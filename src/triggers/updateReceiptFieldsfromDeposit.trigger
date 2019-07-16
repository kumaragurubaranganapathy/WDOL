/* @author  :   Rishap
* @US       :   1966
* @discription :    Update Agency Code and Voucher Number field from Deposit to Receipt
*/ 
trigger updateReceiptFieldsfromDeposit on MUSW__Deposit__c (after insert, after update) {
 if (Trigger.isUpdate) {
        // Process after update
        if(Trigger.isAfter){
            
            set<id> depositIds =new Set<id>();
            for(MUSW__Deposit__c depositRec: Trigger.new){
                MUSW__Deposit__c olddeposit = Trigger.oldMap.get(depositRec.Id);
                if(olddeposit.Agency_Code__c != depositRec.Agency_Code__c || olddeposit.Voucher_Number__c != depositRec.Voucher_Number__c){ 
                    depositIds.add(depositRec.Id);
                }   
            }
            map<Id,Id> mapDepositReceipt = new map<Id,Id>();  
            set<Id>receiptIds = new Set<Id>();
            if(!depositIds.isEmpty()){
                for(MUSW__Payable_Receipt__c payRec: [Select Id,MUSW__Receipt__c, MUSW__Deposit__c,MUSW__Receipt__r.Id,MUSW__Deposit__r.Id from MUSW__Payable_Receipt__c Where MUSW__Deposit__c IN:depositIds]){
                    receiptIds.add(payRec.MUSW__Receipt__c);
                    mapDepositReceipt.put(payRec.MUSW__Deposit__c,payRec.MUSW__Receipt__c);
                }
            }
            map<Id,MUSW__Receipt__c> receiptRectoUpdate;
            if(!receiptIds.isEmpty()){
                receiptRectoUpdate = new  map<Id,MUSW__Receipt__c>([Select Id, 
                                                                                         Agency_Code__c, 
                                                                                         Voucher_Number__c 
                                                                                         from MUSW__Receipt__c 
                                                                                         where ID IN : receiptIds]);
            }
            list<MUSW__Receipt__c> finalReceiptToUpdate = new  list<MUSW__Receipt__c>();
            if(!mapDepositReceipt.isEmpty()){
                for(MUSW__Deposit__c deposit : trigger.new){
                    Id recieptID = mapDepositReceipt.get(deposit.Id);
                    if(recieptID != null){
                        MUSW__Receipt__c recObj = receiptRectoUpdate.get(recieptID);
                        recObj.Agency_Code__c = deposit.Agency_Code__c;
                        recObj.Voucher_Number__c = deposit.Voucher_Number__c;  
                        finalReceiptToUpdate.add(recObj);
                    }
                }
            }
            system.debug('finalReceiptToUpdate : ' +finalReceiptToUpdate);
            if(!finalReceiptToUpdate.isEmpty())
                update finalReceiptToUpdate;            
        }
    }
}