global class DOL_Renewal_Reminder_Batch_Scheduler implements Schedulable {
    
    global void execute(SchedulableContext ctx) {
        Id batchJobId = Database.executeBatch(new Dol_Batch_CreateRenewalTask(), 200);
        System.debug(batchJobId);
    }
    
}