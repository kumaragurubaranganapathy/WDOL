/**
* Name: FeeUsersharing
* Type: Class
* Description: To handle sharing for Fee records with the delegated admin on the account contact Record
* Date:        Developer/Company                 	Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 08/22/2018   Srikanth Kottam/Deloitte           Initial Creation
**/
public class FeeUsersharing {
	/**
     * @Method name   : FeeSharing_RecordInsert
     * @Description   : Prepare Necessary msp and list and pass them to the method that shares the records
     * @Return Type   : None
     * @Parameter     : Trigger.new
     **/
    public void FeeSharing_RecordInsert(List < MUSW__Fee__c > feeShareList) {
        SharingUtilityController utilityCOntroller = new SharingUtilityController();
        Set < Id > feeIds = new Set < Id >();
        List<Id> feeIdsList = new List<Id>();
        for (MUSW__Fee__c feeShareRecord: feeShareList) {
           feeIds.add(feeShareRecord.Id);
        }
        utilityCOntroller.ShareRecordProcessingUtility(feeIds, 'MUSW__Fee__c', 'After Insert', 'FeeUsersharing', Schema.MUSW__Fee__share.RowCause.Insert_Fee_Share__c);          
     }   
}