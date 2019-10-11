/**
* Name: DepositTriggerHandler
* Type: Class
* Description: Trigger Handler for 
* Date:        Developer/Company                   Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* Rishap/Deloitte          Initial Creation
**/
public with sharing class LnP_DepositTriggerHandler implements BGCM.ITriggerHandler{
    public void onAfterDelete() {}
    public void onAfterInsert() {
        
    }
    public void onAfterUndelete() {}
    public void onAfterUpdate() {
        
        set<id> depositIds =new Set<id>();
        for(SObject sobj : Trigger.new){
            
            MUSW__Deposit__c depositRec = (MUSW__Deposit__c)sobj;
            SObject oldrecord = Trigger.oldMap.get(depositRec.Id);
            MUSW__Deposit__c olddeposit = (MUSW__Deposit__c)oldrecord;
            
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
            for(SObject sobj : trigger.new){
                MUSW__Deposit__c deposit = (MUSW__Deposit__c)sobj;
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
    public void onBeforeDelete() {}
    public void onBeforeInsert() {
        
    }
    public void onBeforeUndelete() {}
    public void onBeforeUpdate() {
        
        set<Id> depositIds =new Set<Id>();
        for(SObject sobj : Trigger.new){
            MUSW__Deposit__c depositRec = (MUSW__Deposit__c)sobj;
            SObject oldrecord = Trigger.oldMap.get(depositRec.Id);
            MUSW__Deposit__c olddeposit = (MUSW__Deposit__c)oldrecord;
            if(olddeposit.MUSW__Available_Amount__c != depositRec.MUSW__Available_Amount__c && depositRec.MUSW__Available_Amount__c < olddeposit.MUSW__Available_Amount__c && depositRec.Overshort_Amount__c != null){ 
                depositRec.Overshort_Amount__c = depositRec.MUSW__Available_Amount__c;
                depositRec.Overshort_Modified__c = True;
                depositRec.Over_short_Old_Amount__c = olddeposit.Overshort_Amount__c;
                depositRec.Previous_Overshort_Updated__c = True;
            }  
            if(olddeposit.MUSW__Available_Amount__c != depositRec.MUSW__Available_Amount__c){ 
                depositRec.Old_Available_Amount__c = olddeposit.MUSW__Available_Amount__c;
                
            }  
        }
        
    }
    
    
}