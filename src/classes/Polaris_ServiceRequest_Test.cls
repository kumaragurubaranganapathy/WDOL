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
        
        Request__c reqObj = DOL_TestDataFactory.createRequest(licenseObj.Id,'Funerals','Embalmer Intern');
        reqObj.Description__c = 'Request Description';
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
        //Polaris_ServiceRequestController.getJSONWrapper(str);
        Polaris_ServiceRequestController.fetchData('Funerals','Embalmer Intern','Update Legal Name',reqObj.Id,'CE Audit',licenseObj.Id);
        Polaris_ServiceRequestController.insertApplication(datastring,5,reqObj.Id,'Funerals','Embalmer Intern','General Application');
        Polaris_ServiceRequestController.getTotalBalance(req.Id);
        Polaris_ServiceRequestController.updateAffiliation(req.Id);
        Polaris_ServiceRequestController.getMetadata('Engineers', 'Legal Background Update', 'Engineer in Training');
        Polaris_ServiceRequestController.getBackgroundInformation(reqSET);
        Polaris_ServiceRequestController.getAddresses(reqSET);
        //(List<LnP_ApplyForLicenseWrapper> wrapperList,String Board, String LicenseType, String ApplicationType){
        Polaris_ServiceRequestController.fetchSubmission(wrapList,'Funerals','Embalmer Intern','General Application');
             //Polaris_ServiceRequestController.callCompositeAPI(reqObj.Id,reqObj.Description__c);
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
        reqObj.Service_Request_Type__c = 'Endorsement';
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
        
        
        MUSW__Fee__c fee = DOL_TestDataFactory.createFeeWithLicense('Credential', 100.00 ,licenseObj.Id);        
        fee.Request__c = req.Id; 
        update fee;
        
		Id parcelRecordTypeId = Schema.SObjectType.MUSW__Parcel__c.getRecordTypeInfosByDeveloperName().get('Address').getRecordTypeId(); 
        
        MUSW__Parcel__c parcel = DOL_TestDataFactory.createParcel(parcelRecordTypeId);
        parcel.Request_Parcel__c = req.Id;
        
        
        map<string,string> spSS = new Map<string,string>();
        spSS.put('key', 'value');
        
        
        LnP_BackgroundSection__c bg = DOL_TestDataFactory.createBackgroundSection();
        bg.Request__c = req.Id;
        update bg;
        
        String dataString = '[{"tabIndex":1,"subheader":"Request Information","sobjectType":null,"sectionName":"Request Information","sectionError":false,"recordType":null,"personalInfoObjectName":null,"mandatorySubsection":null,"labelFieldsMap":[{"warningMessages":null,"value":"Alex","validationCriteria":null,"uploadFile":null,"submissionDetails":null,"renderedOnUi":true,"regex":null,"radioValueOptions":[],"questionSectionDetail":"How will your name appear on the license?","questionSectionClass":"Request Questions","questionSection":"Request Questions","parentQuestionId":null,"orderBy":null,"multiValues":[],"minValue":null,"messageTriggerResponse":null,"message":null,"maxValue":null,"labelId":"a2mr0000000XFugAAG","label":"First Name or initial","isMandatorySub":null,"isMandatoryQues":true,"isGenericSub":null,"isChild":false,"helptext":null,"hasChild":false,"fieldValueOptions":null,"fieldType":"Text","fieldObjName":null,"fieldAPIName":"Print_First_Name__c","errormsg":null,"endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":null,"answerId":null,"acknowledgeResponse":null,"acknowledge":null},{"warningMessages":null,"value":"R","validationCriteria":null,"uploadFile":null,"submissionDetails":null,"renderedOnUi":true,"regex":null,"radioValueOptions":[],"questionSectionDetail":null,"questionSectionClass":"Request Questions","questionSection":"null","parentQuestionId":null,"orderBy":null,"multiValues":[],"minValue":null,"messageTriggerResponse":null,"message":null,"maxValue":null,"labelId":"a2mr0000000XFuhAAG","label":"Middle Name or Initial","isMandatorySub":null,"isMandatoryQues":false,"isGenericSub":null,"isChild":false,"helptext":null,"hasChild":false,"fieldValueOptions":null,"fieldType":"Text","fieldObjName":null,"fieldAPIName":"Print_Middle_Name__c","errormsg":null,"endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":null,"answerId":null,"acknowledgeResponse":null,"acknowledge":null},{"warningMessages":null,"value":"House","validationCriteria":null,"uploadFile":null,"submissionDetails":null,"renderedOnUi":true,"regex":null,"radioValueOptions":[],"questionSectionDetail":null,"questionSectionClass":"Request Questions","questionSection":"null","parentQuestionId":null,"orderBy":null,"multiValues":[],"minValue":null,"messageTriggerResponse":null,"message":null,"maxValue":null,"labelId":"a2mr0000000XFuiAAG","label":"Last Name","isMandatorySub":null,"isMandatoryQues":true,"isGenericSub":null,"isChild":false,"helptext":null,"hasChild":true,"fieldValueOptions":null,"fieldType":"Text","fieldObjName":null,"fieldAPIName":"Print_Last_Name__c","errormsg":null,"endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":null,"answerId":null,"acknowledgeResponse":null,"acknowledge":null}],"icon":null,"fieldsList":null,"fieldJson":null,"currentTab":0,"contactId":null,"AMRlabel":"Update Print Name","accountId":null},{"tabIndex":2,"subheader":"Review and Submit","sobjectType":null,"sectionName":"Review and Submit","sectionError":false,"recordType":null,"personalInfoObjectName":null,"mandatorySubsection":null,"labelFieldsMap":[],"icon":"LnP_ReviewnSubmit.svg","fieldsList":null,"fieldJson":null,"currentTab":0,"contactId":null,"AMRlabel":"Update Print Name","accountId":null}]';
        
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
        
           
        String str = '[{"tabIndex":1,"subheader":"Personal Information","sobjectType":null,"sectionName":"Personal Information","sectionError":false,"recordType":null,"personalInfoObjectName":"Contact","mandatorySubsection":null,"labelFieldsMap":"","icon":"LnP_PersonalInfo.svg","fieldsList":null}] ';
        //List<LnP_ApplyForLicenseWrapper> wrapperList = (List<LnP_ApplyForLicenseWrapper>)JSON.deserialize(str, List<LnP_ApplyForLicenseWrapper>.class);
       
        Test.setMock(HttpCalloutMock.class, new WebServiceMockImpl()); 
        Test.startTest();
        //Polaris_ServiceRequestController.getJSONWrapper(str);
        
             Polaris_ServiceRequestController.callCompositeAPI(reqObj.Id,reqObj.Description__c);
        Test.stopTest();
        
    }
}