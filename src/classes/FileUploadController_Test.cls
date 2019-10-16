@isTest
public class FileUploadController_Test {
    
    @testSetup
    public static void setupTestData(){
        //Create Document
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document';
        cv.PathOnClient = 'TestDocument.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;
        
        //Get Content Version
        List<ContentVersion> cvList = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
        System.assertEquals(cvList.size(), 1);
        
        //Get Content Documents
        List<ContentDocument> cdList = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        System.assertEquals(cdList.size(), 1);
    }
    
    @isTest
    public static void test01(){
       try {
            ContentDocument doc = [SELECT Id from ContentDocument limit 1];
            delete doc;
            FileUploadController.setContentId(null,null); 
            FileUploadController.FileSize('docId');
            FileUploadController.deleteFiles('docId');
           
          
           
        } catch(Exception e) {
            DOL_CreateErrorLog_Exception.logApplicationError(e);
            //System.debug('Error '+e);
            //system.assertEquals(e.getMessage().contains('error'), true, 'Error msg');
          
        }
    	
       
    }
    
    @isTest
    public static void test02(){
        ContentDocument doc = [SELECT Id from ContentDocument limit 1];
       
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('User Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        MUSW__License2__c license1 = DOL_TestDataFactory.createLicense(LicRecTypeId1, a.Id, 'Architects', 'Architect', 'General Application');
        license1.MUSW__Status__c = 'Pending Payment';        
        license1.Manual_Fee_Generation__c = true;
        update license1;  
        
        MUSW__Submission__c testSubmission = DOL_TestDataFactory.createSubmission(license1.Id);
        test.startTest();
        FileUploadController.FileSize(doc.id);
        FileUploadController.deleteFiles(doc.Id);
        FileUploadController.setContentId(testSubmission.Id, doc.Id);
        test.stopTest();
        
    }
}