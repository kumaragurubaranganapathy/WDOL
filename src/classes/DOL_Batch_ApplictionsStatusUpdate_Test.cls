@isTest
public class DOL_Batch_ApplictionsStatusUpdate_Test {
    @isTest
    public static void testBatch(){
        
        Id AppRecTypeId = Schema.SObjectType.MUSW__Application2__c.getRecordTypeInfosByName().get('General Service Request').getRecordTypeId();
		MUSW__Application2__c app = new MUSW__Application2__c(RecordTypeId = AppRecTypeId, Name='System Number');
        insert app;
        
        Test.startTest();
        DOL_Batch_ApplictionsStatusUpdate bc = new DOL_Batch_ApplictionsStatusUpdate();
        DataBase.executeBatch(bc); 
        Test.stopTest();
    }
}