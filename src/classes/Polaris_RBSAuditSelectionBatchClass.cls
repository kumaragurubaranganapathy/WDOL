/*@AUTHOR: Kojashree Kakariya
@Date:  25-June-2019      

Description: Class to select ten percent of renewal and license records for audit process.

MODIFICATION LOG:
DEVELOPER                          DATE                     DESCRIPTION
================================================================================
Kojashree Kakariya               25-June-2019             Initial Creation
================================================================================= */

global class Polaris_RBSAuditSelectionBatchClass implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        return Database.getQueryLocator('SELECT Id, Name,MUSW__Status__c,Credential_Type__c,Application_Type__c,Is_Renewal_Eligible__c,Renewal_Eligible_Start_Date__c,MUSW__Renewal_Date__c FROM MUSW__License2__c WHERE Is_Renewal_Eligible__c = True AND LastModifiedDate >= LAST_N_DAYS : 30');
    }
    global void execute(Database.BatchableContext bc, List<MUSW__License2__c> RBSLicenseList){
        system.debug('RBSLicenseList---'+RBSLicenseList);
        // process each batch of records
        
        List<License_Type__mdt> RBSAppListForAudit = new List<License_Type__mdt>();
        RBSAppListForAudit = [SELECT Application_Type__c,Credential_Type__c,Is_Available_for_Audit__c,Object_Name__c,RBS_RE__c FROM License_Type__mdt WHERE RBS_RE__c = 'RBS' AND Is_Available_for_Audit__c = True AND Object_Name__c = 'MUSW__License2__c'];
     	system.debug('RBSAppListForAudit--'+RBSAppListForAudit);
        
        Map<String,List<MUSW__License2__c>> rbsApplicationMap = new Map<String,List<MUSW__License2__c>>();
        Map<String,List<MUSW__License2__c>> UpdatedApplicationMap = new Map<String,List<MUSW__License2__c>>();
        List<MUSW__Review__c> auditList = new List<MUSW__Review__c>(); 
         
          for(MUSW__License2__c app :  RBSLicenseList) {
             for(License_Type__mdt masterDataList : RBSAppListForAudit){
                 if(masterDataList.Credential_Type__c == app.Credential_Type__c){
                     if(rbsApplicationMap.containsKey(masterDataList.Credential_Type__c)){
                         rbsApplicationMap.get(masterDataList.Credential_Type__c).add(app);
                         system.debug('rbsApplicationMap--- in if'+rbsApplicationMap);
                     } else {
                         rbsApplicationMap.put(masterDataList.Credential_Type__c, new List<MUSW__License2__c>{app});
                    system.debug('rbsApplicationMap --in else '+rbsApplicationMap);
                     }
                 }
             }
         }
         if(!rbsApplicationMap.isEmpty()){
               UpdatedApplicationMap = LnP_CreateAuditClass.getUpdatedLicenseMap(rbsApplicationMap);
         }
        List<MUSW__License2__c> updatedListForAudit = new List<MUSW__License2__c>();
        for (List<MUSW__License2__c> updatedRenAppList : UpdatedApplicationMap.values()) {
            updatedListForAudit.addAll(updatedRenAppList);  
        }
        LnP_CreateAuditClass.createAuditForRBS(updatedListForAudit);
        //Call the method for review
    }
    global void finish(Database.BatchableContext bc){
        system.debug('Batch Completed');
        // execute any post-processing operations
    }   
}