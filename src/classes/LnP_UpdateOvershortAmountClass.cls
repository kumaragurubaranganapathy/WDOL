/*
Name: LnP_UpdateOvershortAmountClass
Description: Classes used to update the update the overshort amount on deposit and receipt record
Created By:Chiranrh Aradhya 
Created Date: 07/01/2019
*/
public class LnP_UpdateOvershortAmountClass {
 @AuraEnabled
    public static String updateovershortdepositMethod(Id DepositId) {
        if(DepositId != null) {
            MUSW__Deposit__c depositRec = [SELECT Id,Over_Short_Revenue_Code__c,MUSW__Available_Amount__c,Overshort_Amount__c,wadol_Program_Type__c FROM MUSW__Deposit__c WHERE Id = :DepositId];
            
            if(depositRec.MUSW__Available_Amount__c <= decimal.valueOf(System.Label.OverShortDepositUpperLimit) && depositRec.MUSW__Available_Amount__c > decimal.valueOf(System.Label.OverShortDepositLowerLimit)){
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
            }else{
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
           FeeRec = [SELECT Account_Number__c,Account__c,Activity__c,AFRS_AR_Code__c,AFRS_Cash_Code__c,Agency_Code__c,Agency_Number__c,Agency__c,Application_Method__c,Application_Type__c,Appropriation__c,ARed__c,AR_Date__c,BGBK__Cart_Cashier__c,BGBK__Cart_Exclude__c,BGBK__Cart__c,BGBK__Due_Date__c,BGBK__Invoice__c,BGBK__Return__c,Board__c,Budget_Period__c,Contact__c,Contest__c,CreatedById,CreatedDate,Customer_Name__c,Days_since_created__c,Department__c,Endorsement__c,External_Id__c,Fine__c,Id,Inspection__c,IsDeleted,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Legal_Action__c,License_Number__c,License_Type__c,MUSW__Amended_Amount__c,MUSW__Amount_Paid__c,MUSW__Amount_Waived__c,MUSW__Amount__c,MUSW__Application2__c,MUSW__Check_Number__c,MUSW__Complaint2__c,MUSW__Complaint__c,MUSW__Description__c,MUSW__Effective_Date__c,MUSW__Fee_Paid_By__c,MUSW__Fee_Paid_Date2__c,MUSW__Fee_Paid_Date__c,MUSW__Fee_Paid__c,MUSW__Group__c,MUSW__License1__c,MUSW__License2__c,MUSW__License__c,MUSW__Outstanding_Fee__c,MUSW__Paid_By__c,MUSW__Payment_Comment__c,MUSW__Payment_Method__c,MUSW__Permit2__c,MUSW__Permit__c,MUSW__Planning_Application__c,MUSW__Price_Per_Unit__c,MUSW__Quantity__c,MUSW__Rank__c,MUSW__Receipt_Number__c,MUSW__Test__c,MUSW__Type__c,Name,OwnerId,portal_name__c,Product__c,Profession_Code__c,Prof_Code__c,Program_Type__c,Project__c,RecordTypeId,Related_Account__c,Related_To_Id__c,Related_To_Name__c,Related_To_Type__c,Related_To__c,Renewal_Application__c,Request__c,Revenue_Account_Code__c,Revenue_Code__c,SystemModstamp,TMS_AR_Code__c,TMS_Cash_Code__c,TMS_Revenue_Code__c,Upsert_ID__c,Voided_Receipt_Amount_DHP_Amount__c,Voided_Receipt_Amount__c,Voided_Receipt_Check_Number__c,Voided_Receipt_Payment_Method__c,Voucher_for__c,Voucher_Number__c FROM MUSW__Fee__c where Id =:feeId];
        
            MUSW__Receipt__c receiptRec;
            
            
            if( FeeRec.MUSW__Outstanding_Fee__c< decimal.valueOf(System.Label.OverShortFeeUpperLimit) && FeeRec.MUSW__Outstanding_Fee__c > decimal.valueOf(System.Label.OverShortFeeLowerLimit)){
                    receiptRec = new MUSW__Receipt__c();
                    receiptRec.MUSW__Amount_Tendered__c =  FeeRec.MUSW__Outstanding_Fee__c;
                    receiptRec.MUSW__Payment_Method__c ='Overshort';
                    //receiptRec.BGBK__Cart__c = cart.Id;
                    //receiptRec.MUSW__Paid_By__c=(a != null)?a.Id:null;
                    //receiptRec.MUSW__Receipt_Paid_by__c=(con != null) ? con.Id : null;
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