/**
* Name: License2TriggerHandler_Test
* Type: Class
* Description: Test class for License2TriggerHandler
* Date:        Developer/Company                    Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 06/19/2018   Sharad Maheshwari/Deloitte           Initial Creation
**/

@isTest
public class License2TriggerHandler_Test {
    @testsetup
    static void setup(){
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        a.Name = 'Setup Acc';
        update a;
        Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c lic1 = DOL_TestDataFactory.createLicense(LicRecTypeId1, a.Id, 'Notary Public', 'Notary Public', 'General Application');
        Associations__c asso = new Associations__c();
        asso.Child_License__c = lic1.id;
        asso.Parent_License__c = lic1.id;
        asso.Status__c = 'Generate Fee';
        insert asso;
        //SELECT id,Whatid,Status,Sub_status__c from task 
        List<Task> taskLst = new List<Task>();
        Task tsk1 = new task();
        tsk1.WhatId = asso.id;
        Task tsk2 = new task();
        tsk2.WhatId = lic1.id;
        tsk2.Type = 'Payment Reminder';
        tasklst.add(tsk1);
        tasklst.add(tsk2);
        insert tasklst;
        //SELECT id,License__c,Status__c FROM Endorsement__c where License__c IN:setLicense AND Status__c='Pending Add' ];
        Endorsement__c endo = new Endorsement__c();
        endo.License__c = lic1.id;
        endo.Status__c = 'Pending Add';
        endo.Date_Requested_for_Adding_Endorsement__c = System.today();
        insert endo;
    }
    
    @isTest
    public static void testTriggerDelete(){
        Global_Settings__c globalSetting = DOL_TestDataFactory.createGlobalSetting(UserInfo.getUsername(),true);
        MUSW__License2__c lic1 = [Select id from MUSW__License2__c where Application_Type__c = 'Notary Public'];
        delete lic1;
        Account a = [select id from account where Name = 'Setup Acc'];
		Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c lic2 = DOL_TestDataFactory.createLicense(LicRecTypeId1, a.Id, 'Notary Public', 'Notary Public', 'General Application');
        
    }
       
    @isTest
    public static void testTrigger4(){
        Global_Settings__c globalSetting = DOL_TestDataFactory.createGlobalSetting(UserInfo.getUsername(),false);
        MUSW__License2__c lic1 = [Select id from MUSW__License2__c where Application_Type__c = 'Notary Public'];
        lic1.MUSW__Expiration_Date__c = system.today()+1;
        update lic1;
        lic1.MUSW__Expiration_Date__c = system.today()+2;
        lic1.MUSW__Status__c = 'Active';
        update lic1;
    }
    
    @isTest
    public static void testTrigger5(){
        Global_Settings__c globalSetting = DOL_TestDataFactory.createGlobalSetting(UserInfo.getUsername(),false);
        MUSW__License2__c lic1 = [Select id from MUSW__License2__c where Application_Type__c = 'Notary Public'];
        lic1.MUSW__Issue_Date__c = system.today();
        lic1.MUSW__Expiration_Date__c = system.today()+2;
        update lic1;
        lic1.MUSW__Issue_Date__c = system.today()+1;
        lic1.MUSW__Status__c = 'Active';
        update lic1;
    }
    
    @isTest
    public static void testTrigger6(){
        Global_Settings__c globalSetting = DOL_TestDataFactory.createGlobalSetting(UserInfo.getUsername(),false);
        MUSW__License2__c lic1 = [Select id from MUSW__License2__c where Application_Type__c = 'Notary Public'];
        delete lic1;
        undelete lic1;
    }
    
    @isTest
    public static void testTrigger1(){
        Global_Settings__c globalSetting = DOL_TestDataFactory.createGlobalSetting(UserInfo.getUsername(),false);
        MUSW__License2__c lic1 = [Select id from MUSW__License2__c where Application_Type__c = 'Notary Public'];
        lic1.MUSW__Status__c = 'Pending Payment';
        update lic1;
    }
    
    @isTest
    public static void testTrigger2(){
        Global_Settings__c globalSetting = DOL_TestDataFactory.createGlobalSetting(UserInfo.getUsername(),false);
        MUSW__License2__c lic1 = [Select id from MUSW__License2__c where Application_Type__c = 'Notary Public'];
        lic1.MUSW__Status__c = 'Active';
        update lic1;
    }
    
    @isTest
    public static void testTrigger3(){
        Global_Settings__c globalSetting = DOL_TestDataFactory.createGlobalSetting(UserInfo.getUsername(),false);
        MUSW__License2__c lic1 = [Select id from MUSW__License2__c where Application_Type__c = 'Notary Public'];
        lic1.MUSW__Status__c = 'Active';
        update lic1;
        lic1.Polaris_DHP__c = True;
        lic1.MUSW__Status__c = 'Inactive';
        update lic1;
    }
    
    @isTest
    public static void testTrigger7(){
        Global_Settings__c globalSetting = DOL_TestDataFactory.createGlobalSetting(UserInfo.getUsername(),false);
        MUSW__License2__c lic1 = [Select id from MUSW__License2__c where Application_Type__c = 'Notary Public'];
        
        //SELECT id,Child_License__c,Status__c FROM Associations__c WHERE Child_License__c IN:childSetLicenseId and Child_License__c!=null AND Status__c =: DOL_AppConstants.NULL_EMPTY_STRING + 'Generate Fee' and Status__c!=null
        lic1.MUSW__Status__c = 'Active';
        update lic1;
        lic1.Polaris_DHP__c = True;
        lic1.MUSW__Status__c = 'Inactive';
        update lic1;
    }
    
     
    
    
    
}