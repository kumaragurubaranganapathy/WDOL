/**
* Name: ReceiptTriggerHandler
* Type: Class
* Description: Trigger Handler for MUSW__Receipt__c object being called from ReceiptTrigger
* Date:        Developer/Company                   Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 08/22/2018   Srikanth Kottam/Deloitte          Initial Creation
**/
public class ReceiptTriggerHandler implements BGCM.ITriggerHandler{
    //Added by Abhilasha
    public void onAfterDelete() {
     //   system.debug('onAfterDelete receipt trigger'+trigger.New);
        Set<String> paymentBatchIds = new Set<String>();
        for(sObject sObj : trigger.old){
            MUSW__Receipt__c rec = (MUSW__Receipt__c) sObj;
            if(rec.Payment_Batch_Id__c != null){
                paymentBatchIds.add(String.valueOf(rec.Payment_Batch_Id__c).substring(0, 15));
            }
        }
        if(paymentBatchIds.size() >0){
            doCalculation(trigger.old,paymentBatchIds);
        }
    }
    public void onAfterInsert() {
       if(DOL_AppUtility.isReceiptRunOnce == false){
        DOL_AppUtility.isReceiptRunOnce  = true;
       // system.debug('onAfterInsert receipt trigger');
        //This Method is called when already an AccountContact Record exists on an Account and Receipt records get Created. This Record will be shared with the community Plus User
        //ReceiptUserSharing controller = new ReceiptUserSharing();
        //controller.ReceiptSharing_RecordInsert(Trigger.New);
        //End of ReceiptUserSharing
        
        //Share the Receipt records when the Delegated Admin is the applicant
       /* ReceiptCreatedbyDelegate DelegateController = new ReceiptCreatedbyDelegate();
        DelegateController.shareReceiptRecords(Trigger.New);*/
        
        //Added by Abhilasha **start**
        Set<String> paymentBatchIds = new Set<String>();
        for(sObject sObj : trigger.new){
            MUSW__Receipt__c rec = (MUSW__Receipt__c) sObj;
            if(rec.Payment_Batch_Id__c != null){
                paymentBatchIds.add(String.valueOf(rec.Payment_Batch_Id__c).substring(0, 15));
            }
        }
        if(paymentBatchIds.size() >0){
            doCalculation(trigger.new,paymentBatchIds);
        }
        //**end**
     }
    } 
    //Added by Abhilasha 
    public void onAfterUndelete() {
     //   system.debug('onAfterUndelete receipt trigger');
        Set<String> paymentBatchIds = new Set<String>();
        for(sObject sObj : trigger.new){
            MUSW__Receipt__c rec = (MUSW__Receipt__c) sObj;
            if(rec.Payment_Batch_Id__c != null){
                paymentBatchIds.add(String.valueOf(rec.Payment_Batch_Id__c).substring(0, 15));
            }
        }
        if(paymentBatchIds.size() >0){
            doCalculation(trigger.new,paymentBatchIds);
        }
    }
    public void onAfterUpdate() {
       if(DOL_AppUtility.isReceiptRunOnce == false){
           DOL_AppUtility.isReceiptRunOnce = true;
      // system.debug('onAfterUpdate receipt trigger');
        
        //Added by for US1469 On 07/11/2019 [Chiranth]
        set<Id>DHP_receiptIDs = new Set<Id>();
        set<id> receiptIds = new Set<id>(); // Added by Rishap US - 1966 - [Rishap]
        Set<String> paymentBatchIds = new Set<String>(); // Added by Abhilasha
        
        for(SObject sobj: trigger.new) {
            
            
            MUSW__Receipt__c receipt = (MUSW__Receipt__c)sobj;
            SObject oldrecord = Trigger.oldMap.get(receipt.Id);
            MUSW__Receipt__c oldreceipt = (MUSW__Receipt__c)oldrecord;
            if(oldreceipt.DHP__c != receipt.DHP__c && receipt.DHP__c == True){
                DHP_receiptIDs.add(receipt.Id);
            }
            if(oldreceipt.Agency_Code__c != receipt.Agency_Code__c || oldreceipt.Voucher_Number__c != receipt.Voucher_Number__c){ 
                receiptIds.add(receipt.Id);
            } 
            // added by abhilasha **start**
            if(receipt.Payment_Batch_Id__c != null){
                paymentBatchIds.add(String.valueOf(receipt.Payment_Batch_Id__c).substring(0, 15));
            }
            //**end**
        }
        
        List<MUSW__Fee_Payment__c> feePaymentLists = new List<MUSW__Fee_Payment__c>();
        if(!DHP_receiptIDs.isEmpty()){
            for(MUSW__Fee_Payment__c feePayment:[Select Id,DHP_Amount__c,MUSW__Payment_Amount__c from MUSW__Fee_Payment__c where MUSW__Receipt__c IN:DHP_receiptIDs and MUSW__Receipt__c!=null]){
                feePayment.DHP_Amount__c = feePayment.MUSW__Payment_Amount__c;
                feePaymentLists.add(feePayment);
            }
            if(!feePaymentLists.isEmpty()){
                update feePaymentLists;
            }
        }
        // End of the code of Chiranth 
        
        
        
        //Added by Rishap for US1966
        Map<Id,Id> mapReceipttoFee = new Map<Id,Id>();
        Set<Id> FeeIds = new Set<Id>();
        List<MUSW__Fee_Payment__c> feePaymentforCurrentReceipt = new List<MUSW__Fee_Payment__c>();
        if(!receiptIds.isEmpty()){
            feePaymentforCurrentReceipt = new List<MUSW__Fee_Payment__c>([Select Id,
                                                                          MUSW__Receipt__c, 
                                                                          MUSW__Fee__c 
                                                                          from MUSW__Fee_Payment__c 
                                                                          where MUSW__Receipt__c IN : receiptIds and MUSW__Receipt__c!=null]);
            if(!feePaymentforCurrentReceipt.isEmpty()){
                for(MUSW__Fee_Payment__c feepay : feePaymentforCurrentReceipt){
                    FeeIds.add(feepay.MUSW__Fee__c);
                    mapReceipttoFee.put(feepay.MUSW__Receipt__c, feepay.MUSW__Fee__c);                    
                }
            }
            
        }
        
        
        Map<Id,MUSW__Fee__c> updateFeeRec ;
        if(!FeeIds.isEmpty()){
            updateFeeRec = new Map<Id,MUSW__Fee__c>([Select Id, 
                                                     Agency_Code__c, 
                                                     Voucher_Number__c 
                                                     from MUSW__Fee__c
                                                     where Id IN : FeeIds and id!=null]);
        }
        
        List<MUSW__Fee__c> finalFeesToUpdate = new List<MUSW__Fee__c>();
        for(SObject sobj: trigger.new){
            MUSW__Receipt__c rec = (MUSW__Receipt__c)sobj;
            if(mapReceipttoFee != null && mapReceipttoFee.ContainsKey(rec.Id) && mapReceipttoFee.get(rec.Id) != null){
                Id FeeId = mapReceipttoFee.get(rec.Id);
                if(FeeId != null){
                    if(updateFeeRec != null && updateFeeRec.ContainsKey(FeeId) && updateFeeRec.get(FeeId) != null){
                        MUSW__Fee__c feeRec = updateFeeRec.get(FeeId);
                        feeRec.Agency_Code__c = rec.Agency_Code__c;
                        feeRec.Voucher_Number__c = rec.Voucher_Number__c;
                        finalFeesToUpdate.add(feeRec);
                    }
                }
            }
        }
      //  system.debug('finalFeesToUpdate : ' +finalFeesToUpdate);
        if(!finalFeesToUpdate.isEmpty()){
            update finalFeesToUpdate;
        }
        
        //added by Abhilasha **start**
        if(paymentBatchIds.size() >0){
            doCalculation(trigger.new,paymentBatchIds);
        }
        //**end**
       }  
        
    }
    public void onBeforeDelete() {}
    public void onBeforeInsert() {
       if( DOL_AppUtility.isReceiptRunOnce == false) {
     //   system.debug('beforeInsertMethod receipt trigger');
        beforeMethod();
        }
    }
    public void onBeforeUndelete() {}
    public void onBeforeUpdate() {
        if(DOL_AppUtility.isReceiptRunOnce == false){
         //   system.debug('beforeUpdateMethod receipt trigger');
            beforeMethod();
        }
    }
    
    public void beforeMethod(){
        
        for(sObject sObj : trigger.New){
            MUSW__Receipt__c receipt = (MUSW__Receipt__c) sObj;
            if(receipt.MUSW__Payment_Method__c == 'CC'){
                receipt.MUSW__Payment_Method__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Credit Card';
            }
            if(receipt.MUSW__Card_Type__c == 'MC'){
                receipt.MUSW__Card_Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'MasterCard';
            }else if(receipt.MUSW__Card_Type__c == 'VISA'){
                receipt.MUSW__Card_Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Visa';
            }else if(receipt.MUSW__Card_Type__c == 'AMEX'){
                receipt.MUSW__Card_Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Amex';
            }
        }
    }
    
    public void doCalculation(List<sObject> newList,Set<String> pbIds){
        List<BGBK__Payment_Batch__c> paymentBatchToBeUpdated = new List<BGBK__Payment_Batch__c>();
        List<MUSW__Receipt__c> recRes = [Select MUSW__Amount_Tendered__c,MUSW__Payment_Method__c,Payment_Batch_Id__c from MUSW__Receipt__c where Intake_Method__c =: DOL_AppConstants.NULL_EMPTY_STRING + 'Counter' and Payment_Batch_Id__c IN: pbIds];
      
        for(sObject sObj : newList){
            MUSW__Receipt__c receipt = (MUSW__Receipt__c) sObj;
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
             //       system.debug('pb::'+pb);
                    
                    paymentBatchToBeUpdated.add(pb);
                }
                
            }
        }
        
        try{
       //     system.debug('paymentBatchToBeUpdated::'+paymentBatchToBeUpdated);
            if(paymentBatchToBeUpdated.size() >0){
                update paymentBatchToBeUpdated;
            }
        }catch(DmlException ex){
         //   system.debug('Exception::'+ex.getStackTraceString());
        }
       
    }
}