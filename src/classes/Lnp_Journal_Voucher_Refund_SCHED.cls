global class Lnp_Journal_Voucher_Refund_SCHED {
   
	global void execute(SchedulableContext sc){
        if(! Dol_IntegrationUtil.isBatchRunning('Lnp_Journal_Voucher_Refund')){
            Lnp_Journal_Voucher_Refund batch = new Lnp_Journal_Voucher_Refund();
            Database.executeBatch(batch);
        }
    }


}