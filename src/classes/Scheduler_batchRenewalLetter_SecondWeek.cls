global class Scheduler_batchRenewalLetter_SecondWeek implements Schedulable{

    public static String sched = DOL_AppConstants.NULL_EMPTY_STRING + '0 30 0 ? * 4#2 *';  //Every 2nd wednesday at 00:30 

    global static String scheduleMe() {
        Scheduler_batchRenewalLetter_SecondWeek SC = new Scheduler_batchRenewalLetter_SecondWeek(); 
        return System.schedule('Renewal Letter Update 2nd wednesday', sched, SC);
    }

    global void execute(SchedulableContext sc) {

        DOL_batchRenewalLetterUpdate b1 = new DOL_batchRenewalLetterUpdate();
        ID batchprocessid = Database.executeBatch(b1,200);           
    }
}