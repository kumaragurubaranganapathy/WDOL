/**
* Name: ApexUserSharingModelTest
* Type: Class
* Description: Apex Test Class for ApexUserSharingModel.
* Date:        Developer/Company                 	Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 09/24/2018   Srikanth Kottam/Deloitte           Initial Creation
**/
@isTest
public class ApexUserSharingModelTest {
    @testSetup
    public static void createTestData(){
        //Create Business Account
        Account busAcc = CreateTestDataUtility.createBusinessAccount();
        
        //Create Account
        Account acc = CreateTestDataUtility.createAccount();
        
        List<Account> accList = new List<Account>{busAcc, acc};
            insert accList;
        
        //Create Contact
        Contact firstCon = new Contact(LastName = 'firstConLastName', firstName =  'firstConFirstName', Email='firstcon@mailinator.com', 
                                       Birthdate = null, AccountId = acc.Id, Social_Security_Number_Encrypted__c = '111222333', 
                                       Duplicate_Override__c = true, Birth_Country__c ='United States', Birth_State_Province__c='Illinois', Birth_City__c='Chicago', 
                                       Gender__c='Male', Ethnicity__c='Asian Indian');
        //Create 2nd Contact
        Contact secondCon = new Contact(LastName = 'secondConLastName', firstName =  'secondConFirstName', Email='secondcon@mailinator.com', 
                                        Birthdate = null, AccountId = acc.Id, Social_Security_Number_Encrypted__c = '999888777', 
                                        Duplicate_Override__c = true, Birth_Country__c ='United States', Birth_State_Province__c='Illinois', Birth_City__c='Chicago', 
                                        Gender__c='Male', Ethnicity__c='Asian Indian');
        
        List<Contact> conList = new List<Contact>{firstCon, secondCon};
            insert conList;
        
        //Create Community User
        User portalUser = CreateTestDataUtility.createCommunityTestUser(firstCon.Id);
        portalUser.Alias = 'puser';
        portalUser.Email = 'portaluserone@mailinator.com';
        portalUser.LastName = 'firstConLastName';
        portalUser.UserName = 'portaluserone@mailinator.com';
        
        //Create Community Plus User
        User plusUser = CreateTestDataUtility.createCommunityPlusUser(secondCon.Id);
        plusUser.Alias = 'ppuser';
        plusUser.Email='portalplususerone@mailinator.com';
        plusUser.LastName='secondConLastName';
        plusUser.UserName='portalplususerone@mailinator.com';
        
        List<User> lstUser = new List<User>{portalUser, plusUser};
        insert lstUser;
    }
    @isTest
    Static void testSharing(){
        Test.startTest();
        Account busAcc = [Select Id FROM Account WHERE Name = 'TestBusinessAccount'];
        Account acc = [Select Id FROM Account WHERE Name = 'utilityAccountFirstName'];
        system.debug('busAcc>>>'+busAcc);
        Contact c = [Select Id FROM Contact WHERE LastName = 'secondConLastName'];
        Contact c2 = [Select Id FROM Contact WHERE LastName = 'firstConLastName'];
        User u = [SELECT Id, isActive FROM User WHERE ContactId =: c.Id]; 
        User u2 = [SELECT Id, isActive FROM User WHERE ContactId =: c2.Id];
        //Create Account Contact
        MUSW__Account_Contact__c testAccCon = CreateTestDataUtility.createAccountContact(busAcc.Id,c.Id);
        Database.insert(testAccCon);
        Map<Id, MUSW__Account_Contact__c> insertAccountContact = new Map<Id, MUSW__Account_Contact__c>();
        insertAccountContact.put(testAccCon.Id, testAccCon);
        System.runAs(u){
            //Create Credential
            Musw__License2__c pendingCredential = CreateTestDataUtility.createLicense(acc.Id, c.Id);
            insert pendingCredential; 
            
        }
        List<Musw__License2__c> lstCredential = [Select Id, MUSW__Primary_Licensee__c from Musw__License2__c where MUSW__Primary_Licensee__c =: acc.Id];
        system.debug('lstCredential>>>'+lstCredential);
        system.assertEquals(lstCredential.size(), 1);
        
        List<Musw__License2__share> credShare = [Select id, ParentId, UserOrGroupId, AccessLevel from MUSW__License2__share 
                                                 where ParentId =: lstCredential[0].id or UserOrGroupId =: u.Id];
        system.debug('credShare>>>'+credShare);
        system.assertEquals(credShare.size(), 2);
        System.runAs(u2){
            //Create Credential
            Musw__License2__c activeCredential = CreateTestDataUtility.createLicense(acc.Id, c2.Id);
            insert activeCredential; 
        }
        MUSW__Account_Contact__c updateAccCon = [Select id, MUSW__Account__c, MUSW__Contact__c from MUSW__Account_Contact__c
                                                 where MUSW__Account__c =: busAcc.Id and MUSW__Contact__c =: c.Id];
        updateAccCon.MUSW__Contact__c = c2.Id;
        update testAccCon;
        
        Map<Id, MUSW__Account_Contact__c> updateAccountContact = new Map<Id, MUSW__Account_Contact__c>();
        updateAccountContact.put(updateAccCon.Id, updateAccCon);
        ApexUserSharingModel apexSharing = new ApexUserSharingModel();
        apexSharing.getAccountIds(false, true, insertAccountContact, updateAccountContact);
        Test.stopTest();
    }
}