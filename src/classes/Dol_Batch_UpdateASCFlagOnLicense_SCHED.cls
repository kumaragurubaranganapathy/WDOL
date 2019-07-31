global class Dol_Batch_UpdateASCFlagOnLicense_SCHED implements Schedulable { 
    global void execute(SchedulableContext sc){
    	if((!Dol_IntegrationUtil.isBatchRunning('Dol_Batch_UpdateASCFlagOnLicense'))){
	        Dol_Batch_UpdateASCFlagOnLicense batch = new Dol_Batch_UpdateASCFlagOnLicense();
	        Database.executeBatch(batch, 2);   
        } 
    }
}