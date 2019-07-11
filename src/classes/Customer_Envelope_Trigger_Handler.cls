public class Customer_Envelope_Trigger_Handler {
	// updateAmountOnLockboxEnvelope
    public void onInsertDeleteUndelete(List<Customer_Envelope__c> customerEnvelopeList){
        if( customerEnvelopeList != null && customerEnvelopeList.size() > 0 ){
            Set<Id> lockboxEnvelopeIds = new Set<Id>();
            for(Customer_Envelope__c customerEnvelope : customerEnvelopeList ){
                lockboxEnvelopeIds.add(customerEnvelope.Lockbox_Envelope__c);
            }
            updateParentTotalAmount(lockboxEnvelopeIds);
        }
    }
    
    public void onUpdate(List<Customer_Envelope__c> customerEnvelopeList, Map<Id,Customer_Envelope__c> oldMap){
        if( customerEnvelopeList != null && customerEnvelopeList.size() > 0 ){
            Set<Id> lockboxEnvelopeIds = new Set<Id>();
            for(Customer_Envelope__c customerEnvelope : customerEnvelopeList ){
                if(oldMap.get(customerEnvelope.id).Lockbox_Envelope__c !=  customerEnvelope.Lockbox_Envelope__c )
                    lockboxEnvelopeIds.add(customerEnvelope.Lockbox_Envelope__c);
                lockboxEnvelopeIds.add(oldMap.get(customerEnvelope.Id).Lockbox_Envelope__c);
            }
            updateParentTotalAmount(lockboxEnvelopeIds);
        }
    }
    
    private void updateParentTotalAmount(Set<Id> lockboxEnvelopeIds){
        if( lockboxEnvelopeIds != null && lockboxEnvelopeIds.size() > 0 ){
            List<Lockbox_Envelope__c> lockboxEnvelopeRecords = [select id, Amount__c , (select id, Total_amount__c from Customer_Envelopes__r ) from Lockbox_Envelope__c where id IN :lockboxEnvelopeIds ];
        	Decimal tempTotalAmount = 0;
            if( lockboxEnvelopeRecords != null && lockboxEnvelopeRecords.size() > 0 ){
                for(Lockbox_Envelope__c record :  lockboxEnvelopeRecords){
                    tempTotalAmount = 0;
                    for( Customer_Envelope__c customerEnvelope : record.Customer_Envelopes__r){
                        if(customerEnvelope.Total_amount__c != null)
                        	tempTotalAmount += customerEnvelope.Total_amount__c;
                    }
                    record.Amount__c = tempTotalAmount;
                }
                DOL_Dao.save(lockboxEnvelopeRecords);
            }
        }
    }
}