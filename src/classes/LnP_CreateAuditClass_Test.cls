@isTest
public class LnP_CreateAuditClass_Test {
	@isTest
    public static void calculateTenPercentRecords(){
        Id reAppId = Schema.SObjectType.Renewal_Application__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        List<Renewal_Application__c> renewAppList = new List<Renewal_Application__c>();
        //renewAppList.add(DOL_TestDataFactory.createRenewalApplication(reAppId,null,null));
        LnP_CreateAuditClass.calculateTenPercentRecords(renewAppList);
         
    }
    @isTest
    public static void getUpdatedRenewalAppMap(){
        Id reAppId = Schema.SObjectType.Renewal_Application__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c oLicenseData = DOL_TestDataFactory.createLicense(LicRecTypeId1, a.Id, 'Architects', 'Architect', 'General Application');
        Map<String,List<Renewal_Application__c>> renewAppMap = new  Map<String,List<Renewal_Application__c>>();
        List<Renewal_Application__c> renewAppList = new List<Renewal_Application__c>();
        renewAppList.add(DOL_TestDataFactory.createRenewalApplication(reAppId,oLicenseData.id));
        renewAppMap.put(renewAppList[0].Id, renewAppList);
        LnP_CreateAuditClass.getUpdatedRenewalAppMap(renewAppMap);
        
    }
    @isTest
    public static void getUpdatedLicenseMap(){
        List<MUSW__License2__c> licenseList = new List<MUSW__License2__c>();
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        licenseList.add(DOL_TestDataFactory.createLicense(LicRecTypeId1, a.Id, 'Architects', 'Architect', 'General Application'));
        Map<String,List<MUSW__License2__c>> licenseMap = new Map<String,List<MUSW__License2__c>>();
        licenseMap.put(licenseList[0].id,licenseList);
        LnP_CreateAuditClass.getUpdatedLicenseMap(licenseMap);
    }
    @isTest
    public static void createAuditForRE(){
        Id reAppId = Schema.SObjectType.Renewal_Application__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        List<Renewal_Application__c> renewAppList = new List<Renewal_Application__c>();
        //renewAppList.add(DOL_TestDataFactory.createRenewalApplication(reAppId,null,null));
        LnP_CreateAuditClass.createAuditForRE(renewAppList);
    }
    @isTest
    public static void createAuditForRBS(){
        List<MUSW__License2__c> licenseList = new List<MUSW__License2__c>();
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        licenseList.add(DOL_TestDataFactory.createLicense(LicRecTypeId1, a.Id, 'Architects', 'Architect', 'General Application'));
        LnP_CreateAuditClass.createAuditForRBS(licenseList);
    }
}