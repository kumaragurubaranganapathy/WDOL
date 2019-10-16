/**
* Name: FeePaymentTriggerHandler
* Type: Class
* Description: Trigger Handler for MUSW__Fee_Payment__c object being called from FeePaymentTrigger
* Date:        Developer/Company                   Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 08/22/2018   Srikanth Kottam/Deloitte          Initial Creation
**/
public class FeePaymentTriggerHandler implements BGCM.ITriggerHandler{
	public void onAfterDelete() {}
    public void onAfterInsert() {
        if(!DOL_AppUtility.isFeePaymentRunOnce){
            DOL_AppUtility.isFeePaymentRunOnce = true;
            afterMethod();
        }
    }
    public void onAfterUndelete() {}
    public void onAfterUpdate() {
        if(!DOL_AppUtility.isFeePaymentRunOnce){
            DOL_AppUtility.isFeePaymentRunOnce = true;
            afterMethod();
        }
    }
    public void onBeforeDelete() {}
    public void onBeforeInsert() {
        /*
        for(Sobject S:trigger.new){
            s.addError('Payment Error');
         	//System.debug('***s***'+s);
        }
        */		
    }
    public void onBeforeUndelete() {}
    public void onBeforeUpdate() {}
    
    public void afterMethod() {
        //To share Fee Payemnt records
      /*  FeePaymentCreatedByDelegate DelegateController = new FeePaymentCreatedByDelegate(); 
        DelegateController.shareFeePaymentRecords(Trigger.new);*/
        //adding logic from Process builder built for User Story 1966
        List<MUSW__Fee__c> feeListToBeUpdated = new List<MUSW__Fee__c>();
        List<MUSW__Fee_Payment__c> newList = (List<MUSW__Fee_Payment__c>) trigger.new;
        List<MUSW__Fee_Payment__c> feePaymentList = [Select id, MUSW__Receipt__c, MUSW__Fee__c, MUSW__Receipt__r.Agency_Code__c, MUSW__Receipt__r.Voucher_Number__c, MUSW__Receipt__r.MUSW__Payment_Method__c from MUSW__Fee_Payment__c where MUSW__Receipt__r.Agency_Code__c != '' and MUSW__Receipt__r.Voucher_Number__c != '' and MUSW__Receipt__r.MUSW__Payment_Method__c IN ('Voucher','Deposit') and Id In: newList];
        for(MUSW__Fee_Payment__c fp: feePaymentList) {
            if(fp.MUSW__Fee__c != null){
                MUSW__Fee__c feeRec = new MUSW__Fee__c(id = fp.MUSW__Fee__c);
                feeRec.Agency_Code__c = fp.MUSW__Receipt__r.Agency_Code__c;
                feeRec.Voucher_Number__c = fp.MUSW__Receipt__r.Voucher_Number__c;
                feeListToBeUpdated.add(feeRec);
            }
        }

        if(feeListToBeUpdated.size() >0){
            try{
                update feeListToBeUpdated;
            }catch(Exception ex){
                DOL_CreateErrorLog_Exception.logApplicationError(ex);
                throw new AuraHandledException('An error occurred: '+ex.getMessage());
            }
        }
    }

     
}