@isTest
public class WA_License_utilityTest {
    
    public static testmethod void updateRenewalFieldsTest(){
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('User Account').getRecordTypeId();
        Id ConRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
		Id LicRecTypeId = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        List<MUSW__License2__c> licList = new List<MUSW__License2__c>();
        
        Test.startTest();
        
        Account acc = DOL_TestDataFactory.createAccount(AccRecTypeId);  
        
        Contact con = DOL_TestDataFactory.createContact(ConRecTypeId,acc.id);
        
        MUSW__License2__c lic = DOL_TestDataFactory.createLicense(LicRecTypeId, acc.Id, 'Geologist', 'Geologist', 'General Application');
        lic.MUSW__Status__c = 'Active';
        lic.MUSW__Expiration_Date__c = system.today()+10;
        licList.add(lic);
        update licList;
        
        Renewal_Reinstatement_Eligibility__c rene = DOL_TestDataFactory.createReinstateEligibilityRecord();
        WA_License_utility.updateRenewalFields(licList);
        Test.stopTest();
     }
}