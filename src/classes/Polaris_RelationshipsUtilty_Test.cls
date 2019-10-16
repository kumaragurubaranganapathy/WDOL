@isTest
public class Polaris_RelationshipsUtilty_Test {
    
    @testSetup
    private static void setupTestData()
    { 
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c lic1 = DOL_TestDataFactory.createLicense(LicRecTypeId1, a.Id, 'Architects', 'Architect', 'General Application');
        Id recTypeId = Schema.SObjectType.Associations__c.getRecordTypeInfosByName().get('Designated Person').getRecordTypeId();
        Associations__c asso = new Associations__c();
        asso.recordTypeId = recTypeId;
        asso.Parent_License__c = lic1.Id;
        asso.Status__c = 'Active';
        insert asso;
        
        
        Task tsk = new Task();
        tsk.Subject = 'Test Task';
        tsk.Status = 'Open';
        tsk.Priority = 'Normal';
        tsk.WhatId = asso.Id;
        insert tsk;
        User u2 = new User(Alias = 'newUser', Email='newuser@testorg.com',
                           EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                           LocaleSidKey='en_US', ProfileId = p.Id,
                           TimeZoneSidKey='America/Los_Angeles', UserName='newuser567@testorg.com');
        insert u2;
        
        Associations__c asso1 = new Associations__c();
        asso1.recordTypeId = recTypeId;
        asso1.Parent_License__c = lic1.Id;
        asso1.Status__c = 'Canceled';
        insert asso1;
        
    }
    @isTest
    public static void testMethod1(){
        Associations__c ascc =[select id from Associations__c limit 1];
        Associations__c ascc2 =[select id from Associations__c where Status__c ='Canceled' limit 1];
        
        User u3 = [SELECT Id FROM User WHERE UserName='newuser567@testorg.com'];
      //  system.debug('ascc'+ascc); 
        
        test.startTest();
        Polaris_RelationshipsUtilty.removeAssociationRecord(ascc.Id);
        Polaris_RelationshipsUtilty.updateAssociationRecord(ascc.Id,'Cancel');
        Polaris_RelationshipsUtilty.updateAssociationRecord(ascc.Id,'resend');
        Polaris_RelationshipsUtilty.updateAssociationRecord(ascc.Id,'remove');
        System.runAs(u3){
            Polaris_RelationshipsUtilty.removeAssociationRecord(ascc.Id);
            Polaris_RelationshipsUtilty.updateAssociationRecord(ascc.Id,'remove');
            
        }
        
        test.stopTest();
        
    }
    
    
    @isTest
    public static void testMethod3(){
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c lic1 = DOL_TestDataFactory.createLicense(LicRecTypeId1, a.Id, 'Architects', 'Architect', 'General Application');
        Id recTypeId = Schema.SObjectType.Associations__c.getRecordTypeInfosByName().get('Designated Person').getRecordTypeId();
        Associations__c asso = new Associations__c();
        asso.recordTypeId = recTypeId;
        asso.Parent_License__c = lic1.Id;
        asso.Status__c = 'Active';
        insert asso;
        MUSW__Account_Contact__c ac = new MUSW__Account_Contact__c();
        ac.First_Name__c = 'FName';
        ac.Middle_Name__c = 'mName';
        ac.Last_Name__c = 'LName';
        ac.Email__c = 'test@test.com';
        insert ac;
        
        Task tsk = new Task();
        tsk.Subject = 'Test Task';
        tsk.Status = 'Open';
        tsk.Priority = 'Normal';
        tsk.WhatId = ac.Id;
        insert tsk;
        Polaris_RelationshipsUtilty.removeAffliationRecord(ac.Id);
        User u3 = [SELECT Id FROM User WHERE UserName='newuser567@testorg.com'];
        System.runAs(u3){
            Polaris_RelationshipsUtilty.removeAffliationRecord(ac.Id);
        }
    }
    
    @isTest
    public static void testMethod4(){
        try{
            Polaris_RelationshipsUtilty.removeAssociationRecord('12345');
        }catch(Exception ex){}
        try{
            Polaris_RelationshipsUtilty.removeAffliationRecord('12345');
        }catch(Exception ex){}
        try{
            Polaris_RelationshipsUtilty.updateAssociationRecord('a0Zr0000001otOE', 'statusOfAssociation');
        }catch(Exception ex){}
        
        try{
            Polaris_RelationshipsUtilty.updateAssociationRecord(null,null);
        }catch(Exception ex){}
        
    }
    
    
}