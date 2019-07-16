/**
* Name: LicenseCreatedByDelegateTest
* Type: Class
* Description: Test class for LicenseCreatedByDelegate.
* Date:        Developer/Company                 	Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 10/15/2018   Srikanth Kottam/Deloitte           Initial Creation
**/
@isTest
public class LicenseCreatedByDelegateTest {
	@testSetup
    public static void createTestData(){
        //Create Account
        Account acc = CreateTestDataUtility.createAccount();
        insert acc;
        //Create Contact
        Contact con = new Contact(LastName = 'firstConLastName', firstName =  'firstConFirstName', Email='firstcon@mailinator.com', 
                                  Birthdate = null, AccountId = acc.Id, Social_Security_Number_Encrypted__c = '111222333', 
                                  Duplicate_Override__c = true, Birth_Country__c ='United States', Birth_State_Province__c='Illinois', Birth_City__c='Chicago', 
                                  Gender__c='Male', Ethnicity__c='Asian Indian');
        insert con;
        //Create Community Plus User
        User plusUser = CreateTestDataUtility.createCommunityPlusUser(con.Id);
        plusUser.Alias = 'ppuser';
        plusUser.Email='portalplususerone@mailinator.com';
        plusUser.LastName='secondConLastName';
        plusUser.UserName='portalplususerone@mailinator.com';
        insert plusUser;
    }
    @isTest
    public static void testLicensebyDelegate(){
        Account acc = [Select id, name from Account where name = 'utilityAccountFirstName'];
        Contact con = [Select id, name from Contact where LastName = 'firstConLastName'];
        User u = [SELECT Id, isActive FROM User WHERE ContactId =: con.Id];
        //Musw__License2__c credential = [Select Id, name from Musw__License2__c where MUSW__Applicant__c =: con.Id];
        Test.startTest();
        system.runAs(u){
            Musw__License2__c credential = CreateTestDataUtility.createLicense(acc.Id, con.Id);
            credential.musw__status__c = 'Active';
            credential.MUSW__Expiration_Date__c = system.today();
            insert credential;
        }
        //Credential Submission
        List<Musw__License2__c> lstCredential = [Select Id, name, MUSW__Applicant__c from Musw__License2__c where MUSW__Applicant__c =: con.Id];
        system.debug('lstCredential>>>'+lstCredential);
        System.assertEquals(1,lstCredential.size());
        LicenseCreatedByDelegate credDelegate = new LicenseCreatedByDelegate();
        credDelegate.shareLicenseRecords(lstCredential);
        List<Musw__License2__Share> lstCredentialShare = [SELECT Id FROM Musw__License2__Share where ParentId =: lstCredential[0].id or UserOrGroupId =: u.Id];
        System.assertEquals(2,lstCredentialShare.size());
        Test.stopTest();
    }
}