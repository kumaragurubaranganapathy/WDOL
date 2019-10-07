global with sharing class Dol_Batch_CreateRenewalTask implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC){
            return Database.getQueryLocator([SELECT ID,Name,(select id from tasks where Status ='Pending' and Type = 'Renewal Reminder'),Application_Method__c,MUSW__Expiration_Date__c,Late_Renewal_Eligible_End_Date__c,Renewal_Grace_Period_End_Date__c,Renewal_Eligible_Start_Date__c,MUSW__Status__c  from MUSW__License2__c WHERE Is_Renewal_Eligible__c = true and Renew_Reinstatement_in_progress__c = false]);
        
    }    
    global void execute(Database.BatchableContext BC, List<MUSW__License2__c> lstLicense) {
        List<Task>  lstRenewalLicenses = new List<Task>();
        for(MUSW__License2__c appLicense : lstLicense) {
            if(!appLicense.Tasks.isEmpty()) {
                Task renewTask = new Task();
                renewTask.WhatId = appLicense.Id;
                renewTask.Type = System.Label.Polaris_Renew_Reminder;
                renewTask.Description = System.Label.Polaris_Renew_Reminder;
                renewTask.Status = 'Pending';
                renewTask.Subject = 'License is ready for renewal';
                renewTask.Email__c= appLicense.MUSW__Applicant__r.Email;
                renewTask.WhoId = appLicense.MUSW__Applicant__c;
                renewTask.OwnerId = appLicense.CreatedById;
                renewTask.Parent_License_Name__c = appLicense.Name;
                renewTask.Parent_License_Type__c = appLicense.Credential_Type__c;
                renewTask.Expiration_Date__c = appLicense.MUSW__Expiration_Date__c;
                renewTask.Parent_Profession__c = appLicense.Application_Type__c;
                renewTask.License_Application_Type__c = appLicense.Application_Method__c;
                lstRenewalLicenses.add(renewTask);
            }  
        }
        try{
            if(!lstRenewalLicenses.isEmpty()){
                insert lstRenewalLicenses;
            }
        }
        catch(Exception e){
            DOL_CreateErrorLog_Exception.logApplicationError(e);
        }
    }
    global void finish(Database.BatchableContext BC) {
        System.debug('finish');
    }

}