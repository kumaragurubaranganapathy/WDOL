@isTest
public class Lnp_GenericDataTable_ApexControllerTest {
    
    public static testMethod void genericDataTableMethod(){
        Id RecordTypeIdContact = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        ID RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();        
        ID RecordTypeIdLicense = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        
        Lnp_GenericDataTable_ApexController obj = new Lnp_GenericDataTable_ApexController();
        
        /*obj.actionListWrapper action = new obj.actionListWrapper('test','test');                   
        obj.typeAttributeWrapper ty = new obj.typeAttributeWrapper();
        ty.addAction(action);
        
        obj.DataTableColumnWrapper dt = new obj.DataTableColumnWrapper();
        dt.DataTableColumnWrapper('label', 'fieldName', 'type', ty);
        */
        User newUser = DOL_TestDataFactory.createPortalAccountUser();
        System.runAs(newUser){ 
            Contact con = [Select Id from Contact Limit 1];
            Account acc = [Select Id from Account Limit 1];
            //license
            MUSW__License2__c liceId = DOL_TestDataFactory.createLicense(RecordTypeIdLicense, 
                                                                         DOL_TestDataFactory.createAccount(RecordTypeIdAccount).Id, 
                                                                         'Appraisal Management Companies', 
                                                                         'Appraisal Management Company', 
                                                                         'General Application');
            liceId.MUSW__Applicant__c = con.Id;
            update liceId;
          //  system.debug('liceId : '+liceId.MUSW__Applicant__c);
            
            
            
            
            
            MUSW__Account_Contact__c ac = new MUSW__Account_Contact__c();
            ac.First_Name__c = 'test';
            ac.Last_Name__c = 'test';
            ac.Role__c = 'Administrator';
            ac.Email__c = 'test@test.com';
            ac.Title__c = 'test';
            ac.Status__c = 'Deleted';
            ac.MUSW__Contact__c = con.Id;
            ac.MUSW__Account__c = acc.Id;
            
            insert ac;
            
            //association
            Associations__c asso = new Associations__c();
            asso.Parent_License__c = liceId.Id; 
            asso.Status__c = 'Deleted';
            asso.Association_Type__c = 'Designated Architect';
            asso.Child_License__c = liceId.Id;
            asso.Parent_License__c = liceId.Id;
            insert asso;
            
            Task acts = new Task();
            acts.WhatId = ac.Id;
            acts.Status = 'Pending';        
            acts.Priority = 'Normal';
            acts.Subject = 'test';
            acts.OwnerId = UserInfo.getUserId();
            insert acts;
            
            Task assots = new Task();
            assots.WhatId = asso.Id;
            assots.Status = 'Pending';
            assots.Priority = 'Normal';
            assots.Subject = 'test';
            assots.OwnerId = UserInfo.getUserId();
            
            insert assots;
            
            list<String> strlst = new list<String>{'John', 'Mark', 'David'};
                test.startTest();
            
            
            
            Lnp_GenericDataTable_ApexController.getSobjectData(strlst, 'sObjectName','Draft Maintance Request', con.Id);
            Lnp_GenericDataTable_ApexController.getSobjectData(strlst, 'sObjectName', 'Account Contact', acc.Id);
            Lnp_GenericDataTable_ApexController.getSobjectData(strlst, 'sObjectName', 'ProfessionalRelationshipData', con.Id);
            Lnp_GenericDataTable_ApexController.getSobjectData(strlst, 'sObjectName', 'License Relationship',liceId.Id);
            Lnp_GenericDataTable_ApexController.getSobjectData(strlst, 'sObjectName', 'Business-License',acc.Id);
            Lnp_GenericDataTable_ApexController.removeRecord(ac, 'Resend');
            Lnp_GenericDataTable_ApexController.removeRecord(ac, 'Remove');
            Lnp_GenericDataTable_ApexController.fetchLicenseDetails(liceId.Id);
            Lnp_GenericDataTable_ApexController.removeAssociationRecord(asso, 'Resend');
            Lnp_GenericDataTable_ApexController.removeAssociationRecord(asso, 'Remove');
            Lnp_GenericDataTable_ApexController.createTask(ac.Id, 'test@test.com');
            
            Lnp_GenericDataTable_ApexController.createAssociationTask(asso.Id);            
        }
        
        
        test.stopTest();
    }
}