/****************************************************************************************************************************************
** Class Name       : LicenseUpdateScheduler 
** Description      : Inactivating License Records on nightly basis 
** Version          : 1.0
** Built By         : Padmavathi D
**----------------------------------------------------------------------------------------------------------------------------------------
** Modification Log:
**----------------------------------------------------------------------------------------------------------------------------------------
** Developer                     Date            Reference               Description
** 
**----------------------------------------------------------------------------------------------------------------------------------------
** Review Log:
**---------------
** Reviewer                  Date           Version               Description
**-----------------------------------------------------------------------------------------------------------------------------------------
**
*******************************************************************************************************************************************/ 
global with sharing class LicenseUpdateScheduler implements Schedulable{
    global void execute(SchedulableContext sc){
                String Query = 'Select Id, MUSW__Status__c,MUSW__Expiration_Date__c from MUSW__License2__c where MUSW__Expiration_Date__c<Today and MUSW__Status__c=\'Active\'';
                LicenseUpdateBatch batch = new LicenseUpdateBatch(Query);
                Database.executeBatch(batch, 1000);
    }
}