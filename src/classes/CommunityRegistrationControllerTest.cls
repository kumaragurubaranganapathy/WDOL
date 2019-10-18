@isTest
public class CommunityRegistrationControllerTest {
    @testSetup
    static void makeData(){
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('User_Account').getRecordTypeId();
        Account acc = DOL_TestDataFactory.createAccount(accRecordTypeId);
        
        Id contactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Contact').getRecordTypeId();
        Contact con = DOL_TestDataFactory.createContact(contactRecordTypeId, acc.Id);
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'eSLA Customer Community Plus Login User' LIMIT 1];
        
        User user1 = DOL_TestDataFactory.createPortalUser('Kebeck', 'AK', profileId.Id, 'akebeck@deloitte.com', con.Id);
        User user2 = DOL_TestDataFactory.createUser('Kebeck', 'AK', profileId.Id, 'akebeck@deloitte.com', con.Id);
    }
    
    @isTest
    public static void newCommunityRegisterTestMethod(){
        profile profileId = [SELECT ID FROM profile WHERE name=: DOL_AppConstants.NULL_EMPTY_STRING + 'eSLA Customer Community Plus Login User'];
        //Contact con = [SELECT Id, Name, firstName, lastName FROM Contact LIMIT 1];
        Account acc = [SELECT Id, Name FROM Account LIMIT 1];
        User user1 = [SELECT Id, Name, Username, FirstName, LastName FROM User WHERE Username = 'akebeck@deloitte.com' LIMIT 1];
        
        Test.startTest();
        CommunityRegistrationController.registerNewCommunityUser('Adam','Paul','kEBECKKKKKKKKKKKKKKKKKKKKKKKKKK','8787867876','aman@deloitte.com','User@12345','User@12345','1960-12-31'); 
        //CommunityRegistrationController.registerNewCommunityUser('Adam','Paul','','8787867876','aman@deloitte.com','User@12345','User@12345','1960-12-31'); 
        //CommunityRegistrationController.handleCommunityUserOperations(con, acc.Id, 'User@12345');        
        Test.stopTest();
    }
    
    @isTest
    public static void existingUserTest(){
        profile profileId = [SELECT ID FROM profile WHERE name=: DOL_AppConstants.NULL_EMPTY_STRING + 'eSLA Customer Community Plus Login User'];
        //Contact con = [SELECT Id, Name, firstName, lastName FROM Contact LIMIT 1];
        Account acc = [SELECT Id, Name FROM Account LIMIT 1];
        User user1 = [SELECT Id, Name, Username, FirstName, LastName FROM User WHERE Username != 'akebeck@deloitte.com' LIMIT 1];
        //User user2 = [SELECT Id, Name, Username, FirstName, LastName FROM User WHERE Username = 'akebeck@deloitte.com'];
        
        Test.startTest();
        CommunityRegistrationController.registerNewCommunityUser('Adam','Paul','','8787867876','Garud@deloitte.com','User@12345','User@12345','2015-12-31'); 
        Test.stopTest();
        
    }
}