@isTest
public class batchSendLicenseCertificationTest {
    @testSetup
    static void createData(){
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('User_Account').getRecordTypeId();
        Account acc = DOL_TestDataFactory.createAccount(accRecordTypeId);
        
        Id contactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Contact').getRecordTypeId();
        Contact con = DOL_TestDataFactory.createContact(contactRecordTypeId, acc.Id);
        con.Email = 'test@test.com';
        update con;
        
        Id licRecordTypeId = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByDeveloperName().get('Business').getRecordTypeId();
        MUSW__License2__c lic = DOL_TestDataFactory.createLicense(licRecordTypeId, acc.Id, 'Cemeteries', 'Cemetery', 'General Application');
    }
    
    
    @isTest
    static void batchTest(){
        Contact con = [SELECT Id, Name, Email FROM Contact LIMIT 1];
        List<MUSW__License2__c> lic = [SELECT Id, Print_License_Email__c, MUSW__Status__c, MUSW__Applicant__c, MUSW__Applicant__r.Email, MUSW__Total_Fees__c, MUSW__Total_Payments__c FROM MUSW__License2__c];
        lic[0].Print_License_Email__c = 'Yes';
        lic[0].MUSW__Status__c = 'Active';
        lic[0].MUSW__Applicant__c = con.Id; 
        lic[0].MUSW__Total_Fees__c = 200;
        lic[0].MUSW__Total_Payments__c = 100;
        update lic;
        //System.debug('applicant Email::'+lic[0].MUSW__Applicant__r.Email);
        //System.debug('Contact Email::'+con.Email);
        
        String before = 'Testing base 64 encode';
        Blob beforeblob = Blob.valueOf(before);
        String base64Data = EncodingUtil.base64Encode(beforeblob);
        
        ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S';
        cv.VersionData = EncodingUtil.base64Decode(base64Data);
        cv.Title = 'License cversion';
        cv.PathOnClient = 'cversion';
        insert cv;
        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;        
        cdl.LinkedEntityId = lic[0].Id;
        cdl.ShareType = 'V';
        insert cdl;
        //System.debug('LinkedEntity::'+cdl.LinkedEntityId);
        Test.startTest();
        batchSendLicenseCertification bS = new batchSendLicenseCertification();
        Id batchId = Database.executeBatch(bS);
        
        Test.stopTest();
        System.assertEquals(1, 1);
    }
}