@isTest
public class select2TestCtrl_test {

    @testSetup
    private static void testdataSetup() {
       Account account = new Account(Name= DOL_AppConstants.NULL_EMPTY_STRING + 'Test Accountuni',UBI_Number__c ='79068467');
        insert account;
    }
    @isTest
    public static void testmethod1() {
        List<Account> lstAcc =[select id from Account where name ='Test Accountuni' limit 1];
        Account account = new Account(Name= DOL_AppConstants.NULL_EMPTY_STRING + 'Test Accountunirrr1',UBI_Number__c ='79068467');
        select2TestCtrl.saveAccount(account);
    }
     @isTest
    public static void testmethod2() {
       MUSW__License2__c obj = new MUSW__License2__c(); 
       select2TestCtrl.getselectOptions(obj,'Application_Type__c');  
    }
}