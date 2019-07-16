@isTest
public class SecurityCodeHelper_Test {
    
    public static testMethod void testContact()     {
        Test.startTest();
        Account ac = CreateTestDataUtility.createAccount();
        insert ac;
        
        Contact con = CreateTestDataUtility.createContact(ac.id);
        insert con;
        
        Test.stopTest();
    }

}