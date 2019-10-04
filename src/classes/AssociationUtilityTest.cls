@isTest
public class AssociationUtilityTest {
    
    @testSetup
    static void createData(){
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('User_Account').getRecordTypeId();
        Account acc = DOL_TestDataFactory.createAccount(accRecordTypeId);
        Id licRecordTypeId = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByDeveloperName().get('Business').getRecordTypeId();
        MUSW__License2__c lic = DOL_TestDataFactory.createLicense(licRecordTypeId, acc.Id, 'Camping Resorts', 'Camping Resort Company', 'General Application');
        
        Associations__c assoc = DOL_TestDataFactory.createAssociation(lic.Id);
        List<Associations__c> lstAssoc = new List<Associations__c>();
        lstAssoc.add(assoc);
        
        Associations__c assoc2 = DOL_TestDataFactory.createAssociation(lic.Id);
        assoc.Status__c = 'Active';
        update assoc;
        assoc2.Status__c = 'Active';
        update assoc2;
        lstAssoc.add(assoc2);
        
    }
    
    @isTest
    static void restrictChildLicensesCountTestMethod(){
        
        List<Associations__c> lstAssoc = [SELECT Id, Name, Parent_License__c, Child_License__c, Status__c FROM Associations__c];        
        AssociationUtility.restrictChildLicensesCount(lstAssoc);
        
    }
}