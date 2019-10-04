@isTest
public class Polaris_EndorsementRenewCntrl_Test {
    
    
    @isTest
    public static void test_fetchEndorsement1(){
        Id appRecId = Schema.SObjectType.MUSW__Application2__c.getRecordTypeInfosByName().get('Registration').getRecordTypeId();
        MUSW__Application2__c app = DOL_TestDataFactory.createApplication(appRecId);
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c lic1 = DOL_TestDataFactory.createLicense(LicRecTypeId1, a.Id, 'Architects', 'Architect', 'General Application');
        Endorsement__c endo = DOL_TestDataFactory.createEndorsement(lic1.Id, 'Active');
        try{
            Polaris_EndorsementRenewCntrl.fetchEndorsement(app.Id);
        }catch(Exception ex){
            
        }
    }
    
    @isTest
    public static void test_fetchEndorsement2(){
        Id appRecId = Schema.SObjectType.MUSW__Application2__c.getRecordTypeInfosByName().get('Registration').getRecordTypeId();
        MUSW__Application2__c app = DOL_TestDataFactory.createApplication(appRecId);
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c lic1 = DOL_TestDataFactory.createLicense(LicRecTypeId1, a.Id, 'Architects', 'Architect', 'General Application');
        lic1.Application__c = app.id;
        update lic1;
        Endorsement__c endo = DOL_TestDataFactory.createEndorsement(lic1.Id, 'Active');
        try{
            Polaris_EndorsementRenewCntrl.fetchEndorsement(app.Id);
        }catch(Exception ex){
            
        }
    }
    
    @isTest
    public static void test_fetchProvider1(){
        Id appRecId = Schema.SObjectType.MUSW__Application2__c.getRecordTypeInfosByName().get('Registration').getRecordTypeId();
        MUSW__Application2__c app = DOL_TestDataFactory.createApplication(appRecId);
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c lic1 = DOL_TestDataFactory.createLicense(LicRecTypeId1, a.Id, 'Architects', 'Architect', 'General Application');
        lic1.Application__c = app.id;
        update lic1;
        Endorsement__c endo = DOL_TestDataFactory.createEndorsement(lic1.Id, 'Active');
        Electronic_Notary_Provider_Information__c enpi = DOL_TestDataFactory.createElectronicProviderInfo(endo.Id);
        try{
            Polaris_EndorsementRenewCntrl.fetchProvider(endo.Id);
        }catch(Exception ex){}
    }
    
      
    @isTest
    public static void test_removeProvider1(){
        Id appRecId = Schema.SObjectType.MUSW__Application2__c.getRecordTypeInfosByName().get('Registration').getRecordTypeId();
        MUSW__Application2__c app = DOL_TestDataFactory.createApplication(appRecId);
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c lic1 = DOL_TestDataFactory.createLicense(LicRecTypeId1, a.Id, 'Architects', 'Architect', 'General Application');
        lic1.Application__c = app.id;
        update lic1;
        Endorsement__c endo = DOL_TestDataFactory.createEndorsement(lic1.Id, 'Active');
        Electronic_Notary_Provider_Information__c enpi = DOL_TestDataFactory.createElectronicProviderInfo(endo.Id);
        try{
            Polaris_EndorsementRenewCntrl.removeProvider(enpi.Id);
        }catch(Exception ex){}
    }
    
    @isTest
    public static void test_removeProvider2(){
        try{
            Polaris_EndorsementRenewCntrl.removeProvider('Docusign');
        }catch(Exception ex){}
    }
    
    @isTest
    public static void test_changeStatus1(){
        Id appRecId = Schema.SObjectType.MUSW__Application2__c.getRecordTypeInfosByName().get('Registration').getRecordTypeId();
        MUSW__Application2__c app = DOL_TestDataFactory.createApplication(appRecId);
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c lic1 = DOL_TestDataFactory.createLicense(LicRecTypeId1, a.Id, 'Architects', 'Architect', 'General Application');
        Endorsement__c endo = DOL_TestDataFactory.createEndorsement(lic1.Id, 'Active');
        try{
            Polaris_EndorsementRenewCntrl.changeStatus(endo.Id, 'In-Review', app.Id);
        }catch(exception ex){}
    }
    
    @isTest
    public static void test_changeStatus2(){
        Id appRecId = Schema.SObjectType.MUSW__Application2__c.getRecordTypeInfosByName().get('Registration').getRecordTypeId();
        MUSW__Application2__c app = DOL_TestDataFactory.createApplication(appRecId);
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c lic1 = DOL_TestDataFactory.createLicense(LicRecTypeId1, a.Id, 'Architects', 'Architect', 'General Application');
        lic1.Application__c = app.id;
        update lic1;
        Endorsement__c endo = DOL_TestDataFactory.createEndorsement(lic1.Id, 'Active');
        try{
            Polaris_EndorsementRenewCntrl.changeStatus(endo.Id, 'In-Review', app.Id);
        }catch(exception ex){}
    }
}