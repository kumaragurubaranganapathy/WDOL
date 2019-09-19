@istest
public class TVSVerifyApplication_Test {
@testSetup
    public static void setupTestData(){
        Global_Settings__c globalSetting = new Global_Settings__c(Name = UserInfo.getUsername(), Disable_Triggers__c = true);
        insert globalSetting;
        
        /*Creating test Account*/
        Account acc = new Account();
        acc = CreateTestDataUtility.createAccount();
        /*Inserting test Account*/
        insert acc;
        
        /*Creating test Contact*/
        Contact con = CreateTestDataUtility.createContact(acc.Id);
        /*Inserting test Contact*/
        insert con;
        
        /*Creating test License*/
        Musw__License2__c license1 = CreateTestDataUtility.createLicense(acc.Id, con.Id);
        license1.Application_Type__c = 'Manufactured Homes'; 
        license1.Credential_type__c = 'Manufactured Homes Credential';
        license1.Credential__c = 'Manufactured Homes Installer';
        license1.Application_Method__c = 'Course Completion';
        insert license1;
        
        Musw__License2__c license2 = CreateTestDataUtility.createLicense(acc.Id, con.Id);
        license2.Application_Type__c = 'Trades Credential'; 
        license2.Credential_type__c = 'Dwelling Contractor';
        license2.Credential__c = 'Dwelling Contractor';
        license2.Application_Method__c = 'General Application';
        insert license2;
        
        Musw__Permit2__c permit1 = CreateTestDataUtility.createPermit(acc.Id, con.Id);
        permit1.Application_Type__c = 'Plan Review';
        permit1.Permit_Type__c = 'POWTS Petition for Variance'; 
        permit1.Program_Area__c = 'POWTS'; 
        permit1.MUSW__Status__c = 'Pending';
        insert permit1;
        
        Musw__Permit2__c permit2 = CreateTestDataUtility.createPermit(acc.Id, con.Id);
        permit2.Application_Type__c = 'Manufactured Homes Communities';
        permit2.Permit_Type__c = 'Manufactured Homes Community Permit'; 
        permit2.Program_Area__c = 'Manufactured Homes Communities'; 
        permit2.MUSW__Status__c = 'Pending';
        insert permit2;
        
        Renewal_Application__c renewalApp1 = CreateTestDataUtility.createRenewal(license1.id, 'Manufactured Homes', 'Manufactured Homes Credential', 'Manufactured Homes Installer', 'Generate Fee', 'Renewal');
        insert renewalApp1;
        
        Renewal_Application__c renewalApp2 = CreateTestDataUtility.createRenewal(license2.id, 'Trades Credential', 'Dwelling Contractor', 'Dwelling Contractor', 'Generate Fee', 'Renewal');
        insert renewalApp2;
        
        globalSetting.Disable_Triggers__c = false;
        update globalSetting;
    }
    
    @isTest
    public static void testTVSVerify01(){
        Test.startTest();
        
        MUSW__License2__c lic = [Select Id, MUSW__Applicant__c From MUSW__License2__c where Credential__c = 'Manufactured Homes Installer' limit 1];
        
        Test.setMock(HttpCalloutMock.class, new TVSVerifyApplication_Test_MockService());
        
        //set board and lic type parameters
        string response = TVSVerifyApplication.verifyDetails(lic.Id, false);
        Test.stopTest();
        
        system.assert(response != null);
    }
    
    @isTest
    public static void testTVSVerify02(){
        Test.startTest();
                
        MUSW__License2__c lic = [Select Id, MUSW__Primary_Licensee__c From MUSW__License2__c where Credential__c = 'Dwelling Contractor' limit 1];
        
        Test.setMock(HttpCalloutMock.class, new TVSVerifyApplication_Test_MockService());
        
        //set board and lic type parameters
        string response = TVSVerifyApplication.verifyDetails(lic.Id, false);
        Test.stopTest();
        
        system.assert(response != null);
    }
    
    @isTest
    public static void testTVSVerify03(){
        Test.startTest();
                
        MUSW__Permit2__c per = [Select Id, MUSW__Applicant__c From MUSW__Permit2__c where Permit_Type__c = 'POWTS Petition for Variance' limit 1];
        
        Test.setMock(HttpCalloutMock.class, new TVSVerify_CC_Test_MockService());
        
        //set board and lic type parameters
        string response = TVSVerifyApplication.verifyDetails(per.Id, false);
        Test.stopTest();
        
        system.assert(response != null);
    }
    
    @isTest
    public static void testTVSVerify04(){
        Test.startTest();
        MUSW__Permit2__c per = [Select Id, MUSW__Account__c From MUSW__Permit2__c where Permit_Type__c = 'Manufactured Homes Community Permit' limit 1];
        
        Test.setMock(HttpCalloutMock.class, new TVSVerify_CC_Test_MockService());
        
        //set board and lic type parameters
        string response = TVSVerifyApplication.verifyDetails(per.Id, false);
        Test.stopTest();
        
        system.assert(response != null);
    } 
    
    @isTest
    public static void testTVSVerify05(){
        Test.startTest();
                
        Renewal_Application__c ren = [Select Id, Applicant__c From Renewal_Application__c where Renewal_Reinstatement_Type__c = 'Renewal' and Credential__c = 'Manufactured Homes Installer' limit 1];
        
        Test.setMock(HttpCalloutMock.class, new TVSVerify_CC_Test_MockService());
        
        //set board and lic type parameters
        string response = TVSVerifyApplication.verifyDetails(ren.Id, false);
        Test.stopTest();
        
        system.assert(response != null);
    }
    
    @isTest
    public static void testTVSVerify06(){
        Test.startTest();
        Renewal_Application__c ren = [Select Id, Licensee__c From Renewal_Application__c where Renewal_Reinstatement_Type__c = 'Renewal' and Credential__c = 'Dwelling Contractor' limit 1];
        
        Test.setMock(HttpCalloutMock.class, new TVSVerify_CC_Test_MockService());
        
        //set board and lic type parameters
        string response = TVSVerifyApplication.verifyDetails(ren.Id, false);
        Test.stopTest();
        
        system.assert(response != null);
    } 
}