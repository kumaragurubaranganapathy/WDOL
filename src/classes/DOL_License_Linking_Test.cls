@isTest
public class DOL_License_Linking_Test {
    @isTest
    public static void getAccountListTest1(){
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        a.Security_Code__c = 'abc123';
        update a;
        DOL_License_Linking.getAccountList('abc123');
    }
    
    @isTest
    public static void getAccountListTest2(){
        DOL_License_Linking.getAccountList('abc123');
    }
    
    @isTest
    public static void getAccountListTest3(){
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        a.Security_Code__c = 'abc123';
        update a;
        DOL_License_Linking.createAccountContact(a.Id);
    }
    
    @isTest
    public static void testVoidMethods(){
        DOL_License_Linking.getLicenseType();
        DOL_License_Linking.getProgramPicklist();
        DOL_License_Linking.sendActivationCodeEmail('abc','test@mailinator.com');
        DOL_License_Linking.searchLicenseNumber('Architects','Lic1234568');
        
    }
    
    @isTest
    public static void testGetLicenseList1(){
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Id conRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        Contact con = DOL_TestDataFactory.createContact(conRecTypeId,a.Id); 
        con.Security_Code__c = 'abc123';
        update con;
            Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c lic1 = DOL_TestDataFactory.createLicense(LicRecTypeId1, a.Id, 'Architects', 'Architect', 'General Application');
        lic1.MUSW__Applicant__c = con.id;
        update lic1;
        
        DOL_License_Linking.getLicenseList('abc123','test','Test Contact','123',lic1.Name,'Architect', System.today());
    }
    
    @isTest
    public static void testGetLicenseList2(){
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Id conRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        Contact con = DOL_TestDataFactory.createContact(conRecTypeId,a.Id); 
        con.Last_4_Digits_of_SSN__c = '8138';
        con.FirstName ='test';
        con.Birthdate = Date.newInstance(1990, 12, 9);
        update con;
        
        Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c lic1 = DOL_TestDataFactory.createLicense(LicRecTypeId1, a.Id, 'Architects', 'Architect', 'General Application');
        lic1.MUSW__Applicant__c = con.id;
        update lic1;
        DOL_License_Linking.getLicenseList('','test','Test Contact','8138',lic1.Name,'Architect', System.today());
    }
    
    @isTest
    public static void testGetLicenseList3(){
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Id conRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        Contact con = DOL_TestDataFactory.createContact(conRecTypeId,a.Id); 
        con.Last_4_Digits_of_SSN__c = '8138';
        con.FirstName ='test';
        con.Birthdate = Date.newInstance(1990, 12, 9);
        update con;
        Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c lic1 = DOL_TestDataFactory.createLicense(LicRecTypeId1, a.Id, 'Architects', 'Architect', 'General Application');
        lic1.MUSW__Applicant__c = con.id;
        update lic1;
        DOL_License_Linking.getLicenseList('','test','Test Contact','8138','','', System.today());
    }
    
    @isTest
    public static void testCreateReviewRecord(){
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c lic1 = DOL_TestDataFactory.createLicense(LicRecTypeId1, a.Id, 'Architects', 'Architect', 'General Application');
        DOL_License_Linking.createReviewRecord('Test Reveiw', lic1.Id, 'abc@mailinator.com');
    }
    
    @isTest
    public static void testUpdateLicenseContact(){
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Id conRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        Contact con = DOL_TestDataFactory.createContact(conRecTypeId,a.Id); 
        Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c lic1 = DOL_TestDataFactory.createLicense(LicRecTypeId1, a.Id, 'Architects', 'Architect', 'General Application');
        lic1.MUSW__Applicant__c = con.id;
        update lic1;
        DOL_License_Linking.createReviewRecord('Test Reveiw', lic1.Id, 'abc@mailinator.com');
        Account acc = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Contact cont = DOL_TestDataFactory.createContactWithLastName(conRecTypeId,acc.Id,'dummyLN'); 
        DOL_License_Linking.updateLicenseContact(cont.Id);
        DOL_License_Linking.searchLicenseNumber('Architects',lic1.Name);
    }
    
}