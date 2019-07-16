@isTest
public class ProfileCntrlrTest {
@testSetup
    public static void testData(){
        
        //creating Account, Contact and User    
        //Create Portal Account
        
        Global_Settings__c globalSettings = new Global_Settings__c(Name = Userinfo.getUserName(), Disable_Triggers__c = true);
        insert globalSettings; 
        
        Account acc = CreateTestDataUtility.createTestAccount();
        Database.insert(acc);
        
        //Create Citizen Account
        Account acc1 = new Account(name='CITIZEN');
        Database.insert(acc1);
        
        //Create Contact
        Contact c1 = CreateTestDataUtility.createContact(acc.id);
        c1.FirstName = 'Test';
        Database.insert(c1);
        
        //Create Portal User 
        User u1 = CreateTestDataUtility.createCommunityTestUser(c1.id);
        u1.LastName = 'TestProfileUser';
        Database.upsert(u1);
        delete(globalSettings); 
        
    }

	@isTest
    public static void testProfileCntrlr_PersonalInfo(){
        
        Test.startTest();
        Global_Settings__c globalSettings = new Global_Settings__c(Name = Userinfo.getUserName(), Disable_Triggers__c = true);
        insert globalSettings; 
        User u = [select id, Username from User where LastName = 'TestProfileUser' limit 1];
        Contact c = [select id, Served_in_Military__c, Still_Serving_in_Military__c from Contact where FirstName = 'Test' limit 1];
        
        System.runAs(u){
            ProfileCntrlr profileController = new ProfileCntrlr();
            profileController.currentSection = 'personal_info';
            profileController.birthDateString = '2016-06-20';
            profileController.getResultJSON();
            profileController.saveProfileData();
            
            profileController.updateUsername();
            profileController.conObj.Email = u.Username;
            profileController.updateUsername();
        }
        delete(globalSettings); 
        Test.stopTest();
    }

	@isTest
    public static void testProfileCntrlr1_MilitaryInfo(){
        
        Test.startTest();
        
        Global_Settings__c globalSettings = new Global_Settings__c(Name = Userinfo.getUserName(), Disable_Triggers__c = true);
        insert globalSettings; 
        User u = [select id from User where LastName = 'TestProfileUser' limit 1];
        Contact c = [select id, Served_in_Military__c, Still_Serving_in_Military__c from Contact where FirstName = 'Test' limit 1];
        
        c.Served_in_Military__c = 'Yes';
        c.Still_Serving_in_Military__c = 'No';
        update c;
        System.runAs(u){
            ProfileCntrlr profileController = new ProfileCntrlr();
            profileController.currentSection = 'military_info';
            profileController.milStartDate = '';
            profileController.milEndDate = '2016-06-01';
            profileController.saveProfileData();
        }
        
        c.Served_in_Military__c = 'Yes';
        c.Still_Serving_in_Military__c = 'Yes';
        update c;
        System.runAs(u){
            ProfileCntrlr profileController = new ProfileCntrlr();
            profileController.currentSection = 'military_info';
            profileController.milStartDate = '2016-01-01';
            profileController.saveProfileData();
            
            ProfileCntrlr profileController2 = new ProfileCntrlr();
            profileController2.currentSection = 'military_info';
            profileController2.saveProfileData();
        }
        
        c.Served_in_Military__c = 'No';
        c.Still_Serving_in_Military__c = 'No';
        update c;
        System.runAs(u){
            ProfileCntrlr profileController = new ProfileCntrlr();
            profileController.currentSection = 'military_info';
            profileController.saveProfileData();
        }
        delete(globalSettings); 
        Test.stopTest();
    }
}