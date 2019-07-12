trigger CashRegisterTrigger on Cash_Register__c (before insert) {
    if(Trigger.isbefore && Trigger.isInsert){
        CashRegisterTriggerHandler.handleBeforeInsert(Trigger.new);
    }
}