@isTest
public class SRAnsSubmissionTriggHandler_Test {
    @testSetup
    public static void setupTestData(){
        Global_Settings__c globalSetting = new Global_Settings__c(Name = UserInfo.getUsername(), Disable_Triggers__c = true);
        insert globalSetting;
        
        BGBK__CartSettings__c cartSettings = new BGBK__CartSettings__c(Name = 'Default', BGBK__Payable_Parents__c = 'MUSW__License2__c, MUSW__Application2__c, License_Renewal__c', BGBK__Payment_Gateway_Data_Encryption_Key__c = 'BasicGovPayments');
        insert cartSettings;
        
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
        license1.Application_Type__c = 'Trades Credential'; 
        license1.Credential_type__c = 'Soil Professions';
        license1.Credential__c = 'Soil Tester';
        license1.Application_Method__c = 'Examination';
        insert license1;
        
        List<Master_Review_List__c> masterReviewList = new List<Master_Review_List__c>();
        Master_Review_List__c masterReviewRecord1 = new Master_Review_List__c(Name = 'Test Record 1',
                                                                              Application_Type__c = 'Trades Credential',
                                                                              Estimated_Review_Completion_Time_Hours__c = 1.0,
                                                                              external_id__c = 'TR_1');
        masterReviewList.add(masterReviewRecord1);
        insert masterReviewList;
        
        MUSW__Application2__c sr = CreateTestDataUtility.createServiceRequest();
        sr.Credential__c = 'Soil Tester';
        sr.Credential_Type__c = 'Soil Professions';
        sr.MUSW__Type__c = 'Exam Re-Application';
        sr.License__c = license1.Id;
        sr.MUSW__Applicant__c = con.Id;
        insert sr;
        
        // Get question record type
        Id recTypeId = [SELECT Id FROM RecordType WHERE Name = 'Background Questions' AND SObjectType = 'Question__c' LIMIT 1].Id;
        //List<Question__c> questionsToInsert = new List<Question__c>();
        // Parent question record
        
        // Parent question record
        Question__c queObj1A = new Question__c();
        queObj1A.Question_Body__c = 'Q1A';
        queObj1A.Data_Type__c = 'Yes_No';
        queObj1A.Application_Type__c = 'Trades Credential';
        queObj1A.Credential_Type__c = 'Soil Professions';
        queObj1A.Credential__c = 'Soil Tester';
        queObj1A.Application_Method__c = 'Examination';
        //queObj1A.Service_Request_Type__c = 'Exam Re-Application';
        queObj1A.Status__c = 'Active';
        queObj1A.Version__c = 1.0;
        queObj1A.Order_Number__c = 1;
        queObj1A.Possible_Responses__c = 'Yes;No;';
        queObj1A.Expected_Answer_Parent_Field_Value_Map__c = 'Yes=TRUE;No=FALSE;';
        queObj1A.Show_For__c = 'Service Request';
        queObj1A.RecordTypeId = recTypeId;
        queObj1A.Effective_Date__c = system.today().addDays(-10);
        queObj1A.End_Date__c = system.today().addDays(10);
        //queObj1A.Allow_Multiple_Question_Groups__c = true;
        //queObj1A.Question_Group__c = 'QG__001A';
        queObj1A.External_Id__c = 'Test_001A';
        queObj1A.Parent_Object_API_Name__c = 'MUSW__Application2__c';
        queObj1A.Parent_Object_Field_API_Name__c = 'Special_Accommodation_Request__c';
        insert queObj1A;
        
        Question__c queObj2A = new Question__c();
        queObj2A.Question_Body__c = 'Q2A';
        queObj2A.Data_Type__c = 'Yes_No';
        queObj2A.Application_Type__c = 'Trades Credential';
        queObj2A.Credential_Type__c = 'Uniform Dwelling Code';
        queObj2A.Credential__c = 'UDC Construction Inspector';
        queObj2A.Application_Method__c = 'Examination';
        //queObj2A.Service_Request_Type__c = 'Exam Re-Application';
        queObj2A.Status__c = 'Active';
        queObj2A.Version__c = 1.0;
        queObj2A.Order_Number__c = 1;
        queObj2A.Possible_Responses__c = 'Yes;No;';
        queObj2A.Expected_Answer_Parent_Field_Value_Map__c = 'Yes=TRUE;No=FALSE;';
        queObj2A.Show_For__c = 'Service Request';
        queObj2A.RecordTypeId = recTypeId;
        queObj2A.Effective_Date__c = system.today().addDays(-10);
        queObj2A.End_Date__c = system.today().addDays(10);
        //queObj1A.Allow_Multiple_Question_Groups__c = true;
        //queObj1A.Question_Group__c = 'QG__001A';
        queObj2A.External_Id__c = 'Test_002A';
        queObj2A.Parent_Object_API_Name__c = 'MUSW__Application2__c';
        queObj2A.Parent_Object_Field_API_Name__c = 'Special_Accommodation_Request__c';
        insert queObj2A;
        
        Answer__c answer1A = new Answer__c();
        answer1A.Question__c = queObj1A.id;
        answer1A.Service_Request__c = sr.Id;
        answer1A.Answer_Text__c = 'Yes';
        answer1A.Question_Body__c = queObj1A.Question_Body__c;
        answer1A.External_id_of_Question__c = queObj1A.External_Id__c;
        answer1A.Answer_Group__c = queObj1A.Question_Group__c+'-1';
        insert answer1A;
        
        MUSW__Master_Submission_List__c msl1 = new MUSW__Master_Submission_List__c();
        msl1.Name ='Special Accommodations Documentation';
        msl1.Title__c ='Special Accommodations Documentation';
        msl1.Application_Type__c = 'Trades Credential';
        msl1.Credential_Type__c = 'Soil Professions';
        msl1.Credential__c = 'Soil Tester';
        msl1.Application_Method__c = 'Examination';
        msl1.BG_File_Location_Type__c = 'Salesforce';
       // msl1.Service_Request_Type__c = 'Exam Re-Application';
        msl1.Question__c = queObj1A.id;
        msl1.Expected_Answer__c = 'Yes';
        msl1.Effective_Start_Date__c = system.today().addDays(-10);
        msl1.Effective_End_Date__c = system.today().addDays(10);
        msl1.Show_For__c = 'Service Request'; 
        msl1.Object__c = 'MUSW__Application2__c';
        msl1.External_Id__c = 'Test_001S';
        msl1.Description_Long__c = 'Please provide detail of your request for special accommodations';
        msl1.Submission_Type__c = 'Softcopy: To be Uploaded';
        insert msl1;
        
        globalSetting.Disable_Triggers__c = false;
        update globalSetting;
    }
    
    @isTest
    public static void testSubmission1(){
        Test.startTest();
        Musw__License2__c lic = [Select Id from Musw__License2__c where Credential__c = 'Soil Tester' limit 1];
        MUSW__Application2__c sr1 = [Select Id From MUSW__Application2__c where License__c =: lic.Id limit 1];
        Question__c ques = [Select Id, Parent_Object_API_Name__c From Question__c where Credential__c = 'Soil Tester' limit 1];    
        Map<Id,Answer__c> newAnswerMap = new Map<Id,Answer__c>([Select Id From Answer__c where Question__c =: ques.Id limit 1]);
        system.debug('newAnswerMap>>>'+newAnswerMap);
        SRAnsSubmissionTriggHandler.updateSubmissionRecords(newAnswerMap);
        Test.stopTest();
    }
    
    @isTest
    public static void test02(){
        Test.startTest();
        Musw__License2__c lic = [Select Id from Musw__License2__c where Credential__c = 'Soil Tester' limit 1];
        MUSW__Application2__c sr1 = [Select Id From MUSW__Application2__c where License__c =: lic.Id limit 1];
        Question__c ques = [Select Id, Parent_Object_API_Name__c From Question__c where Credential__c = 'UDC Construction Inspector' limit 1];    
        Map<Id,Answer__c> newAnswerMap = new Map<Id,Answer__c>([Select Id From Answer__c where Question__c =: ques.Id limit 1]);
        system.debug('newAnswerMap>>>'+newAnswerMap);
        SRAnsSubmissionTriggHandler.updateSubmissionRecords(newAnswerMap);
        Test.stopTest();
    }
}