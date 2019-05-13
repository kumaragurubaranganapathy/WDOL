/**
* Name: FineUsersharing
* Type: Class
* Description: To handle sharing for Fine records with the delegated admin on the account contact Record
* Date:        Developer/Company                 	Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 08/22/2018   Srikanth Kottam/Deloitte           Initial Creation
**/
public class FineUsersharing {
    /**
     * @Method name   : shareFineRecords
     * @Description   : Prepare Necessary list and pass them to the method that shares the records
     * @Return Type   : None
     * @Parameter     : Trigger.new
     **/
	public void shareFineRecords(List <Fine__c> FineShareRecords) {
        Set <Id> fineIds = new Set <Id>();
        List<Id> fineIdsList = new List<Id>();
        Set<Id> ContactIdsSet = new Set<Id>();
        
        for (Fine__c fineShareRecord: FineShareRecords){
            fineIds.add(fineShareRecord.Id);
            ContactIdsSet.add(fineShareRecord.Contact_Related_to_the_Fine__c);
        }
        if(fineIds.size()>0){
            fineIdsList.addAll(fineIds);
        }
        
        SharingUtilityController utilityCOntroller = new SharingUtilityController();

        if (fineIdsList.size() > 0 && ContactIdsSet.size() > 0) {
            list <Id> contactids = new List <Id> ();
            contactids.addAll(ContactIdsSet);
            UtilityCOntroller.ShareRecords_CreatedByDelegate(ContactIds, fineIdsList, 'Fine__c', 'FineUsersharing');
        }
    }
}