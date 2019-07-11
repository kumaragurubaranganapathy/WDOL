global class Polaris_ScheduleRBSAuditSelBatch {
 
    global void execute(SchedulableContext ctx) {
        Polaris_RBSAuditSelectionBatchClass p = new Polaris_RBSAuditSelectionBatchClass();
        database.executeBatch(p);
    }   
}