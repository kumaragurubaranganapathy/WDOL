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
    
    @isTest static void testTiggerReturn() {
        
        Global_Settings__c globalSetting = new Global_Settings__c(Name = UserInfo.getUsername(), Disable_Triggers__c = true);
        insert globalSetting;       
        
        Test.startTest();
        
        /*Creating test Account*/
        Account acc = new Account();
        acc = CreateTestDataUtility.createAccount();
        /*Inserting test Account*/
        insert acc;
        
        /*Creating test Contact*/
        Contact con = CreateTestDataUtility.createContact(acc.Id);
        /*Inserting test Contact*/
        insert con;   
        
        /*Creating test License*/
        Musw__License2__c license1 = CreateTestDataUtility.createLicense(acc.Id, con.Id);
        /*Inserting test License to fire License Trigger*/
        insert license1;
        List<MUSW__Submission__c> submissionListCreated = [Select ID from MUSW__Submission__c where MUSW__License2__c =:license1.Id];
        System.assertEquals(0, submissionListCreated.size());
        Test.stopTest();
        
    }
    
    @isTest static void testTiggerFiring() {
        
        Global_Settings__c globalSetting = new Global_Settings__c(Name = UserInfo.getUsername(), Disable_Triggers__c = true);
        insert globalSetting;       
        
        /*Creating test Account*/
        Account acc = new Account();
        acc = CreateTestDataUtility.createAccount();
        /*Inserting test Account*/
        insert acc;
        
        /*Creating test Contact*/
        Contact con = CreateTestDataUtility.createContact(acc.Id);
        /*Inserting test Contact*/
        insert con;   
        
        /*User u = new User();
        u = CreateTestDataUtility.createCommunityUser(con.Id);
        
        System.runAs(u){
          */      /*Create Submission List records*/
                List<MUSW__Master_Submission_List__c> masterSubmissionList = new List<MUSW__Master_Submission_List__c>();
                MUSW__Master_Submission_List__c backgroundSubmission = CreateTestDataUtility.createLicenseSubmissionList ('Manufactured Homes', 'Manufactured Homes Credential', 'Manufactured Homes Installer', 'Course Completion', Label.API_License2, 'Softcopy: To be Uploaded', 'Credential');
                backgroundSubmission.Background_Question_Field_API_Name__c= 'Non_US_Citizen__c';
                masterSubmissionList.add(backgroundSubmission);
                MUSW__Master_Submission_List__c backgroundSubmission2 = CreateTestDataUtility.createLicenseSubmissionList ('Manufactured Homes', 'Manufactured Homes Credential', 'Manufactured Homes Installer', 'Course Completion', Label.API_License2, 'Hardcopy: To be Mailed', 'Credential');
                backgroundSubmission2.Default__c = True;
                masterSubmissionList.add(backgroundSubmission2);
                insert masterSubmissionList;
                /*List<MUSW__Master_Submission_List__c> testSubmissionListCount = [SELECT Id, External_id__c, Name, Background_Question_Field_API_Name__c,
                                                  Description__c, Credential_Type__c, Default__c, Show_For__c,
                                                  Submission_Type__c 
                                                  FROM MUSW__Master_Submission_List__c 
                                                  WHERE Active__c = TRUE 
                                                  AND Object__c = :label.API_License2 
                                                  AND Credential_Type__c IN ('License Type A1')];
                System.debug('test submission list count'+testSubmissionListCount.size());*/
            /*Creating test License*/
        globalSetting.disable_triggers__C = false;
        upsert globalSetting;
                Musw__License2__c license = CreateTestDataUtility.createLicense(acc.Id, con.Id);
                /*Inserting test License to fire License Trigger*/
                insert license;        
                
                /*List<MUSW__License2__c> testLicenseCount = [Select ID from MUSW__License2__c where credential_type__c = 'License Type A1'];
                System.debug('testLicenseCount'+testSubmissionListCount.size());
            */
                List<MUSW__Submission__c> submissionListCreated = [Select ID from MUSW__Submission__c where MUSW__License2__c =:license.Id];
                System.assertEquals(2, submissionListCreated.size());
                
                license.Non_US_Citizen__c = 'No';
                license.MUSW__Description__c = 'testing after update trigger';
                upsert license;
                List<MUSW__Submission__c> submissionListDeleted = [Select ID from MUSW__Submission__c where MUSW__License2__c =:license.Id];
                System.assertEquals(1, submissionListDeleted.size());
                   // }
        
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
        
        
    }

}