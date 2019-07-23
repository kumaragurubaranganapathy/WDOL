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
}