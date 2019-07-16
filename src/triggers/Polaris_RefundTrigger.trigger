trigger Polaris_RefundTrigger on BGBK__Refund2__c (before update,after update) {
    if(Trigger.isUpdate && Trigger.isBefore){
        Polaris_RefundTriggerHandler.handleBeforeUpdate(Trigger.new,Trigger.oldMap);
    }
    if(Trigger.isUpdate && Trigger.isAfter){
        Polaris_RefundTriggerHandler.handleAfterUpdate(Trigger.new,Trigger.oldMap);
    }
}