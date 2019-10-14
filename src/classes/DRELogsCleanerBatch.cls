global class DRELogsCleanerBatch implements Database.Batchable<sObject>, Database.Stateful, Schedulable{
    
    global void execute(SchedulableContext ctx) {
        DRELogsCleanerBatch batchReference = new DRELogsCleanerBatch ();
        try{
             database.executebatch(batchReference,20);
        } catch (Exception e) {
            DOL_CreateErrorLog_Exception.logApplicationError(e);
        }
       
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){        
        Integer iArchivalDays = Integer.valueOf(System.Label.DRE_Event_Log_Archival_Days);
        Date dtFinalArchivalDate = System.Today().addDays(-iArchivalDays);
        System.debug('S Incoming Date '+dtFinalArchivalDate);
        String sQuery = 'select id from DRE__DRE_Event_Log__c where createddate < :dtFinalArchivalDate';
        System.debug('  S Query  '+sQuery);
        return Database.getQueryLocator(sQuery);
    }
    
    global void execute(Database.BatchableContext BC, List<DRE__DRE_Event_Log__c> scope){
       
        if(scope <> null && !scope.isEmpty())
        {
            System.debug(' S '+scope.size());
            try{
            delete scope;
            } catch (Exception e) {
            DOL_CreateErrorLog_Exception.logApplicationError(e);
            }
        }
        
    }
    
    global void finish(Database.BatchableContext BC){
        
    }

}