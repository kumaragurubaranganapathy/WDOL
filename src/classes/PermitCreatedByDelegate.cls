/**
* Name: PermitCreatedByDelegate
* Type: Class
* Description: Trigger handler class to handle sharing for permit records with the 
*			   the community plus user who also happens to be the applicant of a license.
* Date:        Developer/Company                 	Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 08/21/2018   Srikanth Kottam/Deloitte           Initial Creation
**/
public class PermitCreatedByDelegate {
/**
      * @Method name   : sharePermitRecords
      * @Description   : Share the Permit records when the Delegated Admin is the applicant on the Permit 
      * @Return Type   : None
      * @Parameter     : Trigger.new
    **/
    public void sharePermitRecords(List < MUSW__Permit2__c > PermitShareRecords) {
               
        Map < Id, List<Id> > Applicant_Permit_Map = new Map < Id, List<Id> >();
        SharingUtilityController utilityCOntroller = new SharingUtilityController();
        Set<Id> PermitIdsSet = new Set<Id>();
        for(MUSW__Permit2__c permit : PermitShareRecords)
        {
        	if (permit.MUSW__Applicant__c != null) {
                if(!(Applicant_Permit_Map.containsKey(permit.MUSW__Applicant__c)))
                {
                    PermitIdsSet.add(permit.Id);
                    Applicant_Permit_Map.put(permit.MUSW__Applicant__c,new List<Id>());
                }
				Applicant_Permit_Map.get(permit.MUSW__Applicant__c).add(permit.Id);
		    }
        }
        if(!Applicant_Permit_Map.isEmpty())
        {
             List < Id > ContactIds = new List < Id >(Applicant_Permit_Map.keySet());
             List<Id> PermitIds = new List<Id>();
             PermitIds.addAll(PermitIdsSet);
             UtilityCOntroller.ShareRecords_CreatedByDelegate(ContactIds, PermitIds, 'MUSW__Permit2__c', 'PermitCreatedByDelegate');             
        }
    }
}