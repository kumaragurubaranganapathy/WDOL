public class Payment_Batch_Trigger_Handler {
	// updateAmountOnLockboxEnvelope
    public void onInsertDeleteUndelete(List<BGBK__Payment_Batch__c> paymentBatchList){
        if( paymentBatchList != null && paymentBatchList.size() > 0 ){
            Set<Id> cashRegisterIds = new Set<Id>();
            for(BGBK__Payment_Batch__c paymentBatch : paymentBatchList ){
                cashRegisterIds.add(paymentBatch.Cash_Register__c);
            }
            updateParentTotalAmount(cashRegisterIds);
        }
    }
    
    public void onUpdate(List<BGBK__Payment_Batch__c> paymentBatchList, Map<Id,BGBK__Payment_Batch__c> oldMap){
        if( paymentBatchList != null && paymentBatchList.size() > 0 ){
            Set<Id> cashRegisterIds = new Set<Id>();
            for(BGBK__Payment_Batch__c paymentBatch : paymentBatchList ){
                if(oldMap.get(paymentBatch.id).Cash_Register__c !=  paymentBatch.Cash_Register__c )
                    cashRegisterIds.add(paymentBatch.Cash_Register__c);
                cashRegisterIds.add(oldMap.get(paymentBatch.Id).Cash_Register__c);
            }
            updateParentTotalAmount(cashRegisterIds);
        }
    }
    
    private void updateParentTotalAmount(Set<Id> cashRegisterIds){
        if( cashRegisterIds != null && cashRegisterIds.size() > 0 ){
            List<Cash_Register__c> cashRegisterRecords = [select id, System_generated_cash_total__c , (select id, Total__c from Payment_Batches__r) from Cash_Register__c where id IN :cashRegisterIds ];
        	Decimal tempTotalAmount = 0;
            if( cashRegisterRecords != null && cashRegisterRecords.size() > 0 ){
                for(Cash_Register__c record :  cashRegisterRecords){
                    tempTotalAmount = 0;
                    for( BGBK__Payment_Batch__c payBat : record.Payment_Batches__r){
                        if(payBat.Total__c != null)
                        	tempTotalAmount += payBat.Total__c;
                    }
                    record.System_generated_cash_total__c = tempTotalAmount;
                }
                DOL_Dao.save(cashRegisterRecords);
            }
        }
    }
}