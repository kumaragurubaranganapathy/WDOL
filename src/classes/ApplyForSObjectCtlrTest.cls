@isTest(seeAllData = false)
public class ApplyForSObjectCtlrTest {
    
    private static String licenseId;
    private static String permitId;
    private static String accountId;
    private static String contactId;
    private static string busaccountid;
    private static string buspermitId;
    
    // data set up
    @testsetup static void setupData() {
        // create acct
        List<Account> lstAccounts = new List<Account>();
        Account acc = CreateTestDataUtility.createAccount();
        lstAccounts.add(acc);
        Account acc1 = CreateTestDataUtility.createCitizenAccount()   ; 
        lstAccounts.add(acc1);
        Account acc2= CreateTestDataUtility.createBusinessAccount();
        lstAccounts.add(acc2);
        Database.insert(lstAccounts);
        accountId = acc.Id;
        busaccountid=acc2.id;
        Contact c = CreateTestDataUtility.createContact(acc.id);
        Date myDate = Date.newInstance(1960, 2, 17);
        c.BirthDate = myDate;
        c.Served_in_Military__c = 'No';
        Database.insert(c);     
        contactId = c.Id;
        MUSW__License2__c l = CreateTestDataUtility.createLicense(acc.Id,C.ID); 
        insert l;
        licenseId=l.id;
        
        Account businessaccount=CreateTestDataUtility.createBusinessAccount();
        insert businessaccount;
        busaccountid=businessaccount.id;
        MUSW__Account_Contact__c accountcontact=CreateTestDataUtility.createAccountContact(busaccountid,contactId);
        insert accountcontact;
        
        MUSW__permit2__c p = CreateTestDataUtility.createPermit(accountId,c.Id); 
        insert p;
        permitId=p.id;
        
        
    }
    
    
    @isTest
    public static void testCreateRecord() {
/*        Global_Settings__c gs= new Global_Settings__c(SetupOwnerId=UserInfo.getUserId(), Disable_Triggers__c=true);
        insert gs;
        setupData();
        User u1 = CreateTestDataUtility.createCommunityPlusUser(contactId);           
        Database.insert(u1);
        String credentialType = 'Dwelling Contractor';
        String credential = 'Dwelling Contractor';
        string applicationType=   'Trades Credential';
        CreateTestDataUtility.createPageDefinition(credential, credentialType, credential,applicationType);
        Application_Page__c newPage = [Select id, name from Application_Page__c where Name =: credential];
        System.assertNotEquals(null, newPage);
        CreateTestDataUtility.createQuestionsForLicense( applicationType,  credentialType, credential, 'General Application');
        System.runAs(u1){
            System.debug('--->Running as community user');
            //************************* 1. Test creating a LICENSE record *************************
            PageReference pageRef = Page.Application;
                    Account busacc=CreateTestDataUtility.createBusinessAccount();
        insert busacc;
            
            Test.setCurrentPage(pageRef);   
            //set board and lic type parameters
            ApexPages.currentPage().getParameters().put('applicationType', applicationType);
            ApexPages.currentPage().getParameters().put('credential', credential);
            ApexPages.currentPage().getParameters().put('credentialType', credentialtype);
            ApexPages.currentPage().getParameters().put('applicationMethod', 'General Application');  
            ApexPages.currentPage().getParameters().put('accountId', busacc.Id);
            MUSW__Master_Submission_List__c backgroundSubmission=CreateTestDataUtility.createLicenseSubmissionList( applicationType,  credentialType,  credential,  'General Application',  'MUSW__License2__c', 'Softcopy: To be Uploaded', 'Credential') ;
            insert backgroundSubmission;
            ApplyForSObjectCtlr con = new ApplyForSObjectCtlr();
            con.licenseGlobalData.accountid= busacc.Id;
            con.licenseGlobalData.contactId = contactId;       
            con.currentSection = 1;
            con.nextSection = 2;
            con.lic.put('AttestationFullName__c', '12345');
            con.contactObj.Birth_State_Province__c = 'Colorado';
            con.contactObj.Birth_City__c = 'Denver';
            con.contactObj.Phone = '9982439457';
            con.contactObj.Spouse_Served_in_the_Military__c = 'No';
            System.assertEquals(1, con.currentSection);
            System.assertNotEquals(null, con.service);
            Test.startTest();
            con.saveRecord();
            List<Answer__C> answers = new List<Answer__C>();
            For(Question__c ques :[Select external_id__c from question__c])
            {
                Answer__C a=new Answer__C();
                a.License__c=con.lic.id;
                a.Answer_Text__c='Yes';
                a.External_id_of_Question__c=ques.external_id__c;
                answers.add(a);
            }
            insert answers;
            MUSW__Submission__c testatt= CreateTestDataUtility.createSubmission();
            testatt.MUSW__License2__c=con.lic.id;
            testatt.LicenseQuestionKey__c=con.lic.id+backgroundSubmission.External_Id__c;
            insert testatt;
            licenseId = con.lic.id;
            License_Verification__c lvf = new License_Verification__c();
            lvf.Credential_Number__c='Some number';
            lvf.Contact__c = con.contactId;
            lvf.License__c=con.lic.id;
            lvf.Expiration_Date__c=System.today();
            insert lvf;
            Employment_History__c emph = new Employment_History__c();
            emph.Start_Date__c= System.today();
            emph.License__c=con.lic.id;
            insert emph;
            pageRef = Page.Application;
            ApexPages.currentPage().getParameters().put('applicationType', applicationType);
            ApexPages.currentPage().getParameters().put('pid', licenseId);
            con = new ApplyForSObjectCtlr();
            con.lic.put('AttestationFullName__c', '54321'); 
            con.currentSection = 3;
            con.nextSection = 3;
            con.getPrintSections();
            con.lic.put('Section_Number__c', 99);   
            con.quickSave();
            
            con.submitrecord();
            System.debug( '---> Current lic record: ' + con.getCurrentRecordSerialized() );      
            Test.stopTest();
        }
*/    }
    
    @isTest
    public static void testCreateLicRecord() {
        Global_Settings__c gs= new Global_Settings__c(SetupOwnerId=UserInfo.getUserId(), Disable_Triggers__c=true);
        insert gs;
        setupData();
        User u1 = CreateTestDataUtility.createCommunityTestUser(contactId);           
        Database.insert(u1);
        String credentialType = 'Manufactured Homes Credential';
        String credential = 'Manufactured Homes Installer';
        string applicationType=   'Manufactured Homes';
        CreateTestDataUtility.createPageDefinition(credential, credentialType, credential,applicationType);
        CreateTestDataUtility.createQuestionsForLicense( applicationType,  credentialType, credential, 'General Application');
        Application_Page__c newPage = [Select id, name from Application_Page__c where Name =: credential];
        System.assertNotEquals(null, newPage);
        
        System.runAs(u1){
            System.debug('--->Running as community user');
            //************************* 1. Test creating a LICENSE record *************************
            PageReference pageRef = Page.Application;
            Test.setCurrentPage(pageRef);   
            //set board and lic type parameters
            ApexPages.currentPage().getParameters().put('pid', licenseId); 
            ApexPages.currentPage().getParameters().put('applicationType', applicationType); 
            ApplyForSObjectCtlr con = new ApplyForSObjectCtlr();
            con.licenseGlobalData.contactId = contactId;       
            con.currentSection = 1;
            con.nextSection = 2;
            con.lic.put('AttestationFullName__c', '12345');
            System.assertEquals(1, con.currentSection);
            System.assertNotEquals(null, con.service);
            Test.startTest();
            con.saveRecord();
            List<Answer__C> answers = new List<Answer__C>();
            For(Question__c ques :[Select external_id__c from question__c])
            {
                Answer__C a=new Answer__C();
                a.License__c=con.lic.id;
                a.Answer_Text__c=null;
                a.External_id_of_Question__c=ques.external_id__c;
                answers.add(a);
            }
            insert answers;
            licenseId = con.lic.id;
            License_Verification__c lvf = new License_Verification__c();
            lvf.Credential_Number__c='Some number';
            lvf.Contact__c = con.contactId;
            lvf.License__c=con.lic.id;
            lvf.Expiration_Date__c=System.today();
            insert lvf;
            Affiliation__c coaffHistObject = new Affiliation__c();
            coaffHistObject.RecordTypeId=Utilities.getRecordTypeForName(Label.API_Affiliation,'Manufactured Homes Titling Affiliation');
            coaffHistObject.Credential__c=con.lic.id;
            insert coaffHistObject;
            Affiliation__c dacaffHistObject = new Affiliation__c();
            dacaffHistObject.RecordTypeId=Utilities.getRecordTypeForName(Label.API_Affiliation,'Delegated Agent Affiliation'); 
            dacaffHistObject.Credential__c=con.lic.id;
            insert dacaffHistObject;
            Education_History__c edu = new Education_History__c();
            edu.License__c=con.lic.id;
            insert edu;
            MUSW__Parcel__c parc = new MUSW__Parcel__c();
            parc.MUSW__State__c='WI';
            parc.MUSW__Street2__c='location';
            parc.Country__c='United States';
            parc.Status__c=Label.ST_Active;
            insert parc;
            insert CreateTestDataUtility.createLicenseParcel(null, con.lic.id, parc.Id, true, false);
            pageRef = Page.Application;
            ApexPages.currentPage().getParameters().put('applicationType', applicationType);
            ApexPages.currentPage().getParameters().put('pid', licenseId);
            con = new ApplyForSObjectCtlr();
            con.lic.put('AttestationFullName__c', '54321'); 
            con.currentSection = 3;
            con.nextSection = 3;
            con.getsections();
            con.licenseQuickSave();
            con.saveToPdf();
            con.getPrintSections();
            con.quickSave();
            con.lic.put('Section_Number__c', 99);     
            update con.lic;
            con.submitrecord();
            System.debug( '---> Current lic record: ' + con.getCurrentRecordSerialized() );      
            Test.stopTest();
        }
    }
    
    @isTest
    public static void testCreateLicRenewalRecord() {
        Global_Settings__c gs= new Global_Settings__c(SetupOwnerId=UserInfo.getUserId(), Disable_Triggers__c=true);
        insert gs;
        setupData();
        User u1 = CreateTestDataUtility.createCommunityTestUser(contactId);           
        Database.insert(u1);
        String credentialType = 'Manufactured Homes Credential';
        String credential = 'Manufactured Homes Installer';
        string applicationType=   'Manufactured Homes';
        MUSW__License2__c License = [Select Id, Application_type__c, credential__c,credential_type__C,application_method__C, MUSW__Type__c, MUSW__Primary_Licensee__c, Business_License__c 
                                     from MUSW__License2__c 
                                     limit 1];
        Renewal_Application__c renewal = new Renewal_Application__c();
        renewal.Credential_Type__c=license.Credential_Type__c;
        renewal.Credential__c=license.Credential__c;
        renewal.Applicant__c = contactid;    
        renewal.Licensee__c = accountId;
        renewal.License__c=license.Id;
        renewal.Renewal_Reinstatement_Type__c = Label.RNT_Renewal;
        insert renewal;
        CreateTestDataUtility.createPageDefinition(credential, credentialType, credential,applicationType);
        Application_Page__c newPage = [Select id, name from Application_Page__c where Name =: credential];
        System.assertNotEquals(null, newPage);
        
        System.runAs(u1){
            System.debug('--->Running as community user');
            //************************* 1. Test creating a LICENSE record *************************
            PageReference pageRef = Page.Application;
            Test.setCurrentPage(pageRef);   
            //set board and lic type parameters
            ApexPages.currentPage().getParameters().put('applicationType','Renewal');
            ApexPages.currentPage().getParameters().put('applicationMethod',License.Application_Method__c);
            ApexPages.currentPage().getParameters().put('credentialType', License.Credential_Type__c);
            ApexPages.currentPage().getParameters().put('renewalOrReinstatement', 'Renewal');
            ApexPages.currentPage().getParameters().put('credential', License.Credential__c);
            ApexPages.currentPage().getParameters().put('accountId', accountid);
            ApexPages.currentPage().getParameters().put('parentId', License.id);
            ApexPages.currentPage().getParameters().put('pId', renewal.id);
            
            ApplyForSObjectCtlr con = new ApplyForSObjectCtlr();
            con.parentId = License.id;
            string parentid=licenseId;
            con.licenseGlobalData.contactId = contactId;       
            con.currentSection = 1;
            con.nextSection = 2;
            con.lic.put('AttestationFullName__c', '12345');
            System.assertEquals(1, con.currentSection);
            System.assertNotEquals(null, con.service);
            Test.startTest();
            con.saveRecord();
            licenseId = con.lic.id;
            con = new ApplyForSObjectCtlr();
            con.lic.put('AttestationFullName__c', '54321'); 
            con.currentSection = 3;
            con.nextSection = 3;
            con.getsections();
            con.licenseQuickSave();
            con.saveToPdf();
            con.getPrintSections();
            con.quickSave();
            con.lic.put('Section_Number__c', 99);     
            update con.lic;
            System.debug( '---> Current lic record: ' + con.getCurrentRecordSerialized() );      
            Test.stopTest();
        }
    }
    
    
    @isTest
    public static void testCreatePermitRenewalRecord() {
 /*       Global_Settings__c gs= new Global_Settings__c(SetupOwnerId=UserInfo.getUserId(), Disable_Triggers__c=true);
        insert gs;
        setupData();
        User u1 = CreateTestDataUtility.createCommunityPlusUser(contactId);          
        Database.insert(u1);
        String permittype ='Manufactured Homes Community Permit';
        String programarea = 'Manufactured Homes Communities';
        string applicationType=  Label.Str_ManufacturedHomesRenewal;
        CreateTestDataUtility.createPageDefinitionPermit(permittype, programarea, permittype,'Manufactured Homes Communities');
        Application_Page__c newPage = [Select id, name from Application_Page__c where Name =: permittype];
        System.assertNotEquals(null, newPage);
        
        System.runAs(u1){
                    Account busacc= CreateTestDataUtility.createBusinessAccount();
            insert busacc;
            Musw__permit2__C  p = CreateTestDataUtility.createPermitMHC(busacc.Id,contactId); 
            insert p;
            buspermitId=p.id;
            System.debug('--->Running as community user');
            //************************* 1. Test creating a LICENSE record *************************
            PageReference pageRef = Page.Application;
            Test.setCurrentPage(pageRef);   
            //set board and lic type parameters
            //
            ApexPages.currentPage().getParameters().put('applicationType', Label.Str_ManufacturedHomesRenewal);
            ApexPages.currentPage().getParameters().put('permittype', permittype);
            ApexPages.currentPage().getParameters().put('programarea', programarea);   
            ApexPages.currentPage().getParameters().put('renewalOrReinstatement', 'Renewal');
            ApexPages.currentPage().getParameters().put('accountId', busaccountid);
            ApexPages.currentPage().getParameters().put('parentId', buspermitId);
            //  ApexPages.currentPage().getParameters().put('pid', renewal.id);
            
            ApplyForSObjectCtlr con = new ApplyForSObjectCtlr();
            con.parentId = buspermitId;
            string parentid=licenseId;
            con.licenseGlobalData.accountid= busaccountid;
            con.licenseGlobalData.contactId = contactId;       
            con.currentSection = 1;
            con.nextSection = 2;
            con.lic.put('AttestationFullName__c', '12345');
            System.assertEquals(1, con.currentSection);
            System.assertNotEquals(null, con.service);
            Test.startTest();
            con.saveRecord();
            licenseId = con.lic.id;
            con.lic.put('AttestationFullName__c', '54321'); 
            con.currentSection = 3;
            con.nextSection = 3;
            con.getsections();
            con.licenseQuickSave();
            con.saveToPdf();
            con.getPrintSections();
            con.quickSave();
            con.lic.put('Section_Number__c', 99);     
            con.submitrecord();
            System.debug( '---> Current lic record: ' + con.getCurrentRecordSerialized() );      
            Test.stopTest();
        }
 */   }
    
    
    @isTest
    public static void testCreatePermitRecord1() {
        Global_Settings__c gs= new Global_Settings__c(SetupOwnerId=UserInfo.getUserId(), Disable_Triggers__c=true);
        insert gs;
        
        
        setupData();
        User u1 = CreateTestDataUtility.createCommunityTestUser(contactId);           
        Database.insert(u1);
        String permittype ='POWTS Petition for Variance';
        String programarea = 'POWTS';
        string applicationType=  'Plan Review';
        CreateTestDataUtility.createPageDefinitionPermit(permittype, programarea, permittype,applicationType);
        Application_Page__c newPage = [Select id, name from Application_Page__c where Name =: permittype];
        System.assertNotEquals(null, newPage);
        
        System.runAs(u1){
            System.debug('--->Running as community user');
            //************************* 1. Test creating a LICENSE record *************************
            PageReference pageRef = Page.Application;
            Test.setCurrentPage(pageRef);   
            //set board and lic type parameters
            ApexPages.currentPage().getParameters().put('applicationType', applicationType);
            ApexPages.currentPage().getParameters().put('permittype', permittype);
            ApexPages.currentPage().getParameters().put('programarea', programarea);   
            ApexPages.currentPage().getParameters().put('pId', permitId);   
            ApplyForSObjectCtlr con = new ApplyForSObjectCtlr();
            con.licenseGlobalData.contactId = contactId;       
            con.currentSection = 1;
            con.nextSection = 2;
            System.assertEquals(1, con.currentSection);
            System.assertNotEquals(null, con.service);
            Test.startTest();
            con.saveRecord();
            licenseId = con.lic.id;
            Musw__Project2__c proj= new Musw__Project2__c ();
            proj.Name = 'Test';
            proj.MUSW__Description__c ='Test';
            proj.County_Name__c = 'Adams';
            proj.Municipality_Type__c ='Test';
            proj.Municipality_Name__c = 'Test';
            MUSW__Project_Parcel__c testtesting=  ProjectCreation.createproject(proj,licenseId, 'location',null);
             List<MUSW__Project2__c> projects = ProjectCreation.getSite(proj.Name);
            Affiliation__c aff = new Affiliation__c();
            aff.RecordTypeId=Utilities.getRecordTypeForName(Label.API_Affiliation,'POWTS Affiliation');
            aff.Permit_Plan_Review__c=licenseId;
            insert aff;
            MUSW__Parcel__c parc = new MUSW__Parcel__c();
            parc.MUSW__State__c='WI';
            parc.MUSW__Street2__c='location';
            parc.Country__c='United States';
            parc.Status__c=Label.ST_Active;
            insert parc;
            MUSW__Permit_Parcel__c permitParcel = new MUSW__Permit_Parcel__c(
                MUSW__Permit2__c = con.licenseGlobalData.permitId,
                MUSW__Parcel__c = parc.Id,
                Mailing__c = true);
            insert permitparcel;
            con.existingRecId=con.lic.id;
            pageRef = Page.Application;
            ApexPages.currentPage().getParameters().put('applicationType', applicationType);
            ApexPages.currentPage().getParameters().put('pid', licenseId);
            con = new ApplyForSObjectCtlr();
            con.lic.put('AttestationFullName__c', '54321'); 
            con.currentSection = 3;
            con.nextSection = 3;
            con.getsections();
            con.licenseQuickSave();
            con.saveToPdf();
            con.getPrintSections();
            con.quickSave();
            con.lic.put('Section_Number__c', 99);     
            update con.lic;
            con.submitrecord();
            System.debug( '---> Current lic record: ' + con.getCurrentRecordSerialized() );      
            Test.stopTest();
        }
    }
    
    
      @isTest
    public static void testCreatePermitRecord() {
        Global_Settings__c gs= new Global_Settings__c(SetupOwnerId=UserInfo.getUserId(), Disable_Triggers__c=true);
        insert gs;
        
        
        setupData();
        User u1 = CreateTestDataUtility.createCommunityTestUser(contactId);           
        Database.insert(u1);
        String permittype ='POWTS Petition for Variance';
        String programarea = 'POWTS';
        string applicationType=  'Plan Review';
        CreateTestDataUtility.createPageDefinitionPermit(permittype, programarea, permittype,applicationType);
        Application_Page__c newPage = [Select id, name from Application_Page__c where Name =: permittype];
        System.assertNotEquals(null, newPage);
        
        System.runAs(u1){
            System.debug('--->Running as community user');
            //************************* 1. Test creating a LICENSE record *************************
            PageReference pageRef = Page.Application;
            Test.setCurrentPage(pageRef);   
            //set board and lic type parameters
            ApexPages.currentPage().getParameters().put('applicationType', applicationType);
            ApexPages.currentPage().getParameters().put('permittype', permittype);
            ApexPages.currentPage().getParameters().put('programarea', programarea);   
            ApexPages.currentPage().getParameters().put('pId', permitId);   
            ApplyForSObjectCtlr con = new ApplyForSObjectCtlr();
            con.licenseGlobalData.contactId = contactId;       
            con.currentSection = 1;
            con.nextSection = 2;
            System.assertEquals(1, con.currentSection);
            System.assertNotEquals(null, con.service);
            Test.startTest();
            con.saveRecord();
            licenseId = con.lic.id;
            Musw__Project2__c proj= new Musw__Project2__c ();
            proj.Name = 'Test';
            proj.MUSW__Description__c ='Test';
            proj.County_Name__c = 'Adams';
            proj.Municipality_Type__c ='Test';
            proj.Municipality_Name__c = 'Test';
            MUSW__Project_Parcel__c testtesting=  ProjectCreation.createproject(proj,licenseId, 'location',null);
            for (PageDefService.SectionObj sectionObj : con.service.PageObj.sectionObjMap.values()) {
                Component.Apex.Detail subDetail = new Component.Apex.Detail();
                
                // Sub-Section builder
                for (PageDefService.SubSectionObj subSectionObj : sectionObj.subSectionObjMap.values()) {
                    // If fieldset
                    if (subSectionObj.sType == 'Fieldset') {
                        Component.c.PageSubSectionComp customComp =  ApplyforSobjectHelper.fieldSetComponentCreator(subSectionObj,  con.accountObj,new contact(), con.lic, con.Applicationtype,  con.existingRecId, con.parentid) ; 
                        subDetail.childComponents.add(customComp);
                    }
                }
            }
            Affiliation__c aff = new Affiliation__c();
            aff.RecordTypeId=Utilities.getRecordTypeForName(Label.API_Affiliation,'POWTS Affiliation');
            aff.Permit_Plan_Review__c=licenseId;
            insert aff;
            MUSW__Parcel__c parc = new MUSW__Parcel__c();
            parc.MUSW__State__c='WI';
            parc.MUSW__Street2__c='location';
            parc.Country__c='United States';
            parc.Status__c=Label.ST_Active;
            insert parc;
            MUSW__Permit_Parcel__c permitParcel = new MUSW__Permit_Parcel__c(
                MUSW__Permit2__c = con.licenseGlobalData.permitId,
                MUSW__Parcel__c = parc.Id,
                Mailing__c = true);
            insert permitparcel;
            con.existingRecId=con.lic.id;
            pageRef = Page.Application;
            ApexPages.currentPage().getParameters().put('applicationType', applicationType);
            ApexPages.currentPage().getParameters().put('pid', licenseId);
            con = new ApplyForSObjectCtlr();
            con.lic.put('AttestationFullName__c', '54321'); 
            con.currentSection = 3;
            con.nextSection = 3;
            con.getsections();
            con.licenseQuickSave();
            con.saveToPdf();
            con.getPrintSections();
            con.quickSave();
            con.lic.put('Section_Number__c', 99);     
            update con.lic;
            con.submitrecord();
            System.debug( '---> Current lic record: ' + con.getCurrentRecordSerialized() );      
            Test.stopTest();
        }
    }
    
    @isTest
    public static void testCreateServiceRequestRecord() {
        Global_Settings__c gs= new Global_Settings__c(SetupOwnerId=UserInfo.getUserId(), Disable_Triggers__c=true);
        insert gs;
        setupData();
        User u1 = CreateTestDataUtility.createCommunityTestUser(contactId);           
        Database.insert(u1);
        MUSW__License2__c license = new MUSW__License2__c( musw__status__c = 'Pending',                                                                                                                   
                                                          Application_Type__c = 'Manufactured Homes', 
                                                          Credential_type__c = 'Manufactured Homes Credential', 
                                                          Credential__c = 'Manufactured Homes Installer',
                                                          MUSW__Primary_Licensee__c = accountId, 
                                                          MUSW__Applicant__c = contactId);
        insert license;
        String servicetype ='Exam Re-Application';
        CreateTestDataUtility.createPageDefinitionServiceRequest(servicetype,servicetype);
        Application_Page__c newPage = [Select id, name from Application_Page__c where Name =: servicetype];
        System.assertNotEquals(null, newPage);
        
        System.runAs(u1){
            System.debug('--->Running as community user');
            //************************* 1. Test creating a LICENSE record *************************
            PageReference pageRef = Page.Application;
            Test.setCurrentPage(pageRef);   
            //set board and lic type parameters
            Musw__license2__c lic = [Select id from Musw__license2__c LIMIT 1 ];
            ApexPages.currentPage().getParameters().put('serviceRequestType', servicetype);
            ApexPages.currentPage().getParameters().put('applicationtype', Label.Str_Service_Request);
            ApexPages.currentPage().getParameters().put('parentid', lic.Id);   
            ApexPages.currentPage().getParameters().put('credential', 'Manufactured Homes Installer');   
            ApexPages.currentPage().getParameters().put('credentialtype', 'Manufactured Homes Credential');   
            ApplyForSObjectCtlr con = new ApplyForSObjectCtlr();
            con.licenseGlobalData.contactId = contactId;       
            con.currentSection = 1;
            con.nextSection = 2;
            System.assertEquals(1, con.currentSection);
            System.assertNotEquals(null, con.service);
            Test.startTest();
            licenseId = con.lic.id;
            pageRef = Page.Application;
            ApexPages.currentPage().getParameters().put('serviceRequestType', servicetype);
            ApexPages.currentPage().getParameters().put('parentid', licenseId);
            ApexPages.currentPage().getParameters().put('applicationtype', Label.Str_Service_Request);
            ApexPages.currentPage().getParameters().put('credential', 'Manufactured Homes Installer');   
            ApexPages.currentPage().getParameters().put('credentialtype', 'Manufactured Homes Credential');   
            con = new ApplyForSObjectCtlr();
            con.getsections();
            con.quickSave();
            con.submitrecord();
            System.debug( '---> Current lic record: ' + con.getCurrentRecordSerialized() );      
            Test.stopTest();
        }
    }
    
    @isTest
    public static void testApplicationHelper() {
        
        Component.Apex.OutputText a= ApplyforSobjectHelper.createprintcomponentdate('abc',null);
    }
    
    @isTest
    public static void testCreateLicReinstatementRecord() {
        Global_Settings__c gs= new Global_Settings__c(SetupOwnerId=UserInfo.getUserId(), Disable_Triggers__c=true);
        insert gs;
        setupData();
        User u1 = CreateTestDataUtility.createCommunityTestUser(contactId);           
        Database.insert(u1);
        String credentialType = 'Manufactured Homes Credential';
        String credential = 'Manufactured Homes Installer';
        string applicationType=   'Manufactured Homes';
        MUSW__License2__c License = [Select Id, Application_type__c, credential__c,credential_type__C,application_method__C, MUSW__Type__c, MUSW__Primary_Licensee__c, Business_License__c 
                                     from MUSW__License2__c 
                                     limit 1];
        Renewal_Application__c renewal = new Renewal_Application__c();
        renewal.Credential_Type__c=license.Credential_Type__c;
        renewal.Credential__c=license.Credential__c;
        renewal.Applicant__c = contactid;    
        renewal.Licensee__c = accountId;
        renewal.License__c=license.Id;
        renewal.Renewal_Reinstatement_Type__c = Label.RNT_Reinstatement;
        insert renewal;
        CreateTestDataUtility.createPageDefinition(credential, credentialType, credential,applicationType);
        Application_Page__c newPage = [Select id, name from Application_Page__c where Name =: credential];
        System.assertNotEquals(null, newPage);
        
        System.runAs(u1){
            System.debug('--->Running as community user');
            //************************* 1. Test creating a LICENSE record *************************
            PageReference pageRef = Page.Application;
            Test.setCurrentPage(pageRef);   
            //set board and lic type parameters
            ApexPages.currentPage().getParameters().put('applicationType',Label.RNT_Reinstatement);
            ApexPages.currentPage().getParameters().put('applicationMethod',License.Application_Method__c);
            ApexPages.currentPage().getParameters().put('credentialType', License.Credential_Type__c);
            ApexPages.currentPage().getParameters().put('renewalOrReinstatement', Label.RNT_Reinstatement);
            ApexPages.currentPage().getParameters().put('credential', License.Credential__c);
            ApexPages.currentPage().getParameters().put('accountId', accountid);
            ApexPages.currentPage().getParameters().put('parentId', License.id);
            ApexPages.currentPage().getParameters().put('pId', renewal.id);
            
            ApplyForSObjectCtlr con = new ApplyForSObjectCtlr();
            con.parentId = License.id;
            string parentid=licenseId;
            con.licenseGlobalData.contactId = contactId;       
            con.currentSection = 1;
            con.nextSection = 2;
            con.lic.put('AttestationFullName__c', '12345');
            System.assertEquals(1, con.currentSection);
            System.assertNotEquals(null, con.service);
            Test.startTest();
            con.saveRecord();
            licenseId = con.lic.id;
            con = new ApplyForSObjectCtlr();
            con.lic.put('AttestationFullName__c', '54321'); 
            con.currentSection = 3;
            con.nextSection = 3;
            con.getsections();
            con.licenseQuickSave();
            con.saveToPdf();
            con.getPrintSections();
            con.quickSave();
            con.lic.put('Section_Number__c', 99);     
            update con.lic;
            con.submitrecord();
            System.debug( '---> Current lic record: ' + con.getCurrentRecordSerialized() );      
            Test.stopTest();
        }
    }
}