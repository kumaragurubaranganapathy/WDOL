global class Lnp_GenarateReviewRecords_RenewalBatch implements Schedulable, Database.Batchable<SObject>{

    global Database.QueryLocator start (Database.BatchableContext BC) {
    
        String Review_Generation_Status = Label.Review_Generation_Renewal_Status;
        String integration_User = Label.Integration_User;
        String query= DOL_AppConstants.NULL_EMPTY_STRING + 'Select Id,Renewal_Status__c,license_number__c,Total_Balance__c,Manual_Fee_Generation__c,applicant_full_name__c,Renewal_Reinstatement_Type__c,Credential_Type__c,Application_Type__c,Applicant__c,License_Account__c,License__c,License__r.Is_Late_Renewal_Eligible__c, License__r.Deployed__c from Renewal_Application__c where Renewal_Status__c=:Review_Generation_Status AND Total_Balance__c = 0 AND (Manual_Fee_Generation__c = TRUE or Owner.name =:integration_User )';
        return Database.getQueryLocator(query);
    }
    
    global void execute (Database.BatchableContext BC, List<Renewal_Application__c> scope) {
        try {
        
        
        String Review_Creation_Status = Label.Review_Creation_Status_Renewal;
        List<MUSW__Review__c> reviewList = new List<MUSW__Review__c>();
        List<MUSW__Review__c> insertedReviewList = new List<MUSW__Review__c>();
        
                
        for (Renewal_Application__c  renewal_Rec: scope) {
            MUSW__Review__c reviewRec = new MUSW__Review__c();
            renewal_Rec.Renewal_Status__c = Review_Creation_Status;
            reviewRec.Name = renewal_Rec.renewal_reinstatement_type__c+' Review - '+renewal_Rec.applicant_full_name__c+' / '+renewal_Rec.license_number__c;
            reviewRec.MUSW__Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Pending';
            reviewRec.Application_Type__c = renewal_Rec.Application_Type__c;
            reviewRec.License_Type__c = renewal_Rec.Credential_Type__c;
            reviewRec.Review_Type__c = renewal_Rec.renewal_reinstatement_type__c;
            reviewRec.Renewal_Application__c = renewal_Rec.Id;
            reviewRec.License__c = renewal_Rec.License__c;
            reviewList.add(reviewRec);
        }
         
            insertedReviewList = Utilityclass_withsharing.insertList(reviewList); 
            Utilityclass_withsharing.updateList(scope);
            
        } catch (Exception e) {
            DOL_CreateErrorLog_Exception.logApplicationError(e,'Lnp_GenarateReviewRecords_RenewalBatch','execute');
            }
    }
        
    
    
    global void finish (Database.BatchableContext BC) {
        // Leave this blank in this example! Not necessary.
    }
    
    global void execute (SchedulableContext SC) {
        try{
        Integer BatchSize = Integer.Valueof(label.Review_Generation_Batch_Size);
        Database.executeBatch(new Lnp_GenarateReviewRecords_RenewalBatch(),BatchSize);
        }catch (Exception e) {DOL_CreateErrorLog_Exception.logApplicationError(e,'Lnp_GenarateReviewRecords_RenewalBatch','ExecuteSchedulableContext');}
    }
    
}