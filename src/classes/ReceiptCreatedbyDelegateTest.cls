/**
* Name: ReceiptCreatedbyDelegateTest
* Type: Class
* Description: Test class for ReceiptCreatedbyDelegate
* Date:        Developer/Company                 	Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 10/12/2018   Srikanth Kottam/Deloitte           Initial Creation
**/
@istest
public class ReceiptCreatedbyDelegateTest {
    @testSetup
    public static void createTestdata(){
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
    static testmethod void testReceiptbyDelegate()
    {	
        Contact con = [Select id, name from Contact where LastName = 'firstConLastName'];
        User u = [SELECT Id, isActive FROM User WHERE ContactId =: con.Id];
        
        Test.startTest();
        system.runAs(u){
            MUSW__Receipt__c receipt= new MUSW__Receipt__c();
        	receipt.MUSW__Receipt_Paid_By__c = con.Id;
        	receipt.MUSW__Amount_Tendered__c = 100;
        	receipt.MUSW__Amount_Available__c = 0;
        	insert receipt;
        }
        List<MUSW__Receipt__c> lstReceipt = [Select Id, name from MUSW__Receipt__c where MUSW__Receipt_Paid_By__c =: con.id];
        System.assertEquals(1,lstReceipt.size());
        
        List<MUSW__Receipt__Share> lstReceiptSharing= [SELECT Id FROM MUSW__Receipt__Share where ParentId =: lstReceipt[0].id or UserOrGroupId =: u.Id];
        System.assertEquals(1,lstReceiptSharing.size());
        Test.stopTest();
    }
}