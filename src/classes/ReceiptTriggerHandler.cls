/**
* Name: ReceiptTriggerHandler
* Type: Class
* Description: Trigger Handler for MUSW__Receipt__c object being called from ReceiptTrigger
* Date:        Developer/Company                   Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 08/22/2018   Srikanth Kottam/Deloitte          Initial Creation
**/
public class ReceiptTriggerHandler implements BGCM.ITriggerHandler{
	public void onAfterDelete() {}
    public void onAfterInsert() {
        //This Method is called when already an AccountContact Record exists on an Account and Receipt records get Created. This Record will be shared with the community Plus User
        //ReceiptUserSharing controller = new ReceiptUserSharing();
        //controller.ReceiptSharing_RecordInsert(Trigger.New);
        //End of ReceiptUserSharing
        
        //Share the Receipt records when the Delegated Admin is the applicant
        ReceiptCreatedbyDelegate DelegateController = new ReceiptCreatedbyDelegate();
        DelegateController.shareReceiptRecords(Trigger.New);
    }
    public void onAfterUndelete() {}
    public void onAfterUpdate() {}
    public void onBeforeDelete() {}
    public void onBeforeInsert() {
        beforeMethod();
    }
    public void onBeforeUndelete() {}
    public void onBeforeUpdate() {
        beforeMethod();
    }
    
    public void beforeMethod(){
        for(sObject sObj : trigger.New){
            MUSW__Receipt__c receipt = (MUSW__Receipt__c) sObj;
            if(receipt.MUSW__Payment_Method__c == 'CC'){
                receipt.MUSW__Payment_Method__c = 'Credit Card';
            }
            if(receipt.MUSW__Card_Type__c == 'MC'){
                receipt.MUSW__Card_Type__c = 'MasterCard';
            }else if(receipt.MUSW__Card_Type__c == 'VISA'){
                receipt.MUSW__Card_Type__c = 'Visa';
            }else if(receipt.MUSW__Card_Type__c == 'AMEX'){
                receipt.MUSW__Card_Type__c = 'Amex';
            }
        }
    }
}