trigger Polaris_ReceiptTrigger on MUSW__Receipt__c (after delete,after update, after insert, after undelete) {
    public static boolean runonce = false;
    if((Trigger.isInsert || Trigger.isUndelete || Trigger.isUpdate) && Trigger.isAfter && runonce == false){
        runonce = true;        
        Polaris_ReceiptTriggerHandler.handleAfterInsert(Trigger.new);
    }
    
    if(Trigger.isDelete && Trigger.isAfter && runonce == false){
         runonce = true; 
        Polaris_ReceiptTriggerHandler.handleAfterDelete(Trigger.new);
    }
}