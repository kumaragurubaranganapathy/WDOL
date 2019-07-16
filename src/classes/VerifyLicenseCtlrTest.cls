@isTest
public class VerifyLicenseCtlrTest {
    
    @testSetup static void setup() {
        Account acc = new Account();
        acc = CreateTestDataUtility.createAccount();
        insert acc;
        Contact con = CreateTestDataUtility.createContact(acc.Id);
        insert con;   
        Musw__License2__c credential = CreateTestDataUtility.createLicense(acc.Id, con.Id);
        credential.MUSW__Status__c = 'Submitted';
        credential.RecordtypeId = Schema.SObjectType.Musw__License2__c.getRecordTypeInfosByName().get('eSLA Portal').getRecordTypeId();
        insert credential;
    }
    
    @isTest static void testRefreshCounty() {
        VerifyLicenseCtlr verifyCtrl = new VerifyLicenseCtlr();
        verifyCtrl.searchField.county = 'Adams';
        verifyCtrl.refreshCounty();
        System.assert(String.isBlank(verifyCtrl.searchField.county));
    }
    
    @isTest static void testAbbreviatedStateOptions() {
        VerifyLicenseCtlr verifyCtrl = new VerifyLicenseCtlr();
        System.assert(verifyCtrl.abbeviatedStateOptions.size()>0);
    }
    
    @isTest static void testCountyOptions(){
        VerifyLicenseCtlr verifyCtrl = new VerifyLicenseCtlr();
        System.assert(verifyCtrl.countyOptions.size()>0);
    }
    
    @isTest static void testSuccessSearch(){
        VerifyLicenseCtlr.SearchFields searchCriteria = new VerifyLicenseCtlr.SearchFields();
        searchCriteria.searchObject = 'both';
        searchCriteria.searchType = 'individual';
        System.assert(VerifyLicenseCtlr.findSearchResult(searchCriteria).size()>0);
    }
    
    @isTest static void testEmptySearch(){
        VerifyLicenseCtlr.SearchFields searchCriteria = new VerifyLicenseCtlr.SearchFields();
        searchCriteria.searchObject = label.API_Permit;
        searchCriteria.searchType = 'individual';
        System.assert(VerifyLicenseCtlr.findSearchResult(searchCriteria).size() == 0);
    }
    
    @isTest static void testVerifyLicenseDetailSuccess(){
        PageReference PageRef = Page.VerifyLicenseDetails;
        Test.setCurrentPage(PageRef);
        Musw__License2__c credential = [Select Id from Musw__License2__c limit 1];
        ApexPages.currentPage().getParameters().put('source', 'MUSW__License2__c');      
        ApexPages.currentPage().getParameters().put('recordId', credential.Id);   
        VerifyLicenseDetailCtlr detailCtrl = new VerifyLicenseDetailCtlr();
        System.assert(detailCtrl.searchResult != null);
    }
    
    @isTest static void testVerifyLicenseDetailFail(){
        VerifyLicenseDetailCtlr detailCtrl = new VerifyLicenseDetailCtlr();
        System.assert(detailCtrl.searchResult == null);  
    }
    
}