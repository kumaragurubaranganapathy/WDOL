/*************************************************************************************************************
** User Story: 
**************************************************************************************************************
** Name                : PermitNotificationScheduler
** Description         : 
** Version             : 1.0
** Built By            :  
**-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
** Modification Log:
**--------------------------
** Developer                         Date                    Version                      Description
**-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
** Akosa Okwudiafor                   8/17/2018
**
** Review Log:
**---------------
** Reviewer                  Date           Version               Description
**-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
**
*************************************************************************************************************/ 
global with sharing class PermitNotificationScheduler implements Schedulable {
    global void execute(SchedulableContext ctx) {
        String query = 'Select Id, Name, MUSW__Applicant__r.FirstName, MUSW__Applicant__r.LastName, MUSW__Applicant__r.Name, MUSW__Account__r.Email_Primary_Contact__c, MUSW__Status__c, ' + 
            'MUSW__Expiration_Date__c, Next_Notification_Date__c, Next_Notification_Attempt__c, Business_License__c, OwnerId,permit_type__c, ' + 
            'Is_Renewal_Eligible__c, Account_Email__c,Sub_Status__c ' + 
            ' From MUSW__Permit2__c where Next_Notification_Date__c = TODAY '+
            ' and(MUSW__Status__c = \'Active\'' +
            ' or MUSW__Status__c = \'Conditional Approved\'' +
            ' or (MUSW__Status__c = \'Inactive\' AND Sub_Status__c = \'Expired\'))' ;
        try{
            PermitNotificationBatch batch = new PermitNotificationBatch(query);            
            Integer BatchSize = Email_Utility.getBatchSize();
            Database.executeBatch(batch, BatchSize);
        }
        catch(Exception e){
            System.debug('error occured '+e);         
        }
    }
}