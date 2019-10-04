@isTest
public class Polaris_RBSAuditSelectionBatch_Test {
    @isTest
    public static void testMethod1(){
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Id conRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        Contact applicnt = DOL_TestDataFactory.createContact(conRecTypeId, a.Id);
        applicnt.Birthdate = Date.newInstance(1990, 2, 17);
        update applicnt;
        Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c lic1 = DOL_TestDataFactory.createLicense(LicRecTypeId1, a.Id, 'Architects', 'Architect', 'General Application');
        lic1.MUSW__Applicant__c = applicnt.Id;
        lic1.Selected_for_Audit__c= False;
        lic1.MUSW__Issue_Date__c = System.today();
        
       lic1.MUSW__Expiration_Date__c = System.today() + 180;
        lic1.Audit_Completed_Flag__c = False;
        lic1.MUSW__Status__c = 'Active';
        lic1.Expired_Date_Updated__c = false;
        update lic1;
        test.startTest();
        Polaris_RBSAuditSelectionBatchClass btc = new Polaris_RBSAuditSelectionBatchClass();
        DataBase.executeBatch(btc);
        test.stopTest();
    }

}