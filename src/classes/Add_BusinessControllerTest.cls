@isTest
public class Add_BusinessControllerTest {
    @testSetup
    static void businessController(){
        
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('User_Account').getRecordTypeId();
        Account acc = DOL_TestDataFactory.createAccount(accRecordTypeId);
        
        Id contactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Contact').getRecordTypeId();
        Contact con = DOL_TestDataFactory.createContact(contactRecordTypeId, acc.Id);
        
        MUSW__Account_Contact__c accCon = DOL_TestDataFactory.createAccountContact();
        
        Id licRecordTypeId = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByDeveloperName().get('Business').getRecordTypeId();
        MUSW__License2__c lic = DOL_TestDataFactory.createLicense(licRecordTypeId, acc.Id, 'Timeshares', 'Timeshare Company', 'General Application');
        lic.MUSW__Applicant__c = con.Id;
        update lic;
        String licId = String.valueOf(lic.Id);
        
        Associations__c assoc = DOL_TestDataFactory.createAssociation(lic.Id);
        //MUSW__License2__c childLic = DOL_TestDataFactory.createLicense(licRecordTypeId, acc.Id, 'Timeshares', 'Timeshare Salesperson', 'General Application');
        //assoc.Child_License__c = lic.Id;
        //assoc.Child_License__r.MUSW__Applicant__c = con.Id;
        //update assoc;
        
        Id parcelRecordTypeId = Schema.SObjectType.MUSW__Parcel__c.getRecordTypeInfosByDeveloperName().get('Address').getRecordTypeId();
        MUSW__Parcel__c parcel = DOL_TestDataFactory.createParcel(parcelRecordTypeId);
        
        MUSW__License_Parcel__c licParcel = DOL_TestDataFactory.createLicenseParcel(lic.Id, parcel.Id);
        
        Task tsk = new Task();
        tsk.Status = assoc.Status__c;
        tsk.WhatId = assoc.Id;
        insert tsk;
        
        Id renAppRecTypeId = Schema.SObjectType.Renewal_Application__c.getRecordTypeInfosByDeveloperName().get('Individual').getRecordTypeId();
        Renewal_Application__c renApp = DOL_TestDataFactory.createRenewalApplication(renAppRecTypeId, lic.Id);
        
        Request__c request = DOL_TestDataFactory.createRequest(lic.Id, 'Timeshares','Timeshare Company');
        
        Id appRecordTypeId = Schema.SObjectType.MUSW__Application2__c.getRecordTypeInfosByDeveloperName().get('General_Service_Request').getRecordTypeId();
        MUSW__Application2__c application = DOL_TestDataFactory.createApplication(appRecordTypeId);
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        
        User u2 = new User(Alias = 'newUser', Email='newuser@testorg.com',
                           EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                           LocaleSidKey='en_US', ProfileId = p.Id,
                           TimeZoneSidKey='America/Los_Angeles', UserName='newuser567@testorg.com');
        insert u2;
    }
    
    @isTest
    static void accountTest(){
        Account acc = [SELECT Id, Name FROM Account WHERE Name = 'Test Account' LIMIT 1];
        String accId = String.valueOf(acc.Id);
        List<Account> listAccount = new List<Account>();
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('User_Account').getRecordTypeId();
        
        Renewal_Application__c renApp = [SELECT Id, Name FROM Renewal_Application__c LIMIT 1];
        Request__c req = [SELECT Id, Name FROM Request__c LIMIT 1];
        MUSW__Application2__c appl = [SELECT Id, Name FROM MUSW__Application2__c LIMIT 1];
        
        MUSW__License_Parcel__c licParcel = [SELECT Id, Name FROM MUSW__License_Parcel__c LIMIT 1];
        
        for(Integer i = 0; i < 2; i++){
            Account accRec = DOL_TestDataFactory.createAccount(accRecordTypeId);
            accRec.name = 'Test Account ' + i; 
            listAccount.add(accRec);
        }
        
        Add_BusinessController.getRecordTypeIdAccount();
        Add_BusinessController.insertRequestBusiness(accId, 'Update Legal Name');
        
        Add_BusinessController.getAllCourses(accId);
        Add_BusinessController.getAllAccounts();
        Add_BusinessController.getAccountData(accId);
        
        Add_BusinessController.updateAccount(listAccount);
        
        Global_Settings__c gs = new Global_Settings__c(Name = 'gs', Disable_Triggers__c = true);
        insert gs;
        Add_BusinessController.updateAccount(listAccount);
        
        Add_BusinessController.checkIfCourseAccount(accId);
        
        Add_BusinessController.setAbandonStatus(String.valueOf(renApp.Id));
        Add_BusinessController.setAbandonStatus(String.valueOf(req.Id));
        Add_BusinessController.setAbandonStatus(String.valueOf(appl.Id));
        
    }        
    
    @isTest
    static void accountContactTest(){
        Account acc = [SELECT Id, Name FROM Account WHERE Name = 'Test Account' LIMIT 1];
        String accId = String.valueOf(acc.Id);
        
        MUSW__Account_Contact__c accCon = [SELECT Id, MUSW__Account__c, Name FROM MUSW__Account_Contact__c WHERE First_Name__c = 'FirstName' LIMIT 1];
        String accConId = String.valueOf(accCon.Id);
        
        /* EmailTemplate em = new EmailTemplate();
em.Name = 'Department of Licensing - Pending request to join a firm';
em.Subject = 'Test Email';
em.HtmlValue = 'Test';
insert em;*/
        
        Add_BusinessController.getAllContacts(accId);
        Add_BusinessController.createAccountContactObject(accId);
        Add_BusinessController.updateContactAccountStatus(accConId, 'Active', accId);
        Add_BusinessController.updateBusinessAccIDonContact(accId);
        
        
        accCon.MUSW__Account__c = acc.Id;
        update accCon;
        Test.startTest();
        
        Add_BusinessController.resendEmailInvitation(accConId, accId);
        Test.stopTest();
    }
    
    @isTest 
    static void licenseTest(){
        Account acc = [SELECT Id, Name FROM Account WHERE Name = 'Test Account' LIMIT 1];
        String accId = String.valueOf(acc.Id);
        MUSW__License2__c lic = [SELECT Id, Name FROM MUSW__License2__c WHERE Name ='System Number' LIMIT 1];
        String licId = String.valueOf(lic.Id);
        
        Add_BusinessController.getBusinessLicenses(accId, true, licId);
        Add_BusinessController.getBusinessLicenses(accId, false, licId);
        Add_BusinessController.getAllApplications(accId);
        Add_BusinessController.getAllRenewalApplications(accId);
        Add_BusinessController.getAllLicenses(accId);
        Add_BusinessController.setBusinessLicenseTable(accId, true, licId);
        Add_BusinessController.getLicenseData(licId);
        
        Add_BusinessController.pendingNewLicenseApplicationsTbl(accId);
        
        Add_BusinessController.PendingRenewApplicationsTable(accId);
        
        Add_BusinessController.fetchPendingCourseData(accId);
        
        Add_BusinessController.PendingMaintananceRequestApplicationsTable(accId);
        
        Add_BusinessController.CompletedMaintananceRequestApplicationsTable(accId);
    }
    
    @isTest
    static void taskTest(){
        Account acc = [SELECT Id, Name FROM Account WHERE Name = 'Test Account' LIMIT 1];
        String accId = String.valueOf(acc.Id);
        Contact con = [SELECT Id FROM Contact WHERE LastName = 'Test Contact'];
        MUSW__Account_Contact__c accCon = [SELECT Id, Name, isAdminContact__c FROM MUSW__Account_Contact__c WHERE First_Name__c = 'FirstName' LIMIT 1];
        accCon.isAdminContact__c = true;
        update accCon;
        MUSW__License2__c lic = [SELECT Id, Name FROM MUSW__License2__c WHERE Credential_Type__c = 'Timeshare Company' LIMIT 1];
        String licId = String.valueOf(lic.Id);
        
        Associations__c assoc = [SELECT Id, Name, Child_License__c, Child_License__r.MUSW__Applicant__c, Status__c, invitation_send_date__c FROM Associations__c WHERE Parent_License__c =: licId AND Child_License__c =: licId LIMIT 1];
        assoc.Child_License__r.MUSW__Applicant__c = con.Id;
        update assoc;
        
        Task tsk = [SELECT Id, WhatId FROM Task WHERE WhatId =: assoc.Id];
        Test.startTest();
        List<String> listActionClicked = new List<String>{'Accepted', 'Declined'}; 
            
            for(Integer j = 0; j < listActionClicked.size(); j++){
                Add_BusinessController.actionOnTask('License Relationship', listActionClicked[j], tsk);
                Add_BusinessController.updateTask(tsk.Id, listActionClicked[j]);
            }
        
        tsk.WhatId = accCon.Id;
        update tsk;
        for(Integer j = 0; j < listActionClicked.size(); j++){
            Add_BusinessController.actionOnTask('Contact Relationship', listActionClicked[j], tsk);
            Add_BusinessController.updateTask(tsk.Id, listActionClicked[j]);
        }
        
        Add_BusinessController.createTask(accCon.Id, 'testClass@mailinator.com', 'Test Name', accId, 'Administrator');
        Add_BusinessController.createTask(accCon.Id, '', '', licId, '');
        Add_BusinessController.createAssociationTask(assoc.Id);
        Test.stopTest();
    }
    
    @isTest
    static void removeRecordsTest(){
        MUSW__Account_Contact__c accCon = [SELECT Id, Name FROM MUSW__Account_Contact__c WHERE First_Name__c = 'FirstName' LIMIT 1];
        String accConId = String.valueOf(accCon.Id);
        MUSW__License2__c lic = [SELECT Id, Name FROM MUSW__License2__c WHERE Name='System Number' LIMIT 1];
        String licId = String.valueOf(lic.Id);
        Associations__c assoc = [SELECT Id, Name FROM Associations__c WHERE Parent_License__c =: licId LIMIT 1];
        List<String> listAction = new List<String>{'Remove','Resend'};
            
            Add_BusinessController.removeOwnerRecord(accConId);
        
        Task tsk = [SELECT Id, WhatId FROM Task WHERE WhatId =: assoc.Id];
        for(String action : listAction){
            Add_BusinessController.removeAssociationRecord(JSON.serialize(assoc),action);
        }
        
        tsk.WhatId = accCon.Id;
        update tsk;
        for(String action : listAction){
            Add_BusinessController.removeAcconContactRecord(accCon, action);
        }
        
    }
    
    @isTest
    static void relationshipTest(){
        Account acc = [SELECT Id, Name FROM Account WHERE Name = 'Test Account' LIMIT 1];
        String accId = String.valueOf(acc.Id);
        MUSW__License2__c lic = [SELECT Id, Name FROM MUSW__License2__c WHERE Name='System Number' LIMIT 1];
        String licId = String.valueOf(lic.Id);
        
        Add_BusinessController.getRelationShip('MUSW__Account_Contact__c', accId, 'Administrators', true);
        Add_BusinessController.getRelationShip('Associations__c', licId, 'Administrators', true);
        Add_BusinessController.getRelationShip('MUSW__Account_Contact__c', licId, 'Owner', true);
        Add_BusinessController.getRelationShip('MUSW__Account_Contact__c', licId, 'Owner', false);
        
        Add_BusinessController.setPeerRelationShipTable(licId);
        
        lic.Credential__c = 'Timeshare Salesperson';
        lic.Credential_Type__c = 'Timeshare Salesperson';
        update lic;
        Add_BusinessController.setPeerRelationShipTable(licId);
    }
    
    @isTest
    static void miscellaneousTestMethod(){
        Account acc = [SELECT Id, Name FROM Account WHERE Name = 'Test Account' LIMIT 1];
        String accId = String.valueOf(acc.Id);
        MUSW__License2__c lic = [SELECT Id, Name FROM MUSW__License2__c WHERE Name='System Number' LIMIT 1];
        String licId = String.valueOf(lic.Id);
        MUSW__License_Parcel__c licParcel = [SELECT Id, Name, MUSW__Parcel__c, MUSW__License2__c FROM MUSW__License_Parcel__c LIMIT 1];
        MUSW__Account_Contact__c accCon = [SELECT Id, Name FROM MUSW__Account_Contact__c WHERE First_Name__c = 'FirstName' LIMIT 1];
        String accConId = String.valueOf(accCon.Id);
        
        Add_BusinessController.getEndorsementData(licId);
        
        Add_BusinessController.getAddressData(licId);
        
        Add_BusinessController.getMandatoryActions();
        Add_BusinessController.setLocationTable(licId);
        
        
        /*acc.Name = 'Appraisal Management Company Account';
update acc;
Add_BusinessController.checkDCP(accId);*/
        Add_BusinessController.helptextFetch();
        Add_BusinessController.validateUBI('987876765');
        
        Add_BusinessController.checkActiveCart();
        Add_BusinessController.insertRequest(licId, 'Geologist', 'Geologist', 'Update Legal Name');
        Add_BusinessController.insertRequest(licId, '', 'Geologist', 'Update Legal Name');
        
        Add_BusinessController.saveOwnerRecord(accConId);
        
        List<MUSW__Account_Contact__c> lstAccCon = new List<MUSW__Account_Contact__c>();
        lstAccCon.add(accCon);
        String accConStr = JSON.serialize(lstAccCon);
        Add_BusinessController.saveOwnerRecord(accConStr);
        
    } 
    
    
    @isTest
    public static void exceptionHandleTest(){
        Account acc = [SELECT Id, Name FROM Account WHERE Name = 'Test Account' LIMIT 1];
        String accId = String.valueOf(acc.Id);
        MUSW__License2__c lic = [SELECT Id, Name FROM MUSW__License2__c WHERE Name='System Number' LIMIT 1];
        String licId = String.valueOf(lic.Id);
        User user = [SELECT Id, Name FROM User LIMIT 1];
        
        Test.startTest();
        Add_BusinessController.insertRequestBusiness(null, 'Geologist');
        Add_BusinessController.createAccountContactObject(accId);
        Add_BusinessController.getAccountData(licId);
        Add_BusinessController.updateContactAccountStatus(null, null, null);
        Add_BusinessController.getAllCourses('abcabc');
        Add_BusinessController.getBusinessLicenses('abcabc',false,'jjlkj');
        Add_BusinessController.getAllContacts(null);
        Add_BusinessController.checkIfCourseAccount('Hello');
        Add_BusinessController.setAbandonStatus('Hello');
        Add_BusinessController.updateBusinessAccIDonContact('Hello');
        Add_BusinessController.getLicenseData('Hello');       
        Add_BusinessController.pendingNewLicenseApplicationsTbl('Hello');        
        Add_BusinessController.PendingRenewApplicationsTable('Hello');        
        Add_BusinessController.fetchPendingCourseData('Hello');
        Add_BusinessController.PendingMaintananceRequestApplicationsTable('Hello');
        Add_BusinessController.getEndorsementData('Hello');        
        Add_BusinessController.getAddressData('Hello');
        Add_BusinessController.setLocationTable('Hello');
        Add_BusinessController.validateUBI('Hello');
        Add_BusinessController.saveOwnerRecord('Hello');
        
        Test.stopTest();
    }    
}