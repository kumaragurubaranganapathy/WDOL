/*
**************************************************************************************************************
** Class Name    : PermitEmailNotificationHandler
** Description   : Handler class to send out renewal reminders, expiration notice and post expiration notice.
**                 This process also changes License status and sub-status as configured in custom metadata
** Version       : 1.0
** Built By      :
**------------------------------------------------------------------------------------------------------------
** Modification Log:
**------------------
** Developer         Date             Version                   Description
**************************************************************************************************************/ 
public without sharing class PermitEmailNotificationHandler {

    public static void sendNotifications(List<MUSW__Permit2__c> lstPermits){
        Map<String, List<Email_Reminder_Setting__mdt>> mapTypeVsCriteria = Email_Utility.getEmailCriteriaMap(label.Str_Permit); 
        
        List<Email_Utility> lstNotifications = new List<Email_Utility>();
        List<MUSW__Permit2__c> lstPermit_NextUpdate = new List<MUSW__Permit2__c>();

        SavePoint beforeAllUpdates = Database.setSavepoint();
        try{
            for(MUSW__Permit2__c permit : lstPermits){
                Email_Utility email = new Email_Utility();
                Email_Reminder_Setting__mdt currentDefaultEmailSetting = null;
                Email_Reminder_Setting__mdt nextDefaultEmailSetting = null;
                Email_Reminder_Setting__mdt currentEmailSetting = null;
                Email_Reminder_Setting__mdt nextEmailSetting = null;
                
                List<Email_Reminder_Setting__mdt> lstCriteria = mapTypeVsCriteria.get(permit.permit_type__c);
                if(lstCriteria != null){
                    for(Email_Reminder_Setting__mdt setting : lstCriteria){
                        if(setting.Attempt__c == permit.Next_Notification_Attempt__c){
                            currentEmailSetting = setting;
                        }else if(setting.Attempt__c > permit.Next_Notification_Attempt__c){
                            nextEmailSetting = setting;                            
                            break;
                        }
                    }
                }
                
                if(currentEmailSetting == null){
                    currentEmailSetting = currentDefaultEmailSetting;
                }
                if(nextEmailSetting == null){
                    nextEmailSetting = nextDefaultEmailSetting;
                }
                if(currentEmailSetting != null){
                    email = getEmailContent(currentEmailSetting, permit);
                    if(email != null){
                        lstNotifications.add(email);
                        
                        if(nextEmailSetting != null){
                            if(nextEmailSetting.Event__c == label.ERS_Pre_Expiration){
                                permit.Next_Notification_Date__c = permit.MUSW__Expiration_Date__c - (Integer)nextEmailSetting.Days_From_Expiring__c;
                            }else if(nextEmailSetting.Event__c == label.ERS_Post_Expiration){
                                permit.Next_Notification_Date__c = permit.MUSW__Expiration_Date__c + (Integer)nextEmailSetting.Days_From_Expiring__c;
                            }
                            
                            permit.Next_Notification_Attempt__c = nextEmailSetting.Attempt__c;
                            lstPermit_NextUpdate.add(permit);
                        }else{
                            permit.Next_Notification_Date__c = null;
                            permit.Next_Notification_Attempt__c = -1;
                            
                            if(currentEmailSetting.Expired_Permit_Credential_Status__c != null)
                                permit.MUSW__Status__c = currentEmailSetting.Expired_Permit_Credential_Status__c;
                            
                            if(currentEmailSetting.Expired_Permit_Credential_SubStatus__c != null)
                                permit.Sub_status__c = currentEmailSetting.Expired_Permit_Credential_SubStatus__c;
                            
                            lstPermit_NextUpdate.add(permit);
                        }
                    }
                }
            }
            
            
            if(lstPermit_NextUpdate != null && lstPermit_NextUpdate.size() > 0){
                Database.SaveResult[] sr = Database.update(lstPermit_NextUpdate);
              }
            
            Email_Utility.sendEmailUsingParams(lstNotifications);

        }catch(Exception ex){
            Database.rollback(beforeAllUpdates);
           
        }
    }
    
    public static Email_Utility getEmailContent(Email_Reminder_Setting__mdt currentEmailSetting, MUSW__Permit2__c permit){
        Email_Utility email = new Email_Utility();
        email.permitId = permit.Id;
        email.emailType = currentEmailSetting.Notification_Type__c;
        email.NotificationObjectAPIName = Label.API_Email_Notification;
        email.EmailTemplateName = currentEmailSetting.Email_Template_Name__c; 
        email.taskSubjectName = currentEmailSetting.Task_Subject__c;
         if(permit.Business_License__c == True){
            email.EmailId = permit.Account_Email__c;
        }
        else{ 
            email.contactId = permit.MUSW__Applicant__c;
            email.EmailId = '';
        }

       
        if(permit.MUSW__Expiration_Date__c <= Date.today()){
                email.ExpiredLicenseStatus = currentEmailSetting.Expired_Permit_Credential_Status__c;
        }
        
        return email;
    }

}