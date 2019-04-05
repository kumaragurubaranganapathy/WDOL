@isTest
public class ExistingUserRegistration_CCTest {
    @testSetup
    public static void testData(){
        Account testAccount = new Account(name='testAcc');
        insert testAccount;
        Contact testContact = CreateTestDataUtility.createContact(testAccount.id); 
        testContact.Birthdate = date.ValueOf('1971-01-01');
        testContact.Security_Code__c = 'A1234B1234';
        insert testContact;
        Id recordtypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        Contact testContact1 = new Contact(lastName = 'NewLName', firstName =  'utilityContOactFirstName', Email='testTESTtest@grr.la', RecordTypeId = recordtypeId,
                                           Birthdate = null, AccountId = testAccount.id, Social_Security_Number_Encrypted__c = '838587352', 
                                           Duplicate_Override__c = true, Birth_Country__c ='United States', Birth_State_Province__c='Texas', Birth_City__c='Dallas', 
                                           Gender__c='Male', Ethnicity__c='Asian Indian');
        testContact1.Birthdate = date.ValueOf('1971-01-09');
        testContact1.Security_Code__c = 'A1234B1223';
        insert testContact1;
        
        ArchivedContact__c archCon = new ArchivedContact__c(Name = 'testarchName', Security_Code__c = 'A1234B1223', Contact__c = testContact1.Id);
        insert archCon;
        
        User u = CreateTestDataUtility.createCommunityUser(testContact.id);
        insert u;
        
        Profile profile = [SELECT id FROM Profile WHERE name = 'eSLA Customer Community Login User'];
        User u1 = new User(Alias='tuser', Email='tuser11@mailinator.com', Username='tuser11@mailinator.com', LastName='NewLName', 
                           CommunityNickname='testuser11', ContactId = testContact1.Id, TimeZoneSidKey = 'America/Chicago',
                           LocaleSidKey='en_US', EmailEncodingKey='UTF-8', 
                           ProfileId = profile.Id, LanguageLocaleKey='en_US', IsActive= true);
        insert u1;
      
        Contact testContact2 = new Contact(lastName = 'NewLName1', firstName =  'ContOactFirstName', Email='testTESTtest@grr.la', RecordTypeId = recordtypeId,
                                           Birthdate = null, AccountId = testAccount.id, Social_Security_Number_Encrypted__c = '838587991', 
                                           Duplicate_Override__c = true, Birth_Country__c ='United States', Birth_State_Province__c='Texas', Birth_City__c='Dallas', 
                                           Gender__c='Male', Ethnicity__c='Asian Indian');
        testContact1.Birthdate = date.ValueOf('1971-01-12');
        testContact1.Security_Code__c = 'A1234B1654';
        insert testContact2;
        
        Account busAcc = CreateTestDataUtility.createBusinessAccount();
        insert busAcc;
        
		Contact con = new Contact(lastName = 'cLastName', firstName =  'cFirstName', Email='cname@mailinator.com', RecordTypeId = recordtypeId, Security_Code__c = 'AB234BC223',
                                  Social_Security_Number_Encrypted__c = '235673214', Duplicate_Override__c = true, Birth_Country__c ='United States', 
                                  Birth_State_Province__c='Texas', Birth_City__c='Dallas', Gender__c='Male', Ethnicity__c='Asian Indian');
        insert con;
        MUSW__Account_Contact__c accCon = CreateTestDataUtility.createAccountContact(busAcc.id, con.id);
        insert accCon;
    }
    @isTest
    public static void checkUser(){
        Account acc = [select id, name from Account where name = 'testAcc'];
        Contact con = [Select Id, name, lastname, Social_Security_Number_Encrypted__c, email, birthdate, Security_Code__c, Last_4_Digits_of_SSN__c from Contact where lastName = 'utilityContactLastName'];
        User usr = [Select Id, name from User where ContactId =: con.id];
        system.debug('con>>>'+con);
        string securityCode ;
        securityCode = con.Security_Code__c;
        Test.startTest();
        ExistingUserRegistration_CC controller = new ExistingUserRegistration_CC();
        
        controller.ssnForPage = '838587352';
        controller.birthDate = date.ValueOf('1971-01-01');
        controller.newCon = con;
        controller.registerExistingWithCode();
        // controller.newCon.Email = 'testTESTtest@grr.la';
        Boolean bRet = controller.checkIfUserAllreadyExistForContact(con);
        System.assertEquals(true, bRet);
        Test.stopTest();
    }
    

    
    
    
    @isTest
    public static void checkUser1(){
        Account acc = [select id, name from Account where name = 'testAcc'];
        Test.startTest();
        Contact con = [Select Id, name, lastname, Social_Security_Number_Encrypted__c, email, birthdate, Security_Code__c, Last_4_Digits_of_SSN__c from Contact where lastName = 'NewLName' limit 1];
        User usr = [Select Id, name from User where ContactId =: con.id];
        system.debug('con>>>'+con);
        string securityCode ;
        securityCode = con.Security_Code__c;
        
        ExistingUserRegistration_CC controller = new ExistingUserRegistration_CC();
        
        controller.ssnForPage = '838587385';
        controller.birthDate = date.ValueOf('1971-01-01');
        controller.newCon = con;
        controller.registerExistingWithCode();
        // controller.newCon.Email = 'testTESTtest@grr.la';
        Boolean bRet = controller.checkIfUserAllreadyExistForContact(con);
        
        
        Test.stopTest();
    }
    
    @isTest
    public static void checkUser2(){
        Account acc = [select id, name from Account where name = 'testAcc'];
        Test.startTest();
        Contact con = [Select Id, name, lastname, Social_Security_Number_Encrypted__c, email, birthdate, Security_Code__c, Last_4_Digits_of_SSN__c from Contact where lastName = 'NewLName1' limit 1];
        //User usr = [Select Id, name from User where ContactId =: con.id];
        system.debug('con>>>'+con);
        string securityCode ;
        securityCode = con.Security_Code__c;
        
        ExistingUserRegistration_CC controller = new ExistingUserRegistration_CC();
        
        controller.ssnForPage = '838587385';
        controller.birthDate = date.ValueOf('1971-01-01');
        controller.newCon = con;
        controller.registerExistingWithCode();
        // controller.newCon.Email = 'testTESTtest@grr.la';
        Boolean bRet = controller.checkIfUserAllreadyExistForContact(con);
        
        
        Test.stopTest();
    }
    
    
    @isTest
    public static void checkSecondUser(){
        Contact con = new Contact(lastName = 'testLastName', firstName =  'testFirstName', Email='test.org@mailinator.com', 
                                  Birthdate = date.ValueOf('1972-01-01'), Social_Security_Number_Encrypted__c = '123456799', 
                                  Duplicate_Override__c = true, Birth_Country__c ='United States', Birth_State_Province__c='Texas', Birth_City__c='Dallas', 
                                  Gender__c='Male', Ethnicity__c='Asian Indian');
        insert con;
        Test.startTest();
        ExistingUserRegistration_CC controller = new ExistingUserRegistration_CC();
        Boolean bRet = controller.checkIfUserAllreadyExistForContact(con);
        System.assertEquals(false, bRet);
        controller.ssnForPage = '123456799';
        controller.birthDate = date.ValueOf('1972-01-01');
        controller.newCon = con;
        controller.registerExistingWithCode();
        Test.stopTest();
    }
    
    @isTest
    public static void siteuseroperation(){
        Account acc = [select id, name from Account where name = 'testAcc'];
        Contact con = new Contact(lastName = 'NewLName1', firstName =  'utilityContOactFirstName11', Email='test11TESTtest@grr.la', 
                                  Birthdate = null, AccountId = acc.id, Social_Security_Number_Encrypted__c = '838587352', 
                                  Duplicate_Override__c = true, Birth_Country__c ='United States', Birth_State_Province__c='Texas', Birth_City__c='Dallas', 
                                  Gender__c='Male', Ethnicity__c='Asian Indian');
        con.Birthdate = date.ValueOf('1971-01-09');
        con.Security_Code__c = 'A1234B1223';
        insert con;
        ExistingUserRegistration_CC controller = new ExistingUserRegistration_CC();
        //controller.COMMUNITY_PROFILE_ID = profile.id;
        controller.handleCommunityUserOperations(con, acc.id, 'testpassword');
    }
    
    @isTest
    public static void updateCOntactrecord(){
        Account acc = [select id, name from Account where name = 'testAcc'];
        Contact con = [Select Id, name, lastname, Social_Security_Number_Encrypted__c, Firstname, MiddleName, email, birthdate, Security_Code__c, Last_4_Digits_of_SSN__c from Contact where lastName = 'NewLName1' limit 1];
        ExistingUserRegistration_CC controller = new ExistingUserRegistration_CC(); 
        controller.ssnForPage = '838587385';
        controller.birthDate = date.ValueOf('1971-01-01');
        controller.newCon = con; 
        date bdate = date.ValueOf('1971-01-09');
        
        //controller.COMMUNITY_PROFILE_ID = profile.id;
        controller.updateContactRecord(acc.Id, con, con.id , con , bdate);
    }
    
    @isTest
    public static void noUser(){
        Contact con = new Contact(lastName = 'No', firstName =  'User', email = 'nousertest@mailinator.com');
        //con.Birthdate = date.ValueOf('1980-01-09');
        con.Security_Code__c = '123412239A';
        insert con;
        
        ExistingUserRegistration_CC controller = new ExistingUserRegistration_CC(); 
        controller.newCon = con; 
        controller.ssnForPage = '111239999';
        controller.birthDate = date.ValueOf('1981-01-01');
        controller.registerExistingWithCode();
    }
    
    @isTest
    public static void testPlusUser(){
        Contact con = [Select id, lastname, firstname, Security_Code__c, Last_4_Digits_of_SSN__c, email from contact where email = 'cname@mailinator.com'];
        system.debug('Contact>>>'+con);
        Test.startTest();
        ExistingUserRegistration_CC controller = new ExistingUserRegistration_CC(); 
        controller.newCon = con;
        controller.ssnForPage = '235673214';
        controller.birthDate = date.ValueOf('1981-01-01');
        controller.passwordParameter = 'Qwerty@123';
        Boolean conTest = controller.checkAccountContact(con); 
        Account acc = controller.createAccountRecord(con);
        controller.registerExistingWithCode();
        List<user> usr = [Select id, name, profileId from user where email = 'cname@mailinator.com'];
        system.debug('User>>>'+ usr);
        Test.stopTest(); 
    }
}