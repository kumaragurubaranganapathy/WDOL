@isTest
public class DOL_TestDataFactory {
    //method for creating account
    public static Account createAccount(Id recordTypeId) {
        Account acc = new Account(Name= 'Test Account');
        acc.Bus_Id__c = DOL_AppConstants.NULL_EMPTY_STRING+'3';
        acc.RecordTypeId = recordTypeId;
        insert acc;
        return acc;
    }
    
    //method for creating contact
    public static Contact createContact(Id recordTypeId, Id accId) {
        Contact con = new Contact(LastName= 'Test Contact');
        con.RecordTypeId = recordTypeId;
        con.AccountId = accId;
        con.Unique_ID_To_Provide__c = 'SSN';
        con.Social_Security_Number_Encrypted__c ='516143176';
        insert con;
        return con;
    }
    
    //method to create Account Contact
    public static MUSW__Account_Contact__c createAccountContact(Id conId, Id accId){
        MUSW__Account_Contact__c accCon = new MUSW__Account_Contact__c(First_Name__c = 'FirstName', 
                                                                       Last_Name__c = 'LastName', 
                                                                       Title__c = 'Mrs.', 
                                                                       Email__c = 'firstlastname@mailinator.com',
                                                                       MUSW__Account__c=accId,  
                                                                       MUSW__Contact__c=conId );
        insert accCon;
        return accCon;
    }
    
    //method to create Account Contact
    public static MUSW__Account_Contact__c createAccountContact(){
        MUSW__Account_Contact__c accCon = new MUSW__Account_Contact__c(First_Name__c = 'FirstName', 
                                                                       Last_Name__c = 'LastName', 
                                                                       Title__c = 'Mrs.', 
                                                                       Email__c = 'firstlastname@mailinator.com');
        insert accCon;
        return accCon;
    }
    
    public static Contact createContactWithLastName(Id recordTypeId, Id accId,String lastName) {
        Contact con = new Contact(LastName= lastName);
        con.RecordTypeId = recordTypeId;
        con.AccountId = accId;
        con.Unique_ID_To_Provide__c = 'SSN';
        con.Social_Security_Number_Encrypted__c ='543128855';
        insert con;
        return con;
    }
    
    //method for creating License
    public static MUSW__License2__c createLicense(Id recordTypeId, Id accId,String programType, String licenseType,String applicationMethod){
        MUSW__License2__c license = new MUSW__License2__c(Name='System Number', RecordTypeId = recordTypeId,MUSW__Primary_Licensee__c = accId, Application_Type__c = programType,Credential_Type__c = licenseType,Application_Method__c = applicationMethod,Manual_Fee_Generation__c = true);
        insert license;
        return license;
    }
    
    //
        //method for creating License
    public static MUSW__License2__c createLicenseIndividual(Id recordTypeId, Id accId,String programType, String licenseType,String applicationMethod){
        MUSW__License2__c license = new MUSW__License2__c(MUSW__Status__c='Active',Name='System Number', RecordTypeId = recordTypeId,MUSW__Applicant__c = accId, Application_Type__c = programType,Credential_Type__c = licenseType,Application_Method__c = applicationMethod,Manual_Fee_Generation__c = true);
        insert license;
        return license;
    }
    
    //
    //method for creating Association
    public static Associations__c createAssociation(Id licId){
        Associations__c association = new Associations__c(Association_Type__c = 'Designated Architect', Parent_License__c = licId, Child_License__c = licId, Status__c = 'Pending Add');
        insert association;
        return association;
    }
    
    //method for creating Request
    public static Request__c createRequest(Id licId, String applicationType, String licenseType){
        Request__c request = new Request__c(License__c = licId, Profession__c = applicationType, License_Type__c = licenseType);
        insert request;
        return request;
    }
    
    //method for creating Permit
    public static MUSW__Permit2__c createPermit(Id recordType){
        MUSW__Permit2__c permit = new MUSW__Permit2__c(RecordTypeId = recordType, Name = 'System Number', MUSW__Type__c = 'Building', MUSW__Status__c = 'Pending', Application_Type__c = 'Collection Agency', Program_Area__c = 'Manufactured Homes Communities');
        insert permit;
        return permit;
    }
    
    //method for creating fee
    public static MUSW__Fee__c createFee(String type, Decimal amount){
        MUSW__Fee__c fee = new MUSW__Fee__c(MUSW__Type__c = type, MUSW__Amount__c = amount);
        insert fee;
        return fee;
    }
    
    //method for creating fee with license
    public static MUSW__Fee__c createFeeWithLicense(String type, Decimal amount, Id licenseId){
        MUSW__Fee__c fee = new MUSW__Fee__c(MUSW__Type__c = type, MUSW__Amount__c = amount,MUSW__License2__c = licenseId);
        insert fee;
        return fee;
    }
    
    //method for creating CashRegister with arguments
    public static Cash_Register__c createValidationRoomCashRegister(Id recordTypeId,Decimal cash, Decimal check, Decimal vouchers, Decimal vitalCheck){
        Cash_Register__c cashRegister = new Cash_Register__c(RecordTypeId = recordTypeId);
        cashRegister.Total_Amount_of_Cash__c = cash;
        cashRegister.Total_Amount_of_Cheque__c = check;
        cashRegister.Total_Amount_for_Vouchers__c = vouchers;
        cashRegister.Total_from_Vitalcheck__c = vitalCheck;
        try{
            insert cashRegister;
            return cashRegister;
        }catch(Exception ex){
            system.debug('Exception in cash register::'+ex.getStackTraceString());
            return null;
        }
    }
    
    //method for creating CashRegister w/o arguments
    public static Cash_Register__c createCashRegister(Id recordTypeId){
        Cash_Register__c cashRegister = new Cash_Register__c(RecordTypeId = recordTypeId);
        insert cashRegister;
        return cashRegister;
    }
    
    //method for creating receipt
    public static MUSW__Receipt__c createReceipt(String paymentMethod,Decimal amount, String intakeMethod){
        MUSW__Receipt__c receipt = new MUSW__Receipt__c(MUSW__Payment_Method__c =paymentMethod ,MUSW__Amount_Tendered__c =amount,Intake_Method__c=intakeMethod);
        try{
            insert receipt;
            return receipt;
        }catch(Exception ex){
            system.debug('Exception in Receipt::'+ex.getStackTraceString());
            return null;
        }
        
    }
    //Create Cart Record
    public static BGBK__Cart__c createCartRecord(Id paymentBatchId){
        BGBK__Cart__c cartRecord = new BGBK__Cart__c(Name='X-2019-08-01_05-50-00',BGBK__BG_Payment_Batch__c = paymentBatchId);
        insert cartRecord;
        return cartRecord;
    }
    
    //Insert Global Setting for trigger blocking
    public static Global_Settings__c createGlobalSetting(String Name, Boolean disableTrigger){
        Global_Settings__c globalSetting = new Global_Settings__c(Name = Name, Disable_Triggers__c = disableTrigger);
        insert globalSetting;
        return globalSetting;
    }
    
    //Insert Parcel
    public static MUSW__Parcel__c createParcel(Id recordTypeId){
        MUSW__Parcel__c par = new MUSW__Parcel__c(RecordTypeId = recordTypeId, International_Address__c = '345 Street', Country__c = 'Canada', Status__c = 'Active');
        insert par;
        return par;
    }
    
    //Insert License Parcel
    public static MUSW__License_Parcel__c createLicenseParcel(Id license, Id parcel){
        MUSW__License_Parcel__c licenseParcel = new MUSW__License_Parcel__c(MUSW__License2__c = license, MUSW__Parcel__c = parcel, Mailing__c = false, Physical__c = false, Public__c = false);
        insert licenseParcel;
        return licenseParcel;
    }
    
    //Insert Payment Batch with CashRegister
    public static BGBK__Payment_Batch__c createPaymentBatch(Id cashRegister){
        BGBK__Payment_Batch__c pb = new BGBK__Payment_Batch__c(Name = 'Test PB',Cash_Register__c = cashRegister);
        insert pb;
        return pb;        
    }
    // Create Submission
    public static MUSW__Submission__c createSubmission(Id licenseId){
        MUSW__Submission__c submission = new MUSW__Submission__c();
        submission.MUSW__BG_File_Location_Type__c = 'Salesforce';
        submission.IsSANFileUploadTrue__c = True;
        submission.SAN_Image_Type__c = 'Applications';
        submission.Name = 'Test Submission';
        submission.MUSW__License2__c = licenseId;
        insert submission;
        return submission;
       
    }
    //insert background sections
    public static LnP_BackgroundSection__c createBackgroundSection(){
        LnP_BackgroundSection__c bgSection = new LnP_BackgroundSection__c(Name = 'TestBackground');
        bgSection.Renewal_Reinstatement_Application__c = 'test';
        bgSection.Start_Date__c = Date.newInstance(2015, 05, 29);
        bgSection.Job_Title__c= 'JOB';
        bgSection.Employer__c= 'EMPLOYER';
        bgSection.End_date__c= Date.newInstance(2019, 05, 29);
        bgSection.Total_Hours__c= 12;
        bgSection.Street_Address__c= 'test Addresss';
        bgSection.County__c= 'Adams';
        bgSection.State__c= 'Washington';
        bgSection.Country__c= 'United States';
        bgSection.City__c= 'OLYMPIA';
        bgSection.Zip_code__c= '22132';
        bgSection.Status__c= 'Pending';
        bgSection.Name_of_Institution__c= 'Institution';
        bgSection.Degree__c= 'Degree';
        bgSection.Minor__c= 'Yes';
        bgSection.Major__c= 'Yes';
        insert bgSection;
        return bgSection;
    }
    
    //insert Deposit
    public static List<MUSW__Deposit__c> createDeposit(String ProgramType){
        List<MUSW__Deposit__c> depList = new List<MUSW__Deposit__c>();
        depList.add(new MUSW__Deposit__c(Name='System Number',wadol_Program_Type__c= ProgramType,MUSW__Amount__c = 100));
        insert depList;
        return depList;
    }
    
    //insert Portal Arctile
    public static Portal_Article__c createPortalArticle(String status, String displayPage, Id recordType){
        Portal_Article__c portalArticle = new Portal_Article__c(Article_Title__c='Test Article',RecordTypeId = recordType, Article_Status__c = status, Display_Page__c = displayPage);
        insert portalArticle;
        return portalArticle;
    }
    
    //Insert Complaint record
    public static MUSW__Complaint2__c createComplaintRecord(String programType, String status, Id licenseobjId){
        MUSW__Complaint2__c complaintRecord = new MUSW__Complaint2__c(Name='Complaint'+System.Now(), Program_Type__c=programType, MUSW__Status__c=status, License__c=licenseobjId);
        insert complaintRecord;
        return complaintRecord;
    }
    
    //insert Refund
    public static BGBK__Refund2__c createRefund(){
        BGBK__Refund2__c ref = new BGBK__Refund2__c(BGBK__Amount__c = 100);
        insert ref;
        return ref;
    }
    
    //Create Receipt refund
    public static BGBK__Receipt_Refund__c createReceiptRefund(Id refId,Id recId, Id depId){
        BGBK__Receipt_Refund__c recRef = new BGBK__Receipt_Refund__c(BGBK__Refund2__c = refId,BGBK__Receipt__c = recId,BGBK__Deposit__c = depId,BGBK__Amount__c = 100);
        insert recRef;
        return recRef;
    }
    
    //Create User
    public static User createUser(String lastName, String aliasName, Id profileId,String emailId,Id contactId ){
        User newUser = new User(
            profileId = profileId,
            username = emailId,
            email = emailId,
            emailencodingkey = 'UTF-8',
            localesidkey = 'en_US',
            languagelocalekey = 'en_US',
            timezonesidkey = 'America/Los_Angeles',
            alias=aliasName,
            lastname=lastName,
            contactId = contactId);
        return newUser;
        
    }
    
    //Create Portal User
    public static User createPortalUser(String lastName, String aliasName, Id profileId,String emailId,Id contactId ){
        //UserRole ur = [Select Id, PortalType, PortalAccountId From UserRole where PortalType = 'Customer User' limit 1];
        User newUser = new User(
                                profileId = profileId,
                                username = 'newUser'+emailId,
                                email = emailId,
                                emailencodingkey = 'UTF-8',
                                localesidkey = 'en_US',
                                languagelocalekey = 'en_US',
                                timezonesidkey = 'America/Los_Angeles',
                                alias=aliasName,
                                lastname=lastName,
                                contactId = contactId);
        return newUser;
            
    }
    public static User createPortalAccountUser(){
        
        //system.debug('portalRole is ' + portalRole);
        UserRole ur = new UserRole(Name = 'AdminRole');
        insert ur;
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
            UserRoleId = ur.Id,
            ProfileId = profile1.Id,
            //role = 'Manager',
            Username = System.now().millisecond() + 'test2@test.com',
            Alias = 'batman',
            Email='bruce.wayne@wayneenterprises.com',
            EmailEncodingKey='UTF-8',
            Firstname='Bruce',
            Lastname='Wayne',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago'
        );
        Database.insert(portalAccountOwner1);
        
        //User u1 = [Select ID From User Where Id =: portalAccountOwner1.Id];
        User user1;
        
        System.runAs ( portalAccountOwner1 ) {
            //Create account
           
            Account portalAccount1 = new Account(
                Name = 'TestAccount',
                OwnerId = portalAccountOwner1.Id
            );
            Database.insert(portalAccount1);
            
            //Create contact
            Contact contact1 = new Contact(
                FirstName = 'Test',
                Lastname = 'McTesty',
                AccountId = portalAccount1.Id,
                Unique_ID_To_Provide__c = 'No_SSN_or_ITIN',
                Email = System.now().millisecond() + 'test@test.com',
                BusinessCartToOpen__c = portalAccount1.Id
            );
            Database.insert(contact1);
            
            //Create user
            Profile portalProfile = [SELECT Id FROM Profile where Name = 'eSLA Customer Community Plus Login User'];
            user1 = new User(
                Username = System.now().millisecond() + 'test12345@test.com',
                ContactId = contact1.Id,
               // UserRoleId = portalRole.Id,
                ProfileId = portalProfile.Id,
                Alias = 'test123',
                Email = 'TestDataTest@test.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'McTesty',
                CommunityNickname = 'test12345',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US'
            );
            Database.insert(user1);
        }
        return user1;
    }
    
    //Insert Question
    public static Question__c createQuestion(Id recTypeId){
        
        Question__c ques = new Question__c();
        ques.Question_Body__c = 'Total number of full months of experience in real estate appraising';
        ques.Data_Type__c = 'Text';
        ques.Parent_Object_API_Name__c = 'MUSW__License2__c';
        ques.RecordTypeId = recTypeId;
        ques.Application_Type__c = 'Notary Public';
        ques.External_Id__c = 'abc123';
        ques.QuestionFieldAPI__c = 'Name';
        insert ques;
        return ques;
    }
    
    //create Answer
    public static Answer__c createAnswer(Id licId,Id quesId){
        Answer__c ans = new Answer__c();
        ans.Answer_Text__c  ='72';
        ans.License__c = licId;
        ans.Question__c = quesId;
        insert ans;
        return ans;
            
    }
    
    //Create Renewal Application
    public static Renewal_Application__c createRenewalApplication(Id recTypeId, Id licId){
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
        insert reApp;
        return reApp;
    }
    
    //Create Application
    public static MUSW__Application2__c createApplication(Id recTypeId){
        MUSW__Application2__c app = new MUSW__Application2__c(recordTypeId = recTypeId, Name='System Number');
        insert app;
        return app;
    }
    
    //create Application Page
    public static Application_Page__c createApplicationPage(String applicationType, String licenseType){
        Application_Page__c applicationPage = new Application_Page__c(Name = licenseType+' App Page', Application_Type__c = applicationType, Credential__c = licenseType, Credential_Type__c = licenseType);
        insert applicationPage;
        return applicationPage;
    }
    
    //create Application Section 
    public static Application_Section__c createApplicationSection(String applicationType, String licenseType){
        Application_Page__c applicationPage = DOL_TestDataFactory.createApplicationPage(applicationType, licenseType);
        Application_Section__c applicationSection = new Application_Section__c(Name = licenseType, Parent__c = applicationPage.Id);
        insert applicationSection;
        return applicationSection;
    }
    
    //create Application Subsection
    public static Application_Subsection__c createApplicationSubSection(String applicationType, String licenseType){
        Application_Section__c applicationSection = DOL_TestDataFactory.createApplicationSection(applicationType, licenseType);
        Application_Subsection__c applicationSubSection = new Application_Subsection__c(Name = licenseType, Parent__c = applicationSection.Id, Active__c=true, Component_Name__c = 'BusinessAddress', Required__c=true);
        insert applicationSubSection;
        return applicationSubSection;
    }
    
    //create Application Field
    public static Application_Field__c createApplicationField(String name, String applicationType, String licenseType, String objName){
        Application_Subsection__c appSubSec = DOL_TestDataFactory.createApplicationSubSection(applicationType, licenseType);
        Application_Field__c appField = new Application_Field__c(Name = name, Parent__c = appSubSec.Id, Required__c = true, Object_Name__c = objName, Application_Type__c = applicationType, Credential_Type__c = licenseType);
        insert appField;
        return appField;
    }
        
        
    //create Endorsement
    public static Endorsement__c createEndorsement(Id licId,String status){
        Endorsement__c endo = new Endorsement__c();
        endo.License__c = licId;
        endo.Status__c = status;
        endo.Date_Requested_for_Adding_Endorsement__c = system.today();
        endo.Endorsement_Type__c = 'Nuclear';
        insert endo;
        return endo;
    }
    
    //create Electronic_Notary_Provider_Information__c
    public static Electronic_Notary_Provider_Information__c createElectronicProviderInfo(Id endoId){
        Electronic_Notary_Provider_Information__c enpi = new Electronic_Notary_Provider_Information__c();
        enpi.Provider_Name__c = 'Docusign';
        enpi.Effective_Date__c = system.today();
        enpi.Endorsement__c = endoId;
        insert enpi;
        return enpi;
    }

    //create Permit Parcel record
    public static MUSW__Permit_Parcel__c createPermitParcel(Id permit, Id parcel){
        MUSW__Permit_Parcel__c permPar = new MUSW__Permit_Parcel__c(MUSW__Permit2__c = permit, Mailing__c = true, Public__c = true, Physical__c = true, MUSW__Parcel__c = parcel);
        insert permPar;
        return permPar;
    }
    
    //Create Resource Record
    public static Resource__c createResoureRecord(){
        Resource__c res = new Resource__c();
        res.Active__c = true;
        res.User__c = userInfo.getUserId();
        res.Application_Type__c='Program Unknown';
        res.County__c='Green Bay';
        res.Plan_Review_Types__c='POWTS Individual Site Design';
        res.Remote__c=true;
        res.Software__c=true;
        res.Training__c=true;
        insert res;
        return res;
    }
    
     //Create Resource Week Availablity Records
    public static Resource_Week_Availability__c createResourceWeekAvailRecord(Id resourceId){
        Resource_Week_Availability__c rwavail = new Resource_Week_Availability__c();
        rwavail.Autorenewal__c =true;
        rwavail.Backend_User__c=userInfo.getUserId();
        rwavail.Resource__c = resourceId;
        rwavail.Schedule_Valid_From__c = system.today();
        rwavail.Schedule_Valid_till__c = system.today()+8;
        insert rwavail;
        return rwavail;
    }      
        
    //Create Resource Availabilty Records
    public static Resource_Availability__c createResourceAvailRecord(Id resourceWeekAvail, Id resourceId){
        Resource_Availability__c resAvail = new Resource_Availability__c();
        resAvail.AutoRenewal__c = true;
        resAvail.Day__c='Monday';
        resAvail.Backend_User__c=userInfo.getUserId();
        resAvail.Resource__c=resourceId;
        resAvail.Resource_Week_Availability__c=resourceWeekAvail;
        insert resAvail;
        return resAvail;
    }
    
    //Create TimeSlot records
    public static Time_Slot__c createTimeSlotRecord(Id resourceId){
        Time_Slot__c timeSlot = new Time_Slot__c();
        timeSlot.Start_Time__c= system.now();
        timeSlot.Resource__c=resourceId;
        timeSlot.End_Time__c = system.today()+2;
        insert timeSlot;
        return timeSlot;
    }
    
    //Create Reinstatement Eligibility Recorcd
    public static Renewal_Reinstatement_Eligibility__c createReinstateEligibilityRecord(){
        Renewal_Reinstatement_Eligibility__c rene = new  Renewal_Reinstatement_Eligibility__c();
        rene.Active__c = true ;
        rene.Reinstatement_Eligible_End_Date__c = 5;
        rene.License_Type__c = 'Geologist';
        rene.Renewal_Grace_Period_N_Days_After_Expiry__c = 120;
        rene.Renewal_Eligible_N_Days_Before_Expiry__c = 120;
        rene.Late_Ren_Eligible_Until_N_Days_After_Exp__c = 120;
        rene.Credential_Or_Permit__c = 'Credential';  
        rene.Program_Type__c ='Geologist';
        rene.External_Id__c = 'teste1';
        insert rene;
        return rene;
    }
    
    //Create an Inspection Record
    public static MUSW__Inspection__c createInspection(Id recordTypeId, String type, String programType, String credType){
        MUSW__Inspection__c inspec = new MUSW__Inspection__c(Name = 'System Number', RecordTypeId = recordTypeId, MUSW__Type__c = type, Application_Type__c = programType, Credential_Type__c = credType, MUSW__Status__c = 'Pending');
        insert inspec;
        return inspec;
    }
    
    //Create a Violation Record
    public static MUSW__Violation__c createViolation(Id recordTypeId){
        MUSW__Violation__c violation = new MUSW__Violation__c(RecordTypeId = recordTypeId);
        insert violation;
        return violation;
    }
    
    //Create an Inspection_Violation record
    public static MUSW__Inspection_Violation__c createInspectionViolation(Id inpectionId, Id violationId){
        MUSW__Inspection_Violation__c inspVio = new MUSW__Inspection_Violation__c(MUSW__Inspection__c = inpectionId, MUSW__Violation__c = violationId);
        insert inspVio;
        return inspVio;
    }
    
    // create Generic Questions 
    public static Question__c createQuestionData(String qBody,String dataType,String ObjectName,String AppType,String CredType,String ExtrnlId,String QueFieldAPI,String AppMethod,String showFor,String queSubSection,String SubHeader,String Section,String RecordTypeId,Boolean isRequired,String responses){
        Question__c ques = new Question__c();
        ques.Question_Body__c = qBody;
        ques.Data_Type__c = dataType;
        ques.Parent_Object_API_Name__c = ObjectName;
        ques.Application_Type__c = AppType;
        ques.Credential_Type__c = CredType;
        ques.External_Id__c = ExtrnlId;
        ques.QuestionFieldAPI__c = QueFieldAPI;
        ques.Application_Method__c = AppMethod;
        ques.status__c = 'Active';
        ques.Show_For__c = showFor;
        ques.Sub_Sub_Header__c = SubHeader;
        ques.Section__c = Section;
        ques.RecordTypeId = RecordTypeId;
        ques.QuestionObjectName__c = ques.Parent_Object_API_Name__c;
        ques.isRequired__c = isRequired;
        ques.Possible_Responses__c = responses;
        ques.Effective_Date__c = System.today() -1 ;
        insert ques;
        return ques;
    }
  
  // to create generic answers   
   public static BGCK__Answer__c createAnswersGeneric(Boolean valid,String ansText,Id QueId,Id appId){
        BGCK__Answer__c answ = new BGCK__Answer__c();
        answ.BGCK__Valid__c = valid;
        answ.Answer_Text__c = ansText;
        answ.QuestionDOL__c = QueId;
        answ.Application_BG__c = appId;
        insert answ;
        return answ;
    }
    
    public static Employment_History__c getEmploymentHistory(Id recId, Id licId){
        Employment_History__c empHistory = new Employment_History__c();
        empHistory.License__c = licId;
        empHistory.Employer__c = DOL_AppConstants.NULL_EMPTY_STRING+'Test Employer';
        insert empHistory;
        return empHistory;
    }
        
}//Class End