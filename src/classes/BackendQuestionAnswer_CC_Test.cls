@isTest
public class BackendQuestionAnswer_CC_Test {
    
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
        
        Renewal_Application__c credRenewal = CreateTestDataUtility.createRenewal(license1.Id, 'Manufactured Homes', 'Manufactured Homes Credential', 'Manufactured Homes Installer', 'Incomplete', 'Renewal');
        insert credRenewal;
        
        List<Master_Review_List__c> masterReviewList = new List<Master_Review_List__c>();
        Master_Review_List__c masterReviewRecord1 = new Master_Review_List__c(Name = 'Test Record 1',
                                                                             Application_Type__c = 'Manufactured Homes Communities',
                                                                             Permit_Type__c ='Manufactured Homes Community Permit',
                                                                             Estimated_Review_Completion_Time_Hours__c = 1.0,
                                                                             external_id__c = 'TR_1');
        masterReviewList.add(masterReviewRecord1);
        Master_Review_List__c masterReviewRecord2 = new Master_Review_List__c(Name = 'Test Record 2',
                                                                             Application_Type__c = 'Plan Review',
                                                                             Permit_Type__c ='POWTS Petition for Variance',
                                                                             Estimated_Review_Completion_Time_Hours__c = 1.0,
                                                                             external_id__c = 'TR_2');
        masterReviewList.add(masterReviewRecord2);
        insert masterReviewList;
        
        Musw__Permit2__c permit1 = CreateTestDataUtility.createPermit(acc.Id, con.Id);
        permit1.Application_Type__c = 'Plan Review';
        permit1.Permit_Type__c = 'POWTS Petition for Variance'; 
        permit1.Program_Area__c = 'POWTS'; 
        permit1.MUSW__Status__c = 'Pending';
        insert permit1;
        
        Renewal_Application__c permitRenewal = CreateTestDataUtility.createRenewal(permit1.Id, 'Plan Review', 'POWTS', 'POWTS Petition for Variance', 'Incomplete', 'Renewal PTO');
        insert permitRenewal;
        
        System.debug('permitRenewal id '+ permitRenewal.Id);
        
        MUSW__Application2__c sr = CreateTestDataUtility.createServiceRequest();
        sr.Credential__c = 'Manufactured Homes Installer';
        sr.Credential_Type__c = 'Manufactured Homes Credential';
        sr.MUSW__Type__c = 'Exam Re-Application';
        sr.License__c = license1.Id;
        sr.MUSW__Applicant__c = con.Id;
        insert sr;
        
        // Get question record type
        Id recTypeId = [SELECT Id FROM RecordType WHERE Name = 'Background Questions' AND SObjectType = 'Question__c' LIMIT 1].Id;
        //List<Question__c> questionsToInsert = new List<Question__c>();
        // Parent question record
        Question__c queObj = new Question__c();
        queObj.Question_Body__c = 'Q1';
        queObj.Data_Type__c = 'Yes_No';
        queObj.Application_Type__c = 'Manufactured Homes';
        queObj.Credential_Type__c = 'Manufactured Homes Credential';
        queObj.Credential__c = 'Manufactured Homes Installer';
        queObj.Application_Method__c = 'Course Completion';
        queObj.Status__c = 'Active';
        queObj.Version__c = 1.0;
        queObj.Order_Number__c = 1;
        queObj.Possible_Responses__c = 'Yes;No;';
        queObj.Expected_Answer_Parent_Field_Value_Map__c = 'Yes=Yes;No=No;';
        queObj.Show_For__c = 'Credential; Credential Renewal; Credential Reinstatement';
        queObj.RecordTypeId = recTypeId;
        queObj.Effective_Date__c = system.today().addDays(-10);
        queObj.End_Date__c = system.today().addDays(10);
        queObj.Allow_Multiple_Question_Groups__c = true;
        queObj.Question_Group__c = 'QG__001';
        queObj.External_Id__c = 'Test_001';
        insert queObj;
        //questionsToInsert.add(queObj);
        
        Question__c queObj2 = new Question__c();
        queObj2.Question_Body__c = 'Q2';
        queObj2.Data_Type__c = 'Yes_No';
        queObj2.Permit_Type__c = 'POWTS Petition for Variance'; 
        queObj2.Program_Area__c = 'POWTS';
        queObj2.Application_Type__c = 'Plan Review';
        queObj2.Application_Method__c = 'All';
        queObj2.Status__c = 'Active';
        queObj2.Version__c = 1.0;
        queObj2.Show_For__c = 'Permit; Permit Renewal; Permit Reinstatement';
        queObj2.RecordTypeId = recTypeId;
        queObj2.Effective_Date__c = system.today().addDays(-10);
        queObj2.Allow_Multiple_Question_Groups__c = true;
        queObj.Question_Group__c = 'QG__002';
        queObj2.External_Id__c = 'Test_002';
        insert queObj2;
        //questionsToInsert.add(queObj2);
        
        Question__c queObj3 = new Question__c();
        queObj3.Question_Body__c = 'Q3';
        queObj3.Data_Type__c = 'Yes_No';
        queObj3.Application_Type__c = 'Manufactured Homes';
        queObj3.Credential_Type__c = 'Manufactured Homes Credential';
        queObj3.Credential__c = 'Manufactured Homes Installer';
        queObj3.Application_Method__c = 'Course Completion';
        queObj3.Service_Request_Type__c = 'Exam Re-Application';
        queObj3.Status__c = 'Active';
        queObj3.Version__c = 1.0;
        queObj3.Show_For__c = 'Service Request';
        queObj3.RecordTypeId = recTypeId;
        queObj3.Effective_Date__c = system.today();
        queObj3.End_Date__c = system.today();
        queObj3.Allow_Multiple_Question_Groups__c = true;
        queObj.Question_Group__c = 'QG__003';
        queObj3.External_Id__c = 'TestSR_001';
        insert queObj3;
        //questionsToInsert.add(queObj3);

        // Child question record
        Question__c qObj = new Question__c();
        qObj.Question_Body__c = 'Q1c';
        qObj.Parent_Question__c = queObj.Id;
        qObj.Allow_Multiple_Question_Groups__c = true;
        //qObj.Child_Question_Group__c = queObj.Question_Group__c;
        qObj.Data_Type__c = 'Yes_No';
        qObj.Application_Type__c = 'Manufactured Homes';
        qObj.Credential_Type__c = 'Manufactured Homes Credential';
        qObj.Credential__c = 'Manufactured Homes Installer';
        qObj.Application_Method__c = 'Course Completion';
        qObj.Status__c = 'Active';
        qObj.Version__c = 1.0;
        qObj.Show_For__c = 'Credential; Credential Renewal; Credential Reinstatement';
        qObj.RecordTypeId = recTypeId;
        qObj.External_Id__c = 'Test_003';
        insert qObj;
        //questionsToInsert.add(qObj);
        
        Question__c qObj2 = new Question__c();
        qObj2.Question_Body__c = 'Q2c';
        qObj2.Parent_Question__c = queObj2.Id;
        qObj.Allow_Multiple_Question_Groups__c = true;
        //qObj.Child_Question_Group__c = queObj.Question_Group__c;
        qObj2.Data_Type__c = 'Yes_No';
        qObj2.Permit_Type__c = 'POWTS Petition for Variance'; 
        qObj2.Program_Area__c = 'POWTS';
        qObj2.Application_Type__c = 'Plan Review';
        qObj2.Application_Method__c = 'All';
        qObj2.Status__c = 'Active';
        qObj2.Version__c = 1.0;
        qObj2.Show_For__c = 'Permit; Permit Renewal; Permit Reinstatement';
        qObj2.RecordTypeId = recTypeId;
        qObj2.External_Id__c = 'Test_004';
        insert qObj2;
        //questionsToInsert.add(qObj2);
        
        Question__c qObj3 = new Question__c();
        qObj3.Question_Body__c = 'Q3c';
        qObj3.Parent_Question__c = queObj.Id;
        qObj3.Data_Type__c = 'Yes_No';
        qObj.Allow_Multiple_Question_Groups__c = true;
        qObj3.Application_Type__c = 'Manufactured Homes';
        qObj3.Credential_Type__c = 'Manufactured Homes Credential';
        qObj3.Credential__c = 'Manufactured Homes Installer';
        qObj3.Application_Method__c = 'Course Completion';
        qObj3.Service_Request_Type__c = 'Exam Re-Application';
        qObj3.Show_For__c = 'Service Request';
        qObj3.Status__c = 'Active';
        qObj3.Version__c = 1.0;
        qObj3.RecordTypeId = recTypeId;
        qObj3.External_Id__c = 'TestSR_002';
        insert qObj3;
        //questionsToInsert.add(qObj3);
        
        Question__c queObj4 = new Question__c();
        queObj4.Question_Body__c = 'Q4';
        queObj4.Data_Type__c = 'Yes_No';
        queObj4.Application_Type__c = 'Manufactured Homes';
        queObj4.Credential_Type__c = 'Manufactured Homes Credential';
        queObj4.Credential__c = 'Manufactured Homes Installer';
        queObj4.Application_Method__c = 'Course Completion';
        queObj4.Service_Request_Type__c = 'Exam Re-Application';
        queObj4.Status__c = 'Active';
        queObj4.Version__c = 1.0;
        queObj4.Show_For__c = 'Service Request';
        queObj4.RecordTypeId = recTypeId;
        queObj4.Effective_Date__c = system.today();
        queObj4.End_Date__c = null;
        queObj4.Allow_Multiple_Question_Groups__c = true;
        queObj4.Question_Group__c = 'QG__00x';
        queObj4.External_Id__c = 'TestSR_00x';
        insert queObj4;
        //questionsToInsert.add(queObj4);
        
        Question__c queObj5 = new Question__c();
        queObj5.Question_Body__c = 'Q5';
        queObj5.Data_Type__c = 'Yes_No';
        queObj5.Application_Type__c = 'Manufactured Homes';
        queObj5.Credential_Type__c = 'Manufactured Homes Credential';
        queObj5.Credential__c = 'Manufactured Homes Installer';
        queObj5.Application_Method__c = 'Course Completion';
        queObj5.Service_Request_Type__c = 'Exam Re-Application';
        queObj5.Status__c = 'Active';
        queObj5.Version__c = 1.0;
        queObj5.Show_For__c = 'Service Request';
        queObj5.RecordTypeId = recTypeId;
        queObj5.Effective_Date__c = null;
        queObj5.End_Date__c = system.today();
        queObj5.Allow_Multiple_Question_Groups__c = true;
        queObj5.Question_Group__c = 'QG__00y';
        queObj5.External_Id__c = 'TestSR_00y';
        insert queObj5;
        //questionsToInsert.add(queObj5);
        
        //insert questionsToInsert;
        
        /**************************insert questions with answers********************************/
        // Parent question record
        Question__c queObj1A = new Question__c();
        queObj1A.Question_Body__c = 'Q1A';
        queObj1A.Data_Type__c = 'Yes_No';
        queObj1A.Application_Type__c = 'Manufactured Homes';
        queObj1A.Credential_Type__c = 'Manufactured Homes Credential';
        queObj1A.Credential__c = 'Manufactured Homes Installer';
        queObj1A.Application_Method__c = 'Course Completion';
        queObj1A.Status__c = 'Active';
        queObj1A.Version__c = 1.0;
        queObj1A.Order_Number__c = 1;
        queObj1A.Possible_Responses__c = 'Yes;No;';
        queObj1A.Expected_Answer_Parent_Field_Value_Map__c = 'Yes=Yes;No=No;';
        queObj1A.Show_For__c = 'Credential; Credential Renewal; Credential Reinstatement';
        queObj1A.RecordTypeId = recTypeId;
        queObj1A.Effective_Date__c = system.today().addDays(-10);
        queObj1A.End_Date__c = system.today().addDays(10);
        queObj1A.Allow_Multiple_Question_Groups__c = true;
        queObj1A.Question_Group__c = 'QG__001A';
        queObj1A.External_Id__c = 'Test_001A';
        insert queObj1A;
        
        Answer__c answer1A = new Answer__c();
        answer1A.Question__c = queObj1A.id;
        answer1A.License__c = license1.Id;
        answer1A.Answer_Text__c = 'test answer 1';
        answer1A.Question_Body__c = queObj1A.Question_Body__c;
        answer1A.External_id_of_Question__c = queObj1A.External_Id__c;
        answer1A.Answer_Group__c = queObj1A.Question_Group__c+'-1';
        insert answer1A;
        
        Question__c queObj2A = new Question__c();
        queObj2A.Question_Body__c = 'Q2A';
        queObj2A.Data_Type__c = 'Yes_No';
        queObj2A.Permit_Type__c = 'POWTS Petition for Variance'; 
        queObj2A.Program_Area__c = 'POWTS';
        queObj2A.Application_Type__c = 'Plan Review';
        queObj2A.Application_Method__c = 'All';
        queObj2A.Status__c = 'Active';
        queObj2A.Version__c = 1.0;
        queObj2A.Show_For__c = 'Permit; Permit Renewal; Permit Reinstatement';
        queObj2A.RecordTypeId = recTypeId;
        queObj2A.Effective_Date__c = system.today().addDays(-10);
        queObj2A.Allow_Multiple_Question_Groups__c = true;
        queObj2A.Question_Group__c = 'QG__002A';
        queObj2A.External_Id__c = 'Test_002A';
        insert queObj2A;
        
        Answer__c answer2A = new Answer__c();
        answer2A.Question__c = queObj2A.id;
        answer2A.Permit__c = permit1.Id;
        answer2A.Answer_Text__c = 'test answer 2';
        answer2A.Question_Body__c = queObj2A.Question_Body__c;
        answer2A.External_id_of_Question__c = queObj2A.External_Id__c;
        answer2A.Answer_Group__c = queObj2A.Question_Group__c+'-1';
        insert answer2A;
        
        Question__c queObj2A1 = new Question__c();
        queObj2A1.Question_Body__c = 'Q2A';
        queObj2A1.Data_Type__c = 'Yes_No';
        queObj2A1.Permit_Type__c = 'POWTS Petition for Variance'; 
        queObj2A1.Program_Area__c = 'POWTS';
        queObj2A1.Application_Type__c = 'Plan Review';
        queObj2A1.Application_Method__c = 'All';
        queObj2A1.Status__c = 'Active';
        queObj2A1.Version__c = 1.0;
        queObj2A1.Show_For__c = 'Permit; Permit Renewal; Permit Reinstatement';
        queObj2A1.RecordTypeId = recTypeId;
        queObj2A1.Effective_Date__c = system.today().addDays(-10);
        queObj2A1.Allow_Multiple_Question_Groups__c = true;
        queObj2A1.Question_Group__c = 'QG__002A1';
        queObj2A1.External_Id__c = 'Test_002A1';
        insert queObj2A1;
        
        Answer__c answer2A1 = new Answer__c();
        answer2A1.Question__c = queObj2A1.id;
        answer2A1.Permit__c = permit1.Id;
        answer2A1.Answer_Text__c = '10';
        answer2A1.Question_Body__c = queObj2A1.Question_Body__c;
        answer2A1.External_id_of_Question__c = queObj2A1.External_Id__c;
        answer2A1.Answer_Group__c = queObj2A1.Question_Group__c+'-1';
        insert answer2A1;
        
        Question__c queObj3A = new Question__c();
        queObj3A.Question_Body__c = 'Q3A';
        queObj3A.Data_Type__c = 'Yes_No';
        queObj3A.Application_Type__c = 'Manufactured Homes';
        queObj3A.Credential_Type__c = 'Manufactured Homes Credential';
        queObj3A.Credential__c = 'Manufactured Homes Installer';
        queObj3A.Application_Method__c = 'Course Completion';
        queObj3A.Service_Request_Type__c = 'Exam Re-Application';
        queObj3A.Status__c = 'Active';
        queObj3A.Version__c = 1.0;
        queObj3A.Show_For__c = 'Service Request';
        queObj3A.RecordTypeId = recTypeId;
        queObj3A.Effective_Date__c = system.today();
        queObj3A.End_Date__c = system.today();
        queObj3A.Allow_Multiple_Question_Groups__c = true;
        queObj3A.Question_Group__c = 'QG__003A';
        queObj3A.External_Id__c = 'TestSR_001A';
        insert queObj3A;

        Answer__c answer3A = new Answer__c();
        answer3A.Question__c = queObj3A.id;
        answer3A.Service_Request__c = sr.Id;
        answer3A.Answer_Text__c = 'test answer 3';
        answer3A.Question_Body__c = queObj3A.Question_Body__c;
        answer3A.External_id_of_Question__c = queObj3A.External_Id__c;
        answer3A.Answer_Group__c = queObj3A.Question_Group__c+'-1';
        insert answer3A;
        
        // Child question record
        Question__c qObjA = new Question__c();
        qObjA.Question_Body__c = 'Q1cA';
        qObjA.Parent_Question__c = queObj1A.Id;
        qObjA.Allow_Multiple_Question_Groups__c = true;
        //qObjA.Child_Question_Group__c = queObj1A.Question_Group__c;
        qObjA.Data_Type__c = 'Yes_No';
        qObjA.Application_Type__c = 'Manufactured Homes';
        qObjA.Credential_Type__c = 'Manufactured Homes Credential';
        qObjA.Credential__c = 'Manufactured Homes Installer';
        qObjA.Application_Method__c = 'Course Completion';
        qObjA.Status__c = 'Active';
        qObjA.Version__c = 1.0;
        qObjA.Show_For__c = 'Credential; Credential Renewal; Credential Reinstatement';
        qObjA.RecordTypeId = recTypeId;
        qObjA.External_Id__c = 'Test_003A';
        insert qObjA;
        
        Answer__c answer4A = new Answer__c();
        answer4A.Question__c = qObjA.id;
        answer4A.License__c = license1.Id;
        answer4A.Answer_Text__c = 'test answer 4a';
        answer4A.Question_Body__c = qObjA.Question_Body__c;
        answer4A.External_id_of_Question__c = qObjA.External_Id__c;
        answer4A.Answer_Group__c = qObjA.Question_Group__c+'-1';
        insert answer4A;
        
        Question__c qObj2A = new Question__c();
        qObj2A.Question_Body__c = 'Q2cA';
        qObj2A.Parent_Question__c = queObj2A.Id;
        qObj2A.Allow_Multiple_Question_Groups__c = true;
        //qObj2A.Child_Question_Group__c = queObj2A.Question_Group__c;
        qObj2A.Data_Type__c = 'Yes_No';
        qObj2A.Permit_Type__c = 'POWTS Petition for Variance'; 
        qObj2A.Program_Area__c = 'POWTS';
        qObj2A.Application_Type__c = 'Plan Review';
        qObj2A.Application_Method__c = 'All';
        qObj2A.Status__c = 'Active';
        qObj2A.Version__c = 1.0;
        qObj2A.Show_For__c = 'Permit; Permit Renewal; Permit Reinstatement';
        qObj2A.RecordTypeId = recTypeId;
        qObj2A.External_Id__c = 'Test_004A';
        insert qObj2A;
        
        Answer__c answer5A = new Answer__c();
        answer5A.Question__c = qObj2A.id;
        answer5A.Permit__c = permit1.Id;
        answer5A.Answer_Text__c = '10';
        answer5A.Question_Body__c = qObj2A.Question_Body__c;
        answer5A.External_id_of_Question__c = qObj2A.External_Id__c;
        answer5A.Answer_Group__c = queObj2A.Question_Group__c+'-1';
        insert answer5A;
        
        Question__c qObj3A = new Question__c();
        qObj3A.Question_Body__c = 'Q3cA';
        qObj3A.Parent_Question__c = queObj3A.Id;
        qObj3A.Data_Type__c = 'Yes_No';
        qObj3A.Allow_Multiple_Question_Groups__c = true;
        qObj3A.Application_Type__c = 'Manufactured Homes';
        qObj3A.Credential_Type__c = 'Manufactured Homes Credential';
        qObj3A.Credential__c = 'Manufactured Homes Installer';
        qObj3A.Application_Method__c = 'Course Completion';
        qObj3A.Service_Request_Type__c = 'Exam Re-Application';
        qObj3A.Show_For__c = 'Service Request';
        qObj3A.Status__c = 'Active';
        qObj3A.Version__c = 1.0;
        qObj3A.RecordTypeId = recTypeId;
        qObj3A.External_Id__c = 'TestSR_002A';
        insert qObj3A;
        
        Answer__c answer6A = new Answer__c();
        answer6A.Question__c = qObj3A.id;
        answer6A.Service_Request__c = sr.Id;
        answer6A.Answer_Text__c = 'test answer 6a';
        answer6A.Question_Body__c = qObj3A.Question_Body__c;
        answer6A.External_id_of_Question__c = qObj3A.External_Id__c;
        answer6A.Answer_Group__c = queObj3A.Question_Group__c+'-1';
        insert answer6A;
        /*
        // Parent question record
        Question__c queObj6A = new Question__c();
        queObj6A.Question_Body__c = 'Q6A';
        queObj6A.Data_Type__c = 'Yes_No';
        queObj6A.Application_Type__c = 'Manufactured Homes Communities';
        queObj6A.Program_Area__c = 'Manufactured Homes Communities';
        queObj6A.Permit_TYpe__c = 'Manufactured Homes Community Permit';
        queObj6A.Application_Method__c = 'General Application';
        queObj6A.Status__c = 'Active';
        queObj6A.Version__c = 1.0;
        queObj6A.Order_Number__c = 1;
        queObj6A.Possible_Responses__c = 'Yes;No;';
        queObj6A.Expected_Answer_Parent_Field_Value_Map__c = 'Yes=Yes;No=No;';
        queObj6A.Show_For__c = 'Permit';
        queObj6A.RecordTypeId = recTypeId;
        queObj6A.Effective_Date__c = system.today().addDays(-10);
        queObj6A.End_Date__c = system.today().addDays(10);
        queObj6A.Allow_Multiple_Question_Groups__c = true;
        queObj6A.Question_Group__c = 'QG__006A';
        queObj6A.External_Id__c = 'Test_006A';
        insert queObj6A;
        
        Answer__c answer7A = new Answer__c();
        answer7A.Question__c = queObj6A.id;
        answer7A.Permit__c = permit1.Id;
        answer7A.Answer_Text__c = 'test answer 7';
        answer7A.Question_Body__c = queObj6A.Question_Body__c;
        answer7A.External_id_of_Question__c = queObj6A.External_Id__c;
        answer7A.Answer_Group__c = queObj6A.Question_Group__c+'-1';
        insert answer7A;
        
         // Parent question record
        Question__c queObj7A = new Question__c();
        queObj7A.Question_Body__c = 'Q7A';
        queObj7A.Data_Type__c = 'Yes_No';
        queObj7A.Application_Type__c = 'Manufactured Homes Communities';
        queObj7A.Program_Area__c = 'Manufactured Homes Communities';
        queObj7A.Permit_TYpe__c = 'Manufactured Homes Community Permit';
        queObj7A.Application_Method__c = 'General Application';
        queObj7A.Status__c = 'Active';
        queObj7A.Version__c = 1.0;
        queObj7A.Order_Number__c = 1;
        queObj7A.Possible_Responses__c = 'Yes;No;';
        queObj7A.Expected_Answer_Parent_Field_Value_Map__c = 'Yes=Yes;No=No;';
        queObj7A.Show_For__c = 'Permit';
        queObj7A.RecordTypeId = recTypeId;
        queObj7A.Effective_Date__c = system.today().addDays(-10);
        queObj7A.End_Date__c = system.today().addDays(10);
        queObj7A.Allow_Multiple_Question_Groups__c = true;
        queObj7A.Question_Group__c = 'QG__007A';
        queObj7A.External_Id__c = 'Test_007A';
        insert queObj7A;
        
        Answer__c answer8A = new Answer__c();
        answer8A.Question__c = queObj7A.id;
        answer8A.Permit__c = permit1.Id;
        answer8A.Answer_Text__c = '10';
        answer8A.Question_Body__c = queObj7A.Question_Body__c;
        answer8A.External_id_of_Question__c = queObj7A.External_Id__c;
        answer8A.Answer_Group__c = queObj7A.Question_Group__c+'-1';
        insert answer8A;
*/
        System.debug('check 1');
        List<Review_Completion_Time_Computation__c> rctcList = new List<Review_Completion_Time_Computation__c>();
        System.debug('check 2');
        /*Review_Completion_Time_Computation__c rctcRecord1 = new Review_Completion_Time_Computation__c(Name='TR_1',
                                                                                                     Answer_Comparison_Type__c = 'Normal',
                                                                                                     Expected_Answer__c = 'test answer 7',
                                                                                                     External_Id__c = 'EX_1',
                                                                                                     External_id_of_Question__c = queObj6A.External_Id__c,
                                                                                                     Review_Hours__c = 3.5);
        System.debug('check 3');
        rctcList.add(rctcRecord1);
        System.debug('check 4');
        Review_Completion_Time_Computation__c rctcRecord2 = new Review_Completion_Time_Computation__c(Name='TR_2',
                                                                                                     Answer_Comparison_Type__c = 'Range',
                                                                                                     //Expected_Answer__c = '',
                                                                                                     External_Id__c = 'EX_2',
                                                                                                     External_id_of_Question__c = queObj7A.External_Id__c,
                                                                                                     Range_Start_Value__c = 5,
                                                                                                     Range_End_Value__c = 15, 
                                                                                                     Review_Hours__c = 3.5);
        System.debug('check 5');
        rctcList.add(rctcRecord2);*/
        System.debug('check 6');
        Review_Completion_Time_Computation__c rctcRecord3 = new Review_Completion_Time_Computation__c(Name='TR_3',
                                                                                                     Answer_Comparison_Type__c = 'Range',
                                                                                                     //Expected_Answer__c = 'test answer 5a',
                                                                                                     External_Id__c = 'EX_3',
                                                                                                     Range_Start_Value__c = 5,
                                                                                                     Range_End_Value__c = 15, 
                                                                                                     External_id_of_Question__c = queObj2A1.External_Id__c,
                                                                                                     Review_Hours__c = 3.5);
        System.debug('check 7');
        rctcList.add(rctcRecord3);
        Review_Completion_Time_Computation__c rctcRecord4 = new Review_Completion_Time_Computation__c(Name='TR_4',
                                                                                                     Answer_Comparison_Type__c = 'Normal',
                                                                                                     Expected_Answer__c = 'test answer 2',
                                                                                                     External_Id__c = 'EX_4',
                                                                                                     External_id_of_Question__c = queObj2A.External_Id__c,
                                                                                                     Review_Hours__c = 3.5);
        System.debug('check 7a');
        rctcList.add(rctcRecord4);
        System.debug('check 8');
        
        insert rctcList;
        System.debug('check 9');
        List<Review_Completion_Time_Computation__c> rctcListInserted = [Select Id, Expected_Answer__c, External_id_of_Question__c  From Review_Completion_Time_Computation__c];
        System.debug('rctcListInserted '+rctcListInserted);
        List<Question__c> questionList = [Select Id, Permit_Type__c  From Question__c];
        System.debug('questionList '+questionList);
        
        globalSetting.Disable_Triggers__c = false;
        update globalSetting;
    }
    
    @isTest
    public static void testQuestions1(){
        Musw__License2__c license1 = [Select Id From Musw__License2__c limit 1];
        
        BackendQuestionAnswer_CC con = new BackendQuestionAnswer_CC();
        con.RecordId = license1.Id;
        con.ObjectName = 'License';
        
        con.initializeComponent();
        con.edit();
        con.save();
        //con.QuestionsIterator = 0;
        //con.addQuestionsGroup();
    }
    
    @isTest
    public static void testQuestions2(){
        Musw__Permit2__c permit1 = [Select Id From Musw__Permit2__c limit 1];
        
        BackendQuestionAnswer_CC con = new BackendQuestionAnswer_CC();
        con.RecordId = permit1.Id;
        con.ObjectName = 'Permit';
        
        con.initializeComponent();
        con.edit();
        con.save();
    }
    
    @isTest
    public static void testQuestions3(){
        Renewal_Application__c credRenewal = [Select Id From Renewal_Application__c where license__c != null limit 1];
        System.debug('credRenewal 3'+credRenewal);
        BackendQuestionAnswer_CC con = new BackendQuestionAnswer_CC();
        con.RecordId = credRenewal.Id;
        con.ObjectName = 'Renewal';
        con.isCredentialRenewal = true;
        
        con.initializeComponent();
        con.edit();
        con.save();
    }
    
     @isTest
    public static void testQuestions4(){
        Renewal_Application__c credRenewal = [Select Id From Renewal_Application__c where license__c !=null limit 1];
        System.debug('credRenewal 4'+credRenewal);
        BackendQuestionAnswer_CC con = new BackendQuestionAnswer_CC();
        con.RecordId = credRenewal.Id;
        con.ObjectName = 'Renewal';
        con.isCredentialReinstatement = true;
        
        con.initializeComponent();
        con.edit();
        con.save();
    }
    
    @isTest
    public static void testQuestions5(){
        System.debug('running testQuestions5');
        Renewal_Application__c permitRenewal = [Select Id From Renewal_Application__c where permit__c != null limit 1];
        System.debug('permitRenewal '+permitRenewal);
        BackendQuestionAnswer_CC con = new BackendQuestionAnswer_CC();
        con.RecordId = permitRenewal.Id;
        con.objectname = 'Renewal';
        con.isPermitRenewal = true;
        
        con.initializeComponent();
        con.edit();
        con.save();
    }

    
     @isTest
    public static void testQuestions15(){
        BackendQuestionAnswer_CC con = new BackendQuestionAnswer_CC();
        con.ObjectName = '';  
        con.initializeComponent();
    }
}