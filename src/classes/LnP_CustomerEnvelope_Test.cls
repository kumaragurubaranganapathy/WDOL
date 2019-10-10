@isTest
public class LnP_CustomerEnvelope_Test {
    public static testmethod void LnP_CustomerEnvelopeConstructor(){
        Customer_Envelope__c cEnve = TestUtility.getCEnvelope();
        insert cEnve;
        
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('User_Account').getRecordTypeId();
        Account acc=DOL_TestDataFactory.createAccount(accRecordTypeId);
        
        Id contactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Contact').getRecordTypeId();
        Contact con=DOL_TestDataFactory.createContact(contactRecordTypeId, acc.Id);
        
        MUSW__Deposit__c dep = TestUtility.getDeposit();
        dep.Contact__c=con.Id;
        dep.Validation_number__c=cEnve.Id;
        dep.MUSW__Account__c=acc.Id;
        insert dep; 
        
        Test.startTest();
        LnP_CustomerEnvelopeDetailPageCtrl.fetchDeposits(cEnve.Id);
        LnP_CustomerEnvelopeDetailPageCtrl.submitDeposits(cEnve.Id);
        LnP_CustomerEnvelopeDetailPageCtrl.getObjViews();
        Test.stopTest();
    }
    
    public static testmethod void customerEnvelopeTriggerHandleTest(){
        Customer_Envelope__c cEnve = TestUtility.getCEnvelope();
        insert cEnve;
        
        cEnve.Hold_Status__c = true;
        update cEnve;
        
        Database.DeleteResult delcEnve = database.delete(cEnve.Id);
        
        
        Customer_Envelope__c cEnve2 = TestUtility.getCEnvelope();
        insert cEnve2;
        cEnve2.Total_amount__c = 100;
        update cEnve2;
        
        Lockbox_Envelope__c lockbox = new Lockbox_Envelope__c();
        insert lockbox;
        cEnve2.Lockbox_Envelope__c = lockbox.Id;
        update cEnve2;
    }
}