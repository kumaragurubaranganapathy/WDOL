/**
* Name: AccountTriggerHandler_Test
* Type: Handler Class
* Description: Test class for AccountTriggerHandler 
* Date:        Developer/Company                 	Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 08/07/2018   Srikanth Kottam/Deloitte           Initial Creation
**/
@isTest
public class AccountTriggerHandler_Test {
    
    @isTest
    static void Last4FEIN(){
        Global_Settings__c globalSetting = new Global_Settings__c(Name = UserInfo.getUsername(), Disable_Triggers__c = false);
        insert globalSetting;
        Test.startTest();
        /*Creating test Business Account*/
        Account businessacc = new Account();
        businessacc = CreateTestDataUtility.createBusinessAccount();
        /*Inserting test Business Account*/
        insert businessacc;
        string last4FEIN = '';
        List<Account> acc = [Select Id, name, Last_4_Digits_of_FEIN__c from Account where name = 'TestBusinessAccount' limit 1];
        for(Account bAcc : acc){
            last4FEIN = bAcc.Last_4_Digits_of_FEIN__c;
        }
        System.assertEquals('6789', last4FEIN);
        Test.stopTest();
    }
}