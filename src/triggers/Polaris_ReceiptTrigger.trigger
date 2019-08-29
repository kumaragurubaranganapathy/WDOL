trigger Polaris_ReceiptTrigger on MUSW__Receipt__c (after delete,after update, after insert, after undelete) {
    if((Trigger.isInsert || Trigger.isUndelete || Trigger.isUpdate) && Trigger.isAfter){
        Polaris_ReceiptTriggerHandler.handleAfterInsert(Trigger.new);
    }
    
    if(Trigger.isDelete && Trigger.isAfter){
        Polaris_ReceiptTriggerHandler.handleAfterDelete(Trigger.new);
    }
}