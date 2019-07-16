/**
* Name: RenewalCreatedByDelegate
* Type: Class
* Description: Trigger handler class to handle sharing for Renewal records with the 
*  			   the community plus user who also happens to be the applicant of a renewal
* Date:        Developer/Company                 	Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 08/22/2018   Srikanth Kottam/Deloitte           Initial Creation
**/
public class RenewalCreatedByDelegate {
	/**
	* @Method name   : shareRenewalRecords
	* @Description   : Share the Renewal records when the Delegated Admin is the applicant on the Renewal 
	* @Return Type   : None
	* @Parameter     : Trigger.new
	**/
    public void shareRenewalRecords(List<Renewal_Application__c> RenewalShareRecords) {
        
        set <Id> LicenseIds = new set<Id>();
        List<MUSW__License2__c> LicenseList = new List<MUSW__License2__c>();
        set <Id> PermitIds = new set <Id> ();
        List <MUSW__Permit2__c> PermitList = new List <MUSW__Permit2__c> ();
        List <Id> RenewalIds = new List <Id> ();
        Set <Id> ContactIdsSet = new Set <Id> ();
        
        SharingUtilityController utilityCOntroller = new SharingUtilityController();
        for(Renewal_Application__c renewal:RenewalShareRecords) {
            if(renewal.License__c!=null){
                LicenseIds.add(renewal.License__c);
            }else if(renewal.Permit__c != null){
                PermitIds.add(renewal.Permit__c);
            }
            RenewalIds.add(renewal.Id);
        }
        
        if(LicenseIds.size()>0) {
            try{
                LicenseList = [select Id, MUSW__Applicant__c from MUSW__License2__c where Id IN:LicenseIds];
            }
            catch(exception e){
                ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'LicenseRenewalCreatedByDelegate', 'Error Occured Processing Share Records in LicenseRenewalCreatedByDelegate', 'ShareRenewalRecords', 'LicenseRenewalCreatedByDelegate', 'HIGH');
            }
        }
        
        if (PermitIds.size() > 0){
            try{
                PermitList = [select Id, MUSW__Applicant__c from MUSW__Permit2__c where Id IN: PermitIds];
            } 
            catch (exception e){
                ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'LicenseRenewalCreatedByDelegate', 'Error Occured Processing Share Records in LicenseRenewalCreatedByDelegate', 'ShareRenewalRecords', 'LicenseRenewalCreatedByDelegate', 'HIGH');
            }
        }
        
        if(LicenseList.size()>0) {
            for (MUSW__License2__c license: LicenseList){
                if (license.MUSW__Applicant__c != null){
                    ContactIdsSet.add(license.MUSW__Applicant__c);
                }
            }
        }
        
        if(PermitList.size() > 0){
            for(MUSW__Permit2__c permit: PermitList){
                if (permit.MUSW__Applicant__c != null){
                    ContactIdsSet.add(permit.MUSW__Applicant__c);
                }
            }
        }
        
        if (RenewalIds.size() > 0 && ContactIdsSet.size() > 0){
            list <Id> contactids = new List <Id> ();
            contactids.addAll(ContactIdsSet);
            UtilityCOntroller.ShareRecords_CreatedByDelegate(ContactIds, RenewalIds, 'Renewal_Application__c', 'LicenseRenewalCreatedByDelegate');
        }
    }
}