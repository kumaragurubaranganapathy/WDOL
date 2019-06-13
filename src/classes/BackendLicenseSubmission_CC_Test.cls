/**
* User Story: 124- Submission List Triggers
* Name: BackendLicenseSubmission_CC_Test
* Type: Test Class
* Description: Test Class for BackendLicenseSubmission_CC
* Date:        Developer/Company                    Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 06/19/2018   Sharad Maheshwari/Deloitte           Initial Creation
**/
@isTest
public class BackendLicenseSubmission_CC_Test {

    private static Id licenseId;    
    
    @isTest static void testLicenseBackendSubsmissionController()
    {
        Global_Settings__c globalSetting = new Global_Settings__c(Name = UserInfo.getUsername(), Disable_Triggers__c = true);
        insert globalSetting;
        //insertTestData();
        
        //Step 1 : Data Insertion
        /*Creating test Account*/
        Account acc = new Account();
        acc = CreateTestDataUtility.createAccount();
        /*Inserting test Account*/
        insert acc;
        
        /*Creating test Contact*/
        Contact con = CreateTestDataUtility.createContact(acc.Id);
        /*Inserting test Contact*/
        insert con;   
        
        /*Create Submission List records*/
        List<MUSW__Master_Submission_List__c> masterSubmissionList = new List<MUSW__Master_Submission_List__c>();
                MUSW__Master_Submission_List__c backgroundSubmission = CreateTestDataUtility.createLicenseSubmissionList ('Manufactured Homes',
                                                                                                                          'Manufactured Homes Credential', 
                                                                                                                          'Manufactured Homes Installer', 
                                                                                                                          'Course Completion', 
                                                                                                                          Label.API_License2, 
                                                                                                                          'Softcopy: To be Uploaded', 
                                                                                                                          'Credential');
                backgroundSubmission.Background_Question_Field_API_Name__c= 'Non_US_Citizen__c';
                masterSubmissionList.add(backgroundSubmission);
        		MUSW__Master_Submission_List__c backgroundSubmission2 = CreateTestDataUtility.createLicenseSubmissionList ('Manufactured Homes',
                                                                                                                          'Manufactured Homes Credential', 
                                                                                                                          'Manufactured Homes Installer', 
                                                                                                                          'Course Completion', 
                                                                                                                          Label.API_License2, 
                                                                                                                          'Softcopy: To be Uploaded', 
                                                                                                                          'Credential');
                backgroundSubmission2.Default__c = True;
                masterSubmissionList.add(backgroundSubmission2);
        		MUSW__Master_Submission_List__c backgroundSubmission3 = CreateTestDataUtility.createLicenseSubmissionList ('Manufactured Homes',
                                                                                                                          'Manufactured Homes Credential', 
                                                                                                                          'Manufactured Homes Installer', 
                                                                                                                          'Course Completion', 
                                                                                                                          Label.API_Renewal_Application, 
                                                                                                                          'Softcopy: To be Uploaded', 
                                                                                                                          'Credential Renewal');
                backgroundSubmission3.Default__c = True;
                masterSubmissionList.add(backgroundSubmission3);
        		/*MUSW__Master_Submission_List__c backgroundSubmission6 = CreateTestDataUtility.createLicenseSubmissionList ('Manufactured Homes',
                                                                                                                          'Manufactured Homes Credential', 
                                                                                                                          'Manufactured Homes Installer', 
                                                                                                                          'Course Completion', 
                                                                                                                          Label.API_Renewal_Application, 
                                                                                                                          'Softcopy: To be Uploaded', 
                                                                                                                          'Credential Reinstatement');
                backgroundSubmission3.Default__c = True;
                masterSubmissionList.add(backgroundSubmission6);
        		*/insert masterSubmissionList;
        
        /*Creating Multiple Test Licenses*/
        /*
        integer numOfLicensesToCreate = 5;
        List<MUSW__License2__c> licenseList = CreateTestDataUtility.createMultipleLicenses(numOfLicensesToCreate, 'License Type A1','License Type A2', acc.Id, con.Id);
        insert licenseList;
        
        
        
        for(integer i = 0; i < numOfLicensesToCreate; i++){
            if(math.mod(i, 2) == 0){
                licenselist[i].Non_US_Citizen__c = 'No';
                licenseList[i].MUSW__Description__c = 'a';                
            }
            licenselist[i].Non_US_Citizen__c = 'Yes';
            licenseList[i].MUSW__Description__c = 'b';                            
        }
        upsert licenseList;
        */
        
        /*Creating test License*/
        globalSetting.disable_triggers__C = false;
        upsert globalSetting;
        Musw__License2__c license = CreateTestDataUtility.createLicense(acc.Id, con.Id);
        /*Inserting test License to fire License Trigger*/
        insert license;        
        
        List<MUSW__Submission__c> submissionListCreated = [Select ID from MUSW__Submission__c where MUSW__License2__c =:license.Id];
        System.assertEquals(2, submissionListCreated.size());
        globalSetting.disable_triggers__C = true;
        upsert globalSetting;
        Test.startTest();
        
          String recId = license.Id;
          ApexPages.currentPage().getParameters().put('id', recId.substring(0,15));
          Attachment att = new Attachment(Body = Blob.valueOf('Test attachment body'), Name='test attachment', parentId = license.Id);
          insert att;
        
          BackendLicenseSubmission_CC submissionController = new BackendLicenseSubmission_CC(); 
            //Testing with license scenario 
            submissionController.isLicense = TRUE;
            submissionController.pid = license.Id;
            List<MUSW__Submission__c> lst1 = [Select Id FROM MUSW__Submission__c WHERE MUSW__License2__c=:license.Id ORDER BY Name];
        System.debug('size of submissions created '+ lst1.size());    
        //Testing file upload
        submissionController.subId = lst1[0].Id;
        submissionController.file = new Attachment(Body = Blob.valueOf('Test attachment body'), Name='test attachment', parentId = license.Id);
        submissionController.uploadFile();
		//submissionController.isRenewal = True;
        

        //Testing backend submission Update
        //submissionController.hiddenSubId = submissionController.getsubmissionList()[0].Id;
        MUSW__Submission__c submission = new MUSW__Submission__c(Name='Test Backend Submission');
        submissionController.newSubmission = submission;
        submissionController.createSubmission(); 

       
        
        //Testing Hard Copy acknowledgement
        BackendLicenseSubmission_CC.updateHardCopy(submissionController.getsubmissionList()[0].Id);

        //Testing getAttachmentList
        BackendLicenseSubmission_CC.getAttachmentList(submissionController.getsubmissionList()[0].Id);

        //Testing deletion of attachments
        List<Attachment> attList = [SELECT Id FROM Attachment WHERE parentId=:submissionController.getsubmissionList()[0].Id];
        if(!attList.isEmpty()){
            BackendLicenseSubmission_CC.deleteAttachment(attList[0].Id);
        }

        //Testing status update
        BackendLicenseSubmission_CC.updateStatus(submissionController.getsubmissionList()[0].Id, 'Approved');

        //Testing edit of submission/getting submission details with submission Id
        BackendLicenseSubmission_CC.getSubmissionDetails(submissionController.getsubmissionList()[0].Id);
        
        //Testing with License renewal scenario 
            submissionController.isLicense = FALSE;
        	submissionController.isRenewal = TRUE;
            
        
        Renewal_Application__c renewal = CreateTestDataUtility.createRenewal(license.Id, 
                                                                             license.Application_Type__c, 
                                                                             license.Credential_Type__c, 
                                                                             license.Credential__c, 
                                                                             'Incomplete', 
                                                                             'Renewal');
        insert renewal;
        
        MUSW__Submission__c submission1 = new MUSW__Submission__c(Name='Test Backend Submission1');
        submissionController.newSubmission = submission1;
        submissionController.createSubmission();
        
        //Testing with License reinstatement scenario 
        /*submissionController.isRenewal = FALSE;
        submissionController.isReinstatement = TRUE;
        
        Renewal_Application__c renewal1 = CreateTestDataUtility.createRenewal(license.Id, 
                                                                             license.Application_Type__c, 
                                                                             license.Credential_Type__c, 
                                                                             license.Credential__c, 
                                                                             'Incomplete', 
                                                                             'Reinstatement');
        insert renewal1;
        
        MUSW__Submission__c submission2 = new MUSW__Submission__c(Name='Test Backend Submission2');
        submissionController.newSubmission = submission2;
        submissionController.createSubmission();
        */
        /*
        //Testing with permit renewal scenario
        	submissionController.isPermit = FALSE; 
            submissionController.isRenewalPTO = TRUE;
        
        Renewal_Application__c renewal2 = CreateTestDataUtility.createRenewal(permit.Id, 
                                                                             permit.Application_Type__c, 
                                                                             permit.Program_Area__c, 
                                                                             permit.Permit_Type__c, 
                                                                             'Incomplete', 
                                                                             'Renewal PTO');
        insert renewal2;
        
        MUSW__Submission__c submission3 = new MUSW__Submission__c(Name='Test Backend Submission1');
        submissionController.newSubmission = submission3;
        submissionController.createSubmission();
        
        */
        
        //Testing method to check completion of attachment upload with different parameters
        /*BackendLicenseSubmission_CC.getCompletionStatus(submissionController.getsubmissionList()[0].Id, 'true','false','false','false','false','false','false','false', 'false', 'false', 'false');
        BackendLicenseSubmission_CC.getCompletionStatus(submissionController.getsubmissionList()[0].Id, 'false','true','false','false','false','false','false','false', 'false', 'false', 'false');
        BackendLicenseSubmission_CC.getCompletionStatus(submissionController.getsubmissionList()[0].Id, 'false','false','true','false','false','false','false','false', 'false', 'false', 'false');
        BackendLicenseSubmission_CC.getCompletionStatus(submissionController.getsubmissionList()[0].Id, 'false','false','false','true','false','false','false','false', 'false', 'false', 'false');
		*/
        //BackendLicenseSubmission_CC.getCompletionStatus(submissionController.getsubmissionList()[0].Id, 'false','false','false','false','false','true','false','false','false','false', 'false');
        submissionController.hiddenSubId = lst1[0].Id;
        //Deleting submission
        submissionController.refreshSubmissions();
        Test.stopTest();
        
        
    }
    
    @isTest static void testLicenseRenewalBackendSubsmissionController()
    {
        Global_Settings__c globalSetting = new Global_Settings__c(Name = UserInfo.getUsername(), Disable_Triggers__c = true);
        insert globalSetting;
        //insertTestData();
        
        //Step 1 : Data Insertion
        /*Creating test Account*/
        Account acc = new Account();
        acc = CreateTestDataUtility.createAccount();
        /*Inserting test Account*/
        insert acc;
        
        /*Creating test Contact*/
        Contact con = CreateTestDataUtility.createContact(acc.Id);
        /*Inserting test Contact*/
        insert con;   
        
        /*Create Submission List records*/
        List<MUSW__Master_Submission_List__c> masterSubmissionList = new List<MUSW__Master_Submission_List__c>();
                MUSW__Master_Submission_List__c backgroundSubmission = CreateTestDataUtility.createLicenseSubmissionList ('Manufactured Homes',
                                                                                                                          'Manufactured Homes Credential', 
                                                                                                                          'Manufactured Homes Installer', 
                                                                                                                          'Course Completion', 
                                                                                                                          Label.API_License2, 
                                                                                                                          'Softcopy: To be Uploaded', 
                                                                                                                          'Credential');
                backgroundSubmission.Background_Question_Field_API_Name__c= 'Non_US_Citizen__c';
                masterSubmissionList.add(backgroundSubmission);
        		MUSW__Master_Submission_List__c backgroundSubmission2 = CreateTestDataUtility.createLicenseSubmissionList ('Manufactured Homes',
                                                                                                                          'Manufactured Homes Credential', 
                                                                                                                          'Manufactured Homes Installer', 
                                                                                                                          'Course Completion', 
                                                                                                                          Label.API_License2, 
                                                                                                                          'Softcopy: To be Uploaded', 
                                                                                                                          'Credential');
                backgroundSubmission2.Default__c = True;
                masterSubmissionList.add(backgroundSubmission2);
        		MUSW__Master_Submission_List__c backgroundSubmission3 = CreateTestDataUtility.createLicenseSubmissionList ('Manufactured Homes',
                                                                                                                          'Manufactured Homes Credential', 
                                                                                                                          'Manufactured Homes Installer', 
                                                                                                                          'Course Completion', 
                                                                                                                          Label.API_Renewal_Application, 
                                                                                                                          'Softcopy: To be Uploaded', 
                                                                                                                          'Credential Renewal');
                backgroundSubmission3.Default__c = True;
                masterSubmissionList.add(backgroundSubmission3);
        		insert masterSubmissionList;
        
        /*Creating test License*/
        globalSetting.disable_triggers__C = false;
        upsert globalSetting;
        Musw__License2__c license = CreateTestDataUtility.createLicense(acc.Id, con.Id);
        /*Inserting test License to fire License Trigger*/
        insert license;        
        
        List<MUSW__Submission__c> submissionListCreated = [Select ID from MUSW__Submission__c where MUSW__License2__c =:license.Id];
        System.assertEquals(2, submissionListCreated.size());
        globalSetting.disable_triggers__C = true;
        upsert globalSetting;
        Test.startTest();
          
         
          String recId = license.Id;
          ApexPages.currentPage().getParameters().put('id', recId.substring(0,15));
          Attachment att = new Attachment(Body = Blob.valueOf('Test attachment body'), Name='test attachment', parentId = license.Id);
          insert att;
        
          BackendLicenseSubmission_CC submissionController = new BackendLicenseSubmission_CC(); 
            //Testing with license scenario 
            submissionController.isLicense = FALSE;
            submissionController.pid = license.Id;
            List<MUSW__Submission__c> lst1 = [Select Id FROM MUSW__Submission__c WHERE MUSW__License2__c=:license.Id ORDER BY Name];
        System.debug('size of submissions created '+ lst1.size());    
        
        submissionController.isRenewal = TRUE;
                    
        globalSetting.disable_triggers__C = false;
        upsert globalSetting;
        Renewal_Application__c renewal = CreateTestDataUtility.createRenewal(license.Id, 
                                                                             license.Application_Type__c, 
                                                                             license.Credential_Type__c, 
                                                                             license.Credential__c, 
                                                                             'Incomplete', 
                                                                             'Renewal');
        insert renewal;
        
        globalSetting.disable_triggers__C = true;
        upsert globalSetting;
        MUSW__Submission__c submission1 = new MUSW__Submission__c(Name='Test Backend Submission1');
        submissionController.newSubmission = submission1;
        submissionController.createSubmission();

       
        
        //Testing edit of submission/getting submission details with submission Id
       	LIST<MUSW__Submission__c> submissionList = submissionController.getsubmissionList();
        
        //Testing method to check completion of attachment upload with different parameters
        /*BackendLicenseSubmission_CC.getCompletionStatus(submissionController.getsubmissionList()[0].Id, 'true','false','false','false','false','false','false','false', 'false', 'false', 'false');
        BackendLicenseSubmission_CC.getCompletionStatus(submissionController.getsubmissionList()[0].Id, 'false','true','false','false','false','false','false','false', 'false', 'false', 'false');
        BackendLicenseSubmission_CC.getCompletionStatus(submissionController.getsubmissionList()[0].Id, 'false','false','true','false','false','false','false','false', 'false', 'false', 'false');
        BackendLicenseSubmission_CC.getCompletionStatus(submissionController.getsubmissionList()[0].Id, 'false','false','false','true','false','false','false','false', 'false', 'false', 'false');
		*/
        submissionController.hiddenSubId = lst1[0].Id;
        //Deleting submission
        submissionController.refreshSubmissions();
        Test.stopTest();
        
        
    }
    
     @isTest static void testLicenseReinstatementBackendSubsmissionController()
    {
        Global_Settings__c globalSetting = new Global_Settings__c(Name = UserInfo.getUsername(), Disable_Triggers__c = true);
        insert globalSetting;
        //insertTestData();
        
        //Step 1 : Data Insertion
        /*Creating test Account*/
        Account acc = new Account();
        acc = CreateTestDataUtility.createAccount();
        /*Inserting test Account*/
        insert acc;
        
        /*Creating test Contact*/
        Contact con = CreateTestDataUtility.createContact(acc.Id);
        /*Inserting test Contact*/
        insert con;   
        
        /*Create Submission List records*/
        List<MUSW__Master_Submission_List__c> masterSubmissionList = new List<MUSW__Master_Submission_List__c>();
                MUSW__Master_Submission_List__c backgroundSubmission = CreateTestDataUtility.createLicenseSubmissionList ('Manufactured Homes',
                                                                                                                          'Manufactured Homes Credential', 
                                                                                                                          'Manufactured Homes Installer', 
                                                                                                                          'Course Completion', 
                                                                                                                          Label.API_License2, 
                                                                                                                          'Softcopy: To be Uploaded', 
                                                                                                                          'Credential');
                backgroundSubmission.Background_Question_Field_API_Name__c= 'Non_US_Citizen__c';
                masterSubmissionList.add(backgroundSubmission);
        		MUSW__Master_Submission_List__c backgroundSubmission2 = CreateTestDataUtility.createLicenseSubmissionList ('Manufactured Homes',
                                                                                                                          'Manufactured Homes Credential', 
                                                                                                                          'Manufactured Homes Installer', 
                                                                                                                          'Course Completion', 
                                                                                                                          Label.API_License2, 
                                                                                                                          'Softcopy: To be Uploaded', 
                                                                                                                          'Credential');
                backgroundSubmission2.Default__c = True;
                masterSubmissionList.add(backgroundSubmission2);
        		MUSW__Master_Submission_List__c backgroundSubmission3 = CreateTestDataUtility.createLicenseSubmissionList ('Manufactured Homes',
                                                                                                                          'Manufactured Homes Credential', 
                                                                                                                          'Manufactured Homes Installer', 
                                                                                                                          'Course Completion', 
                                                                                                                          Label.API_Renewal_Application, 
                                                                                                                          'Softcopy: To be Uploaded', 
                                                                                                                          'Credential Reinstatement');
                backgroundSubmission3.Default__c = True;
                masterSubmissionList.add(backgroundSubmission3);
        		insert masterSubmissionList;
        
        /*Creating test License*/
        globalSetting.disable_triggers__C = false;
        upsert globalSetting;
        Musw__License2__c license = CreateTestDataUtility.createLicense(acc.Id, con.Id);
        /*Inserting test License to fire License Trigger*/
        insert license;        
        
        List<MUSW__Submission__c> submissionListCreated = [Select ID from MUSW__Submission__c where MUSW__License2__c =:license.Id];
        System.assertEquals(2, submissionListCreated.size());
        globalSetting.disable_triggers__C = true;
        upsert globalSetting;
        Test.startTest();
          
         
          String recId = license.Id;
          ApexPages.currentPage().getParameters().put('id', recId.substring(0,15));
          Attachment att = new Attachment(Body = Blob.valueOf('Test attachment body'), Name='test attachment', parentId = license.Id);
          insert att;
        
          BackendLicenseSubmission_CC submissionController = new BackendLicenseSubmission_CC(); 
            //Testing with license scenario 
            submissionController.isLicense = FALSE;
            submissionController.pid = license.Id;
            List<MUSW__Submission__c> lst1 = [Select Id FROM MUSW__Submission__c WHERE MUSW__License2__c=:license.Id ORDER BY Name];
        System.debug('size of submissions created '+ lst1.size());    
        
        submissionController.isReinstatement = TRUE;
                    
        globalSetting.disable_triggers__C = false;
        upsert globalSetting;
        Renewal_Application__c renewal = CreateTestDataUtility.createRenewal(license.Id, 
                                                                             license.Application_Type__c, 
                                                                             license.Credential_Type__c, 
                                                                             license.Credential__c, 
                                                                             'Incomplete', 
                                                                             'Reinstatement');
        insert renewal;
        
        globalSetting.disable_triggers__C = true;
        upsert globalSetting;
        MUSW__Submission__c submission1 = new MUSW__Submission__c(Name='Test Backend Submission1');
        submissionController.newSubmission = submission1;
        submissionController.createSubmission();

       
        
        //Testing edit of submission/getting submission details with submission Id
       	LIST<MUSW__Submission__c> submissionList = submissionController.getsubmissionList();
        
        //Testing method to check completion of attachment upload with different parameters
        /*BackendLicenseSubmission_CC.getCompletionStatus(submissionController.getsubmissionList()[0].Id, 'true','false','false','false','false','false','false','false', 'false', 'false', 'false');
        BackendLicenseSubmission_CC.getCompletionStatus(submissionController.getsubmissionList()[0].Id, 'false','true','false','false','false','false','false','false', 'false', 'false', 'false');
        BackendLicenseSubmission_CC.getCompletionStatus(submissionController.getsubmissionList()[0].Id, 'false','false','true','false','false','false','false','false', 'false', 'false', 'false');
        BackendLicenseSubmission_CC.getCompletionStatus(submissionController.getsubmissionList()[0].Id, 'false','false','false','true','false','false','false','false', 'false', 'false', 'false');
		*/
        submissionController.hiddenSubId = lst1[0].Id;
        //Deleting submission
        submissionController.refreshSubmissions();
        Test.stopTest();
        
        
    }
    
    @isTest static void testPermitBackendSubsmissionController()
    {
        Global_Settings__c globalSetting = new Global_Settings__c(Name = UserInfo.getUsername(), Disable_Triggers__c = true);
        insert globalSetting;
        //insertTestData();
        
        //Step 1 : Data Insertion
        /*Creating test Account*/
        Account acc = new Account();
        acc = CreateTestDataUtility.createAccount();
        /*Inserting test Account*/
        insert acc;
        
        /*Creating test Contact*/
        Contact con = CreateTestDataUtility.createContact(acc.Id);
        /*Inserting test Contact*/
        insert con;   
        
        /*Create Submission List records*/
        List<MUSW__Master_Submission_List__c> masterSubmissionList = new List<MUSW__Master_Submission_List__c>();
                MUSW__Master_Submission_List__c backgroundSubmission4 = CreateTestDataUtility.createLicenseSubmissionList ('Manufactured Homes Communities',
                                                                                                                          'Manufactured Homes Communities', 
                                                                                                                          'Manufactured Homes Community Permit', 
                                                                                                                          '', 
                                                                                                                          Label.API_Permit, 
                                                                                                                          'Softcopy: To be Uploaded', 
                                                                                                                          'Permit');
                masterSubmissionList.add(backgroundSubmission4);
        		MUSW__Master_Submission_List__c backgroundSubmission5 = CreateTestDataUtility.createLicenseSubmissionList ('Manufactured Homes Communities',
                                                                                                                          'Manufactured Homes Communities', 
                                                                                                                          'Manufactured Homes Community Permit', 
                                                                                                                          '', 
                                                                                                                          Label.API_Permit, 
                                                                                                                          'Softcopy: To be Uploaded', 
                                                                                                                          'Permit');
                backgroundSubmission5.Default__c = True;
                masterSubmissionList.add(backgroundSubmission5);
        		insert masterSubmissionList;
        
        /*Creating test License*/
        globalSetting.disable_triggers__C = false;
        upsert globalSetting;
        Musw__Permit2__c permit = CreateTestDataUtility.createPermit(acc.Id, con.Id);
        permit.Application_Type__c = 'Manufactured Homes Communities';
        permit.Program_Area__c = 'Manufactured Homes Communities';
        permit.Permit_Type__c = 'Manufactured Homes Community Permit';
        /*Inserting test Permit to fire Permit Trigger*/
        insert permit;        
        List<MUSW__Submission__c> submissionListCreated = [Select ID from MUSW__Submission__c where MUSW__Permit2__c =:permit.Id];
        System.assertEquals(1, submissionListCreated.size());
        globalSetting.disable_triggers__C = true;
        upsert globalSetting;
        Test.startTest();
        
          String recId = permit.Id;
          ApexPages.currentPage().getParameters().put('id', recId.substring(0,15));
          Attachment att = new Attachment(Body = Blob.valueOf('Test attachment body'), Name='test attachment', parentId = permit.Id);
          insert att;
        
          BackendLicenseSubmission_CC submissionController = new BackendLicenseSubmission_CC(); 
            //Testing with license scenario 
            submissionController.isPermit = TRUE;
            submissionController.permitpid = permit.Id;
            List<MUSW__Submission__c> lst1 = [Select Id FROM MUSW__Submission__c WHERE MUSW__Permit2__c=:permit.Id ORDER BY Name];
        System.debug('size of submissions created '+ lst1.size());    
        //Testing file upload
        submissionController.subId = lst1[0].Id;
        submissionController.file = new Attachment(Body = Blob.valueOf('Test attachment body'), Name='test attachment', parentId = permit.Id);
        submissionController.uploadFile();
		//submissionController.isRenewal = True;
        

        //Testing backend submission Update
        //submissionController.hiddenSubId = submissionController.getsubmissionList()[0].Id;
        MUSW__Submission__c submission = new MUSW__Submission__c(Name='Test Backend Submission');
        submissionController.newSubmission = submission;
        submissionController.createSubmission(); 

       
        
        //Testing Hard Copy acknowledgement
        BackendLicenseSubmission_CC.updateHardCopy(submissionController.getsubmissionList()[0].Id);

        //Testing getAttachmentList
        BackendLicenseSubmission_CC.getAttachmentList(submissionController.getsubmissionList()[0].Id);

        //Testing deletion of attachments
        List<Attachment> attList = [SELECT Id FROM Attachment WHERE parentId=:submissionController.getsubmissionList()[0].Id];
        if(!attList.isEmpty()){
            BackendLicenseSubmission_CC.deleteAttachment(attList[0].Id);
        }

        //Testing status update
        BackendLicenseSubmission_CC.updateStatus(submissionController.getsubmissionList()[0].Id, 'Approved');

        //Testing edit of submission/getting submission details with submission Id
        BackendLicenseSubmission_CC.getSubmissionDetails(submissionController.getsubmissionList()[0].Id);
        
        //Testing method to check completion of attachment upload with different parameters
        BackendLicenseSubmission_CC.getCompletionStatus(submissionController.getsubmissionList()[0].Id, 'false','false','false','false','false','false','true','false','false','false', 'false');
        submissionController.hiddenSubId = lst1[0].Id;
        //Deleting submission
        submissionController.refreshSubmissions();
        Test.stopTest();
        
        
    }
    
    @isTest static void testPermitRenewalBackendSubsmissionController()
    {
        Global_Settings__c globalSetting = new Global_Settings__c(Name = UserInfo.getUsername(), Disable_Triggers__c = true);
        insert globalSetting;
        //insertTestData();
        
        //Step 1 : Data Insertion
        /*Creating test Account*/
        Account acc = new Account();
        acc = CreateTestDataUtility.createAccount();
        /*Inserting test Account*/
        insert acc;
        
        /*Creating test Contact*/
        Contact con = CreateTestDataUtility.createContact(acc.Id);
        /*Inserting test Contact*/
        insert con;   
        
        /*Create Submission List records*/
        List<MUSW__Master_Submission_List__c> masterSubmissionList = new List<MUSW__Master_Submission_List__c>();
                MUSW__Master_Submission_List__c backgroundSubmission4 = CreateTestDataUtility.createLicenseSubmissionList ('Manufactured Homes Communities',
                                                                                                                          'Manufactured Homes Communities', 
                                                                                                                          'Manufactured Homes Community Permit', 
                                                                                                                          '', 
                                                                                                                          Label.API_Permit, 
                                                                                                                          'Softcopy: To be Uploaded', 
                                                                                                                          'Permit');
                masterSubmissionList.add(backgroundSubmission4);
        		MUSW__Master_Submission_List__c backgroundSubmission5 = CreateTestDataUtility.createLicenseSubmissionList ('Manufactured Homes Communities',
                                                                                                                          'Manufactured Homes Communities', 
                                                                                                                          'Manufactured Homes Community Permit', 
                                                                                                                          '', 
                                                                                                                          Label.API_Permit, 
                                                                                                                          'Softcopy: To be Uploaded', 
                                                                                                                          'Permit');
                backgroundSubmission5.Default__c = True;
                masterSubmissionList.add(backgroundSubmission5);
        		MUSW__Master_Submission_List__c backgroundSubmission3 = CreateTestDataUtility.createLicenseSubmissionList ('Manufactured Homes Communities',
                                                                                                                          'Manufactured Homes Communities', 
                                                                                                                          'Manufactured Homes Community Permit', 
                                                                                                                          '', 
                                                                                                                          Label.API_Renewal_Application, 
                                                                                                                          'Softcopy: To be Uploaded', 
                                                                                                                          'Permit Renewal');
                backgroundSubmission3.Default__c = True;
                masterSubmissionList.add(backgroundSubmission3);
        		insert masterSubmissionList;
        
        /*Creating test License*/
        globalSetting.disable_triggers__C = false;
        upsert globalSetting;
        Musw__Permit2__c permit = CreateTestDataUtility.createPermit(acc.Id, con.Id);
        permit.Application_Type__c = 'Manufactured Homes Communities';
        permit.Program_Area__c = 'Manufactured Homes Communities';
        permit.Permit_Type__c = 'Manufactured Homes Community Permit';
        /*Inserting test Permit to fire Permit Trigger*/
        insert permit;        
        List<MUSW__Submission__c> submissionListCreated = [Select ID from MUSW__Submission__c where MUSW__Permit2__c =:permit.Id];
        System.assertEquals(1, submissionListCreated.size());
        globalSetting.disable_triggers__C = true;
        upsert globalSetting;
        Test.startTest();
        
          String recId = permit.Id;
          ApexPages.currentPage().getParameters().put('id', recId.substring(0,15));
          Attachment att = new Attachment(Body = Blob.valueOf('Test attachment body'), Name='test attachment', parentId = permit.Id);
          insert att;
        
          BackendLicenseSubmission_CC submissionController = new BackendLicenseSubmission_CC(); 
            //Testing with license scenario 
            submissionController.isRenewalPTO = TRUE;
            submissionController.permitpid = permit.Id;
            List<MUSW__Submission__c> lst1 = [Select Id FROM MUSW__Submission__c WHERE MUSW__Permit2__c=:permit.Id ORDER BY Name];
        System.debug('size of submissions created '+ lst1.size());    
        
        //Testing backend submission Update
        //submissionController.hiddenSubId = submissionController.getsubmissionList()[0].Id;
        MUSW__Submission__c submission = new MUSW__Submission__c(Name='Test Backend Submission');
        submissionController.newSubmission = submission;
        submissionController.createSubmission(); 

       	//Testing edit of submission/getting submission details with submission Id
       	LIST<MUSW__Submission__c> submissionList = submissionController.getsubmissionList();
        
        Test.stopTest();
        
        
    }
    
}