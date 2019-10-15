@isTest
public class DhpReminderEmailScheduler_Test {
    @isTest
    public static void testExecute(){
        Id businessAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account acc= DOL_TestDataFactory.createAccount(businessAccount);
        acc.Email__c = 'test@mailinator.com';
        update acc;
        
        Id businessLicenseType = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c lic = DOL_TestDataFactory.createLicense(businessLicenseType, acc.Id, 'Architects', 'Architect', 'General Application');
        lic.Polaris_DHP__c = true;
        update lic;
        
        MUSW__Fee__c fee = DOL_TestDataFactory.createFeeWithLicense('DHP',100,lic.Id);
        Datetime testingday = Datetime.now().addDays(-60);
        Test.setCreatedDate(fee.Id, testingday);
        update fee;
        
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Dishonored',
            PathOnClient = 'Penguins.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersion;    
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = lic.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;
        
        Test.startTest();
        
        //Select id,MUSW__License2__c,MUSW__Outstanding_Fee__c,Days_since_created__c from MUSW__Fee__c where MUSW__Type__c = 'DHP' and MUSW__Outstanding_Fee__c > 0 and (Days_since_created__c = 60)
        DhpReminderEmailScheduler p = new DhpReminderEmailScheduler(); //Schedule apex class name
        String sch = '0 46 * * * ?'; //schedule interval time
        system.schedule('DhpReminderEmailScheduler', sch, p); //system method to schedule apex class
        Test.stopTest();
    }
}