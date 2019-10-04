@isTest
public class DRE2_Associations_Test {
    @isTest
    static void assocTest(){
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('User_Account').getRecordTypeId();
        Account acc = DOL_TestDataFactory.createAccount(accRecordTypeId);
        
        Id licRecordTypeId = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByDeveloperName().get('Business').getRecordTypeId();
        MUSW__License2__c lic = DOL_TestDataFactory.createLicense(licRecordTypeId, acc.Id, 'Cemeteries', 'Cemetery', 'General Application');
        
        Associations__c assoc = DOL_TestDataFactory.createAssociation(lic.Id);
        assoc.Location_State__c = 'Washington';
        assoc.Status__c = 'Active';
        update assoc;
        
        assoc.Status__c = 'Canceled';
        update assoc;
        
        Global_Settings__c gloSett = new Global_Settings__c(Name='cs');
        insert gloSett;
        gloSett.Disable_Triggers__c = true;
        update gloSett;
        
        Database.delete(assoc);
    }
}