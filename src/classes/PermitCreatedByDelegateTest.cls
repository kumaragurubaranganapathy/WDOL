/**
* Name: PermitCreatedByDelegateTest
* Type: Class
* Description: Test class for PermitCreatedByDelegate.
* Date:        Developer/Company                 	Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 10/15/2018   Srikanth Kottam/Deloitte           Initial Creation
**/
@isTest
public class PermitCreatedByDelegateTest {
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
    public static void testPermitbyDelegate(){
        Account acc = [Select id, name from Account where name = 'utilityAccountFirstName'];
        Contact con = [Select id, name from Contact where LastName = 'firstConLastName'];
        User u = [SELECT Id, isActive FROM User WHERE ContactId =: con.Id];
        Test.startTest();
        system.runAs(u){
            MUSW__Permit2__c permit = CreateTestDataUtility.createPermit(acc.Id, con.Id);
            insert permit;
        }
        List<MUSW__Permit2__c> lstPermit = [Select Id, name from MUSW__Permit2__c where MUSW__Applicant__c =: con.Id];
        System.assertEquals(1,lstPermit.size());
        List<MUSW__Permit2__Share> lstPermitShare = [SELECT Id FROM MUSW__Permit2__Share where ParentId =: lstPermit[0].id or UserOrGroupId =: u.Id];
        System.assertEquals(2,lstPermitShare.size());
        Test.stopTest();
    }
}