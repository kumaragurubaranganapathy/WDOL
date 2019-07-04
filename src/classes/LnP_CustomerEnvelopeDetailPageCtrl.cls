public class LnP_CustomerEnvelopeDetailPageCtrl {
    @AuraEnabled
    public static List<MUSW__Deposit__c> fetchDeposits(String recordId){
        List<MUSW__Deposit__c> depositList = new List<MUSW__Deposit__c>();
       // List<MUSW__Deposit__c> depositListToBeUpdated = new List<MUSW__Deposit__c>();
       // Set<Id> licenseIds = new Set<Id>();
        if(recordId != null){
            depositList = [Select Id,name,Form_number__c,Date__c,Amount__c,Document_type__c,wadol_Program_Type__c,Professional_code__c,License_type__c,Contact__c,MUSW__Account__c,License__c,License__r.Name,Fine_Number__c from MUSW__Deposit__c where Validation_number__c =: recordId];
           //Code for mapping license data to deposit data
          /*  for(MUSW__Deposit__c dep: depositList){
                if(dep.License__c != null){
                    licenseIds.add(dep.License__c);
                }
            }
            Map<Id,MUSW__License2__c> licenseMap = new Map<Id,MUSW__License2__c>([Select id,Credential_Type__c,Credential__c,Application_Type__c from MUSW__License2__c where id=:licenseIds]);
            for(MUSW__Deposit__c dep: depositList){
                if(dep.License__c != null && licenseMap.containsKey(dep.License__c) ){
                    if(dep.License_type__c == null || dep.wadol_Program_Type__c == null || (dep.License_type__c != LicenseMap.get(dep.License__c).Credential_Type__c) || (dep.wadol_Program_Type__c != LicenseMap.get(dep.License__c).Application_Type__c)){
                        MUSW__Deposit__c newDep = new MUSW__Deposit__c(Id=dep.Id);
                        newDep.License_type__c = licenseMap.get(dep.License__c).Credential_Type__c;
                        newDep.wadol_Program_Type__c = licenseMap.get(dep.License__c).Application_Type__c;
                        depositListToBeUpdated.add(newDep);
                    }
                }
            }
            if(depositListToBeUpdated.size()>0){
                update depositListToBeUpdated;
                depositList = [Select Id,name,Date__c,Amount__c,Document_type__c,wadol_Program_Type__c,wadol_Professional_Code__c,License_type__c,Contact__c,MUSW__Account__c,License__c,License__r.Name,Missing_Contact__c from MUSW__Deposit__c where Validation_number__c =: recordId];
            } */
            
        }
        
        return depositList;
    }
    
    @AuraEnabled
    public static void submitDeposits(String recordId){
        List<MUSW__Deposit__c> depositListToUpdate = new List<MUSW__Deposit__c>();
        Map<Id,MUSW__Deposit__c> depositRecordsMap ;
        List<LnP_Licence_Application__c> licenseApplicationsToBeCreated = new List<LnP_Licence_Application__c>();
        
        if(recordId != null){
            depositRecordsMap = new Map<Id,MUSW__Deposit__c>([Select Id,name,Status__c,Date__c,Amount__c,Document_type__c,wadol_Program_Type__c,Professional_code__c,License_type__c,Contact__c,MUSW__Account__c,License__c,License_Application__c,Fine_Number__c from MUSW__Deposit__c where Validation_number__c =: recordId]);
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
            
            
            //Logic for creting license Application on click of submit and mapping the license applications to their respective deposit records
            /*for(MUSW__Deposit__c deposit: depositRecordsMap.values()){
                LnP_Licence_Application__c licenseApp;
                if(deposit.License_Application__c != null){
                    licenseApp = new LnP_Licence_Application__c(id = deposit.License_Application__c);
                }else{
                    licenseApp = new LnP_Licence_Application__c();
                }
                licenseApp.Name = deposit.name +'- License App';
                licenseApp.Program_Type__c=deposit.wadol_Program_Type__c;
                licenseApp.License_Type__c=deposit.License_type__c;
                licenseApp.DepositId__c=deposit.Id;
                licenseApplicationsToBeCreated.add(licenseApp);
            }
            
            if(licenseApplicationsToBeCreated.size() >0){
                upsert licenseApplicationsToBeCreated;
            }
            for(LnP_Licence_Application__c licenseApp: licenseApplicationsToBeCreated){
                if(depositRecordsMap.containsKey(licenseApp.DepositId__c)){
                    MUSW__Deposit__c dep  = depositRecordsMap.get(licenseApp.DepositId__c);
                    dep.License_Application__c = licenseApp.Id;
                    depositListToUpdate.add(dep);
                } 
            }
            if(depositListToUpdate.size()>0){
                update depositListToUpdate;
            }*/
            
            
        }
        
        
    }
    
    @AuraEnabled
    public static List<ListView> getObjViews() {
        List<ListView> listviews = 
            [SELECT Id, Name FROM ListView WHERE SobjectType = 'Customer_Envelope__c'];
        
        return listviews;
    }
}