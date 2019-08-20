/**
* Name: License2Trigger
* Type: Trigger
* Description: Trigger on MUSW__License2__c which calls License2TriggerHandler if trigger have not been disabled
* Date:        Developer/Company                    Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 06/13/2018   Sharad Maheshwari/Deloitte           Initial Creation
**/

trigger License2Trigger on MUSW__License2__c(before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    
    /*Checking whehter triggers have been disabled for the user or not*/
    Global_Settings__c globalSetting = Global_Settings__c.getInstance(UserInfo.getUserId());
    if(globalSetting.Disable_Triggers__c == true) {
        /*If the triggers have been disabled, then do not call the trigger handler*/
        return;
    }
    //if(Fee_Waiver.lictrgexcflg){return;}
    /*If the triggers have not been disabled, then call the trigger handler which then executes the required
        code based on before/after insert/update/delete/undelete condition*/
    TriggerDispatcher.Run(new License2TriggerHandler());  
    //added to update renewal fields on License -- siddhesh 
    
   if(trigger.isBefore && trigger.isupdate){
        List<MUSW__License2__c> licList = new List<MUSW__License2__c>();
        for(MUSW__License2__c lic : trigger.new){
            //padma.commented to update renewal date when issuedate changes
            //if(lic.MUSW__Status__c != trigger.oldMap.get(lic.id).MUSW__Status__c && lic.MUSW__Status__c == 'Active' && lic.MUSW__Expiration_Date__c != null){
            if(lic.MUSW__Expiration_Date__c != trigger.oldMap.get(lic.id).MUSW__Expiration_Date__c && lic.MUSW__Status__c == 'Active' && lic.MUSW__Expiration_Date__c != null){
                licList.add(lic);
            }else if(lic.MUSW__Status__c == 'Active' && lic.MUSW__Expiration_Date__c != null && lic.Application_Type__c == 'Notary Public' && lic.MUSW__Issue_Date__c != trigger.oldMap.get(lic.id).MUSW__Issue_Date__c ){
                licList.add(lic);
            }
        }
        if(!licList.isEmpty()){
            WA_License_utility.updateRenewalFields(licList);
        }
    }
	if(trigger.isAfter && trigger.isUpdate){     
        System.debug('Starttttt');
            List<Renewal_Application__c> relatedRenewalApplications = [SELECT Id,License__c, Renewal_Status__c, License__r.MUSW__Status__c,License__r.Polaris_DHP__c,Renewal_Reinstatement_Type__c,License__r.MUSW__Applicant__r.Email,License__r.MUSW__Applicant__c,License__r.CreatedById,License__r.Name FROM Renewal_Application__c WHERE License__c IN :Trigger.newMap.keySet() AND Renewal_Reinstatement_Type__c='Renewal'];
            List<Renewal_Application__c> updaterelatedRenewalApplications = new List<Renewal_Application__c>();
            List<Task> insertLicenseDHPTask = new List<Task>();
            Id recordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Reminder').getRecordTypeId();
			User currentUser = [SELECT Name,Id,ContactId,Email from User Where ID = :UserInfo.getUserId() LIMIT 1];
            for(Renewal_Application__c relatedRenewalApplicationRecord :relatedRenewalApplications ){
                if(relatedRenewalApplicationRecord.License__r.MUSW__Status__c == 'Inactive' && relatedRenewalApplicationRecord.License__r.Polaris_DHP__c==true && trigger.NewMap.get(relatedRenewalApplicationRecord.License__c).MUSW__Status__c != trigger.OldMap.get(relatedRenewalApplicationRecord.License__c).MUSW__Status__c){
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
            if(relatedRenewalApplications.size() > 0){
                update updaterelatedRenewalApplications;
                //System.debug('Test......'+licenseDHPTask.Status);
            }
            if(insertLicenseDHPTask.size() > 0){
             insert insertLicenseDHPTask;
            }
            
        }

}