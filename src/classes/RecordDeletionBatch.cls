/****************************************************************************************************************************************
** Class Name       : RecordDeletionBatch 
** Description      : Deletes sObject Records on a nightly basis 
**                    (User Story: 212 - Deletion of Records)
** Version          : 1.0
** Built By         : Srikanth Kottam
**----------------------------------------------------------------------------------------------------------------------------------------
** Modification Log:
**----------------------------------------------------------------------------------------------------------------------------------------
** Developer                        Date            Reference               Description
** 
**----------------------------------------------------------------------------------------------------------------------------------------
** Review Log:
**---------------
** Reviewer                  Date           Version               Description
**-----------------------------------------------------------------------------------------------------------------------------------------
**
*******************************************************************************************************************************************/ 
global with sharing class RecordDeletionBatch implements Database.Batchable<sObject> {
    global final String query;
    global RecordDeletionBatch(String q){
        query = q;
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> obj){
        Database.DeleteResult[] drList = Database.delete(obj, false);
        for(Database.DeleteResult dr: drList){
            if(dr.isSuccess()){
               // System.debug('Successfully deleted with ID: ' + dr.getId());
            }
            else{
                for(Database.Error err : dr.getErrors()){
                   // System.debug('The following error has occurred.');  
                  //  System.debug(err.getStatusCode() + ': ' + err.getMessage());
                }
                
            }
        }
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
}