/*************************************************************************************************************
** User Story: N/A
**************************************************************************************************************
** Class Name    : EmailnotificationTriggerhandler
** Version       : 1.0
** Built By      : 
**------------------------------------------------------------------------------------------------------------
** Modification Log:
**------------------
** Developer                     Date              Version              Description
** Akosa Okwudiafor              08/16/2018             1.0                Initial Creation v1.0
**------------------------------------------------------------------------------------------------------------
** Review Log:
**---------------
** Reviewer                  Date           Version               Description
**------------------------------------------------------------------------------------------------------------
**
**************************************************************************************************************/
public with sharing class EmailnotificationTriggerhandler implements BGCM.ITriggerHandler {
    public static user u;
    public static boolean IsDisabled;
    
    public EmailnotificationTriggerhandler() {
        Boolean isTriggerDisabled = false;
        Global_Settings__c settings = Global_Settings__c.getInstance(UserInfo.getUserId());
        if (settings != null) {
            isTriggerDisabled = settings.Disable_Triggers__c;
        }
    }
    
    public void onBeforeInsert() {
        beforemethod();
    }
    
    public void onBeforeUpdate() {}
    
    public void onBeforeDelete() {}
    
    public void onBeforeUndelete() {}
    
    public void onAfterInsert() {
        Aftermethod();
    }
    
    public void onAfterUpdate() {
        Aftermethod();
    }
    public void onAfterDelete() {}
    
    public void onAfterUndelete() {}
    
    public void Aftermethod() {
        
        List<Email_Notification__c> EmailNotificationList = new List<Email_Notification__c>();//used to store the modified Email Notification Records    
        List<Email_Notification__c> ApexEmailNotificationList = new List<Email_Notification__c>();
        List<Task> lstTasks = new List<Task>(); //List of task Objects which will be inserted
        List<MUSW__License2__c> lstLicenses = new List<MUSW__License2__c>();
        List<MUSW__Permit2__c> permits = new List<MUSW__Permit2__c>();
        System.debug('time to party');
        map<id,Email_Notification__c> triggeroldmap = (map<id,Email_Notification__c>)trigger.oldmap;
        map<id,Email_Notification__c> triggernewmap = (map<id,Email_Notification__c>)trigger.newmap;
        try{
            for(Id id : (Trigger.newMap).keySet()){
                Email_Notification__c oldEmailNotification = new Email_Notification__c();
                if(triggeroldmap!=null && !(triggeroldmap).isEmpty()){
                    oldEmailNotification = (triggeroldmap).get(id);
                }
                Email_Notification__c newEmailNotification = (triggernewmap).get(id);            
                // Check if the Email Sent  was updated 
                if(newEmailNotification.Email_Sent__c == true && (oldEmailNotification == null || oldEmailNotification.Email_Sent__c == false)) {
                    EmailNotificationList.add(newEmailNotification);
                }else if(trigger.isInsert&& newEmailNotification.Type__c ==label.Str_Email_with_Attachments){
                    ApexEmailNotificationList.add(newEmailNotification);
                }
            }
            
            if(!EmailNotificationList.isEmpty()){
                for(Email_Notification__c emailnotificationObj:EmailNotificationList){
                    if(emailnotificationObj.Credential__c!=null){
                        if(emailnotificationObj.Task_Subject__c != null && emailnotificationObj.Task_Subject__c != ''){
                            Task objTask = new Task(Subject=emailnotificationObj.Task_Subject__c, ActivityDate=Date.today(), Status='Completed', Priority='Normal', WhatId=emailnotificationObj.Credential__c);
                            lstTasks.add(objTask);
                        }
                        
                        if(emailnotificationObj.Expired_Permit_Credential_Status__c!=null ){ 
                            MUSW__License2__c license = new MUSW__License2__c(Id=emailnotificationObj.Credential__c,MUSW__Status__c=emailnotificationObj.Expired_Permit_Credential_Status__c,Sub_Status__c=emailnotificationObj.Expired_Permit_Credential_SubStatus__c);
                            lstLicenses.add(license);
                        }
                        
                    }
                    
                    if(emailnotificationObj.Permit_Plan_Review__c!=null){
                        if(emailnotificationObj.Task_Subject__c != null && emailnotificationObj.Task_Subject__c != ''){
                            Task objTask = new Task(Subject=emailnotificationObj.Task_Subject__c, ActivityDate=Date.today(), Status='Completed', Priority='Normal', WhatId=emailnotificationObj.Credential__c);
                            lstTasks.add(objTask);
                        }
                        
                        if(emailnotificationObj.Expired_Permit_Credential_Status__c!=null){
                            MUSW__Permit2__c permit = new MUSW__Permit2__c(Id=emailnotificationObj.Permit_Plan_Review__c,MUSW__Status__c=emailnotificationObj.Expired_Permit_Credential_Status__c,Sub_Status__c=emailnotificationObj.Expired_Permit_Credential_SubStatus__c);
                            permits.add(permit);
                        }
                    }                    
                }
            }
            
            if(lstTasks != null && lstTasks.size() > 0){
                Database.SaveResult[] sr = Database.insert(lstTasks);                
            }
            
            if(lstLicenses != null && lstLicenses.size() > 0){
                Database.SaveResult[] sr = Database.update(lstLicenses);
                
            }   
            if(permits != null && permits.size() > 0){
                Database.SaveResult[] sr = Database.update(permits);
            }
            
            if(ApexEmailNotificationList != null && ApexEmailNotificationList.size() > 0){
                Email_Utility.sendApexEmails(ApexEmailNotificationList);
            }
        }catch(Exception e){
            System.debug('e '+e);      
        }
    }
    
    public void beforemethod(){
        Email_Utility.populateBodyForWFRuleEmails();
    }
    
}