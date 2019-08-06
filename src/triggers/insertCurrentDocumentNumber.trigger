trigger insertCurrentDocumentNumber on Journal_Voucher__c (After insert, before insert) {
    Journal_Voucher_Trigger_Handler triggerHandler = new Journal_Voucher_Trigger_Handler();
    if (trigger.isbefore){
        if( Trigger.isInsert){
            triggerHandler.onInsert(Trigger.new);
            triggerHandler.onBeforeInsert(Trigger.new);
        } 
    }
}