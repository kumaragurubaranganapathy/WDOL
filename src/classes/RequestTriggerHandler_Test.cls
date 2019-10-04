@isTest
public class RequestTriggerHandler_Test {
    @isTest
    public static void testMethod1(){
        
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c lic1 = DOL_TestDataFactory.createLicense(LicRecTypeId1, a.Id, 'Architects', 'Architect', 'General Application');
        lic1.Application_Type__c = 'Notary Public';
        lic1.Credential_Type__c = 'Notary Public';
        update lic1;
        Request__c req = DOL_TestDataFactory.createRequest(lic1.Id, 'Architects', 'Architect');
        Id quesRecTypeId = Schema.SObjectType.Question__c.getRecordTypeInfosByName().get('License Information').getRecordTypeId();
        Question__c ques = DOL_TestDataFactory.createQuestion(quesRecTypeId);
        
        Answer__c ans = DOL_TestDataFactory.createAnswer(lic1.Id,ques.Id);
        BGCK__Answer__c bgAns = new BGCK__Answer__c();
        bgAns.QuestionDOL__c = ques.Id;
        bgAns.Request__c = req.Id;
        insert bgAns;
        
             MUSW__Parcel__c parcl = new MUSW__Parcel__c();
        parcl.Request_Parcel__c = req.Id;
        insert parcl;
        
        MUSW__License_Parcel__c licParcl = new MUSW__License_Parcel__c();
        licParcl.MUSW__License2__c = lic1.Id;
        licParcl.Physical__c = true;
        licParcl.Status__c = 'Active';
        licParcl.MUSW__Parcel__c = parcl.Id;
        licParcl.Mailing__c = true;
        insert licParcl;
        
        req.Profession__c = 'Notary Public';
        req.License_Type__c = 'Notary Public';
        req.Status__c = 'Approved';
        req.Service_Request_Type__c = 'Update Physical Address';
        update req;
        
    }
    
    @isTest
    public static void testMethod2(){
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c lic1 = DOL_TestDataFactory.createLicense(LicRecTypeId1, a.Id, 'Architects', 'Architect', 'General Application');
        lic1.Application_Type__c = 'Notary Public';
        lic1.Credential_Type__c = 'Notary Public';
        update lic1;
        Request__c req = DOL_TestDataFactory.createRequest(lic1.Id, 'Architects', 'Architect');
        Id quesRecTypeId = Schema.SObjectType.Question__c.getRecordTypeInfosByName().get('License Information').getRecordTypeId();
        Question__c ques = DOL_TestDataFactory.createQuestion(quesRecTypeId);
        
        Answer__c ans = DOL_TestDataFactory.createAnswer(lic1.Id,ques.Id);
        
        req.Profession__c = 'Notary Public';
        req.License_Type__c = 'Notary Public';
        req.Status__c = 'Under Review';
        req.Service_Request_Type__c = 'Reschedule Exam';//CE Audit
        update req;
        
    }
    
    @isTest
    public static void testMethod3(){
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c lic1 = DOL_TestDataFactory.createLicense(LicRecTypeId1, a.Id, 'Architects', 'Architect', 'General Application');
        lic1.Application_Type__c = 'Notary Public';
        lic1.Credential_Type__c = 'Notary Public';
        update lic1;
        Request__c req = DOL_TestDataFactory.createRequest(lic1.Id, 'Architects', 'Architect');
        Id quesRecTypeId = Schema.SObjectType.Question__c.getRecordTypeInfosByName().get('License Information').getRecordTypeId();
        Question__c ques = DOL_TestDataFactory.createQuestion(quesRecTypeId);
        
        Answer__c ans = DOL_TestDataFactory.createAnswer(lic1.Id,ques.Id);
        Task tsk = new Task();
        tsk.WhatId = req.Id;
        tsk.Status = 'Pending';
        insert tsk;
        system.debug('tsk::'+tsk);
        
        req.Profession__c = 'Notary Public';
        req.License_Type__c = 'Notary Public';
        req.Status__c = 'Under Review';
        req.Service_Request_Type__c = 'CE Audit';
        update req;
        
        
        
    }
    
    @isTest
    public static void testMethod4(){
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c lic1 = DOL_TestDataFactory.createLicense(LicRecTypeId1, a.Id, 'Architects', 'Architect', 'General Application');
        lic1.Application_Type__c = 'Notary Public';
        lic1.Credential_Type__c = 'Notary Public';
        update lic1;
        Request__c req = DOL_TestDataFactory.createRequest(lic1.Id, 'Architects', 'Architect');
        Id quesRecTypeId = Schema.SObjectType.Question__c.getRecordTypeInfosByName().get('License Information').getRecordTypeId();
        Question__c ques = DOL_TestDataFactory.createQuestion(quesRecTypeId);
        
        Answer__c ans = DOL_TestDataFactory.createAnswer(lic1.Id,ques.Id);
        BGCK__Answer__c bgAns = new BGCK__Answer__c();
        bgAns.QuestionDOL__c = ques.Id;
        bgAns.Request__c = req.Id;
        insert bgAns;
        
        MUSW__Parcel__c parcl = new MUSW__Parcel__c();
        parcl.Request_Parcel__c = req.Id;
        insert parcl;
        
        MUSW__License_Parcel__c licParcl = new MUSW__License_Parcel__c();
        licParcl.MUSW__License2__c = lic1.Id;
        licParcl.Physical__c = true;
        licParcl.Status__c = 'Active';
        licParcl.MUSW__Parcel__c = parcl.Id;
        insert licParcl;
        
        req.Profession__c = 'Notary Public';
        req.License_Type__c = 'Notary Public';
        req.Status__c = 'Approved';
        req.Service_Request_Type__c = 'Update Print Name';//CE Audit
        try{
            update req;
        }catch(exception ex){}
        
    }
    
    
    @isTest
    public static void testUnusedMethods(){
        RequestTriggerHandler rt = new RequestTriggerHandler();
        rt.onAfterDelete();
        rt.onAfterInsert();
        rt.onAfterUndelete();
        rt.onBeforeDelete();
        rt.onBeforeInsert();
        rt.onBeforeUndelete();
    }
}