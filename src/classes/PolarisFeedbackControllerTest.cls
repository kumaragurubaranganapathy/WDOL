@isTest
public class PolarisFeedbackControllerTest {
    
    public static testmethod void feedbackRenewal(){
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('User Account').getRecordTypeId();
        Id ConRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        Id LicRecTypeId = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        User newUser;
         //Account acc = DOL_TestDataFactory.createAccount(AccRecTypeId);  
        //insert acc;
        //Contact con = DOL_TestDataFactory.createContact(ConRecTypeId,acc.id);
        //insert con;
        
      newUser =  DOL_TestDataFactory.createPortalAccountUser();
        System.runAs ( newUser ) {
       Contact con = [Select Id from Contact Limit 1];
       Account acc = [Select Id from Account Limit 1];
            
            //Insert for License
            MUSW__License2__c licObj = new MUSW__License2__c(
                Name='System Number', 
                RecordTypeId = LicRecTypeId,
                MUSW__Primary_Licensee__c = acc.id, 
                Application_Type__c = 'Geologist',
                Credential_Type__c = 'Geologist',
                Application_Method__c = 'General Application',
                MUSW__Applicant__c =  con.Id);
            insert licObj;
            System.debug('***licObj***'+licObj);
         
            //Insert  RenewalObj
            
            Renewal_Application__c renewalObj = new Renewal_Application__c (License__c=licObj.Id,
                                                                            Applicant__c=con.id, 
                                                                            Application_Type__c='Notary Public',
                                                                            Renewal_Reinstatement_Type__c='Renewal',
                                                                            Online_or_Paper_Application__c='Online',
                                                                            Renewal_Status__c='Draft');
            
            Insert renewalObj;
            System.debug('***renewalObj'+renewalObj); 
            User_Feedback__c feedbackObjRenew = new User_Feedback__c(Name='FeedbackName',
                                                                     Renewal_Reinstatement_Application__c=renewalObj.Id,
                                                                     Name__c=con.Id,
                                                                     License__c=licObj.Id,
                                                                     Grade__c='3.0',
                                                                     ProfCode__c='29890',
                                                                     Comments__c='TestComments');
            PolarisFeedbackController.createRecord(feedbackObjRenew);
                 //Insert AMR
            Request__c AMRObj = new Request__c(License__c=licObj.Id,
                                               Contact__c=con.Id, 
                                               Service_Request_Type__c='Update Legal Name',
                                               Status__c='Draft');
            insert AMRObj;
            System.debug('***AMRObj'+AMRObj); 
            User_Feedback__c feedbackObjAMR = new User_Feedback__c(Name='FeedbackName',
                                                                   AMR_Application__c=AMRObj.Id,
                                                                   Name__c=con.Id,
                                                                   License__c=licObj.Id,
                                                                   Grade__c='1.0',
                                                                   ProfCode__c='20990',
                                                                   Comments__c='TestComments');
            PolarisFeedbackController.createRecord(feedbackObjAMR);
            //create Endorsement
           DOL_TestDataFactory.createEndorsement(licObj.Id, 'Active');
            
        }
    }
    
  
  
    public static testmethod void feedbackLicenseNull(){
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('User Account').getRecordTypeId();
        Id ConRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        Id LicRecTypeId = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        User newUser;
        
        Account acc = DOL_TestDataFactory.createAccount(AccRecTypeId);  
        //insert acc;
        Contact con = DOL_TestDataFactory.createContact(ConRecTypeId,acc.id);
        //insert con;
        //Insert for License
        MUSW__License2__c licObj = new MUSW__License2__c(
            Name='System Number', 
            RecordTypeId = LicRecTypeId,
            MUSW__Primary_Licensee__c = acc.id, 
            Application_Type__c = 'Geologist',
            Credential_Type__c = 'Geologist',
            Application_Method__c = 'General Application',
            MUSW__Applicant__c =  con.Id);
        insert licObj;
        Renewal_Application__c renewalObj = new Renewal_Application__c (License__c=licObj.Id,
                                                                        Applicant__c=con.id, 
                                                                        Application_Type__c='Notary Public',
                                                                        Renewal_Reinstatement_Type__c='Renewal',
                                                                        Online_or_Paper_Application__c='Online',
                                                                        Renewal_Status__c='Draft');
        
        Insert renewalObj;
        System.debug('***renewalObj'+renewalObj); 
        User_Feedback__c feedbackObjRenew = new User_Feedback__c(Name='FeedbackName',
                                                                 Renewal_Reinstatement_Application__c=renewalObj.Id,
                                                                 Name__c=con.Id,
                                                                 License__c=licObj.Id,
                                                                 Grade__c='3.0',
                                                                 ProfCode__c='29890',
                                                                 Comments__c='TestComments');
        PolarisFeedbackController.createRecord(feedbackObjRenew);
         //Insert AMR
            Request__c AMRObj = new Request__c(License__c=licObj.Id,
                                               Contact__c=con.Id, 
                                               Service_Request_Type__c='Update Legal Name',
                                               Status__c='Draft');
            insert AMRObj;
            System.debug('***AMRObj'+AMRObj); 
            User_Feedback__c feedbackObjAMR = new User_Feedback__c(Name='FeedbackName',
                                                                   AMR_Application__c=AMRObj.Id,
                                                                   Name__c=con.Id,
                                                                   License__c=licObj.Id,
                                                                   Grade__c='1.0',
                                                                   ProfCode__c='20990',
                                                                   Comments__c='TestComments');
            PolarisFeedbackController.createRecord(feedbackObjAMR);
    }
}//END OF CLASS