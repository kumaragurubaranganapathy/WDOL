@isTest
private class Dol_Batch_UpdtErrorElpased_SCHED_Test {
    @isTest 
    public static void test_execute_UseCase1(){
        Datetime dTime = Datetime.now().addMinutes(1);
        String CRON_EXP = DOL_AppConstants.NULL_EMPTY_STRING + '0 '+ dTime.minute() + ' * ' + dTime.day() + ' ' + dTime.month() + ' ? ' + dTime.year();
        String jobId = system.schedule('test_execute_UseCase1', CRON_EXP, new Dol_Batch_UpdtErrorPostElpasedTime_SCHED());
    } 
}