@isTest
private class UpdateSecurityCodeBatch_Test {

    @testSetup
    public static void setupTestData(){
        Global_Settings__c globalSetting = new Global_Settings__c(Name = UserInfo.getUsername(), Disable_Triggers__c = true);
        insert globalSetting;
        
        MUSW__GlobalSettings__c muswGlobalSetting = new MUSW__GlobalSettings__c(Name = UserInfo.getUsername(), MUSW__Disable_Triggers__c = true);
		insert muswGlobalSetting;
        
        Account acc = new Account();
        acc = CreateTestDataUtility.createAccount();
        insert acc;
        
        List<Contact> contacts = new List<Contact>();
        for(Integer i=0; i<5; i++){
        	Contact con = CreateTestDataUtility.createContact(acc.Id);
            contacts.add(con);
        }
        insert contacts;
        
        globalSetting.Disable_Triggers__c = false;
        update globalSetting;
        
        muswGlobalSetting.MUSW__Disable_Triggers__c = false;
        update muswGlobalSetting;
    }
    
    @isTest
    private static void testBatch(){
        List<Contact> lstContacts = [Select Id, Security_Code__c From Contact where Security_Code__c = ''];
        system.assertEquals(5, lstContacts.size());
        
        Test.startTest();
        
        String query = 'Select Id, Security_Code__c From Contact where Security_Code__c = \'\'';
        UpdateSecurityCodeBatch batch = new updateSecurityCodeBatch(query);
        Database.executeBatch(batch);
        
        Test.stopTest();
        
        List<Contact> lstContacts2 = [Select Id, Security_Code__c From Contact where Security_Code__c = ''];
        system.assertEquals(0, lstContacts2.size());
    }
}