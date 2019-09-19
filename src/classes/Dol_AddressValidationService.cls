public class Dol_AddressValidationService {
    @auraEnabled
    public static Dol_AddressValidationService.AddrWrapper validateAddress(String addrLine1,String addrLine2,String city, String state, String zip){
        String licenseKey;
        Dol_AddressValidationService.AddrWrapper validatedAddress = new Dol_AddressValidationService.AddrWrapper();
        
        Dol_Integration_Settings__mdt customSettings = [SELECT MasterLabel, DeveloperName, Value__c  FROM Dol_Integration_Settings__mdt where DeveloperName = DOL_AppConstants.NULL_EMPTY_STRING + 'Address_LicenseKey' Limit 1];
        if(customSettings != null){
            licenseKey = customSettings.Value__c.trim();
        }
        String requestbody = DOL_AppConstants.NULL_EMPTY_STRING + '<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:urn=\"urn:MelissaDataAddressCheckService\" xmlns:urn1=\"urn:mdWebServiceAddress\">'
        +'<soapenv:Header/>'
        +'<soapenv:Body>'
        +'<urn:doAddressCheck>'
            +'<urn:Request>'
            +'<urn1:CustomerID>'+licenseKey+'</urn1:CustomerID>'
                +'<urn1:Record>'
                +'<urn1:AddressLine1>'+addrLine1+'</urn1:AddressLine1>'
                +'<urn1:AddressLine2>'+addrLine2+'</urn1:AddressLine2>'
                +'<urn1:City>'+city+'</urn1:City>'
                +'<urn1:State>'+state+'</urn1:State>'
                +'<urn1:Zip>'+zip+'</urn1:Zip>'
                +'</urn1:Record>'
            +'</urn:Request>'
        +'</urn:doAddressCheck>'
        +'</soapenv:Body>'
        +'</soapenv:Envelope>';
        mdwebserviceaddress.ResponseArray res = new mdwebserviceaddress.ResponseArray();
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setHeader('Content-Type', 'text/xml;charset=UTF-8');
        request.setHeader('SOAPAction', 'urn:MelissaDataAddressCheckService/IService/doAddressCheck');
        request.setEndpoint('https://addresscheck.melissadata.net/v2/SOAP/Service.svc');
        request.setMethod('POST');
        request.setBody(requestbody);
        HttpResponse response = new HttpResponse();
        //response = new Http().send(request); 
        if(!Test.isRunningTest()){
           response = new Http().send(request); 
        }
        else {
          response.setBody(Dol_AddressValidationService_Test.responsebody);
        }
        Dom.Document xml = response.getBodyDocument();
        Dom.XMLNode envelope = xml.getRootElement();
        Dom.XMLNode address = envelope.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/').getChildElement('doAddressCheckResponse','urn:MelissaDataAddressCheckService').getChildElement('doAddressCheckResult','urn:MelissaDataAddressCheckService').getChildElement('Record','urn:mdWebServiceAddress').getChildElement('Address', 'urn:mdWebServiceAddress');
        validatedAddress.street = address.getChildElement('Address1', 'urn:mdWebServiceAddress').getText();
        validatedAddress.street2 = address.getChildElement('Suite', 'urn:mdWebServiceAddress').getText();
        System.debug('suite2'+validatedAddress.street2);
        if(Dol_IntegrationUtil.isBlank(validatedAddress.street2)){
            validatedAddress.street2 = null;
        }
        validatedAddress.city = address.getChildElement('City', 'urn:mdWebServiceAddress').getChildElement('Name', 'urn:mdWebServiceAddress').getText();
        validatedAddress.state = address.getChildElement('State', 'urn:mdWebServiceAddress').getChildElement('Abbreviation', 'urn:mdWebServiceAddress').getText();
        String zipRange ;
        if(address.getChildElement('Zip', 'urn:mdWebServiceAddress').getText() != null){
          zipRange = address.getChildElement('Zip', 'urn:mdWebServiceAddress').getText();
            System.debug('zip**'+address.getChildElement('Plus4', 'urn:mdWebServiceAddress').getText());
            string plus4 = address.getChildElement('Plus4', 'urn:mdWebServiceAddress').getText();
                
            if(plus4 != null && plus4 != '' && plus4 !=' ' && plus4 != 'undefined'){
               zipRange += '-'+address.getChildElement('Plus4', 'urn:mdWebServiceAddress').getText();
            }
        }
        validatedAddress.zip = zipRange;
        System.debug('zipRange'+zipRange);
        validatedAddress.country = address.getChildElement('Country', 'urn:mdWebServiceAddress').getChildElement('Name', 'urn:mdWebServiceAddress').getText() == 'United States of America' ? 'United States' : '';
        System.debug('validatedAddress'+validatedAddress);
        return validatedAddress;
    }
    @AuraEnabled
    public static Dol_AddressValidationService.AddrWrapper validateInputAddress(String addrLine1,String addrLine2,String city, String state, String zip){
        return validateAddress(addrLine1,addrLine2,city,state,zip);
    }

     @AuraEnabled
    public static String getObjAPI(String recordId) {
        if(recordId == null || recordId == '') {
            return null;
        }
        
        Id sRecordId = recordId;
        String objName = sRecordId.getSObjectType().getDescribe().getName();
        system.debug('!!!! createTimeEntry.objName = ' + objName);
        
        return objName;
    }
     @AuraEnabled 
    public static List<String> getStates(sObject objObject, string fld) {
      system.debug('objObject:' + objObject);
      system.debug('fld:' + fld);
      List<String> allOpts = new list <String> ();
      // Get the object type of the SObject.
      Schema.sObjectType objType = objObject.getSObjectType();
     
      // Describe the SObject using its object type.
      Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
     
      // Get a map of fields for the SObject
      Map<String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
      List<Schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPickListValues();
      for (Schema.PicklistEntry a: values) {
       allOpts.add(a.getValue());
      }
      system.debug('allOpts ---->' + allOpts);
      return allOpts;
    }
    @auraEnabled
    public static Boolean saveAddress(string selectedAddress,Boolean isAptInfo, String parentId,String applicationId){
        Boolean success = false;
        String addres1;
        String aptInfo = DOL_AppConstants.NULL_EMPTY_STRING;
        String city;
        String state;
        String zip;
        String country;
        
        
        try{
            if(Dol_IntegrationUtil.isNotBlank(selectedAddress)){
                selectedAddress= selectedAddress.replaceAll('\\<.*?\\>', '');
                system.debug('selectedAddress='+selectedAddress);
                List<String> Addresslist = selectedAddress.split(',');
                if(Dol_IntegrationUtil.isNotempty(Addresslist)){
                    addres1 = Addresslist[0] != null ? Addresslist[0].trim() : '';
                    //if address line 2 is null
                    if(!isAptInfo){
                        city = Addresslist[1] != null ? Addresslist[1].trim() : '';
                        state = Addresslist[2] != null ? Addresslist[2].trim() : '';
                        zip = Addresslist[3] != null ? Addresslist[3].trim() : '';
                        country = Addresslist[4] != null ? Addresslist[4].trim() : '';
                    }
                     //if address line 2 is NOT null
                    else if(isAptInfo){
                        aptInfo = Addresslist[1] != null ? Addresslist[1].trim() : '';
                        city = Addresslist[2] != null ? Addresslist[2].trim() : '';
                        state = Addresslist[3] != null ? Addresslist[3].trim() : '';
                        zip = Addresslist[4] != null ? Addresslist[4].trim() : '';
                        country = Addresslist[5] != null ? Addresslist[5].trim() : '';
                    }
                }
                List<LnP_Parcel__c > existingParcel = [SELECT id,Unit__c  from LnP_Parcel__c where Street__c  =:addres1 AND City__c =:city AND State_Province__c =:state AND Zip_Postal_Code__c =:zip AND Country__c =:country Limit 1];
                if(Dol_IntegrationUtil.isNotempty(existingParcel)){
                    if(Dol_IntegrationUtil.isNotBlank(applicationId)) {    
                        MUSW__Application2__c app = new  MUSW__Application2__c (id=applicationId);
                        app.LnP_Parcel__c =  existingParcel[0].id;
                        upsert existingParcel[0];
                    }
                    success = true;
                }
                else{
                    LnP_Parcel__c parcel = new LnP_Parcel__c();
                    parcel.Street__c = addres1;
                    parcel.Unit__c = aptInfo;
                    parcel.City__c = city;
                    parcel.State_Province__c = state;
                    parcel.Zip_Postal_Code__c = zip;
                    parcel.Country__c = country;
                    /*if(Dol_IntegrationUtil.isNotBlank(parentId)){
                        String sObjectName = getObjAPI(parentId) ;
                        system.debug('sObjectName'+sObjectName);
                        if(sObjectName == 'Contact'){
                            system.debug('sObjectNameconatct');
                            
                            parcel.MUSW__Primary_Contact__c = parentId;
                        }
                    }   */
                    System.debug('parcel' + parcel);
                    if(parcel != null){
                        upsert parcel;
                        if(Dol_IntegrationUtil.isNotBlank(parcel.id)){
                            if(Dol_IntegrationUtil.isNotBlank(applicationId)) {    
                                MUSW__Application2__c app = new  MUSW__Application2__c (id=applicationId);
                                app.LnP_Parcel__c  =  parcel.id;
                                upsert app;
                            }
                            success = true;
                        }
                    } 
                  }
                }
            }catch(Exception e){
            System.debug('Dol_AddressValidationService - Exception: '+e);
            DebugErrorLoggger.LogError(e, '', '','Dol_AddressValidationService','saveAddress','saveAddress Method failed');  
        }
        system.debug('success=='+success);
        return success;
    }
    public class AddrWrapper {
        @auraEnabled    public String country {get;set;}
        @auraEnabled    public String street {get;set;}
        @auraEnabled    public String street2 {get;set;}
        @auraEnabled    public String city {get;set;}
        @auraEnabled    public String state {get;set;}
        @auraEnabled    public String zip {get;set;}
    }

}