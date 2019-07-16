@isTest
public class ForgotUsername_CC_Test {
    public static user uComm;
    public static user uComm2;
    @isTest
    static void testdata() {
        Global_Settings__c globalSettings = new Global_Settings__c(Name = Userinfo.getUserName(), Disable_Triggers__c = true);
        insert globalSettings; 
        list <Account> acctsToInsert = new list <Account> ();
        Account account = CreateTestDataUtility.createAccount(); 
        Database.insert(account);
        
        Contact contact = CreateTestDataUtility.createContact(account.Id);
        contact.Last_4_Digits_of_SSN__c = '9191';
        contact.BirthDate = Date.parse('10/31/1990');
        Database.insert(contact);
        
        user usr = CreateTestDataUtility.createCommunityUser(contact.id);
        Database.insert(usr);
        
        delete globalSettings;
    }
    
    public static testMethod void unitTestPass()
    {
        Test.startTest();
        testdata();
        Global_Settings__c globalSettings = new Global_Settings__c(Name = Userinfo.getUserName(), Disable_Triggers__c = true);
        insert globalSettings;         
        
        ForgotUsername_CC cn = new ForgotUsername_CC();
        cn.con.FirstName = 'utilityConactFirstName' ;
        cn.con.LastName = 'utilityConactLastName' ;
        cn.con.BirthDate = Date.parse('10/31/1990');
        cn.con.Last_4_Digits_of_SSN__c = '9191' ;
        cn.findUserName();
        system.assert(cn.result != null ) ;
        delete(globalSettings); 
        Test.stopTest();
    }
    
 public static testMethod void unitTestFail()
    {
        Test.startTest();
        testdata();
        Global_Settings__c globalSettings = new Global_Settings__c(Name = Userinfo.getUserName(), Disable_Triggers__c = true);
        insert globalSettings; 
        ForgotUsername_CC cn = new ForgotUsername_CC();
        cn.con.FirstName = 'Special1' ;
        cn.con.LastName = 'Special1' ;
        cn.con.BirthDate = Date.parse('10/31/1990');
        cn.con.Last_4_Digits_of_SSN__c = '1191' ;
        cn.findUserName();
        cn.userName = 'Test';
        cn.getResult();
        system.assert(cn.result != null ) ;
        delete(globalSettings); 
        Test.stopTest();
    }

}