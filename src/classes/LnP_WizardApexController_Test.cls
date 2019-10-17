@isTest
public class LnP_WizardApexController_Test {

    @isTest
    public static void unitTest01(){
        test.startTest();
        List<MUSW__License2__c> licList = LnP_WizardApexController.fetchLicenseList('Geologist', 'Geologist');
        test.stopTest();
    }
    
    @isTest
    public static void unitTest02(){
        test.startTest();
        List<MUSW__License2__c> licList = LnP_WizardApexController.fetchLicenseList('Geologist', 'Architect');
        LnP_WizardApexController.questionForLicenceTyep('Geologist', 'Geologist', 'General Application', 'MUSW__License2__c', 'Reinstatement');
        test.stopTest();
    }
    
    @isTest
    public static void unitTest03(){
        test.startTest();
        Integer licCount = LnP_WizardApexController.validationForTemporaryLicenses('Appraisers - Real Estate', 'Temporary Certified General', 'General Application', 'MUSW__License2__c');
        LnP_WizardApexController.questionForLicenceTyep('Geologist', 'Geologist','General Application' ,'MUSW__License2__c' , 'Renewal');
        LnP_WizardApexController.fetchCnBLabels('Eligible_Not_Pub', 'Notary Public');
        test.stopTest();
    }
    
    
    @isTest
    public static void unitTest04(){
        test.startTest();
        Map<String,Question__c> questMap = LnP_WizardApexController.questionForLicenceTyep('Geologist', 'Geologist', 'General Application', 'MUSW__License2__c');
        LnP_WizardApexController.fetchInstructions('Geologist', 'Geologist', 'General Application','MUSW__License2__c' , '', '');
        LnP_WizardApexController.fetchLicenseType('Business');
        LnP_WizardApexController.fetchLicenseType('Individual');
        LnP_WizardApexController.getAllStaticTexts();
        LnP_WizardApexController.getPicklistOptions('MUSW__License2__c', 'Application_Type__c', 'Credential_Type__c');
        test.stopTest();
        
    }
    
    @isTest
    public static void unitTest05(){
        test.startTest();
        LnP_WizardApexController.fetchAccountList('Appraisal Management Companies', 'Appraisal Management Company');
        test.stopTest();
    }
    
    @isTest
    public static void unitTest06(){
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('User_Account').getRecordTypeId();
        Account acc = DOL_TestDataFactory.createAccount(accRecordTypeId);
        
        Id contactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Contact').getRecordTypeId();
        Contact con = DOL_TestDataFactory.createContact(contactRecordTypeId, acc.Id);
        
        MUSW__Account_Contact__c accCon = DOL_TestDataFactory.createAccountContact();
               
        Id licRecordTypeId = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByDeveloperName().get('Business').getRecordTypeId();
        MUSW__License2__c lic = DOL_TestDataFactory.createLicense(licRecordTypeId, acc.Id, 'Timeshares', 'Timeshare Company', 'General Application');
        lic.MUSW__Applicant__c = con.Id;
        update lic;
        String licId = lic.id;
        String accId = acc.id;
       
        test.startTest();
            LnP_WizardApexController.startAnApplication('Timeshares', 'Timeshare Company', 'General Application', accId, licId);
            LnP_WizardApexController.startRenewalApplication('Timeshares', 'Timeshare Company', 'General Application',accId , 'True', licId);
       
       test.stopTest();
    }
    
    
    
}