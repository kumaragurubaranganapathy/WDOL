public class Polaris_PaymentBatchTriggerHandler{
	public static void handleBeforeInsert(List<BGBK__Payment_Batch__c> newList){
        for(BGBK__Payment_Batch__c pb: newList){
            pb.Startup__c = pb.Opening_Balance__c;
        }
    }
    public static void handleAfterUpdate(List<BGBK__Payment_Batch__c> newList, Map<Id,BGBK__Payment_Batch__c> oldMap){
        List<Cash_Register__c> cashRegToBeUpdated = new List<Cash_Register__c>();
        for(BGBK__Payment_Batch__c pb: newList){
            Boolean regUpdated = false;
            Cash_Register__c reg = new Cash_Register__c(id= pb.Cash_Register__c);
          	if(oldMap.get(pb.Id).Total_check_credit_card__c != pb.Total_check_credit_card__c){
                regUpdated = true;
                reg.Total_Check_Credit_Cards__c = pb.Total_check_credit_card__c;
            }
            if(oldMap.get(pb.Id).Total_credit_card_receipts__c != pb.Total_credit_card_receipts__c){
                regUpdated = true;
                reg.Total_Credit_Card_Receipts__c = pb.Total_credit_card_receipts__c;
            }
            
            if(regUpdated){
                cashRegToBeUpdated.add(reg);
            }
        }
        
        if(cashRegToBeUpdated.size()>0){
            try{
                update cashRegToBeUpdated;
            }catch(DmlException ex){
                system.debug(ex.getStackTraceString());
            }
        }
    }
}