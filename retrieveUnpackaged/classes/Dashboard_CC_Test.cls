@isTest
public class Dashboard_CC_Test {
    public static Id ContactId;
    public static Id AccountId;
    @testSetup static void setup() {
        Account acc = new Account();
        acc = CreateTestDataUtility.createAccount();
        insert acc;
        Contact con = CreateTestDataUtility.createContact(acc.Id);
        insert con;  
        ContactId = con.Id;
        User portalUser = CreateTestDataUtility.createCommunityTestUser(con.Id); 
        portalUser.isActive = true;           
        Insert portalUser;
        Musw__License2__c pendingCredential = CreateTestDataUtility.createLicense(acc.Id, con.Id);
        Musw__License2__c pendingCredential1 = CreateTestDataUtility.createLicense(acc.Id, con.Id);
        Musw__License2__c activeCredential = CreateTestDataUtility.createLicense(acc.Id, con.Id);
        activeCredential.musw__status__c = 'Active';
        activeCredential.MUSW__Expiration_Date__c = system.today();
        Musw__License2__c activeCredential1 = CreateTestDataUtility.createLicense(acc.Id, con.Id);
        activeCredential1.Application_Type__c = 'Trades Credential'; 
        activeCredential1.Credential_type__c = 'Dwelling Contractor'; 
        activeCredential1.Credential__c = 'Dwelling Contractor';
        activeCredential1.Application_Method__c = 'General Application';
        activeCredential1.musw__status__c = 'Active';
        activeCredential1.MUSW__Expiration_Date__c = system.today() - 1;
        List<Musw__License2__c> credentails = new List<Musw__License2__c>{pendingCredential,pendingCredential1,activeCredential,activeCredential1};
            insert credentails;
        
        MUSW__Permit2__c pendingPermit = CreateTestDataUtility.createPermit(acc.Id, con.Id);
        MUSW__Permit2__c pendingPermit1 = CreateTestDataUtility.createPermit(acc.Id, con.Id);
        MUSW__Permit2__c inactivePermit = CreateTestDataUtility.createPermit(acc.Id, con.Id);
        inactivePermit.musw__status__c = 'Inactive';
        MUSW__Permit2__c activePermit = CreateTestDataUtility.createPermit(acc.Id, con.Id);
        activePermit.musw__status__c = 'Active';
        MUSW__Permit2__c pendingPermitMHC = CreateTestDataUtility.createPermitMHC(acc.Id, con.Id);
        MUSW__Permit2__c inactivePermitMHC = CreateTestDataUtility.createPermitMHC(acc.Id, con.Id);
        inactivePermitMHC.musw__status__c = 'Inactive';
        MUSW__Permit2__c activePermitMHC = CreateTestDataUtility.createPermitMHC(acc.Id, con.Id);
        activePermitMHC.musw__status__c = 'Active';
        activePermitMHC.MUSW__Expiration_Date__c = system.today();
        List<MUSW__Permit2__c> permits = new List<MUSW__Permit2__c>{pendingPermit,pendingPermit1,activePermit,inactivePermit,pendingPermitMHC,activePermitMHC,inactivePermitMHC};
            insert permits;
    }
    
    @isTest static void testSortMethod() {
        Test.setCurrentPageReference(new PageReference('Page.Dashboard')); 
        System.currentPageReference().getParameters().put('applicationType', 'Licenses');
        System.currentPageReference().getParameters().put('type', 'PlanReview');
        
        Test.startTest();
        Account accHAC = [Select Id FROM Account WHERE Name = 'utilityAccountFirstName'];
        Contact c = [Select Id FROM Contact WHERE LastName = 'utilityContactLastName'];
        User u = [SELECT Id, isActive FROM User WHERE ContactId =: c.Id]; 
        
        system.assertEquals(u.IsActive, true);
        System.runAs(u){
            Dashboard_CC dashBoard = new Dashboard_CC();
            System.assert(dashboard.appLicenseList.size()>0, 'Pending credential size should be greater than zero');
            System.assert(dashboard.exLicenseList.size()>0, 'Existing credential size should be greater than zero');
            System.assert(dashboard.appPlanReviewList.size()>0, 'Pending Plan reviews size should be greater than zero');
            System.assert(dashboard.exPlanReviewList.size()>0, 'Existing Plan reviews size should be greater than zero');
            System.assert(dashboard.appPermitList.size()>0, 'Pending Permit size should be greater than zero');
        	System.assert(dashboard.exPermitList.size()>0, 'Pending Permit size should be greater than zero');
            dashBoard.sortParameter = 'credentialName';
            dashBoard.sortListByFieldAsc();
            dashBoard.sortParameter = 'credentialExpiryDt';
            dashBoard.sortListByFieldAsc();
            dashBoard.sortParameter = 'programArea';
            dashBoard.sortListByFieldAsc();
            dashBoard.sortParameter = 'expiryDt';
            dashBoard.sortListByFieldAsc();
        }
        Test.stopTest();
    }
    
    @isTest static void testRenewReinstate() {
        System.currentPageReference().getParameters().put('type', 'PlanReview');
        Account accHAC = [Select Id FROM Account WHERE Name = 'utilityAccountFirstName'];
        Contact c = [Select Id FROM Contact WHERE LastName = 'utilityContactLastName'];
        User u = [SELECT Id, isActive FROM User WHERE ContactId =: c.Id]; 
        MUSW__Permit2__c permitRenewal = [select id,Is_Renewal_Eligible__c from MUSW__Permit2__c where MUSW__Expiration_Date__c =: system.today() limit 1];
        Musw__License2__c licenseRenewal = [select id,Is_Renewal_Eligible__c from Musw__License2__c where MUSW__Expiration_Date__c =: system.today() limit 1];
        system.debug('licenseRenewal>>>>'+licenseRenewal);
        Date expDate = system.today() - 1;
        Musw__License2__c licenseReinstate = [select id,Is_Reinstatement_Eligible__c,MUSW__Expiration_Date__c from Musw__License2__c where MUSW__Expiration_Date__c =: expDate limit 1];
/*        system.debug('licenseReinstate>>>>'+licenseReinstate);
        licenseReinstate.MUSW__Expiration_Date__c = system.today() - 2000;
        update licenseReinstate;
        system.debug('licenseReinstate>>>>'+licenseReinstate);
        Musw__License2__c licenseReinstate2 = [select id,Is_Reinstatement_Eligible__c,MUSW__Expiration_Date__c from Musw__License2__c where id =: licenseReinstate.Id limit 1];
        system.debug('licenseReinstate2>>>>'+licenseReinstate2);
 */       Test.startTest();
        system.assertEquals(u.IsActive, true);
        System.runAs(u){
            Dashboard_CC dashBoard = new Dashboard_CC();
            dashBoard.licensePermitType = 'Permit';
            dashboard.currentLicenseId = permitRenewal.id;
            dashboard.queryRenewReinstate();
            dashBoard.licensePermitType = 'License';
            dashboard.currentLicenseId = licenseRenewal.id;
            dashboard.queryRenewReinstate();
 /*           dashBoard.licensePermitType = 'License';
            dashboard.currentLicenseId = licenseReinstate.id;
            dashboard.queryRenewReinstate();
 */       }
        Test.stopTest();
    }
}