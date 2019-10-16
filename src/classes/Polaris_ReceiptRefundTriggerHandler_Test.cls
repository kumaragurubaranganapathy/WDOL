@isTest
public class Polaris_ReceiptRefundTriggerHandler_Test {
    @isTest
    public static void testMethod1(){
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        MUSW__License2__c lic1 = DOL_TestDataFactory.createLicense(LicRecTypeId1, a.Id, 'Architects', 'Architect', 'General Application');
        MUSW__Fee__c fee = DOL_TestDataFactory.createFeeWithLicense('Fine', 100, lic1.Id);
        
        MUSW__Receipt__c receipt = DOL_TestDataFactory.createReceipt('cash',100,'Counter');
        
        
        // Create a sample refund record and then submit it for approval.
        BGBK__Refund2__c ref = new BGBK__Refund2__c();
        ref.BGBK__Amount__c = 50;
        ref.Fee__c = fee.Id;
        ref.Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Requested';
        insert ref;
        
        BGBK__Receipt_Refund__c recRefund = DOL_TestDataFactory.createReceiptRefund(ref.Id,receipt.Id,null);
    }
    
    @isTest
    public static void testMethod2(){
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        MUSW__License2__c lic1 = DOL_TestDataFactory.createLicense(LicRecTypeId1, a.Id, 'Architects', 'Architect', 'General Application');
        MUSW__Fee__c fee = DOL_TestDataFactory.createFeeWithLicense('Fine', 100, lic1.Id);
        
        MUSW__Receipt__c receipt = DOL_TestDataFactory.createReceipt('ACH',100,'Counter');
        
        
        
        // Create a sample refund record and then submit it for approval.
        BGBK__Refund2__c ref = new BGBK__Refund2__c();
        ref.BGBK__Amount__c = 50;
        ref.Fee__c = fee.Id;
        ref.Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Requested';
        insert ref;
        try{
            BGBK__Receipt_Refund__c recRefund = DOL_TestDataFactory.createReceiptRefund(ref.Id,receipt.Id,null);
        }catch(Exception ex){
           // system.debug(ex.getMessage());
            system.assert(ex.getMessage().contains('Refund cannot be created as US Bank payment status is not settled!'));
        }
        
    }
}