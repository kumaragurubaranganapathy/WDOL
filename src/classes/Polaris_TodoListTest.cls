@isTest
public class Polaris_TodoListTest {
    @isTest
    public static void todoListTestMethod(){
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('User Account').getRecordTypeId();
        Id ConRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        Id LicRecTypeId = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        
        User newUser = DOL_TestDataFactory.createPortalAccountUser();
        System.runAs(newUser){ 
            Contact con = [Select Id from Contact Limit 1];
            Account acc = [Select Id from Account Limit 1]; 
            Account acc1 = DOL_TestDataFactory.createAccount(AccRecTypeId);  
            
            //Contact con = DOL_TestDataFactory.createContact(ConRecTypeId,acc.id);
            
            MUSW__License2__c licObj = new MUSW__License2__c(
                Name='System Number', 
                RecordTypeId = LicRecTypeId,
                MUSW__Primary_Licensee__c = acc.id, 
                Application_Type__c = 'Timeshares',
                Credential_Type__c = 'Timeshare Salesperson',
                Application_Method__c = 'General Application',
                MUSW__Expiration_Date__c = Date.newInstance(2020, 6, 05) ,
                MUSW__Applicant__c =  con.Id);
            insert licObj;
            
            Education_History__c ed = new Education_History__c();
            insert ed;
            
            MUSW__Account_Contact__c ac = new MUSW__Account_Contact__c();
            ac.First_Name__c = 'test';
            ac.Last_Name__c = 'test';
            ac.Role__c = 'Administrator';
            ac.Email__c = 'test@test.com';
            ac.Title__c = 'test';
            ac.Status__c = 'Active';
            ac.MUSW__Contact__c = con.Id;
            ac.MUSW__Account__c = acc.Id;
            ac.Account_Admin__c = true;
            ac.isAdminContact__c = true;
            insert ac;
            
            Task acts = new Task();
            acts.WhatId = ac.Id;
            acts.Status = 'Pending';        
            acts.Priority = 'Normal';
            acts.Subject = 'test';
            acts.OwnerId = UserInfo.getUserId();
            insert acts;            
            
            //association
            Associations__c asso = new Associations__c();
            asso.Parent_License__c = licObj.Id; 
            asso.Status__c = 'Deleted';
            asso.Association_Type__c = 'Designated Architect';
            asso.Child_License__c = licObj.Id;
            asso.Parent_License__c = licObj.Id;
            insert asso;  

            
            Task assots = new Task();
            assots.WhatId = asso.Id;
            assots.Status = 'Pending';
            assots.Priority = 'Normal';
            assots.Subject = 'test';
            assots.OwnerId = UserInfo.getUserId();
            
            insert assots;
            
            
            
            
            test.startTest();
            Polaris_TodoList.insertEducationRequestInformation(licObj.Id, 'Professional Engineer', 	'Engineers', 'Reschedule Exam', ed.Id); 
            Polaris_TodoList.insertRequestInformation(licObj.Id, 'Professional Engineer', 	'Engineers', 'Reschedule Exam');
            Polaris_TodoList.fetchChildLicense(assots.Id)  ; 
            Polaris_TodoList.insertRequest(ac.Id, 'Professional Engineer', 	'Engineers', 'Reschedule Exam');
            Polaris_TodoList.updateTask(assots.Id,'Accepted');
            Polaris_TodoList.updateTask(assots.Id,'Declined');
            
            Polaris_TodoList.updateTask(acts.Id,'Accepted');
            Polaris_TodoList.updateTask(acts.Id,'Declined');
            
            Polaris_TodoList.updateTaskAMR(acts.Id,'Accepted');
            Polaris_TodoList.updateTaskAMR(acts.Id,'Declined');
            
            Polaris_TodoList.hasBusinessAccounts();
            Polaris_TodoList.hasLicenses();
            Polaris_TodoList.getAllAccounts();
            Polaris_TodoList.getContactName();
            Polaris_TodoList.getTodoList();
        }
        test.stopTest();
    }
    
}