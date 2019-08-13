/*
Name: LnP_UpdateOvershortAmountClass
Description: Classes used to update the update the overshort amount on deposit and receipt record
Created By:Chiranrh Aradhya 
Created Date: 07/01/2019
*/
public with sharing class LnP_UpdateOvershortAmountClass {
 @AuraEnabled
    public static String updateovershortdepositMethod(Id DepositId) {
        if(DepositId != null) {
            MUSW__Deposit__c depositRec = [SELECT Id,Over_Short_Revenue_Code__c,MUSW__Available_Amount__c,Overshort_Amount__c,wadol_Program_Type__c FROM MUSW__Deposit__c WHERE Id = :DepositId];
            if(depositRec.Overshort_Amount__c != null){
                
                return 'Send to Overshort cannot be processed.';
            }
            else if((depositRec.MUSW__Available_Amount__c <= decimal.valueOf(System.Label.OverShortDepositUpperLimit) && depositRec.MUSW__Available_Amount__c > decimal.valueOf(System.Label.OverShortDepositLowerLimit)) ){
                //update MUSW__Deposit__c overshort Amount with available amount.
                depositRec.Overshort_Amount__c = depositRec.MUSW__Available_Amount__c;
                depositRec.Overshort_Modified__c = True;
                
                String ProgramType = depositRec.wadol_Program_Type__c;
                List<Master_ConfigData_Listing__c> mastConfigList = new List<Master_ConfigData_Listing__c>();
                mastConfigList =[Select Id, Revenue_Account_Code__c,Listing_Type__c,Program_Type__c from Master_ConfigData_Listing__c where Listing_Type__c ='Overshort Queue' AND Program_Type__c INCLUDES(:ProgramType)];
                if(!mastConfigList.isEmpty()){
                    depositRec.Over_Short_Revenue_Code__c = mastConfigList[0].Revenue_Account_Code__c;
                }
                
                update depositRec;
                return 'True';
            }else if(depositRec.MUSW__Available_Amount__c > decimal.valueOf(System.Label.OverShortDepositUpperLimit)){
                return 'False';
            }
        }
        return null;
    }
    
    @AuraEnabled
    public static String updateovershortreceiptMethod(Id ReceiptId) {
        if(ReceiptId != null) {
             /*
                MUSW__Receipt__c ReceiptRec = [SELECT Id,MUSW__Amount_Available__c,Overshort_Amount__c FROM MUSW__Receipt__c WHERE Id = :ReceiptId];
                if(ReceiptRec.MUSW__Amount_Available__c <= decimal.valueOf(System.Label.OverShortReceiptUpperLimit) && ReceiptRec.MUSW__Amount_Available__c > decimal.valueOf(System.Label.OverShortReceiptLowerLimit)){
                    ReceiptRec.Overshort_Amount__c = ReceiptRec.MUSW__Amount_Available__c;
                    //update MUSW__Receipt__c overshort Amount with available amount.
                    update ReceiptRec;
                    return 'True';
                }else{
                    return 'False';
                }
            */
        }
        return null;
    }
    
    @AuraEnabled
    public static String payFromOverShort(Id feeId) {
        if(feeId != null) {
           MUSW__Fee__c FeeRec = new MUSW__Fee__c();
           
            String FeeQuery = DOL_AppUtility.getQueryString('MUSW__Fee__c');
            FeeQuery += ' WHERE Id = :feeId';
            List<MUSW__Fee__c> FeeList = Database.query(FeeQuery);
           
            MUSW__Receipt__c receiptRec;
            
            FeeRec =Database.query(FeeQuery);
            
            if( FeeRec.MUSW__Outstanding_Fee__c< decimal.valueOf(System.Label.OverShortFeeUpperLimit) && FeeRec.MUSW__Outstanding_Fee__c > decimal.valueOf(System.Label.OverShortFeeLowerLimit)){
                    receiptRec = new MUSW__Receipt__c();
                    receiptRec.MUSW__Amount_Tendered__c =  FeeRec.MUSW__Outstanding_Fee__c;
                    receiptRec.MUSW__Payment_Method__c ='Overshort';
            }else{
                return 'Validation Error';
            }
            
            if(receiptRec != null){
               insert receiptRec; 
            }
            
            BGBK.Payable[] payables = new BGBK.Payable[]{};
            payables.add(new BGBK.Payable(FeeRec, FeeRec.MUSW__Outstanding_Fee__c));

            Map<MUSW__Receipt__c, Decimal> receiptMap = new Map<MUSW__Receipt__c, Decimal>();
            receiptMap.put(receiptRec, receiptRec.MUSW__Amount_Tendered__c);
            DateTime myDateTime  = system.now();   
            BGBK.PaymentService paymentServiceObj = new BGBK.PaymentService();
            Boolean Result = paymentServiceObj.processPayment(payables, receiptMap,null,myDateTime); 
            if(Result){
              return 'True';  
            }else{
              return 'False';
            }
            
        }
        return null;
    }
}