@istest
public class HandleIncompleteRenYearlySchedulerTest {
static testmethod void testschedule() {
Test.StartTest();
HandleIncompleteRenewalsYearlyScheduler sh1 = new HandleIncompleteRenewalsYearlyScheduler();      
String sch = '0 0 23 * * ?';
system.schedule('Test check', sch, sh1);
Test.stopTest();
}
}