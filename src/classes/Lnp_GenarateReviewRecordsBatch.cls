global class Lnp_GenarateReviewRecordsBatch implements Schedulable, Database.Batchable<SObject>{

    global Database.QueryLocator start (Database.BatchableContext BC) {
    
        String Review_Generation_Status = Label.Review_Generation_Status;
        String query= DOL_AppConstants.NULL_EMPTY_STRING + 'Select Id,Name,applicant_full_name__c,MUSW__Total_Balance__c,MUSW__Status__c,Manual_Fee_Generation__c,MUSW__Primary_Licensee__r.business_structure__c,Credential_Type__c,Initial_Contracts__c,Application_Type__c,Application_Method__c,Is_Reinstatement_Eligible__c,Application__c,Number_of_Units__c,Is_Renewal_Eligible__c FROM MUSW__License2__c where MUSW__Status__c=:Review_Generation_Status AND MUSW__Total_Balance__c = 0 AND Manual_Fee_Generation__c = TRUE';
        return Database.getQueryLocator(query);
    }
    
    global void execute (Database.BatchableContext BC, List<MUSW__License2__c> scope) {
        try {
        
        String Review_Generation_Status = Label.Review_Generation_Status;
        String Review_Creation_Status = Label.Review_Creation_Status;
        List<MUSW__Review__c> reviewList = new List<MUSW__Review__c>();
        List<MUSW__Review__c> insertedReviewList = new List<MUSW__Review__c>();
        
                
        for (MUSW__License2__c  license_Rec: scope) {
            MUSW__Review__c reviewRec = new MUSW__Review__c();
            license_Rec.MUSW__Status__c = Review_Creation_Status;
            reviewRec.Name = license_Rec.application_method__c+' Review - '+license_Rec.applicant_full_name__c+' / '+license_Rec.Name;
            reviewRec.MUSW__Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Pending';
            reviewRec.Application_Type__c = license_Rec.Application_Type__c;
            reviewRec.License_Type__c = license_Rec.Credential_Type__c;
            reviewRec.Review_Type__c = license_Rec.application_method__c;
            reviewRec.License__c = license_Rec.Id;
            reviewList.add(reviewRec);
        }
        
        
            insertedReviewList = Utilityclass_withsharing.insertList(reviewList); 
            Utilityclass_withsharing.updateList(scope);
            
        } catch (Exception e) {
            DOL_CreateErrorLog_Exception.logApplicationError(e,'Lnp_GenarateReviewRecordsBatch','execute');
            }
    }
        
    
    
    global void finish (Database.BatchableContext BC) {
        // Leave this blank in this example! Not necessary.
    }
    
    global void execute (SchedulableContext SC) {
        try{
        Integer BatchSize = Integer.Valueof(label.Review_Generation_Batch_Size);
        Database.executeBatch(new Lnp_GenarateReviewRecordsBatch(),BatchSize);
        }catch (Exception e) {DOL_CreateErrorLog_Exception.logApplicationError(e,'Lnp_GenarateReviewRecordsBatch','ExecuteSchedulableContext');}
    }
    
}