global class DOL_batchRenewalLetterUpdate implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = DOL_AppConstants.NULL_EMPTY_STRING + 'SELECT id,MUSW__Primary_Licensee__r.Email__c,License_RecordType_Name__c,Print_Renewal_Letter__c,Credential_Type__c,MUSW__Applicant__r.Email FROM MUSW__License2__c where (MUSW__Status__c =\''+DOL_AppConstants.ACTIVE+'\' OR MUSW__Status__c =\''+DOL_AppConstants.INACTIVE+'\' OR MUSW__Status__c=\''+DOL_AppConstants.EXPIRED+'\' ) AND (Print_Renewal_Letter__c!=\''+DOL_AppConstants.COMPLETED+'\' OR Print_Renewal_Letter__c!=\''+DOL_AppConstants.YES+'\') AND (Is_Late_Renewal_Eligible__c= true OR Is_Renewal_Eligible__c=true  ) ';       
        system.debug('query :'+query );
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<MUSW__License2__c> scope) {
        DOL_AppUtility.runfromDolBatchUpdateLicenseStatus = true;
        system.debug('scope :'+scope);	
        for(MUSW__License2__c lic : scope) {            
            if(lic.License_RecordType_Name__c == DOL_AppConstants.INDIVIDUAL && (lic.MUSW__Applicant__r.Email == null || lic.MUSW__Applicant__r.Email == '' ))
            {        
                lic.Print_Renewal_Letter__c = DOL_AppConstants.YES;
            }
            else if((lic.License_RecordType_Name__c == DOL_AppConstants.BUSINESS || lic.License_RecordType_Name__c == DOL_AppConstants.COURSE) && (lic.MUSW__Primary_Licensee__r.Email__c == null || lic.MUSW__Primary_Licensee__r.Email__c == '' ) )
            {
                lic.Print_Renewal_Letter__c = DOL_AppConstants.YES;
            }            
        }        
         try{
            if(!scope.isEmpty()){
                Database.SaveResult[] srList = Database.update(scope, false);                         
                DOL_CreateErrorLog_Exception.logDataBaseSaveDetails(srList, 'DOL_batchRenewalLetterUpdate', 'execute');
            }
        }
        catch(Exception e){
            System.debug(e);
            DOL_CreateErrorLog_Exception.logApplicationError(e);
        }
        
    }
    
    global void finish(Database.BatchableContext BC) {
    }
}