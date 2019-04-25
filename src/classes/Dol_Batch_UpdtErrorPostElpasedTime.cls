global with sharing class Dol_Batch_UpdtErrorPostElpasedTime implements 
Database.Batchable<sObject>, Database.Stateful , Database.AllowsCallouts {
    
    global Integer elapsedtime;
    global String errorMsg;
    global List<Dol_Batch_Monitor_Detail__c> finalChildList;

    global Dol_Batch_UpdtErrorPostElpasedTime (){
        List<Dol_Integration_Settings__mdt> elapsedSettings = [SELECT MasterLabel, DeveloperName, Value__c  FROM Dol_Integration_Settings__mdt ];
        
        for( Dol_Integration_Settings__mdt settings : elapsedSettings){
            if(Dol_IntegrationUtil.isNotBlank(settings.DeveloperName) && settings.DeveloperName.equalsIgnoreCase('ElapsedTimeToError' )){
                elapsedtime = integer.valueof(settings.Value__c);
            }
            if(Dol_IntegrationUtil.isNotBlank(settings.DeveloperName) && settings.DeveloperName.equalsIgnoreCase('ElapsedErrorMessage')){
                errorMsg = settings.Value__c;
            }
            System.debug('elapsedtime'+elapsedtime);
            System.debug('errorMsg'+errorMsg);
        }
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        System.debug('Dol_Batch_ErrorDetailsAfterElpasedTime::start...');
          return Database.getQueryLocator([Select id,Start_Time__c,End_Time__c,Error_Details__c,Parent_Batch__c,Status__c FROM Dol_Batch_Monitor_Detail__c WHERE Parent_Batch__c !=null AND Status__c = 'Running' AND Start_Time__c !=null AND End_Time__c = null]);
    }
    
    
    global void execute(Database.BatchableContext BC, List<Dol_Batch_Monitor_Detail__c> childrecords){      
        System.debug('Dol_Batch_ErrorDetailsAfterElpasedTime::execute... childrecords -'+childrecords);
        List<Dol_Batch_Monitor_Detail__c> filteredChildList= new List<Dol_Batch_Monitor_Detail__c>();
        List<Dol_Batch_Monitor_Detail__c> finalChildList= new List<Dol_Batch_Monitor_Detail__c>();
        //if(!CommonUtil.isBatchRunning('Dol_Batch_ErrorDetailsAfterElpasedTime')){
        for(Dol_Batch_Monitor_Detail__c child : childrecords){
            Long startTimeLong = child.Start_Time__c.getTime() ;
            Long currentDTLong = DateTime.now().getTime();
            Long milliseconds = currentDTLong - startTimeLong;
            Integer differnceInhours = integer.valueof((milliseconds / 3600000));
            if(differnceInhours >= elapsedtime){
                filteredChildList.add(child);
            }
        }

        if(Dol_IntegrationUtil.isNotEmpty(filteredChildList)){
            for(Dol_Batch_Monitor_Detail__c childRecord : filteredChildList){
                childRecord.Status__c = 'Error';
                childRecord.Error_Details__c = errorMsg;
                childRecord.End_Time__c = System.now();
                finalChildList.add(childRecord);
            }
            System.debug('Dol_Batch_ErrorDetailsAfterElpasedTime::finalChildList -'+finalChildList);
            Database.UpsertResult[] lsr;
            if(!finalChildList.isEmpty()) {
                try{
                    lsr = Database.upsert(finalChildList,false);
                } catch(Exception e) {
                    System.debug('Dol_Batch_ErrorDetailsAfterElpasedTime - Exception: '+e);
                    DebugErrorLoggger.LogError(e, '', '','Dol_Batch_UpdtErrorPostElpasedTime','BatchExecute','Batch Execute Method failed');
                }
            }
        }
    }
    
    
    global void finish(Database.BatchableContext BC){   
    }
}