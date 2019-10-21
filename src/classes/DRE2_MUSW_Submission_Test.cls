@isTest
public class DRE2_MUSW_Submission_Test {
    @isTest
    public static void testGS(){
        Global_Settings__c gs = DOL_TestDataFactory.createGlobalSetting(UserInfo.getUserId(), true);
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c lic1 = DOL_TestDataFactory.createLicense(LicRecTypeId1, a.Id, 'Architects', 'Architect', 'General Application');
        MUSW__Submission__c sb = DOL_TestDataFactory.createSubmission(lic1.Id);
    }
    @isTest
    public static void testMethod1(){
        Global_Settings__c gs = DOL_TestDataFactory.createGlobalSetting(UserInfo.getUserId(), false);
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c lic1 = DOL_TestDataFactory.createLicense(LicRecTypeId1, a.Id, 'Architects', 'Architect', 'General Application');
        MUSW__Submission__c sb = DOL_TestDataFactory.createSubmission(lic1.Id);
        ContentVersion contentVersion = new ContentVersion(
            Title = 'PublicShare',
            PathOnClient = 'Penguins.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersion;    
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = sb.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;
    }
    
    @isTest
    public static void testMethod2(){
        Global_Settings__c gs = DOL_TestDataFactory.createGlobalSetting(UserInfo.getUserId(), false);
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c lic1 = DOL_TestDataFactory.createLicense(LicRecTypeId1, a.Id, 'Architects', 'Architect', 'General Application');
        MUSW__Submission__c sb = DOL_TestDataFactory.createSubmission(lic1.Id);
        ContentVersion contentVersion = new ContentVersion(
            Title = 'PublicShare',
            PathOnClient = 'Penguins.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersion;    
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = sb.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;
        
        MUSW__Complaint2__c cm = new MUSW__Complaint2__c(Name='Complaint'+System.Now(), Program_Type__c='Architects', MUSW__Status__c='Intake', License__c=lic1.Id);
        insert cm;
        
        sb.Public_Disciplinary_Action__c = true;
        sb.Disciplinary_Action_End_Date__c = system.today();
        sb.MUSW__License2__c = lic1.Id;
        sb.Complaint__c = cm.id;
        
        update sb;
    }
    
}