@isTest
public class Lnp_GenarateReviewRecords_RenewaL_Test {
    
    @isTest
    public static void testingBatchMethod(){
        ID RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();        
        ID RecordTypeIdLicense = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        
        MUSW__License2__c liceId = DOL_TestDataFactory.createLicense(RecordTypeIdLicense, 
                                                                     DOL_TestDataFactory.createAccount(RecordTypeIdAccount).Id, 
                                                                     'Appraisal Management Companies', 
                                                                     'Appraisal Management Company', 
                                                                     'General Application');
        liceId.MUSW__Status__c = 'Pending Payment';        
        liceId.Manual_Fee_Generation__c = true;
        //liceId.MUSW__Total_Balance__c = 0;
        update liceId;  
        
        String Review_Generation_Status = Label.Review_Generation_Renewal_Status;
        Id recTypeIdIndividual = Schema.SObjectType.Renewal_Application__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        Renewal_Application__c renew = new Renewal_Application__c();
        renew.RecordTypeId = recTypeIdIndividual;
        renew.License__c = liceId.Id;
        renew.Application_Type__c ='Appraisers - Real Estate';
        renew.Renewal_Reinstatement_Type__c='Reinstatement';
        renew.Online_or_Paper_Application__c='Paper';
        renew.Renewal_Status__c = Review_Generation_Status;
        renew.Manual_Fee_Generation__c = TRUE;
        renew.Total_Fees__c = 0;
        renew.Total_Payments__c  =0;
        insert renew; 
        
        String integration_User = Label.Integration_User;
        String query= DOL_AppConstants.NULL_EMPTY_STRING + 'Select Id,Renewal_Status__c,license_number__c,Total_Balance__c,Manual_Fee_Generation__c,applicant_full_name__c,Renewal_Reinstatement_Type__c,Credential_Type__c,Application_Type__c,Applicant__c,License_Account__c,License__c,License__r.Is_Late_Renewal_Eligible__c, License__r.Deployed__c from Renewal_Application__c where Renewal_Status__c=:Review_Generation_Status AND Total_Balance__c = 0 AND (Manual_Fee_Generation__c = TRUE or Owner.name =:integration_User )';
        
        List<Renewal_Application__c> renewList = [Select Id,Renewal_Status__c,license_number__c,Total_Balance__c,Manual_Fee_Generation__c,applicant_full_name__c,Renewal_Reinstatement_Type__c,Credential_Type__c,Application_Type__c,Applicant__c,License_Account__c,License__c,License__r.Is_Late_Renewal_Eligible__c, License__r.Deployed__c from Renewal_Application__c where Renewal_Status__c=:Review_Generation_Status AND Total_Balance__c = 0 AND (Manual_Fee_Generation__c = TRUE OR Owner.name =:integration_User )];
        system.debug('renewList::'+renewList);
        
        Test.startTest();       
        Lnp_GenarateReviewRecords_RenewalBatch obj1 = new Lnp_GenarateReviewRecords_RenewalBatch();
        DataBase.executeBatch(obj1);
        String sch = '0 46 * * * ?'; //schedule interval time
        system.schedule('Lnp_GenarateReviewRecords_RenewalBatch', sch, obj1); //system method to schedule apex class
        Test.stopTest();
    }
}