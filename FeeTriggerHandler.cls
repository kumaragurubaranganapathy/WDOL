/**
* Name: FeeTriggerHandler
* Type: Class
* Description: Trigger Handler for MUSW__Fee__c object being called from FeeTrigger
* Date:        Developer/Company                   Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 08/22/2018   Srikanth Kottam/Deloitte          Initial Creation
**/
public class FeeTriggerHandler implements BGCM.ITriggerHandler{
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
        //This Method is called when already an AccountContact Record exists on an Account and Fee records get Created. This Record will be shared with the community Plus User
        if(userinfo.getName()!='System Integration'){
        FeeUsersharing controller = new FeeUsersharing();
        controller.FeeSharing_RecordInsert(Trigger.New);
        //End of FeeUsersharing
        
        //Share the Fee records when the Delegated Admin is the applicant
        FeeCreatedByDelegate DelegateController = new FeeCreatedByDelegate();
        System.debug('Entered fee trigger');
        DelegateController.shareFeeRecords(Trigger.New);
        System.debug('Entered fee trigger again');
        }
    } 
}