/* 
*Class Name   : Polaris_ServiceRequest_Test
* Description  : Testclass for Polaris_ServiceRequestController
* Created By   : Shreya Surabhi
* Created On   : 18/09/2019 
* Modification Log:  
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Developer                    Date                        Description
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*
*/
@isTest
public class Polaris_ServiceRequest_Test{
    public static string newID = '' ;
    @testSetup
    public static void testDataSetup() {
     // User u = DOL_TestDataFactory.createPortalAccountUser();
     MUSW__Master_Submission_List__c mstLstSub = new MUSW__Master_Submission_List__c();
     mstLstSub.Name='Military Orders';
    mstLstSub.Order_No__c = 100;
    mstLstSub.Submission_Type__c = 'Softcopy: To be Uploaded';
    mstLstSub.Show_For__c = 'License;Credential;Service Request';
    mstLstSub.Name = 'Funerals';
    mstLstSub.Title__c = '';
    mstLstSub.Expected_Answer__c = '';
    mstLstSub.Required__c = true;
    mstLstSub.Effective_Start_Date__c = System.Today() -1;
    mstLstSub.Default__c = true;
    mstLstSub.Application_Type__c = 'Funerals';
    mstLstSub.Credential_Type__c = 'Embalmer Intern';
    mstLstSub.Application_Method__c = 'General Application';
    mstLstSub.Object__c = 'MUSW__License2__c';
    mstLstSub.External_Id__c = 'a1';
    mstLstSub.Service_Request__c ='Change License Status';
    insert mstLstSub;
    MUSW__Master_Submission_List__c mstLstSub1 = new MUSW__Master_Submission_List__c();
    mstLstSub1.Name = 'Additional Documentation';
    mstLstSub1.Order_No__c = 101;
    mstLstSub1.Submission_Type__c = 'Hardcopy: To be Mailed';
    mstLstSub1.Show_For__c = 'License;Credential;Service Request';
    mstLstSub1.Name = 'Funerals';
    mstLstSub1.Title__c = '';
    mstLstSub1.Expected_Answer__c = '';
    mstLstSub1.Required__c = true;
    mstLstSub1.Effective_Start_Date__c = System.Today()-2;
    mstLstSub1.Default__c = true;
    mstLstSub1.Application_Type__c = 'Funerals';
    mstLstSub1.Credential_Type__c = 'Embalmer Intern';
    mstLstSub1.Application_Method__c = 'General Application';
    mstLstSub1.Object__c = 'MUSW__License2__c';
    mstLstSub1.External_Id__c = 'a1678';
    mstLstSub1.Service_Request__c ='Change License Status';
    insert mstLstSub1;
    
        
        
        Question__c ques = new Question__c();
        ques.Question_Body__c = 'First Name or initial';
        ques.Data_Type__c = 'Text';
        ques.Parent_Object_API_Name__c = 'MUSW__License2__c';
        ques.Application_Type__c = 'Funerals';
        ques.Credential_Type__c = 'Embalmer Intern';
        ques.External_Id__c = 'abc12367';
        ques.QuestionFieldAPI__c = 'Print_First_Name__c';
        ques.Application_Method__c = 'General Application';
        ques.Service_Request_Type__c  ='Change License Status';
        ques.isRequired__c = true;
        ques.status__c = 'Active';
        ques.Section__c ='Request Questions';
        ques.Section__c ='Request Questions';
        ques.Submission_Title__c = 'How will your name appear on the license?';
        ques.recordtypeId = Schema.SObjectType.Question__c.getRecordTypeInfosByName().get('License Information').getRecordTypeId();
        
          insert ques;        
         Question__c ques2 = new Question__c();
        ques2.Question_Body__c = 'First Name or initial';
        ques2.Data_Type__c = 'Text';
        ques2.Parent_Object_API_Name__c = 'MUSW__License2__c';
        ques2.Application_Type__c = 'Funerals';
        ques2.Credential_Type__c = 'Embalmer Intern';
        ques2.External_Id__c = 'abc12367tt';
        ques2.QuestionFieldAPI__c = 'Print_First_Name__c';
        ques2.Application_Method__c = 'General Application';
        ques2.Service_Request_Type__c  ='Change License Status';
        ques2.isRequired__c = false;
        ques2.status__c = 'Active';
        ques2.Section__c ='Request Questions';
        ques2.Section__c ='Request Questions';
        ques2.Submission_Title__c = 'test';
        ques2.recordtypeId = Schema.SObjectType.Question__c.getRecordTypeInfosByName().get('License Information').getRecordTypeId();
        ques2.Parent_Question__c =ques.id;
         insert ques2;   
        
        
        Question__c ques3 = new Question__c();
        ques3.Question_Body__c = 'First Name or initial';
        ques3.Data_Type__c = 'Text';
        ques3.Parent_Object_API_Name__c = 'MUSW__License2__c';
        ques3.Application_Type__c = 'Funerals';
        ques3.Credential_Type__c = 'Embalmer Intern';
        ques3.External_Id__c = 'abc12367ttrr';
        ques3.QuestionFieldAPI__c = 'Print_First_Name__c';
        ques3.Application_Method__c = 'General Application';
        ques3.Service_Request_Type__c  ='Change License Status';
        ques3.isRequired__c = true;
        ques3.status__c = 'Active';
        ques3.Section__c ='null';
        ques3.Section__c ='Request Questions';
        ques3.Submission_Title__c = 'ft';
        ques3.recordtypeId = Schema.SObjectType.Question__c.getRecordTypeInfosByName().get('License Information').getRecordTypeId();
        ques3.Endorsement_Type__c ='Industrial';
        insert ques3;
        Question__c ques4 = new Question__c();
        ques4.Question_Body__c = 'First Name or initial11';
        ques4.Data_Type__c = 'Picklist';
        ques4.Parent_Object_API_Name__c = 'MUSW__License2__c';
        ques4.Application_Type__c = 'Funerals';
        ques4.Credential_Type__c = 'Embalmer Intern';
        ques4.External_Id__c = 'abc12367ttrr1';
        ques4.QuestionFieldAPI__c = 'Print_First_Name__c';
        ques4.Application_Method__c = 'General Application';
        ques4.Service_Request_Type__c  ='Change License Status';
        ques4.isRequired__c = true;
        ques4.status__c = 'Active';
        ques4.Section__c ='null';
        ques4.Section__c ='Request Questions';
        ques4.Submission_Title__c = 'ft';
        ques4.recordtypeId = Schema.SObjectType.Question__c.getRecordTypeInfosByName().get('License Information').getRecordTypeId();
        ques4.Endorsement_Type__c ='Industrial';
        ques4.Possible_Responses__c='Yes;No;Maybe;';
        ques4.Qualifying_Response__c = 'Yes;';
        insert ques4; 
        newID = '' + ques4.Id;
        Question__c ques5 = new Question__c();
        ques5.Question_Body__c = 'First Name or initial112';
        ques5.Data_Type__c = 'Radio';
        ques5.Parent_Object_API_Name__c = 'MUSW__License2__c';
        ques5.Application_Type__c = 'Funerals';
        ques5.Credential_Type__c = 'Embalmer Intern';
        ques5.External_Id__c = 'abc12367ttrr11';
        ques5.QuestionFieldAPI__c = 'Print_First_Name__c';
        ques5.Application_Method__c = 'General Application';
        ques5.Service_Request_Type__c  ='Change License Status';
        ques5.isRequired__c = true;
        ques5.status__c = 'Active';
        ques5.Section__c ='null';
        ques5.Section__c ='Request Questions';
        ques5.Submission_Title__c = 'ft';
        ques5.recordtypeId = Schema.SObjectType.Question__c.getRecordTypeInfosByName().get('License Information').getRecordTypeId();
        ques5.Endorsement_Type__c ='Industrial';
        ques5.Possible_Responses__c='Yes;No';
        ques5.Qualifying_Response__c = 'Yes';
        insert ques5;     
        
       /* String before = 'Testing base 64 encode567';
        Blob beforeblob = Blob.valueOf(before);
        String base64Data = EncodingUtil.base64Encode(beforeblob);
        ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S';
        cv.VersionData = EncodingUtil.base64Decode(base64Data);
        cv.Title = 'License cversion22';
        cv.PathOnClient = 'cversion22';
        insert cv;
        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;        
        cdl.LinkedEntityId = UserInfo.getUserId();
        cdl.ShareType = 'V';
        insert cdl;*/
        list<LnP_Mandatory_Subsections__mdt> theRecord = [SELECT Id, DeveloperName from LnP_Mandatory_Subsections__mdt limit 100];
        List<LnP_SubSection_Icon__mdt> subSectionRecord = [SELECT LnP_Icon_Name__c, LnP_Icon_SVG_Name__c from LnP_SubSection_Icon__mdt limit 100];
        List<AMR_Link__mdt> amrLinks = [SELECT Sections__c,MasterLabel FROM AMR_Link__mdt limit 100]; 
        
    }
    static testMethod void testMethod1(){
        
        
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('User Account').getRecordTypeId();
        Id ConRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        Id LicRecTypeId = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        
        Account acc = DOL_TestDataFactory.createAccount(AccRecTypeId);         
        Contact con = DOL_TestDataFactory.createContact(ConRecTypeId,acc.id); 
        
        
        MUSW__Account_Contact__c ac = new MUSW__Account_Contact__c();
        ac.First_Name__c = 'test';
        ac.Last_Name__c = 'test';
        ac.Role__c = 'Administrator';
        ac.Email__c = 'test@test.com';
        ac.Title__c = 'test';
        ac.Status__c = 'Active';
        ac.MUSW__Contact__c = con.Id;
        ac.MUSW__Account__c = acc.Id;
        
        ac.Account_Admin__c = true;
        ac.isAdminContact__c = true;
        insert ac;
        
        Task acts = new Task();
        acts.WhatId = ac.Id;
        acts.Status = 'Pending';        
        acts.Priority = 'Normal';
        acts.Subject = 'test';
        acts.OwnerId = UserInfo.getUserId();
        insert acts;            
        Id licRecordTypeId = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        MUSW__License2__c licenseObj = DOL_TestDataFactory.createLicense(licRecordTypeId,acc.Id,'Funerals','Embalmer Intern','General Application');
        Endorsement__c endoObject = new Endorsement__c(License__c=licenseObj.Id,Endorsement_Type__c='Industrial',Date_Requested_for_Adding_Endorsement__c=Date.today(),Status__c='Active');
        insert endoObject;
        
        Request__c reqObj = DOL_TestDataFactory.createRequest(licenseObj.Id,'Funerals','Embalmer Intern');
        reqObj.Description__c = 'Request Description';
        //reqObj.Form_JSON__c='{"compositeRequest":[{"body":{"Answer":"Military Orders","Application":"a2pr00000006yxGAAQ","Question":"a2mr0000000WrqMAAS"},"method":"POST","referenceId":"refId0","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"yest","Application":"a2pr00000006yxGAAQ","Question":"a2mr0000000WrplAAC"},"method":"POST","referenceId":"refId2","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"}]}';
        //reqObj.Form_JSON__c='{"compositeRequest":[{"body":{"Answer":"Military Orders;Military Orders1;Military Orders2","Application":"a2pr00000006z34AAA,"Question":"a2mr0000000WrqeAAC"},"method":"POST","referenceId":"refId0","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"tes","Application":"a2pr00000006z34AAA","Question":"a2mr0000000Wrq3AAC"},"method":"POST","referenceId":"refId2","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"method":"DELETE","referenceId":"refDocId10","url":"/services/data/v38.0/sobjects/ContentDocumentLink/06Ar0000003XFUCEA4"},{"body":{"ContentDocumentId":"069r0000001bwoHAAQ","LinkedEntityId":"@{refSubId1.id}","ShareType":"I"},"method":"POST","referenceId":"refContId1","url":"/services/data/v38.0/sobjects/ContentDocumentLink"},{"body":{"ContentDocumentId":"069r0000001bwoHAAQ;","MUSW_Application2":"a2pr00000006z34AAA","MUSW_Description":"Additional Documentation"},"method":"POST","referenceId":"refSubId1","url":"/services/data/v38.0/sobjects/MUSW__Submission__c"},{"method":"DELETE","referenceId":"refDocId20","url":"/services/data/v38.0/sobjects/ContentDocumentLink/06Ar0000003XFUWEA4"},{"body":{"ContentDocumentId":"069r0000001bwoWAAQ","LinkedEntityId":"@{refSubId2.id}","ShareType":"I"},"method":"POST","referenceId":"refContId2","url":"/services/data/v38.0/sobjects/ContentDocumentLink"},{"body":{"ContentDocumentId":"069r0000001bwoWAAQ;","MUSW_Application2":"a2pr00000006z34AAA","MUSW_Description":"Military Orders","Name":"AMR_QUE090127"},"method":"POST","referenceId":"refSubId2","url":"/services/data/v38.0/sobjects/MUSW__Submission__c"}]} ';
        reqObj.Form_JSON__c='{"compositeRequest":[{"body":{"Answer":"Military Orders","Application":"a2pr00000006z34AAA","Question":"a2mr0000000WrqeAAC"},"method":"POST","referenceId":"refId0","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"tes","Application":"a2pr00000006z34AAA","Question":"a2mr0000000Wrq3AAC"},"method":"POST","referenceId":"refId2","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"method":"DELETE","referenceId":"refDocId10","url":"/services/data/v38.0/sobjects/ContentDocumentLink/06Ar0000003XFUCEA4"},{"body":{"ContentDocumentId":"069r0000001bwoHAAQ","LinkedEntityId":"@{refSubId1.id}","ShareType":"I"},"method":"POST","referenceId":"refContId1","url":"/services/data/v38.0/sobjects/ContentDocumentLink"},{"body":{"ContentDocumentId":"069r0000001bwoHAAQ;","MUSW_Application2":"a2pr00000006z34AAA","MUSW_Description":"Additional Documentation"},"method":"POST","referenceId":"refSubId1","url":"/services/data/v38.0/sobjects/MUSW__Submission__c"},{"method":"DELETE","referenceId":"refDocId20","url":"/services/data/v38.0/sobjects/ContentDocumentLink/06Ar0000003XFUWEA4"},{"body":{"ContentDocumentId":"069r0000001bwoWAAQ","LinkedEntityId":"@{refSubId2.id}","ShareType":"I"},"method":"POST","referenceId":"refContId2","url":"/services/data/v38.0/sobjects/ContentDocumentLink"},{"body":{"ContentDocumentId":"069r0000001bwoWAAQ;","MUSW_Application2":"a2pr00000006z34AAA","MUSW_Description":"Military Orders","Name":"AMR_QUE090127"},"method":"POST","referenceId":"refSubId2","url":"/services/data/v38.0/sobjects/MUSW__Submission__c"}]}';

        reqObj.Stage__c=1;
        update reqObj;
        
        Request__c req = new Request__c();
        req.Account_Contact__c = ac.Id;
        insert req;
        Set<Id> reqSET = new Set<Id>();
        reqSET.add(req.Id);
        
        
        MUSW__Fee__c fee = DOL_TestDataFactory.createFeeWithLicense('Credential', 100.00 ,licenseObj.Id);        
        fee.Request__c = req.Id; 
        update fee;
        
        //for ApplyforLicenseWrapper
        Id parcelRecordTypeId = Schema.SObjectType.MUSW__Parcel__c.getRecordTypeInfosByDeveloperName().get('Address').getRecordTypeId(); 
        
        MUSW__Parcel__c parcel = DOL_TestDataFactory.createParcel(parcelRecordTypeId);
        parcel.Request_Parcel__c = req.Id;
        
        MUSW__Submission__c submission =  DOL_TestDataFactory.createSubmission(licenseObj.Id);
    
        //Insert License Parcel
        MUSW__License_Parcel__c lparcel = DOL_TestDataFactory.createLicenseParcel(licenseObj.Id,parcel.Id);
        
      
          
           //create Application Field
    Application_Field__c appF  = DOL_TestDataFactory.createApplicationField('FirstName', 'Notary Public', 'Notary Public', 'Contact');
        
        map<string,string> spSS = new Map<string,string>();
        spSS.put('key', 'value');
        
        
        LnP_BackgroundSection__c bg = DOL_TestDataFactory.createBackgroundSection();
        bg.Request__c = req.Id;
        update bg;
        
        String dataString = '[{"tabIndex":1,"subheader":"Request Information","sobjectType":null,"sectionName":"Request Information","sectionError":false,"recordType":null,"personalInfoObjectName":null,"mandatorySubsection":null,"labelFieldsMap":[{"warningMessages":null,"value":"Alex","validationCriteria":null,"uploadFile":null,"submissionDetails":null,"renderedOnUi":true,"regex":null,"radioValueOptions":[],"questionSectionDetail":"How will your name appear on the license?","questionSectionClass":"Request Questions","questionSection":"Request Questions","parentQuestionId":null,"orderBy":null,"multiValues":[],"minValue":null,"messageTriggerResponse":null,"message":null,"maxValue":null,"labelId":"a2mr0000000XFugAAG","label":"First Name or initial","isMandatorySub":null,"isMandatoryQues":true,"isGenericSub":null,"isChild":false,"helptext":null,"hasChild":false,"fieldValueOptions":null,"fieldType":"Text","fieldObjName":null,"fieldAPIName":"Print_First_Name__c","errormsg":null,"endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":null,"answerId":null,"acknowledgeResponse":null,"acknowledge":null},{"warningMessages":null,"value":"R","validationCriteria":null,"uploadFile":null,"submissionDetails":null,"renderedOnUi":true,"regex":null,"radioValueOptions":[],"questionSectionDetail":null,"questionSectionClass":"Request Questions","questionSection":"null","parentQuestionId":null,"orderBy":null,"multiValues":[],"minValue":null,"messageTriggerResponse":null,"message":null,"maxValue":null,"labelId":"a2mr0000000XFuhAAG","label":"Middle Name or Initial","isMandatorySub":null,"isMandatoryQues":false,"isGenericSub":null,"isChild":false,"helptext":null,"hasChild":false,"fieldValueOptions":null,"fieldType":"Text","fieldObjName":null,"fieldAPIName":"Print_Middle_Name__c","errormsg":null,"endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":null,"answerId":null,"acknowledgeResponse":null,"acknowledge":null},{"warningMessages":null,"value":"House","validationCriteria":null,"uploadFile":null,"submissionDetails":null,"renderedOnUi":true,"regex":null,"radioValueOptions":[],"questionSectionDetail":null,"questionSectionClass":"Request Questions","questionSection":"null","parentQuestionId":null,"orderBy":null,"multiValues":[],"minValue":null,"messageTriggerResponse":null,"message":null,"maxValue":null,"labelId":"a2mr0000000XFuiAAG","label":"Last Name","isMandatorySub":null,"isMandatoryQues":true,"isGenericSub":null,"isChild":false,"helptext":null,"hasChild":true,"fieldValueOptions":null,"fieldType":"Text","fieldObjName":null,"fieldAPIName":"Print_Last_Name__c","errormsg":null,"endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":null,"answerId":null,"acknowledgeResponse":null,"acknowledge":null}],"icon":null,"fieldsList":null,"fieldJson":null,"currentTab":0,"contactId":null,"AMRlabel":"Update Print Name","accountId":null},{"tabIndex":2,"subheader":"Review and Submit","sobjectType":null,"sectionName":"Review and Submit","sectionError":false,"recordType":null,"personalInfoObjectName":null,"mandatorySubsection":null,"labelFieldsMap":[],"icon":"LnP_ReviewnSubmit.svg","fieldsList":null,"fieldJson":null,"currentTab":0,"contactId":null,"AMRlabel":"Update Print Name","accountId":null}]';
        
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('HttpStaticfakeResp');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/xml');
        Test.setMock(HttpCalloutMock.class, mock);
        HTTPResponse res =null;
        
        list<LnP_ApplyForLicenseWrapper> wrapList = new list<LnP_ApplyForLicenseWrapper>();
        LnP_ApplyForLicenseWrapper licenseWrapper = new LnP_ApplyForLicenseWrapper();
         licenseWrapper.sectionName = 'Attachments';
            licenseWrapper.subheader = 'Attachments';
            licenseWrapper.currentTab = 1;
            licenseWrapper.tabIndex = 1;
        wrapList.add(licenseWrapper);
        
           
        String str = '[{"tabIndex":1,"subheader":"Personal Information","sobjectType":null,"sectionName":"Personal Information","sectionError":false,"recordType":null,"personalInfoObjectName":"Contact","mandatorySubsection":null,"labelFieldsMap":"","icon":"LnP_PersonalInfo.svg","fieldsList":null}] ';
        //List<LnP_ApplyForLicenseWrapper> wrapperList = (List<LnP_ApplyForLicenseWrapper>)JSON.deserialize(str, List<LnP_ApplyForLicenseWrapper>.class);
        
        Test.startTest();
        try{
        //Polaris_ServiceRequestController.getJSONWrapper(str);
        //Polaris_ServiceRequestController.fetchData('Funerals','Embalmer Intern','Update Legal Name',reqObj.Id,'CE Audit',licenseObj.Id);
        Polaris_ServiceRequestController.fetchData('Funerals','Embalmer Intern','Update Legal Name',reqObj.Id,'Change License Status',licenseObj.Id);
        Polaris_ServiceRequestController.insertApplication(datastring,5,reqObj.Id,'Funerals','Embalmer Intern','General Application');
        Polaris_ServiceRequestController.getTotalBalance(req.Id);
        Polaris_ServiceRequestController.updateAffiliation(req.Id);
        Polaris_ServiceRequestController.getMetadata('Engineers', 'Legal Background Update', 'Engineer in Training');
        Polaris_ServiceRequestController.getBackgroundInformation(reqSET);
        Polaris_ServiceRequestController.getAddresses(reqSET);
        //(List<LnP_ApplyForLicenseWrapper> wrapperList,String Board, String LicenseType, String ApplicationType){
        Polaris_ServiceRequestController.fetchSubmission(wrapList,'Funerals','Embalmer Intern','General Application');
        Polaris_ServiceRequestController.callCompositeAPI(reqObj.Id,reqObj.Description__c);}
        catch(Exception ex){
         Polaris_CreateErrorLog_Exception.createErrorLogs(ex,'Polaris_ServiceRequest_Test','testMethod1');
        }
        Test.stopTest();
        
    }
    
    static testMethod void testMethod2(){
        
        
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('User Account').getRecordTypeId();
        Id ConRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        Id LicRecTypeId = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        
        Account acc = DOL_TestDataFactory.createAccount(AccRecTypeId);         
        Contact con = DOL_TestDataFactory.createContact(ConRecTypeId,acc.id); 
        
        
        MUSW__Account_Contact__c ac = new MUSW__Account_Contact__c();
        ac.First_Name__c = 'test';
        ac.Last_Name__c = 'test';
        ac.Role__c = 'Administrator';
        ac.Email__c = 'test@test.com';
        ac.Title__c = 'test';
        ac.Status__c = 'Active';
        ac.MUSW__Contact__c = con.Id;
        ac.MUSW__Account__c = acc.Id;
        
        ac.Account_Admin__c = true;
        ac.isAdminContact__c = true;
        insert ac;
        
        Task acts = new Task();
        acts.WhatId = ac.Id;
        acts.Status = 'Pending';        
        acts.Priority = 'Normal';
        acts.Subject = 'test';
        acts.OwnerId = UserInfo.getUserId();
        insert acts;            
        Id licRecordTypeId = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        MUSW__License2__c licenseObj = DOL_TestDataFactory.createLicense(licRecordTypeId,acc.Id,'Funerals','Embalmer Intern','General Application');
        
        Request__c reqObj = DOL_TestDataFactory.createRequest(licenseObj.Id,'Funerals','Embalmer Intern');
        reqObj.Description__c = 'Request Description';
        //reqObj.License_Type__c = 'Professional Engineer';
        reqObj.Service_Request_Type__c = 'Endorsement';
        reqObj.Stage__c = 0;
       reqObj.Form_JSON__c ='{"compositeRequest":[{"body":{"Answer":"Yes","Application":"a2pr00000006guQAAQ","Question":"a2mr0000000WgmQAAS"},"method":"POST","referenceId":"refId0","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},' + 
        '{"body":{"Answer":"Yes","Application":"a2pr00000006guQAAQ","Question":"a2mr0000000WgmVAAS"},"method":"POST","referenceId":"refId1","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},' + 
        '{"body":{"Answer":"Yes","Application":"a2pr00000006guQAAQ","Question":"a2mr0000000WgmaAAC"},"method":"POST","referenceId":"refId2","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},' + 
        '{"body":{"Answer":"No","Application":"a2pr00000006guQAAQ","Question":"a2mr0000000WgmfAAC"},"method":"POST","referenceId":"refId3","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},' + 
        '{"method":"DELETE","referenceId":"refDocId10","url":"/services/data/v38.0/sobjects/ContentDocumentLink/06Ar0000002WjLoEAK"},' + 
        '{"body":{"ContentDocumentId":"069r00000012ZreAAE","LinkedEntityId":"@{refSubId1.id}","ShareType":"I"},"method":"POST","referenceId":"refContId1","url":"/services/data/v38.0/sobjects/ContentDocumentLink"},' + 
        '{"body":{"ContentDocumentId":"069r00000012ZreAAE;","MUSW_Application2":"a2pr00000006guQAAQ","MUSW_Description":"2. Basic Appraisal Procedures (30 hour course)"},"method":"POST","referenceId":"refSubId1","url":"/services/data/v38.0/sobjects/MUSW__Submission__c"},' + 
        '{"method":"DELETE","referenceId":"refDocId20","url":"/services/data/v38.0/sobjects/ContentDocumentLink/06Ar0000002WjMiEAK"},' + 
        '{"body":{"ContentDocumentId":"069r00000012ZvUAAU","LinkedEntityId":"@{refSubId2.id}","ShareType":"I"},"method":"POST","referenceId":"refContId2","url":"/services/data/v38.0/sobjects/ContentDocumentLink"},' + 
        '{"body":{"ContentDocumentId":"069r00000012ZvUAAU;","MUSW_Application2":"a2pr00000006guQAAQ","MUSW_Description":"3. The National Uniform Standards of Professional Appraisal Practice course"},"method":"POST","referenceId":"refSubId2","url":"/services/data/v38.0/sobjects/MUSW__Submission__c"},' + 
        '{"method":"DELETE","referenceId":"refDocId30","url":"/services/data/v38.0/sobjects/ContentDocumentLink/06Ar0000002WjOPEA0"},' + 
        '{"body":{"ContentDocumentId":"069r00000012ZwcAAE","LinkedEntityId":"@{refSubId3.id}","ShareType":"I"},"method":"POST","referenceId":"refContId3","url":"/services/data/v38.0/sobjects/ContentDocumentLink"},' + 
        '{"body":{"ContentDocumentId":"069r00000012ZwcAAE;","MUSW_Application2":"a2pr00000006guQAAQ","MUSW_Description":"6. Residential Market Analysis and HBU (15 hour course)"},"method":"POST","referenceId":"refSubId3","url":"/services/data/v38.0/sobjects/MUSW__Submission__c"},' + 
        '{"method":"DELETE","referenceId":"refDocId40","url":"/services/data/v38.0/sobjects/ContentDocumentLink/06Ar0000002WjPIEA0"},' + 
        '{"body":{"ContentDocumentId":"069r00000012ZxLAAU","LinkedEntityId":"@{refSubId4.id}","ShareType":"I"},"method":"POST","referenceId":"refContId4","url":"/services/data/v38.0/sobjects/ContentDocumentLink"},' + 
        '{"body":{"ContentDocumentId":"069r00000012ZxLAAU;","MUSW_Application2":"a2pr00000006guQAAQ","MUSW_Description":"5. Residential Appraiser Site Valuation & Cost Approach (15 hour course)"},"method":"POST","referenceId":"refSubId4","url":"/services/data/v38.0/sobjects/MUSW__Submission__c"},' + 
        '{"method":"DELETE","referenceId":"refDocId50","url":"/services/data/v38.0/sobjects/ContentDocumentLink/06Ar0000002WjSgEAK"},' + 
        '{"body":{"ContentDocumentId":"069r00000012ZzWAAU","LinkedEntityId":"@{refSubId5.id}","ShareType":"I"},"method":"POST","referenceId":"refContId5","url":"/services/data/v38.0/sobjects/ContentDocumentLink"},' + 
        '{"body":{"ContentDocumentId":"069r00000012ZzWAAU;","MUSW_Application2":"a2pr00000006guQAAQ","MUSW_Description":"10. Appraiser subject matter elective (20 hours)"},"method":"POST","referenceId":"refSubId5","url":"/services/data/v38.0/sobjects/MUSW__Submission__c"},' + 
        '{"method":"DELETE","referenceId":"refDocId60","url":"/services/data/v38.0/sobjects/ContentDocumentLink/06Ar0000002WjVuEAK"},' + 
        '{"body":{"ContentDocumentId":"069r00000012a1hAAA","LinkedEntityId":"@{refSubId6.id}","ShareType":"I"},"method":"POST","referenceId":"refContId6","url":"/services/data/v38.0/sobjects/ContentDocumentLink"},' + 
        '{"body":{"ContentDocumentId":"069r00000012a1hAAA;","MUSW_Application2":"a2pr00000006guQAAQ","MUSW_Description":"Certified Residential Appraiser Question 2 Attachment"},"method":"POST","referenceId":"refSubId6","url":"/services/data/v38.0/sobjects/MUSW__Submission__c"},' + 
        '{"method":"DELETE","referenceId":"refDocId70","url":"/services/data/v38.0/sobjects/ContentDocumentLink/06Ar0000002WjWmEAK"},' + 
        '{"body":{"ContentDocumentId":"069r00000012a1UAAQ","LinkedEntityId":"@{refSubId7.id}","ShareType":"I"},"method":"POST","referenceId":"refContId7","url":"/services/data/v38.0/sobjects/ContentDocumentLink"},' + 
        '{"body":{"ContentDocumentId":"069r00000012a1UAAQ;","MUSW_Application2":"a2pr00000006guQAAQ","MUSW_Description":"Proof of appraiser specific education as specified in WAC 308-125-040 (1-10)"},"method":"POST","referenceId":"refSubId7","url":"/services/data/v38.0/sobjects/MUSW__Submission__c"},' + 
        '{"method":"DELETE","referenceId":"refDocId80","url":"/services/data/v38.0/sobjects/ContentDocumentLink/06Ar0000002WjXlEAK"},' + 
        '{"body":{"ContentDocumentId":"069r00000012a34AAA","LinkedEntityId":"@{refSubId8.id}","ShareType":"I"},"method":"POST","referenceId":"refContId8","url":"/services/data/v38.0/sobjects/ContentDocumentLink"},' + 
        '{"body":{"ContentDocumentId":"069r00000012a34AAA;","MUSW_Application2":"a2pr00000006guQAAQ","MUSW_Description":"4. Residential Appraiser Report Writing & Case Studies (15 hour course)"},"method":"POST","referenceId":"refSubId8","url":"/services/data/v38.0/sobjects/MUSW__Submission__c"},' + 
        '{"method":"DELETE","referenceId":"refDocId90","url":"/services/data/v38.0/sobjects/ContentDocumentLink/06Ar0000002WjXnEAK"},' + 
        '{"body":{"ContentDocumentId":"069r00000012a35AAA","LinkedEntityId":"@{refSubId9.id}","ShareType":"I"},"method":"POST","referenceId":"refContId9","url":"/services/data/v38.0/sobjects/ContentDocumentLink"},' + 
        '{"body":{"ContentDocumentId":"069r00000012a35AAA;","MUSW_Application2":"a2pr00000006guQAAQ","MUSW_Description":"Certified Residential Appraiser Question 3 Attachment"},"method":"POST","referenceId":"refSubId9","url":"/services/data/v38.0/sobjects/MUSW__Submission__c"},' + 
        '{"body":{"MUSW_Application2":"a2pr00000006guQAAQ","MUSW_Description":"Official College Transcript"},"method":"POST","referenceId":"refSubId9","url":"/services/data/v38.0/sobjects/MUSW__Submission__c"},' + 
        '{"method":"DELETE","referenceId":"refDocId100","url":"/services/data/v38.0/sobjects/ContentDocumentLink/06Ar0000002WjZMEA0"},' + 
        //'{"body":{"ContentDocumentId":"069r00000012a0gAAA","LinkedEntityId":"@{refSubId10.id}","ShareType":"I"},"method":"POST","referenceId":"refContId10","url":"/services/data/v38.0/sobjects/ContentDocumentLink"},' + 
        //'{"body":{"ContentDocumentId":"069r00000012a0gAAA;","MUSW_Application2":"a2pr00000006guQAAQ","MUSW_Description":"8. Advanced Residential Applications & Case Studies (15 hour course)"},"method":"POST","referenceId":"refSubId10","url":"/services/data/v38.0/sobjects/MUSW__Submission__c"},'+
        '{"method":"DELETE","referenceId":"refDocId110","url":"/services/data/v38.0/sobjects/ContentDocumentLink/06Ar0000002Wja1EAC"},'+
        '{"body":{"ContentDocumentId":"069r00000012a4gAAA","LinkedEntityId":"@{refSubId11.id}","ShareType":"I"},"method":"POST","referenceId":"refContId11","url":"/services/data/v38.0/sobjects/ContentDocumentLink"},' + 
        '{"body":{"ContentDocumentId":"069r00000012a4gAAA;","MUSW_Application2":"a2pr00000006guQAAQ","MUSW_Description":"Certified Residential Appraiser Question 1 Attachment"},"method":"POST","referenceId":"refSubId11","url":"/services/data/v38.0/sobjects/MUSW__Submission__c"},' + 
        '{"method":"DELETE","referenceId":"refDocId120","url":"/services/data/v38.0/sobjects/ContentDocumentLink/06Ar0000002WjadEAC"},' + 
        '{"body":{"ContentDocumentId":"069r00000012a4BAAQ","LinkedEntityId":"@{refSubId12.id}","ShareType":"I"},"method":"POST","referenceId":"refContId12","url":"/services/data/v38.0/sobjects/ContentDocumentLink"},' + 
        '{"body":{"ContentDocumentId":"069r00000012a4BAAQ;","MUSW_Application2":"a2pr00000006guQAAQ","MUSW_Description":"7. Residential Sales Comparison and Income Approach (30 hour course)"},"method":"POST","referenceId":"refSubId12","url":"/services/data/v38.0/sobjects/MUSW__Submission__c"},' + 
        '{"method":"DELETE","referenceId":"refDocId130","url":"/services/data/v38.0/sobjects/ContentDocumentLink/06Ar0000002WjcCEAS"},' + 
        '{"body":{"ContentDocumentId":"069r00000012a5yAAA","LinkedEntityId":"@{refSubId13.id}","ShareType":"I"},"method":"POST","referenceId":"refContId13","url":"/services/data/v38.0/sobjects/ContentDocumentLink"},' + 
        '{"body":{"ContentDocumentId":"069r00000012a5yAAA;","MUSW_Application2":"a2pr00000006guQAAQ","MUSW_Description":"Experience Log"},"method":"POST","referenceId":"refSubId13","url":"/services/data/v38.0/sobjects/MUSW__Submission__c"},' + 
        '{"method":"DELETE","referenceId":"refDocId140","url":"/services/data/v38.0/sobjects/ContentDocumentLink/06Ar0000002Wjd5EAC"},' + 
        '{"body":{"ContentDocumentId":"069r00000012a6NAAQ","LinkedEntityId":"@{refSubId14.id}","ShareType":"I"},"method":"POST","referenceId":"refContId14","url":"/services/data/v38.0/sobjects/ContentDocumentLink"},' + 
        '{"body":{"ContentDocumentId":"069r00000012a6NAAQ;","MUSW_Application2":"a2pr00000006guQAAQ","MUSW_Description":"1. Basic Appraisal Principles (30 hour course)"},"method":"POST","referenceId":"refSubId14","url":"/services/data/v38.0/sobjects/MUSW__Submission__c"},' + 
        '{"method":"DELETE","referenceId":"refDocId150","url":"/services/data/v38.0/sobjects/ContentDocumentLink/06Ar0000002Wjh2EAC"},' + 
        '{"body":{"ContentDocumentId":"069r00000012a97AAA","LinkedEntityId":"@{refSubId15.id}","ShareType":"I"},"method":"POST","referenceId":"refContId15","url":"/services/data/v38.0/sobjects/ContentDocumentLink"},' + 
        '{"body":{"ContentDocumentId":"069r00000012a97AAA;","MUSW_Application2":"a2pr00000006guQAAQ","MUSW_Description":"9. Statistics, Modeling & Finance (15 hour course)"},"method":"POST","referenceId":"refSubId15","url":"/services/data/v38.0/sobjects/MUSW__Submission__c"},' + 
        '{"method":"DELETE","referenceId":"refDocId160","url":"/services/data/v38.0/sobjects/ContentDocumentLink/06Ar0000002WjhgEAC"},' + 
        '{"body":{"ContentDocumentId":"069r00000012a9bAAA","LinkedEntityId":"@{refSubId16.id}","ShareType":"I"},"method":"POST","referenceId":"refContId16","url":"/services/data/v38.0/sobjects/ContentDocumentLink"},' + 
        '{"body":{"ContentDocumentId":"069r00000012a9bAAA;","MUSW_Application2":"a2pr00000006guQAAQ","MUSW_Description":"Certified Residential Appraiser Submissions"},"method":"POST","referenceId":"refSubId16","url":"/services/data/v38.0/sobjects/MUSW__Submission__c"}]}';
          update reqObj;
        
        Request__c req = new Request__c();
        req.Account_Contact__c = ac.Id;
        insert req;
        Set<Id> reqSET = new Set<Id>();
        reqSET.add(req.Id);
        
        //fee
        MUSW__Fee__c fee = DOL_TestDataFactory.createFeeWithLicense('Credential', 100.00 ,licenseObj.Id);        
        fee.Request__c = reqObj.Id; 
        update fee;
        
        
        //parcel
        Id parcelRecordTypeId = Schema.SObjectType.MUSW__Parcel__c.getRecordTypeInfosByDeveloperName().get('Address').getRecordTypeId(); 
        MUSW__Parcel__c parcel = DOL_TestDataFactory.createParcel(parcelRecordTypeId);
        parcel.Request_Parcel__c = reqObj.Id;
        parcel.Address_Type__c ='MAILING ADDRESS'; 
        update parcel;
              
        //submission
        MUSW__Submission__c submission =  DOL_TestDataFactory.createSubmission(licenseObj.Id);
        submission.Request__c = reqObj.Id;
        update submission;
        
        //background
        LnP_BackgroundSection__c bg = DOL_TestDataFactory.createBackgroundSection();
        bg.Request__c = reqObj.Id;
        update bg;
        
        //Insert Question
          Id questionRecordTypeId = Schema.SObjectType.Question__c.getRecordTypeInfosByDeveloperName().get('Background_Questions').getRecordTypeId(); 
         Question__c questn = DOL_TestDataFactory.createQuestion(questionRecordTypeId);
        
         Answer__c ans =  DOL_TestDataFactory.createAnswer(licenseObj.Id,questn.Id);
            
             
      /*  StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        //mock.setStaticResource('HttpStaticfakeResp');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/xml');
        Test.setMock(HttpCalloutMock.class, mock);
        HTTPResponse res =null;*/
       
        list<LnP_ApplyForLicenseWrapper> wrapList = new list<LnP_ApplyForLicenseWrapper>();
        LnP_ApplyForLicenseWrapper licenseWrapper = new LnP_ApplyForLicenseWrapper();
         licenseWrapper.sectionName = 'Attachments';
            licenseWrapper.subheader = 'Attachments';
            licenseWrapper.currentTab = 1;
            licenseWrapper.tabIndex = 1;
        wrapList.add(licenseWrapper);
        
           
     
        Test.setMock(HttpCalloutMock.class, new WebServiceMockImpl()); 
        Test.startTest();
        //Polaris_ServiceRequestController.getJSONWrapper(str);
        
        Polaris_ServiceRequestController.callCompositeAPI(reqObj.Id,reqObj.Form_JSON__c);
        Test.stopTest();
        
    }
   /* @isTest
    static testMethod void testMethod3(){
        List<ContentDocumentLink> abc = [select id,ContentDocumentId from ContentDocumentLink where LinkedEntityId= UserInfo.getUserId()  limit 1];
        Map<String,String>  abcd = new Map<String,String>();
        abcd.put(String.valueOf(abc[0].ContentDocumentId),String.valueOf(abc[0].ContentDocumentId));
        Polaris_ServiceRequestController.updateLinkedEntityId(abcd);
    }*/
}