@isTest
public class AddressValidatorTest {
    @testSetup
    static void createData(){
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('User_Account').getRecordTypeId();
        Account acc = DOL_TestDataFactory.createAccount(accRecordTypeId);
        
        Id licRecordTypeId = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByDeveloperName().get('Business').getRecordTypeId();
        MUSW__License2__c lic = DOL_TestDataFactory.createLicense(licRecordTypeId, acc.Id, 'Camping Resorts', 'Camping Resort Company', 'General Application');
        
        Id parRecordTypeId = Schema.SObjectType.MUSW__Parcel__c.getRecordTypeInfosByDeveloperName().get('Address').getRecordTypeId();
        MUSW__Parcel__c parcel = DOL_TestDataFactory.createParcel(parRecordTypeId);
        
        MUSW__License_Parcel__c licParcel = DOL_TestDataFactory.createLicenseParcel(lic.Id, parcel.Id);
        MUSW__License_Parcel__c licParcel2 = DOL_TestDataFactory.createLicenseParcel(lic.Id, parcel.Id);
        
        Application_Subsection__c appSubSec = DOL_TestDataFactory.createApplicationSubSection('Camping Resorts', 'Camping Resort Company');
        
        Id permitRecordType = Schema.SObjectType.MUSW__Permit2__c.getRecordTypeInfosByDeveloperName().get('Universal_Default_Permit_Record_Type').getRecordTypeId();
        MUSW__Permit2__c permit = DOL_TestDataFactory.createPermit(permitRecordType);
        
        MUSW__Permit_Parcel__c permPar = DOL_TestDataFactory.createPermitParcel(permit.Id, parcel.Id);
        MUSW__Permit_Parcel__c permPar2 = DOL_TestDataFactory.createPermitParcel(permit.Id, parcel.Id);
        
    }
    
    @isTest
    static void validateAddressTest(){
        MUSW__License2__c lic = [SELECT Id FROM MUSW__License2__c LIMIT 1];
        String licId = String.valueOf(lic.Id);
        
        MUSW__Parcel__c parcel = [SELECT Id, Name, Status__c FROM MUSW__Parcel__c LIMIT 1];
        
        List<MUSW__License_Parcel__c> licParcel = [SELECT Id, Mailing__c, Physical__c, Public__c FROM MUSW__License_Parcel__c];
        
        Application_Subsection__c appSubSec = [SELECT Id, Name, License__c FROM Application_Subsection__c LIMIT 1];
        appSubSec.Name = 'Mailing Camping Resort Company';
        appSubSec.License__c = true;
        update appSubSec;
        
        ValidationError ve = new ValidationError();
        AddressValidator.validate(ve, 'Camping Resort Company', 'Camping Resort Company', 'License__c', licId);
        
        appSubSec.Name = 'Public Camping Resort Company';
        update appSubSec;
        AddressValidator.validate(ve, 'Camping Resort Company', 'Camping Resort Company', 'License__c', licId);
        
        appSubSec.Name = 'Physical Camping Resort Company';
        update appSubSec;
        AddressValidator.validate(ve, 'Camping Resort Company', 'Camping Resort Company', 'License__c', licId);
        
        licParcel[0].Mailing__c = true;
        licParcel[0].Physical__c = true;
        licParcel[0].Public__c = true;
        update licParcel[0];
        AddressValidator.validate(ve, 'Camping Resort Company', 'Camping Resort Company', 'License__c', licId);
        
        MUSW__Permit2__c permit = [SELECT Id FROM MUSW__Permit2__c LIMIT 1];
        
        List<MUSW__Permit_Parcel__c> permParcel = [SELECT Id, Mailing__c, Physical__c, Public__c FROM MUSW__Permit_Parcel__c];
        permParcel[1].Mailing__c = false;
        permParcel[1].Public__c = false;
        permParcel[1].Physical__c = false;
        update permParcel[1];
        
        AddressValidator.validate(ve, 'POWTS', 'Electrical', 'Permit__c', String.valueOf(permit.Id));
        
    }
}