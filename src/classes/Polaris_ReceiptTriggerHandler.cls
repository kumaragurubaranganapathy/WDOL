public class Polaris_ReceiptTriggerHandler {
    
    public static void handleAfterInsert(List<MUSW__Receipt__c> newList){
        Set<String> paymentBatchIds = new Set<String>();
        for(MUSW__Receipt__c rec: newList){
            if(rec.Payment_Batch_Id__c != null){
                paymentBatchIds.add(String.valueOf(rec.Payment_Batch_Id__c).substring(0, 15));
            }
        }
        if(paymentBatchIds.size() >0){
            doCalculation(newList,paymentBatchIds);
        }
    }
    
    public static void handleAfterDelete(List<MUSW__Receipt__c> oldList){
        Set<String> paymentBatchIds = new Set<String>();
        for(MUSW__Receipt__c rec: oldList){
            if(rec.Payment_Batch_Id__c != null){
                paymentBatchIds.add(String.valueOf(rec.Payment_Batch_Id__c).substring(0, 15));
            }
        }
        if(paymentBatchIds.size() >0){
            doCalculation(oldList,paymentBatchIds);
        }
    }
    
    public static void doCalculation(List<MUSW__Receipt__c> newList, Set<String> pbIds){
        system.debug('Inside doCalculation');
        system.debug('newList::'+newList);
        system.debug('pbIds::'+pbIds);
        List<BGBK__Payment_Batch__c> paymentBatchToBeUpdated = new List<BGBK__Payment_Batch__c>();
        List<MUSW__Receipt__c> recRes = [Select MUSW__Amount_Tendered__c,MUSW__Payment_Method__c,Payment_Batch_Id__c from MUSW__Receipt__c where Intake_Method__c = 'Counter' and Payment_Batch_Id__c IN: pbIds];
        system.debug('recRes::'+recRes);
        for(MUSW__Receipt__c receipt: newList){
            if(receipt.Payment_Batch_Id__c != null){
                Decimal totalCash = 0;
                Decimal totalCheck = 0;
                Decimal totalCC = 0;
                BGBK__Payment_Batch__c pb;
                for(MUSW__Receipt__c rec: recRes){
                    if(rec.Payment_Batch_Id__c == receipt.Payment_Batch_Id__c){
                        pb = new BGBK__Payment_Batch__c(id = rec.Payment_Batch_Id__c);
                        if(rec.MUSW__Payment_Method__c == 'Cash'){
                             totalCash += rec.MUSW__Amount_Tendered__c;
                        }else if(rec.MUSW__Payment_Method__c == 'Check/Cashier\'s Check'){
                            totalCheck += rec.MUSW__Amount_Tendered__c;
                        }else if(rec.MUSW__Payment_Method__c == 'Credit Card'){
                            if(receipt.MUSW__Amount_Tendered__c != null){
                                totalCC += rec.MUSW__Amount_Tendered__c;
                            }
                            
                        }
                	}
                }
                if(pb != null){
                    pb.Total_Cash_In_Register__c = totalCash;
                	pb.Total_check_credit_card__c = totalCheck + totalCC;
                	//pb.Total_credit_card_receipts__c = totalCC;
                    system.debug('pb::'+pb);
                    
                	paymentBatchToBeUpdated.add(pb);
                }
                
            }
        }
        
        try{
            system.debug('paymentBatchToBeUpdated::'+paymentBatchToBeUpdated);
            if(paymentBatchToBeUpdated.size() >0){
                update paymentBatchToBeUpdated;
            }
        }catch(DmlException ex){
            system.debug('Exception::'+ex.getStackTraceString());
        }
       
    }
}