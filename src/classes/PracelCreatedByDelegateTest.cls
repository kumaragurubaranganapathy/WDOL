/**
* Name: PracelCreatedByDelegateTest
* Type: Class
* Description: Test class for PracelCreatedByDelegate
* Date:        Developer/Company                    Description
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
    static testmethod void testReceiptbyDelegate()
    {   
        Contact con = [Select id, name from Contact where LastName =: DOL_AppConstants.NULL_EMPTY_STRING + 'firstConLastName'];
        User u = [SELECT Id, isActive FROM User WHERE ContactId =: con.Id];
        
        Test.startTest();
        system.runAs(u){
            MUSW__Parcel__c parcel= new MUSW__Parcel__c();
            parcel.MUSW__Primary_Contact__c = con.Id;
            parcel.Name = DOL_AppConstants.NULL_EMPTY_STRING + 'A1B2 Street';
            insert parcel;
        }
        List<MUSW__Parcel__c> lstParcel = [Select Id, name from MUSW__Parcel__c where MUSW__Primary_Contact__c =: con.id];
        System.assertEquals(1,lstParcel.size());
        
        List<MUSW__Parcel__Share> lstParcelSharing= [SELECT Id, ParentId, UserOrGroupId, AccessLevel, RowCause FROM MUSW__Parcel__Share 
                                                     where ParentId =: lstParcel[0].id or UserOrGroupId =: u.Id];
       // system.debug('lstParcelSharing>>>'+lstParcelSharing);
        System.assertEquals(2,lstParcelSharing.size());
        Test.stopTest();
    }
}