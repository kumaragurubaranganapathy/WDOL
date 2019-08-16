global class DOL_Process_DOR_Data_Batch_SCHED implements Schedulable {
    global void execute(SchedulableContext sc){
        if(! Dol_IntegrationUtil.isBatchRunning('DOL_Process_DOR_Data_Batch')){
            DOL_Process_DOR_Data_Batch batch = new DOL_Process_DOR_Data_Batch();
            Database.executeBatch(batch,1);
        }
    }
}
