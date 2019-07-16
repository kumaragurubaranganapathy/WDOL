/**
* User Story:  85- Ability to select application type
* Name: ApplicationSelection_CC_Test
* Type: Test Class
* Description: Test Class for ApplicationSelection_CC
* Date:        Developer/Company                    Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 06/19/2018   Sharad Maheshwari/Deloitte           Initial Creation
**/
@isTest
public class ApplicationSelection_CC_Test {
    
    @isTest static void testLicenseSelectionCtlr() {
        
        Global_Settings__c globalSettings = new Global_Settings__c(Name = Userinfo.getUserName(), Disable_Triggers__c = true);
        insert globalSettings;
        Test.startTest();
        
        ApplicationSelection_CC licenseSelectionCtlr = new ApplicationSelection_CC();        
        
        // Test the getAccounts method
        licenseSelectionCtlr.getAccounts();
        
        // Test the getAccountsSerialized method
        licenseSelectionCtlr.getAccountsSerialized();
        
        // Test the getEligibilityQuestions method
        licenseSelectionCtlr.getEligibilityQuestions();
        
        // Test the getInstructions method
        licenseSelectionCtlr.getInstructions();
        
        // Test the saveAndContinue method
        licenseSelectionCtlr.saveAndContinue();
        
        licenseSelectionCtlr.lic.Credential_Type__c = 'Manufactured Homes Credential';
        licenseSelectionCtlr.lic.Application_Type__c = 'Manufactured Homes';
        licenseSelectionCtlr.lic.Credential__c = 'Manufactured Homes Installer';
        licenseSelectionCtlr.lic.Application_Method__c = 'Course Completion';
        //licenseSelectionCtlr.saveAndContinue();
        
        Test.stopTest();
    }
    
    @isTest 
    static void testGetAppInstructionContent() {
        Global_Settings__c globalSettings = new Global_Settings__c(Name = Userinfo.getUserName(), Disable_Triggers__c = true);
        insert globalSettings;
        ApplicationSelection_CC licenseSelectionCtlr = new ApplicationSelection_CC();
        
        System.assertNotEquals(null,licenseSelectionCtlr.getAppInstructionContent());
        
        Account ac = CreateTestDataUtility.createAccount();
        insert ac;
        
        ApplicationSelection_CC.accountObj accobj =new  ApplicationSelection_CC.accountObj(ac.id, ac.Name);
        
        /*Account ac1 = CreateTestDataUtility.createCitizenTestAccount();
        insert ac1;
        */
        Contact con = CreateTestDataUtility.createContact(ac.id);
        insert con;
        
        MUSW__License2__c testlic = CreateTestDataUtility.createLicense(ac.id, con.id);
        insert testlic;
        
        Contact con1 = [select id, name from Contact where id =:con.Id];
        
        //licenseSelectionCtlr.contactId = con1.id;
        String[] statusToCheck = new String[]{'complete', 'submitted'};        
        licenseSelectionCtlr.checkOtherLicenses('', statusToCheck); 
        
    }
    
     @isTest 
    static void testCredentialGetInstructions() {
        Global_Settings__c globalSettings = new Global_Settings__c(Name = Userinfo.getUserName(), Disable_Triggers__c = true);
        insert globalSettings;
        ApplicationSelection_CC licenseSelectionCtlr = new ApplicationSelection_CC();
        licenseSelectionCtlr.lic.Application_Type__c = Label.Str_Trades_Credential;
        licenseSelectionCtlr.lic.Credential_Type__c = 'Soil Professions';
        licenseSelectionCtlr.lic.Credential__c = 'Soil Tester';
        licenseSelectionCtlr.lic.Application_Method__c = 'Examination';
        //licenseSelectionCtlr.lic.MUSW__Primary_Licensee__c = null;
        licenseSelectionCtlr.getInstructions();
        licenseSelectionCtlr.getEligibilityQuestions();
        //licenseSelectionCtlr.saveAndContinue();
        licenseSelectionCtlr.flagupdate();
        
    }
    
    @isTest 
    static void testPermitGetInstructions() {
        Global_Settings__c globalSettings = new Global_Settings__c(Name = Userinfo.getUserName(), Disable_Triggers__c = true);
        insert globalSettings;
        ApplicationSelection_CC permitSelectionCtlr = new ApplicationSelection_CC();
        permitSelectionCtlr.permit.Application_Type__c = 'Plan Review';
        permitSelectionCtlr.getInstructions();
        permitSelectionCtlr.getEligibilityQuestions();
        permitSelectionCtlr.saveAndContinue();
        permitSelectionCtlr.flagupdate();
        
    }
    
    @isTest 
    static void test_getAccounts() {
        Test.startTest();
        
         Global_Settings__c globalSettings = new Global_Settings__c(Name = Userinfo.getUserName(), Disable_Triggers__c = true);
        insert globalSettings; 
        
        Account ac1 = CreateTestDataUtility.createAccount();
        insert ac1;
        
        Contact c = CreateTestDataUtility.createContact(ac1.id);
        insert c;
        
        //User u = CreateTestDataUtility.createCommunityTestUser(c.id);
        //insert u;
        //System.runAs(u){
        ApplicationSelection_CC licenseSelectionCtlr = new ApplicationSelection_CC();
        licenseSelectionCtlr.contactId = c.id;
        //licenseSelectionCtlr.accountType = label.Str_Business;
        licenseSelectionCtlr.lic.credential__c = 'Manufactured Homes Manufacturer';
        licenseSelectionCtlr.getAccounts();
        licenseSelectionCtlr.lic.credential__c = null;
        licenseSelectionCtlr.getAccounts();
        
        //}
        delete(globalSettings); 

        Test.stopTest();
    }
    @isTest 
    static void test_saveAndContinue() {
        Test.startTest();

        Global_Settings__c globalSettings = new Global_Settings__c(Name = Userinfo.getUserName(), Disable_Triggers__c = true);
        insert globalSettings; 
        
        Account ac = CreateTestDataUtility.createAccount();
        insert ac;
        
        Account ac1 = CreateTestDataUtility.createAccount();
        insert ac1;
        
        Contact c = CreateTestDataUtility.createContact(ac1.id);
        insert c;
        
        ApplicationSelection_CC licenseSelectionCtlr = new ApplicationSelection_CC();
        licenseSelectionCtlr.applyFor = label.Str_Exam;
        
        delete(globalSettings); 
        
        Test.stopTest();
    }
}