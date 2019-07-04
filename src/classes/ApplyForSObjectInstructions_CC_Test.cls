/**
* User Story:  85- Ability to select application type
* Name: ApplyForSObjectInstructions_CC_Test
* Type: Test Class
* Description: Test Class for ApplyForSObjectInstructions_CC
* Date:        Developer/Company                    Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 06/19/2018   Sharad Maheshwari/Deloitte           Initial Creation
**/
@isTest
public class ApplyForSObjectInstructions_CC_Test {
    
    @isTest static void testLicenseSelectionCtlr() {
        
        Global_Settings__c globalSettings = new Global_Settings__c(Name = Userinfo.getUserName(), Disable_Triggers__c = true);
        insert globalSettings;
        Test.startTest();
        
        ApplyForSObjectInstructions_CC licenseSelectionCtlr = new ApplyForSObjectInstructions_CC();        
        
        // Test the getAccounts method
        Test.setCurrentPageReference(new PageReference('Page.myPage'));
        System.currentPageReference().getParameters().put('applicationType', label.Str_Trades_Credential);
		System.currentPageReference().getParameters().put('renewalOrReinstatement', 'Renewal');
        System.currentPageReference().getParameters().put('credential', 'Dwelling Contractor');
		System.currentPageReference().getParameters().put('credentialType', 'Dwelling Contractor');
        System.currentPageReference().getParameters().put('applicationMethod', 'General Application');
        licenseSelectionCtlr.getURLParameters();
        
        Test.setCurrentPageReference(new PageReference('Page.myPage'));
        System.currentPageReference().getParameters().put('applicationType', label.Str_Trades_Credential);
		System.currentPageReference().getParameters().put('renewalOrReinstatement', 'Reinstatement');
        licenseSelectionCtlr.getURLParameters();
        
        // Test the getInstructions method
        licenseSelectionCtlr.getInstructions();
        
        // Test the saveAndContinue method
        licenseSelectionCtlr.proceedToApplication();
        Test.stopTest();
    }
    
    @isTest 
    static void testGetAppInstructionContent() {
        Global_Settings__c globalSettings = new Global_Settings__c(Name = Userinfo.getUserName(), Disable_Triggers__c = true);
        insert globalSettings;
        ApplyForSObjectInstructions_CC licenseSelectionCtlr = new ApplyForSObjectInstructions_CC();
        System.assertNotEquals(null,licenseSelectionCtlr.getAppInstructionContent());
        
    }
    
     @isTest 
    static void testCredentialGetInstructions() {
        Global_Settings__c globalSettings = new Global_Settings__c(Name = Userinfo.getUserName(), Disable_Triggers__c = true);
        insert globalSettings;
        ApplyForSObjectInstructions_CC licenseSelectionCtlr = new ApplyForSObjectInstructions_CC();
        licenseSelectionCtlr.applicationType = Label.Str_Trades_Credential;
        licenseSelectionCtlr.getInstructions();
        licenseSelectionCtlr.proceedToApplication();
    }
    
    @isTest 
    static void testPermitGetInstructions() {
        Global_Settings__c globalSettings = new Global_Settings__c(Name = Userinfo.getUserName(), Disable_Triggers__c = true);
        insert globalSettings;
        ApplyForSObjectInstructions_CC permitSelectionCtlr = new ApplyForSObjectInstructions_CC();
        
        Test.setCurrentPageReference(new PageReference('Page.myPage'));
        System.currentPageReference().getParameters().put('applicationType', 'Plan Review');
		System.currentPageReference().getParameters().put('renewalOrReinstatement', 'Renewal');
        System.currentPageReference().getParameters().put('permitType', 'POWTS Individual Site Design');
		System.currentPageReference().getParameters().put('programArea', 'POWTS');
        permitSelectionCtlr.getURLParameters();
        System.currentPageReference().getParameters().put('renewalOrReinstatement', 'Reinstatement');
        permitSelectionCtlr.getURLParameters();
        System.currentPageReference().getParameters().put('applicationType', 'Permit to Operate');
		permitSelectionCtlr.getURLParameters();
        System.currentPageReference().getParameters().put('applicationType', 'Manufactured Homes Communities');
		permitSelectionCtlr.getURLParameters();
        permitSelectionCtlr.getInstructions();
        permitSelectionCtlr.proceedToApplication();
        
    }
}