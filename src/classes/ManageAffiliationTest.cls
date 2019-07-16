/*******************************************************************************
* Name          :   ManageAffiliationTest
* Author        :   Akosa Okwudiafor
*-------------------------------------------------------------------------------
UPDATES
Version         Developer               Date            Description             
--------------------------------------------------------------------------------
1.0              Akosa Okwudiafor         
--------------------------------------------------------------------------------
*******************************************************************************/

@isTest
private class ManageAffiliationTest {
    static Account acc;
    static Account acc1;
    static Contact c;
    static User u;
    static MUSW__Application2__c  serviceRequest;
    static MUSW__License2__c license;
    
    static void testdata() {
        //creating Account, Contact and User    
        //Create Poral Account
        acc = CreateTestDataUtility.createTestAccount();
        Database.insert(acc);
        
        //Create Citizen Account
        acc1 = CreateTestDataUtility.createCitizenAccount();
        Database.insert(acc1);
        
        //Create Contact
        c = CreateTestDataUtility.createContact(acc.id);
        Database.insert(c);
        
        //Create Portal User 
        u = CreateTestDataUtility.createCommunityTestUser(c.id);
        Database.insert(u);
        
        //create license
        license = CreateTestDataUtility.createLicense(acc.Id,c.Id);
        Database.insert(license);
        
        //create serviceRequest
        serviceRequest = CreateTestDataUtility.createServiceRequest();
        Database.insert(serviceRequest);
        
    }
    @IsTest(SeeAllData=true)
    static void manageaffiliationanddeactivate(){
        testdata() ;
        //stem.runAs(u,{});
        System.runAs(u){
            Test.StartTest();
            //Instantiate VisualForce Page      
            PageReference pgRef = Page.ManageAffiliations; //Create Page Reference - 'AddAffiliation' is the name of Page
            Test.setCurrentPage(pgRef); //Set the page for Test Method
            ApexPages.currentPage().getParameters().put('credentialId', license.Id);//Pass Id to page
            ManageAffiliations submitdocs = new ManageAffiliations();        
            system.assertNotEquals(null, license.Id,'license id is not null');
            system.debug('license.Id is @@@ ' +license.Id);
             submitdocs.deactivateAffiliation();
              ApexPages.currentPage().getParameters().put('licenseId', license.Id);
            submitdocs.addAffiliation();
            Test.stopTest();
        }
    }
    
       @IsTest(SeeAllData=true)
    static void manageaffiliationanddeactivatewithfakeid(){
        testdata() ;
        //stem.runAs(u,{});
        System.runAs(u){
                       Test.StartTest();
            //Instantiate VisualForce Page      
            PageReference pgRef = Page.ManageAffiliations; //Create Page Reference - 'AddAffiliation' is the name of Page
            Test.setCurrentPage(pgRef); //Set the page for Test Method
            ApexPages.currentPage().getParameters().put('credentialId', u.Id);//Pass Id to page
            ManageAffiliations submitdocs = new ManageAffiliations();        
            system.assertNotEquals(null, license.Id,'license id is not null');
            submitdocs.addAffiliation();
            Test.stopTest();
        }
    }
    
    
       @IsTest(SeeAllData=true)
    static void manageaffiliationanddeactivatewithnoid(){
        testdata() ;
        //stem.runAs(u,{});
        System.runAs(u){
            Test.StartTest();
            //Instantiate VisualForce Page      
            PageReference pgRef = Page.ManageAffiliations; //Create Page Reference - 'AddAffiliation' is the name of Page
            Test.setCurrentPage(pgRef); //Set the page for Test Method
            ApexPages.currentPage().getParameters().put('credentialId', null);//Pass Id to page
            ManageAffiliations submitdocs = new ManageAffiliations();        
            Test.stopTest();
        }
    }
    
       @IsTest(SeeAllData=true)
    static void remotesearching(){
        testdata() ;
        System.runAs(u){
            Test.StartTest();     
            ManageAffiliations.findLicenses('LALA');
            Test.stopTest();
        }
    }
}