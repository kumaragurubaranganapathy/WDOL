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
    
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account accObj = DOL_TestDataFactory.createAccount(accRecordTypeId);
        
        Id licRecordTypeId = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        MUSW__License2__c licenseObj = DOL_TestDataFactory.createLicense(licRecordTypeId,accObj.Id,'Funerals','Embalmer Intern','General Application');
        
        Request__c reqObj = DOL_TestDataFactory.createRequest(licenseObj.Id,'Funerals','Embalmer Intern');
        reqObj.Description__c = 'Request Description';
        update reqObj;
        
        String dataString = '[{"tabIndex":1,"subheader":"Request Information","sobjectType":null,"sectionName":"Request Information","sectionError":false,"recordType":null,"personalInfoObjectName":null,"mandatorySubsection":null,"labelFieldsMap":[{"warningMessages":null,"value":"Alex","validationCriteria":null,"uploadFile":null,"submissionDetails":null,"renderedOnUi":true,"regex":null,"radioValueOptions":[],"questionSectionDetail":"How will your name appear on the license?","questionSectionClass":"Request Questions","questionSection":"Request Questions","parentQuestionId":null,"orderBy":null,"multiValues":[],"minValue":null,"messageTriggerResponse":null,"message":null,"maxValue":null,"labelId":"a2mr0000000XFugAAG","label":"First Name or initial","isMandatorySub":null,"isMandatoryQues":true,"isGenericSub":null,"isChild":false,"helptext":null,"hasChild":false,"fieldValueOptions":null,"fieldType":"Text","fieldObjName":null,"fieldAPIName":"Print_First_Name__c","errormsg":null,"endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":null,"answerId":null,"acknowledgeResponse":null,"acknowledge":null},{"warningMessages":null,"value":"R","validationCriteria":null,"uploadFile":null,"submissionDetails":null,"renderedOnUi":true,"regex":null,"radioValueOptions":[],"questionSectionDetail":null,"questionSectionClass":"Request Questions","questionSection":"null","parentQuestionId":null,"orderBy":null,"multiValues":[],"minValue":null,"messageTriggerResponse":null,"message":null,"maxValue":null,"labelId":"a2mr0000000XFuhAAG","label":"Middle Name or Initial","isMandatorySub":null,"isMandatoryQues":false,"isGenericSub":null,"isChild":false,"helptext":null,"hasChild":false,"fieldValueOptions":null,"fieldType":"Text","fieldObjName":null,"fieldAPIName":"Print_Middle_Name__c","errormsg":null,"endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":null,"answerId":null,"acknowledgeResponse":null,"acknowledge":null},{"warningMessages":null,"value":"House","validationCriteria":null,"uploadFile":null,"submissionDetails":null,"renderedOnUi":true,"regex":null,"radioValueOptions":[],"questionSectionDetail":null,"questionSectionClass":"Request Questions","questionSection":"null","parentQuestionId":null,"orderBy":null,"multiValues":[],"minValue":null,"messageTriggerResponse":null,"message":null,"maxValue":null,"labelId":"a2mr0000000XFuiAAG","label":"Last Name","isMandatorySub":null,"isMandatoryQues":true,"isGenericSub":null,"isChild":false,"helptext":null,"hasChild":true,"fieldValueOptions":null,"fieldType":"Text","fieldObjName":null,"fieldAPIName":"Print_Last_Name__c","errormsg":null,"endorsementType":null,"educationDetailsMap":[],"conditionalAnswer":null,"answerId":null,"acknowledgeResponse":null,"acknowledge":null}],"icon":null,"fieldsList":null,"fieldJson":null,"currentTab":0,"contactId":null,"AMRlabel":"Update Print Name","accountId":null},{"tabIndex":2,"subheader":"Review and Submit","sobjectType":null,"sectionName":"Review and Submit","sectionError":false,"recordType":null,"personalInfoObjectName":null,"mandatorySubsection":null,"labelFieldsMap":[],"icon":"LnP_ReviewnSubmit.svg","fieldsList":null,"fieldJson":null,"currentTab":0,"contactId":null,"AMRlabel":"Update Print Name","accountId":null}]';
        
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('HttpStaticfakeResp');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/xml');
        Test.setMock(HttpCalloutMock.class, mock);
        HTTPResponse res =null;
       
        Test.startTest();
        Polaris_ServiceRequestController.fetchData('Funerals','Embalmer Intern','Update Legal Name',reqObj.Id,'CE Audit',licenseObj.Id);
        Polaris_ServiceRequestController.insertApplication(datastring,5,reqObj.Id,'Funerals','Embalmer Intern','General Application');
        Polaris_ServiceRequestController.callCompositeAPI(reqObj.Id,reqObj.Description__c);
        Test.stopTest();
        
    }
}