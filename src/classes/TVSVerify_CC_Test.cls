@isTest
public class TVSVerify_CC_Test {

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
        
        globalSetting.Disable_Triggers__c = false;
        update globalSetting;
    }
    
    @isTest
    public static void testTVSVerify01(){
        Test.startTest();
        PageReference pageRef = Page.TVSVerify;
        Test.setCurrentPage(pageRef);
        
        MUSW__License2__c lic = [Select Id, MUSW__Applicant__c From MUSW__License2__c where Credential__c = 'Manufactured Homes Installer' limit 1];
        
        //set board and lic type parameters
        ApexPages.currentPage().getParameters().put('id', lic.Id);
        
        Test.setMock(HttpCalloutMock.class, new TVSVerify_CC_Test_MockService());
        
        TVSVerify_CC con = new TVSVerify_CC();
      //  con.waitingForResult = true;
        con.verifyDetails();
      //  con.waitingForResult = false;
        Test.stopTest();
        
        Contact con1 = [Select Id, DOR_Response__c, DOR_Response_Date__c From Contact where Id = : lic.MUSW__Applicant__c limit 1];
        system.assert(con1.DOR_Response__c != null);
        system.assert(con1.DOR_Response_Date__c != null);
    }
    
    @isTest
    public static void testTVSVerify02(){
        Test.startTest();
        PageReference pageRef = Page.TVSVerify;
        Test.setCurrentPage(pageRef);
        
        MUSW__License2__c lic = [Select Id, MUSW__Primary_Licensee__c From MUSW__License2__c where Credential__c = 'Dwelling Contractor' limit 1];
        
        //set board and lic type parameters
        ApexPages.currentPage().getParameters().put('id', lic.Id);
        
        Test.setMock(HttpCalloutMock.class, new TVSVerify_CC_Test_MockService());
        
        TVSVerify_CC con = new TVSVerify_CC();
        con.verifyDetails();
        Test.stopTest();
        
        Account acc1 = [Select Id, DOR_Response__c, DOR_Response_Date__c From Account where Id = : lic.MUSW__Primary_Licensee__c limit 1];
        system.assert(acc1.DOR_Response__c != null);
        system.assert(acc1.DOR_Response_Date__c != null);
    }
    
    @isTest
    public static void testTVSVerify03(){
        Test.startTest();
        PageReference pageRef = Page.TVSVerify;
        Test.setCurrentPage(pageRef);
        
        MUSW__Permit2__c per = [Select Id, MUSW__Applicant__c From MUSW__Permit2__c where Permit_Type__c = 'POWTS Petition for Variance' limit 1];
        
        //set board and lic type parameters
        ApexPages.currentPage().getParameters().put('id', per.Id);
        
        Test.setMock(HttpCalloutMock.class, new TVSVerify_CC_Test_MockService());
        
        TVSVerify_CC con = new TVSVerify_CC();
        con.verifyDetails();
        Test.stopTest();
        
        Contact con1 = [Select Id, DOR_Response__c, DOR_Response_Date__c From Contact where Id = : per.MUSW__Applicant__c limit 1];
        system.assert(con1.DOR_Response__c != null);
        system.assert(con1.DOR_Response_Date__c != null);
    }
    
    @isTest
    public static void testTVSVerify04(){
        Test.startTest();
        PageReference pageRef = Page.TVSVerify;
        Test.setCurrentPage(pageRef);
        
        MUSW__Permit2__c per = [Select Id, MUSW__Account__c From MUSW__Permit2__c where Permit_Type__c = 'Manufactured Homes Community Permit' limit 1];
        
        //set board and lic type parameters
        ApexPages.currentPage().getParameters().put('id', per.Id);
        
        Test.setMock(HttpCalloutMock.class, new TVSVerify_CC_Test_MockService());
        
        TVSVerify_CC con = new TVSVerify_CC();
        con.verifyDetails();
        Test.stopTest();
        
        Account acc1 = [Select Id, DOR_Response__c, DOR_Response_Date__c From Account where Id = : per.MUSW__Account__c limit 1];
        system.assert(acc1.DOR_Response__c != null);
        system.assert(acc1.DOR_Response_Date__c != null);
    }
    
}