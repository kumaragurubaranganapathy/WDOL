@isTest
public class ParentFieldUpdateTriggerHandlerTest {
    @testSetup static void createTestData()
    {
        List<Account> lstAccounts = new List<Account>();
        Global_Settings__c gs= new Global_Settings__c(SetupOwnerId=UserInfo.getUserId(), Disable_Triggers__c=true);
        insert gs;      
        Account acc = CreateTestDataUtility.createTestAccount();
        lstAccounts.add(acc);
        
        Account acc1 = CreateTestDataUtility.createTestAccount(); 
        lstAccounts.add(acc1);
        Database.insert(lstAccounts);
        
        //Create a contact which will pass the validation
        Contact c = CreateTestDataUtility.createContact(acc.id);
        Date myDate = date.newInstance(1950, 2, 17);
        c.Birthdate = myDate; 
        c.LastName = 'TestName1';
        c.Served_In_Military__c = 'No';
        c.Spouse_Served_in_the_Military__c = 'No';
        c.Phone = '407-867-5309';
        c.Birth_Country__c ='United States';
        c.Birth_City__c = 'Atlanta';
        c.Birth_State_Province__c ='Georgia';
        Database.insert(c);
        
        //Create test user        
        User u1 = CreateTestDataUtility.createCommunityUser(c.id);            
        Database.insert(u1);
        
        
        
        //create License 
        Id recordTypeId = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Universal Default License Record Type').getRecordTypeId();
        MUSW__License2__c license = new MUSW__License2__c(RecordTypeId = recordTypeId,
                                                          Application_Type__c = 'Manufactured Homes', 
                                                          Credential_type__c = 'Manufactured Homes Credential', 
                                                          Credential__c = 'Manufactured Homes Installer', 
                                                          Application_Method__c = 'Course Completion',
                                                          musw__status__c = 'Pending', 
                                                          MUSW__Primary_Licensee__c = acc.Id, 
                                                          MUSW__Applicant__c = c.id);
        insert license;
        MUSW__License2__c license2 = new MUSW__License2__c(RecordTypeId = recordTypeId,
                                                          Application_Type__c = 'Trades Credential', 
                                                          Credential_type__c = 'Soil Professions', 
                                                          Credential__c = 'Soil Tester', 
                                                          Application_Method__c = 'Examination',
                                                          musw__status__c = 'Active', 
                                                          MUSW__Primary_Licensee__c = acc.Id, 
                                                          MUSW__Applicant__c = c.id);
        insert license2;
        
        Id srrecordTypeId = Schema.SObjectType.MUSW__Application2__c.getRecordTypeInfosByName().get('General Service Request').getRecordTypeId();
        MUSW__Application2__c serviceRequest = new MUSW__Application2__c(RecordTypeId = srrecordTypeId, MUSW__Type__c = 'Exam Re-Application',
                                                                        License__c =license2.Id, MUSW__Applicant__c = c.id, Credential__c = 'Soil Tester', 
                                                                         Credential_Type__c = 'Soil Professions');
        insert serviceRequest;
        
        Renewal_Application__c Renewal = new Renewal_Application__c(License__c = license.Id);
        insert Renewal;

         Id permitrecordTypeId = Schema.SObjectType.MUSW__Permit2__c.getRecordTypeInfosByName().get('Universal Default Permit Record Type').getRecordTypeId();
        MUSW__Permit2__c permit = new MUSW__Permit2__c(RecordTypeId = permitrecordTypeId,
                                                       Application_Type__c = 'Plan Review', 
                                                       Program_Area__c = 'POWTS',
                                                       Permit_Type__c = 'POWTS Individual Site Design',
                                                       musw__status__c = 'Pending', 
                                                       MUSW__Account__c = acc.id,
                                                       MUSW__Applicant__c = c.id);
        insert permit;
        
        gs.Disable_Triggers__c = false;
        update gs;
    }
    
    static testMethod void LicenseParentFieldUpdate()
    {
        test.startTest();
        List<Contact> lstc = new List<Contact>();
        lstc = [Select Id,Name,LastName from Contact where LastName='TestName1' limit 1];
        
        List<MUSW__License2__c> lstlicense = new List<MUSW__License2__c>();
        lstlicense = [Select Id, MUSW__Applicant__c,Military_Waiver__c from MUSW__License2__c where MUSW__Applicant__c =: lstc[0].Id];
        System.debug('lstlicense>>>>>>>>>>>>>>' +lstlicense);        
                                    
        Question__c testQuestion = new Question__c(Status__c='Active',Question_Body__c='Test Question Body in parent field update test',
                                                   Data_Type__c='Yes_No',Possible_Responses__c='Yes;No;', Expected_Answer_Parent_Field_Value_Map__c='Yes=true;No=false;',
                                                   Application_Type__c = 'Manufactured Homes', Application_Method__c = 'Course Completion', Credential_type__c = 'Manufactured Homes Credential', 
                                                   Credential__c = 'Manufactured Homes Installer',Parent_Object_API_Name__c='MUSW__License2__c',
                                                   Parent_Object_Field_API_Name__c='Military_Waiver__c',Show_For__c='Credential', External_ID__c = 'EXT-test11'
                                                  );
        insert testQuestion;
        System.debug('lstlicense[0].Id>>>>>>>>>>>>>>' +lstlicense[0].Id);
        Answer__c answer = new Answer__c(Answer_Text__c='Yes',Question__c=testQuestion.Id,License__c=lstlicense[0].Id, External_id_of_Question__c = 'EXT-test11' );
        insert answer;
        Answer__c ans1 = new Answer__c();
        ans1= [select id,Answer_Text__c,Question__c, License__c from Answer__c where License__c=:lstlicense[0].Id];
        System.debug('ans1>>>>>' +ans1);
        
        List<MUSW__License2__c> lstlicense2 = new List<MUSW__License2__c>();
        lstlicense2=    [Select Id, MUSW__Applicant__c,Military_Waiver__c from MUSW__License2__c where MUSW__Applicant__c =: lstc[0].Id];
        System.assertEquals(lstlicense2[0].Military_Waiver__c, true);
        test.stopTest();
    }
    
    
   static testMethod void LicenseRenewalParentFieldUpdate()
    {
        test.startTest();
        List<Contact> lstc = new List<Contact>();
        lstc = [Select Id,Name,LastName from Contact where LastName='TestName1' limit 1];
        
        List<MUSW__License2__c> lstlicense = new List<MUSW__License2__c>();
        lstlicense = [Select Id, MUSW__Applicant__c from MUSW__License2__c where MUSW__Applicant__c =: lstc[0].Id];     
        
        List<Renewal_Application__c> lstRenewal = new List<Renewal_Application__c>();
        lstRenewal = [Select Id,License__c,No_Fee_Required__c from Renewal_Application__c where License__c =:lstlicense[0].Id];
                                            
        Question__c testQuestion = new Question__c(Status__c='Active',Question_Body__c='Test Question Body in parent field update test', Application_Type__c = 'Manufactured Homes',
                                                   Data_Type__c='Yes_No',Possible_Responses__c='Yes;No;', Expected_Answer_Parent_Field_Value_Map__c='Yes=true;No=false;',
                                                   Credential__c='Manufactured Homes Installer', Application_Method__c = 'Course Completion', Credential_type__c = 'Manufactured Homes Credential', 
                                                   Parent_Object_API_Name__c='Renewal_Application__c',External_ID__c = 'EXT-test11',
                                                   Parent_Object_Field_API_Name__c='No_Fee_Required__c',Show_For__c='Credential Renewal'
                                                  );
        insert testQuestion;
        
        Answer__c answer = new Answer__c(Answer_Text__c='Yes',Question__c=testQuestion.Id,Renewal_Application__c=lstRenewal[0].Id, External_id_of_Question__c = 'EXT-test11');
        
        insert answer;
        
        List<Renewal_Application__c> lstRenewal1 = new List<Renewal_Application__c>();
        lstRenewal1 = [Select Id,License__c,No_Fee_Required__c from Renewal_Application__c where License__c =:lstlicense[0].Id];
        //system.assertEquals(lstRenewal1[0].No_Fee_Required__c, true);
        
        test.stopTest();
        
    } 
    
       static testMethod void PermitParentFieldUpdate()
    {
        test.startTest();
        List<Contact> lstc = new List<Contact>();
        lstc = [Select Id,Name,LastName from Contact where LastName='TestName1' limit 1];
        
        List<MUSW__Permit2__c> lstpermit = new List<MUSW__Permit2__c>();
        lstpermit = [Select Id, MUSW__Applicant__c from MUSW__Permit2__c where MUSW__Applicant__c =: lstc[0].Id];     
        
                                        
        Question__c testQuestion = new Question__c(Status__c='Active',Question_Body__c='Test Question Body in parent field update test', Application_Type__c = 'Plan Review',
                                                   Data_Type__c='Yes_No',Possible_Responses__c='Yes;No;', Expected_Answer_Parent_Field_Value_Map__c='Yes=true;No=false;',
                                                   Permit_Type__c = 'POWTS Individual Site Design', Application_Method__c = '', Program_Area__c = 'POWTS', 
                                                   Parent_Object_API_Name__c='MUSW__Permit2__c',External_ID__c = 'EXT-test11',
                                                   Parent_Object_Field_API_Name__c='Soil_Saturation_Report__c',Show_For__c='Permit'
                                                  );
        insert testQuestion;
        
        Answer__c answer = new Answer__c(Answer_Text__c='Yes',Question__c=testQuestion.Id,Permit__c =lstpermit[0].Id, External_id_of_Question__c = 'EXT-test11');
        
        insert answer;
        
        List<MUSW__Permit2__c> lstpermit1 = new List<MUSW__Permit2__c>();
        lstpermit1 = [Select Id,Soil_Saturation_Report__c from MUSW__Permit2__c where id =:lstpermit[0].Id];
        system.assertEquals(lstpermit1[0].Soil_Saturation_Report__c, true);
        
        test.stopTest();
        
    } 
    
    static testMethod void serviceRequestParentFieldUpdate()
    {
        test.startTest();
        List<Contact> lstc = new List<Contact>();
        lstc = [Select Id,Name,LastName from Contact where LastName='TestName1' limit 1];
        
        List<MUSW__License2__c> lstlicense = new List<MUSW__License2__c>();
        lstlicense = [Select Id, MUSW__Applicant__c,Military_Waiver__c from MUSW__License2__c where MUSW__Applicant__c =: lstc[0].Id and Application_Method__c = 'Examination' ];
        System.debug('lstlicense>>>>>>>>>>>>>>' +lstlicense); 
        List<MUSW__Application2__c> srList = new List<MUSW__Application2__c>();
        srList = [Select Id, MUSW__Applicant__c  from MUSW__Application2__c where License__c =: lstlicense[0].Id];
        System.debug('srList>>>>>>>>>>>>>>' +srList);        
                                        
        Question__c testQuestion = new Question__c(Status__c='Active',Question_Body__c='Test Question Body in parent field update test',
                                                   Data_Type__c='Yes_No',Possible_Responses__c='Yes;No;', Expected_Answer_Parent_Field_Value_Map__c='Yes=true;No=false;',
                                                   Application_Type__c = 'Trades Credential', Credential_type__c = 'Soil Professions', Credential__c = 'Soil Tester', 
                                                   Application_Method__c = 'Examination', Parent_Object_API_Name__c='MUSW__Application2__c',
                                                   Parent_Object_Field_API_Name__c='Special_Accommodation_Request__c',Show_For__c='Credential', External_ID__c = 'EXT-test111'
                                                  );
        insert testQuestion;
        System.debug('srList[0].Id>>>>>>>>>>>>>>' +srList[0].Id);
        Answer__c answer = new Answer__c(Answer_Text__c='Yes',Question__c=testQuestion.Id,Service_Request__c=srList[0].Id, External_id_of_Question__c = 'EXT-test111' );
        insert answer;
        Answer__c ans1 = new Answer__c();
        ans1= [select id,Answer_Text__c,Question__c, License__c from Answer__c where Service_Request__c=:srList[0].Id];
        System.debug('ans1>>>>>' +ans1);
        
        List<MUSW__Application2__c> srList2 = new List<MUSW__Application2__c>();
        srList2=    [Select Id, MUSW__Applicant__c, Special_Accommodation_Request__c from MUSW__Application2__c where MUSW__Applicant__c =: lstc[0].Id];
        System.assertEquals(srList2[0].Special_Accommodation_Request__c, true);
        test.stopTest();
    }
    
}