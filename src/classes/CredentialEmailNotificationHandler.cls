/*
**************************************************************************************************************
** Class Name    : CredentialEmailNotificationHandler
** Description   : Handler class to send out renewal reminders, expiration notice and post expiration notice.
**                 This process also changes License status and sub-status as configured in custom metadata
** Version       : 1.0
** Built By      :
**------------------------------------------------------------------------------------------------------------
** Modification Log:
**------------------
** Developer         Date             Version                   Description
**************************************************************************************************************/ 
public without sharing class CredentialEmailNotificationHandler {

    public static void sendNotifications(List<MUSW__License2__c> lstLicenses){
        Map<String, List<Email_Reminder_Setting__mdt>> mapTypeVsCriteria = Email_Utility.getEmailCriteriaMap(label.Str_Credential); 
        
        List<Email_Utility> lstNotifications = new List<Email_Utility>();
        List<MUSW__License2__c> lstLicenses_NextUpdate = new List<MUSW__License2__c>();

        SavePoint beforeAllUpdates = Database.setSavepoint();
        try{
            for(MUSW__License2__c license : lstLicenses){
                Email_Utility email = new Email_Utility();
                Email_Reminder_Setting__mdt currentDefaultEmailSetting = null;
                Email_Reminder_Setting__mdt nextDefaultEmailSetting = null;
                Email_Reminder_Setting__mdt currentEmailSetting = null;
                Email_Reminder_Setting__mdt nextEmailSetting = null;
                
                List<Email_Reminder_Setting__mdt> lstCriteria = mapTypeVsCriteria.get(license.Credential__c);
                if(lstCriteria != null){
                    for(Email_Reminder_Setting__mdt setting : lstCriteria){
                        if(setting.Attempt__c == license.Next_Notification_Attempt__c){
                            currentEmailSetting = setting;
                        }else if(setting.Attempt__c > license.Next_Notification_Attempt__c){
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
                    email = getEmailContent(currentEmailSetting, license);
                    if(email != null){
                        lstNotifications.add(email);
                        
                        if(nextEmailSetting != null){
                            if(nextEmailSetting.Event__c == label.ERS_Pre_Expiration){
                                license.Next_Notification_Date__c = license.MUSW__Expiration_Date__c - (Integer)nextEmailSetting.Days_From_Expiring__c;
                            }else if(nextEmailSetting.Event__c == label.ERS_Post_Expiration){
                                license.Next_Notification_Date__c = license.MUSW__Expiration_Date__c + (Integer)nextEmailSetting.Days_From_Expiring__c;
                            }
                            
                            license.Next_Notification_Attempt__c = nextEmailSetting.Attempt__c;
                            lstLicenses_NextUpdate.add(license);
                        }else{
                            license.Next_Notification_Date__c = null;
                            license.Next_Notification_Attempt__c = -1;
                            
                            if(currentEmailSetting.Expired_Permit_Credential_Status__c != null)
                                license.MUSW__Status__c = currentEmailSetting.Expired_Permit_Credential_Status__c;
                            
                            if(currentEmailSetting.Expired_Permit_Credential_SubStatus__c != null)
                                license.Sub_status__c = currentEmailSetting.Expired_Permit_Credential_SubStatus__c;
                            
                            lstLicenses_NextUpdate.add(license);
                        }
                    }
                }
            }
            
            
            if(lstLicenses_NextUpdate != null && lstLicenses_NextUpdate.size() > 0){
                Database.SaveResult[] sr = Database.update(lstLicenses_NextUpdate);
              }
            
            Email_Utility.sendEmailUsingParams(lstNotifications);

        }catch(Exception ex){
            Database.rollback(beforeAllUpdates);
           
        }
    }
    
    public static Email_Utility getEmailContent(Email_Reminder_Setting__mdt currentEmailSetting, MUSW__License2__c license){
        Email_Utility email = new Email_Utility();
        email.LicenseId = license.Id;
        email.emailType = currentEmailSetting.Notification_Type__c;
        email.NotificationObjectAPIName = Label.API_Email_Notification;
        email.EmailTemplateName = currentEmailSetting.Email_Template_Name__c; 
        email.taskSubjectName = currentEmailSetting.Task_Subject__c;
         if(license.Business_License__c == True){
            email.EmailId = license.Account_Email__c;
        }
        else{ 
            email.contactId = license.MUSW__Applicant__c;
            email.EmailId = '';
        }

       
        if(license.MUSW__Expiration_Date__c <= Date.today()){
                email.ExpiredLicenseStatus = currentEmailSetting.Expired_Permit_Credential_Status__c;
        }
        
        return email;
    }

}