/*************************************************************************************************************
** User Story: None
**************************************************************************************************************
** Name                : CredentialNotificationBatch
** Description         : This is the batch class which deals with license notifications.
** Version             : 1.0
** Built By            :
**-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
** Modification Log:
**--------------------------
** Developer                         Date                    Version                      Description
**-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
** Okwudiafor Akosa, Deloitte       
** 
**
**
** Review Log:
**---------------
** Reviewer                  Date           Version               Description
**-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
**
*************************************************************************************************************/ 

global class CredentialNotificationBatch implements Database.Batchable<sObject>{
    global final String query;
    
    global CredentialNotificationBatch(String q){
        Query=q;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }

/***************************************************************************************************
* @Description : This is where the emails are sent to the licensee.
* @Param       : Database.BatchableContext,scope
* @Return      : void
****************************************************************************************************/
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        CredentialEmailNotificationHandler.sendNotifications((List<MUSW__License2__c>) scope);
    }

    global void finish(Database.BatchableContext BC){

    }
    
}