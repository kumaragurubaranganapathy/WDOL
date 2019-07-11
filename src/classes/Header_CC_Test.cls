@isTest
public class Header_CC_Test {

    @testSetup
    public static void setupTestData(){
        BGBK__CartSettings__c cartSettings = new BGBK__CartSettings__c(Name = 'Default', BGBK__Payable_Parents__c = 'MUSW__License2__c, MUSW__Application2__c, License_Renewal__c', BGBK__Payment_Gateway_Data_Encryption_Key__c = 'BasicGovPayments');
        insert cartSettings;
        
        Account acc = new Account();
        acc = CreateTestDataUtility.createAccount();
        insert acc;
        
        Contact con = CreateTestDataUtility.createContact(acc.Id);
        insert con;
    }
    
    @isTest
    public static void test01(){
        Account acc = [Select Id From Account limit 1];
        Contact con = [Select Id From Contact limit 1];
        User u = CreateTestDataUtility.createCommunityUser(con.Id);
        
        Test.startTest();
        
        System.runAs(u){
            Musw__License2__c license1 = CreateTestDataUtility.createLicense(acc.Id, con.Id);
            insert license1;
            
            MUSW__Fee__c fee = new MUSW__Fee__c();
            fee.MUSW__Amount__c = 188;
            fee.Contact__c = con.Id;
            fee.MUSW__License2__c = license1.Id;
            insert fee;
            
        	Header_cc controller = new Header_cc();
            Integer count = controller.cartCount;
            
            PageReference pageRef = Page.ECart;
            Test.setCurrentPage(pageRef);
            Resources_CC rec = new Resources_CC();
        }
        
        Test.stopTest();
    }
}