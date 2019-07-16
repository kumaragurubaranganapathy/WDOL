/**
* Name: ReceiptCreatedbyDelegate
* Type: Class
* Description: Trigger handler class to handle sharing for Receipt records with the 
the community plus user who also happens to be the applicant of a License verification
* Date:        Developer/Company                 	Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 08/22/2018   Srikanth Kottam/Deloitte           Initial Creation
**/
public class ReceiptCreatedbyDelegate {
    /**
	* @Method name   : shareReceiptRecords
	* @Description   : Share the Receipt records when the Delegated Admin is the applicant on the License 
	* @Return Type   : None
	* @Parameter     : Trigger.new
	**/
    public void shareReceiptRecords(List < MUSW__Receipt__c > shareReceiptRecords) {
        List<Id> ReceiptIds = new List<Id>();
        Set <Id> ContactIdsSet = new Set <Id> ();
        SharingUtilityController utilityCOntroller = new SharingUtilityController();
        
        for (MUSW__Receipt__c receipt: shareReceiptRecords){
            ReceiptIds.add(receipt.Id);
            if(receipt.MUSW__Receipt_Paid_By__c!=null){
                ContactIdsSet.add(receipt.MUSW__Receipt_Paid_By__c);
            }
        }
        if(ReceiptIds.size()>0 && ContactIdsSet.size()>0){
            list < Id > contactids = new List < id > ();
            contactids.addAll(ContactIdsSet);
            UtilityCOntroller.ShareRecords_CreatedByDelegate(ContactIds, ReceiptIds, 'MUSW__Receipt__c', 'ReceiptCreatedByDelegate');
        }
    }
}