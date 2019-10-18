@isTest
public class Polaris_ApplyForLicenseControllerTest{
    
@isTest
static void method1(){
    
    User u = DOL_TestDataFactory.createPortalAccountUser();
    System.runAs(u){
    Test.startTest();
    Account acc = new Account();
    acc.Name = 'Business Account Test';
    acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
    insert acc;
    
    Question__c ques = new Question__c();
    ques.Question_Body__c = 'Within the last 10 years, had any action (fine, suspension, revocation, censure, surrender, etc.) taken against any professional or occupational license, certification, or permit held by them?';
    ques.Data_Type__c = 'Yes_No';
    ques.Parent_Object_API_Name__c = 'MUSW__License2__c';
    ques.Application_Type__c = 'TimeShares';
    ques.Credential_Type__c = 'Timeshare Salesperson';
    ques.External_Id__c = 'abc123';
    ques.QuestionFieldAPI__c = '';
    ques.Application_Method__c = 'General Application';
    ques.status__c = 'Active';
    ques.recordtypeId = Schema.SObjectType.Question__c.getRecordTypeInfosByName().get('License Information').getRecordTypeId();
    insert ques;
    
    MUSW__Master_Submission_List__c mstLstSub = new MUSW__Master_Submission_List__c();
    mstLstSub.Order_No__c = 100;
    mstLstSub.Submission_Type__c = 'Softcopy: To be Uploaded';
    mstLstSub.Show_For__c = 'License;Credential;Service Request';
    mstLstSub.Name = 'Timeshare Salesperson  Reinstatement Attachment';
    mstLstSub.Title__c = '';
    mstLstSub.Expected_Answer__c = '';
    mstLstSub.Required__c = false;
    mstLstSub.Effective_Start_Date__c = System.Today() -1;
    mstLstSub.Default__c = true;
    mstLstSub.Application_Type__c = 'Timeshares';
    mstLstSub.Credential_Type__c = 'Timeshare Salesperson';
    mstLstSub.Application_Method__c = 'General Application';
    mstLstSub.Object__c = 'MUSW__License2__c';
    mstLstSub.External_Id__c = 'a1';
    insert mstLstSub;
    
    MUSW__Master_Submission_List__c mstLstSub1 = new MUSW__Master_Submission_List__c();
    mstLstSub1.Order_No__c = 100;
    mstLstSub1.Submission_Type__c = 'Hardcopy: To be Mailed';
    mstLstSub1.Show_For__c = 'License;Credential;Service Request';
    mstLstSub1.Name = 'Miscellaneous';
    mstLstSub1.Title__c = '';
    mstLstSub1.Expected_Answer__c = '';
    mstLstSub1.Required__c = false;
    mstLstSub1.Effective_Start_Date__c = System.Today() -1;
    mstLstSub1.Default__c = true;
    mstLstSub1.Application_Type__c = 'Timeshares';
    mstLstSub1.Credential_Type__c = 'Timeshare Salesperson';
    mstLstSub1.Object__c = 'MUSW__License2__c';
    mstLstSub1.External_Id__c = 'a2';
    insert mstLstSub1;
    
    DOL_TestDataFactory.createApplicationField('FirstName','Timeshares','Timeshare Salesperson','Contact');
    
    MUSW__Application2__c app = new MUSW__Application2__c();
    app.MUSW__Account__c = acc.Id;
    app.Stage__c = 4;
    app.Application_Type__c = 'Timeshares';
    app.Application_Method__c = 'General Application';
    app.Credential_Type__c = 'Timeshare Salesperson';
    app.Form_JSON__c = '{"compositeRequest":[{"body":{"Answer":"Using my full legal name","Application":"a06r0000001yR9HAAU","Question":"a2mr0000000WhgVAAS"},"method":"POST","referenceId":"refId1","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"No","Application":"a06r0000001yR9HAAU","Question":"a2mr0000000WRwKAAW"},"method":"POST","referenceId":"refId5","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"No","Application":"a06r0000001yR9HAAU","Question":"a2mr0000000WRwLAAW"},"method":"POST","referenceId":"refId7","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"No","Application":"a06r0000001yR9HAAU","Question":"a2mr0000000WRwMAAW"},"method":"POST","referenceId":"refId9","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"No","Application":"a06r0000001yR9HAAU","Question":"a2mr0000000WRwNAAW"},"method":"POST","referenceId":"refId11","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Application":"a06r0000001yR9HAAU","Question":"a2mr0000000WYcrAAG"},"method":"POST","referenceId":"refId13","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"method":"DELETE","referenceId":"refDocId11","url":"/services/data/v38.0/sobjects/ContentDocumentLink/null"},{"body":{"ContentDocumentId":"069r0000001be5nAAA","LinkedEntityId":"@{refSubId1.id}","ShareType":"I"},"method":"POST","referenceId":"refContId1","url":"/services/data/v38.0/sobjects/ContentDocumentLink"},{"body":{"ContentDocumentId":"069r0000001be5nAAA;","MUSW_Application2":"a06r0000001yR9HAAU","MUSW_Description":"Miscellaneous"},"method":"POST","referenceId":"refSubId1","url":"/services/data/v38.0/sobjects/MUSW__Submission__c"}]}';
    insert app;
    
    Polaris_ApplyForLicenseController.fetchData('Timeshares','Timeshare Salesperson','General Application','flow', app.Id);
    Polaris_ApplyForLicenseController.MapgetPicklistFieldValues('MUSW__License2__c','Credential_Type__c');
    Polaris_ApplyForLicenseController.getUpgradeLicenseId(app.Id);
    
    Id commId = Polaris_ApplyForLicenseController.getCommunityUserContactId();
    Id ContactRecordType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact with PII').getRecordTypeId();
    contact con = DOL_TestDataFactory.createContact(ContactRecordType,acc.Id); 
    Id parcelRecordTypeId = Schema.SObjectType.MUSW__Parcel__c.getRecordTypeInfosByName().get('Address').getRecordTypeId();
    MUSW__Parcel__c parc = new MUSW__Parcel__c(RecordTypeId = parcelRecordTypeId, International_Address__c = '345 Street', Country__c = 'Canada', Status__c = 'Active',MUSW__Primary_Contact__c = con.Id,Application_BG__c = app.Id );
    insert parc;
    
    Polaris_ApplyForLicenseController.getAllAddressForValidation(con.Id,app.Id);
    Id LicRecordtype = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
    MUSW__License2__c lic = DOL_TestDataFactory.createLicense(LicRecordtype,acc.Id,'Timeshares','Timeshare Salesperson','General Application');
    Polaris_ApplyForLicenseController.getTotalBalance(lic.Id);
    Polaris_ApplyForLicenseController.getFormattedValue('reteruns');
    Polaris_ApplyForLicenseController.UserInfo();
    
    Test.StopTest();
     
    }
}

    @isTest
    static void insertApplicationTest(){
    
    Account acc = new Account();
    acc.Name = 'Business Account Test';
    acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
    insert acc;
    
    MUSW__Application2__c app = new MUSW__Application2__c();
    app.MUSW__Account__c = acc.Id;
    app.Stage__c = 4;
    app.Application_Type__c = 'Timeshares';
    app.Application_Method__c = 'General Application';
    app.Credential_Type__c = 'Timeshare Salesperson';
    app.Form_JSON__c = '{"compositeRequest":[{"body":{"Answer":"Using my full legal name","Application":"a06r0000001yR9HAAU","Question":"a2mr0000000WhgVAAS"},"method":"POST","referenceId":"refId1","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"No","Application":"a06r0000001yR9HAAU","Question":"a2mr0000000WRwKAAW"},"method":"POST","referenceId":"refId5","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"No","Application":"a06r0000001yR9HAAU","Question":"a2mr0000000WRwLAAW"},"method":"POST","referenceId":"refId7","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"No","Application":"a06r0000001yR9HAAU","Question":"a2mr0000000WRwMAAW"},"method":"POST","referenceId":"refId9","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"No","Application":"a06r0000001yR9HAAU","Question":"a2mr0000000WRwNAAW"},"method":"POST","referenceId":"refId11","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Application":"a06r0000001yR9HAAU","Question":"a2mr0000000WYcrAAG"},"method":"POST","referenceId":"refId13","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"method":"DELETE","referenceId":"refDocId11","url":"/services/data/v38.0/sobjects/ContentDocumentLink/null"},{"body":{"ContentDocumentId":"069r0000001be5nAAA","LinkedEntityId":"@{refSubId1.id}","ShareType":"I"},"method":"POST","referenceId":"refContId1","url":"/services/data/v38.0/sobjects/ContentDocumentLink"},{"body":{"ContentDocumentId":"069r0000001be5nAAA;","MUSW_Application2":"a06r0000001yR9HAAU","MUSW_Description":"Miscellaneous"},"method":"POST","referenceId":"refSubId1","url":"/services/data/v38.0/sobjects/MUSW__Submission__c"}]}';
    insert app;
    
    MUSW__Application2__c app1 = new MUSW__Application2__c();
    app1.MUSW__Account__c = acc.Id;
    app1.Stage__c = 4;
    app1.Application_Type__c = 'Notary Public';
    app1.Application_Method__c = 'General Application';
    app1.Credential_Type__c = 'Notary Public';
    insert app1;
    
    String dataString = '[{"tabIndex":1,"subheader":"Personal Information","sobjectType":null,"sectionName":"Personal Information","sectionError":false,"recordType":null,"personalInfoObjectName":"Contact","mandatorySubsection":["Physical Address","test"],"labelFieldsMap":[],"icon":"LnP_PersonalInfo.svg","fieldsList":null}]';
    String dataString2 = '[{"tabIndex":2,"subheader":"License Information","sobjectType":null,"sectionName":"License Information","sectionError":true,"recordType":null,"personalInfoObjectName":null,"mandatorySubsection":["Qualifying Education","Test"],"labelFieldsMap":[{"warningMessages":null,"value":null,"validationCriteria":null,"uploadFile":null,"submissionDetails":null,"renderedOnUi":true,"regex":null,"radioValueOptions":[],"questionSectionDetail":null,"questionSectionClass":"General Questions","questionSection":"General Questions","parentQuestionId":null,"orderBy":null,"multiValues":[],"minValue":null,"messageTriggerResponse":null,"message":null,"maxValue":null,"labelId":"a2mr0000000XM3qAAG","label":"How do you want your name displayed on your license?","isMandatorySub":null,"isMandatoryQues":true,"isGenericSub":null,"isChild":false,"helptext":null,"hasChild":true,"fieldValueOptions":["--Select--","Using my full legal name","Using a different version of my name"],"fieldType":"Picklist","fieldObjName":null,"fieldAPIName":null,"errormsg":null,"endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":null,"answerId":null,"acknowledgeResponse":null,"acknowledge":null},{"warningMessages":null,"value":null,"validationCriteria":null,"uploadFile":null,"submissionDetails":null,"renderedOnUi":false,"regex":null,"radioValueOptions":[],"questionSectionDetail":null,"questionSectionClass":"General Questions","questionSection":"null","parentQuestionId":"a2mr0000000XM3qAAG","orderBy":null,"multiValues":[],"minValue":null,"messageTriggerResponse":null,"message":null,"maxValue":null,"labelId":"a2mr0000000XM40AAG","label":"How will your name appear on the license?<br><br>First Name or Initial","isMandatorySub":null,"isMandatoryQues":true,"isGenericSub":null,"isChild":true,"helptext":null,"hasChild":false,"fieldValueOptions":null,"fieldType":"Text","fieldObjName":null,"fieldAPIName":null,"errormsg":null,"endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":"Using a different version of my name","answerId":null,"acknowledgeResponse":null,"acknowledge":null},{"warningMessages":null,"value":null,"validationCriteria":null,"uploadFile":null,"submissionDetails":null,"renderedOnUi":false,"regex":null,"radioValueOptions":[],"questionSectionDetail":null,"questionSectionClass":"General Questions","questionSection":"null","parentQuestionId":"a2mr0000000XM3qAAG","orderBy":null,"multiValues":[],"minValue":null,"messageTriggerResponse":null,"message":null,"maxValue":null,"labelId":"a2mr0000000XM45AAG","label":"Middle Name or Initial","isMandatorySub":null,"isMandatoryQues":true,"isGenericSub":null,"isChild":true,"helptext":null,"hasChild":false,"fieldValueOptions":null,"fieldType":"Text","fieldObjName":null,"fieldAPIName":null,"errormsg":null,"endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":"Using a different version of my name","answerId":null,"acknowledgeResponse":null,"acknowledge":null},{"warningMessages":null,"value":null,"validationCriteria":null,"uploadFile":null,"submissionDetails":null,"renderedOnUi":false,"regex":null,"radioValueOptions":[],"questionSectionDetail":null,"questionSectionClass":"General Questions","questionSection":"null","parentQuestionId":"a2mr0000000XM3qAAG","orderBy":null,"multiValues":[],"minValue":null,"messageTriggerResponse":null,"message":null,"maxValue":null,"labelId":"a2mr0000000XM4FAAW","label":"Last Name","isMandatorySub":null,"isMandatoryQues":true,"isGenericSub":null,"isChild":true,"helptext":null,"hasChild":false,"fieldValueOptions":null,"fieldType":"Text","fieldObjName":null,"fieldAPIName":null,"errormsg":null,"endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":"Using a different version of my name","answerId":null,"acknowledgeResponse":null,"acknowledge":null},{"warningMessages":null,"value":null,"validationCriteria":null,"uploadFile":null,"submissionDetails":null,"renderedOnUi":true,"regex":null,"radioValueOptions":[{"value":"Yes","label":"Yes"},{"value":"No","label":"No"}],"questionSectionDetail":null,"questionSectionClass":"General Questions","questionSection":"null","parentQuestionId":null,"orderBy":null,"multiValues":[],"minValue":null,"messageTriggerResponse":null,"message":null,"maxValue":null,"labelId":"a2mr0000000XM3vAAG","label":"Have you ever been educated, licensed, employed, or done business under a different name?","isMandatorySub":null,"isMandatoryQues":true,"isGenericSub":null,"isChild":false,"helptext":null,"hasChild":true,"fieldValueOptions":null,"fieldType":"Yes_No","fieldObjName":null,"fieldAPIName":null,"errormsg":null,"endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":null,"answerId":null,"acknowledgeResponse":null,"acknowledge":null},{"warningMessages":null,"value":null,"validationCriteria":null,"uploadFile":null,"submissionDetails":null,"renderedOnUi":false,"regex":null,"radioValueOptions":[],"questionSectionDetail":null,"questionSectionClass":"General Questions","questionSection":"null","parentQuestionId":"a2mr0000000XM3vAAG","orderBy":null,"multiValues":[],"minValue":null,"messageTriggerResponse":null,"message":null,"maxValue":null,"labelId":"a2mr0000000XM4KAAW","label":"Former First Name","isMandatorySub":null,"isMandatoryQues":true,"isGenericSub":null,"isChild":true,"helptext":null,"hasChild":false,"fieldValueOptions":null,"fieldType":"Text","fieldObjName":null,"fieldAPIName":null,"errormsg":null,"endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":"Yes","answerId":null,"acknowledgeResponse":null,"acknowledge":null},{"warningMessages":null,"value":null,"validationCriteria":null,"uploadFile":null,"submissionDetails":null,"renderedOnUi":false,"regex":null,"radioValueOptions":[],"questionSectionDetail":null,"questionSectionClass":"General Questions","questionSection":"null","parentQuestionId":"a2mr0000000XM3vAAG","orderBy":null,"multiValues":[],"minValue":null,"messageTriggerResponse":null,"message":null,"maxValue":null,"labelId":"a2mr0000000XM4PAAW","label":"Former Middle Name","isMandatorySub":null,"isMandatoryQues":true,"isGenericSub":null,"isChild":true,"helptext":null,"hasChild":false,"fieldValueOptions":null,"fieldType":"Text","fieldObjName":null,"fieldAPIName":null,"errormsg":null,"endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":"Yes","answerId":null,"acknowledgeResponse":null,"acknowledge":null},{"warningMessages":null,"value":null,"validationCriteria":null,"uploadFile":null,"submissionDetails":null,"renderedOnUi":false,"regex":null,"radioValueOptions":[],"questionSectionDetail":null,"questionSectionClass":"General Questions","questionSection":"null","parentQuestionId":"a2mr0000000XM3vAAG","orderBy":null,"multiValues":[],"minValue":null,"messageTriggerResponse":null,"message":null,"maxValue":null,"labelId":"a2mr0000000XM4UAAW","label":"Former Last Name","isMandatorySub":null,"isMandatoryQues":true,"isGenericSub":null,"isChild":true,"helptext":null,"hasChild":false,"fieldValueOptions":null,"fieldType":"Text","fieldObjName":null,"fieldAPIName":null,"errormsg":null,"endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":"Yes","answerId":null,"acknowledgeResponse":null,"acknowledge":null},{"warningMessages":null,"value":null,"validationCriteria":null,"uploadFile":null,"submissionDetails":null,"renderedOnUi":true,"regex":null,"radioValueOptions":[{"value":"Yes","label":"Yes"},{"value":" No","label":" No"}],"questionSectionDetail":null,"questionSectionClass":"Military Questions","questionSection":"Military Questions","parentQuestionId":null,"orderBy":null,"multiValues":[],"minValue":null,"messageTriggerResponse":null,"message":null,"maxValue":null,"labelId":"a2mr0000000WkjSAAS","label":"I am a current or former member of the armed forces, the United States Public Health Service Commissioned Corps, or the Merchant Marines of the United States.","isMandatorySub":null,"isMandatoryQues":true,"isGenericSub":null,"isChild":false,"helptext":null,"hasChild":false,"fieldValueOptions":null,"fieldType":"Yes_No","fieldObjName":null,"fieldAPIName":"Military__c","errormsg":null,"endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":null,"answerId":null,"acknowledgeResponse":null,"acknowledge":null},{"warningMessages":null,"value":null,"validationCriteria":null,"uploadFile":null,"submissionDetails":"{\"Yes\":\"Questions_timeshare11\"}","renderedOnUi":true,"regex":null,"radioValueOptions":[{"value":"Yes","label":"Yes"},{"value":"No","label":"No"}],"questionSectionDetail":null,"questionSectionClass":"Military Questions","questionSection":"null","parentQuestionId":null,"orderBy":null,"multiValues":[],"minValue":null,"messageTriggerResponse":null,"message":null,"maxValue":null,"labelId":"a2mr0000000WN9VAAW","label":"I am a current or former spouse or registered domestic partner of a military member, and I have an existing license in this profession from another state. My spouse/partner is being transferred and I am moving to Washington.","isMandatorySub":null,"isMandatoryQues":true,"isGenericSub":null,"isChild":false,"helptext":null,"hasChild":true,"fieldValueOptions":null,"fieldType":"Yes_No","fieldObjName":null,"fieldAPIName":"Military_Spouse__c","errormsg":null,"endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":null,"answerId":null,"acknowledgeResponse":null,"acknowledge":null},{"warningMessages":null,"value":null,"validationCriteria":null,"uploadFile":null,"submissionDetails":"{\"Yes\":\"Questions_timeshare3\"}","renderedOnUi":true,"regex":null,"radioValueOptions":[{"value":"Yes","label":"Yes"},{"value":"No","label":"No"}],"questionSectionDetail":"In this state or any other jurisdiction, have you or are you:","questionSectionClass":"Legal Background Questions","questionSection":"Legal Background Questions","parentQuestionId":null,"orderBy":null,"multiValues":[],"minValue":null,"messageTriggerResponse":null,"message":null,"maxValue":null,"labelId":"a2mr0000000WMNfAAO","label":"Within the last 10 years, had any action (fine, suspension, revocation, censure, surrender, etc.) taken against any professional or occupational license, certification, or permit held by you?","isMandatorySub":null,"isMandatoryQues":true,"isGenericSub":null,"isChild":false,"helptext":null,"hasChild":true,"fieldValueOptions":null,"fieldType":"Yes_No","fieldObjName":null,"fieldAPIName":null,"errormsg":null,"endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":null,"answerId":null,"acknowledgeResponse":null,"acknowledge":null},{"warningMessages":null,"value":null,"validationCriteria":null,"uploadFile":null,"submissionDetails":null,"renderedOnUi":false,"regex":null,"radioValueOptions":[],"questionSectionDetail":null,"questionSectionClass":"Legal Background Questions","questionSection":"null","parentQuestionId":"a2mr0000000WMNfAAO","orderBy":null,"multiValues":[],"minValue":null,"messageTriggerResponse":null,"message":null,"maxValue":null,"labelId":"a2mr0000000WN9aAAG","label":"Please Explain:","isMandatorySub":null,"isMandatoryQues":true,"isGenericSub":null,"isChild":true,"helptext":null,"hasChild":false,"fieldValueOptions":null,"fieldType":"Textarea","fieldObjName":null,"fieldAPIName":null,"errormsg":null,"endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":"Yes","answerId":null,"acknowledgeResponse":null,"acknowledge":null},{"warningMessages":null,"value":null,"validationCriteria":null,"uploadFile":null,"submissionDetails":"{\"Yes\":\"Questions_timeshare4\"}","renderedOnUi":true,"regex":null,"radioValueOptions":[{"value":"Yes","label":"Yes"},{"value":"No","label":"No"}],"questionSectionDetail":null,"questionSectionClass":"Legal Background Questions","questionSection":"null","parentQuestionId":null,"orderBy":null,"multiValues":[],"minValue":null,"messageTriggerResponse":null,"message":null,"maxValue":null,"labelId":"a2mr0000000WMNkAAO","label":"Within the last 10 years, had any civil court order, verdict, or judgment entered against you?","isMandatorySub":null,"isMandatoryQues":true,"isGenericSub":null,"isChild":false,"helptext":null,"hasChild":true,"fieldValueOptions":null,"fieldType":"Yes_No","fieldObjName":null,"fieldAPIName":null,"errormsg":null,"endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":null,"answerId":null,"acknowledgeResponse":null,"acknowledge":null},{"warningMessages":null,"value":null,"validationCriteria":null,"uploadFile":null,"submissionDetails":null,"renderedOnUi":false,"regex":null,"radioValueOptions":[],"questionSectionDetail":null,"questionSectionClass":"Legal Background Questions","questionSection":"null","parentQuestionId":"a2mr0000000WMNkAAO","orderBy":null,"multiValues":[],"minValue":null,"messageTriggerResponse":null,"message":null,"maxValue":null,"labelId":"a2mr0000000WN9fAAG","label":"Please Explain:","isMandatorySub":null,"isMandatoryQues":true,"isGenericSub":null,"isChild":true,"helptext":null,"hasChild":false,"fieldValueOptions":null,"fieldType":"Textarea","fieldObjName":null,"fieldAPIName":null,"errormsg":null,"endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":"Yes","answerId":null,"acknowledgeResponse":null,"acknowledge":null},{"warningMessages":null,"value":null,"validationCriteria":null,"uploadFile":null,"submissionDetails":"{\"Yes\":\"Questions_timeshare5\"}","renderedOnUi":true,"regex":null,"radioValueOptions":[{"value":"Yes","label":"Yes"},{"value":"No","label":"No"}],"questionSectionDetail":null,"questionSectionClass":"Legal Background Questions","questionSection":"null","parentQuestionId":null,"orderBy":null,"multiValues":[],"minValue":null,"messageTriggerResponse":null,"message":null,"maxValue":null,"labelId":"a2mr0000000WMNpAAO","label":"Within the last 10 years, defaulted or been convicted of or entered a plea of no contest to a gross misdemeanor or felony crime? (Don’t include traffic offenses.)","isMandatorySub":null,"isMandatoryQues":true,"isGenericSub":null,"isChild":false,"helptext":null,"hasChild":true,"fieldValueOptions":null,"fieldType":"Yes_No","fieldObjName":null,"fieldAPIName":null,"errormsg":null,"endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":null,"answerId":null,"acknowledgeResponse":null,"acknowledge":null},{"warningMessages":null,"value":null,"validationCriteria":null,"uploadFile":null,"submissionDetails":null,"renderedOnUi":false,"regex":null,"radioValueOptions":[],"questionSectionDetail":null,"questionSectionClass":"Legal Background Questions","questionSection":"null","parentQuestionId":"a2mr0000000WMNpAAO","orderBy":null,"multiValues":[],"minValue":null,"messageTriggerResponse":null,"message":null,"maxValue":null,"labelId":"a2mr0000000WN9kAAG","label":"Please Explain:","isMandatorySub":null,"isMandatoryQues":true,"isGenericSub":null,"isChild":true,"helptext":null,"hasChild":false,"fieldValueOptions":null,"fieldType":"Textarea","fieldObjName":null,"fieldAPIName":null,"errormsg":null,"endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":"Yes","answerId":null,"acknowledgeResponse":null,"acknowledge":null},{"warningMessages":null,"value":null,"validationCriteria":null,"uploadFile":null,"submissionDetails":"{\"Yes\":\"Questions_timeshare6\"}","renderedOnUi":true,"regex":null,"radioValueOptions":[{"value":"Yes","label":"Yes"},{"value":"No","label":"No"}],"questionSectionDetail":null,"questionSectionClass":"Legal Background Questions","questionSection":"null","parentQuestionId":null,"orderBy":null,"multiValues":[],"minValue":null,"messageTriggerResponse":null,"message":null,"maxValue":null,"labelId":"a2mr0000000WMNuAAO","label":"Currently under indictment, or is there a criminal complaint, charge, or information pending against you?","isMandatorySub":null,"isMandatoryQues":true,"isGenericSub":null,"isChild":false,"helptext":null,"hasChild":true,"fieldValueOptions":null,"fieldType":"Yes_No","fieldObjName":null,"fieldAPIName":null,"errormsg":null,"endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":null,"answerId":null,"acknowledgeResponse":null,"acknowledge":null},{"warningMessages":null,"value":null,"validationCriteria":null,"uploadFile":null,"submissionDetails":null,"renderedOnUi":false,"regex":null,"radioValueOptions":[],"questionSectionDetail":null,"questionSectionClass":"Legal Background Questions","questionSection":"null","parentQuestionId":"a2mr0000000WMNuAAO","orderBy":null,"multiValues":[],"minValue":null,"messageTriggerResponse":null,"message":null,"maxValue":null,"labelId":"a2mr0000000WN9pAAG","label":"Please Explain:","isMandatorySub":null,"isMandatoryQues":true,"isGenericSub":null,"isChild":true,"helptext":null,"hasChild":false,"fieldValueOptions":null,"fieldType":"Textarea","fieldObjName":null,"fieldAPIName":null,"errormsg":null,"endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":"Yes","answerId":null,"acknowledgeResponse":null,"acknowledge":null}],"icon":"LnP_BackgroundQuestions.svg","fieldsList":null,"fieldJson":null,"currentTab":0,"contactId":null,"AMRlabel":null,"accountId":null}]';
    String dataString3 = '[{"tabIndex":3,"subheader":"Attachments","sobjectType":"Submission","sectionName":"Attachments","sectionError":false,"recordType":null,"personalInfoObjectName":null,"mandatorySubsection":["Physical Address,"Qualifying Education"],"labelFieldsMap":[{"warningMessages":null,"value":null,"validationCriteria":null,"uploadFile":true,"submissionDetails":null,"renderedOnUi":null,"regex":null,"radioValueOptions":[],"questionSectionDetail":null,"questionSectionClass":null,"questionSection":null,"parentQuestionId":null,"orderBy":200,"multiValues":["069r0000001bqALAAY"],"minValue":null,"messageTriggerResponse":null,"message":null,"maxValue":null,"labelId":null,"label":"Miscellaneous","isMandatorySub":true,"isMandatoryQues":null,"isGenericSub":true,"isChild":null,"helptext":null,"hasChild":null,"fieldValueOptions":null,"fieldType":"Attachment","fieldObjName":null,"fieldAPIName":null,"errormsg":null,"endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":null,"answerId":null,"acknowledgeResponse":null,"acknowledge":null}],"icon":"LnP_Attachments.svg","fieldsList":null,"fieldJson":null,"currentTab":0,"contactId":null,"AMRlabel":null,"accountId":null}]';
    String dataString4 = '[{"tabIndex":2,"subheader":"License Information","sobjectType":null,"sectionName":"License Information","sectionError":false,"recordType":null,"personalInfoObjectName":null,"mandatorySubsection":["Physical Address,"Qualifying Education"],"labelFieldsMap":[{"warningMessages":null,"value":"Using my full legal name","validationCriteria":null,"uploadFile":null,"submissionDetails":null,"renderedOnUi":true,"regex":null,"radioValueOptions":[],"questionSectionDetail":null,"questionSectionClass":"General Questions","questionSection":"General Questions","parentQuestionId":null,"orderBy":null,"multiValues":[],"minValue":null,"messageTriggerResponse":"Using a different version of my name","message":"Name should match the stamp.","maxValue":null,"labelId":"a2mr0000000WNBAAA4","label":"How will you be signing your notary public commission?","isMandatorySub":null,"isMandatoryQues":true,"isGenericSub":null,"isChild":false,"helptext":"This is the name you will use to sign notarized documents. It will appear on your license and stamp and must be identical to the name on your surety bond. It must be in one of the following formats: J A Smith, J Ann Smith, Jane Smith, Jane A Smith, Jane Ann Smith","hasChild":true,"fieldValueOptions":["--Select--","Using my full legal name","Using a different version of my name"],"fieldType":"Picklist","fieldObjName":null,"fieldAPIName":null,"errormsg":"How do you want your name displayed on your license is required","endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":null,"answerId":null,"acknowledgeResponse":null,"acknowledge":null},{"warningMessages":null,"value":null,"validationCriteria":null,"uploadFile":null,"submissionDetails":null,"renderedOnUi":false,"regex":null,"radioValueOptions":[],"questionSectionDetail":null,"questionSectionClass":"General Questions","questionSection":"null","parentQuestionId":"a2mr0000000WNBAAA4","orderBy":null,"multiValues":[],"minValue":null,"messageTriggerResponse":null,"message":null,"maxValue":null,"labelId":"a2mr0000000WNBFAA4","label":"How will your name appear on the notary public commission license?<br><br>First Name or initial","isMandatorySub":null,"isMandatoryQues":true,"isGenericSub":null,"isChild":true,"helptext":null,"hasChild":false,"fieldValueOptions":null,"fieldType":"Text","fieldObjName":null,"fieldAPIName":null,"errormsg":"First Name or initial is required.","endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":"Using a different version of my name","answerId":null,"acknowledgeResponse":null,"acknowledge":null},{"warningMessages":null,"value":null,"validationCriteria":null,"uploadFile":null,"submissionDetails":null,"renderedOnUi":false,"regex":null,"radioValueOptions":[],"questionSectionDetail":null,"questionSectionClass":"General Questions","questionSection":"null","parentQuestionId":"a2mr0000000WNBAAA4","orderBy":null,"multiValues":[],"minValue":null,"messageTriggerResponse":null,"message":null,"maxValue":null,"labelId":"a2mr0000000WSDgAAO","label":"Middle Name or Initial","isMandatorySub":null,"isMandatoryQues":true,"isGenericSub":null,"isChild":true,"helptext":null,"hasChild":false,"fieldValueOptions":null,"fieldType":"Text","fieldObjName":null,"fieldAPIName":null,"errormsg":null,"endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":"Using a different version of my name","answerId":null,"acknowledgeResponse":null,"acknowledge":null},{"warningMessages":null,"value":null,"validationCriteria":null,"uploadFile":null,"submissionDetails":null,"renderedOnUi":false,"regex":null,"radioValueOptions":[],"questionSectionDetail":null,"questionSectionClass":"General Questions","questionSection":"null","parentQuestionId":"a2mr0000000WNBAAA4","orderBy":null,"multiValues":[],"minValue":null,"messageTriggerResponse":null,"message":null,"maxValue":null,"labelId":"a2mr0000000WSDlAAO","label":"Last Name","isMandatorySub":null,"isMandatoryQues":true,"isGenericSub":null,"isChild":true,"helptext":null,"hasChild":false,"fieldValueOptions":null,"fieldType":"Text","fieldObjName":null,"fieldAPIName":null,"errormsg":"Last Name is required","endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":"Using a different version of my name","answerId":null,"acknowledgeResponse":null,"acknowledge":null},{"warningMessages":null,"value":"No","validationCriteria":null,"uploadFile":null,"submissionDetails":null,"renderedOnUi":true,"regex":null,"radioValueOptions":[{"value":"Yes","label":"Yes"},{"value":"No","label":"No"}],"questionSectionDetail":null,"questionSectionClass":"General Questions","questionSection":"null","parentQuestionId":null,"orderBy":null,"multiValues":[],"minValue":null,"messageTriggerResponse":null,"message":null,"maxValue":null,"labelId":"a2mr0000000WkgOAAS","label":"Have you ever been educated, licensed, employed, or done business under a different name?","isMandatorySub":null,"isMandatoryQues":true,"isGenericSub":null,"isChild":false,"helptext":null,"hasChild":true,"fieldValueOptions":null,"fieldType":"Yes_No","fieldObjName":null,"fieldAPIName":null,"errormsg":null,"endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":null,"answerId":null,"acknowledgeResponse":null,"acknowledge":null},{"warningMessages":null,"value":null,"validationCriteria":null,"uploadFile":null,"submissionDetails":null,"renderedOnUi":false,"regex":null,"radioValueOptions":[],"questionSectionDetail":null,"questionSectionClass":"General Questions","questionSection":"null","parentQuestionId":"a2mr0000000WkgOAAS","orderBy":null,"multiValues":[],"minValue":null,"messageTriggerResponse":null,"message":null,"maxValue":null,"labelId":"a2mr0000000WkhIAAS","label":"Former First Name","isMandatorySub":null,"isMandatoryQues":true,"isGenericSub":null,"isChild":true,"helptext":null,"hasChild":false,"fieldValueOptions":null,"fieldType":"Text","fieldObjName":null,"fieldAPIName":null,"errormsg":null,"endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":"Yes","answerId":null,"acknowledgeResponse":null,"acknowledge":null},{"warningMessages":null,"value":null,"validationCriteria":null,"uploadFile":null,"submissionDetails":null,"renderedOnUi":false,"regex":null,"radioValueOptions":[],"questionSectionDetail":null,"questionSectionClass":"General Questions","questionSection":"null","parentQuestionId":"a2mr0000000WkgOAAS","orderBy":null,"multiValues":[],"minValue":null,"messageTriggerResponse":null,"message":null,"maxValue":null,"labelId":"a2mr0000000WkhJAAS","label":"Former Middle Name","isMandatorySub":null,"isMandatoryQues":true,"isGenericSub":null,"isChild":true,"helptext":null,"hasChild":false,"fieldValueOptions":null,"fieldType":"Text","fieldObjName":null,"fieldAPIName":null,"errormsg":null,"endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":"Yes","answerId":null,"acknowledgeResponse":null,"acknowledge":null},{"warningMessages":null,"value":null,"validationCriteria":null,"uploadFile":null,"submissionDetails":null,"renderedOnUi":false,"regex":null,"radioValueOptions":[],"questionSectionDetail":null,"questionSectionClass":"General Questions","questionSection":"null","parentQuestionId":"a2mr0000000WkgOAAS","orderBy":null,"multiValues":[],"minValue":null,"messageTriggerResponse":null,"message":null,"maxValue":null,"labelId":"a2mr0000000WkhKAAS","label":"Former Last Name","isMandatorySub":null,"isMandatoryQues":true,"isGenericSub":null,"isChild":true,"helptext":null,"hasChild":false,"fieldValueOptions":null,"fieldType":"Text","fieldObjName":null,"fieldAPIName":null,"errormsg":null,"endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":"Yes","answerId":null,"acknowledgeResponse":null,"acknowledge":null},{"warningMessages":null,"value":" No","validationCriteria":null,"uploadFile":null,"submissionDetails":null,"renderedOnUi":true,"regex":null,"radioValueOptions":[{"value":"Yes","label":"Yes"},{"value":" No","label":" No"}],"questionSectionDetail":null,"questionSectionClass":"Military Questions","questionSection":"Military Questions","parentQuestionId":null,"orderBy":null,"multiValues":[],"minValue":null,"messageTriggerResponse":null,"message":null,"maxValue":null,"labelId":"a2mr0000000WkjTAAS","label":"I am a current or former member of the armed forces, the United States Public Health Service Commissioned Corps, or the Merchant Marines of the United States.","isMandatorySub":null,"isMandatoryQues":true,"isGenericSub":null,"isChild":false,"helptext":null,"hasChild":false,"fieldValueOptions":null,"fieldType":"Yes_No","fieldObjName":null,"fieldAPIName":"Military__c","errormsg":null,"endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":null,"answerId":null,"acknowledgeResponse":null,"acknowledge":null},{"warningMessages":null,"value":"Yes","validationCriteria":null,"uploadFile":null,"submissionDetails":null,"renderedOnUi":true,"regex":null,"radioValueOptions":[{"value":"Yes","label":"Yes"},{"value":"No","label":"No"}],"questionSectionDetail":null,"questionSectionClass":"Military Questions","questionSection":"null","parentQuestionId":null,"orderBy":null,"multiValues":[],"minValue":null,"messageTriggerResponse":null,"message":null,"maxValue":null,"labelId":"a2mr0000000WNBPAA4","label":"I am a current or former spouse or registered domestic partner of a military member, and I have an existing license in this profession from another state. My spouse/partner is being transferred and I am moving to Washington.","isMandatorySub":null,"isMandatoryQues":true,"isGenericSub":null,"isChild":false,"helptext":null,"hasChild":true,"fieldValueOptions":null,"fieldType":"Yes_No","fieldObjName":null,"fieldAPIName":"Military_Spouse__c","errormsg":null,"endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":null,"answerId":null,"acknowledgeResponse":null,"acknowledge":null},{"warningMessages":null,"value":"Yes","validationCriteria":null,"uploadFile":null,"submissionDetails":"{\"Yes\":\"QUE0000024\"}","renderedOnUi":true,"regex":null,"radioValueOptions":[{"value":"Yes","label":"Yes"},{"value":"No","label":"No"}],"questionSectionDetail":"In this state or any other jurisdiction, have you or are you:","questionSectionClass":"Legal Background Questions","questionSection":"Legal Background Questions","parentQuestionId":null,"orderBy":null,"multiValues":[],"minValue":null,"messageTriggerResponse":null,"message":null,"maxValue":null,"labelId":"a2mr0000000WJgOAAW","label":"Within the last 10 years, had any action (fine, suspension, revocation, censure, surrender, etc.) taken against any professional or occupational license, certification, or permit held by you?","isMandatorySub":null,"isMandatoryQues":true,"isGenericSub":null,"isChild":false,"helptext":null,"hasChild":true,"fieldValueOptions":null,"fieldType":"Yes_No","fieldObjName":null,"fieldAPIName":null,"errormsg":null,"endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":null,"answerId":null,"acknowledgeResponse":null,"acknowledge":null},{"warningMessages":null,"value":"test","validationCriteria":null,"uploadFile":null,"submissionDetails":null,"renderedOnUi":false,"regex":null,"radioValueOptions":[],"questionSectionDetail":null,"questionSectionClass":"Legal Background Questions","questionSection":"null","parentQuestionId":"a2mr0000000WJgOAAW","orderBy":null,"multiValues":[],"minValue":null,"messageTriggerResponse":null,"message":null,"maxValue":null,"labelId":"a2mr0000000WNZ7AAO","label":"Please Explain:","isMandatorySub":null,"isMandatoryQues":true,"isGenericSub":null,"isChild":true,"helptext":null,"hasChild":false,"fieldValueOptions":null,"fieldType":"Textarea","fieldObjName":null,"fieldAPIName":null,"errormsg":null,"endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":"Yes","answerId":null,"acknowledgeResponse":null,"acknowledge":null},{"warningMessages":null,"value":"No","validationCriteria":null,"uploadFile":null,"submissionDetails":"{\"Yes\":\"QUE0000025\"}","renderedOnUi":true,"regex":null,"radioValueOptions":[{"value":"Yes","label":"Yes"},{"value":"No","label":"No"}],"questionSectionDetail":null,"questionSectionClass":"Legal Background Questions","questionSection":"null","parentQuestionId":null,"orderBy":null,"multiValues":[],"minValue":null,"messageTriggerResponse":null,"message":null,"maxValue":null,"labelId":"a2mr0000000WJgTAAW","label":"Within the last 10 years, had any civil court order, verdict, or judgment entered against you? ","isMandatorySub":null,"isMandatoryQues":true,"isGenericSub":null,"isChild":false,"helptext":null,"hasChild":true,"fieldValueOptions":null,"fieldType":"Yes_No","fieldObjName":null,"fieldAPIName":null,"errormsg":null,"endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":null,"answerId":null,"acknowledgeResponse":null,"acknowledge":null},{"warningMessages":null,"value":null,"validationCriteria":null,"uploadFile":null,"submissionDetails":null,"renderedOnUi":false,"regex":null,"radioValueOptions":[],"questionSectionDetail":null,"questionSectionClass":"Legal Background Questions","questionSection":"null","parentQuestionId":"a2mr0000000WJgTAAW","orderBy":null,"multiValues":[],"minValue":null,"messageTriggerResponse":null,"message":null,"maxValue":null,"labelId":"a2mr0000000WNZCAA4","label":"Please Explain:","isMandatorySub":null,"isMandatoryQues":true,"isGenericSub":null,"isChild":true,"helptext":null,"hasChild":false,"fieldValueOptions":null,"fieldType":"Textarea","fieldObjName":null,"fieldAPIName":null,"errormsg":null,"endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":"Yes","answerId":null,"acknowledgeResponse":null,"acknowledge":null},{"warningMessages":null,"value":"No","validationCriteria":null,"uploadFile":null,"submissionDetails":"{\"Yes\":\"QUE0000012\"}","renderedOnUi":true,"regex":null,"radioValueOptions":[{"value":"Yes","label":"Yes"},{"value":"No","label":"No"}],"questionSectionDetail":null,"questionSectionClass":"Legal Background Questions","questionSection":"null","parentQuestionId":null,"orderBy":null,"multiValues":[],"minValue":null,"messageTriggerResponse":null,"message":null,"maxValue":null,"labelId":"a2mr0000000WJg9AAG","label":"Within the last 10 years, defaulted or been convicted of or entered a plea of no contest to a gross misdemeanor or felony crime? (Don’t include traffic offenses.)","isMandatorySub":null,"isMandatoryQues":true,"isGenericSub":null,"isChild":false,"helptext":null,"hasChild":true,"fieldValueOptions":null,"fieldType":"Yes_No","fieldObjName":null,"fieldAPIName":null,"errormsg":null,"endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":null,"answerId":null,"acknowledgeResponse":null,"acknowledge":null},{"warningMessages":null,"value":null,"validationCriteria":null,"uploadFile":null,"submissionDetails":null,"renderedOnUi":false,"regex":null,"radioValueOptions":[],"questionSectionDetail":null,"questionSectionClass":"Legal Background Questions","questionSection":"null","parentQuestionId":"a2mr0000000WJg9AAG","orderBy":null,"multiValues":[],"minValue":null,"messageTriggerResponse":null,"message":null,"maxValue":null,"labelId":"a2mr0000000WNYxAAO","label":"Please Explain:","isMandatorySub":null,"isMandatoryQues":true,"isGenericSub":null,"isChild":true,"helptext":null,"hasChild":false,"fieldValueOptions":null,"fieldType":"Textarea","fieldObjName":null,"fieldAPIName":null,"errormsg":null,"endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":"Yes","answerId":null,"acknowledgeResponse":null,"acknowledge":null},{"warningMessages":null,"value":"No","validationCriteria":null,"uploadFile":null,"submissionDetails":"{\"Yes\":\"QUE0000023\"}","renderedOnUi":true,"regex":null,"radioValueOptions":[{"value":"Yes","label":"Yes"},{"value":"No","label":"No"}],"questionSectionDetail":null,"questionSectionClass":"Legal Background Questions","questionSection":"null","parentQuestionId":null,"orderBy":null,"multiValues":[],"minValue":null,"messageTriggerResponse":null,"message":null,"maxValue":null,"labelId":"a2mr0000000WJgEAAW","label":"Currently under indictment, or is there a criminal complaint, charge, or information pending against you?","isMandatorySub":null,"isMandatoryQues":true,"isGenericSub":null,"isChild":false,"helptext":null,"hasChild":true,"fieldValueOptions":null,"fieldType":"Yes_No","fieldObjName":null,"fieldAPIName":null,"errormsg":null,"endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":null,"answerId":null,"acknowledgeResponse":null,"acknowledge":null},{"warningMessages":null,"value":null,"validationCriteria":null,"uploadFile":null,"submissionDetails":null,"renderedOnUi":false,"regex":null,"radioValueOptions":[],"questionSectionDetail":null,"questionSectionClass":"Legal Background Questions","questionSection":"null","parentQuestionId":"a2mr0000000WJgEAAW","orderBy":null,"multiValues":[],"minValue":null,"messageTriggerResponse":null,"message":null,"maxValue":null,"labelId":"a2mr0000000WNZ2AAO","label":"Please Explain:","isMandatorySub":null,"isMandatoryQues":true,"isGenericSub":null,"isChild":true,"helptext":null,"hasChild":false,"fieldValueOptions":null,"fieldType":"Textarea","fieldObjName":null,"fieldAPIName":null,"errormsg":null,"endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":"Yes","answerId":null,"acknowledgeResponse":null,"acknowledge":null}],"icon":"LnP_BackgroundQuestions.svg","fieldsList":null,"fieldJson":null,"currentTab":2,"contactId":null,"AMRlabel":null,"accountId":null}]';
    String dataString5 = '[{"tabIndex":3,"subheader":"Endorsement","sobjectType":null,"sectionName":"Endorsement","sectionError":false,"recordType":null,"personalInfoObjectName":null,"mandatorySubsection":["Physical Address,"Qualifying Education"],"labelFieldsMap":[{"warningMessages":null,"value":"No","validationCriteria":null,"uploadFile":null,"submissionDetails":null,"renderedOnUi":true,"regex":null,"radioValueOptions":[{"value":"Yes","label":"Yes"},{"value":"No","label":"No"}],"questionSectionDetail":null,"questionSectionClass":"Endorsement","questionSection":"Endorsement","parentQuestionId":null,"orderBy":null,"multiValues":[],"minValue":null,"messageTriggerResponse":"Yes","message":null,"maxValue":null,"labelId":"a2mr0000000WbvkAAC","label":"Would you like to add an Electronic Records Notary Public endorsement?","isMandatorySub":null,"isMandatoryQues":true,"isGenericSub":null,"isChild":false,"helptext":null,"hasChild":true,"fieldValueOptions":null,"fieldType":"Yes_No","fieldObjName":null,"fieldAPIName":null,"errormsg":null,"endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":null,"answerId":null,"acknowledgeResponse":null,"acknowledge":null},{"warningMessages":null,"value":null,"validationCriteria":null,"uploadFile":null,"submissionDetails":null,"renderedOnUi":true,"regex":null,"radioValueOptions":[],"questionSectionDetail":null,"questionSectionClass":"Endorsement","questionSection":"null","parentQuestionId":null,"orderBy":null,"multiValues":[],"minValue":null,"messageTriggerResponse":null,"message":null,"maxValue":null,"labelId":"a2mr0000000Wir7AAC","label":"Provider Name","isMandatorySub":null,"isMandatoryQues":true,"isGenericSub":null,"isChild":false,"helptext":null,"hasChild":false,"fieldValueOptions":null,"fieldType":null,"fieldObjName":"Electronic_Notary_Provider_Information__c","fieldAPIName":"Provider_Name__c","errormsg":null,"endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":null,"answerId":null,"acknowledgeResponse":null,"acknowledge":null},{"warningMessages":null,"value":null,"validationCriteria":null,"uploadFile":null,"submissionDetails":null,"renderedOnUi":false,"regex":null,"radioValueOptions":[],"questionSectionDetail":null,"questionSectionClass":"Endorsement","questionSection":"null","parentQuestionId":"a2mr0000000WbvkAAC","orderBy":null,"multiValues":[],"minValue":null,"messageTriggerResponse":null,"message":null,"maxValue":null,"labelId":"a2mr0000000WbvpAAC","label":"Effective Date","isMandatorySub":null,"isMandatoryQues":true,"isGenericSub":null,"isChild":true,"helptext":null,"hasChild":false,"fieldValueOptions":null,"fieldType":"Text","fieldObjName":"Endorsement__c","fieldAPIName":"Effective_Date__c","errormsg":null,"endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":null,"answerId":null,"acknowledgeResponse":null,"acknowledge":null},{"warningMessages":null,"value":null,"validationCriteria":null,"uploadFile":null,"submissionDetails":null,"renderedOnUi":true,"regex":null,"radioValueOptions":[],"questionSectionDetail":null,"questionSectionClass":"Endorsement","questionSection":"null","parentQuestionId":null,"orderBy":null,"multiValues":[],"minValue":null,"messageTriggerResponse":null,"message":null,"maxValue":null,"labelId":"a2mr0000000WitPAAS","label":"Effective Date","isMandatorySub":null,"isMandatoryQues":true,"isGenericSub":null,"isChild":false,"helptext":null,"hasChild":false,"fieldValueOptions":null,"fieldType":null,"fieldObjName":"Electronic_Notary_Provider_Information__c","fieldAPIName":"Effective_Date__c","errormsg":null,"endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":null,"answerId":null,"acknowledgeResponse":null,"acknowledge":null},{"warningMessages":null,"value":null,"validationCriteria":null,"uploadFile":null,"submissionDetails":null,"renderedOnUi":true,"regex":null,"radioValueOptions":[],"questionSectionDetail":null,"questionSectionClass":"Endorsement","questionSection":"null","parentQuestionId":null,"orderBy":null,"multiValues":[],"minValue":null,"messageTriggerResponse":null,"message":null,"maxValue":null,"labelId":"a2mr0000000WitUAAS","label":"Description","isMandatorySub":null,"isMandatoryQues":true,"isGenericSub":null,"isChild":false,"helptext":null,"hasChild":false,"fieldValueOptions":null,"fieldType":null,"fieldObjName":"Electronic_Notary_Provider_Information__c","fieldAPIName":"Description__c","errormsg":null,"endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":null,"answerId":null,"acknowledgeResponse":null,"acknowledge":null},{"warningMessages":null,"value":null,"validationCriteria":null,"uploadFile":null,"submissionDetails":null,"renderedOnUi":false,"regex":null,"radioValueOptions":[],"questionSectionDetail":null,"questionSectionClass":"Endorsement","questionSection":"null","parentQuestionId":"a2mr0000000WaJzAAK","orderBy":null,"multiValues":[],"minValue":null,"messageTriggerResponse":null,"message":null,"maxValue":null,"labelId":"a2mr0000000WbvzAAC","label":"Electronic software provider details","isMandatorySub":null,"isMandatoryQues":true,"isGenericSub":null,"isChild":true,"helptext":null,"hasChild":false,"fieldValueOptions":null,"fieldType":"Text","fieldObjName":null,"fieldAPIName":null,"errormsg":null,"endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":"Other","answerId":null,"acknowledgeResponse":null,"acknowledge":null}],"icon":"LnP_QuestionsAnswers1.svg","fieldsList":null,"fieldJson":null,"currentTab":2,"contactId":null,"AMRlabel":null,"accountId":null}]';
    test.StartTest();
    String TestLicense = Polaris_ApplyForLicenseController.insertApplication(dataString,1,app.Id,'Timeshares','Timeshare Salesperson','General Application',null);
    String TestLicense1 = Polaris_ApplyForLicenseController.insertApplication(dataString2,2,app.Id,'Timeshares','Timeshare Salesperson','General Application',null);
    String TestLicense2 = Polaris_ApplyForLicenseController.insertApplication(dataString3,3,app.Id,'Timeshares','Timeshare Salesperson','General Application',null);
    String TestLicense3 = Polaris_ApplyForLicenseController.insertApplication(dataString4,2,app1.Id,'Notary Public','Notary Public','General Application',null);
    String TestLicense4 =  Polaris_ApplyForLicenseController.insertApplication(dataString5,3,app1.Id,'Notary Public','Notary Public','General Application',null);
    
    String dataString6 = '[{    "tabIndex":2,    "subheader":"License Information",    "sobjectType":null,    "sectionName":"License Information",    "sectionError":false,    "recordType":null,    "personalInfoObjectName":null,    "mandatorySubsection":null,    "labelFieldsMap":[       {          "warningMessages":null,          "value":null,          "validationCriteria":null,          "uploadFile":null,          "submissionDetails":null,          "renderedOnUi":true,          "regex":null,          "radioValueOptions":[ ],          "questionSectionDetail":null,          "questionSectionClass":"General Questions",          "questionSection":"null",          "parentQuestionId":"a2mr0000000WNBAAA4",          "orderBy":null,          "multiValues":[ ],          "minValue":null,          "messageTriggerResponse":null,          "message":null,          "maxValue":null,          "labelId":"a2mr0000000WNBFAA4",          "label":"How will your name appear on the notary public commission license?<br><br>First Name or initial",          "isMandatorySub":null,          "isMandatoryQues":true,          "isGenericSub":null,          "isChild":true,          "helptext":null,          "hasChild":false,          "fieldValueOptions":null,          "fieldType":"Text",          "fieldObjName":null,          "fieldAPIName":null,          "errormsg":"First Name or initial is required.",          "endorsementType":null,          "educationDetailsMap":[ ],          "conditionalAnswer":"Using a different version of my name",          "answerId":null,          "acknowledgeResponse":null,          "acknowledge":null       },          ],    "icon":"LnP_BackgroundQuestions.svg",    "fieldsList":null,    "fieldJson":null,    "currentTab":2,    "contactId":null,    "AMRlabel":null,    "accountId":null }]';
    STring TestLicense6 =  Polaris_ApplyForLicenseController.insertApplication(dataString6,2,app1.Id,'Notary Public','Notary Public','General Application',null);
    test.StopTest();
    
    }
    
    @isTest
    static void callcompositeAPITest(){
    Test.startTest();  
        Account acc = new Account();
        acc.Name = 'Business Account Test';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        insert acc;  
        
        Set<Id> accSetId = new Set<Id>();
        accSetId.add(acc.Id);
        Polaris_ApplyForLicenseController.addAffiliation(accSetId);
        
        MUSW__Application2__c app = new MUSW__Application2__c();
        app.Stage__c = 4;
        app.Application_Type__c = 'Timeshares';
        app.Application_Method__c = 'General Application';
        app.Credential_Type__c = 'Timeshare Salesperson';
        app.Form_JSON__c = '{"compositeRequest":[{"body":{"Answer":"Using my full legal name","Application":"a06r0000001yR9HAAU","Question":"a2mr0000000WhgVAAS"},"method":"POST","referenceId":"refId1","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"No","Application":"a06r0000001yR9HAAU","Question":"a2mr0000000WRwKAAW"},"method":"POST","referenceId":"refId5","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"No","Application":"a06r0000001yR9HAAU","Question":"a2mr0000000WRwLAAW"},"method":"POST","referenceId":"refId7","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"No","Application":"a06r0000001yR9HAAU","Question":"a2mr0000000WRwMAAW"},"method":"POST","referenceId":"refId9","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"No","Application":"a06r0000001yR9HAAU","Question":"a2mr0000000WRwNAAW"},"method":"POST","referenceId":"refId11","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Application":"a06r0000001yR9HAAU","Question":"a2mr0000000WYcrAAG"},"method":"POST","referenceId":"refId13","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"method":"DELETE","referenceId":"refDocId11","url":"/services/data/v38.0/sobjects/ContentDocumentLink/null"},{"body":{"ContentDocumentId":"069r0000001be5nAAA","LinkedEntityId":"@{refSubId1.id}","ShareType":"I"},"method":"POST","referenceId":"refContId1","url":"/services/data/v38.0/sobjects/ContentDocumentLink"},{"body":{"ContentDocumentId":"069r0000001be5nAAA;","MUSW_Application2":"a06r0000001yR9HAAU","MUSW_Description":"Miscellaneous"},"method":"POST","referenceId":"refSubId1","url":"/services/data/v38.0/sobjects/MUSW__Submission__c"}]}';
        insert app;
        Test.setMock(HttpCalloutMock.class, new WebServiceMockImpl());
        List<MUSW__License2__c> lic = Polaris_ApplyForLicenseController.callCompositeAPI(app.Id,null);
        
        Account acc1 = new Account();
        acc1.Name = 'Business Account Test';
        acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        acc1.Course_Provider__c = true;
        insert acc1; 
        
        MUSW__Application2__c app2 = new MUSW__Application2__c();
        app2.MUSW__Account__c = acc1.Id;
        app2.Stage__c = 4;
        app2.Application_Type__c = 'Funerals';
        app2.Application_Method__c = 'General Application';
        app2.Credential_Type__c = 'Funeral Establishment';
        app2.Form_JSON__c ='{"compositeRequest":[{"body":{"Answer":"test","Application":"a06r0000001yTmQAAU","Question":"a2mr0000000Wv9PAAS"},"method":"POST","referenceId":"refId1","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"test","Application":"a06r0000001yTmQAAU","Question":"a2mr0000000Wv9NAAS"},"method":"POST","referenceId":"refId2","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"Syllabus;Curriculum","Application":"a06r0000001yTmQAAU","Question":"a2mr0000000Wv9OAAS"},"method":"POST","referenceId":"refId3","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"No","Application":"a06r0000001yTmQAAU","Question":"a2mr0000000Wv9SAAS"},"method":"POST","referenceId":"refId4","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"No","Application":"a06r0000001yTmQAAU","Question":"a2mr0000000Wv9QAAS"},"method":"POST","referenceId":"refId8","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"No","Application":"a06r0000001yTmQAAU","Question":"a2mr0000000Wv9RAAS"},"method":"POST","referenceId":"refId12","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"Ongoing event","Application":"a06r0000001yTmQAAU","Question":"a2mr0000000Wv9MAAS"},"method":"POST","referenceId":"refId17","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"Distance / On-line","Application":"a06r0000001yTmQAAU","Question":"a2mr0000000WvOaAAK"},"method":"POST","referenceId":"refId21","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"No","Application":"a06r0000001yTmQAAU","Question":"a2mr0000000WvOpAAK"},"method":"POST","referenceId":"refId22","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"2019-10-18","Application":"a06r0000001yTmQAAU","Question":"a2mr0000000WvOwAAK"},"method":"POST","referenceId":"refId23","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"Primary Provider","Application":"a06r0000001yTmQAAU","Question":"a2mr0000000WvOxAAK"},"method":"POST","referenceId":"refId24","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"No","Application":"a06r0000001yTmQAAU","Question":"a2mr0000000WvObAAK"},"method":"POST","referenceId":"refId25","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"Yes","Application":"a06r0000001yTmQAAU","Question":"a2mr0000000WvOcAAK"},"method":"POST","referenceId":"refId27","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"2019-10-25","Application":"a06r0000001yTmQAAU","Question":"a2mr0000000WvOrAAK"},"method":"POST","referenceId":"refId28","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"No","Application":"a06r0000001yTmQAAU","Question":"a2mr0000000Wv9KAAS"},"method":"POST","referenceId":"refId38","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"No","Application":"a06r0000001yTmQAAU","Question":"a2mr0000000Wv9WAAS"},"method":"POST","referenceId":"refId40","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"No","Application":"a06r0000001yTmQAAU","Question":"a2mr0000000Wv9XAAS"},"method":"POST","referenceId":"refId42","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Application":"a06r0000001yTmQAAU","Question":"a2mr0000000Ww36AAC"},"method":"POST","referenceId":"refId44","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"method":"DELETE","referenceId":"refDocId11","url":"/services/data/v38.0/sobjects/ContentDocumentLink/06Ar0000003X5I1EAK"},{"body":{"ContentDocumentId":"069r0000001bqrFAAQ","LinkedEntityId":"@{refSubId1.id}","MUSW_Required":true,"ShareType":"I"},"method":"POST","referenceId":"refContId1","url":"/services/data/v38.0/sobjects/ContentDocumentLink"},{"body":{"ContentDocumentId":"069r0000001bqrFAAQ;","MUSW_Application2":"a06r0000001yTmQAAU","MUSW_Description":"IDECC Approval Certificate","Name":"N_Q_Q_CI_B1"},"method":"POST","referenceId":"refSubId1","url":"/services/data/v38.0/sobjects/MUSW__Submission__c"},{"method":"DELETE","referenceId":"refDocId21","url":"/services/data/v38.0/sobjects/ContentDocumentLink/06Ar0000003X5I6EAK"},{"body":{"ContentDocumentId":"069r0000001bqrKAAQ","LinkedEntityId":"@{refSubId1.id}","MUSW_Required":true,"ShareType":"I"},"method":"POST","referenceId":"refContId1","url":"/services/data/v38.0/sobjects/ContentDocumentLink"},{"body":{"ContentDocumentId":"069r0000001bqrKAAQ;","MUSW_Application2":"a06r0000001yTmQAAU","MUSW_Description":"USPAP Instructor Approval Certificate","Name":"N_Q_Q_CI_5"},"method":"POST","referenceId":"refSubId2","url":"/services/data/v38.0/sobjects/MUSW__Submission__c"},{"method":"DELETE","referenceId":"refDocId31","url":"/services/data/v38.0/sobjects/ContentDocumentLink/06Ar0000003X5IBEA0"},{"body":{"ContentDocumentId":"069r0000001bqrPAAQ","LinkedEntityId":"@{refSubId1.id}","MUSW_Required":true,"ShareType":"I"},"method":"POST","referenceId":"refContId1","url":"/services/data/v38.0/sobjects/ContentDocumentLink"},{"body":{"ContentDocumentId":"069r0000001bqrPAAQ;","MUSW_Application2":"a06r0000001yTmQAAU","MUSW_Description":"Syllabus and/or Curriculum","Name":"N_Q_Q_CI_3"},"method":"POST","referenceId":"refSubId3","url":"/services/data/v38.0/sobjects/MUSW__Submission__c"},{"body":{"MUSW_Application2":"a06r0000001yTmQAAU","MUSW_Description":"Appraisal Course Submission"},"method":"POST","referenceId":"refSubId4","url":"/services/data/v38.0/sobjects/MUSW__Submission__c"}]}';
        insert app2;
        List<MUSW__License2__c> lic2 = Polaris_ApplyForLicenseController.callCompositeAPI(app2.Id,null);
        
        MUSW__Application2__c app1 = new MUSW__Application2__c();
        app1.MUSW__Account__c = acc1.Id;
        app1.Stage__c = 4;
        app1.Application_Type__c = 'Appraisers - Real Estate';
        app1.Application_Method__c = 'General Application';
        app1.Credential_Type__c = 'Appraiser Course';
        app1.Form_JSON__c ='{"compositeRequest":[{"body":{"Answer":"test","Application":"a06r0000001yTmQAAU","Question":"a2mr0000000Wv9PAAS"},"method":"POST","referenceId":"refId1","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"test","Application":"a06r0000001yTmQAAU","Question":"a2mr0000000Wv9NAAS"},"method":"POST","referenceId":"refId2","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"Syllabus;Curriculum","Application":"a06r0000001yTmQAAU","Question":"a2mr0000000Wv9OAAS"},"method":"POST","referenceId":"refId3","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"No","Application":"a06r0000001yTmQAAU","Question":"a2mr0000000Wv9SAAS"},"method":"POST","referenceId":"refId4","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"No","Application":"a06r0000001yTmQAAU","Question":"a2mr0000000Wv9QAAS"},"method":"POST","referenceId":"refId8","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"No","Application":"a06r0000001yTmQAAU","Question":"a2mr0000000Wv9RAAS"},"method":"POST","referenceId":"refId12","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"Ongoing event","Application":"a06r0000001yTmQAAU","Question":"a2mr0000000Wv9MAAS"},"method":"POST","referenceId":"refId17","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"Distance / On-line","Application":"a06r0000001yTmQAAU","Question":"a2mr0000000WvOaAAK"},"method":"POST","referenceId":"refId21","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"No","Application":"a06r0000001yTmQAAU","Question":"a2mr0000000WvOpAAK"},"method":"POST","referenceId":"refId22","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"2019-10-18","Application":"a06r0000001yTmQAAU","Question":"a2mr0000000WvOwAAK"},"method":"POST","referenceId":"refId23","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"Primary Provider","Application":"a06r0000001yTmQAAU","Question":"a2mr0000000WvOxAAK"},"method":"POST","referenceId":"refId24","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"No","Application":"a06r0000001yTmQAAU","Question":"a2mr0000000WvObAAK"},"method":"POST","referenceId":"refId25","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"Yes","Application":"a06r0000001yTmQAAU","Question":"a2mr0000000WvOcAAK"},"method":"POST","referenceId":"refId27","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"2019-10-25","Application":"a06r0000001yTmQAAU","Question":"a2mr0000000WvOrAAK"},"method":"POST","referenceId":"refId28","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"No","Application":"a06r0000001yTmQAAU","Question":"a2mr0000000Wv9KAAS"},"method":"POST","referenceId":"refId38","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"No","Application":"a06r0000001yTmQAAU","Question":"a2mr0000000Wv9WAAS"},"method":"POST","referenceId":"refId40","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"No","Application":"a06r0000001yTmQAAU","Question":"a2mr0000000Wv9XAAS"},"method":"POST","referenceId":"refId42","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Application":"a06r0000001yTmQAAU","Question":"a2mr0000000Ww36AAC"},"method":"POST","referenceId":"refId44","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"method":"DELETE","referenceId":"refDocId11","url":"/services/data/v38.0/sobjects/ContentDocumentLink/06Ar0000003X5I1EAK"},{"body":{"ContentDocumentId":"069r0000001bqrFAAQ","LinkedEntityId":"@{refSubId1.id}","MUSW_Required":true,"ShareType":"I"},"method":"POST","referenceId":"refContId1","url":"/services/data/v38.0/sobjects/ContentDocumentLink"},{"body":{"ContentDocumentId":"069r0000001bqrFAAQ;","MUSW_Application2":"a06r0000001yTmQAAU","MUSW_Description":"IDECC Approval Certificate","Name":"N_Q_Q_CI_B1"},"method":"POST","referenceId":"refSubId1","url":"/services/data/v38.0/sobjects/MUSW__Submission__c"},{"method":"DELETE","referenceId":"refDocId21","url":"/services/data/v38.0/sobjects/ContentDocumentLink/06Ar0000003X5I6EAK"},{"body":{"ContentDocumentId":"069r0000001bqrKAAQ","LinkedEntityId":"@{refSubId1.id}","MUSW_Required":true,"ShareType":"I"},"method":"POST","referenceId":"refContId1","url":"/services/data/v38.0/sobjects/ContentDocumentLink"},{"body":{"ContentDocumentId":"069r0000001bqrKAAQ;","MUSW_Application2":"a06r0000001yTmQAAU","MUSW_Description":"USPAP Instructor Approval Certificate","Name":"N_Q_Q_CI_5"},"method":"POST","referenceId":"refSubId2","url":"/services/data/v38.0/sobjects/MUSW__Submission__c"},{"method":"DELETE","referenceId":"refDocId31","url":"/services/data/v38.0/sobjects/ContentDocumentLink/06Ar0000003X5IBEA0"},{"body":{"ContentDocumentId":"069r0000001bqrPAAQ","LinkedEntityId":"@{refSubId1.id}","MUSW_Required":true,"ShareType":"I"},"method":"POST","referenceId":"refContId1","url":"/services/data/v38.0/sobjects/ContentDocumentLink"},{"body":{"ContentDocumentId":"069r0000001bqrPAAQ;","MUSW_Application2":"a06r0000001yTmQAAU","MUSW_Description":"Syllabus and/or Curriculum","Name":"N_Q_Q_CI_3"},"method":"POST","referenceId":"refSubId3","url":"/services/data/v38.0/sobjects/MUSW__Submission__c"},{"body":{"MUSW_Application2":"a06r0000001yTmQAAU","MUSW_Description":"Appraisal Course Submission"},"method":"POST","referenceId":"refSubId4","url":"/services/data/v38.0/sobjects/MUSW__Submission__c"}]}';
        insert app1;
        
        
    Id courseRecordType = Schema.SObjectType.Question__c.getRecordTypeInfosByName().get('Course Information').getRecordTypeId();
    
    Question__c courseQue1 = DOL_TestDataFactory.createQuestionData('Continuing Education Course','Radio','MUSW__License2__c','Appraisers - Real Estate','Appraiser Course','Ext100','Course_Type__c','General Application','Answer;Credential;Service Request;License','','','Course is designed to meet which type of requirement and clock hours?',courseRecordType,true,'Yes;No;');
    BGCK__Answer__c courseAns1 = DOL_TestDataFactory.createAnswersGeneric(true,'Yes',courseQue1.Id,app1.Id);
    
    Question__c courseQue2 = DOL_TestDataFactory.createQuestionData('Pre-Qualifying Course','Radio','MUSW__License2__c','Appraisers - Real Estate','Appraiser Course','Ext101','Course_Type__c','General Application','Answer;Credential;Service Request;License','','','Course is designed to meet which type of requirement and clock hours?',courseRecordType,true,'Yes;No;');
    BGCK__Answer__c courseAns2 = DOL_TestDataFactory.createAnswersGeneric(true,'Yes',courseQue2.Id,app1.Id);
    
    Question__c courseQue3 = DOL_TestDataFactory.createQuestionData('Qualifying Elective Course','Radio','MUSW__License2__c','Appraisers - Real Estate','Appraiser Course','Ext102','Course_Type__c','General Application','Answer;Credential;Service Request;License','','','Course is designed to meet which type of requirement and clock hours?',courseRecordType,true,'Yes;No;');
    BGCK__Answer__c courseAns3 = DOL_TestDataFactory.createAnswersGeneric(true,'Yes',courseQue3.Id,app1.Id);
    
    Question__c courseQue4 = DOL_TestDataFactory.createQuestionData('Select the one that applies','Picklist','MUSW__License2__c','Appraisers - Real Estate','Appraiser Course','Ext103','Delivery_Method__c','General Application','Answer;Credential;Service Request;License','','','Course Delivery Method',courseRecordType,true,'--Select--;One-time event / Seminar;Ongoing event;Substantial course changes to existing active course;');
    BGCK__Answer__c courseAns4 = DOL_TestDataFactory.createAnswersGeneric(true,'One-time event / Seminar',courseQue4.Id,app1.Id);
    
    Question__c courseQue5 = DOL_TestDataFactory.createQuestionData('Enter Email','Text','MUSW__License2__c','Appraisers - Real Estate','Appraiser Course','Ext104','License_Email__c','General Application','Answer;Credential;Service Request;License','','','Course Contact Information',courseRecordType,true,'');
    BGCK__Answer__c courseAns5 = DOL_TestDataFactory.createAnswersGeneric(true,'Test',courseQue5.Id,app1.Id);
    
    Question__c courseQue6 = DOL_TestDataFactory.createQuestionData('Enter Website','Text','MUSW__License2__c','Appraisers - Real Estate','Appraiser Course','Ext105','Website__c','General Application','Answer;Credential;Service Request;License','','','Course Contact Information',courseRecordType,true,'');
    BGCK__Answer__c courseAns6 = DOL_TestDataFactory.createAnswersGeneric(true,'Test',courseQue6.Id,app1.Id);
    
    Question__c courseQue7 = DOL_TestDataFactory.createQuestionData('Are you the Primary or Secondary Provider of this course?','Picklist','MUSW__License2__c','Appraisers - Real Estate','Appraiser Course','Ext106','Provider_Type__c','General Application','Answer;Credential;Service Request;License','','','Course Delivery Method',courseRecordType,true,'--Select--;Primary Provider;Secondary Provider;');
    BGCK__Answer__c courseAns7 = DOL_TestDataFactory.createAnswersGeneric(true,'Primary Provider',courseQue7.Id,app1.Id);
    
    Question__c courseQue8 = DOL_TestDataFactory.createQuestionData('Is this is a USPAP 15-hour or 7-hour update course?','Yes_No','MUSW__License2__c','Appraisers - Real Estate','Appraiser Course','Ext107','Pre_Approval__c','General Application','Answer;Credential;Service Request;License','','','',courseRecordType,true,'--Select--;Yes;No');
    BGCK__Answer__c courseAns8 = DOL_TestDataFactory.createAnswersGeneric(true,'Yes',courseQue8.Id,app1.Id);
    
    Question__c courseQue9 = DOL_TestDataFactory.createQuestionData('Do you have an Appraisal Qualification Board approval certificate?','Yes_No','MUSW__License2__c','Appraisers - Real Estate','Appraiser Course','Ext108','Pre_Approval__c','General Application','Answer;Credential;Service Request;License','','','',courseRecordType,true,'--Select--;Yes;No');
    BGCK__Answer__c courseAns9 = DOL_TestDataFactory.createAnswersGeneric(true,'Yes',courseQue9.Id,app1.Id);
    
    Question__c courseQue10 = DOL_TestDataFactory.createQuestionData('Is the Provider an accredited college?','Yes_No','MUSW__License2__c','Appraisers - Real Estate','Appraiser Course','Ext109','Pre_Approval__c','General Application','Answer;Credential;Service Request;License','','','',courseRecordType,true,'--Select--;Yes;No');
    BGCK__Answer__c courseAns10 = DOL_TestDataFactory.createAnswersGeneric(true,'Yes',courseQue10.Id,app1.Id);
    
    Question__c courseQue11 = DOL_TestDataFactory.createQuestionData('What is the course or seminar title? (First word must be "On-line" if a distance course)','Text','MUSW__License2__c','Appraisers - Real Estate','Appraiser Course','Ext110','Course_Title__c','General Application','Answer;Credential;Service Request;License','','','',courseRecordType,true,'');
    BGCK__Answer__c courseAns11 = DOL_TestDataFactory.createAnswersGeneric(true,'Test',courseQue11.Id,app1.Id);
    
    Question__c courseQue12 = DOL_TestDataFactory.createQuestionData('Location:City','Text','MUSW__License2__c','Appraisers - Real Estate','Appraiser Course','Ext111','Event_City__c','General Application','Answer;Credential;Service Request;License','','','',courseRecordType,true,'');
    BGCK__Answer__c courseAns12 = DOL_TestDataFactory.createAnswersGeneric(true,'Adam',courseQue12.Id,app1.Id);
    
    Question__c courseQue13 = DOL_TestDataFactory.createQuestionData('Location: State','Picklist','MUSW__License2__c','Appraisers - Real Estate','Appraiser Course','Ext112','Event_State__c','General Application','Answer;Credential;Service Request;License','','','',courseRecordType,true,'--Select--;AA;');
    BGCK__Answer__c courseAns13 = DOL_TestDataFactory.createAnswersGeneric(true,'Adam',courseQue13.Id,app1.Id);
    
    Question__c courseQue14 = DOL_TestDataFactory.createQuestionData('C1. Number of clock hours (including exam/test, if course is also a qualifying course). (minimum of 2 hours)','Decimal','MUSW__License2__c','Appraisers - Real Estate','Appraiser Course','Ext113','Clock_Hours_Continuing_Education__c','General Application','Answer;Credential;Service Request;License','','','',courseRecordType,true,'');
    BGCK__Answer__c courseAns14 = DOL_TestDataFactory.createAnswersGeneric(true,'12.0',courseQue14.Id,app1.Id);
    
    Question__c courseQue15 = DOL_TestDataFactory.createQuestionData('A1 . Number of clock hours (minimum of 15 hours with exam):','Decimal','MUSW__License2__c','Appraisers - Real Estate','Appraiser Course','Ext114','Clock_Hours_Pre_Qualifying__c','General Application','Answer;Credential;Service Request;License','','','',courseRecordType,true,'');
    BGCK__Answer__c courseAns15 = DOL_TestDataFactory.createAnswersGeneric(true,'12.0',courseQue15.Id,app1.Id);
    
    Question__c courseQue16 = DOL_TestDataFactory.createQuestionData('B1. Number of clock hours(minimum of 15 hours with exam):','Decimal','MUSW__License2__c','Appraisers - Real Estate','Appraiser Course','Ext115','Clock_Hours_Qualifying_Elective__c','General Application','Answer;Credential;Service Request;License','','','',courseRecordType,true,'');
    BGCK__Answer__c courseAns16 = DOL_TestDataFactory.createAnswersGeneric(true,'12.0',courseQue16.Id,app1.Id);
    
    Question__c courseQue17 = DOL_TestDataFactory.createQuestionData('Enter Hours excluding exam/test','Decimal','MUSW__License2__c','Appraisers - Real Estate','Appraiser Course','Ext116','Alternate_Clock_Hours_Continuing_Educa__c','General Application','Answer;Credential;Service Request;License','','','',courseRecordType,true,'');
    BGCK__Answer__c courseAns17 = DOL_TestDataFactory.createAnswersGeneric(true,'12.0',courseQue17.Id,app1.Id);
    
    Question__c courseQue18 = DOL_TestDataFactory.createQuestionData('C2. Which licensure level(s) does this apply to? (Select all that apply.)','Checkbox','MUSW__License2__c','Appraisers - Real Estate','Appraiser Course','Ext117','Continuing_Education_Licensure_Levels__c','General Application','Answer;Credential;Service Request;License','','','',courseRecordType,true,'Registered Trainee Appraiser;State Licensed Appraiser;');
    BGCK__Answer__c courseAns18 = DOL_TestDataFactory.createAnswersGeneric(true,'Registered Trainee Appraiser',courseQue18.Id,app1.Id);
    
    Question__c courseQue19 = DOL_TestDataFactory.createQuestionData('A2 . Which licensure level(s) does this apply to? (Select all that apply.)','Checkbox','MUSW__License2__c','Appraisers - Real Estate','Appraiser Course','Ext118','Pre_Qualifying_Licensure_Levels__c','General Application','Answer;Credential;Service Request;License','','','',courseRecordType,true,'Registered Trainee Appraiser;State Licensed Appraiser;');
    BGCK__Answer__c courseAns19 = DOL_TestDataFactory.createAnswersGeneric(true,'Registered Trainee Appraiser',courseQue19.Id,app1.Id);
    
    Question__c courseQue20 = DOL_TestDataFactory.createQuestionData('B2. Which licensure level(s) does this apply to? (can select multiples)','Checkbox','MUSW__License2__c','Appraisers - Real Estate','Appraiser Course','Ext119','Qualifying_Elective_Licensure_Levels__c','General Application','Answer;Credential;Service Request;License','','','',courseRecordType,true,'Registered Trainee Appraiser;State Licensed Appraiser;');
    BGCK__Answer__c courseAns20 = DOL_TestDataFactory.createAnswersGeneric(true,'Registered Trainee Appraiser',courseQue20.Id,app1.Id);
    
    List<MUSW__License2__c> lic1 = Polaris_ApplyForLicenseController.callCompositeAPI(app1.Id,null);
        
        
    Test.StopTest();
    }
    
    @istest
    static void createEndorsementTest(){
    Test.startTest();  
        Account acc = new Account();
        acc.Name = 'Business Account Test';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        insert acc;  
  
        MUSW__Application2__c app = new MUSW__Application2__c();
        app.Stage__c = 4;
        app.Application_Type__c = 'Notary Public';
        app.Application_Method__c = 'General Application';
        app.Credential_Type__c = 'Notary Public';
        app.Form_JSON__c = '{"compositeRequest":[{"body":{"Answer":"Using my full legal name","Application":"a06r0000001yR9HAAU","Question":"a2mr0000000WhgVAAS"},"method":"POST","referenceId":"refId1","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"No","Application":"a06r0000001yR9HAAU","Question":"a2mr0000000WRwKAAW"},"method":"POST","referenceId":"refId5","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"No","Application":"a06r0000001yR9HAAU","Question":"a2mr0000000WRwLAAW"},"method":"POST","referenceId":"refId7","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"No","Application":"a06r0000001yR9HAAU","Question":"a2mr0000000WRwMAAW"},"method":"POST","referenceId":"refId9","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"No","Application":"a06r0000001yR9HAAU","Question":"a2mr0000000WRwNAAW"},"method":"POST","referenceId":"refId11","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Application":"a06r0000001yR9HAAU","Question":"a2mr0000000WYcrAAG"},"method":"POST","referenceId":"refId13","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"method":"DELETE","referenceId":"refDocId11","url":"/services/data/v38.0/sobjects/ContentDocumentLink/null"},{"body":{"ContentDocumentId":"069r0000001be5nAAA","LinkedEntityId":"@{refSubId1.id}","ShareType":"I"},"method":"POST","referenceId":"refContId1","url":"/services/data/v38.0/sobjects/ContentDocumentLink"},{"body":{"ContentDocumentId":"069r0000001be5nAAA;","MUSW_Application2":"a06r0000001yR9HAAU","MUSW_Description":"Miscellaneous"},"method":"POST","referenceId":"refSubId1","url":"/services/data/v38.0/sobjects/MUSW__Submission__c"}]}';
        insert app;
 
 Id licenseInfoRecordType = Schema.SObjectType.Question__c.getRecordTypeInfosByName().get('License Information').getRecordTypeId();
 
 Question__c NotaryQue1 = DOL_TestDataFactory.createQuestionData('Do you want to update License Printable Name?','Yes_No','MUSW__License2__c','Notary Public','Notary Public','Ext101','','General Application','Answer;Credential;Service Request;License','','','Certifications',licenseInfoRecordType,true,'Yes;No;');
 NotaryQue1.Create_Endorsement_Record__c = true;
 update NotaryQue1;
 
 Question__c NotaryQue2 = DOL_TestDataFactory.createQuestionData('Where should we send this license history?','Picklist','MUSW__License2__c','Notary Public','Notary Public','Ext102','','General Application','Answer;Credential;Service Request;License','','','General Questions',licenseInfoRecordType,true,'--Select--;To an association;');
 NotaryQue2.Create_Endorsement_Record__c = true;
 update NotaryQue2;

 BGCK__Answer__c answ = new BGCK__Answer__c();
 answ.BGCK__Valid__c = true;
 answ.Answer_Text__c = 'Yes';
 answ.QuestionDOL__c = NotaryQue1.Id;
 answ.Application_BG__c = app.Id;
 insert answ;
 
  BGCK__Answer__c answ1 = new BGCK__Answer__c();
 answ1.BGCK__Valid__c = true;
 answ1.Answer_Text__c = 'To an association';
 answ1.QuestionDOL__c = NotaryQue2.Id;
 answ1.Application_BG__c = app.Id;
 insert answ1;
 
 Electronic_Notary_Provider_Information__c enpi = new Electronic_Notary_Provider_Information__c();
 enpi.Description__c = 'test';
 enpi.Effective_Date__c = System.today()-1;
 enpi.Application_BG__c = app.Id;
 enpi.Provider_Name__c = 'Docusign';
 insert enpi;
 
 LnP_BackgroundSection__c bgs = new LnP_BackgroundSection__c();
 bgs.Country__c = 'United States';
 bgs.Application_BG__c = app.Id;
 bgs.RecordTypeID = Schema.SObjectType.LnP_BackgroundSection__c.getRecordTypeInfosByName().get('Qualifying Education').getRecordTypeId();
 insert bgs;
 
 Id afLocRecordTypeId = Schema.SObjectType.MUSW__Parcel__c.getRecordTypeInfosByName().get('Affiliated Location').getRecordTypeId();
 
 MUSW__Parcel__c par = new MUSW__Parcel__c();
 par.Name = 'Harrison Street, Seattle';
 par.MUSW__Street2__c = 'Harrison Street';
 par.MUSW__City__c = 'Seattle';
 par.MUSW__Post_Zip_Code__c = '98109';
 par.Country__c = 'United States';
 par.County__c = 'Adams';
 par.MUSW__State__c = 'WA';
 par.recordtypeId = afLocRecordTypeId;
 insert par; 
 
 ContentVersion contentVersion = new ContentVersion(
  Title = 'Penguins',
  PathOnClient = 'Penguins.jpg',
  VersionData = Blob.valueOf('Test Content'),
  IsMajorVersion = true
    );
    
    
    insert contentVersion;    
    List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
    
    ContentDocumentLink cdl = New ContentDocumentLink();
    cdl.LinkedEntityId = app.id;
    cdl.ContentDocumentId = documents[0].Id;
    cdl.shareType = 'V';
    insert cdl;
    
    MUSW__Submission__c sub = new MUSW__Submission__c();
    sub.ContentDocumentId__c = documents[0].Id;
    sub.MUSW__BG_File_Location_Type__c = 'Salesforce';
    insert sub;

 List<MUSW__License2__c> lic = Polaris_ApplyForLicenseController.callCompositeAPI(app.Id,null);
 
 Test.stopTest();
 
    }
    
    @isTest
    static void insertLicenseTest(){
        Test.startTest();  
        String data = Polaris_ApplyForLicenseController.fetchBoardLabels('LnP_Elg_Funeral_Establishment_Ques_1','Funeral Services');
        Account acc = new Account();
        acc.Name = 'Business Account Test';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        insert acc;  
        
        Contact con = new Contact(LastName= 'Test Contact');
        con.AccountId = acc.Id;
        con.Unique_ID_To_Provide__c = 'SSN';
        con.Social_Security_Number_Encrypted__c ='516143176';
        insert con;
        
        MUSW__Application2__c app = new MUSW__Application2__c();
        app.Stage__c = 4;
        app.Application_Type__c = 'Notary Public';
        app.Application_Method__c = 'General Application';
        app.Credential_Type__c = 'Notary Public';
        app.Form_JSON__c = '{"compositeRequest":[{"body":{"Answer":"Using my full legal name","Application":"a06r0000001yR9HAAU","Question":"a2mr0000000WhgVAAS"},"method":"POST","referenceId":"refId1","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"No","Application":"a06r0000001yR9HAAU","Question":"a2mr0000000WRwKAAW"},"method":"POST","referenceId":"refId5","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"No","Application":"a06r0000001yR9HAAU","Question":"a2mr0000000WRwLAAW"},"method":"POST","referenceId":"refId7","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"No","Application":"a06r0000001yR9HAAU","Question":"a2mr0000000WRwMAAW"},"method":"POST","referenceId":"refId9","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"No","Application":"a06r0000001yR9HAAU","Question":"a2mr0000000WRwNAAW"},"method":"POST","referenceId":"refId11","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Application":"a06r0000001yR9HAAU","Question":"a2mr0000000WYcrAAG"},"method":"POST","referenceId":"refId13","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"method":"DELETE","referenceId":"refDocId11","url":"/services/data/v38.0/sobjects/ContentDocumentLink/null"},{"body":{"ContentDocumentId":"069r0000001be5nAAA","LinkedEntityId":"@{refSubId1.id}","ShareType":"I"},"method":"POST","referenceId":"refContId1","url":"/services/data/v38.0/sobjects/ContentDocumentLink"},{"body":{"ContentDocumentId":"069r0000001be5nAAA;","MUSW_Application2":"a06r0000001yR9HAAU","MUSW_Description":"Miscellaneous"},"method":"POST","referenceId":"refSubId1","url":"/services/data/v38.0/sobjects/MUSW__Submission__c"}]}';
        insert app;
        Id afLocRecordTypeId = Schema.SObjectType.MUSW__Parcel__c.getRecordTypeInfosByName().get('Affiliated Location').getRecordTypeId();
 
         MUSW__Parcel__c par = new MUSW__Parcel__c();
         par.Name = 'Harrison Street, Seattle';
         par.MUSW__Street2__c = 'Harrison Street';
         par.MUSW__City__c = 'Seattle';
         par.MUSW__Post_Zip_Code__c = '98109';
         par.Country__c = 'United States';
         par.County__c = 'Adams';
         par.MUSW__State__c = 'WA';
         par.MUSW__Primary_Contact__c = con.Id;
         par.recordtypeId = afLocRecordTypeId;
         par.Status__c = 'Active';
         par.Application_BG__c = app.Id;
         insert par; 
         
         MUSW__Parcel__c par1 = new MUSW__Parcel__c();
         par1.Name = 'Harrison Street, Seattle';
         par1.MUSW__Street2__c = 'Harrison Street';
         par1.MUSW__City__c = 'Seattle';
         par1.MUSW__Post_Zip_Code__c = '98109';
         par1.Country__c = 'United States';
         par1.County__c = 'Adams';
         par1.MUSW__State__c = 'WA';
         par1.MUSW__Primary_Contact__c = con.Id;
         par1.Status__c = 'Active';
         par1.Application_BG__c = app.Id;
         insert par1; 
         
         MUSW__Parcel__c par2 = new MUSW__Parcel__c();
         par2.Name = 'Harrison Street, Seattle';
         par2.MUSW__Street2__c = 'Harrison Street';
         par2.MUSW__City__c = 'Seattle';
         par2.MUSW__Post_Zip_Code__c = '98109';
         par2.Country__c = 'United States';
         par2.County__c = 'Adams';
         par2.Address_Type__c = 'MAILING ADDRESS';
         par2.is_Physical_and_Mailing_Address_Same__c = true;
         par2.MUSW__State__c = 'WA';
         par2.MUSW__Primary_Contact__c = con.Id;
         par2.Status__c = 'Active';
         par2.Application_BG__c = app.Id;
         insert par2; 
         
         MUSW__Parcel__c par3 = new MUSW__Parcel__c();
         par3.Name = 'Harrison Street, Seattle';
         par3.MUSW__Street2__c = 'Harrison Street';
         par3.MUSW__City__c = 'Seattle';
         par3.MUSW__Post_Zip_Code__c = '98109';
         par3.Country__c = 'United States';
         par3.County__c = 'Adams';
         par3.Address_Type__c = 'MAILING ADDRESS';
         par3.is_Physical_and_Mailing_Address_Same__c = false;
         par3.MUSW__State__c = 'WA';
         par3.MUSW__Primary_Contact__c = con.Id;
         par3.Status__c = 'Active';
         par3.Application_BG__c = app.Id;
         insert par3;
         
         Id LicRecordtype = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
         MUSW__License2__c lican = DOL_TestDataFactory.createLicense(LicRecordtype,acc.Id,'Timeshares','Timeshare Salesperson','General Application');
         
         Polaris_ApplyForLicenseController.getAllAddressesForComposite(con.Id,app.Id,lican.Id);
         Polaris_ApplyForLicenseController.getAddresses(con.Id,app.Id);
         Polaris_ApplyForLicenseController.currentContact = con;
         Set<Id> appSet = new Set<Id>();
         appset.add(app.id);
         
         LnP_BackgroundSection__c bgs = new LnP_BackgroundSection__c();
         bgs.Country__c = 'United States';
         bgs.Application_BG__c = app.Id;
         bgs.RecordTypeID = Schema.SObjectType.LnP_BackgroundSection__c.getRecordTypeInfosByName().get('Qualifying Education').getRecordTypeId();
         insert bgs;
         
         Map<String,List<LnP_BackgroundSection__c>> mapBackSec = Polaris_ApplyForLicenseController.getBackgroundInformation(appset);
          
          
         ContentVersion contentVersion = new ContentVersion(
          Title = 'Penguins',
          PathOnClient = 'Penguins.jpg',
          VersionData = Blob.valueOf('Test Content'),
          IsMajorVersion = true
            );
    
    
    insert contentVersion;    
    List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
    
    ContentDocumentLink cdl = New ContentDocumentLink();
    cdl.LinkedEntityId = app.id;
    cdl.ContentDocumentId = documents[0].Id;
    cdl.shareType = 'V';
    insert cdl;
    
    MUSW__Submission__c sub = new MUSW__Submission__c();
    sub.ContentDocumentId__c = documents[0].Id;
    sub.MUSW__BG_File_Location_Type__c = 'Salesforce';
    sub.MUSW__Application2__c = app.Id;
    insert sub;

        
        Id reviewAndSubmitType = Schema.SObjectType.Question__c.getRecordTypeInfosByName().get('Review and Submit').getRecordTypeId();
        Id licenseInfo = Schema.SObjectType.Question__c.getRecordTypeInfosByName().get('License Information').getRecordTypeId();
        
        Question__c NotaryQue1 = DOL_TestDataFactory.createQuestionData('I understand I am required to keep a notary journal.','Decimal','MUSW__License2__c','Notary Public','Notary Public','Ext101','Camping_Resorts__c','General Application','Answer;Credential;Service Request;License','','','',reviewAndSubmitType,true,'');
        BGCK__Answer__c NotaryAns1 = DOL_TestDataFactory.createAnswersGeneric(true,'12',NotaryQue1.Id,app.Id);
        
        Question__c NotaryQue2 = DOL_TestDataFactory.createQuestionData('I understand I am required to keep a notary journal.','Decimal','MUSW__License2__c','Notary Public','Notary Public','Ext102','Initial_Contracts__c','General Application','Answer;Credential;Service Request;License','','','',reviewAndSubmitType,true,'');
        BGCK__Answer__c NotaryAns2 = DOL_TestDataFactory.createAnswersGeneric(true,'12',NotaryQue2.Id,app.Id);
        
        Question__c NotaryQue3 = DOL_TestDataFactory.createQuestionData('Within the last 10 years, ','Yes_No','MUSW__License2__c','Notary Public','Notary Public','Ext103','Military__c','General Application','Answer;Credential;Service Request;License','','','',licenseInfo,true,'Yes;No;');
        BGCK__Answer__c NotaryAns3 = DOL_TestDataFactory.createAnswersGeneric(true,'Yes',NotaryQue3.Id,app.Id);
        
        Question__c NotaryQue4 = DOL_TestDataFactory.createQuestionData('Within the last 10 years, ','Yes_No','MUSW__License2__c','Notary Public','Notary Public','Ext104','Military_Spouse__c','General Application','Answer;Credential;Service Request;License','','','',licenseInfo,true,'Yes;No;');
        BGCK__Answer__c NotaryAns4 = DOL_TestDataFactory.createAnswersGeneric(true,'Yes',NotaryQue4.Id,app.Id);
        
        Question__c NotaryQue5 = DOL_TestDataFactory.createQuestionData('I understand I am required to keep a notary journal.','Decimal','MUSW__License2__c','Notary Public','Notary Public','Ext105','Timeshare_Projects__c','General Application','Answer;Credential;Service Request;License','','','',licenseInfo,true,'');
        BGCK__Answer__c NotaryAns5 = DOL_TestDataFactory.createAnswersGeneric(true,'12',NotaryQue5.Id,app.Id);
        
        Question__c NotaryQue6 = DOL_TestDataFactory.createQuestionData('I understand I am required to keep a notary journal.','Decimal','MUSW__License2__c','Notary Public','Notary Public','Ext106','Apartment_Units__c','General Application','Answer;Credential;Service Request;License','','','',licenseInfo,true,'');
        BGCK__Answer__c NotaryAns6 = DOL_TestDataFactory.createAnswersGeneric(true,'12',NotaryQue6.Id,app.Id);
        
        Question__c NotaryQue7 = DOL_TestDataFactory.createQuestionData('I understand I am required to keep a notary journal.','Decimal','MUSW__License2__c','Notary Public','Notary Public','Ext107','Interval_fees__c','General Application','Answer;Credential;Service Request;License','','','',licenseInfo,true,'');
        BGCK__Answer__c NotaryAns7 = DOL_TestDataFactory.createAnswersGeneric(true,'12',NotaryQue7.Id,app.Id);
        
        Question__c NotaryQue8 = DOL_TestDataFactory.createQuestionData('I understand I am required to keep a notary journal.','Decimal','MUSW__License2__c','Notary Public','Notary Public','Ext108','Advertising_Fees__c','General Application','Answer;Credential;Service Request;License','','','',licenseInfo,true,'');
        BGCK__Answer__c NotaryAns8 = DOL_TestDataFactory.createAnswersGeneric(true,'12',NotaryQue8.Id,app.Id);
        
        Question__c NotaryQue9 = DOL_TestDataFactory.createQuestionData('I understand I am required to keep a notary journal.','Decimal','MUSW__License2__c','Notary Public','Notary Public','Ext109','Pieces_of_Personal_Property__c','General Application','Answer;Credential;Service Request;License','','','',licenseInfo,true,'');
        BGCK__Answer__c NotaryAns9 = DOL_TestDataFactory.createAnswersGeneric(true,'12',NotaryQue9.Id,app.Id);
        
        Question__c NotaryQue10 = DOL_TestDataFactory.createQuestionData('I understand I am required to keep a notary journal.','Decimal','MUSW__License2__c','Notary Public','Notary Public','Ext110','Camping_Resorts__c','General Application','Answer;Credential;Service Request;License','','','',licenseInfo,true,'');
        BGCK__Answer__c NotaryAns10 = DOL_TestDataFactory.createAnswersGeneric(true,'12',NotaryQue10.Id,app.Id);
        
        Question__c NotaryQue11 = DOL_TestDataFactory.createQuestionData('I understand I am required to keep a notary journal.','Decimal','MUSW__License2__c','Notary Public','Notary Public','Ext111','Initial_Contracts__c','General Application','Answer;Credential;Service Request;License','','','',licenseInfo,true,'');
        BGCK__Answer__c NotaryAns11 = DOL_TestDataFactory.createAnswersGeneric(true,'12',NotaryQue11.Id,app.Id);
        
        //Question__c NotaryQue12 = DOL_TestDataFactory.createQuestionData('I understand I am required to keep a notary journal.','Text','MUSW__License2__c','Notary Public','Notary Public','Ext112','Date_Fiscal_Year_Ends__c','General Application','Answer;Credential;Service Request;License','','','',licenseInfo,true,'');
        //BGCK__Answer__c NotaryAns12 = DOL_TestDataFactory.createAnswersGeneric(true,'2019/5/02',NotaryQue12.Id,app.Id);
        
        Question__c NotaryQue13 = DOL_TestDataFactory.createQuestionData('How will your name appear','Text','MUSW__License2__c','Notary Public','Notary Public','Ext113','','General Application','Answer;Credential;Service Request;License','','','',licenseInfo,true,'');
        BGCK__Answer__c NotaryAns13 = DOL_TestDataFactory.createAnswersGeneric(true,'Test',NotaryQue13.Id,app.Id);
        
        Question__c NotaryQue14 = DOL_TestDataFactory.createQuestionData('First Name or initial','Text','MUSW__License2__c','Notary Public','Notary Public','Ext114','','General Application','Answer;Credential;Service Request;License','','','',licenseInfo,true,'');
        BGCK__Answer__c NotaryAns14 = DOL_TestDataFactory.createAnswersGeneric(true,'Test',NotaryQue14.Id,app.Id);
        
        Question__c NotaryQue15 = DOL_TestDataFactory.createQuestionData('Doing Business As','Text','MUSW__License2__c','Notary Public','Notary Public','Ext115','','General Application','Answer;Credential;Service Request;License','','','',licenseInfo,true,'');
        BGCK__Answer__c NotaryAns15 = DOL_TestDataFactory.createAnswersGeneric(true,'Test',NotaryQue15.Id,app.Id);
        
        Question__c NotaryQue16 = DOL_TestDataFactory.createQuestionData('Middle Name or initial','Text','MUSW__License2__c','Notary Public','Notary Public','Ext116','','General Application','Answer;Credential;Service Request;License','','','',licenseInfo,true,'');
        BGCK__Answer__c NotaryAns16 = DOL_TestDataFactory.createAnswersGeneric(true,'Test',NotaryQue16.Id,app.Id);
        
        Question__c NotaryQue17 = DOL_TestDataFactory.createQuestionData('How do you want your name displayed on your license','Text','MUSW__License2__c','Notary Public','Notary Public','Ext117','','General Application','Answer;Credential;Service Request;License','','','',licenseInfo,true,'');
        BGCK__Answer__c NotaryAns17 = DOL_TestDataFactory.createAnswersGeneric(true,'Use my full legal name',NotaryQue17.Id,app.Id);
        
        Question__c NotaryQue18 = DOL_TestDataFactory.createQuestionData('How do you want your name displayed on your license','Text','MUSW__License2__c','Notary Public','Notary Public','Ext118','','General Application','Answer;Credential;Service Request;License','','','',licenseInfo,true,'');
        BGCK__Answer__c NotaryAns18 = DOL_TestDataFactory.createAnswersGeneric(true,'Using a different version of my name',NotaryQue18.Id,app.Id);
        
        id finanicalRecordTypeId = Schema.SObjectType.Question__c.getRecordTypeInfosByName().get('Financial Guarantee').getRecordTypeId();
        
        Question__c NotaryQue19 = DOL_TestDataFactory.createQuestionData('Bond or Policy Number','Text','MUSW__License2__c','Notary Public','Notary Public','Ext119','','General Application','Answer;Credential;Service Request;License','','','',finanicalRecordTypeId,true,'');
        BGCK__Answer__c NotaryAns19 = DOL_TestDataFactory.createAnswersGeneric(true,'1231421',NotaryQue19.Id,app.Id);
        
        Question__c NotaryQue20 = DOL_TestDataFactory.createQuestionData('Bond or Insurance Company Name','Text','MUSW__License2__c','Notary Public','Notary Public','Ext120','','General Application','Answer;Credential;Service Request;License','','','',finanicalRecordTypeId,true,'');
        BGCK__Answer__c NotaryAns20 = DOL_TestDataFactory.createAnswersGeneric(true,'Company',NotaryQue20.Id,app.Id);
        
        Question__c NotaryQue21 = DOL_TestDataFactory.createQuestionData('Bond or Policy Amount','Text','MUSW__License2__c','Notary Public','Notary Public','Ext121','','General Application','Answer;Credential;Service Request;License','','','',finanicalRecordTypeId,true,'');
        BGCK__Answer__c NotaryAns21 = DOL_TestDataFactory.createAnswersGeneric(true,'120000',NotaryQue21.Id,app.Id);
        
        Question__c NotaryQue22 = DOL_TestDataFactory.createQuestionData('Effective Date','Text','MUSW__License2__c','Notary Public','Notary Public','Ext122','','General Application','Answer;Credential;Service Request;License','','','',finanicalRecordTypeId,true,'');
        BGCK__Answer__c NotaryAns22 = DOL_TestDataFactory.createAnswersGeneric(true,'2019/04/10',NotaryQue22.Id,app.Id);
        
        Question__c NotaryQue23 = DOL_TestDataFactory.createQuestionData('Expiration Date','Date','MUSW__License2__c','Notary Public','Notary Public','Ext123','','General Application','Answer;Credential;Service Request;License','','','',finanicalRecordTypeId,true,'');
        BGCK__Answer__c NotaryAns23 = DOL_TestDataFactory.createAnswersGeneric(true,'2019/04/10',NotaryQue23.Id,app.Id);
        
        MUSW__Application2__c app1 = new MUSW__Application2__c();
        app1.Stage__c = 4;
        app1.MUSW__Account__c = acc.Id;
        app1.Application_Type__c = 'Notary Public';
        app1.Application_Method__c = 'General Application';
        app1.Credential_Type__c = 'Notary Public';
        app1.Form_JSON__c = '{"compositeRequest":[{"body":{"Answer":"Using my full legal name","Application":"a06r0000001yR9HAAU","Question":"a2mr0000000WhgVAAS"},"method":"POST","referenceId":"refId1","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"No","Application":"a06r0000001yR9HAAU","Question":"a2mr0000000WRwKAAW"},"method":"POST","referenceId":"refId5","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"No","Application":"a06r0000001yR9HAAU","Question":"a2mr0000000WRwLAAW"},"method":"POST","referenceId":"refId7","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"No","Application":"a06r0000001yR9HAAU","Question":"a2mr0000000WRwMAAW"},"method":"POST","referenceId":"refId9","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Answer":"No","Application":"a06r0000001yR9HAAU","Question":"a2mr0000000WRwNAAW"},"method":"POST","referenceId":"refId11","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"body":{"Application":"a06r0000001yR9HAAU","Question":"a2mr0000000WYcrAAG"},"method":"POST","referenceId":"refId13","url":"/services/data/v38.0/sobjects/BGCK__Answer__c"},{"method":"DELETE","referenceId":"refDocId11","url":"/services/data/v38.0/sobjects/ContentDocumentLink/null"},{"body":{"ContentDocumentId":"069r0000001be5nAAA","LinkedEntityId":"@{refSubId1.id}","ShareType":"I"},"method":"POST","referenceId":"refContId1","url":"/services/data/v38.0/sobjects/ContentDocumentLink"},{"body":{"ContentDocumentId":"069r0000001be5nAAA;","MUSW_Application2":"a06r0000001yR9HAAU","MUSW_Description":"Miscellaneous"},"method":"POST","referenceId":"refSubId1","url":"/services/data/v38.0/sobjects/MUSW__Submission__c"}]}';
        app1.Branch_License__c = true;
        insert app1;
        
        List<MUSW__License2__c> lic = Polaris_ApplyForLicenseController.callCompositeAPI(app.Id,null);
        List<MUSW__License2__c> lic1 = Polaris_ApplyForLicenseController.callCompositeAPI(app1.Id,null);
   
        
     
        
        Test.stoptest();
        
    
    }
    
}