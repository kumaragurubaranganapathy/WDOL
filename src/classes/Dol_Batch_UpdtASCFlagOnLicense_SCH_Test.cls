@isTest
private class Dol_Batch_UpdtASCFlagOnLicense_SCH_Test {
    @isTest 
    public static void test_execute_UseCase1(){
        Datetime dTime = Datetime.now().addMinutes(1);
        String CRON_EXP = '0 '+ dTime.minute() + ' * ' + dTime.day() + ' ' + dTime.month() + ' ? ' + dTime.year();
        String jobId = system.schedule('test_execute_UseCase1', CRON_EXP, new Dol_Batch_UpdateASCFlagOnLicense_SCHED());
    } 
}