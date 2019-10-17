@isTest
public class BaseValidatorTest {
    
    @testSetup
    static void createData(){
        MUSW__License2__c lic = new MUSW__License2__c();
        
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('User_Account').getRecordTypeId();
        Account acc = DOL_TestDataFactory.createAccount(accRecordTypeId);
        Id contactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Contact').getRecordTypeId();
        Contact con = DOL_TestDataFactory.createContact(contactRecordTypeId, acc.Id);
        Id licRecordTypeId = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByDeveloperName().get('Business').getRecordTypeId();
        lic = DOL_TestDataFactory.createLicense(licRecordTypeId, acc.Id, 'Timeshares', 'Timeshare Company', 'General Application');
        lic.MUSW__Applicant__c = con.Id;
        lic.MUSW__Primary_Licensee__c = acc.Id;
        update lic;
        Schema.sObjectType tokenA = lic.getSObjectType();
        
        Id permitRecordType = Schema.SObjectType.MUSW__Permit2__c.getRecordTypeInfosByDeveloperName().get('Universal_Default_Permit_Record_Type').getRecordTypeId();
        MUSW__Permit2__c permit = DOL_TestDataFactory.createPermit(permitRecordType);
        permit.MUSW__Applicant__c = con.Id;
        permit.MUSW__Account__c = acc.Id;
        update permit;
        
        Id renewalRecordTypeId = Schema.SObjectType.Renewal_Application__c.getRecordTypeInfosByDeveloperName().get('Individual').getRecordTypeId();
        Renewal_Application__c renewal = DOL_TestDataFactory.createRenewalApplication(renewalRecordTypeId, lic.Id);
        renewal.Applicant__c = con.Id;
        renewal.Licensee__c = acc.Id;
        renewal.Permit__c = permit.Id;
        update renewal;
        
        Id applicationRecordType = Schema.SObjectType.MUSW__Application2__c.getRecordTypeInfosByDeveloperName().get('Service_Request').getRecordTypeId();
        MUSW__Application2__c app = DOL_TestDataFactory.createApplication(applicationRecordType);
    }
    
    @isTest
    static void createValidatorTest(){
        
        BaseValidator.createValidator(BaseValidator.ApplicationObjectType.LICENSE, 'Delegated Agent Record Type');
        BaseValidator.createValidator(BaseValidator.ApplicationObjectType.LICENSE, 'Manufactured Homes Record Type');
        BaseValidator.createValidator(BaseValidator.ApplicationObjectType.PERMIT, 'Permit');
        BaseValidator.createValidator(BaseValidator.ApplicationObjectType.PERMIT, 'POWTS Plan Review');
        BaseValidator.createValidator(BaseValidator.ApplicationObjectType.RENEWAL, 'Universal Default Renewal/Reinstatement');
        BaseValidator.createValidator(BaseValidator.ApplicationObjectType.SERVICEREQUEST, 'Universal Default Renewal/Reinstatement');
        
        
    }
    
    @isTest
    static void validateContactTest(){
        MUSW__License2__c lic = [SELECT Id, MUSW__Applicant__c, Credential_Type__c, Credential__c FROM MUSW__License2__c LIMIT 1];       
        MUSW__Permit2__c permit = [SELECT Id, MUSW__Applicant__c, Program_Area__c, Permit_Type__c FROM MUSW__Permit2__c LIMIT 1];
        Renewal_Application__c renewal = [SELECT Id, Renewal_Reinstatement_Type__c, Applicant__c, License__c, Permit__c, Credential__c, Credential_Type__c, Permit_Type__c, Program_Area__c FROM Renewal_Application__c];
        BaseValidator b = new BaseValidator();
        b.validateContact(BaseValidator.ApplicationObjectType.LICENSE, lic);
        b.validateContact(BaseValidator.ApplicationObjectType.PERMIT, permit);
        b.validateContact(BaseValidator.ApplicationObjectType.RENEWAL, renewal);
        
        renewal.Renewal_Reinstatement_Type__c = Label.RNT_Reinstatement;
        update renewal;
        b.validateContact(BaseValidator.ApplicationObjectType.RENEWAL, renewal);
        
        renewal.Renewal_Reinstatement_Type__c = Label.RNT_RenewalPTO;
        update renewal;
        b.validateContact(BaseValidator.ApplicationObjectType.RENEWAL, renewal);
    }
    
    @isTest
    static void validateAccountTest(){
        MUSW__License2__c lic = [SELECT Id, MUSW__Primary_Licensee__c, Credential_Type__c, Credential__c FROM MUSW__License2__c LIMIT 1];       
        MUSW__Permit2__c permit = [SELECT Id, MUSW__Account__c, Program_Area__c, Permit_Type__c FROM MUSW__Permit2__c LIMIT 1];
        Renewal_Application__c renewal = [SELECT Id, Renewal_Reinstatement_Type__c, Licensee__c, License__c, Permit__c, Credential__c, Credential_Type__c, Permit_Type__c, Program_Area__c FROM Renewal_Application__c];
        BaseValidator b = new BaseValidator();
        b.validateAccount(BaseValidator.ApplicationObjectType.LICENSE, lic);
        b.validateAccount(BaseValidator.ApplicationObjectType.PERMIT, permit);
        b.validateAccount(BaseValidator.ApplicationObjectType.RENEWAL, renewal);
        
        renewal.Renewal_Reinstatement_Type__c = Label.RNT_Reinstatement;
        update renewal;
        b.validateAccount(BaseValidator.ApplicationObjectType.RENEWAL, renewal);
        
        renewal.Renewal_Reinstatement_Type__c = Label.RNT_RenewalPTO;
        update renewal;
        b.validateAccount(BaseValidator.ApplicationObjectType.RENEWAL, renewal);
    }
    
    @isTest
    static void validateAddress(){
        MUSW__License2__c lic = [SELECT Id, MUSW__Primary_Licensee__c, Credential_Type__c, Credential__c FROM MUSW__License2__c LIMIT 1];       
        MUSW__Permit2__c permit = [SELECT Id, MUSW__Account__c, Program_Area__c, Permit_Type__c FROM MUSW__Permit2__c LIMIT 1];
        Renewal_Application__c renewal = [SELECT Id, Renewal_Reinstatement_Type__c, Licensee__c, License__c, Permit__c, Credential__c, Credential_Type__c, Permit_Type__c, Program_Area__c FROM Renewal_Application__c];
        BaseValidator b = new BaseValidator();
        b.validateAddress(BaseValidator.ApplicationObjectType.LICENSE, lic);
        b.validateAddress(BaseValidator.ApplicationObjectType.PERMIT, permit);
        b.validateAddress(BaseValidator.ApplicationObjectType.RENEWAL, renewal);
        
        renewal.Renewal_Reinstatement_Type__c = Label.RNT_Reinstatement;
        update renewal;
        b.validateAddress(BaseValidator.ApplicationObjectType.RENEWAL, renewal);
        
        renewal.Renewal_Reinstatement_Type__c = Label.RNT_RenewalPTO;
        update renewal;
        b.validateAddress(BaseValidator.ApplicationObjectType.RENEWAL, renewal);
        
        renewal.License__c = null;
        update renewal;
        b.validateAddress(BaseValidator.ApplicationObjectType.RENEWAL, renewal);
    }
    
    @isTest
    static void validateServiceRequestTest(){
        MUSW__Application2__c app = [SELECT Id FROM MUSW__Application2__c LIMIT 1];
        app.Section_Number__c = 99;
        update app;
        BaseValidator b = new BaseValidator();
        b.validateServiceRequest(BaseValidator.ApplicationObjectType.SERVICEREQUEST, app);
    }
    
    @isTest
    static void validateTest(){
        MUSW__Application2__c app = [SELECT Id FROM MUSW__Application2__c LIMIT 1];
        MUSW__License2__c lic = [SELECT Id, MUSW__Primary_Licensee__c, Credential_Type__c, Credential__c FROM MUSW__License2__c LIMIT 1];       
        
        app.Section_Number__c = 99;
        update app;
        BaseValidator b = new BaseValidator();
        b.validate(app, lic);
        b.runConfigurableValidations();
    }
}