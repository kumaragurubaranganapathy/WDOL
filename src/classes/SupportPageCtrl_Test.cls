@isTest
public class SupportPageCtrl_Test {
    
    public static testmethod void test_supportpage(){
        
        Newsfeed__c faqtest = new Newsfeed__c(Name = DOL_AppConstants.NULL_EMPTY_STRING + 'testFAQ', Question__c = DOL_AppConstants.NULL_EMPTY_STRING + 'testQuestion', Answer__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Testanswer', Section__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Privacy and Security', External_Id__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Test_132456');
        insert faqtest;
        SupportPageCtrl cntrl = new SupportPageCtrl();
        
    }
}