/**
* Name: Permit2TriggerHandler
* Type: Class
* Description: Trigger Handler for MUSW__Permit2__c object being called from Permit2Trigger
* Date:        Developer/Company                   Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
*                       /Deloitte               Initial Creation
* 08/22/2018   Srikanth Kottam/Deloitte           Apex Sharing
**/
public class Permit2TriggerHandler implements BGCM.ITriggerHandler{
    public static user u;
    public Permit2TriggerHandler() {
        u = [Select Id, UserType, Is_Portal_User__c From User where Id = :UserInfo.getUserId()];
    }
    public void onAfterDelete() {}
    public void onAfterInsert() {
        //This method is to run the automation rules
        BGCM.TriggerManager.execute('DRE2_MUSW_Permit2_c', new DRETriggerHandler());
        afterMethod();
        if(!Test.isRunningTest()){
            createBluebeamProjectHelper();
        }
    }
    public void onAfterUndelete() {}
    public void onAfterUpdate() {
        afterMethod();
    }
    public void onBeforeDelete() {}
    public void onBeforeInsert() {
        if (u.Is_Portal_User__c == true) {
            SObjectTriggerHandler handler = new SObjectTriggerHandler(Trigger.New,SObjectTriggerHandler.Action.BeforeInsert);
            handler.process();
        }else{ 
            if(!test.isRunningTest())  {
        //Added to restrict users from updating credential number- Bug#2488
        List<MUSW__Permit2__c> triggerNew = Trigger.New;
        for (MUSW__Permit2__c newPermitRecord : triggerNew) {        
                    if(!Label.Str_System_Number.equals(newPermitRecord.Name)){
                        //throw an error message
                        newPermitRecord.addError(Label.Err_Cannot_change_System_Number);
                    }
                }
        
            
        }
        }
        Notificationdate();
        
        
        beforeMethod();
        
        //This is to generate Intial sequence number with "APP"
        MUSW.SequenceNumber.updateNumbers(Trigger.New, Trigger.Old);
        system.debug('Entered Sequence no');
    }
    public void onBeforeUndelete() {}
    public void onBeforeUpdate() {
        if (u.Is_Portal_User__c == true) {
            SObjectTriggerHandler handler = new SObjectTriggerHandler(Trigger.New,SObjectTriggerHandler.Action.BeforeUpdate);
            handler.process();
        }
        Notificationdate();
        beforeMethod();
        
        //This is to Update sequence number & Automation Rules
        DRESequence();
    }
    
    
    public void afterMethod() {  
        System.debug('in permit after method');
        /* 
* Method to update sumission records based on answers in Permit records      
* Fetching old and new values for the Permit if any
*/
        
        List<MUSW__Permit2__c> triggerOld = Trigger.Old;
        List<MUSW__Permit2__c> triggerNew = Trigger.New;
        //List<MUSW__Permit2__c> licensesForFeeWaiver = new List<MUSW__Permit2__c>();
        Map<Id, MUSW__Permit2__c> permitsInPendingStatusMap = new Map<Id, MUSW__Permit2__c>();
        Set<String> permitTypeInPendingStatusSet = new Set<String>();
        System.debug('trigger size'+triggerNew.size());
        for(Integer i = 0; i < triggerNew.size(); i++) {
            System.debug('in for loop');
            MUSW__Permit2__c permitNew = triggerNew[i];
            
            //get the permit id to update submission list             
            System.debug('permit status '+ permitNew.MUSW__Status__c);
            if(permitNew.MUSW__Status__c == '' || permitNew.MUSW__Status__c == 'Pending') {
                System.debug('permit status is pending or blank');
                
                //If the permit is in pending status- add it to the map
                
                permitsInPendingStatusMap.put(permitNew.Id, permitNew);
                
                /* If the permit is in pending status- add the permit type to the set to avoid 
* duplciation/repetition of the same permit type */
                
                //permitTypeInPendingStatusSet.add(permitNew.Credential_Type__c);
                permitTypeInPendingStatusSet.add(permitNew.Permit_Type__c);
            }
            
        }
        System.debug('permitTypeInPendingStatusSet '+permitTypeInPendingStatusSet);
        
        if(permitsInPendingStatusMap.size() > 0) {
            System.debug('in if size > 0 ');
            
            //Share the records based on custom setttings
            SharingUtilityController sharingController = new SharingUtilityController();
            sharingController.ShareRecordProcessingUtility(Trigger.NewMap.keySet(), 'MUSW__Permit2__c', 'after insert', 'PermitTrigger', Schema.MUSW__Permit2__share.RowCause.Insert_PermitShare__c);
            
            //Share the License records when the Delegated Admin is the applicant on the License
            PermitCreatedByDelegate DelegateController = new PermitCreatedByDelegate();
            DelegateController.sharePermitRecords(TriggerNew);
            
            //Creating a map of permit type and corresponding submission list.
            
            Map<String, List<MUSW__Master_Submission_List__c>> permitTypesSubmissionListMap = new Map<String, List<MUSW__Master_Submission_List__c>>();
            for(MUSW__Master_Submission_List__c masterSubmission: [SELECT Id, External_id__c, Name, Background_Question_Field_API_Name__c,
                                                                   Description_Long__c, Application_Type__c, Permit_Type__c, Program_Area__c, Default__c, Show_For__c,
                                                                   Submission_Type__c, Document_API_Name__c, BG_File_Location_Type__c
                                                                   FROM MUSW__Master_Submission_List__c 
                                                                   WHERE Active__c = TRUE 
                                                                   AND Object__c = :label.API_Permit 
                                                                   AND Permit_Type__c IN :permitTypeInPendingStatusSet 
                                                                   LIMIT 5000]) {
                                                                       System.debug('in second for loop ');                                                                 
                                                                       List<MUSW__Master_Submission_List__c> tempSubmissionList = new List<MUSW__Master_Submission_List__c> ();
                                                                       /* if permit type already exists in the map, then fetch the list of submission list
* records associated with that permit type*/
                                                                       if(permitTypesSubmissionListMap.containsKey(masterSubmission.Permit_Type__c)) {
                                                                           tempSubmissionList = permitTypesSubmissionListMap.get(masterSubmission.Permit_Type__c);
                                                                       }
                                                                       /*1. adding submission list for the permit type in a list                                                      
* 2. If the above 'if condition' was executed, then the new submission list record would be added to the
* existing list */
                                                                       tempSubmissionList.add(masterSubmission);
                                                                       System.debug('tempSubmissionList>>'+tempSubmissionList);
                                                                       //adding permit type and corresponding list in a map
                                                                       permitTypesSubmissionListMap.put(masterSubmission.Permit_Type__c, tempSubmissionList);
                                                                   }
            
            System.debug('permitTypesSubmissionListMap>>'+permitTypesSubmissionListMap);
            Set<String> permitFieldSet = Schema.SObjectType.MUSW__Permit2__c.fields.getMap().keyset();
            System.debug('permitFieldSet>>'+permitFieldSet);
            List<MUSW__Submission__c> submissionUpsertList = new List<MUSW__Submission__c>();
            List<MUSW__Submission__c> submissionDeleteList = new List<MUSW__Submission__c>();
            // Querying existing submissions under permit records and iterating over it to create new submissions
            
            for(MUSW__Permit2__c permit:[Select id,(Select Id, Name, LicenseQuestionKey__c FROM MUSW__Submissions__r) FROM MUSW__Permit2__c WHERE Id = :permitsInPendingStatusMap.keyset()]){
                System.debug('in select permit for loop>>'+permit);
                // Getting new permit instance from Trigger.newMap
                
                MUSW__Permit2__c newPermit = permitsInPendingStatusMap.get(permit.Id);
                System.debug('in select permit for loop>>'+permit);
                //Creating a map of existing submission records
                
                Map<String,MUSW__Submission__c> keyToSubmissionMap = new Map<String, MUSW__Submission__c>();
                for(MUSW__Submission__c submission: permit.MUSW__Submissions__r) {
                    System.debug('in for submission.LicenseQuestionKey__c>>'+submission.LicenseQuestionKey__c);
                    if(submission.LicenseQuestionKey__c != null){
                        keyToSubmissionMap.put(submission.LicenseQuestionKey__c, submission);
                    }
                }
                System.debug('keyToSubmissionMap>>'+keyToSubmissionMap);
                
                // Creating submissions based on License Type
                System.debug('newPermit.Permit_Type__c>>'+newPermit.Permit_Type__c);
                if(permitTypesSubmissionListMap.containsKey(newPermit.Permit_Type__c)) {
                    System.debug('in if 1>>');
                    for(MUSW__Master_Submission_List__c masterSubmission : permitTypesSubmissionListMap.get(newPermit.Permit_Type__c)) {
                        System.debug('in for 1>>');
                        String permitSubmissionComboKey = String.valueOf(newPermit.Id) + String.valueOf(masterSubmission.External_Id__c);
                        // If question is background question type, submission is created based on answer
                        System.debug('permitSubmissionComboKey>>'+permitSubmissionComboKey);
                        if(masterSubmission.Background_Question_Field_API_Name__c != null && permitFieldSet.contains(masterSubmission.Background_Question_Field_API_Name__c.toLowerCase())) {
                            System.debug('in first if---this is right>');
                            String questionAnswer;
                            questionAnswer= (String)newPermit.get(masterSubmission.Background_Question_Field_API_Name__c);
                            
                            // If answer is 'Yes' new submission is created
                            
                            if(questionAnswer!= null && questionAnswer.equalsIgnoreCase('Yes')) { 
                                System.debug('in first if---this is wrong>');
                                if(!keyToSubmissionMap.containsKey(permitSubmissionComboKey)) {
                                    MUSW__Submission__c newSubmission = new MUSW__Submission__c(Name = masterSubmission.Name, Description_Long__c = masterSubmission.Description_Long__c,
                                                                                                LicenseQuestionKey__c = permitSubmissionComboKey, MUSW__Permit2__c = newPermit.Id, Application_Type__c = masterSubmission.Application_Type__c,
                                                                                                Type__c = (masterSubmission.Submission_Type__c == 'Hardcopy: To be Mailed' ? 'Hardcopy' : 'Softcopy'),
                                                                                                Extid_from_Submission_List__c = masterSubmission.External_Id__c, Document_API_Name__c = masterSubmission.Document_API_Name__c, 
                                                                                                Master_Submission_List__c = masterSubmission.Id, MUSW__BG_File_Location_Type__c = masterSubmission.BG_File_Location_Type__c);
                                    
                                    if(newSubmission.MUSW__BG_File_Location_Type__c == null || newSubmission.MUSW__BG_File_Location_Type__c == '') newSubmission.MUSW__BG_File_Location_Type__c = 'Salesforce';
                                    submissionUpsertList.add(newSubmission);
                                }
                            }else if((questionAnswer == null || questionAnswer.equalsIgnoreCase('No')) && keyToSubmissionMap.containsKey(permitSubmissionComboKey)) {
                                //If answer is 'No' and there is an existing submission, it is deleted
                                System.debug('in first if---this is wrong 2>');
                                MUSW__Submission__c oldSubmission = keyToSubmissionMap.get(permitSubmissionComboKey);
                                submissionDeleteList.add(oldSubmission);
                            }
                        }
                        else if(masterSubmission.Default__c) {
                            System.debug('in default permit');
                            // If submisison list is not of question type, corresponding submission is created
                            
                            if(!keyToSubmissionMap.containsKey(permitSubmissionComboKey)) {
                                if(masterSubmission.Show_For__c != null && masterSubmission.Show_For__c.containsIgnoreCase('Permit')) {
                                    MUSW__Submission__c newSubmission = new MUSW__Submission__c(Name = masterSubmission.Name, Description_Long__c = masterSubmission.Description_Long__c,
                                                                                                LicenseQuestionKey__c = permitSubmissionComboKey, MUSW__Permit2__c = newPermit.Id, Application_Type__c = masterSubmission.Application_Type__c,
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
            System.debug('submissionUpsertList>>'+submissionUpsertList);
            try{
                upsert submissionUpsertList LicenseQuestionKey__c;
            } catch(Exception ex){
                System.debug('Exception occured>>>>'+ex);
            }
            
            if(Schema.sObjectType.MUSW__Submission__c.isDeletable()) {
                delete submissionDeleteList;
            }
            
        }
        
    }
    
    /*********************************************************************************
Method Name    : beforeMethod
Description    : This method is called in before Insert & before update 
Return Type    : void
Parameter      : Nil
*********************************************************************************/
    public void beforeMethod(){
        
        // If Request for deletion is checked capture the Date which is used for reporting
        list<MUSW__Permit2__c> triggerNew = trigger.new;
        for(MUSW__Permit2__c per : triggerNew){
            if(per.Request_for_Deletion__c == true){
                per.Request_for_Deletion_Date__c = system.today();
            }
           
            MUSW__Permit2__c permOld = null;
            if(trigger.Old != null){
                permOld = (MUSW__Permit2__c)trigger.OldMap.get(per.Id);
            }
            
            if (permOld != null && permOld.MUSW__Status__c != per.MUSW__Status__c && per.MUSW__Status__c == label.ST_Generate_Fee) {
                per.Attestation_Date__c   = system.today();
            }
            //Copy the application number to a new field only once
            if(permOld != null && String.isBlank(permOld.Application_Number__c)){
                per.Application_Number__c = per.Name;
            }
        }
        Map<Id, Decimal> MapPermitTotalFee = new Map<Id, Decimal>();
        if (trigger.isUpdate) {
            for (AggregateResult ar : [Select MUSW__Permit2__c, SUM(MUSW__Amount__c) amt, SUM(MUSW__Amount_Waived__c) wamt From MUSW__Fee__c where MUSW__Permit2__c IN :trigger.New group by MUSW__Permit2__c]) {
                Decimal feeAmt = (Decimal) ar.get('amt');
                Decimal feeWaivedAmt = (Decimal) ar.get('wamt');
                if (feeAmt == null) feeAmt = 0;
                if (feeWaivedAmt == null) feeWaivedAmt = 0;
                MapPermitTotalFee.put((Id) ar.get('MUSW__Permit2__c'), feeAmt - feeWaivedAmt);
            }
            for(sObject sObj : trigger.New){
                MUSW__Permit2__c perm = (MUSW__Permit2__c) sObj;
                MUSW__Permit2__c permOld = null;
                if(trigger.Old != null){
                    permOld = (MUSW__Permit2__c)trigger.OldMap.get(perm.Id);
                }
                if(perm.MUSW__Total_Fees__c > 0 && perm.MUSW__Total_Balance__c == 0 && (permOld == null || permOld.MUSW__Total_Balance__c > 0)){
                    perm.MUSW__Status__c = 'Submitted';
                    perm.Sub_Status__c = '';
                    perm.App_Submitted_Date__c = Date.today();
                }
                
                Decimal feeAmt = MapPermitTotalFee.get(perm.Id);
                if (perm.Id != null && feeAmt != null && perm.MUSW__Total_Fees__c != feeAmt) {
                    perm.MUSW__Total_Fees__c = feeAmt;
                    
                   /* if(perm.MUSW__Total_Fees__c == perm.MUSW__Total_Payments__c){
                        perm.MUSW__Status__c = 'Submitted';
                        perm.Sub_Status__c = '';
                        perm.App_Submitted_Date__c = Date.today();
                    } */
                }
            } 
        }
    }
    
    /*********************************************************************************
Method Name    : Notificationdate
Description    : This method is updating the Next notification date on license
Return Type    : void
Parameter      : Nil
*********************************************************************************/
    public void Notificationdate() {
        
        List<MUSW__Permit2__c> triggerOld = Trigger.Old;
        List<MUSW__Permit2__c> triggerNew = Trigger.New;
        Map<String, List<Email_Reminder_Setting__mdt>> mapTypeVsCriteria = Email_Utility.getEmailCriteriaMap(label.Str_Permit);
        for (Integer i = 0; i < triggerNew.size(); i++) {
            
            MUSW__Permit2__c permit = triggerNew[i];
            Boolean isExpirationDateChanged = false;
            if (Trigger.isUpdate && permit.MUSW__Expiration_Date__c != triggerold[i].MUSW__Expiration_Date__c) {
                isExpirationDateChanged = true;
            }
            
            //checking the current notification date
            if (permit.Next_Notification_Date__c == null || permit.Next_Notification_Date__c < Date.today() || isExpirationDateChanged) {
                if (permit.MUSW__Expiration_Date__c != null && (permit.Next_Notification_Attempt__c != -1 || isExpirationDateChanged)) {
                    List<Email_Reminder_Setting__mdt> lstCriteria = mapTypeVsCriteria.get(permit.Permit_Type__c);
                    //Updating the next notification date and attempt
                    if (lstCriteria != null) {
                        for (Email_Reminder_Setting__mdt currentEmailSetting : lstCriteria) {
                            if (currentEmailSetting != null) {
                                if (currentEmailSetting.Event__c == label.ERS_Pre_Expiration) {
                                    permit.Next_Notification_Date__c = permit.MUSW__Expiration_Date__c - (Integer)currentEmailSetting.days_from_expiring__C;
                                } else if (currentEmailSetting.Event__c == label.ERS_Post_Expiration) {
                                    permit.Next_Notification_Date__c = permit.MUSW__Expiration_Date__c + (Integer)currentEmailSetting.days_from_expiring__C;
                                }
                                
                                permit.Next_Notification_Attempt__c = currentEmailSetting.Attempt__c;
                                
                                if (permit.Next_Notification_Date__c > Date.today()) {
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
        // Call Automation rules
        BGCM.TriggerManager.execute('DRE2_MUSW_Permit2_c', new DRETriggerHandler());
        // Call Sequence No
        Boolean isSeqNumberChangeReq = false;
                for (sObject sobj : Trigger.New) {
                    MUSW__Permit2__c per = (MUSW__Permit2__c) sobj;
                    MUSW__Permit2__c oldPer = (MUSW__Permit2__c)Trigger.OldMap.get(per.Id);
                    //Status was changed AND old Status is Not Active & Not Conditionally Approved
                    if (Trigger.Old != null && oldPer.MUSW__Status__c != per.MUSW__Status__c &&  oldPer.MUSW__Status__c != 'Active' && oldPer.MUSW__Status__c != 'Conditionally Approved') {
                        // Update Sequence number
                        MUSW.SequenceNumber.updateNumbers(Trigger.new, trigger.old);
                        system.debug('Entered Sequence no');
                    }
                    //Added to restrict users from updating credential number- Bug#2488
                    else if(Trigger.Old != null && oldPer.Name != per.Name){
                        //throw an error message
                        sobj.addError(Label.Err_Number_cannot_be_changed);
                    }
                }    
    }
    private void createBluebeamProjectHelper(){
        MUSW.BlueBeamProjectService.createProjects(Trigger.new);
    }
}