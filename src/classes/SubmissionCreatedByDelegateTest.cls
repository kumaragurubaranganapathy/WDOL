/**
* Name: SubmissionCreatedByDelegateTest
* Type: Class
* Description: Test class for ReceiptCreatedbyDelegate
* Date:        Developer/Company                 	Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 10/12/2018   Srikanth Kottam/Deloitte           Initial Creation
**/
@istest
public class SubmissionCreatedByDelegateTest {
    @testSetup
    public static void createTestdata(){
        //Create Account
        Account acc = CreateTestDataUtility.createAccount();
        insert acc;
        //Create Contact
        Contact con = new Contact(LastName = DOL_AppConstants.NULL_EMPTY_STRING + 'firstConLastName', firstName = DOL_AppConstants.NULL_EMPTY_STRING + 'firstConFirstName', Email= DOL_AppConstants.NULL_EMPTY_STRING + 'firstcon@mailinator.com', 
                                  Birthdate = null, AccountId = acc.Id, Social_Security_Number_Encrypted__c = DOL_AppConstants.NULL_EMPTY_STRING + '111222333', 
                                  Duplicate_Override__c = true, Birth_Country__c = DOL_AppConstants.NULL_EMPTY_STRING + 'United States', Birth_State_Province__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Illinois', Birth_City__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Chicago', 
                                  Gender__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Male', Ethnicity__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Asian Indian');
        insert con;
        //Create Community Plus User
        User plusUser = CreateTestDataUtility.createCommunityPlusUser(con.Id);
        plusUser.Alias = DOL_AppConstants.NULL_EMPTY_STRING + 'ppuser';
        plusUser.Email= DOL_AppConstants.NULL_EMPTY_STRING + 'portalplususerone@mailinator.com';
        plusUser.LastName= DOL_AppConstants.NULL_EMPTY_STRING + 'secondConLastName';
        plusUser.UserName= DOL_AppConstants.NULL_EMPTY_STRING + 'portalplususerone@mailinator.com';
        insert plusUser;
        
        
    }
    static testmethod void testSubmissionbyDelegate()
    {	
        Account acc = [Select id, name from Account where name =: DOL_AppConstants.NULL_EMPTY_STRING + 'utilityAccountFirstName'];
        Contact con = [Select id, name from Contact where LastName =: DOL_AppConstants.NULL_EMPTY_STRING + 'firstConLastName'];
        User u = [SELECT Id, isActive FROM User WHERE ContactId =: con.Id];
        //Musw__License2__c credential = [Select Id, name from Musw__License2__c where MUSW__Applicant__c =: con.Id];
        Test.startTest();
        system.runAs(u){
            Musw__License2__c credential = CreateTestDataUtility.createLicense(acc.Id, con.Id);
            credential.musw__status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Active';
            credential.MUSW__Expiration_Date__c = system.today();
            insert credential;
            
            MUSW__Submission__c submission= new MUSW__Submission__c();
            submission.MUSW__BG_File_Location_Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Salesforce';
            submission.Name = DOL_AppConstants.NULL_EMPTY_STRING + 'Test file credential';
            submission.MUSW__Required__c = true;
            submission.MUSW__License2__c = credential.id;
            insert submission;
            
            MUSW__Permit2__c permit = CreateTestDataUtility.createPermit(acc.Id, con.Id);
            insert permit;
            
            MUSW__Submission__c submission2= new MUSW__Submission__c();
            submission2.MUSW__BG_File_Location_Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Salesforce';
            submission2.Name = DOL_AppConstants.NULL_EMPTY_STRING + 'Test file permit';
            submission2.MUSW__Required__c = true;
            submission2.MUSW__Permit2__c = permit.id;
            insert submission2;
            
            Renewal_Application__c renewal = CreateTestDataUtility.createRenewal(credential.id, credential.Application_Type__c, credential.Credential_Type__c, credential.Credential__c, 'Generate Fee', 'Renewal');
            renewal.Applicant__c = con.Id;
            insert renewal;
        }
        //Credential Submission
        Musw__License2__c credential = [Select Id, name from Musw__License2__c where MUSW__Applicant__c =: con.Id];
        List<MUSW__Submission__c> lstSubmission = [Select Id, name from MUSW__Submission__c where MUSW__License2__c =: credential.id];
        System.assertEquals(1,lstSubmission.size());
        
        
      /*  System.assertEquals(4,lstSubmissionShare.size());
        Test.stopTest(); */
        
        //Permit Submission
        MUSW__Permit2__c permit = [Select Id, name from MUSW__Permit2__c where MUSW__Applicant__c =: con.Id];
        List<MUSW__Submission__c> lstSubmission2 = [Select Id, name from MUSW__Submission__c where MUSW__Permit2__c =: permit.id];
        System.assertEquals(1,lstSubmission2.size());
        
        //Renewal
        Renewal_Application__c renewal = [Select Id, Applicant__c from Renewal_Application__c where Applicant__c =: con.Id];
        List<MUSW__Submission__c> lstSubmission3 = [Select Id, name from MUSW__Submission__c where MUSW__License2__c =: credential.id and Show_For_Credential__c = true];
        System.assertEquals(1,lstSubmission3.size());
     	List<MUSW__Submission__Share> lstSubmissionShare= [SELECT Id FROM MUSW__Submission__Share where ParentId =: lstSubmission3[0].id or UserOrGroupId =: u.Id];
        System.assertEquals(4,lstSubmissionShare.size());
        Test.stopTest();
    }
}