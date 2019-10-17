global class Lnp_Journal_Voucher_Generic_SCHED implements Schedulable{
	global void execute(SchedulableContext sc){
        integer batchSize =  integer.valueOf(label.Journal_Voucher_Batch_Size);
        if(! Dol_IntegrationUtil.isBatchRunning('Lnp_Journal_Voucher_Generic')){
            Lnp_Journal_Voucher_Generic batch = new Lnp_Journal_Voucher_Generic();
            Database.executeBatch(batch,batchSize);
        }
    }
}