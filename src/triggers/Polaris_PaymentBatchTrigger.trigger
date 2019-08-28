trigger Polaris_PaymentBatchTrigger on BGBK__Payment_Batch__c (before insert,after update) {
	if(Trigger.isInsert && Trigger.isBefore){
        Polaris_PaymentBatchTriggerHandler.handleBeforeInsert(Trigger.new);
    }
    
    if(Trigger.isUpdate && Trigger.isAfter){
        Polaris_PaymentBatchTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
    }
    
}