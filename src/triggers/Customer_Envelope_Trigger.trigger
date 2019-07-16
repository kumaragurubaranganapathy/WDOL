trigger Customer_Envelope_Trigger on Customer_Envelope__c (after insert, after update, after delete, after undelete) {
    Customer_Envelope_Trigger_Handler triggerHandler = new Customer_Envelope_Trigger_Handler();
    if( Trigger.isInsert || Trigger.isUndelete ){
        triggerHandler.onInsertDeleteUndelete( Trigger.new );
    } else if( Trigger.isDelete ){
        triggerHandler.onInsertDeleteUndelete( Trigger.old );
    } else if( Trigger.isUpdate ){
        triggerHandler.onUpdate( Trigger.new , Trigger.oldMap );
    }
}