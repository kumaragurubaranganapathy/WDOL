@isTest
public class Polaris_AuditSelectionBatchClassTest {

    @isTest
    public static void testAuditSelection(){
        Id reAppId = Schema.SObjectType.Renewal_Application__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        List<Renewal_Application__c> renewAppList = new List<Renewal_Application__c>();
        for(Integer i=0 ;i <20;i++)
        {
            Renewal_Application__c renApp = new Renewal_Application__c();
            renApp.Application_Type__c = 'Appraisers - Real Estate';
            renApp.Credential_Type__c = 'Certified General Appraiser';
            renApp.Credential__c = 'Certified General Appraiser';
            renApp.Renewal_Reinstatement_Type__c = 'Renewal';
            renApp.Renewal_Status__c = 'Complete';
            renApp.Selected_for_Audit__c = False;
            renApp.Manual_Fee_Generation__c = False;
            renewAppList.add(renApp);
        }
        
        insert renewAppList;
        Test.startTest();
        Polaris_AuditSelectionBatchClass auditClass = new Polaris_AuditSelectionBatchClass();
        Database.executeBatch(auditClass);
        Test.stopTest();
        
    }
}