@isTest
private class UpdateAccountSecurityCodeBatch_Test {
	
    @testSetup
    public static void setupTestData(){
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('User Account').getRecordTypeId();
        
        Test.startTest();
        Global_Settings__c globalSetting = new Global_Settings__c(Name = UserInfo.getUsername(), Disable_Triggers__c = true);
        insert globalSetting;
        
        MUSW__GlobalSettings__c muswGlobalSetting = new MUSW__GlobalSettings__c(Name = UserInfo.getUsername(), MUSW__Disable_Triggers__c = true);
		insert muswGlobalSetting;
        
        //Insert Account
        List<Account> accountList = new List<Account>();
        for(Integer i=0; i<5; i++){
            Account acc = new Account(Name= 'Test Account');
            acc.RecordTypeId = AccRecTypeId;
            accountList.add(acc);
        }
        insert accountList;
        
        //Upsert Global Setting        
        globalSetting.Disable_Triggers__c = false;
        update globalSetting;
        
        muswGlobalSetting.MUSW__Disable_Triggers__c = false;
        update muswGlobalSetting;
        Test.stopTest();
    }
    
    @isTest
    private static void testBatch(){
        List<Account> lstAccounts = [Select Id, Security_Code__c From Account where Security_Code__c =: DOL_AppConstants.NULL_EMPTY_STRING + ''];
        system.assertEquals(5, lstAccounts.size());
        
        Test.startTest();
        
        String query = DOL_AppConstants.NULL_EMPTY_STRING + 'Select Id, Security_Code__c From Account where Security_Code__c = \'\'';
        UpdateAccountSecurityCodeBatch batch = new UpdateAccountSecurityCodeBatch(query);
        Database.executeBatch(batch);
        
        Test.stopTest();
        
        List<Account> lstAccounts2 = [Select Id, Security_Code__c From Account where Security_Code__c =: DOL_AppConstants.NULL_EMPTY_STRING + ''];
        system.assertEquals(0, lstAccounts2.size());
    }
    
}