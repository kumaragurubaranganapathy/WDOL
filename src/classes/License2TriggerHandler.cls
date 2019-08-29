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
    public static boolean runAgain = true;
    public static boolean runOnce = false;
    public License2TriggerHandler() {
        u = [Select Id, UserType, Is_Portal_User__c From User where Id = :UserInfo.getUserId()];
    }
    
    public void onAfterDelete() {}
    public void onAfterInsert() {
        //This method is to run the automation rules
        BGCM.TriggerManager.execute('DRE2_MUSW_License2_c', new DRETriggerHandler());
        
        /*Calling the after method to create submissions*/   
        if(runAgain == true) {
            runAgain= false;
            afterMethod();
        }
       
            
    }
    public void onAfterUndelete() {}
    public void onAfterUpdate() {
     if(runAgain == true) {
         runAgain= false;
         afterMethod();
        }

    }
    public void onBeforeDelete() {}
    public void onBeforeInsert() {
        if (u.Is_Portal_User__c == true) {
            //This method is for base validation on license details provided by the Applicant
           
        }else{
            //if(!test.isRunningTest()){
            //Added to restrict users from updating credential number- Bug#2488
        List<MUSW__License2__c> triggerNew = Trigger.New;
        for (MUSW__License2__c newLicenseRecord : triggerNew) {        
                    if(!Label.Str_System_Number.equals(newLicenseRecord.Name)){
                        //throw an error message
                        newLicenseRecord.addError(Label.Err_Cannot_change_System_Number);
                    }
                }
        
        
            
       // }
        }
        
        beforeMethod();
        
        //This is to generate Intial sequence number with "APP"
        MUSW.SequenceNumber.updateNumbers(Trigger.New, Trigger.Old);
        
      //  Notificationdate();
    }
    public void onBeforeUndelete() {}
    public void onBeforeUpdate() {
        if (u.Is_Portal_User__c == true) {
            //This method is for base validation on license details provided by the Applicant
            
        }
        beforeMethod();
        
        //This is to Update sequence number & Automation Rules
        DRESequence();
        
      //  Notificationdate();
      //  
    }
    
    public void afterMethod() {        
        /* 
          * Method to update sumission records based on answers in License records         
          * Fetching old and new values for the License if any
        */
        
        
        
        List<MUSW__License2__c> triggerOld = Trigger.Old;
        List<MUSW__License2__c> triggerNew = Trigger.New;
        Map<Id,MUSW__License2__c> oldMapLicense = (Map<Id,MUSW__License2__c>)Trigger.OldMap;
        Map<Id,MUSW__License2__c> newMapLicense = (Map<Id,MUSW__License2__c>)Trigger.NewMap;
        List<MUSW__License2__c> licensesForFeeWaiver = new List<MUSW__License2__c>();
        Map<Id, MUSW__License2__c> licensesInPendingStatusMap = new Map<Id, MUSW__License2__c>();
        Set<String> credentialInPendingStatusSet = new Set<String>();
        Set<String> applicationMethodSet = new Set<String>();
        Set<MUSW__License2__c> setLicense = new Set<MUSW__License2__c>();
        setLicense.addAll(triggerNew);
        List<Endorsement__c> listEndorsement = [SELECT id,License__c,Status__c FROM Endorsement__c where License__c IN:setLicense AND Status__c='Pending Add' ];
        System.debug('trigger size'+triggerNew.size());
        Set<Id> parentSetLicenseId = new Set<Id>();
        Set<Id> childSetLicenseId = new Set<Id>();
        for(Integer i = 0; i < triggerNew.size(); i++) {
            System.debug('in for loop');
            MUSW__License2__c licenseNew = triggerNew[i];
            //get the license id to update submission list             
            System.debug('license status '+ licenseNew.MUSW__Status__c);            
            if(licenseNew.MUSW__Status__c == 'Active')
            {
                parentSetLicenseId .add(licenseNew.Id);
                if(licenseNew.MUSW__Total_Balance__c == 0)
                {
                    childSetLicenseId.add(licenseNew.Id);
                }
                for(Endorsement__c endo:listEndorsement)
                {
                    endo.Status__c = 'Active';
                }
            }
            
        }
        if(childSetLicenseId.size()>0)
        {
            List<Task> lstupdateTask = new List<Task>();
            Set<Id> setAssociationTaskId = new Set<Id>();
            List<Associations__c> lstupdateChildAssociation = new List<Associations__c>();
            for(Associations__c association : [SELECT id,Child_License__c,Status__c FROM Associations__c WHERE Child_License__c IN:childSetLicenseId AND Status__c = 'Generate Fee' ])
            {
                association.Status__c = 'Active';
                setAssociationTaskId.add(association.id);
                lstupdateChildAssociation.add(association);
                
            }
            for(Task ta : [SELECT id,Whatid,Status,Sub_status__c from task where Whatid IN:setAssociationTaskId])
            {
                ta.Status = 'Completed';
                ta.Sub_status__c = 'Accepted';
                lstupdateTask.add(ta);
            }
            if(lstupdateChildAssociation.size() > 0)
            {
                update lstupdateChildAssociation;
            }
            if(lstupdateTask.size() > 0)
            {
                update lstupdateTask;
            }
        }
        if(parentSetLicenseId.size()>0)
        {
            
            List<MUSW__License2__c> lstupdateChildLicenses = new List<MUSW__License2__c>();
            for(MUSW__License2__c lic : [SELECT id,MUSW__Status__c,Upgraded_License__c FROM MUSW__License2__c where Upgraded_License__c IN: parentSetLicenseId ])
            {
                lic.MUSW__Status__c = 'Sunset';
                lstupdateChildLicenses.add(lic);
            }
            update lstupdateChildLicenses;
        }
        if(!listEndorsement.isEmpty()){
            system.debug('listEndorsement : '+listEndorsement);
            update listEndorsement; 
        }
        
        //DHP Task
         if(trigger.isUpdate && runOnce == false){
            System.debug('Start executing');
            runOnce = true;
            List<Renewal_Application__c> relatedRenewalApplications  = new List<Renewal_Application__c>();
            
            set<id> licenseIDs = new Set<Id>();
            for(MUSW__License2__c licenseRec : triggerNew){
                   
                if(licenseRec.Polaris_DHP__c ==  True && licenseRec.MUSW__Status__c != oldMapLicense.get(licenseRec.Id).MUSW__Status__c  && licenseRec.MUSW__Status__c == 'Inactive'){
                    licenseIDs.add(licenseRec.Id);
                    
                }
            
            }
            if(!licenseIDs.isEmpty()){
                relatedRenewalApplications = [SELECT Id,License__c, Renewal_Status__c, License__r.MUSW__Status__c,License__r.Polaris_DHP__c,Renewal_Reinstatement_Type__c,License__r.MUSW__Applicant__r.Email,License__r.MUSW__Applicant__c,License__r.CreatedById,License__r.Name FROM Renewal_Application__c WHERE License__c IN :Trigger.newMap.keySet() AND Renewal_Reinstatement_Type__c='Renewal'];
            }   
            System.debug('Starttttt');
            
            List<Renewal_Application__c> updaterelatedRenewalApplications = new List<Renewal_Application__c>();
            List<Task> insertLicenseDHPTask = new List<Task>();
            Id recordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Reminder').getRecordTypeId();
            //User currentUser = [SELECT Name,Id,ContactId,Email from User Where ID = :UserInfo.getUserId() LIMIT 1];
            
            if(!relatedRenewalApplications.isEmpty()){
                for(Renewal_Application__c relatedRenewalApplicationRecord :relatedRenewalApplications ){
                    if(relatedRenewalApplicationRecord.License__r.MUSW__Status__c == 'Inactive' && relatedRenewalApplicationRecord.License__r.Polaris_DHP__c==true && newMapLicense.get(relatedRenewalApplicationRecord.License__c).MUSW__Status__c != oldMapLicense.get(relatedRenewalApplicationRecord.License__c).MUSW__Status__c){
                        System.debug('Update');
                        Task licenseDHPTask = new Task();
                        relatedRenewalApplicationRecord.Renewal_Status__c = 'Pending Payment';
                        licenseDHPTask.WhatId = relatedRenewalApplicationRecord.License__c;
                        licenseDHPTask.RecordTypeId = recordTypeId;
                        licenseDHPTask.Type = 'DHP';
                        licenseDHPTask.Description = 'DHP Reminder';
                        licenseDHPTask.Status = 'Pending';
                        licenseDHPTask.Subject = 'Bounced Check';
                        licenseDHPTask.Email__c=relatedRenewalApplicationRecord.License__r.MUSW__Applicant__r.Email;
                        licenseDHPTask.WhoId = relatedRenewalApplicationRecord.License__r.MUSW__Applicant__c;
                        licenseDHPTask.OwnerId = relatedRenewalApplicationRecord.License__r.CreatedById;
                        licenseDHPTask.Parent_License_Name__c = relatedRenewalApplicationRecord.License__r.Name;
                        
                        updaterelatedRenewalApplications.add(relatedRenewalApplicationRecord);
                        insertLicenseDHPTask.add(licenseDHPTask);
                    }
                }
            }
            if(relatedRenewalApplications.size() > 0){
                update updaterelatedRenewalApplications;
                //System.debug('Test......'+licenseDHPTask.Status);
            }
            if(insertLicenseDHPTask.size() > 0){
             insert insertLicenseDHPTask;
            }
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
        
     /*   List<MUSW__License2__c> triggerOld = Trigger.Old;
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
        } */
        
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
                    //Added a condition to update sequence for appraiser course if provider is secondary
                    else if(Trigger.Old != null && oldLic.Name != lic.Name && lic.Credential_Type__c != 'Appraiser Course'){
                        //throw an error message
                        sobj.addError(Label.Err_Number_cannot_be_changed);
                    }
                }    
        // Call Automation rules
        BGCM.TriggerManager.execute('DRE2_MUSW_License2_c', new DRETriggerHandler());
    }
    
}
