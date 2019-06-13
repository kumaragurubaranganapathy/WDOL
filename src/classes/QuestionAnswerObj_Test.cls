@isTest
public class QuestionAnswerObj_Test {

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
        license1.Application_Type__c = 'Manufactured Homes'; 
        license1.Credential_type__c = 'Manufactured Homes Credential';
        license1.Credential__c = 'Manufactured Homes Installer';
        license1.Application_Method__c = 'Course Completion';
        insert license1;
        
        Musw__Permit2__c permit1 = CreateTestDataUtility.createPermit(acc.Id, con.Id);
        permit1.Application_Type__c = 'Plan Review';
        permit1.Permit_Type__c = 'POWTS Petition for Variance'; 
        permit1.Program_Area__c = 'POWTS'; 
        permit1.MUSW__Status__c = 'Pending';
        insert permit1;
        
        MUSW__Application2__c sr = CreateTestDataUtility.createServiceRequest();
        sr.Credential__c = 'Manufactured Homes Installer';
        sr.Credential_Type__c = 'Manufactured Homes Credential';
        sr.MUSW__Type__c = 'Exam Re-Application';
        sr.License__c = license1.Id;
        sr.MUSW__Applicant__c = con.Id;
        insert sr;
        
        // Get question record type
        Id recTypeId = [SELECT Id FROM RecordType WHERE Name = 'Background Questions' AND SObjectType = 'Question__c' LIMIT 1].Id;

        // Parent question record
        Question__c queObj = new Question__c();
        queObj.Question_Body__c = 'Q1';
        queObj.Data_Type__c = 'Yes_No';
        queObj.Application_Type__c = 'Manufactured Homes';
        queObj.Credential_Type__c = 'Manufactured Homes Titling';
        queObj.Credential__c = 'Manufactured Homes Certificate of Title';
        queObj.Application_Method__c = 'All';
        queObj.Status__c = 'Active';
        queObj.Version__c = 1.0;
        queObj.Show_For__c = 'Credential';
        queObj.RecordTypeId = recTypeId;
        queObj.Effective_Date__c = system.today().addDays(-10);
        queObj.End_Date__c = system.today().addDays(10);
        queObj.Allow_Multiple_Question_Groups__c = true;
        queObj.External_Id__c = 'Test_001';
        insert queObj;
        
        Question__c queObj2 = new Question__c();
        queObj2.Question_Body__c = 'Q1';
        queObj2.Data_Type__c = 'Yes_No';
        queObj2.Permit_Type__c = 'POWTS Petition for Variance'; 
        queObj2.Program_Area__c = 'POWTS';
        queObj2.Application_Type__c = 'Plan Review';
        queObj2.Application_Method__c = 'All';
        queObj2.Status__c = 'Active';
        queObj2.Version__c = 1.0;
        queObj2.Show_For__c = Label.Str_Permit;
        queObj2.RecordTypeId = recTypeId;
        queObj2.Effective_Date__c = system.today().addDays(-10);
        queObj2.Allow_Multiple_Question_Groups__c = true;
        queObj2.External_Id__c = 'Test_002';
        insert queObj2;
        
        Question__c queObj3 = new Question__c();
        queObj3.Question_Body__c = 'Q1';
        queObj3.Data_Type__c = 'Yes_No';
        queObj3.Application_Type__c = 'Manufactured Homes';
        queObj3.Credential_Type__c = 'Manufactured Homes Titling';
        queObj3.Credential__c = 'Manufactured Homes Certificate of Title';
        queObj3.Application_Method__c = 'All';
        queObj3.Service_Request_Type__c = 'Exam Re-Application';
        queObj3.Status__c = 'Active';
        queObj3.Version__c = 1.0;
        queObj3.Show_For__c = 'Service Request';
        queObj3.RecordTypeId = recTypeId;
        queObj3.Effective_Date__c = system.today();
        queObj3.End_Date__c = system.today();
        queObj3.Allow_Multiple_Question_Groups__c = true;
        queObj3.External_Id__c = 'TestSR_001';
        insert queObj3;

        // Child question record
        Question__c qObj = new Question__c();
        qObj.Question_Body__c = 'Q3';
        qObj.Parent_Question__c = queObj.Id;
        qObj.Data_Type__c = 'Yes_No';
        qObj.Application_Type__c = 'Manufactured Homes';
        qObj.Credential_Type__c = 'Manufactured Homes Titling';
        qObj.Credential__c = 'Manufactured Homes Certificate of Title';
        qObj.Application_Method__c = 'All';
        qObj.Status__c = 'Active';
        qObj.Version__c = 1.0;
        qObj.Show_For__c = 'Credential';
        qObj.RecordTypeId = recTypeId;
        qObj.External_Id__c = 'Test_003';
        insert qObj;
        
        Question__c qObj2 = new Question__c();
        qObj2.Question_Body__c = 'Q3';
        qObj2.Parent_Question__c = queObj2.Id;
        qObj2.Data_Type__c = 'Yes_No';
        qObj2.Permit_Type__c = 'POWTS Petition for Variance'; 
        qObj2.Program_Area__c = 'POWTS';
        qObj2.Application_Type__c = 'Plan Review';
        qObj2.Application_Method__c = 'All';
        qObj2.Status__c = 'Active';
        qObj2.Version__c = 1.0;
        qObj2.Show_For__c = Label.Str_Permit;
        qObj2.RecordTypeId = recTypeId;
        qObj2.External_Id__c = 'Test_004';
        insert qObj2;
        
        Question__c qObj3 = new Question__c();
        qObj3.Question_Body__c = 'Q3';
        qObj3.Parent_Question__c = queObj.Id;
        qObj3.Data_Type__c = 'Yes_No';
        qObj3.Application_Type__c = 'Manufactured Homes';
        qObj3.Credential_Type__c = 'Manufactured Homes Titling';
        qObj3.Credential__c = 'Manufactured Homes Certificate of Title';
        qObj3.Application_Method__c = 'All';
        qObj3.Service_Request_Type__c = 'Exam Re-Application';
        qObj3.Show_For__c = 'Service Request';
        qObj3.Status__c = 'Active';
        qObj3.Version__c = 1.0;
        qObj3.Show_For__c = 'Credential';
        qObj3.RecordTypeId = recTypeId;
        qObj3.External_Id__c = 'TestSR_002';
        insert qObj3;
        
        globalSetting.Disable_Triggers__c = false;
        update globalSetting;
    }
    
    @isTest
    public static void testQuestions1(){
        MUSW__License2__c lic = [Select Id From MUSW__License2__c limit 1];
        QuestionAnswerObj q1 = new QuestionAnswerObj('Manufactured Homes', 'Manufactured Homes Titling', 'Manufactured Homes Certificate of Title', 'Transfer of Ownership', 'License__c', lic.Id);
        
        MUSW__Permit2__c per = [Select Id From MUSW__Permit2__c limit 1];
        QuestionAnswerObj q2 = new QuestionAnswerObj('Plan Review', 'POWTS', 'POWTS Petition for Variance', '', 'Permit__c', per.Id);
        
        MUSW__Application2__c sr = [Select Id From MUSW__Application2__c limit 1];
        QuestionAnswerObj q3 = new QuestionAnswerObj('Service Request', 'Manufactured Homes Titling', 'Manufactured Homes Certificate of Title', 'Transfer of Ownership', 'Service_Request__c', sr.Id, 'Exam Re-Application');
        
        Question__c queObj = [Select Id, Data_Type__c, Application_type__c, Application_Method__c, Credential_Type__c, Credential__c, Permit_Type__c, Program_Area__c, 
                             	 Parent_Question__c,Question_Body__c, Triggering_Field_API_Name__c, Parent_Object_API_Name__c, Triggering_Parent_Answer__c, 
                                External_Id__c, Triggering_Comment_Box_Value__c, Triggering_Field_Value__c, Possible_Responses__c 
                              From Question__c limit 1];
          
        QuestionAnswerObj.QuestionsGroup quesGroup = new QuestionAnswerObj.QuestionsGroup(queObj.Id, queObj.Data_Type__c, queObj.Application_type__c, 
                            queObj.Application_Method__c, queObj.Credential_Type__c, queObj.Credential__c, queObj.Permit_Type__c, queObj.Program_Area__c,
                                                queObj.Question_Body__c, queObj.Parent_Question__c, 
                                                queObj.Triggering_Field_API_Name__c, queObj.Parent_Object_API_Name__c, queObj.Triggering_Parent_Answer__c, 
                                                queObj.External_Id__c,queObj.Triggering_Comment_Box_Value__c, queObj.Triggering_Field_Value__c, 
                                                queObj.Possible_Responses__c);
    }
}