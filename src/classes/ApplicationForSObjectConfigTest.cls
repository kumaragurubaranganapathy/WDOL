@isTest
public class ApplicationForSObjectConfigTest {
    
    @testSetup
    static void setupTestData(){
        Global_Settings__c gs= new Global_Settings__c(SetupOwnerId=UserInfo.getUserId(), Disable_Triggers__c=true);
         insert gs;

        Account citizenAccount = CreateTestDataUtility.createCitizenAccount();
        insert citizenAccount;
        Account account = CreateTestDataUtility.createAccount();
        account.Name = 'Test Account';
        insert account;
       
        Contact contact = CreateTestDataUtility.createContact(account.Id);
        contact.FirstName = 'Test Contact';
        insert contact;
        
        MUSW__License2__c testLicense = CreateTestDataUtility.createLicense( account.id,contact.Id); //License
        insert testLicense;
        
        MUSW__Permit2__c testPermit = CreateTestDataUtility.createPermit( account.id,contact.Id);
        insert testPermit;
        delete gs;
        
    }
    
    @isTest
    static void testfactoryMethod(){
        Test.startTest();
        ApplicationForSObjectConfig.factoryMethod(Label.str_PLAN_REVIEW);
        ApplicationForSObjectConfig.factoryMethod(label.RNT_Renewal);
        ApplicationForSObjectConfig.factoryMethod(label.Str_ManufacturedHomesRenewal);
        ApplicationForSObjectConfig.factoryMethod(label.RNT_Reinstatement);
        ApplicationForSObjectConfig.factoryMethod(label.STR_Service_Request);
        ApplicationForSObjectConfig.factoryMethod(Label.Str_Trades_Credential);
        ApplicationForSObjectConfig.factoryMethod('TestNull');
        Test.stopTest();
    }
    
    @isTest
    static void testLicenseConfigMethods(){
        Test.startTest();
        Contact contact = [select id from Contact where FirstName = 'Test Contact'];
        Account acct =  [select id from Account limit 1];
        MUSW__License2__c testLicense = [Select Id, Application_type__c, credential__c,credential_type__C,application_method__C, MUSW__Type__c, MUSW__Primary_Licensee__c, Business_License__c 
                                         from MUSW__License2__c 
                                         limit 1];
        
        ApplicationForSObjectConfig.LicenseConfig obj = new ApplicationForSObjectConfig.LicenseConfig();
        obj.getContactRelationship();
        obj.createInstance();
        obj.getObjectName();
        obj.getCurrentRecordWhereClause();
        obj.getFeeRequirementWhereClause('1234');
        obj.setPageTitle();
        obj.getQuestionObjectLookup();
        obj.getAttachmentObjectLookup();
        obj.getStatusField();
        
        Newsfeed__c news = new Newsfeed__c ();
        news.Credential_Type__c =testLicense.Credential_Type__c;
        news.Credential__c=testLicense.Credential__c;
        news.Application_Type__c=testLicense.Application_Type__c;
        news.Application_Method__c=testLicense.Application_Method__c;
        news.Instructions__c = 'Test Instructions';
        news.RecordTypeId = [select id from RecordType where name = 'Attestation Line' ].id;
        news.Show_For__c = 'Credential';
        news.External_Id__c='abec';
        insert news;
       
        PageReference pageRef = Page.Application;
        Test.setCurrentPage(pageRef);  
        ApexPages.currentPage().getParameters().put('applicationType', testlicense.Application_Type__c);
        ApexPages.currentPage().getParameters().put('credential', testlicense.Credential__c);
        ApexPages.currentPage().getParameters().put('credentialType', testlicense.Credential_Type__c);
        ApexPages.currentPage().getParameters().put('accountId', acct.id);
        ApexPages.currentPage().getParameters().put('contactId', contact.id);
        ApplyForSObjectCtlr ctrl = new ApplyForSObjectCtlr();
        
        ctrl.existingRecId = testLicense.id;
        ctrl.licenseBy = testlicense.Application_Method__c;

        obj.getBoardLicenseType(ctrl);
        obj.getExistingRecord(ctrl);
        obj.setFieldValues(ctrl);
        obj.setRecordTypeField(ctrl);
        obj.setBoardLicenseType(ctrl);
        obj.setLicenseId(ctrl);
        obj.getLegalText(ctrl);
        
        Newsfeed__c link = new Newsfeed__c ();
        link.Credential_Type__c =testLicense.Credential_Type__c;
        link.Credential__c=testLicense.Credential__c;
        link.Application_Type__c=testLicense.Application_Type__c;
        link.External_Id__c='absec';
        link.Application_Method__c=testLicense.Application_Method__c;
        link.RecordTypeId = [select id from RecordType where name = 'Affidavit Link'].id;
        link.Show_For__c = 'Credential';
        insert link;
        
        obj.getAffidavitLink(ctrl);
        Test.stopTest();
    }
    
    

    @isTest
    static void testLicenseRenewalConfigMethods(){
        /*
        Test.startTest();
        Contact contact = [select id from Contact where FirstName = 'Test Contact'];
        Account acct =  [select id from Account limit 1];
       MUSW__License2__c testLicense = [Select Id, Application_type__c, credential__c,credential_type__C,application_method__C, MUSW__Type__c, MUSW__Primary_Licensee__c, Business_License__c 
                                         from MUSW__License2__c 
                                         limit 1];
        
        Renewal_Application__c renewal = new Renewal_Application__c();
        renewal.Credential_Type__c=testlicense.Credential_Type__c;
        renewal.Credential__c=testlicense.Credential__c;
        renewal.Applicant__c = contact.id;    
        renewal.Licensee__c = acct.id;
        renewal.License__c=testlicense.Id;
        renewal.Renewal_Reinstatement_Type__c = Label.RNT_Renewal;
        insert renewal;
        
        ApplicationForSObjectConfig.RenewalConfig obj = new ApplicationForSObjectConfig.RenewalConfig();
        obj.getContactRelationship();
        obj.createInstance();
        
        obj.getObjectName();
        obj.getCurrentRecordWhereClause();
        obj.getFeeRequirementWhereClause('1234');
        obj.setPageTitle();
        obj.getQuestionObjectLookup();
        obj.getAttachmentObjectLookup();
        obj.getStatusField();
        Newsfeed__c news = new Newsfeed__c ();
        news.Credential_Type__c =testLicense.Credential_Type__c;
        news.Credential__c=testLicense.Credential__c;
        news.Application_Type__c=testLicense.Application_Type__c;
        news.Application_Method__c=testLicense.Application_Method__c;
        news.Instructions__c = 'Test Instrsdsductions';
        news.RecordTypeId = [select id from RecordType where name =:label.RT_Attestation_Line ].id;
        news.Show_For__c = label.Str_Credential_Renewal;
        news.External_Id__c='asasas';
        insert news;
        System.debug('anew '+news);
        PageReference pageRef = Page.Application;
        Test.setCurrentPage(pageRef);  
        ApexPages.currentPage().getParameters().put('applicationType','Renewal');
           ApexPages.currentPage().getParameters().put('applicationMethod',testlicense.Application_Method__c);
       ApexPages.currentPage().getParameters().put('credentialType', testlicense.Credential_Type__c);
        ApexPages.currentPage().getParameters().put('renewalOrReinstatement', 'Renewal');
        ApexPages.currentPage().getParameters().put('credential', testlicense.Credential__c);
        ApexPages.currentPage().getParameters().put('accountId', acct.id);
        ApexPages.currentPage().getParameters().put('parentId', testLicense.id);
        ApplyForSObjectCtlr ctrl = new ApplyForSObjectCtlr();
        ctrl.parentId = testLicense.id;
        System.debug('ctrl.lic '+ctrl.lic);
        obj.getBoardLicenseType(ctrl);
        obj.getExistingRecord(ctrl);
        obj.setFieldValues(ctrl);
        obj.setRecordTypeField(ctrl);
        obj.setBoardLicenseType(ctrl);
        obj.setLicenseId(ctrl);
        obj.getLegalText(ctrl);
        
        Newsfeed__c link = new Newsfeed__c ();
        link.Credential_Type__c =testLicense.Credential_Type__c;
        link.Credential__c=testLicense.Credential__c;
        link.Application_Type__c=testLicense.Application_Type__c;
        link.External_Id__c='absec';
        link.Application_Method__c=testLicense.Application_Method__c;
        link.RecordTypeId = [select id from RecordType where name =:label.RT_Affidavit_Link].id;
        link.Show_For__c = Label.Str_Credential_Renewal;
        link.External_Id__c='asasass';
        link.Link__c='www.google.com';
        insert link;
        
      //  obj.getAffidavitLink(ctrl);
        
        //ctrl.parentId = renewal.id;
        obj.setFieldValues(ctrl);
        Test.stopTest();*/
    }
    
    
     @isTest
    static void testReinstatementConfigMethods(){
        /*
       Test.startTest();
        Contact contact = [select id from Contact where FirstName = 'Test Contact'];
        Account acct =  [select id from Account limit 1];
       MUSW__License2__c testLicense = [Select Id, Application_type__c, credential__c,credential_type__C,application_method__C, MUSW__Type__c, MUSW__Primary_Licensee__c, Business_License__c 
                                         from MUSW__License2__c 
                                         limit 1];
        
        Renewal_Application__c renewal = new Renewal_Application__c();
        renewal.Credential_Type__c=testlicense.Credential_Type__c;
        renewal.Credential__c=testlicense.Credential__c;
        renewal.Applicant__c = contact.id;    
        renewal.Licensee__c = acct.id;
        renewal.License__c=testlicense.Id;
        renewal.Renewal_Reinstatement_Type__c = Label.RNT_Reinstatement;
        insert renewal;
        
        ApplicationForSObjectConfig.ReinstatementConfig obj = new ApplicationForSObjectConfig.ReinstatementConfig();
        obj.getContactRelationship();
        obj.createInstance();
        
        obj.getObjectName();
        obj.getCurrentRecordWhereClause();
        obj.getFeeRequirementWhereClause('1234');
        obj.setPageTitle();
        obj.getQuestionObjectLookup();
        obj.getAttachmentObjectLookup();
        obj.getStatusField();
        Newsfeed__c news = new Newsfeed__c ();
        news.Credential_Type__c =testLicense.Credential_Type__c;
        news.Credential__c=testLicense.Credential__c;
        news.Application_Type__c=testLicense.Application_Type__c;
        news.Application_Method__c=testLicense.Application_Method__c;
        news.Instructions__c = 'Test Instrsdsductions';
        news.RecordTypeId = [select id from RecordType where name =:label.RT_Attestation_Line ].id;
        news.Show_For__c = label.Str_Credential_Reinstatement;
        news.External_Id__c='asasas';
        insert news;
        System.debug('anew '+news);
        PageReference pageRef = Page.Application;
        Test.setCurrentPage(pageRef);  
        ApexPages.currentPage().getParameters().put('applicationType','Renewal');
           ApexPages.currentPage().getParameters().put('applicationMethod',testlicense.Application_Method__c);
       ApexPages.currentPage().getParameters().put('credentialType', testlicense.Credential_Type__c);
        ApexPages.currentPage().getParameters().put('renewalOrReinstatement', 'Reinstatement');
        ApexPages.currentPage().getParameters().put('credential', testlicense.Credential__c);
        ApexPages.currentPage().getParameters().put('accountId', acct.id);
        ApexPages.currentPage().getParameters().put('parentId', testLicense.id);
        ApplyForSObjectCtlr ctrl = new ApplyForSObjectCtlr();
        ctrl.parentId = testLicense.id;
        System.debug('ctrl.lic '+ctrl.lic);
        obj.getBoardLicenseType(ctrl);
        obj.getExistingRecord(ctrl);
        obj.setFieldValues(ctrl);
        obj.setRecordTypeField(ctrl);
        obj.setBoardLicenseType(ctrl);
        obj.setLicenseId(ctrl);
        obj.getLegalText(ctrl);
        
        Newsfeed__c link = new Newsfeed__c ();
        link.Credential_Type__c =testLicense.Credential_Type__c;
        link.Credential__c=testLicense.Credential__c;
        link.Application_Type__c=testLicense.Application_Type__c;
        link.External_Id__c='absec';
        link.Application_Method__c=testLicense.Application_Method__c;
        link.RecordTypeId = [select id from RecordType where name =:label.RT_Affidavit_Link].id;
        link.Show_For__c = Label.Str_Credential_Reinstatement;
        link.External_Id__c='asasass';
        link.Link__c='www.google.com';
        insert link;
        
      //  obj.getAffidavitLink(ctrl);
        
        //ctrl.parentId = renewal.id;
        obj.setFieldValues(ctrl);
        Test.stopTest();
        */
    }
    
     @isTest
    static void testPermtiConfigMethods(){
        Test.startTest();
        Contact contact = [select id from Contact where FirstName = 'Test Contact'];
        Account acct =  [select id from Account limit 1];
        MUSW__Permit2__c testLicense = [Select Id, Application_type__c, permit_type__c,program_area__C,application_method__C, MUSW__Account__c, Business_License__c 
                                         from MUSW__Permit2__c 
                                         limit 1];
        
        ApplicationForSObjectConfig.PermitConfig obj = new ApplicationForSObjectConfig.PermitConfig();
        obj.getContactRelationship();
        obj.createInstance();
        obj.getObjectName();
        obj.getCurrentRecordWhereClause();
        obj.getFeeRequirementWhereClause('1234');
        obj.setPageTitle();
        obj.getQuestionObjectLookup();
        obj.getAttachmentObjectLookup();
        obj.getStatusField();
        
        Newsfeed__c news = new Newsfeed__c ();
        news.Program_Area__c =testLicense.Program_Area__c;
        news.Permit_Type__c=testLicense.Permit_Type__c;
        news.Application_Type__c=testLicense.Application_Type__c;
        news.Application_Method__c=testLicense.Application_Method__c;
        news.Instructions__c = 'Test Instructions';
        news.RecordTypeId = [select id from RecordType where name = 'Attestation Line' ].id;
        news.Show_For__c = 'Permit';
        news.External_Id__c='abec';
        insert news;
       
        PageReference pageRef = Page.Application;
        Test.setCurrentPage(pageRef);  
        ApexPages.currentPage().getParameters().put('applicationType', testlicense.Application_Type__c);
        ApexPages.currentPage().getParameters().put('programArea', testlicense.Program_Area__c);
        ApexPages.currentPage().getParameters().put('permitType', testlicense.Permit_Type__c);
        ApexPages.currentPage().getParameters().put('accountId', acct.id);
        ApexPages.currentPage().getParameters().put('contactId', contact.id);
        ApplyForSObjectCtlr ctrl = new ApplyForSObjectCtlr();
        
        ctrl.existingRecId = testLicense.id;
        ctrl.licenseBy = testlicense.Application_Method__c;

        obj.getBoardLicenseType(ctrl);
        obj.getExistingRecord(ctrl);
        obj.setFieldValues(ctrl);
        obj.setRecordTypeField(ctrl);
        obj.setBoardLicenseType(ctrl);
        obj.setLicenseId(ctrl);
        obj.getLegalText(ctrl);
        
        Newsfeed__c link = new Newsfeed__c ();
         link.Program_Area__c =testLicense.Program_Area__c;
        link.Permit_Type__c=testLicense.Permit_Type__c;
        link.Application_Type__c=testLicense.Application_Type__c;
        link.External_Id__c='absec';
        link.Application_Method__c=testLicense.Application_Method__c;
        link.RecordTypeId = [select id from RecordType where name = 'Affidavit Link'].id;
        link.Show_For__c = 'Permit';
        insert link;
        
       // obj.getAffidavitLink(ctrl);
        Test.stopTest();
    }
    
     @isTest
    static void testPermitRenewalConfigMethods(){
        Test.startTest();
        Contact contact = [select id from Contact where FirstName = 'Test Contact'];
        Account acct =  [select id from Account limit 1];
        MUSW__Permit2__c testLicense = [Select Id, Application_type__c, permit_type__c,program_area__C,application_method__C, MUSW__Account__c, Business_License__c 
                                         from MUSW__Permit2__c 
                                         limit 1];
        
        ApplicationForSObjectConfig.RenewalPermitConfig obj = new ApplicationForSObjectConfig.RenewalPermitConfig();
        obj.getContactRelationship();
        obj.createInstance();
        obj.getObjectName();
        obj.getCurrentRecordWhereClause();
        obj.getFeeRequirementWhereClause('1234');
        obj.setPageTitle();
        obj.getQuestionObjectLookup();
        obj.getAttachmentObjectLookup();
        obj.getStatusField();
        
        Newsfeed__c news = new Newsfeed__c ();
        news.Program_Area__c =testLicense.Program_Area__c;
        news.Permit_Type__c=testLicense.Permit_Type__c;
        news.Application_Type__c=testLicense.Application_Type__c;
        news.Application_Method__c=testLicense.Application_Method__c;
        news.Instructions__c = 'Test Instructions';
        news.RecordTypeId = [select id from RecordType where name = 'Attestation Line' ].id;
        news.Show_For__c = Label.Str_Permit_Renewal;
        news.External_Id__c='abec';
        insert news;
       
        PageReference pageRef = Page.Application;
        Test.setCurrentPage(pageRef);  
         ApexPages.currentPage().getParameters().put('applicationType',Label.Str_ManufacturedHomesRenewal);
        ApexPages.currentPage().getParameters().put('programArea', testlicense.Program_Area__c);
        ApexPages.currentPage().getParameters().put('renewalOrReinstatement', 'Renewal');
        ApexPages.currentPage().getParameters().put('permitType', testlicense.Permit_Type__c);
        ApexPages.currentPage().getParameters().put('accountId', acct.id);
        ApexPages.currentPage().getParameters().put('parentId', testLicense.id);
        ApplyForSObjectCtlr ctrl = new ApplyForSObjectCtlr();
        
        obj.getBoardLicenseType(ctrl);
        obj.getExistingRecord(ctrl);
        obj.setFieldValues(ctrl);
      //  obj.setRecordTypeField(ctrl);
        obj.setBoardLicenseType(ctrl);
        obj.setLicenseId(ctrl);
        obj.getLegalText(ctrl);
        
        Newsfeed__c link = new Newsfeed__c ();
         link.Program_Area__c =testLicense.Program_Area__c;
        link.Permit_Type__c=testLicense.Permit_Type__c;
        link.Application_Type__c=testLicense.Application_Type__c;
        link.External_Id__c='absec';
        link.Application_Method__c=testLicense.Application_Method__c;
        link.RecordTypeId = [select id from RecordType where name = 'Affidavit Link'].id;
        link.Show_For__c = Label.Str_Permit_Renewal;
        insert link;
        
       // obj.getAffidavitLink(ctrl);
        Test.stopTest();
    }
    
         @isTest
    static void testSRConfigMethods(){
        Test.startTest();
        Contact contact = [select id from Contact where FirstName = 'Test Contact'];
        Account acct =  [select id from Account limit 1];
        MUSW__Permit2__c testLicense = [Select Id, Application_type__c, permit_type__c,program_area__C,application_method__C, MUSW__Account__c, Business_License__c 
                                         from MUSW__Permit2__c 
                                         limit 1];
        
        ApplicationForSObjectConfig.ServiceRequestConfig obj = new ApplicationForSObjectConfig.ServiceRequestConfig();
        obj.getContactRelationship();
        obj.createInstance();
        obj.getObjectName();
        obj.getCurrentRecordWhereClause();
        obj.getFeeRequirementWhereClause('1234');
        obj.setPageTitle();
        obj.getQuestionObjectLookup();
        obj.getAttachmentObjectLookup();
        obj.getStatusField();
        
        PageReference pageRef = Page.Application;
        Test.setCurrentPage(pageRef);  
         ApexPages.currentPage().getParameters().put('applicationType',Label.STR_Service_Request);
        ApexPages.currentPage().getParameters().put('credential', testlicense.Program_Area__c);
        ApexPages.currentPage().getParameters().put('credentialType', testlicense.Permit_Type__c);
        ApexPages.currentPage().getParameters().put('srType', 'Change Name');
        ApexPages.currentPage().getParameters().put('parentId', testLicense.id);
        ApplyForSObjectCtlr ctrl = new ApplyForSObjectCtlr();
        obj.getBoardLicenseType(ctrl);
        obj.getExistingRecord(ctrl);
        obj.setFieldValues(ctrl);
        obj.setRecordTypeField(ctrl);
        obj.setBoardLicenseType(ctrl);
        obj.setLicenseId(ctrl);
        obj.getLegalText(ctrl);
        
        obj.getAffidavitLink(ctrl);
        Test.stopTest();
    }
      
}