/**
* Name: PracelCreatedByDelegate
* Type: Class
* Description: Tto handle sharing for Parcel records with the the community plus user who also happens to be the applicant of a Parcel
* Date:        Developer/Company                 	Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 08/22/2018   Srikanth Kottam/Deloitte           Initial Creation
**/
public class PracelCreatedByDelegate {
	/***************************************************************************************************
	* @Method name   : shareParcelRecords
	* @Description   : Share the Parcel records when the Delegated Admin is the applicant on the Parcel 
	* @Return Type   : None
	* @Parameter     : Trigger.new
	****************************************************************************************************/
    public void shareParcelRecords(List < MUSW__Parcel__c > shareParcelRecords) {
        Set<Id> ContactIdsSet = new Set<Id>();
        List<Id> ParcelIds = new List<Id>();
        SharingUtilityController utilityCOntroller = new SharingUtilityController();
        for (MUSW__Parcel__c parcel: shareParcelRecords) {
            if (parcel.MUSW__Primary_Contact__c != null) {
                ContactIdsSet.add(parcel.MUSW__Primary_Contact__c);
                ParcelIds.add(parcel.Id);
            }
        }
        
        if (ParcelIds.size() > 0 && ContactIdsSet.size()>0) {
            list < Id > contactids = new List < id > ();
            contactids.addAll(ContactIdsSet);
            
            UtilityCOntroller.ShareRecords_CreatedByDelegate(contactids, ParcelIds, 'MUSW__Parcel__c', 'ParcelCreatedByDelegate');
        }
    }
}