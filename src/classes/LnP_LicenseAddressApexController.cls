public with sharing class LnP_LicenseAddressApexController {
    
    @AuraEnabled
    public static List<LnP_Parcel__c> getAddressLines(LnP_Parcel__c addr, Id applicationId){
        List<LnP_Parcel__c> ListAddress = new List<LnP_Parcel__c>();
        System.debug('--addr--'+addr);
        if(addr != null){
            insert addr;
        }
    
        //system.debug('hey !!');
        ListAddress = [select Id,Address_Type__c, Street__c,Unit__c, City__c,State__c, County__c, Country__c, Zip_Postal_Code__c,Application_BG__c, is_Physical_and_Mailing_Address_Same__c from LnP_Parcel__c where Application_BG__c=: applicationId];        
        system.debug('ListAddress'+ListAddress);
        return ListAddress;
    }
    
    @AuraEnabled
    public static List<LnP_Parcel__c> getAllAddress(Id applicationId){
        system.debug('applicationId'+applicationId);
        List<LnP_Parcel__c> ListAddress = new List<LnP_Parcel__c>();
        ListAddress = [select Id,Address_Type__c,is_Physical_and_Mailing_Address_Same__c, Street__c,Unit__c, City__c,State__c, County__c, Country__c, Zip_Postal_Code__c,Application_BG__c from LnP_Parcel__c where Application_BG__c=: applicationId];        
        system.debug('ListAddress'+ListAddress);
        return ListAddress;
    }
    
    @AuraEnabled    
    public static List<String> getAddressDetailsType(){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = LnP_Parcel__c.Address_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add('--None--');
        for (Schema.PicklistEntry f: ple) {
            options.add(f.getLabel());
            options.sort();
        }
        return options;
    }
    
    @AuraEnabled
    public static List<selectOption> getCountyValue(String state, String city){
        List<selectOption> selectCounty = new List<selectOption>();
        String stateValue = state;
        //System.debug('statevalue::'+stateValue);
        String cityValue = city;
        List<LnP_City_County_Map__mdt> cityCountyMap = new List<LnP_City_County_Map__mdt>();
        cityCountyMap = [SELECT MasterLabel, City__c, County__c FROM LnP_City_County_Map__mdt];

        LnP_Parcel__c par = new LnP_Parcel__c();
        if(stateValue != 'Washington' && stateValue != 'WA'){
            selectOption sel = new selectOption();
            sel.label = 'Out Of State';
            sel.value = 'Out Of State';
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
        return selectCounty;
    }
    
    /*
    @AuraEnabled
    public static List<String> objectFields(String selectedObject){
        List<String> fields = new List<String>();
        Map<String , Schema.SObjectType> globalDescription = Schema.getGlobalDescribe();
        Schema.sObjectType objType = globalDescription.get(selectedObject); 
        Schema.DescribeSObjectResult r1 = objType.getDescribe(); 
        
        Map<String , Schema.SObjectField> mapFieldList = r1.fields.getMap();  

        for(Schema.SObjectField field : mapFieldList.values())  {  
            Schema.DescribeFieldResult fieldResult = field.getDescribe();  
            
            if(fieldResult.isAccessible())  {  
                fields.add(fieldResult.getName());
            }  
        }
        List<String> so = new List<String>();
        for(String fs : fields){
            so.add(fs);
            so.sort();
        } 
        System.debug('so---->>' + so);
        return so;
    }
    
    @AuraEnabled
    public Static LnP_Parcel__c editAddress(String recordId){
        System.debug('---recordId---'+recordId);
        List<LnP_Parcel__c> addList = [SELECT Id, Name, Address_Type__c, Street__c, City__c,State_Province__c, Country__c, Zip_Postal_Code__c
                                       FROM LnP_Parcel__c WHERE Id =: recordId];
        if(!addList.isEmpty())
            return addList[0];
        else
            return null;
    }
    
    @AuraEnabled
    public Static void deleteAddress(String recordId){
        System.debug('---recordId---'+recordId);
        List<LnP_Parcel__c> addList = [SELECT Id, Name, Address_Type__c, Street__c, City__c,State_Province__c, Country__c, Zip_Postal_Code__c
                                       FROM LnP_Parcel__c WHERE Id =: recordId];
        if(!addList.isEmpty()){
            try{
                delete addList[0];
            }
            Catch(Exception e){
                System.debug('---EXCEPTION---'+e.getMessage());
            }
        }
    }
    */ /*
    @AuraEnabled
    public static List<LnP_Parcel__c> saveLicenseAddress(String addressType, String street, String city, String state, String country, String zip){
        List<LnP_Parcel__c> ListAddress = new List<LnP_Parcel__c>();
        LnP_Parcel__c panelAddress  = new LnP_Parcel__c();
        panelAddress.Address_Type__c = addressType;
        panelAddress.Street__c = street;
        panelAddress.City__c = city;
        panelAddress.State_Province__c = state;
        panelAddress.Country__c = country;
        panelAddress.Zip_Postal_Code__c = zip;
        Insert panelAddress;
        
        ListAddress = [select id,Address_Type__c, Street__c, City__c,State_Province__c, Country__c, Zip_Postal_Code__c from LnP_Parcel__c LIMIT 5];
        system.debug('ListAddress'+ListAddress);
        return ListAddress;
        
    }
    */
    @AuraEnabled
    public static SOD_Autocomplete_Wrapper getAutoComplete(string strPrefix) {
        system.debug('strPrefix3'+strPrefix);
        strPrefix = EncodingUtil.urlEncode(strPrefix, 'UTF-8');
        
        SOD_Address_Auth__c objCS = SOD_Address_Auth__c.getInstance('Auto_Complete_Address');
        system.debug('objCS'+objCS);
        String url = objCS.url__c
            + 'auth-id=' +objCS.AuthID__c
            + '&auth-token=' +objCS.AuthToken__c
            + '&prefix=' + strPrefix;
        
        system.debug('URL = '+url);
        try{
           SOD_Autocomplete_Wrapper response = SOD_Autocomplete_Wrapper.parse(makeAPICall(url));
           return response; 
        }
        catch(Exception e){
            HandleException.LogException(e,'LnP_PublicFormsApexController','getAutoComplete');
            return null;
        }

 
    }
    private static string makeAPICall(string url) {

            Http http = new Http();
            HttpRequest httpRequest = new HttpRequest();
            HttpResponse httpResponse = new HttpResponse();
            httpRequest.setMethod('GET');
            httpRequest.setEndpoint(url);
            httpRequest.setTimeout(120000);
            httpResponse = http.send(httpRequest); 
            system.debug('httpResponse = '+httpResponse);
            
            if (httpResponse.getStatusCode() == 200){
                system.debug(httpResponse.getBody());
                return httpResponse.getBody();    
            } else {
                System.debug(httpResponse.getStatusCode());
                System.debug(httpResponse.getBody());
                throw new AuraHandledException(httpResponse.getBody());
            }
    }
    @AuraEnabled
    public static List<LnP_Parcel__c> deleteTableRecord(String recordId, String addrType,String sobjectType,String applicationId){
        System.debug('---recordId---'+recordId);
        Id recId = (Id)recordId;
        List<LnP_Parcel__c> listAddress = new List<LnP_Parcel__c>();
      //  String sobjectType = recId.getSObjectType().getDescribe().getName();
        String recCondition1 = 'Id =\''+recId+'\'';
        String recCondition2 =  'Address_Type__c =\''+addrType+'\'';
        String query = 'SELECT Id FROM ' + sobjectType + ' WHERE ' + recCondition1+' AND '+recCondition2;
        List<Sobject> recList = Database.query(query);
        if(!recList.isEmpty()){
            try{
                delete recList[0];
            }
            Catch(Exception e){
                System.debug('---EXCEPTION---'+e.getMessage());
            }
          listAddress = [select id,Address_Type__c, Street__c, City__c,State_Province__c, County__c, Country__c, Zip_Postal_Code__c,Application_BG__c, is_Physical_and_Mailing_Address_Same__c from LnP_Parcel__c where Application_BG__c=: applicationId];        
        } else{
            
        }
        return listAddress;
    }
    
    
    @AuraEnabled
    public static List<LnP_Parcel__c> sameAddUpdate(String recordId, String sobjectType,String applicationId, boolean isSame){
        System.debug('---recordId---'+recordId);
        Id recId = (Id)recordId;
        List<LnP_Parcel__c> listAddress = new List<LnP_Parcel__c>();
      //  String sobjectType = recId.getSObjectType().getDescribe().getName();
        String recCondition1 = 'Id =\''+recId+'\'';
        String query = 'SELECT Id, is_Physical_and_Mailing_Address_Same__c, Address_Type__c  FROM ' + sobjectType + ' WHERE ' + recCondition1;
        System.debug('The sameAdd query is:'+query);
        List<Sobject> recList = Database.query(query);
        List<LnP_Parcel__c> allAddr = new List<LnP_Parcel__c>();
        if(!recList.isEmpty()){
            if(isSame){
                System.debug('The sameAdd isSame is:'+isSame);
                LnP_Parcel__c parcel = (LnP_Parcel__c)recList[0];
                parcel.Address_Type__c = 'Physical Address';
                parcel.is_Physical_and_Mailing_Address_Same__c = true;
                // code to delete if any other mailling address is present for the application
                allAddr = [Select id,name from LnP_Parcel__c where Application_BG__c =:applicationId];
                system.debug('allAddr'+allAddr);
                for(Integer i = 0; i < allAddr.size(); i++){
                   if(allAddr.get(i).id == parcel.id){
                        system.debug('allAddr=='+allAddr.get(i).id + 'parcel.id=='+parcel.id);
                        allAddr.remove(i);
                   }
                }
                 system.debug('allAddr'+allAddr);
            }else{
                System.debug('The sameAdd isSame is:'+isSame);
                LnP_Parcel__c parcel = (LnP_Parcel__c)recList[0];
                parcel.Address_Type__c = 'Physical Address';
                parcel.is_Physical_and_Mailing_Address_Same__c = false;
            }

            try{
                update recList[0];
                if(Dol_IntegrationUtil.isNotEmpty(allAddr)){
                    try{
                        delete allAddr;
                    }Catch(Exception e){
                    System.debug('---EXCEPTION---'+e.getMessage());
                }     
              }
            }
            Catch(Exception e){
                System.debug('---EXCEPTION---'+e.getMessage());
            }
          listAddress = [select id,Address_Type__c,is_Physical_and_Mailing_Address_Same__c, Street__c, City__c,State_Province__c, County__c, Country__c, Zip_Postal_Code__c,Application_BG__c from LnP_Parcel__c where Application_BG__c=: applicationId];        
        } else{
            System.debug('The sameAdd recList empty is:');
        }
        System.debug('The sameAdd listAddress is:'+listAddress);
        return listAddress;
    }
    
    public class selectOption{
        
        @AuraEnabled public string label;
        @AuraEnabled public string value;
    }
    
    @auraEnabled
    public static Dol_AddressValidationService.AddrWrapper validateAddress(String addrLine1,String addrLine2,String city, String state, String zip){
        String licenseKey;
        Dol_AddressValidationService.AddrWrapper validatedAddress = new Dol_AddressValidationService.AddrWrapper();
        
        Dol_Integration_Settings__mdt customSettings = [SELECT MasterLabel, DeveloperName, Value__c  FROM Dol_Integration_Settings__mdt where DeveloperName ='Address_LicenseKey' Limit 1];
        if(customSettings != null){
            licenseKey = customSettings.Value__c.trim();
        }
        String requestbody = '<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:urn=\"urn:MelissaDataAddressCheckService\" xmlns:urn1=\"urn:mdWebServiceAddress\">'
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
        return validatedAddress;
    }

     @AuraEnabled 
    public static List<SelectOption> getStates(sObject objObject, string fld) {
        system.debug('objObject:' + objObject);
        system.debug('fld:' + fld);
        //List<String> allOpts = new list <String> ();
        List<SelectOption> allOpts = new List<SelectOption>();
        // Get the object type of the SObject.
        Schema.sObjectType objType = objObject.getSObjectType();
        
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        
        // Get a map of fields for the SObject
        Map<String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        List<Schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a: values) {
            SelectOption sel = new SelectOption();
            sel.Label = a.getLabel();
            sel.Value = a.getValue();
            allOpts.add(sel);
        }
        system.debug('allOpts ---->' + allOpts);
        return allOpts;
    }  
    @auraEnabled
    public static List<LnP_Parcel__c> integrationsaveAddress(string selectedAddress,Boolean isAptInfo,String applicationId, Boolean issuggestTrue,String addresstype,String licenseId){
        List<LnP_Parcel__c> parcelList = new List<LnP_Parcel__c>();
        String addres1;
        String aptInfo = '';
        String city;
        String state;
        String zip;
        String country;
        system.debug('isAptInfo=='+isAptInfo);
        system.debug('selectedAddress=='+selectedAddress);
        
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
                List<LnP_Parcel__c > existingParcel = [SELECT id,Street__c,Unit__c,City__c,State__c,Zip_Postal_Code__c,Country__c,Melissa_Address_Verified__c,is_Physical_and_Mailing_Address_Same__c,Address_Type__c  from LnP_Parcel__c where Street__c  =:addres1 AND City__c =:city AND State__c =:state AND Zip_Postal_Code__c =:zip AND Country__c =:country Limit 1];
                System.debug('existingParcel'+existingParcel);
                if(Dol_IntegrationUtil.isNotempty(existingParcel)){
                    if(Dol_IntegrationUtil.isNotBlank(applicationId)){
                        existingParcel[0].Application_BG__c = applicationId;
                        if(issuggestTrue == true){
                            existingParcel[0].Melissa_Address_Verified__c = true;
                        }
                        if(addresstype != null && addresstype !='--None--'){
                            existingParcel[0].Address_Type__c = addresstype;
                        }
                        /*if(existingParcel[0].is_Physical_and_Mailing_Address_Same__c == true){
                            existingParcel[0].Address_Type__c = 'Physical Address';
                        }else if(addresstype != null){
                             existingParcel[0].Address_Type__c = addresstype;
                        }*/
                        upsert existingParcel[0];
                    }
                    parcelList.add(existingParcel[0]);
                    System.debug('parcelList'+parcelList);
                }
                else{
                    LnP_Parcel__c parcel = new LnP_Parcel__c();
                    parcel.Street__c = addres1;
                    parcel.Unit__c = aptInfo;
                    parcel.City__c = city;
                    parcel.State__c = state;
                    parcel.Zip_Postal_Code__c = zip;
                    parcel.Country__c = country;
                    if(issuggestTrue == true){
                       parcel.Melissa_Address_Verified__c = true;
                      }
                    if(addresstype != null && addresstype !='--None--'){
                        parcel.Address_Type__c = addresstype;
                    }
                    if(Dol_IntegrationUtil.isNotBlank(applicationId)) {
                        parcel.Application_BG__c = applicationId;
                    }
                    if(Dol_IntegrationUtil.isNotBlank(licenseId))
                    {
                        parcel.License__c = licenseId;
                    }
                    System.debug('parcel' + parcel);
                    if(parcel != null){
                        upsert parcel;
                        if(Dol_IntegrationUtil.isNotBlank(parcel.id)){
                            List<LnP_Parcel__c > insertedParcel = [SELECT id,Street__c,Unit__c,City__c,State__c,Zip_Postal_Code__c,Country__c,Melissa_Address_Verified__c,Address_Type__c, is_Physical_and_Mailing_Address_Same__c  from LnP_Parcel__c where id=:parcel.id Limit 1];
                            System.debug('insertedParcel'+insertedParcel);
                            if(Dol_IntegrationUtil.isNotempty(insertedParcel)){ 
                                parcelList.add(insertedParcel[0]);
                            }    
                        }
                    } 
                  }
                }
            }catch(Exception e){
            System.debug('Dol_AddressValidationService - Exception: '+e);
            DebugErrorLoggger.LogError(e, '', '','Dol_AddressValidationService','saveAddress','saveAddress Method failed');  
        }
        system.debug('parcelList=='+parcelList);
        return parcelList;
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