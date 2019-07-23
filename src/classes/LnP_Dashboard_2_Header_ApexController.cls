public class LnP_Dashboard_2_Header_ApexController {
	@AuraEnabled
    public static Contact getContact(){
        Contact conObj;
        List<Contact> ConList =  [SELECT OtherGeocodeAccuracy, Other_Email__c,Email,OtherStreet, OtherCity, OtherState, OtherPostalCode, OtherCountry, OtherLatitude, OtherLongitude, Name, FirstName, LastName, Id, MiddleName, MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry, MailingLatitude, MailingLongitude, MailingGeocodeAccuracy, Phone, MobilePhone, HomePhone, OtherPhone, Title FROM Contact Where Id In (Select ContactId
                                                                             From User
                                                                             Where Id = :UserInfo.getUserId())];
        if(!ConList.isEmpty()){
            conObj = ConList[0];
        }
        return conObj;
    }
	
	@AuraEnabled 
    public static String insertRequest(String ServiceRequestType){
        List<User> userInfoData = new  List<User>();
        String queryCondition = ' Id=\''+UserInfo.getUserId()+'\'';
        System.debug('User Id ' + queryCondition);
        String queryStr = 'SELECT Username, ContactId, Contact.Name, Contact.AccountId, Contact.Account.Name FROM User WHERE  '+queryCondition + 'Limit 1';
        system.debug('queryStr '+queryStr);
        
        userInfoData = Utilityclass_withsharing.queryRecords(queryStr);
        Id getContactId = '003r000000EOhBB';
        if(userInfoData[0].ContactId != null){
            getContactId = userInfoData[0].ContactId;
        }
       // system.debug('licenseType'+licenseType+'board');
        Request__c application = new Request__c();
        application.Profession__c = ServiceRequestType; 
        application.License_Type__c = ServiceRequestType;        
        application.Stage__c = 0;
        application.Service_Request_Type__c = ServiceRequestType;
        application.Contact__c = getContactId;
        
        try
        {          
            insert application;
        }
        catch(Exception e){
            HandleException.LogException(e,'LnP_Dashboard_2_Header_ApexController','insertRequest');            
        }
        string appId = '';
        return appId = application.Id;
    }
}