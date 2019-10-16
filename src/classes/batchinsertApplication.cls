global class batchinsertApplication implements Database.Batchable<sObject> {
    
    List<MUSW__License2__c> batchList;
    List<Renewal_Application__c> batchRenewal;
    global batchinsertApplication(List<MUSW__License2__c> objList){
         if (objList == null) objList = new List<MUSW__License2__c>();      
        this.batchList = objList; 
    }
  
    
    global Iterable<sObject> start(Database.BatchableContext BC) {
           return this.batchList;
    }
    
    
    
    global void execute(Database.BatchableContext BC,List<MUSW__License2__c> sobj) {
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