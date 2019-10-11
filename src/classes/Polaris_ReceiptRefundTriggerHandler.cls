public class Polaris_ReceiptRefundTriggerHandler {
    public static void handleBeforeInsert(List<BGBK__Receipt_Refund__c> newList){
        List<String> onlinePaymentMethod = new List<String>{'ACH', 'Credit Card'};
            Set<Id> receiptIds = new Set<Id>();
        for(BGBK__Receipt_Refund__c recRef: newList){
            if(recRef.BGBK__Receipt__c != null){
                receiptIds.add(recRef.BGBK__Receipt__c);
            }
        }
        Map<Id,MUSW__Receipt__c> receiptMap = new Map<id,MUSW__Receipt__c>([Select id, name, US_Bank_Payment_Status__c,MUSW__Payment_Method__c from MUSW__Receipt__c where id in: receiptIds and MUSW__Payment_Method__c in: onlinePaymentMethod and US_Bank_Payment_Status__c !='Settled']);
        system.debug('receiptMap::'+receiptMap);
        if(receiptMap.size()>0){
            for(BGBK__Receipt_Refund__c recRef: newList){
                if(receiptMap.containsKey(recRef.BGBK__Receipt__c)){
                    recRef.addError('Refund cannot be created as US Bank payment status is not settled!');
                }
            }  
        }
        
    }
}