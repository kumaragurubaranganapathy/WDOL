global class DOL_Epayment_ProcessRemittanceData_SCHED implements Schedulable {
    global void execute(SchedulableContext sc){
        if(! Dol_IntegrationUtil.isBatchRunning('DOL_Epayment_ProcessRemittanceData')){
            DOL_Epayment_ProcessRemittanceData batch = new DOL_Epayment_ProcessRemittanceData();
            Database.executeBatch(batch,1);
        }
    }
}