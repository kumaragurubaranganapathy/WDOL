/* @author  :   Rishap
* @US       :   1966
* @discription :    Update Agency Code and Voucher Number field from Deposit to Receipt
*/ 
trigger updateReceiptFieldsfromDeposit on MUSW__Deposit__c (after insert, after update) {
    if (Trigger.isInsert) {
        if (Trigger.isBefore) {
            // Process before insert
        } else if (Trigger.isAfter) {
            // Process after insert
        }        
    }
    else if (Trigger.isUpdate) {
        // Process after update
        if(Trigger.isAfter){
            List<MUSW__Payable_Receipt__c> paybelReceipt_currentDeposit = new List<MUSW__Payable_Receipt__c>([Select Id, 
                                                                                                              MUSW__Receipt__c, 
                                                                                                              MUSW__Deposit__c,MUSW__Receipt__r.Id,MUSW__Deposit__r.Id
                                                                                                              from MUSW__Payable_Receipt__c 
                                                                                                              Where MUSW__Deposit__c IN : trigger.new]);   
            system.debug('paybelReceipt_currentDeposit : ' +paybelReceipt_currentDeposit);
            map<Id,Id> mapDepositReceipt = new map<Id,Id>();  
            Set<Id> receiptIds = new Set<Id>();
            for(MUSW__Payable_Receipt__c pr : paybelReceipt_currentDeposit){
                receiptIds.add(pr.MUSW__Receipt__c);
                mapDepositReceipt.put(pr.MUSW__Deposit__c,pr.MUSW__Receipt__c);
            }
            
            system.debug('mapDepositReceipt : ' +mapDepositReceipt);
            map<Id,MUSW__Receipt__c> receiptRectoUpdate = new  map<Id,MUSW__Receipt__c>([Select Id, 
                                                                                         Agency_Code__c, 
                                                                                         Voucher_Number__c 
                                                                                         from MUSW__Receipt__c 
                                                                                         where ID IN : receiptIds]);
            list<MUSW__Receipt__c> finalReceiptToUpdate = new  list<MUSW__Receipt__c>();
            
            for(MUSW__Deposit__c deposit : trigger.new){
                Id recieptID = mapDepositReceipt.get(deposit.Id);
                if(recieptID != null){
                    MUSW__Receipt__c recObj = receiptRectoUpdate.get(recieptID);
                    recObj.Agency_Code__c = deposit.Agency_Code__c;
                    recObj.Voucher_Number__c = deposit.Voucher_Number__c;  
                    finalReceiptToUpdate.add(recObj);
                }
            }
            system.debug('finalReceiptToUpdate : ' +finalReceiptToUpdate);
            if(!finalReceiptToUpdate.isEmpty())
                update finalReceiptToUpdate;            
        }
    }
}