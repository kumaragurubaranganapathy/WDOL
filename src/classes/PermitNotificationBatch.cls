/*************************************************************************************************************
** User Story: None
**************************************************************************************************************
** Name                : PermitNotificationBatch
** Description         : This is the batch class which deals with permit notifications.
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

global class PermitNotificationBatch implements Database.Batchable<sObject>{
    global final String query;
    
    global PermitNotificationBatch(String q){
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
        PermitEmailNotificationHandler.sendNotifications((List<MUSW__Permit2__c>) scope);
    }

    global void finish(Database.BatchableContext BC){

    }
    
}