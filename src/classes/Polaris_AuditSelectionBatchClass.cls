/*@AUTHOR: Kojashree Kakariya
@Date:  25-June-2019      

Description: Class to select ten percent of renewal and license records for audit process.

MODIFICATION LOG:
DEVELOPER                          DATE                     DESCRIPTION
================================================================================
Kojashree Kakariya               25-June-2019             Initial Creation
================================================================================= */

global class Polaris_AuditSelectionBatchClass implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        return Database.getQueryLocator('SELECT Id, Name,Renewal_Status__c,Credential_Type__c,Application_Type__c,License__c FROM Renewal_Application__c WHERE Renewal_Status__c = \'Complete\' AND Selected_for_Audit__c = FALSE AND Manual_Fee_Generation__c = FALSE AND LastModifiedDate >= LAST_N_DAYS : 30');
    }
     global void execute(Database.BatchableContext bc, List<Renewal_Application__c> renewalAppList){
        // process each batch of records
        system.debug('renewalAppList---'+renewalAppList);
        List<License_Type__mdt> REAppListForAudit = new List<License_Type__mdt>();
        REAppListForAudit = [SELECT Application_Type__c,Credential_Type__c,Is_Available_for_Audit__c,Object_Name__c,RBS_RE__c FROM License_Type__mdt WHERE RBS_RE__c = 'RE' AND Is_Available_for_Audit__c = True AND Object_Name__c = 'Renewal_Application__c'];
     	system.debug('REAppListForAudit--'+REAppListForAudit);
         
        Map<String,List<Renewal_Application__c>> renApplicationMap = new Map<String,List<Renewal_Application__c>>();
        Map<String,List<Renewal_Application__c>> UpdatedApplicationMap = new Map<String,List<Renewal_Application__c>>();
        List<MUSW__Review__c> auditList = new List<MUSW__Review__c>(); 
         
         for(Renewal_Application__c app :  renewalAppList) {
             for(License_Type__mdt masterDataList : REAppListForAudit){
                 if(masterDataList.Credential_Type__c == app.Credential_Type__c){
                     if(renApplicationMap.containsKey(masterDataList.Credential_Type__c)){
                         renApplicationMap.get(masterDataList.Credential_Type__c).add(app);
                         system.debug('renApplicationMap--- in if'+renApplicationMap);
                     } else {
                         renApplicationMap.put(masterDataList.Credential_Type__c, new List<Renewal_Application__c>{app});
                         system.debug('renApplicationMap --in else '+renApplicationMap);
                     }
                 }
             }
         }
         if(!renApplicationMap.isEmpty()){
               UpdatedApplicationMap = LnP_CreateAuditClass.getUpdatedRenewalAppMap(renApplicationMap);
         }

     
         List<Renewal_Application__c> updatedListForAudit = new List<Renewal_Application__c>();
         for (List<Renewal_Application__c> updatedRenAppList : UpdatedApplicationMap.values()) {
             updatedListForAudit.addAll(updatedRenAppList);  
         }
         LnP_CreateAuditClass.createAuditForRE(updatedListForAudit);
         //Call the method for review

     }
     global void finish(Database.BatchableContext bc){
        system.debug('Batch Completed');
        // execute any post-processing operations
    }    
}