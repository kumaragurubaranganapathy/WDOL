/**
* Name: License2TriggerHandler
* Type: Class
* Description: Trigger Handler for MUSW__License2__c object being called from License2_Trigger
* Date:        Developer/Company                    Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 06/13/2018   Sharad Maheshwari/Deloitte           Initial Creation
* 09/25/2018   Srikanth Kottam/Deloitte             Control Sequence Number & DRE triggering
**/

public class License2TriggerHandler implements BGCM.ITriggerHandler {
    public static user u;
    public License2TriggerHandler() {
        u = [Select Id, UserType, Is_Portal_User__c From User where Id = :UserInfo.getUserId()];
    }
    public void onAfterDelete() {}
    public void onAfterInsert() {
        //This method is to run the automation rules
        BGCM.TriggerManager.execute('DRE2_MUSW_License2_c', new DRETriggerHandler());
        
        /*Calling the after method to create submissions*/        
        afterMethod();
    }
    public void onAfterUndelete() {}
    public void onAfterUpdate() {
        afterMethod();
    }
    public void onBeforeDelete() {}
    public void onBeforeInsert() {
        if (u.Is_Portal_User__c == true) {
            //This method is for base validation on license details provided by the Applicant
            SObjectTriggerHandler handler = new SObjectTriggerHandler(Trigger.New,SObjectTriggerHandler.Action.BeforeInsert);
            handler.process();
        }else{
            if(!test.isRunningTest()){
            //Added to restrict users from updating credential number- Bug#2488
        List<MUSW__License2__c> triggerNew = Trigger.New;
        for (MUSW__License2__c newLicenseRecord : triggerNew) {        
                    if(!Label.Str_System_Number.equals(newLicenseRecord.Name)){
                        //throw an error message
                        newLicenseRecord.addError(Label.Err_Cannot_change_System_Number);
                    }
                }
        
        
            
        }
        }
        
        beforeMethod();
        
        //This is to generate Intial sequence number with "APP"
        MUSW.SequenceNumber.updateNumbers(Trigger.New, Trigger.Old);
        
        Notificationdate();
    }
    public void onBeforeUndelete() {}
    public void onBeforeUpdate() {
        if (u.Is_Portal_User__c == true) {
            //This method is for base validation on license details provided by the Applicant
            SObjectTriggerHandler handler = new SObjectTriggerHandler(Trigger.New,SObjectTriggerHandler.Action.beforeupdate);               
            handler.process();
        }
        beforeMethod();
        
        //This is to Update sequence number & Automation Rules
        DRESequence();
        
        Notificationdate();
    }
    
    public void afterMethod() {        
        /* 
* Method to update sumission records based on answers in License records         
* Fetching old and new values for the License if any
*/
        
        List<MUSW__License2__c> triggerOld = Trigger.Old;
        List<MUSW__License2__c> triggerNew = Trigger.New;
        List<MUSW__License2__c> licensesForFeeWaiver = new List<MUSW__License2__c>();
        Map<Id, MUSW__License2__c> licensesInPendingStatusMap = new Map<Id, MUSW__License2__c>();
        //Map<String, String> credentialApplicationMethodMap = new Map<String, String>();
        Set<String> credentialInPendingStatusSet = new Set<String>();
        Set<String> applicationMethodSet = new Set<String>();
        System.debug('trigger size'+triggerNew.size());
        for(Integer i = 0; i < triggerNew.size(); i++) {
            System.debug('in for loop');
            MUSW__License2__c licenseNew = triggerNew[i];
            //get the license id to update submission list             
            System.debug('license status '+ licenseNew.MUSW__Status__c);
            if(licenseNew.MUSW__Status__c == '' || licenseNew.MUSW__Status__c == 'Pending') {
                System.debug('license status is pending or blank');
                
                //If the license is in pending status- add it to the map
                
                licensesInPendingStatusMap.put(licenseNew.Id, licenseNew);
                
                /* If the license is in pending status- add the license type to the set to avoid 
* duplciation/repetition of the same license type */
                
                //licenseTypesInPendingStatusSet.add(licenseNew.Credential_Type__c);
                credentialInPendingStatusSet.add(licenseNew.Credential__c);
                applicationMethodSet.add(licenseNew.Application_Method__c);
            }
            
        }
        
        if(licensesInPendingStatusMap.size() > 0) {
            System.debug('in if size > 0 ');
            
            //Share the records based on custom setttings
            SharingUtilityController sharingController = new SharingUtilityController();
            sharingController.ShareRecordProcessingUtility(Trigger.NewMap.keySet(), 'MUSW__License2__c', 'after insert', 'LicenseTrigger', Schema.MUSW__License2__share.RowCause.Insert_CredentialShare__c);
            
            //Share the License records when the Delegated Admin is the applicant on the License
            LicenseCreatedByDelegate DelegateController = new LicenseCreatedByDelegate();
            DelegateController.shareLicenseRecords(TriggerNew);
            
            //Creating a map of license type and corresponding submission list.
            
            Map<String, List<MUSW__Master_Submission_List__c>> licenseTypesSubmissionListMap = new Map<String, List<MUSW__Master_Submission_List__c>>();
            for(MUSW__Master_Submission_List__c masterSubmission: [SELECT Id, External_id__c, Name, Background_Question_Field_API_Name__c,
                                                                   Description_Long__c, Application_Type__c, Credential_Type__c, Credential__c, Default__c, Show_For__c,Question__r.External_Id__c,Expected_Answer__c,
                                                                   Submission_Type__c, Document_API_Name__c, Application_Method__c, BG_File_Location_Type__c
                                                                   FROM MUSW__Master_Submission_List__c 
                                                                   WHERE Active__c = TRUE 
                                                                   AND Object__c = :label.API_License2 
                                                                   AND Credential__c IN :credentialInPendingStatusSet
                                                                   AND Application_Method__c IN :applicationMethodSet
                                                                   LIMIT 5000]) {
                                                                       System.debug('in second for loop ');                                                                 
                                                                       List<MUSW__Master_Submission_List__c> tempSubmissionList = new List<MUSW__Master_Submission_List__c> ();
                                                                       /* if license type already exists in the map, then fetch the list of submission list
* records associated with that license type*/
                                                                       if(licenseTypesSubmissionListMap.containsKey(masterSubmission.Credential__c)) {
                                                                           tempSubmissionList = licenseTypesSubmissionListMap.get(masterSubmission.Credential__c);
                                                                       }
                                                                       /*1. adding submission list for the license type in a list                                                      
* 2. If the above 'if condition' was executed, then the new submission list record would be added to the
* existing list */
                                                                       tempSubmissionList.add(masterSubmission);
                                                                       //adding license type and corresponding list in a map
                                                                       licenseTypesSubmissionListMap.put(masterSubmission.Credential__c, tempSubmissionList);
                                                                   }
            
            Set<String> licenseFieldSet = Schema.SObjectType.MUSW__License2__c.fields.getMap().keyset();
            system.debug('licenseFieldSet : '+licenseFieldSet );
            List<MUSW__Submission__c> submissionUpsertList = new List<MUSW__Submission__c>();
            List<MUSW__Submission__c> submissionDeleteList = new List<MUSW__Submission__c>();
            // Querying existing submissions under license records and iterating over it to create new submissions
            
            for(MUSW__License2__c license:[Select id,(Select Id, Name, LicenseQuestionKey__c FROM MUSW__Submissions__r) FROM MUSW__License2__c WHERE Id = :licensesInPendingStatusMap.keyset()]){
                
                // Getting new license instance from Trigger.newMap
                
                MUSW__License2__c newLicense = licensesInPendingStatusMap.get(license.Id);
                List <Answer__c> answerList = [Select id, External_id_of_Question__c, License__c, Answer_Text__c FROM Answer__c where License__c =: newLicense.Id ];
                //Creating a map of existing submission records
                
                Map<String,MUSW__Submission__c> keyToSubmissionMap = new Map<String, MUSW__Submission__c>();
                for(MUSW__Submission__c submission: license.MUSW__Submissions__r) {
                    if(submission.LicenseQuestionKey__c != null){
                        keyToSubmissionMap.put(submission.LicenseQuestionKey__c, submission);
                    }
                }
                
                // Creating submissions based on License Type
                
                if(licenseTypesSubmissionListMap.containsKey(newLicense.Credential__c)) {
                    for(MUSW__Master_Submission_List__c masterSubmission : licenseTypesSubmissionListMap.get(newLicense.Credential__c)) {
                        String licenseSubmissionComboKey = String.valueOf(newLicense.Id) + String.valueOf(masterSubmission.External_Id__c);
                        // If question is background question type, submission is created based on answer
                        
                        if(masterSubmission.Background_Question_Field_API_Name__c != null && licenseFieldSet.contains(masterSubmission.Background_Question_Field_API_Name__c.toLowerCase())) {
                            String questionAnswer;
                            questionAnswer= (String)newLicense.get(masterSubmission.Background_Question_Field_API_Name__c);
                            system.debug('questionAnswer : '+questionAnswer);
                            // If answer is 'Yes' new submission is created
                            
                            if(questionAnswer!= null && questionAnswer.equalsIgnoreCase('Yes')) { 
                                if(!keyToSubmissionMap.containsKey(licenseSubmissionComboKey)) {
                                    MUSW__Submission__c newSubmission = new MUSW__Submission__c(Name = masterSubmission.Name, Description_Long__c = masterSubmission.Description_Long__c,
                                                                                                LicenseQuestionKey__c = licenseSubmissionComboKey, MUSW__License2__c = newLicense.Id, Application_Type__c = masterSubmission.Application_Type__c,
                                                                                                Type__c = (masterSubmission.Submission_Type__c =='Hardcopy: To be Mailed' ? 'Hardcopy: To be Mailed' : 'Softcopy: To be Uploaded'),
                                                                                                Extid_from_Submission_List__c = masterSubmission.External_Id__c, Document_API_Name__c = masterSubmission.Document_API_Name__c, 
                                                                                                Master_Submission_List__c = masterSubmission.Id, MUSW__BG_File_Location_Type__c = masterSubmission.BG_File_Location_Type__c);
                                    
                                    if(newSubmission.MUSW__BG_File_Location_Type__c == null || newSubmission.MUSW__BG_File_Location_Type__c == '') newSubmission.MUSW__BG_File_Location_Type__c = 'Salesforce';
                                    submissionUpsertList.add(newSubmission);
                                }
                            }else if((questionAnswer == null || questionAnswer.equalsIgnoreCase('No')) && keyToSubmissionMap.containsKey(licenseSubmissionComboKey)) {
                                //If answer is 'No' and there is an existing submission, it is deleted
                                
                                MUSW__Submission__c oldSubmission = keyToSubmissionMap.get(licenseSubmissionComboKey);
                                submissionDeleteList.add(oldSubmission);
                            }
                        }
                        //To create attachments based on question answer
                        for(Answer__c ans : answerList){
                            if(masterSubmission.Question__r.External_Id__c == ans.External_id_of_Question__c &&  masterSubmission.Background_Question_Field_API_Name__c == null && !masterSubmission.Default__c  ){
                                if(masterSubmission.Expected_Answer__c == ans.Answer_Text__c ){
                                    if(!keyToSubmissionMap.containsKey(licenseSubmissionComboKey)) {
                                        MUSW__Submission__c newSubmission = new MUSW__Submission__c(Name = masterSubmission.Name, Description_Long__c =       masterSubmission.Description_Long__c,
                                                                                                LicenseQuestionKey__c = licenseSubmissionComboKey, MUSW__License2__c = newLicense.Id, Application_Type__c = masterSubmission.Application_Type__c,
                                                                                                Type__c = (masterSubmission.Submission_Type__c =='Hardcopy: To be Mailed' ? 'Hardcopy: To be Mailed' : 'Softcopy: To be Uploaded'),
                                                                                                Extid_from_Submission_List__c = masterSubmission.External_Id__c, Document_API_Name__c = masterSubmission.Document_API_Name__c, 
                                                                                                Master_Submission_List__c = masterSubmission.Id, MUSW__BG_File_Location_Type__c = masterSubmission.BG_File_Location_Type__c);
                                    
                                        if(newSubmission.MUSW__BG_File_Location_Type__c == null || newSubmission.MUSW__BG_File_Location_Type__c == '') newSubmission.MUSW__BG_File_Location_Type__c = 'Salesforce';
                                        submissionUpsertList.add(newSubmission);
                                        
                                    }
                                }
                                else if(masterSubmission.Expected_Answer__c != ans.Answer_Text__c  && keyToSubmissionMap.containsKey(licenseSubmissionComboKey)){
                                    //If answer is not equal to expected and there is an existing submission, it is deleted
                                
                                    MUSW__Submission__c oldSubmission = keyToSubmissionMap.get(licenseSubmissionComboKey);
                                    submissionDeleteList.add(oldSubmission);
                                }
                            }
                        }
                        if(masterSubmission.Default__c) {
                            // If submisison list is not of question type, corresponding submission is created
                            
                            if(!keyToSubmissionMap.containsKey(licenseSubmissionComboKey)) {
                                if(masterSubmission.Show_For__c != null && masterSubmission.Show_For__c.containsIgnoreCase('Credential')) {
                                    MUSW__Submission__c newSubmission = new MUSW__Submission__c(Name = masterSubmission.Name, Description_Long__c = masterSubmission.Description_Long__c,
                                                                                                LicenseQuestionKey__c = licenseSubmissionComboKey, MUSW__License2__c = newLicense.Id, Application_Type__c = masterSubmission.Application_Type__c,
                                                                                                Type__c = (masterSubmission.Submission_Type__c =='Hardcopy: To be Mailed' ? 'Hardcopy: To be Mailed' : 'Softcopy: To be Uploaded'),
                                                                                                MUSW__Required__c = masterSubmission.Default__c, Extid_from_Submission_List__c = masterSubmission.External_Id__c,
                                                                                                Document_API_Name__c = masterSubmission.Document_API_Name__c, Master_Submission_List__c = masterSubmission.Id,
                                                                                                MUSW__BG_File_Location_Type__c = masterSubmission.BG_File_Location_Type__c);
                                    
                                    if(newSubmission.MUSW__BG_File_Location_Type__c == null || newSubmission.MUSW__BG_File_Location_Type__c == '') newSubmission.MUSW__BG_File_Location_Type__c = 'Salesforce';
                                    submissionUpsertList.add(newSubmission);
                                }
                                
                            }
                        }
                    }
                }
            }
            
            upsert submissionUpsertList LicenseQuestionKey__c;
           // if(Schema.sObjectType.MUSW__Submission__c.isDeletable()) {
                delete submissionDeleteList;
            //}
            
        }
        
    }
    
    public void beforeMethod() {
        //Verify if Total Fee was updated correctly
        Map<Id, Decimal> MapLicenseTotalFee = new Map<Id, Decimal>();
        if (trigger.isUpdate) {
            for (AggregateResult ar : [Select MUSW__License2__c, SUM(MUSW__Amount__c) amt, SUM(MUSW__Amount_Waived__c) wamt From MUSW__Fee__c where MUSW__License2__c IN :trigger.New group by MUSW__License2__c]) {
                Decimal feeAmt = (Decimal) ar.get('amt');
                Decimal feeWaivedAmt = (Decimal) ar.get('wamt');
                if (feeAmt == null) feeAmt = 0;
                if (feeWaivedAmt == null) feeWaivedAmt = 0;
                mapLicenseTotalFee.put((Id) ar.get('MUSW__License2__c'), feeAmt - feeWaivedAmt);
            }
            
            // If Request for deletion is checked capture the Date which is used for reporting
            list<MUSW__License2__c> triggerNew = trigger.new;
            for(MUSW__License2__c lic : triggerNew){
                if(lic.Request_for_Deletion__c == true){
                    lic.Request_for_Deletion_Date__c = system.today();
                }
            }
        }
        
        //Set the App Submitted Date
        for(sObject sObj : trigger.New){
            MUSW__License2__c lic = (MUSW__License2__c) sObj;
            MUSW__License2__c licOld = null;
            if(trigger.Old != null){
                licOld = (MUSW__License2__c)trigger.OldMap.get(lic.Id);
            }
            if(lic.MUSW__Total_Fees__c > 0 && lic.MUSW__Total_Balance__c == 0 && lic.MUSW__Status__c == label.ST_Generate_Fee && (licOld == null || licOld.MUSW__Total_Balance__c > 0)){
                lic.MUSW__Status__c = 'Submitted';
                lic.App_Submitted_Date__c = Date.today();
            }
            
            //Copy the application number to a new field only once
            if(licOld != null && String.isBlank(licOld.Application_Number__c)){
                lic.Application_Number__c = lic.Name;
            }
            
            if (licOld != null && licOld.MUSW__Status__c != lic.MUSW__Status__c && lic.MUSW__Status__c == label.ST_Submitted) {
                lic.Attestation_Date__c   = system.today();
            }
            
            if ((licOld != null && !licOld.No_Fee__c) &&
                (licOld.MUSW__Status__c != lic.MUSW__Status__c && lic.MUSW__Status__c == label.ST_Generate_Fee)) {
                    lic.Attestation_Date__c   = system.today();
                    
                }
            
            Decimal feeAmt = mapLicenseTotalFee.get(lic.Id);
            if (lic.Id != null && feeAmt != null && lic.MUSW__Total_Fees__c != feeAmt) {
                lic.MUSW__Total_Fees__c = feeAmt;
                
                if(lic.MUSW__Total_Fees__c == lic.MUSW__Total_Payments__c){
                    lic.MUSW__Status__c = 'Submitted';
                    lic.App_Submitted_Date__c = Date.today();
                }
            }
        } 
        
        
        /*below code calls FeeWaiver class to update No Fee required field on License if the applicant is eligible for Fee waiver */
        /*List<MUSW__License2__c> triggerNew = Trigger.New;
List<MUSW__License2__c> licensesForFeeWaiver = new List<MUSW__License2__c>();
Map<Id, MUSW__License2__c> contactMap = new Map<Id, MUSW__License2__c>();

for(MUSW__License2__c licenseNew: triggerNew){
contactMap.put(licenseNew.MUSW__Applicant__c, licenseNew);
}
List<Contact> listOfContacts = [select id, Served_in_Military__c from Contact where id in :contactMap.keyset() and Served_in_Military__c = 'Yes']; 
System.debug('listOfContacts size' +listOfContacts.size());
for(Contact con: listOfContacts){
licensesForFeeWaiver.add(contactMap.get(con.id));
}
System.debug('licensesForFeeWaiver>>>>>>>>>>>>>>' +licensesForFeeWaiver);
Fee_Waiver fWaiver = new Fee_Waiver();
fWaiver.UpdateNoFeeRequired(licensesForFeeWaiver, 'Credential'); */
        /* List<MUSW__License2__c> triggerNew = Trigger.New;
for(MUSW__License2__c licenseNew: triggerNew){
if(licenseNew.DVA_Voucher_code__c != '' && licenseNew.DVA_Voucher_code__c != Null){
licenseNew.No_Fee_Required__c = true;
}
} */
    } 
    
    /*********************************************************************************
Method Name    : Notificationdate
Description    : This method is updating the Next notification date on license
Return Type    : void
Parameter      : Nil
*********************************************************************************/
    public void Notificationdate() {
        
        List<MUSW__License2__c> triggerOld = Trigger.Old;
        List<MUSW__License2__c> triggerNew = Trigger.New;
        Map<String, List<Email_Reminder_Setting__mdt>> mapTypeVsCriteria = Email_Utility.getEmailCriteriaMap(label.Str_Credential);
        for (Integer i = 0; i < triggerNew.size(); i++) {
            
            MUSW__License2__c license = triggerNew[i];
            Boolean isExpirationDateChanged = false;
            if (Trigger.isUpdate && license.MUSW__Expiration_Date__c != triggerold[i].MUSW__Expiration_Date__c) {
                isExpirationDateChanged = true;
            }
            
            //checking the current notification date
            if (license.Next_Notification_Date__c == null || license.Next_Notification_Date__c < Date.today() || isExpirationDateChanged) {
                if (license.MUSW__Expiration_Date__c != null && (license.Next_Notification_Attempt__c != -1 || isExpirationDateChanged)) {
                    List<Email_Reminder_Setting__mdt> lstCriteria = mapTypeVsCriteria.get(license.Credential__c);
                    //Updating the next notification date and attempt
                    if (lstCriteria != null) {
                        for (Email_Reminder_Setting__mdt currentEmailSetting : lstCriteria) {
                            if (currentEmailSetting != null) {
                                if (currentEmailSetting.Event__c == label.ERS_Pre_Expiration) {
                                    license.Next_Notification_Date__c = license.MUSW__Expiration_Date__c - (Integer)currentEmailSetting.days_from_expiring__C;
                                } else if (currentEmailSetting.Event__c == label.ERS_Post_Expiration) {
                                    license.Next_Notification_Date__c = license.MUSW__Expiration_Date__c + (Integer)currentEmailSetting.days_from_expiring__C;
                                }
                                
                                license.Next_Notification_Attempt__c = currentEmailSetting.Attempt__c;
                                
                                if (license.Next_Notification_Date__c > Date.today()) {
                                    break;
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    /*********************************************************************************
    Method Name    : DRESequence
    Description    : This method is to call Basic gov Sequence number and DRE .
    Return Type    : void
    Parameter      : Nil
    *********************************************************************************/
    Private Void DRESequence(){
        String actionType = (Trigger.isUpdate) ? 'Update':
            ((Trigger.isInsert) ? 'Insert' : 'Delete');
        Boolean isSeqNumberChangeReq = false;
                for (sObject sobj : Trigger.New) {
                    MUSW__License2__c lic = (MUSW__License2__c) sobj;
                    MUSW__License2__c oldLic = (MUSW__License2__c)Trigger.OldMap.get(lic.Id);
                    //Status was changed AND old Status is Not Active
                    if (Trigger.Old != null && oldLic.MUSW__Status__c != lic.MUSW__Status__c &&  oldLic.MUSW__Status__c != 'Active') {
                        // Update Sequence number
                        MUSW.SequenceNumber.updateNumbers(Trigger.new, trigger.old);
                    }
                    //Added to restrict users from updating credential number- Bug#2488
                    else if(Trigger.Old != null && oldLic.Name != lic.Name){
                        //throw an error message
                        sobj.addError(Label.Err_Number_cannot_be_changed);
                    }
                }    
        // Call Automation rules
        BGCM.TriggerManager.execute('DRE2_MUSW_License2_c', new DRETriggerHandler());
    }
    
}