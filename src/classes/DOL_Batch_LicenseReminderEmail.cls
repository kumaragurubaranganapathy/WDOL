/**
 * Name: DOL_Batch_LicenseReminderEmail
 * Type: Class
 * Description: Batch to update status field to Abandoned if a draft application is not modified for 30 days
 *              & delete the abandoned applications if not modified for 120 days.
 * Date:        - Case#/Project:            - Developer/Company                         - Description
 * ------------------------------------------------------------------------------------------------------------------------- *
 * 07/16/2019   Swapna Satapathy/Deloitte           Initial Creation 
 */
 global with sharing class DOL_Batch_LicenseReminderEmail implements Database.Batchable<sObject>{
 
 global Database.QueryLocator start(Database.BatchableContext BC){
   String queryLicenseForReminder = DOL_AppConstants.QUERY_ACTIVE_LICENSES;
   return Database.getQueryLocator(queryLicenseForReminder);
 }
 
  global void execute(Database.BatchableContext BC, List<MUSW__License2__c> listLicenseForReminder) {
     Date expirationDate = Date.newInstance(1960, 2, 17);
     //Time targetTime = Time.newInstance(21, 30, 0, 0);
     //List<MUSW__Application2__c>  applicationListToUpdateStatus = new List<MUSW__Application2__c>();
     List<Task> createEmailTask = new List<Task>();
     List<Id> contactLstids= new List<Id>();
     EmailTemplate emailTemplate=[Select id,Subject, HtmlValue, Body from EmailTemplate where name = 'Renewal Notice Template' limit 1];
     String htmlSubject = emailTemplate.Subject;
     String htmlBody = emailTemplate.HtmlValue;
     String plainBody = emailTemplate.Body; 
        for(MUSW__License2__c licObj : listLicenseForReminder) {
            expirationDate = licObj.MUSW__Expiration_Date__c;
            if(licObj.MUSW__Status__c == 'Active' && licObj.MUSW__Expiration_Date__c == Date.Today().addDays(120)){
              //System.debug('Inside If');
              contactLstids.add(licObj.MUSW__Applicant__r.Id);
              Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
              mail.templateid=emailTemplate.Id;
              htmlSubject=htmlSubject.replace('nDays', '120');
              htmlBody=htmlBody.replace('LicenseApplicationType', licObj.Application_Type__c);
              htmlBody=htmlBody.replace('LicenseLicenseeName', licObj.MUSW__Applicant__r.Name);
              htmlBody=htmlBody.replace('ExpirationDate', expirationDate.format());
              htmlBody=htmlBody.replace('LicenseName', licObj.Name);
              htmlBody=htmlBody.replace('LicenseCredentialType', licObj.Credential_Type__c);
              htmlBody=htmlBody.replace('LicenseProgramEmail', licObj.Program_Email__c);
              htmlBody=htmlBody.replace('LicenseProgramPhone', licObj.Program_Phone__c);
              plainBody = plainBody.replace('ExpirationDate', expirationDate.format());
              //System.debug('***HTML***'+htmlBody);
              mail.toAddresses = new String[] { licObj.MUSW__Applicant__r.Email, licObj.MUSW__Applicant__r.Other_Email__c };
              mail.setSubject(htmlSubject);
              mail.setHtmlBody(htmlBody);
              mail.setPlainTextBody(plainBody);
              Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {mail};
              Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
              Task objTask = new Task();
              objTask.Subject = 'Send Letter';
              objTask.Status ='Completed';
              objTask.Priority = 'Normal';
              objTask.WhatId = licObj.Id;
              createEmailTask.add(objTask);
            }
            //System.debug('ListOfIds'+contactLstids);
            

        }
        
        try{
            if(!createEmailTask.isEmpty()){
                insert createEmailTask;}
            /*if(!applicationDeleteAbandoned.isEmpty()){
                DOL_CreateErrorLog_Exception.logDeleteDetails(applicationDeleteAbandoned.size()+' applications records were deleted from DOL_Batch_ApplictionsStatusUpdate','execute','DOL_Batch_ApplictionsStatusUpdate');
                delete applicationDeleteAbandoned;
            }*/
            /*if(!contactLstids.isEmpty()){
            Messaging.MassEmailMessage mail = new Messaging.MassEmailMessage();
            mail.setTargetObjectIds(contactLstids);
            mail.setSenderDisplayName('System Admin');
            mail.setTemplateId(et.id);
            Messaging.sendEmail(new Messaging.MassEmailMessage[] { mail });}*/
           }
        catch(Exception e){
            //System.debug(e);
            DOL_CreateErrorLog_Exception.logApplicationError(e);
            //System.debug('Error message'+e.getMessage());
           }
    }
    
    global void finish(Database.BatchableContext BC) {
    }
    
    
 }