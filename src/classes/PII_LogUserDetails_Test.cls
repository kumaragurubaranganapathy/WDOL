@isTest
private class PII_LogUserDetails_Test {
    
    public static testMethod void LogUserDetailsTest(){
        Global_Settings__c globalSettings = new Global_Settings__c(Name = Userinfo.getUserName(), Disable_Triggers__c = true);
        insert globalSettings;
        
        Test.startTest();
        
        //Set up an account with the utiltiy
        Account acc = CreateTestDataUtility.createAccount();
        insert acc;
        
        //Set up and insert a contact
        Contact con = new Contact (AccountId= acc.id, Email='conemail@example.com', LastName = 'Hill');
        insert con;
        
        //Set up the user to RunAs
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User runUser = new User (Alias = 'runner', FirstName = 'Harold', LastName = 'Hill', Email='hhill@example.com', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US', LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles', ProfileId=p.Id,  UserName='Harold@testorg.com');	
        insert runUser;
        
        System.runAs(runUser){
            
            //Instantiate the Controller and pass in the contact
            PII_LogUserDetails controller = new PII_LogUserDetails (new ApexPages.StandardController(con));
            
            //Verify state 
            system.assertEquals(controller.infoEdit, false);
            system.assertEquals(controller.infoPrint, true);
            system.assertEquals(controller.showRelatedLists, true); 
            
            controller.EditContact();
            
            //Verify state
            system.assertEquals(controller.InfoEdit, true );
            system.assertEquals(controller.infoPrint, false );
            
            controller.savePage ();
            
            //Verify state
            system.assertEquals(controller.infoEdit, false);
            system.assertEquals(controller.infoPrint, true);
            
            controller.createNewLog();
            
            //Verify state
            User chkUser = [SELECT Id FROM User WHERE UserName = 'Harold@testorg.com'];
            Integer chkLog = [SELECT count () FROM PII_Info_Log__c WHERE User__c =: chkUser.Id];
            system.assertEquals(chkLog, 1);
            Test.stopTest();
            delete globalSettings; 
            
        }  	 
    }
}