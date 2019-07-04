trigger Payment_Batch_Trigger on BGBK__Payment_Batch__c (after insert, after update, after delete, after undelete) {
    Payment_Batch_Trigger_Handler triggerHandler = new Payment_Batch_Trigger_Handler();
    if( Trigger.isInsert || Trigger.isUndelete ){
        triggerHandler.onInsertDeleteUndelete( Trigger.new );
    } else if( Trigger.isDelete ){
        triggerHandler.onInsertDeleteUndelete( Trigger.old );
    } else if( Trigger.isUpdate ){
        triggerHandler.onUpdate( Trigger.new , Trigger.oldMap );
    }
}