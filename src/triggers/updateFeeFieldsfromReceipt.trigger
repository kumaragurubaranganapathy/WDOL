/* @author  :   Rishap
*  @US       :   1966
*  @discription :    Update Agency Code and Voucher Number field from receipt to Fee
*/ 
trigger updateFeeFieldsfromReceipt on MUSW__Receipt__c (after update,after insert) {
   if (Trigger.isUpdate || Trigger.isInsert) {
        // Process after update
        if(Trigger.isAfter){
            
            List<MUSW__Fee_Payment__c> feePaymentforCurrentReceipt = new List<MUSW__Fee_Payment__c>([Select Id,
                                                                                                     MUSW__Receipt__c, 
                                                                                                     MUSW__Fee__c 
                                                                                                     from MUSW__Fee_Payment__c 
                                                                                                     where MUSW__Receipt__c IN : trigger.new]);
            system.debug('feePaymentforCurrentReceipt : ' +feePaymentforCurrentReceipt);
            Map<Id,Id> mapReceipttoFee = new Map<Id,Id>();
            Set<Id> FeeIds = new Set<Id>();
            for(MUSW__Fee_Payment__c feepay : feePaymentforCurrentReceipt){
                FeeIds.add(feepay.MUSW__Fee__c);
                mapReceipttoFee.put(feepay.MUSW__Receipt__c, feepay.MUSW__Fee__c);                    
            }
             system.debug('mapReceipttoFee : ' +mapReceipttoFee);
            Map<Id,MUSW__Fee__c> updateFeeRec = new Map<Id,MUSW__Fee__c>([Select Id, 
                                                                          Agency_Code__c, 
                                                                          Voucher_Number__c 
                                                                          from MUSW__Fee__c
                                                                          where Id IN : FeeIds]);
            List<MUSW__Fee__c> finalFeesToUpdate = new List<MUSW__Fee__c>();
            for(MUSW__Receipt__c rec : trigger.new){
                Id FeeId = mapReceipttoFee.get(rec.Id);
                if(FeeId != null){
                    MUSW__Fee__c feeRec = updateFeeRec.get(FeeId);
                    feeRec.Agency_Code__c = rec.Agency_Code__c;
                    feeRec.Voucher_Number__c = rec.Voucher_Number__c;
                    finalFeesToUpdate.add(feeRec);
                }
            }
              system.debug('finalFeesToUpdate : ' +finalFeesToUpdate);
            if(!finalFeesToUpdate.isEmpty()){
                update finalFeesToUpdate;
            }
        }
    }
}