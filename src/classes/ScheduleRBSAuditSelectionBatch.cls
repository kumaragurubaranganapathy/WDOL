global class ScheduleRBSAuditSelectionBatch implements Schedulable{

    global void execute(SchedulableContext ctx) {
        Polaris_RBSAuditSelectionBatchClass p = new Polaris_RBSAuditSelectionBatchClass();
        database.executeBatch(p);
    }   
}