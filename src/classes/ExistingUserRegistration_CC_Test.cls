@isTest
public class ExistingUserRegistration_CC_Test {
	@isTest static void testcheckIfUserAllreadyExistForContact(){
        Test.startTest(); 
        Account testAccount = new Account(name='CITIZEN');
        insert testAccount;
        Contact testContact = CreateTestDataUtility.createContact(testAccount.id); 
        insert testContact;
        User u = CreateTestDataUtility.createCommunityUser(testContact.id);
        insert u;
        ExistingUserRegistration_CC controller = new ExistingUserRegistration_CC();
        Boolean bRet = controller.checkIfUserAllreadyExistForContact(testContact);
        System.assertEquals(true, bRet);
        Test.stopTest();
    }
    
    @isTest static void testcheckSSNnoSSNValidation(){
        Test.startTest();       
        Account testAccount = new Account(name='CITIZEN');
        insert testAccount;
        Contact testContact = CreateTestDataUtility.createContact(testAccount.id); 
        testContact.Last_4_Digits_of_SSN__c = '7352';
        insert testContact;
        Contact newCon = new Contact();
        newCon.FirstName = 'TestFirst';
        newCon.LastName = 'TestLast';
        newCon.Reason_for_No_SSN__c = '';
        newCon.Email = 'test@email.com';
        ExistingUserRegistration_CC controller = new ExistingUserRegistration_CC();
        controller.ssnForPage = '';
        controller.newCon = newCon;
        Boolean bRet = controller.checkSSNnoSSNValidation(testContact);
        System.assertEquals(true, bRet);
        string s1=controller.getResultData();
        ExistingUserRegistration_CC.RegResult r1 = controller.getResultObject();
        Test.stopTest();
    }    
    
    @isTest static void testregisterExistingWithCodeV1(){
             
        Account testAccount = new Account(name='CITIZEN');
        insert testAccount;
        Contact existContact = CreateTestDataUtility.createContact(testAccount.id); 
        existContact.Last_4_Digits_of_SSN__c = '7352';
        existContact.Security_Code__c = '1234';
        insert existContact;
        
        Contact newCon = new Contact();
        newCon.FirstName = 'TestFirst';
        newCon.LastName = 'TestLast';
        newCon.Reason_for_No_SSN__c = '';
        newCon.Email = 'test@email.com';
        newCon.Last_4_Digits_of_SSN__c = '7352';
        Test.startTest(); 
        PageReference ref = new PageReference('/apex/test_PortalRegistration');
        Test.setCurrentPage(ref);
        ExistingUserRegistration_CC controller = new ExistingUserRegistration_CC();
        controller.ssnForPage = '838587352';
        controller.newCon = newCon;
        controller.birthDate = date.ValueOf('1971-01-01');
        newCon.Security_Code__c = '1234';
        controller.registerExistingWithCode();
        //pagereference pref = controller.registerCasinoUser();
        Test.stopTest();
    }    
    
    @isTest static void testregisterExistingWithCodeV2(){
        Test.startTest();  
         Account testAccount = new Account(name='CITIZEN');
        insert testAccount;
         Contact con = new Contact(FirstName='fname',
            LastName = 'lname',
            Email = 'email@gmail.com',
            Phone = '9743800309');
        insert con;
         User user1 = CreateTestDataUtility.createCommunityTestUser(con.Id);
        insert user1;
        ArchivedContact__c acrhContact = new ArchivedContact__c();
        acrhContact.FirstName__c = 'TestFirst';
        acrhContact.LastName__c = 'TestLast';
        acrhContact.Email__c = 'test@email.com';
        acrhContact.Security_Code__c = '1234';
        acrhContact.Contact__c = con.id;
        insert acrhContact;
         System.AssertNotEquals(Null, con.Id); 
        Contact newCon = new Contact();
        newCon.FirstName = 'TestFirst';
        newCon.LastName = 'TestLast';
        newCon.Reason_for_No_SSN__c = '';
        newCon.Email = 'test@email.com';
        newCon.Last_4_Digits_of_SSN__c = '2346';
        newCon.Security_Code__c = '1234';
       
        PageReference ref = new PageReference('/apex/test_PortalRegistration');
        Test.setCurrentPage(ref);
        System.runAs(user1){
        ExistingUserRegistration_CC controller = new ExistingUserRegistration_CC();
        controller.passwordParameter = 'jhjsdhf';
        controller.ssnForPage = '838582346';
        controller.birthDate = date.ValueOf('1982-12-09');    
        controller.newCon = newCon;
        controller.registerExistingWithCode();
        controller.getResultObject();
        controller.getResultData();
        }
        Test.stopTest();
    }    
  
    @isTest static void testregisterNewCommunityUser(){
        Test.startTest();      
        
        Account testAccount = new Account(name='CITIZEN');
        insert testAccount;
        Contact existContact = CreateTestDataUtility.createContact(testAccount.id); 
        existContact.Last_4_Digits_of_SSN__c = '2346';
        existContact.Security_Code__c = '1234';
        insert existContact;
        
        Contact newCon = new Contact();
        newCon.FirstName = 'TestFirst';
        newCon.LastName = 'TestLast';
        newCon.Reason_for_No_SSN__c = '';
        newCon.Email = 'test@email.com';
        newCon.Last_4_Digits_of_SSN__c = '2346';
        newCon.Security_Code__c = '1234';
        insert newCon;
        Contact newCon1 = [select id, name from Contact where id = :newCon.id];
        
        
        PageReference ref = new PageReference('/apex/test_PortalRegistration');
        Test.setCurrentPage(ref);
        CommunitiesRegistrationController controller = new CommunitiesRegistrationController();
        controller.ssnForPage = '838582346';
        controller.newCon = newCon1;
        //controller.birthDate = date.ValueOf('1970-01-01');
        //controller.isCACLicense = true;
        controller.passwordParameter = 'jsdjfjdsj';
        controller.registerNewCommunityUser();
        newcon.email='test@dsps.wi.gov';
        update newcon;
        controller.newCon = newCon;
        controller.registerNewCommunityUser();
        //controller.resultmethod();
        Test.stopTest();
    }
    
    
    @isTest static void testregisterNewCommunityUser1(){
        Test.startTest();      
        
        Account testAccount = new Account(name='CITIZEN');
        insert testAccount;
        Contact existContact = CreateTestDataUtility.createContact(testAccount.id); 
        existContact.Last_4_Digits_of_SSN__c = '2346';
        existContact.Security_Code__c = '1234';
        
        insert existContact;
        
        Contact newContact = [select id, name from Contact where id = :existContact.id]; 
		CommunitiesRegistrationController controller = new CommunitiesRegistrationController();
         controller.newCon = newContact;
        
        PageReference ref = new PageReference('/apex/test_PortalRegistration');
        Test.setCurrentPage(ref);
      
        controller.ssnForPage = '838-58-2346';
        //controller.birthDate = date.ValueOf('1970-01-01');
        //controller.isCACLicense = true;
        controller.passwordParameter = 'jsdjfjdsj';
        controller.registerNewCommunityUser();
        Test.stopTest();
    }
    
   static testmethod void  test_PortalRegistration(){
        Contact newCon = new Contact();
        newCon.FirstName = 'TestFirst';
        newCon.LastName = 'TestLast';
        newCon.Reason_for_No_SSN__c = '';
        newCon.Email = 'test@email.com';
        newCon.Last_4_Digits_of_SSN__c = '6789';
        PageReference ref = new PageReference('/apex/test_PortalRegistration');
        Test.setCurrentPage(ref);
        CommunitiesRegistrationController controller = new CommunitiesRegistrationController();
        controller.ssnForPage = '123456789';
        controller.newCon = newCon;
        //controller.birthDate = date.ValueOf(System.today() - 10950);
        controller.registerNewCommunityUser(); 
       
    }
    
    static testmethod void  test_CheckForExistingContact(){
         
        Account testAccount = new Account(name='CITIZEN');
        insert testAccount;
      
        Contact newCon = new Contact(FirstName='TestFirst',
			LastName = 'lname',
            Email = 'test@email.com',
            Last_4_Digits_of_SSN__c = '2346',
            Reason_for_No_SSN__c = '',
            Phone = '9743800309',
            Security_Code__c = '1234');
        
        insert newCon;
         Test.startTest();
         CommunitiesRegistrationController controller = new CommunitiesRegistrationController();
         controller.ssnForPage = '236-56-2346';
         controller.CheckForExistingContact();
         
         controller.ssnForPage = null;
         ExistingUserRegistration_CC controllerEx = new ExistingUserRegistration_CC();
         controllerEx.registerExistingWithCode();
         Test.stopTest();
     }
    
     @isTest static void testSiteUserOperation(){
         Test.startTest();
         
          Account testAccount = new Account(name='CITIZEN');
        insert testAccount;
         Contact connnn = CreateTestDataUtility.createContact(testAccount.id);
         insert connnn;
		User user = CreateTestDataUtility.createCommunityTestUser(connnn.Id);
         insert user;
         
         ExistingUserRegistration_CC controller1 = new ExistingUserRegistration_CC();
        ExistingUserRegistration_CC.SiteUserOperation suseroperation = new  ExistingUserRegistration_CC.SiteUserOperation();
        suseroperation.password = 'jdshfjd';
         suseroperation.userRecord = user;
          suseroperation.userId = user.Id;
         
        test.stopTest();
    }
}