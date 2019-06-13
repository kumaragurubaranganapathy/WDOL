/****************************************************************************************************************************************
** Class Name       : LicenseUpdateBatch 
** Description      : Inactivating License Records on nightly basis 
** Version          : 1.0
** Built By         : D Padmavathi
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
global with sharing class LicenseUpdateBatch implements Database.Batchable<sObject>,Database.Stateful{
    global final String query;
    global List<MUSW__License2__c> licenseMasterList;
    global LicenseUpdateBatch(String q){
        query = q;
        licenseMasterList = new List<MUSW__License2__c>();
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<MUSW__License2__c> licenseList){
       // List<MUSW__License2__c> licenseMasterList = new List<MUSW__License2__c>();
       for(MUSW__License2__c license: licenseList){
           license.MUSW__Status__c='Inactive';
           licenseMasterList.add(license);
        }
    }
    
    global void finish(Database.BatchableContext BC){
         update licenseMasterList;
    }
}