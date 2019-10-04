/*
 * Class Name:  EndorsementStatusOnProviderDeleteTest
 * Trigger:     updateEndorsementStatusOnProviderDelete
 * Description: This is test class for Trigger:updateEndorsementStatusOnProviderDelete
 */

@isTest
public class EndorsementStatusOnProviderDeleteTest{
    public static testmethod void testEndorsmentMethod(){
        Global_Settings__c globalSetting = new Global_Settings__c(Name = UserInfo.getUsername(), Disable_Triggers__c = false);
        
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Id ConRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        Id LicRecTypeId = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        Id ApplcationRecType = Schema.SObjectType.MUSW__Application2__c.getRecordTypeInfosByName().get('General Service Request').getRecordTypeId();
            
        
        //Insert Account
        Account acc = DOL_TestDataFactory.createAccount(AccRecTypeId);   
        
        //Insert con
        Contact con = DOL_TestDataFactory.createContact(ConRecTypeId,acc.id);
                
        //Insert License
        MUSW__License2__c lic = DOL_TestDataFactory.createLicense(LicRecTypeId, acc.Id, 'Architects', 'Architect', 'General Application');
        lic.MUSW__Applicant__c =  con.Id;
        update lic;
        
        //Insert Application
        MUSW__Application2__c application = DOL_TestDataFactory.createApplication(ApplcationRecType);
        
        //Insert Request
        Request__c req = DOL_TestDataFactory.createRequest(lic.Id, 'Architects','Architect');
        
        //Insert Endorsement
        Endorsement__c endors = DOL_TestDataFactory.createEndorsement(lic.Id,'In-Review');
        
        Electronic_Notary_Provider_Information__c enp = new Electronic_Notary_Provider_Information__c();
        enp.Application_BG__c = application.id;
        enp.Date_Requested__c = system.today();
        enp.Description__c = 'Test Description';
        enp.Effective_Date__c = system.today();
        enp.Endorsement__c = endors.id;
        enp.Provider_Name__c = 'Docusign';
        enp.Request__c = req.id;
        insert enp;
        update enp;
        delete enp;
    }
    
      public static testmethod void testEndorsmentMethod2(){
        Global_Settings__c globalSetting = new Global_Settings__c(Name = UserInfo.getUsername(), Disable_Triggers__c = false);
        
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Id ConRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        Id LicRecTypeId = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        Id ApplcationRecType = Schema.SObjectType.MUSW__Application2__c.getRecordTypeInfosByName().get('General Service Request').getRecordTypeId();
            
        
        //Insert Account
        Account acc = DOL_TestDataFactory.createAccount(AccRecTypeId);   
        
        //Insert con
        Contact con = DOL_TestDataFactory.createContact(ConRecTypeId,acc.id);
                
        //Insert License
        MUSW__License2__c lic = DOL_TestDataFactory.createLicense(LicRecTypeId, acc.Id, 'Architects', 'Architect', 'General Application');
        lic.MUSW__Applicant__c =  con.Id;
        update lic;
        
        //Insert Application
        MUSW__Application2__c application = DOL_TestDataFactory.createApplication(ApplcationRecType);
        
        //Insert Request
        Request__c req = DOL_TestDataFactory.createRequest(lic.Id, 'Architects','Architect');
        globalSetting.Disable_Triggers__c = true;
        test.startTest();
        //Insert Endorsement
        Endorsement__c endors = DOL_TestDataFactory.createEndorsement(lic.Id,'In-Review');
        
        Electronic_Notary_Provider_Information__c enp = new Electronic_Notary_Provider_Information__c();
        enp.Application_BG__c = application.id;
        enp.Date_Requested__c = system.today();
        enp.Description__c = 'Test Description';
        enp.Effective_Date__c = system.today();
        enp.Endorsement__c = endors.id;
        enp.Provider_Name__c = 'Docusign';
        enp.Request__c = req.id;
        insert enp;
        update enp;
        delete enp;
          test.stopTest();
    }
}