/**
* Name: BusinessUtilityTest
* Type: Class
* Description: Test class for BusinessUtility class
* Date:        Developer/Company                    Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 09/25/2018   Srikanth Kottam/Deloitte           Initial Creation
**/
@isTest
public class BusinessUtilityTest {
	public static User u ;
	
	static
	{
		u = CreateUserTestDataUtility.createCommunityUser();
	}
	
	public static testmethod void unitTestOne()
	{
		Test.startTest();
		User nU = BusinessUtility.getUserDetails(u.Id , u.ProfileId) ;
		system.assert(nU != null ) ;
		Test.stopTest() ;
	}
	
	public static testmethod void unitTest2()
	{
		Test.startTest();
         Global_Settings__c globalSettings = new Global_Settings__c(Name = Userinfo.getUserName(), Disable_Triggers__c = true);
		insert globalSettings; 
		try
		{
		User nU = BusinessUtility.getUserDetails(UserInfo.getUserId() , userInfo.getProfileId()) ;
		system.assert(nU != null ) ;
		
		Database.SaveResult re = BusinessUtility.deactivateCommunityUser(nU) ;
		}catch(exception ex)
		{
		}
        
        delete(globalSettings); 
		Test.stopTest() ;
	}   
    
    public static testmethod void unitTest3()
    {
        Test.startTest();
        Global_Settings__c globalSettings = new Global_Settings__c(Name = Userinfo.getUserName(), Disable_Triggers__c = true);
        insert globalSettings; 
        
        Account ac = CreateTestDataUtility.createTestAccount();
        insert ac;
        
        Contact c = CreateTestDataUtility.createContact(ac.id);
        insert c;
        
        User nU = BusinessUtility.getUserDetails(UserInfo.getUserId() , userInfo.getProfileId()) ; 
        Account ac1 = CreateTestDataUtility.createTestAccount();
        insert ac1;
        
        Contact c1 = CreateTestDataUtility.createContact(ac1.id);
        insert c1;
        
        MUSW__Parcel__c p =  CreateTestDataUtility.createAccountParcel(ac.id, c.id, 'aghdsg Street', 'hsgdga city', 'FL', '46322', 'United States' );
        insert p;
        
        Parcel_Account__c pc = CreateTestDataUtility.createParcelAccountJunction(p.id, ac.Id);
        insert pc;
        
        List<Parcel_Account__c> listpaccounts = new List<Parcel_Account__c>();
        listpaccounts.add(pc);
        
        MUSW__Account_Contact__c testacccontact =  CreateTestDataUtility.createAccountContact(ac.id, c.id);
        insert testacccontact;
        
        BusinessUtility.AccountJunctionResult aob = new BusinessUtility.AccountJunctionResult(ac, listpaccounts, testacccontact);
        
        BusinessUtility ob = new BusinessUtility();
        BusinessUtility.NewBusiness nob = new BusinessUtility.NewBusiness();
        
        nob.registeredAs = 'ABCXYZ';
        nob.accountName = 'taccount';
        nob.contactId = c.id;
        nob.firmCertificate = 'jfhsd';
        nob.contactPerson = 'testcontactperson';
        nob.contactPersonFirstName = 'testfirstnamecontact';
        nob.contactPersonLastName = 'testcontactlastname';
        nob.FEINNumbersole = '673216471';
        nob.SSNNumber = '723676111';
        nob.website = 'www.salesforce.com';
        nob.phoneNumber = '2678672222';
        nob.fax = '7265767622';
        nob.email = 'fdghgsd@test.com';
        nob.primaryContactEmail = 'gsdhgsh@test.com';
        nob.businessAlias = 'balias';
        nob.DoingbusinessAs = 'hghsgg';
        nob.primaryParcelId = p.id;
        nob.mailingParcelId = '';
        
        BusinessUtility.UserPromotion userprom = new BusinessUtility.UserPromotion();
        userprom.contactId = c1.id;
        userprom.currentUserId = '';
        userprom.currentUserProfileId = '';
        userprom.firstName = 'testfirst';
        userprom.lastName = 'testlastname';
        userprom.email = 'testemail@testing.com';
        userprom.newAccountId = ac1.id;
        userprom.isSharingRequired = true;
        
        
        
        BusinessUtility.NewBusinessUserPromoCombo nbuserpromo = new BusinessUtility.NewBusinessUserPromoCombo(nob, userprom, 'exscenario' );
        BusinessUtility.createCommunityPlusUser(userprom, nob, 'exscenario');
        BusinessUtility.sendMessageForEmailService('Event', nbuserpromo);
        BusinessUtility.sendMessageForEmailService('Event', 'comboin');
        BusinessUtility.createAccountContactJunction(userprom);
        BusinessUtility.handleAccountContactJunctionOperation(nob);
        

        delete(globalSettings); 
        Test.stopTest() ;
    }
}