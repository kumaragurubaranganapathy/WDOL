public class LnP_CustomerEnvelopeDetailPageCtrl {
    @AuraEnabled
    public static List<MUSW__Deposit__c> fetchDeposits(String recordId){
        List<MUSW__Deposit__c> depositList = new List<MUSW__Deposit__c>();
       // List<MUSW__Deposit__c> depositListToBeUpdated = new List<MUSW__Deposit__c>();
       // Set<Id> licenseIds = new Set<Id>();
        if(recordId != null){
            depositList = [Select Id,name,Form_number__c,Date__c,Amount__c,Document_type__c,wadol_Program_Type__c,Professional_code__c,License_type__c,Contact__c,MUSW__Account__c,License__c,License__r.Name,Fine_Number__c,Route_to_Miscellaneous_queue__c from MUSW__Deposit__c where Validation_number__c =: recordId];
        }
        
        return depositList;
    }
    
    @AuraEnabled
    public static void submitDeposits(String recordId){
        List<MUSW__Deposit__c> depositListToUpdate = new List<MUSW__Deposit__c>();
        Map<Id,MUSW__Deposit__c> depositRecordsMap ;
        List<LnP_Licence_Application__c> licenseApplicationsToBeCreated = new List<LnP_Licence_Application__c>();
        
        if(recordId != null){
            depositRecordsMap = new Map<Id,MUSW__Deposit__c>([Select Id,name,Status__c,Date__c,Amount__c,Document_type__c,wadol_Program_Type__c,Professional_code__c,License_type__c,Contact__c,MUSW__Account__c,License__c,License_Application__c,Fine_Number__c,Route_to_Miscellaneous_queue__c from MUSW__Deposit__c where Validation_number__c =: recordId]);
            for(MUSW__Deposit__c dep: depositRecordsMap.values()){
                if(dep.wadol_Program_Type__c != null && (dep.Contact__c != null || dep.MUSW__Account__c != null)){
                    dep.Status__c = 'completed';
                    depositListToUpdate.add(dep);
                }
            }
            
            if(depositListToUpdate.size() >0){
                update depositListToUpdate;
            }
            
            if(depositListToUpdate.size() == depositRecordsMap.values().size()){
                Customer_Envelope__c custEnv = new Customer_Envelope__c(Id=recordId);
            	custEnv.status__c = 'processed';
            	update custEnv;
            }
        }
    }
    
    @AuraEnabled
    public static List<ListView> getObjViews() {
        List<ListView> listviews = 
            [SELECT Id, Name FROM ListView WHERE SobjectType = 'Customer_Envelope__c'];
        
        return listviews;
    }
}