/**
* Name: SubmissionTriggerHandler
* Type: Class
* Description: Trigger Handler for MUSW__Submission__c object being called from SubmissionTrigger
* Date:        Developer/Company                 	Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 08/21/2018   Srikanth Kottam/Deloitte           Initial Creation
**/
public class SubmissionTriggerHandler implements BGCM.ITriggerHandler{
	public void onBeforeDelete(){}
    public void onBeforeInsert(){}
    public void onBeforeUndelete(){}
    public void onBeforeUpdate(){}
    public void onAfterDelete(){}
    public void onAfterInsert(){
       aftermethod();
    }
    public void onAfterUndelete(){}
    public void onAfterUpdate(){
        aftermethod();
    }
    
    Public void aftermethod(){
        //This Method is called when already an AccountContact Record exists on an Account and Submission records get Created. This Record will be shared with the community Plus User
        SubmissionUsersharing controller = new SubmissionUsersharing();
        controller.SubmissionShare_RecordInsert(Trigger.New);
        
        //Share the Submission records when the Delegated Admin is the applicant on the License        
        SubmissionCreatedByDelegate delController = new SubmissionCreatedByDelegate();
        delController.shareSubmissionRecords(Trigger.New);
    }
}