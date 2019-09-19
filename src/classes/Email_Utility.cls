public with sharing class Email_Utility {
    public Id contactId {get; set;} //The contact lookup to be populated on the Email Notification object.
                                    //This is the recipient to which the email is sent.
    public String emailId {get; set;}
    public String subject {get; set;} //Subject of the email
    public String body {get; set;} //Optional. HTML Body of the email.
    public String emailType {get; set;} //Email Type field to be set on the Email Notification object.
    public Map<String, String> mapParamValues {get; set;} //The parameter map that contains field name as the key and the corresponding value.
    public String taskSubjectName {get; set;} //This parameter is not used in the email notification. Used while creating the task right after the email is sent.
    public Id licenseId {get; set;}
    public Id permitId {get; set;}
    public string ExpiredLicenseStatus {get; set;}
    public string ExpiredLicenseSubStatus {get; set;}
    public string NotificationObjectAPIName {get; set;}
    public String EmailTemplateName {get; set;}
    
    public Email_Utility(){
        mapParamValues = new Map<String, String>();
    }
    
    public Email_Utility(Id contactId, String subject, String body){
        this.contactId = contactId;
        this.subject = subject;
        this.body = body;
        
        mapParamValues = new Map<String, String>();
    }
    
    public Email_Utility(String emailId, String subject, String body){
        this.emailId = emailId;
        this.subject = subject;
        this.body = body;
        
        mapParamValues = new Map<String, String>();
    }
    
    public Email_Utility(Id contactId, String subject, Map<String, String> mapParamValues){
        this.contactId = contactId;
        this.subject = subject;
        this.mapParamValues = mapParamValues;
    }
    
    public static void sendEmailUsingBody(List<Email_Utility> lstNotifications){
        List<Email_Notification__c> lstEmailMessages = new List<Email_Notification__c>();
        
        for(Email_Utility notification : lstNotifications){
            Email_Notification__c objEmailMessage = new Email_Notification__c(
                                                                Recipient_Contact__c = notification.contactId,
                                                                Subject__c = notification.subject,
                                                                Type__c = notification.emailType,
                                                                Body__c = notification.body,
                                                                Email__c = notification.EmailId
                                                                
                                                            );
                                                            
            lstEmailMessages.add(objEmailMessage);
        }
        
        Database.SaveResult[] sr = Database.insert(lstEmailMessages, false);
            }
    
    public static void sendEmailUsingParams(List<Email_Utility> lstNotifications){
        List<sObject> lstEmailMessages = new List<sObject>();
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        
        for(Email_Utility notification : lstNotifications){
            sObject objEmailMessage = new Email_Notification__c();
            
            if(notification.NotificationObjectAPIName != ''){
                Schema.SObjectType st = gd.get(notification.NotificationObjectAPIName);
                if(st != null){
                    objEmailMessage = st.newSobject();
                }
            }
            
            objEmailMessage.put('Recipient_Contact__c', notification.contactId);
            objEmailMessage.put('Subject__c', notification.subject);
            objEmailMessage.put('Type__c', notification.emailType);
            objEmailMessage.put('Email__c', notification.EmailId);
            objEmailMessage.put('Credential__c', notification.licenseId);
            objEmailMessage.put('Permit_Plan_Review__c', notification.permitId);
            objEmailMessage.put('Expired_Permit_Credential_Status__c', notification.ExpiredLicenseStatus);
            objEmailMessage.put('Email_Template_Name__c', notification.EmailTemplateName);
            
            if(notification.mapParamValues != null){
                for(String param : notification.mapParamValues.keySet()){
                    try{
                        objEmailMessage.put(param, notification.mapParamValues.get(param));
                    }catch(Exception ex){
                        system.debug('EmailNotificationUtil: sendEmailUsingParams: Invalid Parameter: ' + param);
                    }
                }
            }
                                                            
            lstEmailMessages.add(objEmailMessage);
        }
        
        Database.SaveResult[] sr = Database.insert(lstEmailMessages, false);
      }
    
    //This method reads the values from the Metadata Type and constructs a map with License Type as the key.
    //This is then used to set the next notification date and attempt on the license object.
    //This is also used to set the Notification Type on the Email Notification object being created.
    public static Map<String, List<Email_Reminder_Setting__mdt>> getEmailCriteriaMap(String objectType){
        Map<String, List<Email_Reminder_Setting__mdt>> mapTypeVsCriteria = new Map<String, List<Email_Reminder_Setting__mdt>>();
        
        //The query must be sorted on Attempt__c ascending order as we need to read the attempts in order for this to work.
        List<Email_Reminder_Setting__mdt> lstEmailCriteria = [Select Id, MasterLabel, Attempt__c, Days_From_Expiring__c, Event__c,
                                                                Type_of_Permit_Plan_Review_Credential__c, Notification_Type__c, object__c, Expired_Permit_Credential_Status__c,
                                                                 Email_Template_Name__c,Task_Subject__c,Expired_Permit_Credential_SubStatus__c From Email_Reminder_Setting__mdt where object__c = :objectType order by Attempt__c asc];
        for(Email_Reminder_Setting__mdt emailCriteria : lstEmailCriteria){
            
            if(mapTypeVsCriteria.get(emailCriteria.Type_of_Permit_Plan_Review_Credential__c) == null){
                List<Email_Reminder_Setting__mdt> lstCriteria = new List<Email_Reminder_Setting__mdt>();
                lstCriteria.add(emailCriteria);
                
                mapTypeVsCriteria.put(emailCriteria.Type_of_Permit_Plan_Review_Credential__c, lstCriteria);
            }else{
                List<Email_Reminder_Setting__mdt> lstCriteria = mapTypeVsCriteria.get(emailCriteria.Type_of_Permit_Plan_Review_Credential__c);
                lstCriteria.add(emailCriteria);
                
                mapTypeVsCriteria.put(emailCriteria.Type_of_Permit_Plan_Review_Credential__c, lstCriteria);
            }
                                
        }
        
        return mapTypeVsCriteria;
    }
    
    public static Integer getBatchSize(){
        Integer BatchSize = 10;         
        try{
            Email_Batch_Setting__mdt setting = [Select Id, Batch_Size__c From Email_Batch_Setting__mdt where DeveloperName =: DOL_AppConstants.NULL_EMPTY_STRING + 'Default' limit 1];
            BatchSize = (Integer) setting.Batch_Size__c;
        }catch(Exception ex){
        }
        
        return BatchSize;
    }
    
    public static void sendApexEmails(List<Email_Notification__c> lstNotifications){
        OrgWideEmailAddress orgWideAddress = [select Id, DisplayName, Address from OrgWideEmailAddress where DisplayName = :label.Str_Org_Wide_Address];
        Set<String> setAttachmentNames = new Set<String>();
        Set<Id> setAttachmentParentIDs = new Set<Id>();
        Set<Id> setContactIDs = new Set<Id>();
        Set<String> setEmailTemplateNames = new Set<String>();
        
        //Populate the parentIDs, contactIDs and attachmentNames into the respective sets so that we are able to query them in bulk below
        for(Email_Notification__c notification : lstNotifications){
        	String defaultParentId = notification.Email_Parent_Id__c; //This is populated based on the populated lookup fields.
        	String emailTemplateParentId = notification.Email_Template_Parent_Id__c; //Id that should be used as WhatId for the email template.
        	String attachmentParentId = notification.Attachment_Parent_Id__c; //Id from which attachments should be retrieved.
        	
        	//if Email_Template_Parent_Id__c is not provided, then use default parent id.
        	if(emailTemplateParentId== null){
        		emailTemplateParentId = defaultParentId;
        	}
        	//if Attachment_Parent_Id__c is not provided, then use the default parent id.
        	if(attachmentParentId== null){
        		attachmentParentId = defaultParentId;
        	}
        	
            setAttachmentParentIDs.add(attachmentParentId);
            if(notification.Recipient_Contact__c != null) setContactIDs.add(notification.Recipient_Contact__c);
            setEmailTemplateNames.add(notification.Email_Template_Name__c);
            
            if(notification.Attachment_Names__c != null && notification.Attachment_Names__c != ''){
                for(String aName : notification.Attachment_Names__c.split(',')){
                    if(aName != null){
                    	aName = aName.trim();
                        setAttachmentNames.add(aName.trim());
                    }
                }
            }
        }
        
        //Create a map of UserId for each Contact. This will be used to decide whether to send the email to the user or to the contact
        Map<Id,Id> mapContactUser = new Map<Id,Id>();
        if(setContactIDs.size() > 0){
		    for(User usr : [Select Id, ContactId, Email From User where ContactId IN :setContactIDs]){
		        mapContactUser.put(usr.ContactId, usr.Id);
		    }
        }
        system.debug('>>>> mapContactUser.size()' + mapContactUser.size());

        //Get all attachments for the parentIDs in the current context and create a map such that we can access all attachments associated with each parent
        Map<Id, List<Attachment>> mapAttachments = new Map<Id, List<Attachment>>();
        for(Attachment att : [Select Id, Name, ParentId, ContentType From Attachment where ParentId IN :setAttachmentParentIDs order by CreatedDate desc]){
            List<Attachment> lstAttachment = mapAttachments.get(att.ParentId);
            if(lstAttachment == null){
                lstAttachment = new List<Attachment>();
            }
            
            lstAttachment.add(att);
            mapAttachments.put(att.ParentId, lstAttachment);
        }
        
        //Get Email Template IDs from the Email Template Names
        Map<String, Id> mapEmailTemplates = new Map<String, Id>();
        for(EmailTemplate emailTemplate : [Select Id, Name From EmailTemplate where Name IN :setEmailTemplateNames order by CreatedDate asc]){
            mapEmailTemplates.put(emailTemplate.Name, emailTemplate.Id);
        }

        //List of emails to send and the list of activity history records to insert
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        List<EmailMessage> lstActivityHistory = new List<EmailMessage>();
        
        //For each notification record, get the rendered content using Contact Id as the recipient. The template should also be created such that it refers contact as the recipient and not a user.
        for(Email_Notification__c notification : lstNotifications){
            Id emailTemplateId = mapEmailTemplates.get(notification.Email_Template_Name__c);
            String defaultParentId = notification.Email_Parent_Id__c; //This is populated based on the populated lookup fields.
        	String emailTemplateParentId = notification.Email_Template_Parent_Id__c; //Id that should be used as WhatId for the email template.
        	String attachmentParentId = notification.Attachment_Parent_Id__c; //Id from which attachments should be retrieved.
        	
        	//if Email_Template_Parent_Id__c is not provided, then use default parent id.
        	if(emailTemplateParentId== null){
        		emailTemplateParentId = defaultParentId;
        	}
        	//if Attachment_Parent_Id__c is not provided, then use the default parent id.
        	if(attachmentParentId== null){
        		attachmentParentId = defaultParentId;
        	}
            
            if(emailTemplateId != null){
                Messaging.SingleEmailMessage mail_rendered_content = new Messaging.SingleEmailMessage();
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                List<Id> lstAttach = new List<Id>();
                
                //For the current parentId (from the notification), check if the attachment name 'starts with' the name specified on the notification record. If yes, the add to the list of attachments.
                //In case more than one attachment exists with same name, only add the first one. 
                if(notification.Attachment_Names__c != null && notification.Attachment_Names__c != ''){
                    for(String aName : notification.Attachment_Names__c.split(',')){
                        Set<String> setFilesAttached = new Set<String>();
                        if(aName != null){
                        	aName = aName.trim();
                            for(Attachment att : mapAttachments.get(attachmentParentId)){
                                if(att.Name.startsWithIgnoreCase(aName) && setFilesAttached.contains(aName) == false){
                                    lstAttach.add(att.Id);
                                    setFilesAttached.add(aName);
                                }
                            }
                        }
                    }
                }
                
                //Prepare the mail record to generate the content. Put contact as the recipient in this case.
                mail_rendered_content.setUseSignature(false);
                mail_rendered_content.setOrgWideEmailAddressId(orgWideAddress.Id);
                mail_rendered_content.setTemplateId(emailTemplateId);
                mail_rendered_content.setWhatId(emailTemplateParentId);
                mail_rendered_content.setSaveAsActivity(false);
                
                if(notification.Recipient_Contact__c != null){
                	mail_rendered_content.setTargetObjectId(notification.Recipient_Contact__c);
                }else{
                	//Contact ID is not provided. In this case the Email__c field will be used to send out the email.
                	mail_rendered_content.setTargetObjectId(UserInfo.getUserId());
                	mail_rendered_content.setToAddresses(new String[] {notification.Email__c});
                	mail_rendered_content.setTreatTargetObjectAsRecipient(false);
                }
                
                //Render the content.
                Messaging.SingleEmailMessage renderedMsg = Messaging.renderStoredEmailTemplate(mail_rendered_content.getTemplateId(), mail_rendered_content.getTargetObjectId(), mail_rendered_content.getWhatId());
                
                //Now prepare the mail record with the generated content, but specify user as the recipient instead of contact. If user record does not exist, then set contact as the recipient.
                Id userId = mapContactUser.get(notification.Recipient_Contact__c);
                system.debug('>>>> userId: ' + userId);
                
                mail.setUseSignature(false);
                mail.setOrgWideEmailAddressId(orgWideAddress.Id);
                mail.setHtmlBody(renderedMsg.getHtmlBody());
                mail.setPlainTextBody(renderedMsg.getPlainTextBody());
                mail.setSaveAsActivity(false);
                mail.setSubject(renderedMsg.getSubject());
                if(userId == null){
                	if(notification.Recipient_Contact__c != null){
	                    mail.setTargetObjectId(notification.Recipient_Contact__c);
	                    system.debug('>>>> Sending email to CONTACT: ' + notification.Recipient_Contact__c);
                	}else{
                		//Contact ID is not provided. In this case the Email__c field will be used to send out the email.
	                	mail.setTargetObjectId(UserInfo.getUserId());
	                	mail.setToAddresses(new String[] {notification.Email__c});
	                	mail.setTreatTargetObjectAsRecipient(false);
	                	
	                	system.debug('>>>> Sending email to Email__c: ' + notification.Email__c);
                	}
                }else{
                    mail.setTargetObjectId(userId);
                    system.debug('>>>> Sending email to USER: ' + userId);
                }
                if(lstAttach != null && lstAttach.size() > 0){
                    mail.setEntityAttachments(lstAttach); 
                }
                System.debug('mail   '+mail);
                mails.add(mail);
                
                EmailMessage activityHistory = new EmailMessage();
                activityHistory.Subject = renderedMsg.getSubject();
                activityHistory.TextBody = renderedMsg.getPlainTextBody();
                activityHistory.HtmlBody = renderedMsg.getHtmlBody();
                activityHistory.RelatedToId = renderedMsg.getWhatId();
                activityHistory.MessageDate = DateTime.now();
                activityHistory.Status = DOL_AppConstants.THREE_STRING;
                activityHistory.FromAddress = orgWideAddress.Address;
                activityHistory.FromName = orgWideAddress.DisplayName;
                activityHistory.ToAddress = notification.To_Address__c;
                
                lstActivityHistory.add(activityHistory);
            }
            
        }
        System.debug('mails '+mails);
        // Send the email
        Messaging.sendEmail(mails,false);
        insert lstActivityHistory;
    }
    
        //This method is called from a before insert trigger on the Email Notification object
    public static void populateBodyForWFRuleEmails(){
        OrgWideEmailAddress orgWideAddress = [select Id, DisplayName, Address from OrgWideEmailAddress where DisplayName =:label.Str_Org_Wide_Address];
        Set<String> setEmailTemplateNames = new Set<String>();
        
        for(SObject sobj : trigger.New){
            Email_Notification__c notification = (Email_Notification__c) sobj;
            if(notification.Type__c == 'Raw HTML Body' || (notification.Email_Address__c != null && notification.Email_Address__c != '')){
                setEmailTemplateNames.add(notification.Email_Template_Name__c);
            }
        }
        
        //Get Email Template IDs from the Email Template Names
        Map<String, Id> mapEmailTemplates = new Map<String, Id>();
        if(setEmailTemplateNames.size() > 0){
            for(EmailTemplate emailTemplate : [Select Id, Name From EmailTemplate where Name IN :setEmailTemplateNames order by CreatedDate asc]){
                mapEmailTemplates.put(emailTemplate.Name, emailTemplate.Id);
            }
        }
        
        List<EmailMessage> lstActivityHistory = new List<EmailMessage>();
        
        for(SObject sobj : trigger.New){
            Email_Notification__c notification = (Email_Notification__c) sobj;
            if(notification.Type__c == 'Raw HTML Body' || (notification.Email_Address__c != null && notification.Email_Address__c != '')){
                Id emailTemplateId = mapEmailTemplates.get(notification.Email_Template_Name__c);
                
                if(emailTemplateId != null){
                    Messaging.SingleEmailMessage mail_rendered_content = new Messaging.SingleEmailMessage();
                    
                    //Prepare the mail record to generate the content. Put contact as the recipient in this case.
                    mail_rendered_content.setUseSignature(false);
                    mail_rendered_content.setOrgWideEmailAddressId(orgWideAddress.Id);
                    mail_rendered_content.setTemplateId(emailTemplateId);
                    mail_rendered_content.setTargetObjectId(notification.Recipient_Contact__c);
                    mail_rendered_content.setWhatId(notification.Email_Parent_Id__c);
                    mail_rendered_content.setSaveAsActivity(false);
                    
                    //Render the content.
                    Messaging.SingleEmailMessage renderedMsg = Messaging.renderStoredEmailTemplate(mail_rendered_content.getTemplateId(), mail_rendered_content.getTargetObjectId(), mail_rendered_content.getWhatId());
                    notification.Body__c = renderedMsg.getHtmlBody();
                    notification.Subject__c = renderedMsg.getSubject();
                    
                    EmailMessage activityHistory = new EmailMessage();
                    activityHistory.Subject = renderedMsg.getSubject();
                    activityHistory.TextBody = renderedMsg.getPlainTextBody();
                    activityHistory.HtmlBody = renderedMsg.getHtmlBody();
                    activityHistory.RelatedToId = renderedMsg.getWhatId();
                    activityHistory.MessageDate = DateTime.now();
                    activityHistory.Status = DOL_AppConstants.THREE_STRING;
                    activityHistory.FromAddress = orgWideAddress.Address;
                    activityHistory.FromName = orgWideAddress.DisplayName;
                    activityHistory.ToAddress = notification.To_Address__c;
                    
                    if(notification.Type__c == 'Raw HTML Body'){
                    	lstActivityHistory.add(activityHistory);
                    }
                    
                    //If credentialer email address is populated, save a copy of the email in activity history
                    if(notification.Email_Address__c != null && notification.Email_Address__c != ''){
                    	EmailMessage activityHistoryClone = activityHistory.clone(false, false, false, false);
                    	activityHistoryClone.ToAddress = notification.Email_Address__c;
                    	
                    	lstActivityHistory.add(activityHistoryClone);
                    }
                }
            }
        }
        System.debug('time to party');
        insert lstActivityHistory;
    }
}
