@isTest
public class TriggerHandlerTest {
    @testSetup
    static void createData(){
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('User_Account').getRecordTypeId();
        Account acc = DOL_TestDataFactory.createAccount(accRecordTypeId);
        Id contactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Contact').getRecordTypeId();
        Contact con = DOL_TestDataFactory.createContact(contactRecordTypeId, acc.Id);
        Id licRecordTypeId = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByDeveloperName().get('Business').getRecordTypeId();
        MUSW__License2__c lic = DOL_TestDataFactory.createLicense(licRecordTypeId, acc.Id, 'Timeshares', 'Timeshare Company', 'General Application');
        Associations__c assoc = DOL_TestDataFactory.createAssociation(lic.Id);
    }
    
    @isTest
    static void triggerHandlerTest(){
        Associations__c asso = [SELECT Id FROM Associations__c LIMIT 1];
        asso.End_Date__c = Date.newInstance(2020, 02, 16);
        update asso;
        
        Database.DeleteResult delAsso = Database.delete(asso);
        System.assert(delAsso.isSuccess());
        //List<Associations__c> assoc = [SELECT Id, Name__c,Child_Contact_Name__c,Child_License_Name__c,Parent_License_Name__c,Submitted_Date__c FROM Associations__c];
        //Boolean delAssoc = Add_AssociationController.deleteAssociations(assoc);
        Database.UndeleteResult undelAsso = Database.undelete(asso);
        System.assert(undelAsso.isSuccess());
    }
    
    @isTest
    static void loopTestMethod(){
        Associations__c asso = [SELECT Id FROM Associations__c LIMIT 1];
        TriggerHandler tH = new TriggerHandler();
        tH.setMaxLoopCount(5);
        tH.clearMaxLoopCount();
        
        Test.startTest();
        TriggerHandler.LoopCount lC = new TriggerHandler.LoopCount();
        lC.increment();
        lC.exceeded();
        lC.getMax();
        lC.getCount();
        Test.stopTest();
    }
    
    @isTest
    static void byPassTestMethod(){
        TriggerHandler.bypass('Handler'); 
        TriggerHandler.clearBypass('Handler'); 
        TriggerHandler.isBypassed('Handler'); 
        TriggerHandler.clearAllBypasses();
    }
    
    @isTest
    static void dmlMethod(){
		Test.startTest();
        TriggerHandler th = new TriggerHandler();
        th.beforeInsert();
        th.afterInsert();
        th.beforeUpdate();
        th.afterUpdate();
        th.beforeDelete();
        th.afterDelete();
        th.afterUndelete();
		Test.stopTest();
    }
}