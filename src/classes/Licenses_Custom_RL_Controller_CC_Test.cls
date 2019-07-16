@isTest
private class Licenses_Custom_RL_Controller_CC_Test {
    
    static testMethod void LicensesContrTest(){
        Test.startTest();
        //Set up an account with the utiltiy
        Account acc = CreateTestDataUtility.createAccount();
        insert acc;
        
        //Set up and insert a contact
        Contact con = new Contact (AccountId= acc.id, Email='conemail@example.com', LastName = 'Hill');
        insert con;
        
        //Get Record Type Id from the Rcord Type
        RecordType recs = [SELECT Id, Name FROM RecordType WHERE sObjectType='MUSW__License2__c' and Name ='Universal Default License Record Type'];
        RecordType recsPermit = [SELECT Id, Name FROM RecordType WHERE sObjectType='MUSW__Permit2__c' and Name ='eSLA Portal'];
        
        //Set up and insert a new license.
        MUSW__License2__c testLicense = new MUSW__License2__c(MUSW__Applicant__c = con.id, RecordTypeId = recs.id, Application_Type__c = 'Manufactured Homes', Credential_type__c = 'Manufactured Homes Credential', Credential__c = 'Manufactured Homes Installer', Application_Method__c = 'Course Completion');
        insert testLicense; 
        
        //Set up and insert a new Permit.
        MUSW__Permit2__c testPermit = new MUSW__Permit2__c(MUSW__Applicant__c = con.id, Object_Type__c = Label.Str_Permit, RecordTypeId = recsPermit.id, Application_Type__c = 'Plan Review', Permit_Type__c = 'POWTS Petition for Variance', Program_Area__c = 'POWTS');
        insert testPermit;
        System.debug('testpermit '+testPermit);
        //Set up and insert a new PlanReview.
        MUSW__Permit2__c testPlanReview = new MUSW__Permit2__c(MUSW__Applicant__c = con.id, Object_Type__c = Label.Str_Plan_Review, RecordTypeId = recsPermit.id, Application_Type__c = 'Plan Review', Permit_Type__c = 'POWTS Petition for Variance', Program_Area__c = 'POWTS');
        insert testPlanReview;
        
        //Instantiate the Controller and pass in the contact
        Licenses_Custom_RL_Controller_CC controller = new Licenses_Custom_RL_Controller_CC (new ApexPages.StandardController(con));
        
        Test.stopTest();    
        
        //Verify state  
        System.assert (controller.lstLicense.size()>0);
    }
}