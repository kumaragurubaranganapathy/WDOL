@isTest
public class CreateTestDataUtilityTest {
    @isTest
    static void createTestDataTest(){
        
        Account acc = CreateTestDataUtility.createAccount();
        Account busAcc = CreateTestDataUtility.createBusinessAccount();    
        //Account testAcc = CreateTestDataUtility.createTestAccount();
        Contact con = CreateTestDataUtility.createContact(acc.Id);
        //MUSW__Permit2__c permit = CreateTestDataUtility.createPermit(acc.Id, con.Id);
        
        Datetime startDate = Datetime.newInstance(2019, 02, 01);
        Datetime endDate = Datetime.newInstance(2019, 12, 01);
        //MUSW__Review__c permReview = CreateTestDataUtility.createPermitReview(permit, startDate, endDate);
        
        MUSW__Account_Contact__c accCon = CreateTestDataUtility.createAccountContact(acc.Id, con.Id);
        
        MUSW__Parcel__c accParcel = CreateTestDataUtility.createAccountParcel(acc.Id, con.Id, 'Madison Street', 'New York City', 'New York', '66579', 'United States');
        
        MUSW__License2__c lic = CreateTestDataUtility.createLicense(acc.Id, con.Id);
        MUSW__License_Parcel__c licParcel = CreateTestDataUtility.createLicenseParcel(acc.Id, lic.Id, accParcel.Id, true, false);
        
        //MUSW__Permit_Parcel__c permParcel = CreateTestDataUtility.createPermitParcel(acc.Id, permit.Id, accParcel.Id, true, false);
        
        Renewal_Application__c renewal = CreateTestDataUtility.createRenewal(lic.Id, 'Geologist', 'Geologist', 'Geologist', 'Pending', 'Renewal');
        
        //MUSW__Permit2__c permitMHC = CreateTestDataUtility.createPermitMHC(acc.Id, con.Id);
        
        String randomNo1 = CreateTestDataUtility.generateRandomNumber(5);
        String randomNo2 = CreateTestDataUtility.generateRandomNumber(4);
        
        MUSW__Master_Submission_List__c msl1 =  CreateTestDataUtility.createLicenseSubmissionList('Geologist', 'Geologist', 'Geologist', 'Application Method', 'MUSW__License2__c', 'Softcopy: To be Uploaded', 'License');
        MUSW__Master_Submission_List__c msl2 =  CreateTestDataUtility.createLicenseSubmissionList('Geologist', 'Geologist', 'Geologist', 'Application Method', 'Renewal_Application__c', 'Softcopy: To be Uploaded', 'Permit Renewal');
        MUSW__Master_Submission_List__c msl3 =  CreateTestDataUtility.createLicenseSubmissionList('Geologist', 'Geologist', 'Geologist', 'Application Method', 'Renewal_Application__c', 'Softcopy: To be Uploaded', 'Credential Renewal');
        MUSW__Master_Submission_List__c msl4 =  CreateTestDataUtility.createLicenseSubmissionList('Geologist', 'Geologist', 'Geologist', 'Application Method', 'Musw__Permit2__c', 'Softcopy: To be Uploaded', 'Credential Renewal');
        
        CreateTestDataUtility.createQuestionsForLicense('Geologist', 'Geologist', 'Geologist', 'General Application');
        
        MUSW__Submission__c sub = CreateTestDataUtility.createSubmission();
        
        User usr = CreateTestDataUtility.createCommunityUser(con.Id);
        //User user1 = CreateTestDataUtility.createBackendUser();
        //User user2 = CreateTestDataUtility.createBackendUser2();
        User user3 = CreateTestDataUtility.createCommunityPlusUser(con.Id);
        List<MUSW__License2__c> lstLicenses = CreateTestDataUtility.createMultipleLicenses(3, 'Geologist', 'Geologist', acc.Id, con.Id);
        MUSW__Parcel__c parcel2 = CreateTestDataUtility.createContactParcel(con.Id, 'Madison Street', 'New York City', 'New York', '66579', 'United States');
        
        MUSW__Parcel_Contact2__c parcelCon = CreateTestDataUtility.createParcelContactJunction(parcel2.Id, con.Id);
        
        Parcel_Account__c parAcc = CreateTestDataUtility.createParcelAccountJunction(parcel2.Id, acc.Id);
        
        Account acc2 = CreateTestDataUtility.createCitizenAccount();
        
        User usr4 = CreateTestDataUtility.createCommunityTestUser(con.Id);
        
        MUSW__Application2__c appl2 = CreateTestDataUtility.createServiceRequest();
        
        CreateTestDataUtility.createPageDefinition('Page', 'Geologist', 'Geologist', 'Geologist');
        
        CreateTestDataUtility.createPageDefinitionServiceRequest('Page', 'Update Legal Name');
    }
}