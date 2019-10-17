@isTest
public class ScheduleRBSAuditSelectionBatchTest {
    public static testmethod void testBatchScheduler(){
        Test.startTest();
        ScheduleRBSAuditSelectionBatch bts = new ScheduleRBSAuditSelectionBatch();
        String sch ='0 48 * * * ?'; 
    System.schedule('Schedule to update Account Name', sch,bts);
        Test.stopTest();
        
    }
}