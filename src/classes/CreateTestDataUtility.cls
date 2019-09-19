/**
* Name: CreateTestDataUtility
* Type: Class
* Description: Class to create test data
* Date:        Developer/Company                    Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 06/19/2018   Sharad Maheshwari/Deloitte           Initial Creation
**/

public class CreateTestDataUtility {
    
    public static final String COMMUNITY_PROFILE_ID = [Select Id from Profile Where Name = 'eSLA Customer Community Login User' limit 1 ].Id ;
    public static Contact profileRecordSpcl ;
    
    /**
    * Method name   : createAccount
    * Description   : Method to create test account
    * Return Type   : Account
    * Parameter     : none
    **/
    public static Account createAccount() {
        
        Account acc = new Account(name = DOL_AppConstants.NULL_EMPTY_STRING + 'utilityAccountFirstName');
        return acc;
    }
    
    /**
    * Method name   : createBusinessAccount
    * Description   : Method to create test account
    * Return Type   : Account
    * Parameter     : none
    **/
    public static Account createBusinessAccount() {
        Id recordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account acc = new Account(name = DOL_AppConstants.NULL_EMPTY_STRING + 'TestBusinessAccount', RecordTypeId = recordtypeId, Business_Name__c = DOL_AppConstants.NULL_EMPTY_STRING + 'TestBusinessAccount', Type_of_Ownership__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Company',
                                 FEIN_Number_Encrypted__c = DOL_AppConstants.NULL_EMPTY_STRING + '123456789');
        return acc;
    }

    /**
    * Method name   : createTestAccount
    * Description   : method for creating test account
    * Return Type   : Account
    * Parameter     : none
    **/

    public static Account createTestAccount(){
        
          Id accountOwnerId = [SELECT Id 
                             FROM User
                             WHERE Username = :System.label.UN_Account_Owner LIMIT 1].Id; 
        
        system.assert(accountOwnerId != null);
        
         //Step 1 : Data Insertion
        String fullName = DOL_AppConstants.NULL_EMPTY_STRING + 'TestUser 1123';
        Account acc = new Account(name=fullName, OwnerId = accountOwnerId);
        
        
        return acc;
 
    }
    
    /**
    * Method name   : createContact
    * Description   : Method to create test contact
    * Return Type   : Contact
    * Parameter     : Account Id
    **/
    public static Contact createContact(Id accId) {
        
        Contact con = new Contact(lastName = DOL_AppConstants.NULL_EMPTY_STRING + 'utilityContactLastName', firstName = DOL_AppConstants.NULL_EMPTY_STRING + 'utilityContOactFirstName', Email= DOL_AppConstants.NULL_EMPTY_STRING + 'testTESTtest@grr.la', 
                                  Birthdate = null, AccountId = accid, Social_Security_Number_Encrypted__c = DOL_AppConstants.NULL_EMPTY_STRING + '838587352', 
                                  Duplicate_Override__c = true, Birth_Country__c = DOL_AppConstants.NULL_EMPTY_STRING + 'United States', Birth_State_Province__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Texas', Birth_City__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Dallas', 
                                  Gender__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Male', Ethnicity__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Asian Indian');
        return con;
    }
    
    /**
    * Method name   : createPermitReview
    * Description   : Method to create test review
    * Return Type   : Review
    * Parameter     : Permit Id
    **/
    public static MUSW__Review__c createPermitReview(MUSW__Permit2__c permitRecord, Datetime startDate, Datetime endDate) {
        
        MUSW__Review__c review = new MUSW__Review__c(MUSW__Permit2__c = permitRecord.Id,
                                                    MUSW__Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Pending',
                                                    Application_Type__c = permitRecord.Application_Type__c,
                                                    Start_Date__c = startDate,
                                                    MUSW__Completed_DateTime__c = endDate);
        return review;
    }
    
    /**
    * Method name   : createAccountContact
    * Description   : method for creating test AccountContactRecord
    * Return Type   : AccountContact
    * Parameter     : Account id, Contact id  
    **/
    public static MUSW__Account_Contact__c createAccountContact(Id accid,Id ContactId){
        
         //Create AccountContact
        MUSW__Account_Contact__c ac = new MUSW__Account_Contact__c(MUSW__Account__c=accid,MUSW__Contact__c=ContactId, Associate_Status__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Active');
        
        return ac;
    }

            /**
    * Method name   : createAccountParcel
    * Description   : method for creating test Account parcel object
    * Return Type   : MUSW__Parcel__c
    * Parameter     : Account id, Contact id, String street, String city, String state, String zip, String country
    **/
    public static MUSW__Parcel__c createAccountParcel(Id aid, Id cid, String street, String city, String state, String zip, String country){
        MUSW__Parcel__c p = new MUSW__Parcel__c(Primary_Account__c = aid, MUSW__Primary_Contact__c=cid);
        p.MUSW__Street2__c = street;
        p.MUSW__City__c = city;
        p.MUSW__State__c = state;
        p.MUSW__Post_Zip_Code__c = zip;
        p.Country__c = country;
        
        return p;
    }

    
    /**
    * Method name   : createLicenseParcel
    * Description   : method for creating test license parcel object
    * Return Type   : MUSW__License_Parcel__c
    * Parameter     : Account id, Contact id, String street, String city, String state, String zip, String country
    **/
    public static MUSW__License_Parcel__c createLicenseParcel(Id accountId, Id licenseId, Id parcelId, Boolean isMailing, Boolean isPublic){
        MUSW__License_Parcel__c licenseParcel = new MUSW__License_Parcel__c(Account__c = accountId, 
                                                                MUSW__License2__c = licenseId,
                                                                MUSW__Parcel__c = parcelId,
                                                               Mailing__c = isMailing,
                                                               Public__c = isPublic);
        
        return licenseParcel;
    }
    
    /**
    * Method name   : createPermitParcel
    * Description   : method for creating test permit parcel object
    * Return Type   : MUSW__Permit_Parcel__c
    * Parameter     : Account id, Contact id, String street, String city, String state, String zip, String country
    **/
    public static MUSW__Permit_Parcel__c createPermitParcel(Id accountId, Id permitId, Id parcelId, Boolean isMailing, Boolean isPublic){
        MUSW__Permit_Parcel__c permitParcel = new MUSW__Permit_Parcel__c(Account__c = accountId, 
                                                                MUSW__Permit2__c = permitId,
                                                                MUSW__Parcel__c = parcelId,
                                                               Mailing__c = isMailing,
                                                               Public__c = isPublic);
        
        return permitParcel;
    }

    /**
    * Method name   : createLicense
    * Description   : Method to create test license
    * Return Type   : MUSW__License2__c
    * Parameter     : Account Id and Contact Id
    **/
    public static MUSW__License2__c createLicense(Id accountId, Id contactId) {
        
        Id recordTypeId = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        MUSW__License2__c license = new MUSW__License2__c(RecordTypeId = recordTypeId,
                                                          Application_Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Geologist', 
                                                          Credential_type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Geologist', 
                                                          Credential__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Geologist', 
                                                          Application_Method__c = DOL_AppConstants.NULL_EMPTY_STRING + 'General Application',
                                                          musw__status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Pending', 
                                                          MUSW__Primary_Licensee__c = accountId, 
                                                          MUSW__Applicant__c = contactId, 
                                                          Non_US_Citizen__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Yes');
                
        return license;
    }
    
    /**
    * Method name   : createRenewal
    * Description   : Method to create test renewal
    * Return Type   : Renewal_Application__c
    * Parameter     : License Id
    **/
    public static Renewal_Application__c createRenewal(Id licenseOrPermitId, String applicationType, String credentialTypeOrProgramArea, String credentialOrPermitType, String status, String renewalReinstatementType) {
        
        Id recordTypeId = Schema.SObjectType.Renewal_Application__c.getRecordTypeInfosByName().get('Universal Default Renewal/Reinstatement').getRecordTypeId();
        Renewal_Application__c renewal;
        if(renewalReinstatementType == 'Renewal' || renewalReinstatementType == 'Reinstatement'){
            renewal = new Renewal_Application__c(RecordTypeId = recordTypeId,
                                                          Application_Type__c = applicationType, 
                                                          Credential_type__c = credentialTypeOrProgramArea, 
                                                          Credential__c = credentialOrPermitType,
                                                          renewal_status__c = status,
                                                          license__c = licenseOrPermitId,
                                                          Renewal_Reinstatement_Type__c = renewalReinstatementType);
            
        }else if(renewalReinstatementType == 'Renewal PTO' || renewalReinstatementType == 'Reinstatement PTO'){
            System.debug('in renewal pto');
            renewal = new Renewal_Application__c(RecordTypeId = recordTypeId,
                                                          Application_Type__c = applicationType, 
                                                          Program_Area__c = credentialTypeOrProgramArea, 
                                                          Permit_Type__c = credentialOrPermitType,
                                                          renewal_status__c = status,
                                                          permit__c = licenseOrPermitId,
                                                          Renewal_Reinstatement_Type__c = renewalReinstatementType);
            System.debug('renewal '+renewal);
            
        }
        
                
        return renewal;
    }
    
    
        /**
    * Method name   : createPermit
    * Description   : Method to create test permit
    * Return Type   : MUSW__Permit2__c
    * Parameter     : Account Id and Contact Id
    **/
    public static MUSW__Permit2__c createPermit(Id accountId, Id contactId) {
         Id recordTypeId = Schema.SObjectType.MUSW__Permit2__c.getRecordTypeInfosByName().get('Universal Default Permit Record Type').getRecordTypeId();
        
                                                        MUSW__Permit2__c permit = new MUSW__Permit2__c(RecordTypeId = recordTypeId,
                                                          Application_Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Geologist', 
                                                          Permit_Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Building', 
                                                          Program_Area__c = DOL_AppConstants.NULL_EMPTY_STRING + 'POWTS', 
                                                          musw__status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Pending', 
                                                          MUSW__Account__c = accountId,Review_Hours_Based_on_Answers__c=1.0,MUSW__Applicant__c = contactId );                
        return permit;
    }
    
        /**
    * Method name   : createPermitMHC
    * Description   : Method to create test MHC permit
    * Return Type   : MUSW__Permit2__c
    * Parameter     : Account Id and Contact Id
    **/
    public static MUSW__Permit2__c createPermitMHC(Id accountId, Id contactId) {
        
        Id recordTypeId = Schema.SObjectType.MUSW__Permit2__c.getRecordTypeInfosByName().get('Permit').getRecordTypeId();
        MUSW__Permit2__c permit = new MUSW__Permit2__c(RecordTypeId = recordTypeId,
                                                          Application_Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Manufactured Homes Communities', 
                                                          Permit_Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Manufactured Homes Community Permit', 
                                                          Program_Area__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Manufactured Homes Communities', 
                                                          musw__status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Pending', 
                                                          MUSW__Account__c = accountId,
                                                          Review_Hours_Based_on_Answers__c=1.0,
                                                          MUSW__Applicant__c = contactId );                
        return permit;
    }
    
    /**
    * Method name   : generateRandomNumber
    * Description   : Method to generate a random number which can be used in external id's and other fields where unique number is required
    * Return Type   : Integer
    * Parameter     : none
    **/
    public static String generateRandomNumber(Integer range) {
        
        Double randomDouble = math.random() * range;
        Integer randomInteger = randomDouble.intValue();
        String randomNumber;
        if(math.mod(randomInteger, 2) == 0){
            randomNumber = DOL_AppConstants.NULL_EMPTY_STRING + 'AEIOU'+randomInteger;
        }else{
            randomNumber = DOL_AppConstants.NULL_EMPTY_STRING + 'UOIEA'+randomInteger;
        }
        return randomNumber;
    }
    
    /**
    * Method name   : createLicenseSubmissionList
    * Description   : Method to create test submissionList
    * Return Type   : MUSW__License2__c
    * Parameter     : Account Id and Contact Id
    **/
    public static MUSW__Master_Submission_List__c createLicenseSubmissionList(String applicationType, String credentialTypeOrProgramArea, String credentialorPermitType, String applicationMethod, String obj, String submissionType, String showFor) {
        MUSW__Master_Submission_List__c backgroundSubmission;
        String externalId = DOL_AppConstants.NULL_EMPTY_STRING + 'extid' + generateRandomNumber(48763);
        System.debug(externalId);
        if(obj == Label.API_license2){
            backgroundSubmission = new MUSW__Master_Submission_List__c (External_Id__c = externalId, 
                                                                                                    Name = externalId, 
                                                                                                    Object__c = obj, 
                                                                                                    Description_Long__c = DOL_AppConstants.NULL_EMPTY_STRING + 'test description', 
                                                                                                    Application_Type__c = applicationType,
                                                                                                    Credential_Type__c = credentialTypeOrProgramArea, 
                                                                                                    Credential__c = credentialorPermitType, 
                                                                                                    Application_Method__c = applicationMethod,
                                                                                                    Effective_start_date__c = (System.today() - 3), 
                                                                                                    Effective_end_date__c = (System.today() + 3), 
                                                                                                    Show_For__c = showFor,
                                                                                                    Submission_Type__c = submissionType);
            
        }else if(obj == Label.API_Renewal_Application && showFor == 'Permit Renewal'){
            backgroundSubmission = new MUSW__Master_Submission_List__c (External_Id__c = externalId, 
                                                                                                    Name = externalId, 
                                                                                                    Object__c = obj, 
                                                                                                    Description_Long__c = DOL_AppConstants.NULL_EMPTY_STRING + 'test description', 
                                                                                                    Application_Type__c = applicationType,
                                                                                                    Program_Area__c = credentialTypeOrProgramArea, 
                                                                                                    Permit_Type__c = credentialorPermitType, 
                                                                                                    Application_Method__c = applicationMethod,
                                                                                                    Effective_start_date__c = (System.today() - 3), 
                                                                                                    Effective_end_date__c = (System.today() + 3), 
                                                                                                    Show_For__c = showFor,
                                                                                                    Submission_Type__c = submissionType);
            
        }else if(obj == Label.API_Renewal_Application && (showFor == 'Credential Renewal' || showFor == 'Credential Reinstatement')){
            backgroundSubmission = new MUSW__Master_Submission_List__c (External_Id__c = externalId, 
                                                                                                    Name = externalId, 
                                                                                                    Object__c = obj, 
                                                                                                    Description_Long__c = DOL_AppConstants.NULL_EMPTY_STRING + 'test description', 
                                                                                                    Application_Type__c = applicationType,
                                                                                                    Credential_Type__c = credentialTypeOrProgramArea, 
                                                                                                    Credential__c = credentialorPermitType, 
                                                                                                    Application_Method__c = applicationMethod,
                                                                                                    Effective_start_date__c = (System.today() - 3), 
                                                                                                    Effective_end_date__c = (System.today() + 3), 
                                                                                                    Show_For__c = showFor,
                                                                                                    Submission_Type__c = submissionType);
            
        }else if(obj == Label.API_Permit){
            backgroundSubmission = new MUSW__Master_Submission_List__c (External_Id__c = externalId, 
                                                                                                    Name = externalId, 
                                                                                                    Object__c = obj, 
                                                                                                    Description_Long__c = DOL_AppConstants.NULL_EMPTY_STRING + 'test description', 
                                                                                                    Application_Type__c = applicationType,
                                                                                                    Program_Area__c = credentialTypeOrProgramArea, 
                                                                                                    Permit_Type__c = credentialorPermitType, 
                                                                                                    Application_Method__c = applicationMethod,
                                                                                                    Effective_start_date__c = (System.today() - 3), 
                                                                                                    Effective_end_date__c = (System.today() + 3), 
                                                                                                    Show_For__c = showFor,
                                                                                                    Submission_Type__c = submissionType);
            
        }
        
               
        return backgroundSubmission;
    }
    
    
    public static void createQuestionsForLicense(String applicationType, String credentialTypeOrProgramArea, String credentialorPermitType,String applicationMethod){
         Id recTypeId = [SELECT Id FROM RecordType WHERE Name =: DOL_AppConstants.NULL_EMPTY_STRING + 'Background Questions' AND SObjectType =: DOL_AppConstants.NULL_EMPTY_STRING + 'Question__c' LIMIT 1].Id;

        // Parent question record
        Question__c queObj = new Question__c();
        queObj.Question_Body__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Q1';
        queObj.Data_Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Yes_No';
        queObj.Application_Type__c = applicationType;
        queObj.Credential_Type__c = credentialTypeOrProgramArea ;
        queObj.Credential__c = credentialorPermitType;
        queObj.Application_Method__c = applicationMethod;
        queObj.Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Active';
        queObj.Version__c = 1.0;
        queObj.Show_For__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Credential; Credential Renewal; Credential Reinstatement';
        queObj.RecordTypeId = recTypeId;
        queObj.Effective_Date__c = system.today().addDays(-10);
        queObj.End_Date__c = system.today().addDays(10);
        queObj.Allow_Multiple_Question_Groups__c = true;
        queObj.External_Id__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Test_001';
        insert queObj;
       

        // Child question record
        Question__c qObj = new Question__c();
        qObj.Question_Body__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Q3';
        qObj.Parent_Question__c = queObj.Id;
        qObj.Data_Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Yes_No';
        qObj.Application_Type__c = applicationType;
        qObj.Credential_Type__c = credentialTypeOrProgramArea ;
        qObj.Credential__c = credentialorPermitType;
        qObj.Application_Method__c = applicationMethod;
        qObj.Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Active';
        qObj.Version__c = 1.0;
        qObj.Show_For__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Credential; Credential Renewal; Credential Reinstatement';
        qObj.RecordTypeId = recTypeId;
        qObj.External_Id__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Test_003';
        insert qObj;
        
    }
    /**
    * Method name   : createSubmission
    * Description   : method for creating test submission
    * Return Type   : MUSW__Submission__c
    * Parameter     : none
    **/
    
    public static MUSW__Submission__c createSubmission()
    {
        MUSW__Submission__c s =new MUSW__Submission__c();
        s.Name = DOL_AppConstants.NULL_EMPTY_STRING + 'Test submission';
        
        return s;
    }

    
    /**
    * Method name   : createCommunityUser
    * Description   : Method to create test CommunityUser
    * Return Type   : User
    * Parameter     : Contact
    **/
    public static User createCommunityUser(Id contactId) {
        Profile profile = [SELECT id FROM Profile WHERE name =: DOL_AppConstants.NULL_EMPTY_STRING + 'eSLA Customer Community Login User'];
        User communityUser = new User(Alias= DOL_AppConstants.NULL_EMPTY_STRING + 'tuser', Email= DOL_AppConstants.NULL_EMPTY_STRING + 'tuser@mailinator.com', Username= DOL_AppConstants.NULL_EMPTY_STRING + 'tuser@mailinator.com', LastName= DOL_AppConstants.NULL_EMPTY_STRING + 'new', 
                                      CommunityNickname= DOL_AppConstants.NULL_EMPTY_STRING + 'testuser', ContactId = contactId, TimeZoneSidKey = DOL_AppConstants.NULL_EMPTY_STRING + 'America/Chicago',
                                      LocaleSidKey= DOL_AppConstants.NULL_EMPTY_STRING + 'en_US', EmailEncodingKey= DOL_AppConstants.NULL_EMPTY_STRING + 'UTF-8', 
                                      ProfileId = profile.Id, LanguageLocaleKey= DOL_AppConstants.NULL_EMPTY_STRING + 'en_US', IsActive= true);
        return communityUser;
    }
    
       
     public static User createBackendUser() {

         
         Profile profile = [SELECT id FROM Profile WHERE name =: DOL_AppConstants.NULL_EMPTY_STRING + 'eSLA DIS Super User'];
        UserRole roled= [Select id from UserRole where name=: DOL_AppConstants.NULL_EMPTY_STRING + 'DIS Division Administrator'];
        User communityUser = new User(Alias= DOL_AppConstants.NULL_EMPTY_STRING + 'tugcler', Email= DOL_AppConstants.NULL_EMPTY_STRING + 'tcvcvcvuser@mailinatogr.com', Username= DOL_AppConstants.NULL_EMPTY_STRING + 'tgdfdfdcvcvcvfdser@mailinator.com', LastName= DOL_AppConstants.NULL_EMPTY_STRING + 'negw', 
                                      CommunityNickname= DOL_AppConstants.NULL_EMPTY_STRING + 'tescvcvvtuser2', TimeZoneSidKey = DOL_AppConstants.NULL_EMPTY_STRING + 'America/Chicago',
                                      LocaleSidKey= DOL_AppConstants.NULL_EMPTY_STRING + 'en_US', EmailEncodingKey= DOL_AppConstants.NULL_EMPTY_STRING + 'UTF-8',userroleid=roled.Id, 
                                      ProfileId = profile.Id, LanguageLocaleKey= DOL_AppConstants.NULL_EMPTY_STRING + 'en_US', IsActive= true);
        return communityUser;
    }
    
         public static User createBackendUser2() {
        Profile profile = [SELECT id FROM Profile WHERE name =: DOL_AppConstants.NULL_EMPTY_STRING + 'eSLA DIS Super User'];
         UserRole roled= [Select id from UserRole where name=: DOL_AppConstants.NULL_EMPTY_STRING + 'DIS Division Administrator'];
        User communityUser = new User(Alias= DOL_AppConstants.NULL_EMPTY_STRING + 'tuasler', Email= DOL_AppConstants.NULL_EMPTY_STRING + 'tcvcvsdsdcvsuser@mailinatogr.com', Username= DOL_AppConstants.NULL_EMPTY_STRING + 'fdsser@mailtor.com', LastName= DOL_AppConstants.NULL_EMPTY_STRING + 'nsdw', 
                                      CommunityNickname= DOL_AppConstants.NULL_EMPTY_STRING + 'tescvcsasaser2', TimeZoneSidKey = DOL_AppConstants.NULL_EMPTY_STRING + 'America/Chicago',
                                      LocaleSidKey= DOL_AppConstants.NULL_EMPTY_STRING + 'en_US', EmailEncodingKey= DOL_AppConstants.NULL_EMPTY_STRING + 'UTF-8',userroleid=roled.Id, 
                                      ProfileId = profile.Id, LanguageLocaleKey= DOL_AppConstants.NULL_EMPTY_STRING + 'en_US', IsActive= true);
        return communityUser;
    }
    
    /**
    * Method name   : createCommunityPlusUser
    * Description   : method for creating test community Plus user
    * Return Type   : user
    * Parameter     : Contact id
    **/
    
    public static user createCommunityPlusUser(Id contactid){
        
        //create test user
        Profile p = [SELECT Id FROM Profile WHERE Name=: DOL_AppConstants.NULL_EMPTY_STRING + 'eSLA Customer Community Plus Login User'];
        User u1 = new User(Alias = DOL_AppConstants.NULL_EMPTY_STRING + 'standa', Email= DOL_AppConstants.NULL_EMPTY_STRING + 'saplingstandarduser@testorg.com',
                           EmailEncodingKey= DOL_AppConstants.NULL_EMPTY_STRING + 'UTF-8', LastName= DOL_AppConstants.NULL_EMPTY_STRING + 'Testing', LanguageLocaleKey= DOL_AppConstants.NULL_EMPTY_STRING + 'en_US',
                           LocaleSidKey= DOL_AppConstants.NULL_EMPTY_STRING + 'en_US', ProfileId = p.Id, ContactId = contactid,
                           TimeZoneSidKey= DOL_AppConstants.NULL_EMPTY_STRING + 'America/Los_Angeles', UserName= DOL_AppConstants.NULL_EMPTY_STRING + 'saplingstandarduser@testorg.com');
       
        return u1;
    }
    
    
    /**
    * Method name   : CommunityUser(Password Locked)
    * Description   : Method to create test CommunityUser
    * Return Type   : User
    * Parameter     : Contact
    *
    public static User communityUserLocked(Id userId) {
        UserLogin lockedUser = new UserLogin(IsPasswordLocked=true, UserId=userId);
        return lockedUser;
    } */
    
    /**
    * Method name   : createMultipleLicenses
    * Description   : Method to create multiple test licenses based on the number provided from test class
    * Return Type   : List<MUSW__License2__c>
    * Parameter     : Number of licenses to create, Account Id and Contact Id
    **/
    public static List<MUSW__License2__c> createMultipleLicenses(integer numOfLicensesToCreate, String licenseType1, String licenseType2, Id accountId, Id contactId) {
        
        List<MUSW__License2__c> licenseList = new List<MUSW__License2__c>();
        
        if(numOfLicensesToCreate > 1){            
            String licenseType = licenseType1;
            String nonUSCitizen = DOL_AppConstants.NULL_EMPTY_STRING + 'Yes';
            for(integer i = 0; i < numOfLicensesToCreate; i++){
                if(math.mod(i,2) != 0){
                    licenseType = licenseType2;
                    nonUSCitizen = DOL_AppConstants.NULL_EMPTY_STRING + 'No';
                }
                MUSW__License2__c license = new MUSW__License2__c(musw__type__c = licenseType, musw__status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Pending', MUSW__Primary_Licensee__c = accountId, MUSW__Applicant__c = contactId, Non_US_Citizen__c = nonUSCitizen);
                licenseList.add(license);            
            }
        }        
        
        return licenseList;
    }
    
    /**
    * Method name   : createContactParcel
    * Description   : method for creating test Contact parcel object
    * Return Type   : MUSW__Parcel__c
    * Parameter     : Contact id,String street, String city, String state, String zip, String country
    **/
    
    public static MUSW__Parcel__c createContactParcel(Id cid, String street, String city, String state, String zip, String country){
        MUSW__Parcel__c p = new MUSW__Parcel__c(MUSW__Primary_Contact__c = cid);
        p.MUSW__Street2__c = street;
        p.MUSW__City__c = city;
        p.MUSW__State__c = state;
        p.MUSW__Post_Zip_Code__c = zip;
        p.Country__c = country;
        
        return p;
    }
    
        /**
    * Method name   : createParcelContactJunction
    * Description   : method for creating test Contact parcel junction object
    * Return Type   : MUSW__Parcel_Contact2__c
    * Parameter     : Parcel id, Contact id
    **/
    
    public static MUSW__Parcel_Contact2__c createParcelContactJunction(Id pid, Id cid){
        MUSW__Parcel_Contact2__c pc = new MUSW__Parcel_Contact2__c(MUSW__Contact__c =cid, MUSW__Parcel__c = pid);
        
        return pc;
    }
    
        /**
    * Method name   : createParcelAccountJunction
    * Description   : method for creating test Account parcel junction object
    * Return Type   : Parcel_Account__c
    * Parameter     : Parcel id, Account id
    **/
    public static Parcel_Account__c createParcelAccountJunction(Id pid, Id aid){
        Parcel_Account__c pc = new Parcel_Account__c(Account__c =aid, Parcel__c = pid);
        
        return pc;
    }
    
        /**
    * Method name   : createCitizenAccount
    * Description   : method for creating test citizen account
    * Return Type   : Account
    * Parameter     : none
    **/
    public static Account createCitizenAccount(){
        
         //Step 1 : Data Insertion
        
        Account acc1 = new Account(name= DOL_AppConstants.NULL_EMPTY_STRING + 'CITIZEN');
        
        return acc1;
        
        
    }
    
    /**
    * Method name   : createCommunityTestUser
    * Description   : method for creating test community user
    * Return Type   : user
    * Parameter     : Contact id
    **/
    
    public static user createCommunityTestUser(Id contactid){
        
        //create test user
        Profile p = [SELECT Id FROM Profile WHERE Name=: DOL_AppConstants.NULL_EMPTY_STRING + 'eSLA Customer Community Login User'];
        User u1 = new User(Alias = DOL_AppConstants.NULL_EMPTY_STRING + 'standa', Email= DOL_AppConstants.NULL_EMPTY_STRING + 'saplingstandarduser@testorg.com',
                           EmailEncodingKey= DOL_AppConstants.NULL_EMPTY_STRING + 'UTF-8', LastName= DOL_AppConstants.NULL_EMPTY_STRING + 'Testing', LanguageLocaleKey= DOL_AppConstants.NULL_EMPTY_STRING + 'en_US',
                           LocaleSidKey= DOL_AppConstants.NULL_EMPTY_STRING + 'en_US', ProfileId = p.Id, ContactId = contactid,
                           TimeZoneSidKey= DOL_AppConstants.NULL_EMPTY_STRING + 'America/Los_Angeles', UserName= DOL_AppConstants.NULL_EMPTY_STRING + 'saplingstandarduser@testorg.com');
        //  u1.ProfileID = [Select Id From Profile Where Name= DOL_AppConstants.NULL_EMPTY_STRING + 'Some Profile'].id
       
        return u1;
    }
    
    /**
    * Method name   : createServiceRequest
    * Description   : method for creating test service request
    * Return Type   : MUSW__Application2__c
    * Parameter     : none
    **/
    
    public static MUSW__Application2__c createServiceRequest()
    {
        Id recordTypeId = Schema.SObjectType.MUSW__Application2__c.getRecordTypeInfosByName().get('General Service Request').getRecordTypeId();
        MUSW__Application2__c sr = new MUSW__Application2__c();
        sr.RecordTypeId = recordTypeId;
        sr.Credential__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Dwelling Contractor';
        sr.Credential_Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Dwelling Contractor';
        sr.MUSW__Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Change in Status';
        
        return sr;
    }

    
    public static void createPageDefinition(String pageName, String board, String sType,String appType) {

        //License__c = true means that the object is available for License Application
        // create a page
        Application_Page__c p = new Application_Page__c();
        p.Name = pageName;
           p.Application_Type__c = appType;
        p.Credential_Type__c = board;
        p.Credential__c = sType;
        p.License__c = true;
        p.Permit__c = true;
        p.License_Renewal__c = true;
        p.License_Reinstatement__c = true;
        insert p;
    
        Application_Section__c s = new Application_Section__c();
        s.Name = DOL_AppConstants.NULL_EMPTY_STRING + 'Personal Information Test';
        s.Parent__c = p.Id;
        s.Order_Number__c = 1;
        s.License__c = true;
        s.Permit__c = true;
        s.License_Renewal__c = true;
        s.License_Reinstatement__c = true;
        insert s;
    
         List<Application_SubSection__c> sub_sections = new List<Application_SubSection__c>();        
        // create a subsection
        Application_SubSection__c ss = new Application_SubSection__c();
        ss.Name = DOL_AppConstants.NULL_EMPTY_STRING + 'Personal Information Subsection Test';
        ss.Active__c = true;
        ss.Description__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Personal Information Subsection Description';
        ss.Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Fieldset';
        ss.Order_Number__c = 1;
        ss.Parent__c = s.Id;
        ss.License__c = true;
        ss.Permit__c = true;
        ss.License_Renewal__c = true;
        sub_sections.add(ss);
    
            // create a public address subsection - that is display after the above section
        Application_SubSection__c addrBSubSec1 = new Application_SubSection__c();
        addrBSubSec1.Name = DOL_AppConstants.NULL_EMPTY_STRING + 'public';
        addrBSubSec1.Active__c = true;
        addrBSubSec1.Description__c = DOL_AppConstants.NULL_EMPTY_STRING + 'public';
        addrBSubSec1.Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Component';
        addrBSubSec1.Order_Number__c = 2;
        addrBSubSec1.Parent__c = s.Id;
        addrBSubSec1.License__c = true;
        addrBSubSec1.Permit__c = true;
        addrBSubSec1.Component_Name__c = DOL_AppConstants.NULL_EMPTY_STRING + 'BusinessAddress';
        sub_sections.add(addrBSubSec1);
    
            // create a public address subsection - that is display after the above section
        Application_SubSection__c addrBSubSec4 = new Application_SubSection__c();
        addrBSubSec4.Name = DOL_AppConstants.NULL_EMPTY_STRING + 'Mailing';
        addrBSubSec4.Active__c = true;
        addrBSubSec4.Description__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Mailing';
        addrBSubSec4.Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Component';
        addrBSubSec4.Order_Number__c = 2;
        addrBSubSec4.Parent__c = s.Id;
        addrBSubSec4.License__c = true;
        addrBSubSec4.Permit__c = true;
        addrBSubSec4.Component_Name__c = DOL_AppConstants.NULL_EMPTY_STRING + 'BusinessAddress';
        sub_sections.add(addrBSubSec4);
    
        Application_SubSection__c edComp = new Application_SubSection__c();
        edComp.Name = DOL_AppConstants.NULL_EMPTY_STRING + 'Educational Comp';
        edComp.Active__c = true;
        edComp.Description__c = DOL_AppConstants.NULL_EMPTY_STRING + 'EducationHistoryComp';
        edComp.Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Component';
        edComp.Order_Number__c = 3;
        edComp.Parent__c = s.Id;
        edComp.License__c = true;
        edComp.Permit__c = true;
        edComp.Component_Name__c = DOL_AppConstants.NULL_EMPTY_STRING + 'EducationHistoryComp';
        sub_sections.add(edComp);
        
        Application_SubSection__c dacComp = new Application_SubSection__c();
        dacComp.Name = DOL_AppConstants.NULL_EMPTY_STRING + 'DelegatedAgentComponent';
        dacComp.Active__c = true;
        dacComp.Description__c = DOL_AppConstants.NULL_EMPTY_STRING + 'DelegatedAgentComponent';
        dacComp.Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Component';
        dacComp.Order_Number__c = 3;
        dacComp.Parent__c = s.Id;
        dacComp.License__c = true;
        dacComp.Permit__c = true;
        dacComp.Component_Name__c = DOL_AppConstants.NULL_EMPTY_STRING + 'DelegatedAgentComponent';
        sub_sections.add(dacComp);
        
        
        Application_SubSection__c coComp = new Application_SubSection__c();
        coComp.Name = DOL_AppConstants.NULL_EMPTY_STRING + 'CoownershipComponent';
        coComp.Active__c = true;
        coComp.Description__c = DOL_AppConstants.NULL_EMPTY_STRING + 'CoownershipComponent';
        coComp.Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Component';
        coComp.Order_Number__c = 3;
        coComp.Parent__c = s.Id;
        coComp.License__c = true;
        coComp.Permit__c = true;
        coComp.Component_Name__c = DOL_AppConstants.NULL_EMPTY_STRING + 'CoownershipComponent';
        sub_sections.add(coComp);
    
        Application_SubSection__c empComp = new Application_SubSection__c();
        empComp.Name = DOL_AppConstants.NULL_EMPTY_STRING + 'EmploymentHistoryComp';
        empComp.Active__c = true;
        empComp.Description__c = DOL_AppConstants.NULL_EMPTY_STRING + 'EmploymentHistoryComp';
        empComp.Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Component';
        empComp.Order_Number__c = 4;
        empComp.Parent__c = s.Id;
        empComp.License__c = true;
        empComp.Permit__c = true;
        empComp.Component_Name__c = DOL_AppConstants.NULL_EMPTY_STRING + 'EmploymentHistoryComp';
        sub_sections.add(empComp);
    
        Application_SubSection__c resHisComp = new Application_SubSection__c();
        resHisComp.Name = DOL_AppConstants.NULL_EMPTY_STRING + 'LicenseVerificationComp';
        resHisComp.Active__c = true;
        resHisComp.Description__c = DOL_AppConstants.NULL_EMPTY_STRING + 'LicenseVerificationComp';
        resHisComp.Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Component';
        resHisComp.Order_Number__c = 5;
        resHisComp.Parent__c = s.Id;
        resHisComp.License__c = true;
        resHisComp.Component_Name__c = DOL_AppConstants.NULL_EMPTY_STRING + 'LicenseVerificationComp';    
        sub_sections.add(resHisComp);
        
        Application_SubSection__c DelegatedAgentComponent = new Application_SubSection__c();
        DelegatedAgentComponent.Name = DOL_AppConstants.NULL_EMPTY_STRING + 'DelegatedAgentComponent';
DelegatedAgentComponent.Active__c = true;
        DelegatedAgentComponent.Description__c = DOL_AppConstants.NULL_EMPTY_STRING + 'DelegatedAgentComponent';
        DelegatedAgentComponent.Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Component';
        DelegatedAgentComponent.Order_Number__c = 6;
        DelegatedAgentComponent.Parent__c = s.Id;
        DelegatedAgentComponent.License__c = true;
        DelegatedAgentComponent.Component_Name__c = DOL_AppConstants.NULL_EMPTY_STRING + 'DelegatedAgentComponent';    
        sub_sections.add(DelegatedAgentComponent);
        
            Application_SubSection__c CoownershipComponent = new Application_SubSection__c();
        CoownershipComponent.Name = DOL_AppConstants.NULL_EMPTY_STRING + 'CoownershipComponent';
CoownershipComponent.Active__c = true;
        CoownershipComponent.Description__c = DOL_AppConstants.NULL_EMPTY_STRING + 'CoownershipComponent';
        CoownershipComponent.Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Component';
        CoownershipComponent.Order_Number__c = 6;
        CoownershipComponent.Parent__c = s.Id;
        CoownershipComponent.License__c = true;
        CoownershipComponent.Component_Name__c = DOL_AppConstants.NULL_EMPTY_STRING + 'CoownershipComponent';    
        sub_sections.add(CoownershipComponent);
    
    Application_SubSection__c queHisComp = new Application_SubSection__c();
        queHisComp.Name = DOL_AppConstants.NULL_EMPTY_STRING + 'QuestionAnswer';
        queHisComp.Active__c = true;
        queHisComp.Description__c = DOL_AppConstants.NULL_EMPTY_STRING + 'QuestionAnswer';
        queHisComp.Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Component';
        queHisComp.Order_Number__c = 7;
        queHisComp.Parent__c = s.Id;
        queHisComp.License__c = true;
        queHisComp.Component_Name__c = DOL_AppConstants.NULL_EMPTY_STRING + 'QuestionAnswer';    
        sub_sections.add(queHisComp);
    
    Application_SubSection__c attHisComp = new Application_SubSection__c();
        attHisComp.Name = DOL_AppConstants.NULL_EMPTY_STRING + 'AttachmentsComp';
        attHisComp.Active__c = true;
        attHisComp.Description__c = DOL_AppConstants.NULL_EMPTY_STRING + 'AttachmentsComp';
        attHisComp.Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Component';
        attHisComp.Order_Number__c = 8;
        attHisComp.Parent__c = s.Id;
        attHisComp.License__c = true;
        attHisComp.Component_Name__c = DOL_AppConstants.NULL_EMPTY_STRING + 'AttachmentsComp';    
        sub_sections.add(attHisComp);
    
      upsert sub_sections;
        Application_Field__c f =  new Application_Field__c();
        f.Label__c = DOL_AppConstants.NULL_EMPTY_STRING + 'MUSW__Status__c';
        f.Name = DOL_AppConstants.NULL_EMPTY_STRING + 'MUSW__Status__c';
        f.Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Text';
        f.Parent__c = ss.Id;
        f.License__c = true;
        f.Object_Name__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Main Object';
        insert f;
        
        Application_Field__c field =  new Application_Field__c();
        field.Label__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Community_Name__c';
        field.Name = DOL_AppConstants.NULL_EMPTY_STRING + 'Community_Name__c';
        field.Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Text';
        field.Parent__c = ss.Id;
        field.Required__c = true;
        field.License_Renewal__c=true;
        field.Object_Name__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Parent of Main Object';
        insert field;

        // create fields
        Application_Field__c f2 =  new Application_Field__c();
        f2.Label__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Title';
        f2.Name = DOL_AppConstants.NULL_EMPTY_STRING + 'Title';
        f2.Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Text';
        f2.Parent__c = ss.Id;
        f2.License__c = true;
        f2.Object_Name__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Contact';
        insert f2;
        
        f2 =  new Application_Field__c();
        f2.Label__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Name';
        f2.Name = DOL_AppConstants.NULL_EMPTY_STRING + 'Name';
        f2.Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Text';
        f2.Parent__c = ss.Id;
        f2.License__c = true;
        f2.Object_Name__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Account';
        insert f2;
        

    }
    
     public static void createPageDefinitionPermit(String pageName, String board, String sType,String appType) {

                 Newsfeed__c news= new Newsfeed__c();
        news.Application_Type__c=appType;
        news.Instructions__c= DOL_AppConstants.NULL_EMPTY_STRING + 'lmao';
        news.Program_Area__c=board;
        news.Permit_Type__c=pageName;
         newS.external_id__C=pageName+label.RT_Attestation_Line;
        news.RecordTypeId= Utilities.getRecordTypeForName('Newsfeed__c',label.RT_Attestation_Line);  
        news.Show_For__c=label.Str_Permit;
        insert news;
         
        Newsfeed__c news2= new Newsfeed__c();
        news2.Application_Type__c=appType;
        news2.Instructions__c= DOL_AppConstants.NULL_EMPTY_STRING + 'lmao';
        news2.Program_Area__c=board;
        news2.Permit_Type__c=pageName;
                  newS2.External_Id__c=pageName+label.RT_Affidavit_Link;
        news2.RecordTypeId= Utilities.getRecordTypeForName('Newsfeed__c',label.RT_Affidavit_Link); 
        news2.Show_For__c=label.Str_Permit;
        insert news2;
         
        //License__c = true means that the object is available for License Application
        // create a page
        Application_Page__c p = new Application_Page__c();
        p.Name = pageName;
           p.Application_Type__c = appType;
        p.Program_Area__c = board;
        p.Permit_Type__c = sType;
        p.License__c = true;
        p.Permit__c = true;
        p.License_Renewal__c = true;
         p.Permit_Renewal__c =true;
        p.License_Reinstatement__c = true;
        insert p;
    
        Application_Section__c s = new Application_Section__c();
        s.Name = DOL_AppConstants.NULL_EMPTY_STRING + 'Personal Information Test';
        s.Parent__c = p.Id;
        s.Order_Number__c = 1;
        s.License__c = true;
        s.Permit__c = true;
        s.License_Renewal__c = true;
        s.License_Reinstatement__c = true;
                  s.Permit_Renewal__c =true;
        insert s;
    
         List<Application_SubSection__c> sub_sections = new List<Application_SubSection__c>();        
        // create a subsection
        Application_SubSection__c ss = new Application_SubSection__c();
        ss.Name = DOL_AppConstants.NULL_EMPTY_STRING + 'Personal Information Subsection Test';
        ss.Active__c = true;
        ss.Description__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Personal Information Subsection Description';
        ss.Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Fieldset';
        ss.Order_Number__c = 1;
        ss.Parent__c = s.Id;
        ss.License__c = true;
        ss.Permit__c = true;
                ss.Permit_Renewal__c =true;
        ss.License_Renewal__c = true;
        sub_sections.add(ss);
    
            // create a public address subsection - that is display after the above section
        Application_SubSection__c addrBSubSec1 = new Application_SubSection__c();
        addrBSubSec1.Name = DOL_AppConstants.NULL_EMPTY_STRING + 'public';
        addrBSubSec1.Active__c = true;
        addrBSubSec1.Description__c = DOL_AppConstants.NULL_EMPTY_STRING + 'public';
        addrBSubSec1.Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Component';
        addrBSubSec1.Order_Number__c = 2;
        addrBSubSec1.Parent__c = s.Id;
        addrBSubSec1.License__c = true;
        addrBSubSec1.Permit__c = true;
                addrBSubSec1.Permit_Renewal__c =true;
        addrBSubSec1.Component_Name__c = DOL_AppConstants.NULL_EMPTY_STRING + 'BusinessAddress';
        sub_sections.add(addrBSubSec1);
    
            // create a public address subsection - that is display after the above section
        Application_SubSection__c addrBSubSec4 = new Application_SubSection__c();
        addrBSubSec4.Name = DOL_AppConstants.NULL_EMPTY_STRING + 'Mailing';
        addrBSubSec4.Active__c = true;
        addrBSubSec4.Description__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Mailing';
        addrBSubSec4.Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Component';
        addrBSubSec4.Order_Number__c = 2;
        addrBSubSec4.Parent__c = s.Id;
        addrBSubSec4.License__c = true;
               addrBSubSec4.Permit_Renewal__c =true;
        addrBSubSec4.Permit__c = true;
        addrBSubSec4.Component_Name__c = DOL_AppConstants.NULL_EMPTY_STRING + 'BusinessAddress';
        sub_sections.add(addrBSubSec4);
   
         Application_SubSection__c podComp = new Application_SubSection__c();
        podComp.Name = DOL_AppConstants.NULL_EMPTY_STRING + 'POWTSOwnerDesigner';
        podComp.Active__c = true;
        podComp.Description__c = DOL_AppConstants.NULL_EMPTY_STRING + 'POWTSOwnerDesigner';
        podComp.Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Component';
        podComp.Order_Number__c = 3;
        podComp.Parent__c = s.Id;
        podComp.License__c = true;
             podComp.Permit_Renewal__c =true;
        podComp.Permit__c = true;
        podComp.Component_Name__c = DOL_AppConstants.NULL_EMPTY_STRING + 'POWTSOwnerDesigner';
        sub_sections.add(podComp);
         
        Application_SubSection__c revComp = new Application_SubSection__c();
        revComp.Name = DOL_AppConstants.NULL_EMPTY_STRING + 'ReviewAndSubmitNoAffidavit';
        revComp.Active__c = true;
        revComp.Description__c = DOL_AppConstants.NULL_EMPTY_STRING + 'ReviewAndSubmitNoAffidavit';
        revComp.Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Component';
        revComp.Order_Number__c = 3;
        revComp.Parent__c = s.Id;
        revComp.License__c = true;
        revComp.Permit__c = true;
            revComp.Permit_Renewal__c =true;
        revComp.Component_Name__c = DOL_AppConstants.NULL_EMPTY_STRING + 'ReviewAndSubmitNoAffidavit';
        sub_sections.add(revComp);
         
         Application_SubSection__c picComp = new Application_SubSection__c();
        picComp.Name = DOL_AppConstants.NULL_EMPTY_STRING + 'ProjectInformationComponent';
        picComp.Active__c = true;
        picComp.Description__c = DOL_AppConstants.NULL_EMPTY_STRING + 'ProjectInformationComponent';
        picComp.Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Component';
        picComp.Order_Number__c = 3;
        picComp.Parent__c = s.Id;
        picComp.License__c = true;
        picComp.Permit__c = true;
           picComp.Permit_Renewal__c =true;
        picComp.Component_Name__c = DOL_AppConstants.NULL_EMPTY_STRING + 'ProjectInformationComponent';
        sub_sections.add(picComp);
         
    Application_SubSection__c queHisComp = new Application_SubSection__c();
        queHisComp.Name = DOL_AppConstants.NULL_EMPTY_STRING + 'QuestionAnswer';
        queHisComp.Active__c = true;
        queHisComp.Description__c = DOL_AppConstants.NULL_EMPTY_STRING + 'QuestionAnswer';
        queHisComp.Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Component';
        queHisComp.Order_Number__c = 4;
        queHisComp.Parent__c = s.Id;
        queHisComp.License__c = true;
               queHisComp.Permit_Renewal__c =true;
        queHisComp.Component_Name__c = DOL_AppConstants.NULL_EMPTY_STRING + 'QuestionAnswer';    
        sub_sections.add(queHisComp);
    
    Application_SubSection__c attHisComp = new Application_SubSection__c();
        attHisComp.Name = DOL_AppConstants.NULL_EMPTY_STRING + 'AttachmentsComp';
        attHisComp.Active__c = true;
        attHisComp.Description__c = DOL_AppConstants.NULL_EMPTY_STRING + 'AttachmentsComp';
        attHisComp.Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Component';
        attHisComp.Order_Number__c = 4;
        attHisComp.Parent__c = s.Id;
          attHisComp.Permit_Renewal__c =true;
        attHisComp.License__c = true;
        attHisComp.Component_Name__c = DOL_AppConstants.NULL_EMPTY_STRING + 'AttachmentsComp';    
        sub_sections.add(attHisComp);
    
      upsert sub_sections;
        Application_Field__c f =  new Application_Field__c();
        f.Label__c = DOL_AppConstants.NULL_EMPTY_STRING + 'MUSW__Status__c';
        f.Name = DOL_AppConstants.NULL_EMPTY_STRING + 'MUSW__Status__c';
        f.Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Text';
        f.Parent__c = ss.Id;
        f.License__c = true;
          f.Permit_Renewal__c =true;
        f.Object_Name__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Main Object';
        insert f;

        // create fields
        Application_Field__c f2 =  new Application_Field__c();
        f2.Label__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Title';
        f2.Name = DOL_AppConstants.NULL_EMPTY_STRING + 'Title';
        f2.Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Text';
          f2.Permit_Renewal__c =true;
        f2.Parent__c = ss.Id;
        f2.License__c = true;
        f2.Object_Name__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Contact';
        insert f2;



    }

      public static void createPageDefinitionServiceRequest(String pageName,String sType) {

        //License__c = true means that the object is available for License Application
        // create a page
        Application_Page__c p = new Application_Page__c();
        p.Name = pageName;
        p.Service_Request_Type__c   =sType;
        p.Service_Request__c = true;
        insert p;
    
        Application_Section__c s = new Application_Section__c();
        s.Name = DOL_AppConstants.NULL_EMPTY_STRING + 'Exam Information';
        s.Parent__c = p.Id;
        s.Order_Number__c = 1;
        p.Service_Request__c = true;
        insert s;
    
         List<Application_SubSection__c> sub_sections = new List<Application_SubSection__c>();        
        // create a subsection
        Application_SubSection__c ss = new Application_SubSection__c();
        ss.Name = DOL_AppConstants.NULL_EMPTY_STRING + 'Personal Information Subsection Test';
        ss.Active__c = true;
        ss.Description__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Personal Information Subsection Description';
        ss.Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Fieldset';
        ss.Order_Number__c = 1;
        ss.Parent__c = s.Id;
        ss.Service_Request__c = true;
        sub_sections.add(ss);
   
        
        Application_SubSection__c revComp = new Application_SubSection__c();
        revComp.Name = DOL_AppConstants.NULL_EMPTY_STRING + 'ReviewAndSubmitNoAffidavit';
        revComp.Active__c = true;
        revComp.Description__c = DOL_AppConstants.NULL_EMPTY_STRING + 'ReviewAndSubmitNoAffidavit';
        revComp.Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Component';
        revComp.Order_Number__c = 3;
        revComp.Parent__c = s.Id;
       revComp.Service_Request__c = true;
        revComp.Component_Name__c = DOL_AppConstants.NULL_EMPTY_STRING + 'ReviewAndSubmitNoAffidavit';
        sub_sections.add(revComp);
         
              Application_SubSection__c SRParentRecordDetails = new Application_SubSection__c();
        SRParentRecordDetails.Name = DOL_AppConstants.NULL_EMPTY_STRING + 'SRParentRecordDetails';
        SRParentRecordDetails.Active__c = true;
        SRParentRecordDetails.Description__c = DOL_AppConstants.NULL_EMPTY_STRING + 'SRParentRecordDetails';

        SRParentRecordDetails.Order_Number__c = 4;
        SRParentRecordDetails.Parent__c = s.Id;
       revComp.Service_Request__c = true;
        SRParentRecordDetails.Component_Name__c = DOL_AppConstants.NULL_EMPTY_STRING + 'SRParentRecordDetails';    
        sub_sections.add(SRParentRecordDetails);
             
      upsert sub_sections;
        // create fields
        Application_Field__c f2 =  new Application_Field__c();
        f2.Label__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Reason_for_Submitting_Service_Request__c';
        f2.Name = DOL_AppConstants.NULL_EMPTY_STRING + 'Reason_for_Submitting_Service_Request__c';
        f2.Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Text';
        f2.Parent__c = ss.Id;
        f2.Service_Request__c = true;
        f2.Object_Name__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Main Object';
        f2.Required__c = true;
        insert f2;



    }

    
}
