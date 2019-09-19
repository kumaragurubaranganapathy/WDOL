global class Scheduler_batchSendLicenseCerti implements Schedulable{

    public static String sched = DOL_AppConstants.NULL_EMPTY_STRING + '0 00 00 * * ?';  //Every Day at Midnight 

    global static String scheduleMe() {
        Scheduler_batchSendLicenseCerti SC = new Scheduler_batchSendLicenseCerti(); 
        return System.schedule('Batch for Sending License Certification', sched, SC);
    }

    global void execute(SchedulableContext sc) {

        batchSendLicenseCertification b1 = new batchSendLicenseCertification();
        ID batchprocessid = Database.executeBatch(b1,200);           
    }
}