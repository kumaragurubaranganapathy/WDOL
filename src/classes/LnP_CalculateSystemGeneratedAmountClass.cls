/*
Name: LnP_CalculateSystemGeneratedAmountClass
Description:
*/
public class LnP_CalculateSystemGeneratedAmountClass {
 @AuraEnabled
    public static String CalculateSystemGeneratedAmount(Id recordId) {
    
        Map<Id, List<MUSW__Receipt__c>> cashRegwithReceiptMap = new Map<Id, List<MUSW__Receipt__c>>();
        if(RecordId != null){
            for(MUSW__Receipt__c receipt: [SELECT Id,MUSW__Amount_Tendered__c, BGBK__Cart__r.BGBK__BG_Payment_Batch__r.Cash_Register__c FROM MUSW__Receipt__c where BGBK__Cart__r.BGBK__BG_Payment_Batch__r.Cash_Register__c =:RecordId and MUSW__Payment_Method__c ='cash']){
            if(!cashRegwithReceiptMap.containsKey(receipt.BGBK__Cart__r.BGBK__BG_Payment_Batch__r.Cash_Register__c)){
                cashRegwithReceiptMap.put(receipt.BGBK__Cart__r.BGBK__BG_Payment_Batch__r.Cash_Register__c, new List<MUSW__Receipt__c>());
            }
                cashRegwithReceiptMap.get(receipt.BGBK__Cart__r.BGBK__BG_Payment_Batch__r.Cash_Register__c).add(receipt); 
            } 
        
            List<Cash_Register__c> cashRegisterList = new List<Cash_Register__c>();
            Double totalAmount = 0;
            
                for(Cash_Register__c cashRegister : [Select Id, System_generated_cash_total__c from Cash_Register__c where Id =: RecordId]){
                    totalAmount = 0;
                    if(!cashRegwithReceiptMap.isEmpty()){
                        if(cashRegwithReceiptMap.containsKey(cashRegister.Id)){
                            for(MUSW__Receipt__c receipt : cashRegwithReceiptMap.get(cashRegister.Id)){
                                if(receipt.MUSW__Amount_Tendered__c != null){
                                    totalAmount += receipt.MUSW__Amount_Tendered__c;
                                }
                            }
                        }
                    }
                    cashRegister.System_generated_cash_total__c = totalAmount;
                    cashRegisterList.add(cashRegister);
                }
				if(!cashRegisterList.isEmpty()){
						update cashRegisterList;
				   }
            
        }
        return null;
    }
}