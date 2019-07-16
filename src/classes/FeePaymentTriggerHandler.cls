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
        afterMethod();
    }
    public void onAfterUndelete() {}
    public void onAfterUpdate() {
        afterMethod();
        
    }
    public void onBeforeDelete() {}
    public void onBeforeInsert() {}
    public void onBeforeUndelete() {}
    public void onBeforeUpdate() {}
    
    public void afterMethod() {
        //To share Fee Payemnt records
        FeePaymentCreatedByDelegate DelegateController = new FeePaymentCreatedByDelegate(); 
        DelegateController.shareFeePaymentRecords(Trigger.new);
    } 
}