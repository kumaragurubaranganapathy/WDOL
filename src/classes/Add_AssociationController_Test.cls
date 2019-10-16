@isTest
public class Add_AssociationController_Test {
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
    
    /*@isTest
    static void searchIDsTest(){
        MUSW__License2__c lic = [SELECT Id, Name FROM MUSW__License2__c LIMIT 1];
        //System.debug('lic.Name::'+lic.Name);
        Associations__c assoc = [SELECT Id, Name, Name__c, Child_Contact__c, Child_License__c, Source_Id__c, Submitted_Date__c, Parent_License__c FROM Associations__c LIMIT 1];
        
        List<MUSW__License2__c> lstLic = Add_AssociationController.searchForIds(String.valueOf(lic.Name), lic.Id);
    }*/
    
    @isTest
    static void getAssociationsSuccessTest(){
        MUSW__License2__c lic = [SELECT Id, Name FROM MUSW__License2__c LIMIT 1];
        Associations__c assoc = [SELECT Id, Name__c,Child_Contact_Name__c,Child_License_Name__c,Parent_License_Name__c,Submitted_Date__c FROM Associations__c WHERE Parent_License__c =:lic.Id];
        List<Associations__c> lstAssoc = Add_AssociationController.getAssociations(lic.Id);
    }
    
    @isTest
    static void getAssociationsFailureTest(){
        Account acc = [SELECT Id, Name FROM Account LIMIT 1];
        MUSW__License2__c lic = [SELECT Id, Name FROM MUSW__License2__c LIMIT 1];
        Associations__c assoc = [SELECT Id, Name__c,Child_Contact_Name__c,Child_License_Name__c,Parent_License_Name__c,Submitted_Date__c FROM Associations__c WHERE Parent_License__c =:lic.Id];
        update assoc;
        List<Associations__c> lstAssoc = Add_AssociationController.getAssociations(acc.Id);
    }
    
        @isTest
    static void deleteAssociationsSuccessTest(){
        List<Associations__c> assoc = [SELECT Id, Name__c,Child_Contact_Name__c,Child_License_Name__c,Parent_License_Name__c,Submitted_Date__c FROM Associations__c];
        Boolean delAssoc = Add_AssociationController.deleteAssociations(assoc);
    }
    
    @isTest
    static void deleteAssociationsFailureTest(){
        Associations__c asso = [SELECT Id FROM Associations__c LIMIT 1];
        asso.End_Date__c = Date.newInstance(2020, 02, 16);
        update asso;
        
        Database.DeleteResult delAsso = Database.delete(asso);
        System.assert(delAsso.isSuccess());
        List<Associations__c> assoc = [SELECT Id, Name__c,Child_Contact_Name__c,Child_License_Name__c,Parent_License_Name__c,Submitted_Date__c FROM Associations__c];
        Boolean delAssoc = Add_AssociationController.deleteAssociations(assoc);
        
    }

}