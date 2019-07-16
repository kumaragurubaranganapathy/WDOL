@isTest
public class ForgotSecurityCode_CC_Test {

    @testSetup static void createTestData()
    {
        MUSW__GlobalSettings__c globalSettings = new MUSW__GlobalSettings__c(Name = 'Default', MUSW__Disable_Triggers__c = false);
        insert globalSettings;
        Id BusinessRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        List<Account> lstAccounts = new List<Account>();
        /*** Citizen Account ***/         
        Account ca = new Account(name='CITIZEN');
        lstAccounts.add(ca);
        //insert ca;
        
        /** Account Creation **/         
        Account a = CreateTestDataUtility.createTestAccount();
        a.Email__c = 'TestFindBusinessSecurityCode@gmail.com';
        a.FEIN_Number_Encrypted__c = '981823142';
        a.Last_4_Digits_of_FEIN__c = '3142';
        a.Security_Code__c = '2v8765';
        a.recordtypeid = BusinessRecordTypeId;
        lstAccounts.add(a);
        
        Account b = CreateTestDataUtility.createTestAccount();
        b.Email__c = 'noemail@noemail.com';
        b.FEIN_Number_Encrypted__c = '747474747';
        b.Last_4_Digits_of_FEIN__c = '4747';
        b.Security_Code__c = '';
        b.recordtypeid = BusinessRecordTypeId;
        lstAccounts.add(b);
        
        Account b1 = CreateTestDataUtility.createTestAccount();
        b1.Email__c = 'duplicateemail@noemail.com';
        b1.FEIN_Number_Encrypted__c = '123321123';
        b1.Last_4_Digits_of_FEIN__c = '1123';
        b1.Security_Code__c = '';
        b1.recordtypeid = BusinessRecordTypeId;
        lstAccounts.add(b1);
        
        Account d = CreateTestDataUtility.createTestAccount();
        d.Email__c = 'duplicateemail@noemail.com';
        d.FEIN_Number_Encrypted__c = '123321123';
        d.Last_4_Digits_of_FEIN__c = '1123';
        d.Security_Code__c = '';
        d.recordtypeid = BusinessRecordTypeId;
        lstAccounts.add(d);
        
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.AllowSave = true;
  
        Account aDuplicate = CreateTestDataUtility.createTestAccount();
        aDuplicate.Email__c = 'TestFindBusinessSecurityCodeDuplicate@gmail.com';
        aDuplicate.FEIN_Number_Encrypted__c = '123321123';
        aDuplicate.Last_4_Digits_of_FEIN__c = '1123';
        aDuplicate.Security_Code__c = '2v8765';
        lstAccounts.add(aDuplicate);
        Database.insert(lstAccounts, dml);
        
        
        List<Contact> lstContacts = new List<Contact>();
        /** Contact Creation **/
        Contact c = CreateTestDataUtility.createContact(a.Id);
        c.FirstName = 'TestForgotSecurityCodeFirstname';
        c.Lastname = 'TestForgotSecurityCodeLastName';
        c.Email = 'TestForgotSecurityCodeIndividual@gmail.com';
        c.Duplicate_Override__c=true;
        c.Social_Security_Number_Encrypted__c = '123456789';
        c.Last_4_Digits_of_SSN__c = '6789';
        lstContacts.add(c);
        
        Contact cDuplicate1 = CreateTestDataUtility.createContact(a.Id);
        cDuplicate1.FirstName = 'TestForgotSecurityCodeFirstnameDuplicate';
        cDuplicate1.Lastname = 'TestForgotSecurityCodeLastNameDuplicate';
        cDuplicate1.Email = 'TestForgotSecurityCodeIndividualDuplicate@gmail.com';
        cDuplicate1.Social_Security_Number_Encrypted__c = '923456789';
        lstContacts.add(cDuplicate1);
        
        Contact cDuplicate = CreateTestDataUtility.createContact(a.Id);
        cDuplicate.FirstName = 'TestForgotSecurityCodeFirstnameDuplicate';
        cDuplicate.Lastname = 'TestForgotSecurityCodeLastNameDuplicate';
        cDuplicate.Email = 'TestForgotSecurityCodeIndividualDuplicate@gmail.com';
        cDuplicate.Social_Security_Number_Encrypted__c = '987654321';
        lstContacts.add(cDuplicate);
        
        Database.insert(lstContacts, dml);
        
        List<ArchivedContact__c> ArchivedContacts = new List<ArchivedContact__c>();
        
        /** Archived Conatct Creation ***/ 
        ArchivedContact__c Ac = new ArchivedContact__c();
        Ac.LastName__c = c.LastName;
        Ac.FirstName__c = c.FirstName;
        Ac.Email__c = c.Email;
        Ac.Security_Code__c = c.Security_Code__c;
        Ac.SSN_Encrypted__c = '111116789';
        //Ac.Social_Security_Number_Encrypted__c = '123456789';
        Ac.Contact__c = c.Id;
        
        ArchivedContacts.add(Ac);
        
        ArchivedContact__c Ac1 = new ArchivedContact__c();
        Ac1.LastName__c = 'TestAcForgotSecurityCodeLastName';
        Ac.FirstName__c = 'TestAcForgotSecurityCodeFirstName';
        Ac1.Email__c = 'ArchivedName@gmail.com';
        Ac1.Security_Code__c = c.Security_Code__c;
        Ac1.SSN_Encrypted__c = '998877665';
        
        ArchivedContacts.add(Ac1);
        
        Database.insert(ArchivedContacts);
        
    }
    static testMethod void SendIndividualSecurityCodeFromContact_using_Email_as_Input()
    {
        test.startTest();
        List<Contact> lstContacts = [Select Id,Email,Security_Code__c,Social_Security_Number_Encrypted__c from Contact where LastName = 'TestForgotSecurityCodeLastName' or LastName = 'TestForgotSecurityCodeLastNameDuplicate'];
        system.debug('Contact idnt is@@@'+lstContacts[0].Security_Code__c);
        ForgotSecurityCode_CC.sendSecurityCode('',lstContacts[0].Email);
        
        //Exception Handling Coverage
        lstContacts[1].Email = lstContacts[0].Email;
        upsert lstContacts[1];
        ForgotSecurityCode_CC.sendSecurityCode('',lstContacts[0].Email);
        
        lstContacts[1].Email = '';
        lstContacts[0].Security_Code__c = null;
        Database.upsert(lstContacts);
        ForgotSecurityCode_CC.sendSecurityCode('','');
        ForgotSecurityCode_CC.sendSecurityCode('','testExceptionEmail@gmail.com');
        ForgotSecurityCode_CC.sendSecurityCode('123456789','testExceptionEmail@gmail.com');
        test.stopTest();
    }
    static testMethod void SendIndividualSecurityCodeFromContact_using_ssn_as_Input()
    {
        test.startTest();
        List<Contact> lstContacts = [Select Id,Email,Security_Code__c,Social_Security_Number_Encrypted__c from Contact where LastName = 'TestForgotSecurityCodeLastName' or LastName = 'TestForgotSecurityCodeLastNameDuplicate'];
        system.debug('Contact idnt is@@@'+lstContacts[0].Security_Code__c);
        ForgotSecurityCode_CC.sendSecurityCode(lstContacts[0].Social_Security_Number_Encrypted__c, '');
        
        //exception handling coverage 
        lstContacts[1].Social_Security_Number_Encrypted__c = lstContacts[0].Social_Security_Number_Encrypted__c;
        upsert lstContacts[1];
        ForgotSecurityCode_CC.sendSecurityCode(lstContacts[0].Social_Security_Number_Encrypted__c, '');
         
        lstContacts[1].Social_Security_Number_Encrypted__c = '';
        lstContacts[0].email = null;
        Database.upsert(lstContacts);
        
        ForgotSecurityCode_CC.sendSecurityCode('123456789', '');
        ForgotSecurityCode_CC.sendSecurityCode('123453142', '');
        
        test.stopTest();
    }
    static testMethod void SendIndividualSecurityCodeFromContact_using_ssn_as_Input_Fail()
    {
        test.startTest(); 
        List<ArchivedContact__c> ArchivedContacts = new List<ArchivedContact__c>();
        ArchivedContacts = [Select Id,Email__c,FirstName__c,LastName__c,SSN_Encrypted__c,Security_Code__c from ArchivedContact__c where LastName__c='TestAcForgotSecurityCodeLastName' limit 1];
        ForgotSecurityCode_CC fs = new ForgotSecurityCode_CC();
        fs.email = '';
        fs.SocialSecurityNumber = ArchivedContacts[0].SSN_Encrypted__c;
        //fs.findSecurityCode();
        
        test.stopTest();
    }
    static testMethod void SendIndividualSecurityCodeFromArchivedContact_using_Email_as_Input()
    {
        test.startTest();
        List<Contact> lstContacts = [Select Id,Email,Security_Code__c,Social_Security_Number_Encrypted__c from Contact where LastName = 'TestForgotSecurityCodeLastName' limit 1];
        system.debug('Contact idnt is@@@'+lstContacts[0].Security_Code__c);
        
        lstContacts[0].email = 'TestUpdateEmail@gmail.com';
        Update lstContacts;
        
        List<ArchivedContact__c> ArchivedContacts = new List<ArchivedContact__c>();
        ArchivedContacts = [Select Id,Email__c,FirstName__c,LastName__c,SSN_Encrypted__c,Security_Code__c from ArchivedContact__c where LastName__c='TestForgotSecurityCodeLastName' limit 1];
        ForgotSecurityCode_CC fs = new ForgotSecurityCode_CC();
        fs.email = ArchivedContacts[0].Email__c;
        fs.SocialSecurityNumber = '';
        //fs.findSecurityCode();
        
        //Exception Handling Coverage 
        fs.email='testArchEmail@gmail.com';
        fs.SocialSecurityNumber ='';
        //fs.findSecurityCode();
        
        test.stopTest();
    }
    static testMethod void SendIndividualSecurityCodeFromArchivedContact_using_ssn_as_Input()
    {
        test.startTest();
        List<Contact> lstContacts = [Select Id,Email,Security_Code__c,Social_Security_Number_Encrypted__c from Contact where LastName = 'TestForgotSecurityCodeLastName' limit 1];
        system.debug('Contact idnt is@@@'+lstContacts[0].Security_Code__c);
        
        lstContacts[0].Social_Security_Number_Encrypted__c = '123456789';
        lstContacts[0].Last_4_Digits_of_SSN__c = '6789';
        //lstContacts[0].Last_4_Digits_of_SSN__c = '';
        Update lstContacts;
        
        List<ArchivedContact__c> ArchivedContacts = new List<ArchivedContact__c>();
        ArchivedContacts = [Select Id,Email__c,FirstName__c,LastName__c,SSN_Encrypted__c,Security_Code__c from ArchivedContact__c where LastName__c='TestForgotSecurityCodeLastName' or LastName__c = 'TestAcForgotSecurityCodeLastName'];
        ForgotSecurityCode_CC fs = new ForgotSecurityCode_CC();
        fs.email = '';
        system.debug('@@@SocialSecurityNumber@@@'+ArchivedContacts[0].SSN_Encrypted__c);
        fs.SocialSecurityNumber = ArchivedContacts[0].SSN_Encrypted__c;
        //fs.findSecurityCode();
        
        //Exception Handling Coverage 
        fs.email='';
        fs.SocialSecurityNumber = ArchivedContacts[1].SSN_Encrypted__c;
        //fs.findSecurityCode();
       
        fs.email='';
        fs.SocialSecurityNumber ='555556789';
        //fs.findSecurityCode();
        
        fs.email='';
        fs.SocialSecurityNumber ='232323232';
        //fs.findSecurityCode();
        
        fs.email='';
        fs.SocialSecurityNumber ='998877665';
        //fs.findSecurityCode();
        
        test.stopTest();
    }
    static testMethod void SendBusinessSecurityCodeFromContact_using_ssn_as_Input()
    {
        Test.startTest();
            List<Account> lstAccounts = [Select Id, Name,Email__c, FEIN_Number_Encrypted__c, Last_4_Digits_of_FEIN__c, Security_Code__c from Account
                            where Email__c ='TestFindBusinessSecurityCode@gmail.com' OR Email__c ='TestFindBusinessSecurityCodeDuplicate@gmail.com'
                            ];
            ForgotSecurityCode_CC fs = new ForgotSecurityCode_CC();
            fs.email = '';
            fs.SocialSecurityNumber = lstAccounts[0].FEIN_Number_Encrypted__c;
            fs.findBusinessSecurityCode();
          system.debug('lstAccounts size>>>'+lstAccounts.size());
            system.debug('lstAccounts>>>'+lstAccounts);
        
            //Exception Handling 
          /*  lstAccounts[1].FEIN_Number_Encrypted__c = lstAccounts[0].FEIN_Number_Encrypted__c;
            upsert lstAccounts[1];
            fs.findBusinessSecurityCode();
        
            lstAccounts[1].FEIN_Number_Encrypted__c = '';
            */ lstAccounts[0].Email__c = null;
            Database.upsert(lstAccounts);
            fs.findBusinessSecurityCode();
            
            fs.SocialSecurityNumber = '294518265';
            fs.findBusinessSecurityCode();
        
            fs.SocialSecurityNumber = '29451' + lstAccounts[0].Last_4_Digits_of_FEIN__c;
            fs.findBusinessSecurityCode();
        
            Account acc = [Select Id, Name,Email__c, FEIN_Number_Encrypted__c, Last_4_Digits_of_FEIN__c, Security_Code__c from Account
                            where Email__c ='noemail@noemail.com'
                            ];
            acc.Security_Code__c = null;
            update acc;
        
            fs.email = '';
            fs.SocialSecurityNumber = acc.FEIN_Number_Encrypted__c;
            fs.findBusinessSecurityCode();
        
            fs.email = '';
            fs.SocialSecurityNumber = '111114747';
            fs.findBusinessSecurityCode();
        
            fs.email = '';
            fs.SocialSecurityNumber = '123321123';
            fs.findBusinessSecurityCode();
        
        
        Test.stopTest();
    }
    
    static testMethod void SendBusinessSecurityCodeFromContact_using_email_as_Input()
    {
        Test.startTest();
            List<Account> lstAccounts = [Select Id, Name,Email__c, FEIN_Number_Encrypted__c, Last_4_Digits_of_FEIN__c, Security_Code__c from Account
                            where Email__c ='TestFindBusinessSecurityCode@gmail.com'
                            ];
            ForgotSecurityCode_CC fs = new ForgotSecurityCode_CC();
            fs.email = lstAccounts[0].Email__c;
            fs.SocialSecurityNumber = '';
            fs.findBusinessSecurityCode();
            
            //Exception Handling 
            lstAccounts[0].Security_Code__c = null;
            upsert lstAccounts[0];
            fs.findBusinessSecurityCode();
        
            fs.email = 'testBusinessEmail682016@gmail.com';
            fs.findBusinessSecurityCode();
        
            Account acc = [Select Id, Name,Email__c, FEIN_Number_Encrypted__c, Last_4_Digits_of_FEIN__c, Security_Code__c from Account
                            where Email__c ='noemail@noemail.com'
                            ];
            acc.Security_Code__c = null;
            update acc;
        
            fs.email = 'noemail@noemail.com';
            fs.SocialSecurityNumber = '';
            fs.findBusinessSecurityCode();
        
            fs.email = 'duplicateemail@noemail.com';
            fs.SocialSecurityNumber = '';
            fs.findBusinessSecurityCode();
        
        
        Test.stopTest();
    }
    
    static testMethod void findBusinessSecurityCode_test()
    {
         Test.startTest();
         Database.DMLOptions dml = new Database.DMLOptions();
         dml.DuplicateRuleHeader.AllowSave = true;
        
         Account a = CreateTestDataUtility.createTestAccount();
         a.Email__c = 'TestFindBusinessSecurityCode@gmail.com';
         a.FEIN_Number_Encrypted__c = '981823142';
         a.Security_Code__c = '2v8765';
         Database.Insert(a, dml);
         
         ForgotSecurityCode_CC fs = new ForgotSecurityCode_CC();  
         fs.FEINnumber = '981823142';
         fs.findBusinessSecurityCode();
         Test.stopTest();
    }
    static testMethod void findBusinessSecurityCode_testfail()
    {
         Test.startTest();
         Account a = CreateTestDataUtility.createTestAccount();
         a.Email__c = 'TestFindBusinessSecurityCode@gmail.com';
         a.FEIN_Number_Encrypted__c = '981823142';
         a.Security_Code__c = '';
         insert a;
         ForgotSecurityCode_CC fs = new ForgotSecurityCode_CC();  
         fs.FEINnumber = '981823142';
         fs.findBusinessSecurityCode();
         Test.stopTest();
    }
    
    static testMethod void sendSecurityCode_ArchivedContact()
    {
        Test.startTest();
         
        ArchivedContact__c arCon = [Select Id, Name, Email__c, Contact__c, Contact__r.FirstName, Contact__r.LastName, Contact__r.Security_Code__c From ArchivedContact__c limit 1];
        ForgotSecurityCode_CC fs = new ForgotSecurityCode_CC();
        fs.sendEmailArc(arCon);
        
        Test.stopTest();
    }
}