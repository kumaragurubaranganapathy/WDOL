/**
* Name: SubmissionUsersharing
* Type: Class
* Description: To handle sharing for submission records with the delegated admin on the account contact Record
* Date:        Developer/Company                 	Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 08/21/2018   Srikanth Kottam/Deloitte           Initial Creation
**/
public without sharing class SubmissionUsersharing {
	/**
     * @Method name   : SubmissionShare_RecordInsert
     * @Description   : Prepare Necessary msp and list and pass them to the method that shares the records
     * @Return Type   : None
     * @Parameter     : Trigger.new
     **/
    public void SubmissionShare_RecordInsert(List < MUSW__Submission__c > SubmissionShareList) {
            
			SharingUtilityController utilityCOntroller = new SharingUtilityController();
        	Set <Id> submissionIds = new Set <Id>();
            List<Id> submissionIdsList = new List<Id>();
            for (MUSW__Submission__c submissionRecord: SubmissionShareList) {
                submissionIds.add(submissionRecord.Id);
            }
        	utilityCOntroller.ShareRecordProcessingUtility(submissionIds, 'MUSW__Submission__c','After Insert','SubmissionUsersharing',Schema.MUSW__Submission__share.RowCause.Insert_Submission_Share__c);
    }
}