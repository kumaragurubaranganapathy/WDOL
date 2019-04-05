/**
* Name: ReceiptUserSharing
* Type: Class
* Description: To handle sharing for Receipt records with the delegated admin on the account contact Record
* Date:        Developer/Company                 	Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 08/22/2018   Srikanth Kottam/Deloitte           Initial Creation
**/
public class ReceiptUserSharing {
	/**
     * @Method name   : ReceiptSharing_RecordInsert
     * @Description   : Prepare Necessary msp and list and pass them to the method that shares the records
     * @Return Type   : None
     * @Parameter     : Trigger.new
     **/
    public void ReceiptSharing_RecordInsert(List < MUSW__Receipt__c > ReceiptRecords) {
        
        	SharingUtilityController utilityCOntroller = new SharingUtilityController();
        	Set <Id> ReceiptIds = new Set <Id>();
            
            for (MUSW__Receipt__c ReceiptRecord: ReceiptRecords) {
            	ReceiptIds.add(ReceiptRecord.Id);
        	}
        	utilityCOntroller.ShareRecordProcessingUtility(ReceiptIds,'MUSW__Receipt__c','After Insert','ReceiptUserSharing',Schema.MUSW__Receipt__share.RowCause.Insert_Receipt_Share__c);
    }
}