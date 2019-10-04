@isTest
public class Polaris_RenewLicenseService_Test {
	@isTest
    public static void testMethod1(){
        Polaris_RenewLicenseService.fetchUserDetails();
    }
    @isTest
    public static void testMethod2(){
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c lic1 = DOL_TestDataFactory.createLicense(LicRecTypeId1, a.Id, 'Architects', 'Architect', 'General Application');
        Endorsement__c endo = DOL_TestDataFactory.createEndorsement(lic1.Id,'Active');
        Polaris_RenewLicenseService.fetchEndorsements(lic1.Id);
        Polaris_RenewLicenseService.fetLicenseDetails(lic1.Id);
    }
    
    @isTest
    public static void testMethod3(){
        Polaris_RenewLicenseService.fetchSubsectionIcons('ApplyForLicense');
        Polaris_RenewLicenseService.fetchSection('Architects', 'Architect','General Application');
        Polaris_RenewLicenseService.fetchApplicationFields('Architects', 'Architect','General Application');
        Polaris_RenewLicenseService.fetchMandatorySubsections('Architects', 'Architect', 'Renewal');
        Polaris_RenewLicenseService.fetchQuestionsDetails('Architects', 'Architect','General Application', 'Renewal');
        Polaris_RenewLicenseService.fetchQuestionsDetails('Architects', 'Architect','General Application', 'Reinstatement');
        Polaris_RenewLicenseService.fetchMasterSubmissionDetails('Architects', 'Architect','General Application', 'Renewal');
        Polaris_RenewLicenseService.fetchMasterSubmissionDetails('Architects', 'Architect','General Application', 'Reinstatement');
        Id recTypeId = Schema.SObjectType.MUSW__Application2__c.getRecordTypeInfosByName().get('General Service Request').getRecordTypeId();
        MUSW__Application2__c app = DOL_TestDataFactory.createApplication(recTypeId);
        Polaris_RenewLicenseService.fetchApplications(app.Id);
    }
    
}