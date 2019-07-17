/**
 * User Story: 1315
 * Name: DOL_Batch_ApplictionsStatusUpdate
 * Type: Class
 * Description: Batch to update status field to Abandoned if a draft application is not modified for 30 days
 *              & delete the abandoned applications if not modified for 120 days.
 * Date:        - Case#/Project:            - Developer/Company                         - Description
 * ------------------------------------------------------------------------------------------------------------------------- *
 * 07/16/2019   Swapna Satapathy/Deloitte           Initial Creation 
 */
 global with sharing class DOL_Batch_ApplictionsStatusUpdate implements Database.Batchable<sObject>{
 
 global Database.QueryLocator start(Database.BatchableContext BC){
   String queryDraftApplications = 'select id,LastModifiedDate,MUSW__Status__c from MUSW__Application2__c where ((MUSW__Status__c=\'Draft\' OR MUSW__Status__c=\'Withdrawn\') OR (MUSW__Status__c=\'Pending\' OR MUSW__Status__c=\'Under Review\')) OR MUSW__Status__c=\'Abandoned\'';
   return Database.getQueryLocator(queryDraftApplications);
 }
 
  global void execute(Database.BatchableContext BC, List<MUSW__Application2__c> listDraftApplication) {
     List<MUSW__Application2__c>  applicationListToUpdateStatus = new List<MUSW__Application2__c>();
     List<MUSW__Application2__c>  applicationDeleteAbandoned = new List<MUSW__Application2__c>();
        for(MUSW__Application2__c appDraft : listDraftApplication) {
            if(appDraft.MUSW__Status__c != 'Abandoned' && appDraft.LastModifiedDate <= Date.today().addDays(-30)){
            appDraft.MUSW__Status__c = 'Abandoned';
            appDraft.Is_Abandoned__c = true;
            applicationListToUpdateStatus.add(appDraft);}
            
            if(appDraft.MUSW__Status__c == 'Abandoned' && appDraft.LastModifiedDate == Date.today().addDays(-120)){
             applicationDeleteAbandoned.add(appDraft);
            }
        }
        
        try{
            if(!applicationListToUpdateStatus.isEmpty()){
                update applicationListToUpdateStatus;}
            if(!applicationDeleteAbandoned.isEmpty()){
                DOL_CreateErrorLog_Exception.logDeleteDetails(applicationDeleteAbandoned.size()+' applications records were deleted from DOL_Batch_ApplictionsStatusUpdate','execute','DOL_Batch_ApplictionsStatusUpdate');
                delete applicationDeleteAbandoned;
            }
           }
        catch(Exception e){
            System.debug(e);
            DOL_CreateErrorLog_Exception.createErrorLogs(e,'DOL_Batch_ApplictionsStatusUpdate','execute');
           }
    }
    
    global void finish(Database.BatchableContext BC) {
    }
 }