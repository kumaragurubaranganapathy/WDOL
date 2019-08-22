global class Lnp_GenarateReviewRecordsBatch implements Schedulable, Database.Batchable<SObject>{

    global Database.QueryLocator start (Database.BatchableContext BC) {
    
        String Review_Generation_Status = Label.Review_Generation_Status;
        
        String query='Select Id,Name,applicant_full_name__c,MUSW__Status__c,Manual_Fee_Generation__c,MUSW__Primary_Licensee__r.business_structure__c,Credential_Type__c,Initial_Contracts__c,Application_Type__c,Application_Method__c,Is_Reinstatement_Eligible__c,Application__c,Number_of_Units__c,Is_Renewal_Eligible__c FROM MUSW__License2__c where MUSW__Status__c=:Review_Generation_Status';
        return Database.getQueryLocator(query);
    }
    
    global void execute (Database.BatchableContext BC, List<MUSW__License2__c> scope) {
        try {
                
        String Review_Generation_Status = Label.Review_Generation_Status;
        String Review_Creation_Status = Label.Review_Creation_Status;
        List<MUSW__Review__c> reviewList = new List<MUSW__Review__c>();
        List<MUSW__Review__c> insertedReviewList = new List<MUSW__Review__c>();
        MUSW__Review__c reviewRec = new MUSW__Review__c();
                
        for (MUSW__License2__c  license_Rec: scope) {
            license_Rec.MUSW__Status__c = Review_Creation_Status;
            reviewRec.Name = license_Rec.application_method__c+' Review - '+license_Rec.applicant_full_name__c+' / '+license_Rec.Name;
            reviewRec.MUSW__Status__c ='Pending';
            reviewRec.Application_Type__c = license_Rec.Application_Type__c;
            reviewRec.License_Type__c = license_Rec.Credential_Type__c;
            reviewRec.Review_Type__c = license_Rec.application_method__c;
            reviewRec.License__c = license_Rec.Id;
            reviewList.add(reviewRec);
        }
        
        
            insertedReviewList = Utilityclass_withsharing.insertList(reviewList); 
            Utilityclass_withsharing.updateList(scope);
            
        } catch (Exception e) {
            DOL_CreateErrorLog_Exception.logApplicationError(e,'Lnp_GenarateReviewRecordsBatch','start');
            system.debug('*****************'+e);
            }
    }
        
    
    
    global void finish (Database.BatchableContext BC) {
        // Leave this blank in this example! Not necessary.
    }
    
    global void execute (SchedulableContext SC) {
        Database.executeBatch(new Lnp_GenarateReviewRecordsBatch());
    }
    
}