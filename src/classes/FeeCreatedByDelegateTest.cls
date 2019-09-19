/**
* Name: FeeCreatedByDelegateTest
* Type: Class
* Description: Test class for FeeCreatedByDelegate.
* Date:        Developer/Company                 	Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 10/15/2018   Srikanth Kottam/Deloitte           Initial Creation
**/
@isTest
public class FeeCreatedByDelegateTest {
	@testSetup
    public static void createTestData(){
        //Create Account
        Account acc = CreateTestDataUtility.createAccount();
        insert acc;
        //Create Contact
        Contact con = new Contact(LastName = DOL_AppConstants.NULL_EMPTY_STRING + 'firstConLastName', firstName = DOL_AppConstants.NULL_EMPTY_STRING + 'firstConFirstName', Email= DOL_AppConstants.NULL_EMPTY_STRING + 'firstcon@mailinator.com', 
                                  Birthdate = null, AccountId = acc.Id, Social_Security_Number_Encrypted__c = DOL_AppConstants.NULL_EMPTY_STRING + '111222333', 
                                  Duplicate_Override__c = true, Birth_Country__c = DOL_AppConstants.NULL_EMPTY_STRING + 'United States', Birth_State_Province__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Illinois', Birth_City__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Chicago', 
                                  Gender__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Male', Ethnicity__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Asian Indian');
        insert con;
        //Create Community Plus User
        User plusUser = CreateTestDataUtility.createCommunityPlusUser(con.Id);
        plusUser.Alias = DOL_AppConstants.NULL_EMPTY_STRING + 'ppuser';
        plusUser.Email= DOL_AppConstants.NULL_EMPTY_STRING + 'portalplususerone@mailinator.com';
        plusUser.LastName= DOL_AppConstants.NULL_EMPTY_STRING + 'secondConLastName';
        plusUser.UserName= DOL_AppConstants.NULL_EMPTY_STRING + 'portalplususerone@mailinator.com';
        insert plusUser;
    }
    @isTest
    public static void testFeebyDelegate(){
        Account acc = [Select id, name from Account where name =: DOL_AppConstants.NULL_EMPTY_STRING + 'utilityAccountFirstName'];
        Contact con = [Select id, name from Contact where LastName =: DOL_AppConstants.NULL_EMPTY_STRING + 'firstConLastName'];
        User u = [SELECT Id, isActive FROM User WHERE ContactId =: con.Id];
        //Musw__License2__c credential = [Select Id, name from Musw__License2__c where MUSW__Applicant__c =: con.Id];
        Test.startTest();
        system.runAs(u){
            Musw__License2__c credential = CreateTestDataUtility.createLicense(acc.Id, con.Id);
            credential.musw__status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Pending';
            credential.MUSW__Expiration_Date__c = system.today();
            insert credential;
            
            credential.musw__status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Generate Fee';
            update credential;
        }
        //Credential Submission
        List<Musw__License2__c> lstCredential = [Select Id, name, MUSW__Applicant__c, MUSW__Total_Balance__c from Musw__License2__c where MUSW__Applicant__c =: con.Id];
        System.assertEquals(1,lstCredential.size()); 
        Test.stopTest(); 
    }
}