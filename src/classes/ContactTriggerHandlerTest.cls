@isTest
public class ContactTriggerHandlerTest {
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
    
    @isTest
    Public static void deceasedContactTest(){
        List<Contact> lstContact = new List<Contact>();
        List<Contact> con = [Select id, name, Deceased_Date__c from Contact where LastName =: DOL_AppConstants.NULL_EMPTY_STRING + 'firstConLastName'];
        Test.startTest();
        for(Contact deceasedCon : con){
            deceasedCon.Deceased_Date__c = system.today();
            lstContact.add(deceasedCon);
        }
        if(lstContact.size() > 0){
            Update con;
        }
        Test.stopTest();
    }
}