/**
* Name: ParcelUsersharing
* Type: Class
* Description: To handle sharing for parcel records with the delegated admin on the account contact Record
* Date:        Developer/Company                 	Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 08/22/2018   Srikanth Kottam/Deloitte           Initial Creation
**/

public class ParcelUsersharing {
	/**
         * @Method name   : ParcelSharing_RecordInsert
         * @Description   : Prepare Necessary msp and list and pass them to the method that shares the records
         * @Return Type   : None
         * @Parameter     : Trigger.new
         **/
        public void ParcelSharing_RecordInsert(List <MUSW__Parcel__c> parcelShareList) {
            
            SharingUtilityController utilityCOntroller = new SharingUtilityController();
            Set <Id> ParcelIds = new Set <Id>();
            List<Id> ParcelIdsList = new List<Id>();
            for (MUSW__Parcel__c parcelShareShareRecord: parcelShareList) {
                ParcelIds.add(parcelShareShareRecord.Id);
            }
            utilityCOntroller.ShareRecordProcessingUtility(ParcelIds,'MUSW__Parcel__c','After Insert','ParcelUsersharing',Schema.MUSW__Parcel__share.RowCause.Insert_Parcel_Share__c);

        }
}