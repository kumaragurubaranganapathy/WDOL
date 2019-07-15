trigger insertCurrentDocumentNumber on Journal_Voucher__c (After insert) {
    Journal_Voucher_Trigger_Handler triggerHandler = new Journal_Voucher_Trigger_Handler();
    if( Trigger.isInsert){
        triggerHandler.onInsert(Trigger.new);
    } 
}