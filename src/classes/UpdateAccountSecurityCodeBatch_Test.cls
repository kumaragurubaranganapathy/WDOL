@isTest
private class UpdateAccountSecurityCodeBatch_Test {
	
    @testSetup
    public static void setupTestData(){
        Global_Settings__c globalSetting = new Global_Settings__c(Name = UserInfo.getUsername(), Disable_Triggers__c = true);
        insert globalSetting;
        
        MUSW__GlobalSettings__c muswGlobalSetting = new MUSW__GlobalSettings__c(Name = UserInfo.getUsername(), MUSW__Disable_Triggers__c = true);
		insert muswGlobalSetting;
        
        List<Account> accounts = new List<Account>();
        for(Integer i=0; i<5; i++){
        	Account acc = CreateTestDataUtility.createAccount();
            accounts.add(acc);
        }
        insert accounts;
        
        globalSetting.Disable_Triggers__c = false;
        update globalSetting;
        
        muswGlobalSetting.MUSW__Disable_Triggers__c = false;
        update muswGlobalSetting;
    }
    
    @isTest
    private static void testBatch(){
        List<Account> lstAccounts = [Select Id, Security_Code__c From Account where Security_Code__c = ''];
        system.assertEquals(5, lstAccounts.size());
        
        Test.startTest();
        
        String query = 'Select Id, Security_Code__c From Account where Security_Code__c = \'\'';
        UpdateAccountSecurityCodeBatch batch = new UpdateAccountSecurityCodeBatch(query);
        Database.executeBatch(batch);
        
        Test.stopTest();
        
        List<Account> lstAccounts2 = [Select Id, Security_Code__c From Account where Security_Code__c = ''];
        system.assertEquals(0, lstAccounts2.size());
    }
    
}