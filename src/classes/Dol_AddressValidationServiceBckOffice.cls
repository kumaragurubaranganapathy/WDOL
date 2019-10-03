public class Dol_AddressValidationServiceBckOffice {
    @auraEnabled
    public static Dol_AddressValidationService.AddrWrapper validateAddress(String addrLine1,String addrLine2,String city, String state, String zip){
        try{ 
        String licenseKey;
        Dol_AddressValidationService.AddrWrapper validatedAddress = new Dol_AddressValidationService.AddrWrapper();
        
        Dol_Integration_Settings__mdt customSettings = [SELECT MasterLabel, DeveloperName, Value__c  FROM Dol_Integration_Settings__mdt where DeveloperName =: DOL_AppConstants.NULL_EMPTY_STRING + 'Address_LicenseKey' Limit 1];
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
          response.setBody(Dol_AddrValidationServiceBckOffice_Test.responsebody);
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
        catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
    }
    
    @AuraEnabled
    public static String getObjAPI(String recordId) {
        try{
        if(recordId == null || recordId == '') {
            return null;
        }
        
        Id sRecordId = recordId;
        String objName = sRecordId.getSObjectType().getDescribe().getName();
        system.debug('!!!! createTimeEntry.objName = ' + objName);
        
        return objName;
        }
        catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
    }
     @AuraEnabled 
    public static List<String> getStates(sObject objObject, string fld) {
        try{
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
        catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
    }
    @auraEnabled
    public static String saveAddress(string selectedAddress,Boolean isAptInfo,Boolean isAddrValidated, String countyValue,String parentId){
        String parceLId = DOL_AppConstants.NULL_EMPTY_STRING;
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
            }
            List<MUSW__Parcel__c> updtexistingParcel = new List<MUSW__Parcel__c>();
            List<MUSW__Parcel__c> existingParcel = new List<MUSW__Parcel__c> ();
            String parentSobjName = DOL_AppConstants.NULL_EMPTY_STRING + '';
            if(Dol_IntegrationUtil.isNotBlank(parentId)){
                parentSobjName = getObjAPI(parentId);
                existingParcel = [SELECT id,Account__c,Contact__c,Primary_Account__c ,MUSW__Primary_Contact__c ,MUSW__Unit__c,County__c ,Melissa_Address_Verified__c 
                                  from MUSW__Parcel__c where MUSW__Street2__c =:addres1 AND MUSW__Street2__c != null AND MUSW__City__c=:city AND MUSW__City__c !=null 
                                  AND MUSW__State__c=:state AND MUSW__State__c!= null AND MUSW__Post_Zip_Code__c=:zip AND MUSW__Post_Zip_Code__c != null 
                                  AND Country__c=:country AND Country__c != null AND (Primary_Account__c =:parentId OR MUSW__Primary_Contact__c =:parentId) Limit 1];
            }
            if(Dol_IntegrationUtil.isNotempty(existingParcel)){
                if (Dol_IntegrationUtil.isNotBlank(parentSobjName) && parentSobjName =='Account'){
                    if(Dol_IntegrationUtil.isNotBlank(existingParcel[0].Primary_Account__c) && existingParcel[0].Primary_Account__c == parentId){
                        existingParcel[0].Melissa_Address_Verified__c = isAddrValidated;
                        if(aptInfo!= null){
                            existingParcel[0].MUSW__Unit__c = aptInfo.trim();
                        }if(countyValue != null){
                            existingParcel[0].County__c = countyValue.trim(); 
                        }
                        updtexistingParcel.add(existingParcel[0]);
                    }
                }
                if (Dol_IntegrationUtil.isNotBlank(parentSobjName) && parentSobjName =='Contact'){
                    if(Dol_IntegrationUtil.isNotBlank(existingParcel[0].MUSW__Primary_Contact__c) && existingParcel[0].MUSW__Primary_Contact__c == parentId){
                        existingParcel[0].Melissa_Address_Verified__c = isAddrValidated;
                        if(aptInfo!= null){
                            existingParcel[0].MUSW__Unit__c = aptInfo.trim();
                        }if(countyValue != null){
                            existingParcel[0].County__c = countyValue.trim(); 
                        }
                        updtexistingParcel.add(existingParcel[0]);
                    }
                }
            }else{
                MUSW__Parcel__c parcel = new MUSW__Parcel__c();
                parcel.MUSW__Street2__c = addres1;
                parcel.MUSW__City__c = city;
                parcel.MUSW__State__c = state;
                parcel.MUSW__Post_Zip_Code__c = zip;
                parcel.Country__c = country;
                parcel.Melissa_Address_Verified__c = isAddrValidated;
                if(aptInfo!= null){
                    parcel.MUSW__Unit__c = aptInfo.trim();
                }
                if(countyValue != null){
                    parcel.County__c = countyValue.trim(); 
                }
                if(Dol_IntegrationUtil.isNotBlank(parentId)){
                    if (Dol_IntegrationUtil.isNotBlank(parentSobjName) && parentSobjName =='Account'){
                        parcel.Account__c = parentId;
                        parcel.Primary_Account__c = parentId;
                    }else if(Dol_IntegrationUtil.isNotBlank(parentSobjName) && parentSobjName =='Contact'){
                        parcel.Contact__c  = parentId;
                        parcel.MUSW__Primary_Contact__c = parentId;
                    }
                }
                if(parcel != null){
                    updtexistingParcel.add(parcel);
                } 
            }
            System.debug('updtexistingParcel**' + updtexistingParcel);
            if (Dol_IntegrationUtil.isNotempty(updtexistingParcel)){
                upsert updtexistingParcel;
                parceLId = [select id from MUSW__Parcel__c where id =:updtexistingParcel[0].id AND id != null Limit 1].id;
            }
            }catch(Exception e){
            System.debug('Dol_AddressValidationService - Exception: '+e);
            DOL_CreateErrorLog_Exception.logApplicationError(e);
            throw new AuraHandledException('An error occurred: '+e.getMessage());  
        }
        system.debug('parceLId=='+parceLId);
        return parceLId;
    }
    @AuraEnabled
    public static List<selectOption> getCountyValue(String state, String city){
        try{
        List<selectOption> selectCounty = new List<selectOption>();
        String stateValue = state;
        System.debug('statevalue::'+stateValue);
        String cityValue = city;
        System.debug('cityvalue::'+cityValue);
        List<LnP_City_County_Map__mdt> cityCountyMap = new List<LnP_City_County_Map__mdt>();
        //System.debug('statevalue::'+stateValue);
        cityCountyMap = [SELECT MasterLabel, City__c, County__c FROM LnP_City_County_Map__mdt];
        System.debug('cityCountyMap::'+cityCountyMap);
        
        MUSW__Parcel__c par = new MUSW__Parcel__c();
        if(stateValue != 'Washington' && stateValue != 'WA'){
            selectOption sel = new selectOption();
            sel.label = DOL_AppConstants.OUT_OF_THE_STATE;
            sel.value = DOL_AppConstants.OUT_OF_THE_STATE;
            selectCounty.add(sel);
        }
        else {
            for(LnP_City_County_Map__mdt mapItem : cityCountyMap){
                if(mapItem.City__c == cityValue){
                    selectOption sel = new selectOption();
                    sel.label = mapItem.County__c;
                    sel.value = mapItem.County__c;
                    selectCounty.add(sel);
                }
            }
    }
         System.debug('selectCounty::'+selectCounty);
    return selectCounty;
           //System.debug('selectCounty::'+selectCounty);
        }
        catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
     
    }

    public class selectOption{
        
        @AuraEnabled public string label;
        @AuraEnabled public string value;
    }

}