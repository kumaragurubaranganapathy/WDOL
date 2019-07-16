/**
* Name: PracelCreatedByDelegateTest
* Type: Class
* Description: Test class for PracelCreatedByDelegate
* Date:        Developer/Company                 	Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 10/12/2018   Srikanth Kottam/Deloitte           Initial Creation
**/
@istest
public class PracelCreatedByDelegateTest {
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
            MUSW__Parcel__c parcel= new MUSW__Parcel__c();
        	parcel.MUSW__Primary_Contact__c = con.Id;
        	parcel.Name = 'A1B2 Street';
        	insert parcel;
        }
        List<MUSW__Parcel__c> lstParcel = [Select Id, name from MUSW__Parcel__c where MUSW__Primary_Contact__c =: con.id];
        System.assertEquals(1,lstParcel.size());
        
        List<MUSW__Parcel__Share> lstParcelSharing= [SELECT Id, ParentId, UserOrGroupId, AccessLevel, RowCause FROM MUSW__Parcel__Share 
                                                     where ParentId =: lstParcel[0].id or UserOrGroupId =: u.Id];
        system.debug('lstParcelSharing>>>'+lstParcelSharing);
        System.assertEquals(2,lstParcelSharing.size());
        Test.stopTest();
    }
}