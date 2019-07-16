/**
* Name: RenewalUserSharing
* Type: Class
* Description: To handle sharing for Renewal records with the delegated admin on the account contact Record
* Date:        Developer/Company                 	Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 08/22/2018   Srikanth Kottam/Deloitte           Initial Creation
**/
public class RenewalUserSharing {
	/**
     * @Method name   : RenewalSharing_RecordInsert
     * @Description   : Prepare Necessary msp and list and pass them to the method that shares the records
     * @Return Type   : None
     * @Parameter     : Trigger.new
     **/
    public void RenewalSharing_RecordInsert(List<Renewal_Application__c> RenewalRecords){
        	SharingUtilityController utilityCOntroller = new SharingUtilityController();
        	Set < Id > RenewalIds = new Set < Id >();
            for (Renewal_Application__c RenewalRecord: RenewalRecords) {
                RenewalIds.add(RenewalRecord.Id);
            }
        	utilityCOntroller.ShareRecordProcessingUtility(RenewalIds,'Renewal_Application__c','After Insert','RenewalUserSharing',Schema.Renewal_Application__share.RowCause.Insert_Renewal_Share__c);
   }
}