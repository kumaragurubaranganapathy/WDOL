@isTest
public class Polaris_ScheduleRBSAuditSelBatchTest {
 @isTest
    static void schedule(){
        Test.startTest();
        Polaris_ScheduleRBSAuditSelBatch auditbatch = new Polaris_ScheduleRBSAuditSelBatch();
        
        //RecordDeletionScheduler rds = new RecordDeletionScheduler();
        string schedule = DOL_AppConstants.NULL_EMPTY_STRING + '0 0 23 * * ?';
        System.schedule('Test Record Deletion', schedule, auditbatch);
        
        Test.stopTest();
    } 
}