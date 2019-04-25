/**
* Name: SubmissionCreatedByDelegate
* Type: Class
* Description: Trigger handler class to handle sharing for submissions records with the 
*              the community plus user who also happens to be the applicant of a submission
* Date:        Developer/Company                 	Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 08/21/2018   Srikanth Kottam/Deloitte           Initial Creation
**/
public without sharing class SubmissionCreatedByDelegate {
/**
     * @Method name   : shareSubmissionRecords
     * @Description   : Share the submissions records when the Delegated Admin is the applicant on the submission 
     * @Return Type   : None
     * @Parameter     : Trigger.new
    **/
      public void shareSubmissionRecords(List <MUSW__Submission__c> SubmissionShareRecords) {
        
        List<MUSW__License2__c> ListLicenses = new List<MUSW__License2__c>(); 
        List<MUSW__Permit2__c> ListPermits = new List<MUSW__Permit2__c>(); 
        List<Renewal_Application__c> ListRenewals = new List<Renewal_Application__c>(); 
        List<License_Verification__c> ListVerifications = new List<License_Verification__c>(); 
        List<MUSW__Application2__c> ListServiceRequests = new List<MUSW__Application2__c>(); 
        
        List<Id> SubmissionIds = new List<Id>();
        Set <Id> ContactIdsSet = new Set <Id> ();
        SharingUtilityController utilityCOntroller = new SharingUtilityController();
        set <Id> LicenseIds = new set <Id> ();
        set <Id> PermitIds = new set <Id> ();
        set <Id> RenewalIds = new set <Id> ();
        set <Id> VerificationIds = new set <Id> ();
        set <Id> ServiceRequestIds = new set <Id> ();
        List < MUSW__Submission__share > ShareObjectRecords = new List < MUSW__Submission__share > ();
        
        for(MUSW__Submission__c Submission: SubmissionShareRecords)
        {
            if(Submission.MUSW__Application2__c != null)
            {
                ServiceRequestIds.add(Submission.MUSW__Application2__c);
                SubmissionIds.add(Submission.Id);
            }
            else if(Submission.MUSW__License2__c != null)
            {
                LicenseIds.add(Submission.MUSW__License2__c);
                SubmissionIds.add(Submission.Id);
            }
            else if(Submission.MUSW__Permit2__c != null)
            {
                PermitIds.add(Submission.MUSW__Permit2__c);
                SubmissionIds.add(Submission.Id);
            }
            else if(Submission.License_Renewal__c != null)
            {
                RenewalIds.add(Submission.License_Renewal__c);
                SubmissionIds.add(Submission.Id);
            }
         /*   else if(Submission.License_Verification__c != null)
            {
                VerificationIds.add(Submission.License_Verification__c);
                SubmissionIds.add(Submission.Id);
            }  */
        }
        try {
            if(!LicenseIds.isEmpty() && !SubmissionIds.isEmpty())
            {
                ListLicenses = [select Id, MUSW__Applicant__c from MUSW__License2__c where Id IN:LicenseIds];
                
                if(!ListLicenses.isEmpty())
                {
                    for (MUSW__License2__c license: ListLicenses) {
                        ContactIdsSet.add(license.MUSW__Applicant__c);
                    }
                     if(!ContactIdsSet.isEmpty())
                     {
                        list < Id > contactids = new List < id > ();
                        contactids.addAll(ContactIdsSet);
                        UtilityCOntroller.ShareRecords_CreatedByDelegate(ContactIds, SubmissionIds, label.API_Submission, 'SubmissionCreatedByDelegate');
                     }
                }
            }
            else if(!PermitIds.isEmpty() && !SubmissionIds.isEmpty())
            {
                ListPermits = [select Id, MUSW__Applicant__c from MUSW__Permit2__c where Id IN:PermitIds];
                
                if(!ListPermits.isEmpty())
                {
                    for (MUSW__Permit2__c permit: ListPermits) {
                        ContactIdsSet.add(permit.MUSW__Applicant__c);
                    }
                     if(!ContactIdsSet.isEmpty())
                     {
                        list <Id> contactids = new List <Id> ();
                        contactids.addAll(ContactIdsSet);
                        UtilityCOntroller.ShareRecords_CreatedByDelegate(ContactIds, SubmissionIds, label.API_Submission, 'SubmissionCreatedByDelegate');
                     }
                }
            }
            else if(!RenewalIds.isEmpty() && !SubmissionIds.isEmpty())
            {
                ListRenewals = [Select Id,License__r.MUSW__Applicant__c,Applicant__c from Renewal_Application__c where Id IN:RenewalIds];
                
                if(!ListRenewals.isEmpty())
                {
                    for (Renewal_Application__c renewal: ListRenewals) {
                        if(renewal.Applicant__c != null){
                            ContactIdsSet.add(renewal.Applicant__c);
                        }else{
                        ContactIdsSet.add(renewal.License__r.MUSW__Applicant__c);
                        }
                    }
                     if(!ContactIdsSet.isEmpty())
                     {
                        list < Id > contactids = new List < id > ();
                        contactids.addAll(ContactIdsSet);
                        UtilityCOntroller.ShareRecords_CreatedByDelegate(ContactIds, SubmissionIds, label.API_Submission, 'SubmissionCreatedByDelegate');
                     }
                }
            }
        /*    else if(!VerificationIds.isEmpty() && !SubmissionIds.isEmpty())
            {
                ListVerifications = [Select Id,License__r.MUSW__Applicant__c from License_Verification__c where Id IN:VerificationIds];
                
                if(!ListVerifications.isEmpty())
                {
                    for (License_Verification__c verification: ListVerifications) {
                        ContactIdsSet.add(verification.License__r.MUSW__Applicant__c);
                    }
                     if(!ContactIdsSet.isEmpty())
                     {
                        list < Id > contactids = new List < id > ();
                        contactids.addAll(ContactIdsSet);
                        UtilityCOntroller.ShareRecords_CreatedByDelegate(ContactIds, SubmissionIds, label.API_Submission, 'SubmissionCreatedByDelegate');
                     }
                }
            } */
            else if(!ServiceRequestIds.isEmpty() && !SubmissionIds.isEmpty())
            {
                ListServiceRequests = [Select Id,MUSW__Applicant__c,License__r.MUSW__Applicant__c from MUSW__Application2__c where Id IN:ServiceRequestIds];
                
                if(!ListServiceRequests.isEmpty())
                {
                    for (MUSW__Application2__c serviceReq: ListServiceRequests) {
                        ContactIdsSet.add(serviceReq.License__r.MUSW__Applicant__c);
                        ContactIdsSet.add(serviceReq.MUSW__Applicant__c);
                    }
                     if(!ContactIdsSet.isEmpty())
                     {
                        list < Id > contactids = new List < id > ();
                        contactids.addAll(ContactIdsSet);
                        UtilityCOntroller.ShareRecords_CreatedByDelegate(ContactIds, SubmissionIds, label.API_Submission, 'SubmissionCreatedByDelegate');
                     }
                }
            }
            

        }
        catch(Exception e)
        {
            ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'User', 'Error While Submissions to Share Object', 'Query Parent Object Logic', 'SubmissionCreatedByDelegate', 'HIGH');
        }
        
      }
}