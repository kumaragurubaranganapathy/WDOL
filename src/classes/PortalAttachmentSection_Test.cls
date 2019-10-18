/* 
*Class Name   : PortalAttachmentSection_Test
* Description  : Testclass for PortalAttachmentSection
* Created By   : Shreya Surabhi
* Created On   : 20/09/2019 
* Modification Log:  
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Developer                    Date                        Description
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*
*/
@isTest
public class PortalAttachmentSection_Test{
    
    private static testmethod void testMethod_PortalAttachmentSection(){
        
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account accObj = DOL_TestDataFactory.createAccount(accRecordTypeId);
        
        Id licRecordTypeId = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        MUSW__License2__c licenseObj = DOL_TestDataFactory.createLicense(licRecordTypeId,accObj.Id,'Funerals','Embalmer Intern','General Application');
        Document sampleDocument = new Document (Name ='Military Spouse Required Attachment',DeveloperName = 'Military_Spouse_Required_Attachment');
        sampleDocument.FolderId = [select id from folder where name = 'Shared Documents'].id;
        insert sampleDocument;
        
        MUSW__Submission__c subRec = DOL_TestDataFactory.createSubmission(licenseObj.Id);
        subRec.Name = 'Military Spouse Required Attachment';
        subRec.Document_API_Name__c = 'Military_Spouse_Required_Attachment';
        update subRec;
        
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        Attachment attachDoc = new Attachment(Name = 'Test Attachment', Description ='Test Class Data', ParentId=subRec.Id,Body=bodyBlob);
        insert attachDoc;
        PortalAttachmentSection portalObj = new PortalAttachmentSection('Funerals','Embalmer Intern',licenseObj.Id);
    }
}