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
    public static List<MUSW__Parcel__c> getAllAddress(Id applicationId){
        system.debug('applicationId==='+ applicationId);
        List<MUSW__Parcel__c> ListAddress = new List<MUSW__Parcel__c>();
        if(String.isNotBlank(applicationId)){
            for(MUSW__Parcel__c addressRecords : [Select Id, Address_Type__c, is_Physical_and_Mailing_Address_Same__c, MUSW__Street2__c, 
                                                  MUSW__Unit__c, MUSW__City__c,MUSW__State__c, Canadian_provinces__c, 
                                                  County__c, Country__c, Zip_Postal_Code__c,Application_BG__c
                                                  FROM MUSW__Parcel__c WHERE Application_BG__c=: applicationId]){
                                                      ListAddress.add(addressRecords);
                                                  }  
            system.debug('ListAddress'+ListAddress);
        }
        return ListAddress;
    }
    
    @AuraEnabled
    public static List<MUSW__Parcel__c> getAddress(Id applicationId){
        system.debug('applicationId==='+ applicationId);
        List<MUSW__Parcel__c> ListAddress = new List<MUSW__Parcel__c>();
         List<MUSW__Parcel_Contact2__c> lstContact  = new  List<MUSW__Parcel_Contact2__c>();
        if(String.isNotBlank(applicationId)){
            lstContact   = [SELECT MUSW__Parcel__r.Application_BG__c,MUSW__Parcel__r.Canadian_provinces__c,
                            MUSW__Parcel__r.MUSW__Unit__c,MUSW__Parcel__r.is_Physical_and_Mailing_Address_Same__c,
                            MUSW__Parcel__r.Address_Type__c,MUSW__Parcel__r.Country__c,MUSW__Parcel__r.County__c,
                            Id,MUSW__Parcel__r.MUSW__City__c,MUSW__Parcel__r.MUSW__District__c,
                            MUSW__Parcel__r.Zip_Postal_Code__c,
                            MUSW__Parcel__r.MUSW__State__c,MUSW__Parcel__r.MUSW__Street2__c,
                            MUSW__Parcel__r.MUSW__Street_Number__c,MUSW__Parcel__r.MUSW__Street_Suffix__c,MUSW__Parcel__r.MUSW__Street__c,Name 
                            from MUSW__Parcel_Contact2__c where MUSW__Contact__c  =:applicationId Limit 1];
            if(!lstContact.isEmpty()) {
                for(MUSW__Parcel_Contact2__c lstparcel :lstContact) {
                    MUSW__Parcel__c parcel = new MUSW__Parcel__c();
                    parcel.Address_Type__c = lstparcel.MUSW__Parcel__r.Address_Type__c;
                    parcel.is_Physical_and_Mailing_Address_Same__c = lstparcel.MUSW__Parcel__r.is_Physical_and_Mailing_Address_Same__c;
                    parcel.MUSW__Unit__c = lstparcel.MUSW__Parcel__r.MUSW__Unit__c;
                    parcel.MUSW__City__c = lstparcel.MUSW__Parcel__r.MUSW__City__c;
                    parcel.MUSW__State__c = lstparcel.MUSW__Parcel__r.MUSW__State__c;
                    parcel.MUSW__Street2__c = lstparcel.MUSW__Parcel__r.MUSW__Street2__c;
                    parcel.Canadian_provinces__c = lstparcel.MUSW__Parcel__r.Canadian_provinces__c;
                    parcel.County__c = lstparcel.MUSW__Parcel__r.County__c;
                    parcel.Country__c = lstparcel.MUSW__Parcel__r.Country__c;
                    parcel.Zip_Postal_Code__c =lstparcel.MUSW__Parcel__r.Zip_Postal_Code__c;
                    parcel.Application_BG__c = lstparcel.MUSW__Parcel__r.Application_BG__c;
                    ListAddress.add(parcel);
                }

            }
        }
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
     System.debug('selectCounty::'+selectCounty);
return selectCounty;
       //System.debug('selectCounty::'+selectCounty);
 
}

/*@AuraEnabled
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
    public static List<MUSW__Parcel__c> deleteTableRecord(String recordId, String addrType,String sobjectType,String applicationId){
        System.debug('---recordId---'+recordId);
        Id recId = (Id)recordId;
        List<MUSW__Parcel__c> listAddress = new List<MUSW__Parcel__c>();
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
            listAddress = [select id,Address_Type__c, MUSW__Street2__c, MUSW__City__c,MUSW__State__c, Canadian_provinces__c, County__c, Country__c, Zip_Postal_Code__c,Application_BG__c, is_Physical_and_Mailing_Address_Same__c from MUSW__Parcel__c where Application_BG__c=: applicationId];        
        } else{
            
        }
        return listAddress;
    }
    
    
    @AuraEnabled
    public static List<MUSW__Parcel__c> sameAddUpdate(String recordId, String sobjectType,String applicationId, boolean isSame){
        System.debug('---recordId---'+recordId);
        Id recId = (Id)recordId;
        List<MUSW__Parcel__c> listAddress = new List<MUSW__Parcel__c>();
        //  String sobjectType = recId.getSObjectType().getDescribe().getName();
        String recCondition1 = 'Id =\''+recId+'\'';
        String query = 'SELECT Id, is_Physical_and_Mailing_Address_Same__c, Address_Type__c  FROM ' + sobjectType + ' WHERE ' + recCondition1;
        System.debug('The sameAdd query is:'+query);
        List<Sobject> recList = Database.query(query);
        List<MUSW__Parcel__c> allAddr = new List<MUSW__Parcel__c>();
        if(!recList.isEmpty()){
            if(isSame){
                System.debug('The sameAdd isSame is:'+isSame);
                MUSW__Parcel__c parcel = (MUSW__Parcel__c)recList[0];
                //parcel.Address_Type__c = 'Physical Address';
                parcel.is_Physical_and_Mailing_Address_Same__c = true;
                allAddr = [Select id,name from MUSW__Parcel__c where Application_BG__c =:applicationId];
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
                MUSW__Parcel__c parcel = (MUSW__Parcel__c)recList[0];
                //parcel.Address_Type__c = 'Physical Address';
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
            listAddress = [SELECT id,MUSW__Street2__c,MUSW__Unit__c,MUSW__City__c,MUSW__State__c,Zip_Postal_Code__c, Canadian_provinces__c, 
                           Country__c,Melissa_Address_Verified__c,Address_Type__c,is_Physical_and_Mailing_Address_Same__c from MUSW__Parcel__c 
                           where Application_BG__c=: applicationId];        
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
    public static List<MUSW__Parcel__c> integrationsaveAddress(string selectedAddress,Boolean isAptInfo,String applicationId, Boolean issuggestTrue,String addresstype, String county, String accountOrContactId, String objectRecordName, Boolean isAMR){
        List<MUSW__Parcel__c> parcelList = new List<MUSW__Parcel__c>();
        String addres1;
        String aptInfo = '';
        String city;
        String state;
        String zip;
        String country;
        String countyVal = county;
        system.debug('isAptInfo=='+isAptInfo + 'objectname---' + objectRecordName);
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
                for(MUSW__Parcel__c existingParcel : [SELECT id, MUSW__Street2__c,MUSW__Unit__c,MUSW__City__c,MUSW__State__c,Zip_Postal_Code__c,Country__c,
                                                      Melissa_Address_Verified__c, is_Physical_and_Mailing_Address_Same__c,Address_Type__c, 
                                                      Canadian_provinces__c, County__c, Primary_Account__c, MUSW__Primary_Contact__c from MUSW__Parcel__c 
                                                      where Address_Type__c = :addresstype AND ((MUSW__Primary_Contact__c!=null AND MUSW__Primary_Contact__c = :accountOrContactId) 
                                                      OR (Primary_Account__c!=null AND Primary_Account__c = :accountOrContactId)) Limit 1]){
                                                          System.debug('existingParcel=='+ existingParcel);
                                                          existingParcel.MUSW__Street2__c = addres1;
                                                          existingParcel.MUSW__Unit__c = aptInfo;
                                                          existingParcel.MUSW__City__c = city;
                                                          existingParcel.Country__c = country;
                                                          existingParcel.County__c = countyVal;
                                                          if(String.isNotBlank(objectRecordName)){
                                                              existingParcel.Primary_Account__c = accountOrContactId;
                                                          }else{
                                                              existingParcel.MUSW__Primary_Contact__c = accountOrContactId;
                                                          }
                                                          //existingParcel.Application_BG__c = applicationId;
                                                          if(country!= 'Canada'){
                                                              existingParcel.MUSW__State__c = state; 
                                                              existingParcel.Canadian_provinces__c = null;
                                                          }else {
                                                              existingParcel.Canadian_provinces__c = state;
                                                              existingParcel.MUSW__State__c = null;
                                                          }
                                                          existingParcel.Zip_Postal_Code__c = zip;
                                                          if(isAMR)
                                                          {
                                                              //existingParcel.Request_Parcel__c = applicationId;
                                                          }
                                                          parcelList.add(existingParcel);
                                                      }
                if(!parcelList.isEmpty()){
                    try{
                        upsert parcelList;
                    }
                    catch(DmlException e){
                        System.debug('Error while updating existing Parcel ==' + e.getMessage());
                    }
                    System.debug('updated parcelList'+parcelList);
                }
                else{
                    MUSW__Parcel__c parcel = new MUSW__Parcel__c();
                    parcel.MUSW__Street2__c = addres1;
                    parcel.MUSW__Unit__c = aptInfo;
                    parcel.MUSW__City__c = city;
                    parcel.Country__c = country;
                    parcel.County__c = countyVal;
                    System.debug('country===' + country);
                    if(country!= 'Canada'){
                        parcel.MUSW__State__c = state; 
                        parcel.Canadian_provinces__c = null;
                    }else {
                        parcel.Canadian_provinces__c = state;
                        parcel.MUSW__State__c = null;
                    }
                    parcel.Zip_Postal_Code__c = zip;
                    if(String.isNotBlank(objectRecordName)){
                        parcel.Primary_Account__c = accountOrContactId;
                    }else{
                        parcel.MUSW__Primary_Contact__c = accountOrContactId;
                    }
                    if(issuggestTrue == true){
                        parcel.Melissa_Address_Verified__c = true;
                    }
                    if(addresstype != null && addresstype !='--None--'){
                        parcel.Address_Type__c = addresstype;
                    }
                    system.debug('isAMR--'+isAMR);
                    if(Dol_IntegrationUtil.isNotBlank(applicationId) && !isAMR) {
                        parcel.Application_BG__c = applicationId;
                    }
                    else
                    {
                        //parcel.Request_Parcel__c = applicationId;
                    }
                    System.debug('parcel' + parcel);
                    if(parcel != null ){
                        try{
                           upsert parcel; 
                        }
                        catch(DmlException e){
                            System.debug('Error while inserting new Parcel---' + e.getMessage());
                        }
                        if(Dol_IntegrationUtil.isNotBlank(parcel.id)){
                            List<MUSW__Parcel__c> insertedParcel = [SELECT id,MUSW__Street2__c,MUSW__Unit__c,MUSW__City__c,MUSW__State__c,
                                                                    Zip_Postal_Code__c, Canadian_provinces__c, Country__c,County__c,
                                                                    Melissa_Address_Verified__c,Address_Type__c, Application_BG__c, Primary_Account__c,
                                                                    is_Physical_and_Mailing_Address_Same__c, MUSW__Primary_Contact__c from MUSW__Parcel__c 
                                                                    where id =:parcel.id Limit 1];
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
       
    
    @AuraEnabled
    public static MUSW__Parcel__c AffiliatedLocation(String parcel,boolean removeLocation){
        MUSW__Parcel__c parcl = (MUSW__Parcel__c)JSON.deserialize(parcel,MUSW__Parcel__c.class);
        parcl.recordTypeId= Schema.SObjectType.MUSW__Parcel__c.getRecordTypeInfosByName().get('Affiliated Location').getRecordTypeId(); 
        parcl.Status__c = 'Active';
        System.debug('parcl::'+ parcl );
        System.debug('removeLocation::'+ removeLocation);
        if(parcl != null && !removeLocation ){
            insert parcl ;
        }else if(removeLocation ){
            parcl.Status__c = 'Inactive';
            update parcl ;
        }
        return parcl ;
    }
    
    @AuraEnabled
    public static Boolean removeLocation(Id parcelId){
        Boolean removed = false;
        MUSW__Parcel__c parcl = new MUSW__Parcel__c(id=parcelId); 
        parcl.Status__c = 'Inactive';
        try{
            update parcl ;
            removed = true;
        }catch(Exception e){
            System.debug(e.getMessage());
            removed = false;
        }
        
        return removed;
    }
    
    
     @AuraEnabled
    public static String setRequestLocationTable(String requestId){
        try{
            Id LocationRT = Schema.SObjectType.MUSW__Parcel__c.getRecordTypeInfosByName().get('Affiliated Location').getRecordTypeId(); 
            List<SObject> columnDataList;
            List<String> columnHeaderList ;
            columnDataList = [SELECT id, Designated_Engineer_License__c, Designated_Land_Surveyor_License__c,MUSW__Street2__c,License__c,MUSW__Unit__c,MUSW__City__c, Country__c, County__c,MUSW__State__c,Canadian_provinces__c,Zip_Postal_Code__c, Address_Type__c, Application_BG__c from MUSW__Parcel__c where Request__c=:requestId AND Status__c =:'Active' AND recordtypeid =:LocationRT];                          
            columnHeaderList = new List<String>{'Designated Engineer' , 'Designated Land Surveyor','Country','Address Line 1','State','County','Zip Code','Action'};
            
            LnP_LicenseAddressApexController.lightningDataTableWrapper wrapperObj = new LnP_LicenseAddressApexController.lightningDataTableWrapper(columnHeaderList,columnDataList);
            return JSON.serialize(wrapperObj,true);
            
        }catch(Exception ex){
            return null;
        }
    }
    
    @AuraEnabled 
    public static Boolean removeAffiliationRequest(List<Id> parcelIdList,Id RequestId){
        
        try{
            Request__c req = new Request__c(id = RequestId );
            req.Service_Request_Type__c = 'Remove Affiliations';
            update req;
            
            List<MUSW__Parcel__c> parcelList = new List<MUSW__Parcel__c>();
            for( Id parcelId : parcelIdList){
                MUSW__Parcel__c parcel = new MUSW__Parcel__c(id= parcelId );
                parcel.Request__c = RequestId ;
                parcelList.add(parcel);
            }
            if(!parcelList.isEmpty()){
                update parcelList;
            }
              return true;  
          }catch(Exception e){
                System.debug('e.getMessage()');
                return false;
       }
    }    
    
    @AuraEnabled
    public static String setLocationTable(String applicationId, Boolean isAMR){
        try{
            System.debug('applicationId::'+ applicationId);
            System.debug('isAMR::'+isAMR);  
            
            Id LocationRT = Schema.SObjectType.MUSW__Parcel__c.getRecordTypeInfosByName().get('Affiliated Location').getRecordTypeId(); 
            List<SObject> columnDataList;
            List<String> columnHeaderList ;
            if(isAMR){
                columnDataList = [SELECT id, Designated_Engineer_License__c, Designated_Land_Surveyor_License__c,MUSW__Street2__c,License__c,MUSW__Unit__c,MUSW__City__c, Country__c, County__c,MUSW__State__c,Canadian_provinces__c,Zip_Postal_Code__c, Address_Type__c, Application_BG__c from MUSW__Parcel__c where License__c=: applicationId AND Status__c =:'Active' AND recordtypeid =:LocationRT];                          
                columnHeaderList = new List<String>{'select','Designated Engineer' , 'Designated Land Surveyor','Country','Address Line 1','State','County','Zip Code'};
            }else{
                columnHeaderList = new List<String>{'Designated Engineer' , 'Designated Land Surveyor','Country','Address Line 1','State','County','Zip Code','Action'};
                columnDataList = [SELECT id, Designated_Engineer_License__c, Designated_Land_Surveyor_License__c,MUSW__Street2__c,MUSW__Unit__c,MUSW__City__c, Country__c, County__c,MUSW__State__c,Canadian_provinces__c,Zip_Postal_Code__c, Address_Type__c, Application_BG__c from MUSW__Parcel__c where Application_BG__c=: applicationId AND Status__c =:'Active' AND recordtypeid =:LocationRT];                          
            }
            LnP_LicenseAddressApexController.lightningDataTableWrapper wrapperObj = new LnP_LicenseAddressApexController.lightningDataTableWrapper(columnHeaderList,columnDataList);
            return JSON.serialize(wrapperObj,true);
            
        }catch(Exception ex){
            return null;
        }
    }
    
    
    public class AddrWrapper {
        @auraEnabled    public String country {get;set;}
        @auraEnabled    public String street {get;set;}
        @auraEnabled    public String street2 {get;set;}
        @auraEnabled    public String city {get;set;}
        @auraEnabled    public String state {get;set;}
        @auraEnabled    public String zip {get;set;}
    }
    
     public class lightningDataTableWrapper{
        public List<String> tableHeader;
        public List<Sobject> tableData;
        public String miscellaneousData;
        lightningDataTableWrapper(List<String> tableHeader,List<Sobject> tableData){
            this.tableHeader = tableHeader!=null? tableHeader:new List<String>();
            this.tableData = tableData!=null? tableData : new List<Sobject>();
        }
    }
    
    @auraEnabled
    public static List<MUSW__Parcel__c> updateContactParcel(string selectedAddress,Boolean isAptInfo,String contactId, Boolean issuggestTrue,String addresstype, String county){
        List<MUSW__Parcel__c> parcelList = new List<MUSW__Parcel__c>();
        String addres1;
        String aptInfo = '';
        String city;
        String state;
        String zip;
        String country;
        String countyVal = county;
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
                List<MUSW__Parcel_Contact2__c> lstParcelContact = [SELECT id, MUSW__Parcel__c from MUSW__Parcel_Contact2__c 
                                                                   where MUSW__Contact__c =:contactId AND MUSW__Parcel__r.Address_Type__c = :addresstype Limit 1 ];

                if(!lstParcelContact.isEmpty()) {
                    for(MUSW__Parcel__c existingParcel : [SELECT id, MUSW__Street2__c,MUSW__Unit__c,MUSW__City__c,MUSW__State__c,Zip_Postal_Code__c,Country__c,Melissa_Address_Verified__c,
                                                          is_Physical_and_Mailing_Address_Same__c,Address_Type__c, Canadian_provinces__c, County__c from MUSW__Parcel__c 
                                                          where Id = :lstParcelContact[0].MUSW__Parcel__c
                                                          Limit 1]){
                                                              System.debug('existingParcel=='+ existingParcel);
                                                              existingParcel.MUSW__Street2__c = addres1;
                                                              existingParcel.MUSW__Unit__c = aptInfo;
                                                              existingParcel.MUSW__City__c = city;
                                                              existingParcel.Country__c = country;
                                                              existingParcel.County__c = countyVal;
                                                              if(country!= 'Canada'){
                                                                  existingParcel.MUSW__State__c = state; 
                                                                  existingParcel.Canadian_provinces__c = null;
                                                              }else {
                                                                  existingParcel.Canadian_provinces__c = state;
                                                                  existingParcel.MUSW__State__c = null;
                                                              }
                                                              existingParcel.Zip_Postal_Code__c = zip;
                                                              parcelList.add(existingParcel);
                                                          }
                }
                if(!parcelList.isEmpty()){
                    upsert parcelList;
                    System.debug('updated parcelList'+parcelList);
                }
                else{
                    MUSW__Parcel__c parcel = new MUSW__Parcel__c();
                    parcel.MUSW__Street2__c = addres1;
                    parcel.MUSW__Unit__c = aptInfo;
                    parcel.MUSW__City__c = city;
                    parcel.Country__c = country;
                    parcel.County__c = countyVal;
                    System.debug('country===' + country);
                    if(country!= 'Canada'){
                        parcel.MUSW__State__c = state; 
                        parcel.Canadian_provinces__c = null;
                    }else {
                        parcel.Canadian_provinces__c = state;
                        parcel.MUSW__State__c = null;
                    }
                    parcel.Zip_Postal_Code__c = zip;
                    
                    if(issuggestTrue == true){
                        parcel.Melissa_Address_Verified__c = true;
                    }
                    if(addresstype != null && addresstype !='--None--'){
                        parcel.Address_Type__c = addresstype;
                    }
                    System.debug('parcel' + parcel);
                    if(parcel != null){
                        upsert parcel;
                       
                        if(Dol_IntegrationUtil.isNotBlank(parcel.id)){
                             addContactparcel(contactId,parcel.id);
                            List<MUSW__Parcel__c> insertedParcel = [SELECT id,MUSW__Street2__c,MUSW__Unit__c,MUSW__City__c,MUSW__State__c,
                                                                    Zip_Postal_Code__c, Canadian_provinces__c, Country__c,County__c,
                                                                    Melissa_Address_Verified__c,Address_Type__c, Application_BG__c,
                                                                    is_Physical_and_Mailing_Address_Same__c from MUSW__Parcel__c 
                                                                    where id =:parcel.id Limit 1];
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
    
    Public static void addContactparcel (string contactID, Id parcelId) {
        MUSW__Parcel_Contact2__c  newParcelContact =  new MUSW__Parcel_Contact2__c();
        newParcelContact.MUSW__Contact__c = contactID;
        newParcelContact.MUSW__Parcel__c = parcelId;
        insert newParcelContact;
    }
}