trigger Polaris_ReceiptRefundTrigger on BGBK__Receipt_Refund__c (before insert) {
	if(Trigger.isInsert && Trigger.isBefore){
        Polaris_ReceiptRefundTriggerHandler.handleBeforeInsert(Trigger.new);
    }
}