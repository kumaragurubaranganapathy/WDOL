@isTest
public class AddBusiness_CC_Test {
	public static testmethod void unittestForBasicConstructor()
    {
        Id BusinessRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account testAccount = CreateTestDataUtility.createAccount();
        testAccount.Security_Code__c='test123';
        testAccount.recordtypeid = BusinessRecordTypeId;
        insert testAccount;
        Contact testContact = CreateTestDataUtility.createContact(testAccount.id);  
        insert testContact;
        
        MUSW__Parcel__c parc = CreateTestDataUtility.createContactParcel(testContact.id, 'street', 'Scity', 'state', 'zip', 'United States');
        insert parc;
        
        Parcel_Account__c pacc = CreateTestDataUtility.createParcelAccountJunction(parc.id, testAccount.id);
        //insert pacc;
        List<Parcel_Account__c> lp = new List<Parcel_Account__c>();
        lp.add(pacc);
        Database.insert(lp);
        user u= CreateTestDataUtility.createCommunityPlusUser(testcontact.id);
        insert u;
        
        AddBusiness_CC.BusinessRecord bRec = new AddBusiness_CC.BusinessRecord();
            bRec.accountId = testAccount.id;
            bRec.contactPerson = testContact.name;
            bRec.firmCertificate= 'test123';
            bRec.primaryParcelId = parc.id;
            bRec.mailingParcelId = parc.id; 
        
        //createCommunityTestUser
        system.runas(u) {
            Test.startTest();
            
            AddBusiness_CC cntrlr = new AddBusiness_CC();
            cntrlr.secCode='test123';
            cntrlr.currentUser = u;
            //system.assert(!cntrlr.isCommunityPlusUser) ;
            cntrlr.addExistingBusiness();
            cntrlr.addNewBusiness();
            PageReference prf =cntrlr.refreshAddNewBusinessSection();
            system.assert(cntrlr.getUserInfoJSON() != null ) ;
            system.assert(cntrlr.registeredAsOptions.size() > 0 ) ;
            Test.stopTest();
        }
        
    }
    public static testmethod void unittestForBasicConstructor1()
    {
        Account testAccount = CreateTestDataUtility.createAccount();
        testAccount.Security_Code__c='test123';
        insert testAccount;
        Contact testContact = CreateTestDataUtility.createContact(testAccount.id);  
        insert testContact;
        user u= CreateTestDataUtility.createCommunityTestUser(testcontact.id);
        insert u;
        //createCommunityTestUser
        system.runas(u) {
            Test.startTest();
            
            AddBusiness_CC cntrlr = new AddBusiness_CC();
            cntrlr.secCode='test123';
            //system.assert(!cntrlr.isCommunityPlusUser) ;
            cntrlr.addExistingBusiness();
            //cntrlr.deleteEmployee();
             
            
            Test.stopTest();
        }

    }    
    
   public static testmethod void unittestForBasicConstructor2()
    {
        Id BusinessRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account testAccount = CreateTestDataUtility.createAccount();
        testAccount.Security_Code__c='test123';
        testAccount.recordtypeid = BusinessRecordTypeId;
        insert testAccount;
        Contact testContact = CreateTestDataUtility.createContact(testAccount.id);  
        insert testContact;
        user u= CreateTestDataUtility.createCommunityTestUser(testcontact.id);
        insert u;
        //createCommunityTestUser
        system.runas(u) {
        Test.startTest();
        
        AddBusiness_CC cntrlr = new AddBusiness_CC();
        cntrlr.secCode='test123';
        //system.assert(!cntrlr.isCommunityPlusUser) ;
        cntrlr.addExistingBusiness();
            cntrlr.addNewBusiness();
        PageReference prf =cntrlr.refreshAddNewBusinessSection();
        system.assert(cntrlr.getUserInfoJSON() != null ) ;
        system.assert(cntrlr.registeredAsOptions.size() > 0 ) ;
        Test.stopTest();
        }

    }

    public static testMethod void unitTestForRemoteMethod3()
    {
        Account testAccount = CreateTestDataUtility.createAccount();		
        insert testAccount;
        Contact testContact = CreateTestDataUtility.createContact(testAccount.id);  
        insert testContact;
        
        MUSW__Parcel__c parc = CreateTestDataUtility.createContactParcel(testContact.id, 'street', 'Scity', 'state', 'zip', 'United States');
        insert parc;
        
        Parcel_Account__c pacc = CreateTestDataUtility.createParcelAccountJunction(parc.id, testAccount.id);
        insert pacc;
        
        user u= CreateTestDataUtility.createCommunityPlusUser(testcontact.id);
        insert u;
        system.runAs(u){
        AddBusiness_CC.BusinessRecord bRec = new AddBusiness_CC.BusinessRecord();
        bRec.accountId = testAccount.id;
        bRec.contactPerson = testContact.name;
        
        bRec.contactPersonFirstName = testContact.Firstname;
        bRec.contactPersonLastName = testContact.LastName;
        
        bRec.phoneNumber= 'test123';
        bRec.email = testcontact.Email;
        bRec.primaryContactEmail= testcontact.Email;
        bRec.fax = 'test123';
        bRec.website = 'test123';
        bRec.registeredAs = 'test123';
        bRec.accountName = 'test123';
        bRec.contactId = 'test123';
        bRec.firmCertificate= 'test123';
        bRec.primaryParcelId = parc.id;
        bRec.mailingParcelId = 'test123';
        
        bRec.currentUserId = 'test123';
        bRec.currentUserProfileId = 'test123';
        bRec.firstName = 'test123';
        bRec.lastName = 'test123';
        bRec.userEmail = 'test123';
       // bRec.FEINNumber = 'test123'; 


        AddBusiness_CC.AddBusinessDBResult res = AddBusiness_CC.saveBusinessRecord(bRec);
        AddBusiness_CC.AddBusinessDBResult res1 = AddBusiness_CC.addNewBusinessForCommUser(bRec);
        system.assert(res != null ) ;
            
        }
    }
    public static testMethod void unitTestForRemoteMethod2()
    {
        Account testAccount = CreateTestDataUtility.createAccount();		
        insert testAccount;
        Contact testContact = CreateTestDataUtility.createContact(testAccount.id);  
        insert testContact;
        Affiliation__c aff = new Affiliation__c();
        insert aff;
        user u= CreateTestDataUtility.createCommunityPlusUser(testcontact.id);
        insert u;
        system.runAs(u){
            AddBusiness_CC.EmployeeRecord bRec = new AddBusiness_CC.EmployeeRecord();
            
            bRec.AffliationId = aff.id;
            bRec.EmployeeId ='test123';
            bRec.LicenseId ='test123';
            bRec.UnSupervisor = 'test123';
            AddBusiness_CC OAA = new AddBusiness_CC();
            OAA.mybusinessList = null;
            AddBusiness_CC.ManageBusinessWrapper mg = new AddBusiness_CC.ManageBusinessWrapper();
            // mg.myAffiliations = null;
            mg.myBusiness = null;
            AddBusiness_CC.AddBusinessDBResult res = AddBusiness_CC.saveEmployeeRecord(bRec);
            AddBusiness_CC.AddBusinessDBResult res1 = AddBusiness_CC.deleteEmployeeRecord(testaccount.id);
       		AddBusiness_CC ctrl = new AddBusiness_CC();
      		ctrl.createAccountContactObject(String.valueOf(testContact.Id), String.valueOf(testAccount.Id));
            // AddBusiness_CC.deleteEmployee test= new AddBusiness_CC.deleteEmployee();   
            // system.assert(res != null ) ;
            
        }
    }
    
    public static testMethod void unitTestForAddBusiness()
    {
        Account testAccount = CreateTestDataUtility.createAccount();		
        insert testAccount;
        Contact testContact = CreateTestDataUtility.createContact(testAccount.id);  
        insert testContact;
        user u= CreateTestDataUtility.createCommunityPlusUser(testcontact.id);
        insert u;
         MUSW__Parcel__c parc = CreateTestDataUtility.createContactParcel(testContact.id, 'street', 'Scity', 'state', 'zip', 'United States');
        insert parc;
        
        Parcel_Account__c pacc = CreateTestDataUtility.createParcelAccountJunction(parc.id, testAccount.id);
        insert pacc;
        
        MUSW__Account_Contact__c maccon = CreateTestDataUtility.createAccountContact(testAccount.id, testContact.Id);
        insert maccon;
        
        Affiliation__c aff = new Affiliation__c();
        insert aff;
        
        List<Affiliation__c> listlr =new List<Affiliation__c>();
        listlr.add(aff);
        
        system.runAs(u){
            test.starttest();
            List<AddBusiness_CC.ManageBusinessWrapper> mblist = new List<AddBusiness_CC.ManageBusinessWrapper>();
            AddBusiness_CC.ManageBusinessWrapper mwrap = new AddBusiness_CC.ManageBusinessWrapper();
            //mwrap.myAffiliations = listlr;
            mwrap.myBusiness = maccon;
            //mblist.add(mwrap);
            AddBusiness_CC cntrl = new AddBusiness_CC();
            cntrl.AccountId = testAccount.Id;
            cntrl.BusIdChosen = null;
            cntrl.EmpIdChosen = null;
            cntrl.primaryParcelId = pacc.id;
            cntrl.mailingParcelId = pacc.id;
            cntrl.addNewBusiness();
            mblist = cntrl.mybusinessList;
            test.stoptest();
        }
        
    }
    
     public static testMethod void unitTestForuploadatt()
    {
         Account testAccount = CreateTestDataUtility.createAccount();       
        insert testAccount;
        Contact testContact = CreateTestDataUtility.createContact(testAccount.id);  
        insert testContact;
        MUSW__License2__c testLicense = CreateTestDataUtility.createLicense(testAccount.id, testContact.id); //License
        testLicense.MUSW__Status__c = 'Active';
        insert testLicense; 
        Attachment attObj = new Attachment();
        attObj.Name = 'test';
        attObj.Body = Blob.valueOf('Unit Test Attachment Body');
        attObj.ParentId = testLicense.Id;
        insert attObj;
        AddBusiness_CC.doUploadAttachment(testAccount.id, String.valueOf(EncodingUtil.base64Encode(attObj.Body)), attObj.Name);
     	AddBusiness_CC.doUploadAttachment(null, String.valueOf(EncodingUtil.base64Encode(attObj.Body)), attObj.Name);
    }
 
}