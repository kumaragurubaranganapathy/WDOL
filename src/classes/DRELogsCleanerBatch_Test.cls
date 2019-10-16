@isTest
public class DRELogsCleanerBatch_Test {

    @isTest
    public static void testDRECleaner(){
        
        Test.startTest();
        DRE__DRE_Event_Log__c dp = new DRE__DRE_Event_Log__c();
        insert dp;
        
        DRELogsCleanerBatch p = new DRELogsCleanerBatch(); //Schedule apex class name
        String sch = '0 46 * * * ?'; //schedule interval time
        system.schedule('DRELogsCleanerBatch', sch, p); //system method to schedule apex class
        
        DRELogsCleanerBatch batchReference = new DRELogsCleanerBatch();
        database.executebatch(batchReference,20);
        
        Test.stopTest();   
    }
    
}