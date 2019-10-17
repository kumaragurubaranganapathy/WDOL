@isTest
public class DOL_AbondonedPendingActionsTest {
 @isTest
    public static void testmethod1(){
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account accountRecord = DOL_TestDataFactory.createAccount(AccRecTypeId);
        
        //license record data
        Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c licenseRecord = DOL_TestDataFactory.createLicense(LicRecTypeId1, accountRecord.Id, 'Architects', 'Architect', 'General Application');
        licenseRecord.MUSW__Status__c = 'Pending action';
        update licenseRecord;
        
        Test.startTest();
        DOL_AbondonedPendingActions sh1 = new DOL_AbondonedPendingActions();
        String sch = '0 0 16 * * ?'; 
        system.schedule('Test Abandoned License', sch, sh1); 
        Test.stopTest();
    }
}