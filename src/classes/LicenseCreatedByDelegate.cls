/**
* Name: LicenseCreatedByDelegate
* Type: Class
* Description: Trigger handler class to handle sharing for license records with the 
*			   the community plus user who also happens to be the applicant of a license.
* Date:        Developer/Company                 	Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 08/21/2018   Srikanth Kottam/Deloitte           Initial Creation
**/
public class LicenseCreatedByDelegate {
/**
      * @Method name   : shareLicenseRecords
      * @Description   : Share the License records when the Delegated Admin is the applicant on the License 
      * @Return Type   : None
      * @Parameter     : Trigger.new
    **/
    public void shareLicenseRecords(List < MUSW__License2__c > LicenseShareRecords) {
               
        Map < Id, List<Id> > Applicant_Licenses_Map = new Map < Id, List<Id> >();
        SharingUtilityController utilityCOntroller = new SharingUtilityController();
        Set<Id> LicenseIdsSet = new Set<Id>();
        for(MUSW__License2__c license:LicenseShareRecords)
        {
        	if (license.MUSW__Applicant__c != null) {
                if(!(Applicant_Licenses_Map.containsKey(license.MUSW__Applicant__c)))
                {
                    LicenseIdsSet.add(license.Id);
                    Applicant_Licenses_Map.put(license.MUSW__Applicant__c,new List<Id>());
                }
				Applicant_Licenses_Map.get(license.MUSW__Applicant__c).add(license.Id);
		    }
        }
        if(!Applicant_Licenses_Map.isEmpty())
        {
             List < Id > ContactIds = new List < Id >(Applicant_Licenses_Map.keySet());
             List<Id> LicenseIds = new List<Id>();
             LicenseIds.addAll(LicenseIdsSet);
             UtilityCOntroller.ShareRecords_CreatedByDelegate(ContactIds, LicenseIds, 'MUSW__License2__c', 'CredentialCreatedByDelegate');             
        }
    }
}