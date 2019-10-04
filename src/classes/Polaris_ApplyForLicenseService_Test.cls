@isTest
public class Polaris_ApplyForLicenseService_Test {
	@isTest
    public static void test_fetchUserDetails(){
        Polaris_ApplyForLicenseService.fetchUserDetails();
    }
    
    @isTest
    public static void test_fetchQuestionsDetails(){
        Polaris_ApplyForLicenseService.fetchQuestionsDetails('Architects', 'Architect', 'General Application');
    }
    @isTest
    public static void test_fetchSubsectionIcons(){
        Polaris_ApplyForLicenseService.fetchSubsectionIcons('ApplyForLicense');
    }
    @isTest
    public static void test_fetchMandatorySubsections(){
        Polaris_ApplyForLicenseService.fetchMandatorySubsections('Architects', 'Architect');
    }
    
    @isTest
    public static void test_fetchApplicationFields(){
        Polaris_ApplyForLicenseService.fetchApplicationFields('Architects', 'Architect', 'General Application');
    }
    @isTest
    public static void test_fetchMasterSubmissionDetails(){
        Polaris_ApplyForLicenseService.fetchMasterSubmissionDetails('Architects', 'Architect', 'General Application');
    }
@isTest
    public static void test_fetchApplications(){
        Polaris_ApplyForLicenseService.fetchApplications('123456789012345');
    }
    @isTest
    public static void test_fetchSection(){
        Polaris_ApplyForLicenseService.fetchSection('Architects', 'Architect', 'General Application');
    }
    
    @isTest
    public static void test_fetLicenseDetails(){
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c lic = DOL_TestDataFactory.createLicense(LicRecTypeId1, a.Id, 'Architects', 'Architect', 'General Application');
        
        Polaris_ApplyForLicenseService.fetLicenseDetails(lic.Id);
    }
    
    @isTest
    public static void test_partition(){
        LnP_JSONParser jsonParser = new LnP_JSONParser();
        LnP_JSONParser.CompositeRequest cr = new LnP_JSONParser.CompositeRequest();
        LnP_JSONParser.Body body = new LnP_JSONParser.Body();
        cr.body = body;
        cr.method = 'testMethod';
        cr.referenceId = 'testRefernceId';
        cr.url = 'test.com';
        list<LnP_JSONParser.CompositeRequest> lstString = new List<LnP_JSONParser.CompositeRequest>();
        lstString.add(cr);
        Polaris_ApplyForLicenseService.partition(lstString, 1);
    }

}