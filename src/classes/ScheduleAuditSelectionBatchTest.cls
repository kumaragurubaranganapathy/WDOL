@isTest
public class ScheduleAuditSelectionBatchTest {
    public static testmethod void testBatchScheduler(){
        Test.startTest();
        ScheduleAuditSelectionBatch bts = new ScheduleAuditSelectionBatch();
        String sch ='0 48 * * * ?'; 
		System.schedule('Schedule to update Account Name', sch,bts);
        Test.stopTest();
        
    }
}