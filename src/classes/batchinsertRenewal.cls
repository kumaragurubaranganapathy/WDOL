global class batchinsertRenewal implements Database.Batchable<sObject> {
    
    List<Renewal_Application__c> batchList;
    global batchinsertRenewal(List<Renewal_Application__c> objList){
         if (objList == null) objList = new List<Renewal_Application__c>();      
        this.batchList = objList; 
    }
  
    
    global Iterable<sObject> start(Database.BatchableContext BC) {
           return this.batchList;
    }
    
    
    
    global void execute(Database.BatchableContext BC,List<Renewal_Application__c> sobj) {
        try {
            insert batchList;
        }
        catch(Exception e){
            //System.debug('error' + e.getMessage());
        }
    }   
    
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations
        //System.debug('exceuted Succesfully::');
    }
}