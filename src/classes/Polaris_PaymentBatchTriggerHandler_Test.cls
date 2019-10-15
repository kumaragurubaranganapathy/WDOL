@isTest
public class Polaris_PaymentBatchTriggerHandler_Test {
	@isTest
    public static void testHandleBeforeInsert(){
        Id cashRegisterRecTypeId = Schema.SObjectType.Cash_Register__c.getRecordTypeInfosByName().get('Cash Register').getRecordTypeId();
        Cash_Register__c cashRegister = DOL_TestDataFactory.createCashRegister(cashRegisterRecTypeId);
        BGBK__Payment_Batch__c pb = DOL_TestDataFactory.createPaymentBatch(cashRegister.Id);
    }
    
    @isTest
    public static void testHandleAfterInsert(){
        Id cashRegisterRecTypeId = Schema.SObjectType.Cash_Register__c.getRecordTypeInfosByName().get('Cash Register').getRecordTypeId();
        Cash_Register__c cashRegister = DOL_TestDataFactory.createCashRegister(cashRegisterRecTypeId);
        BGBK__Payment_Batch__c pb = DOL_TestDataFactory.createPaymentBatch(cashRegister.Id);
        pb.Total_check_credit_card__c = 10;
        pb.Total_credit_card_receipts__c = 10;
        update pb;
    }
}