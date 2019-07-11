/**
* Name: ServiceRequestCreatedByDelegate
* Type: Class
* Description: To handle sharing for Service request records with the community plus user who also happens to be the applicant of a Service Request
* Date:        Developer/Company                 	Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 08/21/2018   Srikanth Kottam/Deloitte           Initial Creation
**/
public without sharing class ServiceRequestCreatedByDelegate {

    /***************************************************************************************************
    * @Description : Share the Verification records when the Delegated Admin is the applicant on the License 
    * @Param       : Trigger.new
    * @Return      : NA
    ****************************************************************************************************/

    public void shareServiceRequestRecords(List < MUSW__Application2__c > SRShareRecords){
        List < MUSW__License2__c > LicenseList = new List < MUSW__License2__c > ();
        List < MUSW__Permit2__c > PermitList = new List < MUSW__Permit2__c > ();
        List < Id > SRIds = new List < Id > ();
        Set < Id > ContactIdsSet = new Set < Id > ();
        SharingUtilityController utilityCOntroller = new SharingUtilityController();
        set < Id > LicenseIds = new set < Id > ();
        set < Id > PermitIds = new set < Id > ();
        
        for (MUSW__Application2__c sr: SRShareRecords){
            if (sr.License__c != null){
                LicenseIds.add(sr.License__c);
            } else if(sr.Permit__c != null){
                PermitIds.add(sr.Permit__c);
            }
            SRIds.add(sr.Id);
        }

        if (LicenseIds.size() > 0){
            try{
                LicenseList = [select Id, MUSW__Applicant__c from MUSW__License2__c where Id IN: LicenseIds];
            } 
            catch (exception e){
                ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'ServiceRequestCreatedByDelegate', 'Error Occured Querying License List in Service request', 'shareServiceRequestRecords', 'ServiceRequestCreatedByDelegate', 'HIGH');
            }
        }
        if (PermitIds.size() > 0){
            try{
                PermitList = [select Id, MUSW__Applicant__c from MUSW__Permit2__c where Id IN: PermitIds];
            } 
            catch (exception e){
                ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'ServiceRequestCreatedByDelegate', 'Error Occured Querying Permit List in Service request', 'shareServiceRequestRecords', 'ServiceRequestCreatedByDelegate', 'HIGH');
            }
        }
        
        if (LicenseList.size() > 0){
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
        system.debug('ContactIdsSet ' + ContactIdsSet);
        if (SRIds.size() > 0 && ContactIdsSet.size() > 0){
            list < Id > contactids = new List < id > ();
            contactids.addAll(ContactIdsSet);
            UtilityCOntroller.ShareRecords_CreatedByDelegate(ContactIds, SRIds, 'MUSW__Application2__c', 'ServiceRequestCreatedByDelegate');
        }
    }
}