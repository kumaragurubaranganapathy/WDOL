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
        lic1 .Polaris_DHP__c =true;
        update lic1 ;
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
        
        //SELECT  Renewal_Status__c, ,Renewal_Reinstatement_Type__c,License__r.MUSW__Applicant__r.Email,License__r.MUSW__Applicant__c,License__r.CreatedById,License__r.Name FROM Renewal_Application__c WHERE License__c IN :Trigger.newMap.keySet() AND Renewal_Reinstatement_Type__c='Renewal']
        Renewal_Application__c mock = new Renewal_Application__c();
        mock.License__c=lic1.id;
        mock.Renewal_Status__c='Submitted';
        mock.Renewal_Reinstatement_Type__c='Renewal';
        mock.Application_Type__c = 'Architects';
        mock.Credential_Type__c = 'Architect';
        mock.Credential__c = 'Architect';
        insert mock;
        
        
        Account account = new Account(Name= DOL_AppConstants.NULL_EMPTY_STRING + 'Test Accounttt',UBI_Number__c ='79068467rr');
        insert account;
        Contact c = new Contact(LastName= DOL_AppConstants.NULL_EMPTY_STRING + 'Test Contact44tt',FirstName= DOL_AppConstants.NULL_EMPTY_STRING + 'BasicGov1', Email= DOL_AppConstants.NULL_EMPTY_STRING + 'test@basicgov.com',Account=account
                                ,Unique_ID_To_Provide__c='No_SSN_or_ITIN');
        insert c;
        
       // Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        MUSW__License2__c lic2 = DOL_TestDataFactory.createLicenseIndividual(LicRecTypeId1, c.Id, 'Appraisers - Real Estate', 'Certified General Appraiser', 'General Application');
        
        MUSW__Review__c review = new MUSW__Review__c();
        review.MUSW__Status__c ='Pending';
        review.License__c  = lic2.id;
        review.Review_Type__c='General Application';
        insert review;
        
        Task tsk = new Task();
        tsk.WhatId = lic2.id;
        tsk.Type = 'Payment Reminder';
        insert tsk;
        
        
            
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
    
    @isTest
    
    public static void testautoRenewReinstatementMethod(){
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('User Account').getRecordTypeId();
        Id ConRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        Id LicRecTypeId = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        Id renewalRecordTypeId = Schema.SObjectType.Renewal_Application__c.getRecordTypeInfosByDeveloperName().get('Individual').getRecordTypeId();
        Id quesRecTypeId = Schema.SObjectType.Question__c.getRecordTypeInfosByName().get('License Information').getRecordTypeId();
        
        
        
        Test.startTest();
        //Insert Account
        Account acc = DOL_TestDataFactory.createAccount(AccRecTypeId); 
        
        //Insert Contact
        Contact con = DOL_TestDataFactory.createContact(ConRecTypeId,acc.id);
        
        //Insert License
        MUSW__License2__c license = DOL_TestDataFactory.createLicense(LicRecTypeId, acc.Id, 'Architects', 'Architect', 'General Application');
        license.MUSW__Applicant__c = con.Id;
        license.MUSW__Expiration_Date__c = System.today()+10;
        update license;
        
        //Insert Renewal Application
        Renewal_Application__c renew = DOL_TestDataFactory.createRenewalApplication(renewalRecordTypeId, license.Id);
        renew.Renewal_Status__c = 'Pending Payment';
        update renew;
        
        //Insert Question
        Question__c ques = new Question__c();
        ques.Question_Body__c = 'Total number of full months of experience in real estate appraising';
        ques.Data_Type__c = 'Yes_No';
        ques.Parent_Object_API_Name__c = 'Renewal_Application__c';
        ques.RecordTypeId = quesRecTypeId;
        ques.Application_Type__c = 'Notary Public';
        ques.External_Id__c = 'abc123';
        ques.QuestionFieldAPI__c = 'Name';
        ques.Section__c = 'Legal Background Questions';
        insert ques;
        
        //Insert Answer
        BGCK__Answer__c ans = new BGCK__Answer__c();
        ans.Answer_Text__c = 'No';
        ans.QuestionDOL__c = ques.Id;
        ans.Renewal_Reinstatement_Application__c = renew.id;
        insert ans;
        
        //Insert Answer
        BGCK__Answer__c ans1 = new BGCK__Answer__c();
        ans1.Answer_Text__c = 'No';
        ans1.QuestionDOL__c = ques.Id;
        ans1.Renewal_Reinstatement_Application__c = renew.id; 
        insert ans1;
        
        
        
        
        
        Test.stopTest();
    }
    
    
    @isTest
    public static void testtrigger12(){
        Renewal_Application__c reApp = new Renewal_Application__c();
        reApp.Application_Type__c = 'Architects';
        reApp.Credential_Type__c = 'Architect';
        reApp.Credential__c = 'Architect';
        reApp.Renewal_Reinstatement_Type__c = 'Renewal';
        reApp.Renewal_Status__c = 'Draft';
        //reApp.License__c = '1234';
        //reApp.Permit__c = permitId;
        reApp.Policy_Amount__c =100.00;
        reApp.Advertising_Fees__c =100.00;
        reApp.Interval_fees__c =100.00;
        reApp.Initial_Contracts__c =1;
        reApp.Timeshare_Projects__c =1; 
        reApp.Apartment_Units__c =1;
        reApp.Camping_Resorts__c =1;
        insert reApp;
        
    }
    
    
    
    @isTest
    public static void testrigger10(){
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        system.runAs(thisUser){
            Holiday h = new Holiday();
            h.ActivityDate = system.today()+1;
            h.name = 'test holiday';
            insert h;
        }
        
        Id reviewRT = Schema.SObjectType.MUSW__Review__c.getRecordTypeInfosByName().get('License Review').getRecordTypeId();
        MUSW__Review__c rev = new MUSW__Review__c();
        rev.RecordTypeId = reviewRT;
        rev.Start_Date__c = system.now();
        rev.MUSW__Status__c='Approved';
        rev.Review_Type__c= 'General Application';
        rev.MUSW__Completed_DateTime__c = system.now()+10;
        insert rev;
        /*ReviewCompletionTimeComputation rc = new ReviewCompletionTimeComputation();
        
        
        Decimal dec = rc.ReviewCompletionTimeComputation(rev);*/ 
        
    }
    
    
    private static testMethod void testafterMethod() {
        User user1;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) {
            Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
            Account accObj = DOL_TestDataFactory.createAccount(accRecordTypeId);
            License2TriggerHandler oHandler2 = new License2TriggerHandler();
            Id licRecordTypeId = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
            MUSW__License2__c licenseObj = DOL_TestDataFactory.createLicense(licRecordTypeId,accObj.Id,'Funerals','Embalmer Intern','General Application');
            licenseObj.MUSW__Status__c = 'Inactive';
            licenseObj.Polaris_DHP__c = true;
            update licenseObj;
            Id renRecordTypeId = Schema.SObjectType.Renewal_Application__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
            Renewal_Application__c renewalObj = createRenewalApplication(renRecordTypeId,licenseObj.Id );
            renewalObj.Renewal_Status__c = 'Generate Fee';
            renewalObj.Total_Fees__c =25.00;
            renewalObj.Total_Payments__c =25.00;
            update renewalObj;
            Renewal_Application__c renewalObj1 = DOL_TestDataFactory.createRenewalApplication(renRecordTypeId,licenseObj.Id );
            renewalObj1.Renewal_Status__c = 'Incomplete';
            update renewalObj1;
            
            
            //Create Contact
            Contact con = new Contact(LastName = DOL_AppConstants.NULL_EMPTY_STRING + 'firstConLastName', firstName = DOL_AppConstants.NULL_EMPTY_STRING + 'firstConFirstName', Email= DOL_AppConstants.NULL_EMPTY_STRING + 'firstcon@mailinator.com', 
                                      Birthdate = Date.newInstance(1947, 05, 01), AccountId = accObj.Id, Social_Security_Number_Encrypted__c = DOL_AppConstants.NULL_EMPTY_STRING + '111222333', 
                                      Duplicate_Override__c = true, Birth_Country__c = DOL_AppConstants.NULL_EMPTY_STRING + 'United States', Birth_State_Province__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Illinois', Birth_City__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Chicago', 
                                      Gender__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Male', Contact_Status__c = 'Inactive', Ethnicity__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Asian Indian', Unique_ID_To_Provide__c = 'SSN');
            insert con;
            
            try { licenseObj.Application__c = '';}
            catch(exception ex){}
            update licenseObj;
            
            
            MUSW__License2__c upgradeLicense = DOL_TestDataFactory.createLicense(licRecordTypeId,accObj.Id,'Appraisers - Real Estate','State Licensed Appraiser','General Application');
            upgradeLicense.MUSW__Primary_Licensee__c = accObj.Id;
            update upgradeLicense;
            
            Request__c reqObj = DOL_TestDataFactory.createRequest(licenseObj.Id,'Geologist','Geologist');
            reqObj.Description__c = 'Request Description';
            update reqObj;}
        //System.runAs(user1){
        License2TriggerHandler oHandler = new License2TriggerHandler();
        try{
            oHandler.onBeforeInsert();
        }catch(Exception ex){}
        try{
            oHandler.onBeforeUpdate();}catch(Exception ex){}//}
        try{
            oHandler.onAfterUpdate();
        }catch(Exception ex){}
        try{
            oHandler.onAfterInsert();
        }catch(Exception ex){}
        try{
            oHandler.onAfterDelete();
        }catch(Exception ex){}
        try{
            oHandler.onAfterUndelete();
        }catch(Exception ex){}
        try{
            oHandler.onBeforeDelete();
        }catch(Exception ex){}
        //System.debug('***Test Debug1***'+renewalObj.Total_Balance__c);
        //System.debug('***Test Debug2***'+renewalObj.Total_Fees__c);
        //System.debug('***Test Debug3***'+renewalObj.Total_Payments__c);
        
    }
    
    private static Renewal_Application__c createRenewalApplication(Id recTypeId, Id licId){
        Renewal_Application__c reApp = new Renewal_Application__c(recordTypeId = recTypeId);
        reApp.Application_Type__c = 'Architects';
        reApp.Credential_Type__c = 'Architect';
        reApp.Credential__c = 'Architect';
        reApp.Renewal_Reinstatement_Type__c = 'Renewal';
        reApp.Renewal_Status__c = 'Draft';
        reApp.License__c = licId;
        //reApp.Permit__c = permitId;
        reApp.Policy_Amount__c =100.00;
        reApp.Advertising_Fees__c =100.00;
        reApp.Interval_fees__c =100.00;
        reApp.Initial_Contracts__c =1;
        reApp.Timeshare_Projects__c =1; 
        reApp.Apartment_Units__c =1;
        reApp.Camping_Resorts__c =1;
        reApp.Renewal_Status__c = 'Generate Fee';
        insert reApp;
        return reApp;
    }
    
    @IsTest
    public static void testCreateErrorLogException(){
        DOL_CreateErrorLog_Exception.addError(new CustomException('test'),'test','test');
        DOL_CreateErrorLog_Exception.logApplicationError(new CustomException('test'),'test','test');
        DOL_CreateErrorLog_Exception.logApplicationError(new CustomException('test'));
        DOL_CreateErrorLog_Exception.logDeleteDetails('test','test','test');
    }
        @IsTest
    public static void testApproveReview(){
      Set<Id> setli = new Set<Id>();
      License2TriggerHandler lstreview = new License2TriggerHandler();
      List<Id> lstid = new List<Id>();
      List<MUSW__License2__c > lstli = [select id from MUSW__License2__c where Application_Type__c = 'Appraisers - Real Estate'];
      for(MUSW__License2__c  license : lstli) {
        setli.add(license.id);
        lstid.add(license.id);
      }
      lstreview .approveReview(setli);
        lstreview .approveReview(setli);
      Test.startTest();
      License2TriggerHandler.createReviewOnLicense(lstid );
      Test.stopTest();
        
    }
}