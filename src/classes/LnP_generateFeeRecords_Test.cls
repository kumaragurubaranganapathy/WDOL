@isTest
public class LnP_generateFeeRecords_Test {
    
    public static testmethod void LnP_Dashboard_2_HeaderConstructor(){
        
        //Id RecordTypeIdContact = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        ID RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();        
        ID RecordTypeIdLicense = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        
        MUSW__License2__c liceId = DOL_TestDataFactory.createLicense(RecordTypeIdLicense, 
                                                                     DOL_TestDataFactory.createAccount(RecordTypeIdAccount).Id, 
                                                                     'Appraisal Management Companies', 
                                                                     'Appraisal Management Company', 
                                                                     'General Application');
        liceId.MUSW__Status__c = 'Submitted';        
        liceId.Manual_Fee_Generation__c = true;
        update liceId;         
        
        Renewal_Application__c renew = new Renewal_Application__c();
        renew.License__c = liceId.Id;
        renew.Application_Type__c ='Appraisers - Real Estate';
        renew.Renewal_Reinstatement_Type__c='Reinstatement';
        renew.Online_or_Paper_Application__c='Paper';
        renew.Renewal_Status__c='Submitted';
        renew.Manual_Fee_Generation__c = true;        
        insert renew;       
     
        Test.startTest();
        LnP_generateFeeRecords_Class.generateFeeRecords(liceId.Id);        
        LnP_generateFeeRecords_Class.generateFeeRecords_Renewals(renew.Id);
        
        Test.stopTest();
    }
    public static testmethod void LnP_Dashboard_2_HeaderConstructor1(){
         ID RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();        
        ID RecordTypeIdLicense = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
         MUSW__License2__c liceId1 = DOL_TestDataFactory.createLicense(RecordTypeIdLicense, 
                                                                     DOL_TestDataFactory.createAccount(RecordTypeIdAccount).Id, 
                                                                     'Appraisal Management Companies', 
                                                                     'Appraisal Management Company', 
                                                                     'General Application');
        liceId1.MUSW__Status__c = 'Submitted';        
        liceId1.Manual_Fee_Generation__c = false;
        update liceId1; 
        
        Renewal_Application__c renew1 = new Renewal_Application__c();
        renew1.License__c = liceId1.Id;
        renew1.Application_Type__c ='Appraisers - Real Estate';
        renew1.Renewal_Reinstatement_Type__c='Reinstatement';
        renew1.Online_or_Paper_Application__c='Paper';
        renew1.Renewal_Status__c='Submitted';
        renew1.Manual_Fee_Generation__c = false;        
        insert renew1;
        Test.startTest();
        LnP_generateFeeRecords_Class.generateFeeRecords(liceId1.Id);
        LnP_generateFeeRecords_Class.generateFeeRecords_Renewals(renew1.Id);
        Test.stopTest();
        
    }
}