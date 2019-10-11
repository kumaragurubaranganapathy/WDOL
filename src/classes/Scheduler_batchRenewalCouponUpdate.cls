global class Scheduler_batchRenewalCouponUpdate implements Schedulable{

    public static String sched = DOL_AppConstants.NULL_EMPTY_STRING + '0 30 0 ? * 4#4 *';  //Every 4nd wednesday at 00:30 

    global static String scheduleMe() {
        Scheduler_batchRenewalCouponUpdate SC = new Scheduler_batchRenewalCouponUpdate(); 
        return System.schedule('Renewal Letter Update 4th wednesday', sched, SC);
    }

    global void execute(SchedulableContext sc) {

        DOL_batchRenewalLetterUpdate b1 = new DOL_batchRenewalLetterUpdate();
        ID batchprocessid = Database.executeBatch(b1,200);           
    }
}