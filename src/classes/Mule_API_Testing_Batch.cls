global class Mule_API_Testing_Batch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
    private String recepientEmailId {get; set;}
    
    global Mule_API_Testing_Batch(String emailId){
        recepientEmailId = emailId;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
       // System.debug('Mule_API_Testing_Batch::start...');
        return Database.getQueryLocator([select id, Request_Body__c, Request_Type__c, API_URI__c, Headers__c, URL_Params__c from DOL_Mule_API_Info__c]);
    }
    
    global void execute(Database.BatchableContext BC, List<DOL_Mule_API_Info__c> muleAPIInfos){
        for( DOL_Mule_API_Info__c record : muleAPIInfos){
            try{
            HttpResponse httpResp = DOL_HTTP_Utility.doHttpRequest(record.API_URI__c,record.Request_Type__c,record.Request_Body__c,record.URL_Params__c,record.Headers__c);
            record.Response_Status_Code__c = httpResp.getStatusCode();
            record.Response_Body__c = httpResp.getBody();
            } catch(Exception error){
         //       System.debug('error occured :- '+error.getMessage()+' stack trace '+error.getStackTraceString());
            }
        }
        DOL_Dao.save(muleAPIInfos);
    }
    
    global void finish(Database.BatchableContext BC){
        //System.debug('Finished Called ');
    }
}