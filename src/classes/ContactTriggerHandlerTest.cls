@isTest
public class ContactTriggerHandlerTest {
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
    
    @isTest
    Public static void deceasedContactTest(){
        List<Contact> lstContact = new List<Contact>();
        List<Contact> con = [Select id, name, Deceased_Date__c from Contact where LastName = 'firstConLastName'];
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