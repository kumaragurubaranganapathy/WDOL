/**
* User Story: 
* Name: ReviewTriggerHandler_Test
* Type: Test Class
* Description: Test Class for ReviewTriggerHandler
* Date:        Developer/Company                    Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 10/18/2018   Sharad Maheshwari/Deloitte           Initial Creation
**/
@isTest
public class ReviewTriggerHandler_Test {
    
    @isTest
    public static void setupTestData(){
        Global_Settings__c globalSetting = new Global_Settings__c(Name = UserInfo.getUsername(), Disable_Triggers__c = true);
        insert globalSetting;
        
        //Creating test Account
        Account acc = new Account();
        acc = CreateTestDataUtility.createAccount();
        insert acc;
        
        //Creating test Contact
        Contact con = CreateTestDataUtility.createContact(acc.Id);
        insert con;   
        
        //Creating test License
        Musw__Permit2__c permit1 = CreateTestDataUtility.createPermit(acc.Id, con.Id);
        permit1.Application_Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Plan Review';
        permit1.Permit_Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'POWTS Petition for Variance'; 
        permit1.Program_Area__c = DOL_AppConstants.NULL_EMPTY_STRING + 'POWTS'; 
        permit1.MUSW__Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Pending';
        insert permit1;
        
        globalSetting.Disable_Triggers__c = false;
        update globalSetting;
        Test.startTest();
        //Creating review
        Datetime startDate1 = Datetime.newInstance(2018, 10, 18, 14, 14, 14);
        Datetime startDate2 = Datetime.newInstance(2018, 10, 17, 14, 14, 14);
        Datetime startDate3 = Datetime.newInstance(2018, 10, 16, 14, 14, 14);
        Datetime startDate4 = Datetime.newInstance(2018, 10, 15, 14, 14, 14);
        Datetime startDate5 = Datetime.newInstance(2018, 10, 14, 14, 14, 14);
        Datetime startDate6 = Datetime.newInstance(2018, 10, 13, 14, 14, 14);
        Datetime startDate7 = Datetime.newInstance(2018, 10, 12, 14, 14, 14);
        Datetime startDate8 = Datetime.newInstance(2018, 10, 11, 14, 14, 14);
        Datetime startDate9 = Datetime.newInstance(2018, 10, 10, 14, 14, 14);
                
        Datetime completedDate1 = Datetime.newInstance(2018, 10, 18, 16, 14, 14);
        Datetime completedDate2 = Datetime.newInstance(2018, 10, 19, 14, 14, 14);
        Datetime completedDate3 = Datetime.newInstance(2018, 10, 22, 14, 14, 14);
        Datetime completedDate4 = Datetime.newInstance(2018, 10, 24, 14, 14, 14);
        Datetime completedDate5 = Datetime.newInstance(2018, 10, 25, 14, 14, 14);
		Datetime completedDate6 = Datetime.newInstance(2018, 10, 26, 14, 14, 14);
        Datetime completedDate7 = Datetime.newInstance(2018, 10, 20, 14, 14, 14);
        Datetime completedDate8 = Datetime.newInstance(2018, 10, 21, 14, 14, 14);
		Datetime completedDate9 = Datetime.newInstance(2018, 10, 23, 14, 14, 14);
        
        List<MUSW__Review__c> reviewList = new List<MUSW__Review__c>();
        MUSW__Review__c review1 = CreateTestDataUtility.createPermitReview(permit1, 
                                                                           startDate1, 
                                                                           completedDate1);
        insert review1;
        review1.MUSW__Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Approved';
        update review1;
        MUSW__Review__c review2 = CreateTestDataUtility.createPermitReview(permit1, 
                                                                           startDate2, 
                                                                           completedDate2);
        insert review2;
        review2.MUSW__Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Approved';
        update review2;
        MUSW__Review__c review3 = CreateTestDataUtility.createPermitReview(permit1, 
                                                                           startDate3, 
                                                                           completedDate3);
        insert review3;
        review3.MUSW__Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Approved';
        update review3;
        
        //
        MUSW__Review__c review4 = CreateTestDataUtility.createPermitReview(permit1, 
                                                                           startDate4, 
                                                                           completedDate4);
        insert review4;
        review4.MUSW__Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Approved';
        update review4;
        
        MUSW__Review__c review5 = CreateTestDataUtility.createPermitReview(permit1, 
                                                                           startDate5, 
                                                                           completedDate5);
        insert review5;
        review5.MUSW__Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Approved';
        update review5;
        
        MUSW__Review__c review6 = CreateTestDataUtility.createPermitReview(permit1, 
                                                                           startDate6, 
                                                                           completedDate6);
        insert review6;
        review6.MUSW__Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Approved';
        update review6;
        
        MUSW__Review__c review7 = CreateTestDataUtility.createPermitReview(permit1, 
                                                                           startDate7, 
                                                                           completedDate7);
        insert review7;
        review7.MUSW__Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Approved';
        update review7;
        
        MUSW__Review__c review8 = CreateTestDataUtility.createPermitReview(permit1, 
                                                                           startDate8, 
                                                                           completedDate8);
        insert review8;
        review8.MUSW__Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Approved';
        update review8;
        
        MUSW__Review__c review9 = CreateTestDataUtility.createPermitReview(permit1, 
                                                                           startDate9, 
                                                                           completedDate9);
        insert review9;
        review9.MUSW__Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Approved';
        update review9;
        
        Test.stopTest();

    }

}