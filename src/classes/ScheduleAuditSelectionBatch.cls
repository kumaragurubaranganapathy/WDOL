global class ScheduleAuditSelectionBatch implements Schedulable{

    global void execute(SchedulableContext ctx) {
        Polaris_AuditSelectionBatchClass p = new Polaris_AuditSelectionBatchClass();
        database.executeBatch(p);
    }   
}