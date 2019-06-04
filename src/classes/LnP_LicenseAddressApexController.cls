public with sharing class LnP_LicenseAddressApexController {
    
    @AuraEnabled
    public static List<LnP_Parcel__c> getAddressLines(LnP_Parcel__c addr, Id applicationId){
        List<LnP_Parcel__c> ListAddress = new List<LnP_Parcel__c>();
        System.debug('--addr--'+addr);
        if(addr != null){
            insert addr;
        }
    
        //system.debug('hey !!');
        ListAddress = [select Id,Address_Type__c, Street__c, City__c,State_Province__c, County__c, Country__c, Zip_Postal_Code__c,Application_BG__c from LnP_Parcel__c where Application_BG__c=: applicationId];        
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
        String stateValue = State;
        String cityValue = City;
        List<LnP_City_County_Map__mdt> cityCountyMap = new List<LnP_City_County_Map__mdt>();
        cityCountyMap = [SELECT MasterLabel, City__c, County__c FROM LnP_City_County_Map__mdt];

        LnP_Parcel__c par = new LnP_Parcel__c();
        if(stateValue != 'Washington'){
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
          listAddress = [select id,Address_Type__c, Street__c, City__c,State_Province__c, County__c, Country__c, Zip_Postal_Code__c,Application_BG__c from LnP_Parcel__c where Application_BG__c=: applicationId];        
        } else{
            
        }
        return listAddress;
    }
    
    public class selectOption{
        
        @AuraEnabled public string label;
        @AuraEnabled public string value;
    }
    
}