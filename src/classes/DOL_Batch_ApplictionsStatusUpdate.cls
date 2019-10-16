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
   String queryDraftApplications = DOL_AppConstants.QUERY_DRAFT_APPLICATIONS;
   return Database.getQueryLocator(queryDraftApplications);
 }
 
  global void execute(Database.BatchableContext BC, List<MUSW__Application2__c> listDraftApplication) {
     Date targetDate = Date.today().addDays(-30);
     Time targetTime = Time.newInstance(21, 30, 0, 0);
     List<MUSW__Application2__c>  applicationListToUpdateStatus = new List<MUSW__Application2__c>();
     List<MUSW__Application2__c>  applicationDeleteAbandoned = new List<MUSW__Application2__c>();
        for(MUSW__Application2__c appDraft : listDraftApplication) {
            if(appDraft.MUSW__Status__c != 'Abandoned' && appDraft.LastModifiedDate <= Datetime.newInstanceGmt(targetDate, targetTime)){
            appDraft.MUSW__Status__c = DOL_AppConstants.ABANDONED_STRING;
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
            //System.debug(e);
            DOL_CreateErrorLog_Exception.logApplicationError(e);
           }
    }
    
    global void finish(Database.BatchableContext BC) {
    }
 }