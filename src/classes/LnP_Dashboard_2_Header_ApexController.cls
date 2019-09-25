public class LnP_Dashboard_2_Header_ApexController {
    @AuraEnabled
    public static Contact getContact(){
        try{
        Contact conObj;
        List<Contact> ConList =  [SELECT Other_Email__c,Email,OtherStreet, OtherCity, OtherState, OtherPostalCode, OtherCountry, OtherLatitude, OtherLongitude, Name, FirstName, LastName, Id, MiddleName, MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry, MailingLatitude, MailingLongitude, MailingGeocodeAccuracy, Phone, MobilePhone, HomePhone, OtherPhone, Title  
                                  FROM Contact 
                                  Where Id In (Select ContactId
                                               From User
                                               Where Id = :UserInfo.getUserId())];
        if(!ConList.isEmpty()){
            conObj = ConList[0];
        }
        return conObj;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            return null;
        }
    }
    
    @AuraEnabled 
    public static MUSW__Parcel__c getAddressDetails  () {
        /*MUSW__Parcel_Contact2__c conParcel ;
List<MUSW__Parcel_Contact2__c> lstContact  = new  List<MUSW__Parcel_Contact2__c>();
lstContact = [ SELECT MUSW__Parcel__r.Address_Type__c,MUSW__Parcel__r.Country__c,MUSW__Parcel__r.County__c,Id,MUSW__Parcel__r.MUSW__City__c,MUSW__Parcel__r.MUSW__District__c,MUSW__Parcel__r.Zip_Postal_Code__c,
MUSW__Parcel__r.MUSW__State__c,MUSW__Parcel__r.MUSW__Street2__c,MUSW__Parcel__r.MUSW__Street_Number__c,MUSW__Parcel__r.MUSW__Street_Suffix__c,MUSW__Parcel__r.MUSW__Street__c,Name 
from MUSW__Parcel_Contact2__c where MUSW__Parcel__r.Address_Type__c IN ('HOME','MAILING ADDRESS') AND MUSW__Parcel__r.Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Active'
AND MUSW__Contact__c  in (Select ContactId From User Where Id = :UserInfo.getUserId()) Limit 1 ];
if(!lstContact.isEmpty()){
conParcel = lstContact[0];
}*/
        try{
            String sAddressType = DOL_AppConstants.NULL_EMPTY_STRING + 'MAILING ADDRESS';
        MUSW__Parcel__c mailingAddressData = new MUSW__Parcel__c();
        for(MUSW__Parcel__c mailingAddressRecord : [Select Id, Address_Type__c, is_Physical_and_Mailing_Address_Same__c, MUSW__Street2__c, 
                                                    MUSW__Unit__c, MUSW__City__c,MUSW__State__c, Canadian_provinces__c, 
                                                    County__c, Country__c, MUSW__Post_Zip_Code__c,Application_BG__c, MUSW__Primary_Contact__c
                                                    FROM MUSW__Parcel__c WHERE Address_Type__c = :sAddressType AND
                                                    MUSW__Primary_Contact__c IN (Select ContactId From User Where Id = :UserInfo.getUserId()) Limit 1]){
                                                        mailingAddressData = mailingAddressRecord;
                                                    } 
        
        system.debug('mailingAddressData'+mailingAddressData);
        return mailingAddressData;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            return null;
        }
    }
    
    @AuraEnabled 
    public static String insertRequest(String ServiceRequestType){
        try{
        List<User> userInfoData = new  List<User>();
        String queryCondition = DOL_AppConstants.NULL_EMPTY_STRING + ' Id=\''+UserInfo.getUserId()+'\'';
        System.debug('User Id ' + queryCondition);
        String queryStr = DOL_AppConstants.NULL_EMPTY_STRING + 'SELECT Username, ContactId, Contact.Name, Contact.AccountId, Contact.Account.Name FROM User WHERE  '+queryCondition + 'Limit 1';
        system.debug('queryStr '+queryStr);
        
        userInfoData = Utilityclass_withsharing.queryRecords(queryStr);
        Id getContactId = DOL_AppConstants.NULL_EMPTY_STRING + '003r000000EOhBB';
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
        
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            
        }
        string appId = DOL_AppConstants.NULL_EMPTY_STRING + '';
        return appId = application.Id;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            return null;
        }
    }
    
    @AuraEnabled
    public static Boolean checkActiveCart(){
        try{
        Boolean redirect = false;
        List<User> userInfoData = new  List<User>();
        String queryCondition = DOL_AppConstants.NULL_EMPTY_STRING + ' Id=\''+UserInfo.getUserId()+'\'';
        System.debug('User Id ' + queryCondition);
        String queryStr = DOL_AppConstants.NULL_EMPTY_STRING + 'SELECT Username, ContactId, Contact.Name, Contact.AccountId, Contact.Account.Name FROM User WHERE  '+queryCondition + 'Limit 1';
        system.debug('queryStr '+queryStr);
        
        userInfoData = Utilityclass_withsharing.queryRecords(queryStr);
        
        List<BGBK__Cart__c> crtList = [select id from BGBK__Cart__c where BGBK__Contact__c =:userInfoData[0].ContactId and BGBK__Status__c =: DOL_AppConstants.NULL_EMPTY_STRING + 'Open' and BGBK__Total_Amount__c > 0 ];
        if(crtList.size() > 0){
            redirect = true;
        }
        return redirect;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            return null;
        }
    }
}