/****************************************************************************************************************************************
** Class Name       : RecordDeletionScheduler 
** Description      : Deletes sObject Records on a nightly basis 
**					  (User Story: 212 - Deletion of Records)
** Version          : 1.0
** Built By         : Srikanth Kottam
**----------------------------------------------------------------------------------------------------------------------------------------
** Modification Log:
**----------------------------------------------------------------------------------------------------------------------------------------
** Developer                 		Date            Reference               Description
** 
**----------------------------------------------------------------------------------------------------------------------------------------
** Review Log:
**---------------
** Reviewer                  Date           Version               Description
**-----------------------------------------------------------------------------------------------------------------------------------------
**
*******************************************************************************************************************************************/ 
global with sharing class RecordDeletionScheduler implements Schedulable{
    global void execute(SchedulableContext sc){
        List<Object_API_Setting__mdt> objectMetadata = [Select Id, MasterLabel, Object_API_Name__c from Object_API_Setting__mdt limit 200];
        for(Object_API_Setting__mdt objectApi : objectMetadata){
            if(objectApi.Object_API_Name__c != null){
                String Query = 'Select Id, Marked_for_Deletion__c from ' + objectApi.Object_API_Name__c + ' where Marked_for_Deletion__c=true';
                RecordDeletionBatch batch = new RecordDeletionBatch(Query);
                Database.executeBatch(batch, 1000);
            }
        }
    }
}