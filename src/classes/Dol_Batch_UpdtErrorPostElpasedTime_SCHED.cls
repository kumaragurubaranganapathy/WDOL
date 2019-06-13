global class Dol_Batch_UpdtErrorPostElpasedTime_SCHED implements Schedulable { 
    global void execute(SchedulableContext sc){
    	if((!Dol_IntegrationUtil.isBatchRunning('Dol_Batch_UpdtErrorPostElpasedTime'))){
	        Dol_Batch_UpdtErrorPostElpasedTime batch = new Dol_Batch_UpdtErrorPostElpasedTime();
	        Database.executeBatch(batch, 2);   
        } 
    }
}