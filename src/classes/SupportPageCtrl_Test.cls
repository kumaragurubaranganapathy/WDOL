@isTest
public class SupportPageCtrl_Test {
    
    public static testmethod void test_supportpage(){
        
        Newsfeed__c faqtest = new Newsfeed__c(Name = 'testFAQ', Question__c = 'testQuestion', Answer__c ='Testanswer', Section__c = 'Privacy and Security', External_Id__c = 'Test_132456');
        insert faqtest;
        SupportPageCtrl cntrl = new SupportPageCtrl();
        
    }
}