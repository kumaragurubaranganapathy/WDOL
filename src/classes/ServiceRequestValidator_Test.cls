@isTest
public class ServiceRequestValidator_Test {

    @testSetup
    public static void setupTestData(){
        Account acc = new Account();
        acc = CreateTestDataUtility.createAccount();
        insert acc;
        
        Contact con = CreateTestDataUtility.createContact(acc.Id);
        insert con;
        
        CreateTestDataUtility.createPageDefinitionServiceRequest('Change Name', 'Change Name');
    }
    
    @isTest
    public static void testValidator(){
        Contact con = [Select Id From Contact limit 1];
        User u = CreateTestDataUtility.createCommunityUser(con.Id);
        
        Test.startTest();
        
        System.runAs(u){
            MUSW__Application2__c sr = CreateTestDataUtility.createServiceRequest();
            sr.MUSW__Applicant__c = con.Id;
            sr.MUSW__Type__c = 'Change Name';
            sr.Section_Number__c = 99;
            sr.Reason_for_Submitting_Service_Request__c = 'Test';
            insert sr;
            
            sr.Reason_for_Submitting_Service_Request__c = '';
            sr.MUSW__Type__c = 'Relinquish Delegated Agent Status';
            sr.Requested_Effective_Date__c = Date.today();
            
            BaseValidator v = new BaseValidator();
            v.validateServiceRequest(BaseValidator.ApplicationObjectType.ServiceRequest,  sr);
        }
        
        Test.stopTest();
    }
}