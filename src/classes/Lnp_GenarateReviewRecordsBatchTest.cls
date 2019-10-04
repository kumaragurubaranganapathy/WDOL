@isTest
public class Lnp_GenarateReviewRecordsBatchTest {

    public static testmethod void testingBatchMethod(){
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
        
         Renewal_Application__c renew = new Renewal_Application__c();
        renew.License__c = liceId.Id;
        renew.Application_Type__c ='Appraisers - Real Estate';
        renew.Renewal_Reinstatement_Type__c='Reinstatement';
        renew.Online_or_Paper_Application__c='Paper';
        renew.Renewal_Status__c='Pending Payment';
        renew.Manual_Fee_Generation__c = true;        
        insert renew;  
        
        Test.startTest();       
        Lnp_GenarateReviewRecordsBatch obj = new Lnp_GenarateReviewRecordsBatch();
            DataBase.executeBatch(obj);
         Lnp_GenarateReviewRecords_RenewalBatch obj1 = new Lnp_GenarateReviewRecords_RenewalBatch();
            DataBase.executeBatch(obj1);
        Test.stopTest();
    }
}