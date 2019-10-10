@isTest
private class CEAudit_RequestTest {
   @isTest
    static void requestDataFetch(){
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('User_Account').getRecordTypeId();
        Account acc = DOL_TestDataFactory.createAccount(accRecordTypeId);
        Id licRecordTypeId = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByDeveloperName().get('Universal_Default_License_Record_Type').getRecordTypeId();
        MUSW__License2__c lic = DOL_TestDataFactory.createLicense(licRecordTypeId, acc.Id, 'Architects', 'Architect', 'General Application');
        
        Request__c request = DOL_TestDataFactory.createRequest(lic.Id,'Architects','Architect');

        Test.startTest();
        String requestRecordFetched = (CEAudit_Request.getLicenseRecordData(request.Id)!=null) ? ('The request record is '+CEAudit_Request.getLicenseRecordData(request.Id)) : ('The request record fetched is null');
        CEAudit_Request.getLicenseRecordData(lic.Id);
        Test.stopTest();
        System.debug('Final Request fetched::'+requestRecordFetched);
    }
}