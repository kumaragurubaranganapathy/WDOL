global class Scheduler_batchRenewalCouponUpdate implements Schedulable{

    public static String sched = '0 00 00 * * ?';  //Every Day at Midnight 

    global static String scheduleMe() {
        Scheduler_batchRenewalCouponUpdate SC = new Scheduler_batchRenewalCouponUpdate(); 
        return System.schedule('Batch for Renewal Coupon Update', sched, SC);
    }

    global void execute(SchedulableContext sc) {

        batchRenewalCouponUpdate b1 = new batchRenewalCouponUpdate();
        ID batchprocessid = Database.executeBatch(b1,200);           
    }
}