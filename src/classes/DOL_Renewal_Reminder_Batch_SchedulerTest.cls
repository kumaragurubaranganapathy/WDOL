@isTest
public class DOL_Renewal_Reminder_Batch_SchedulerTest {

@isTest
static void method1(){
    Test.startTest();
    DOL_Renewal_Reminder_Batch_Scheduler sh1 = new DOL_Renewal_Reminder_Batch_Scheduler();
    String sch = '0 0 2 * * ?'; 
    system.schedule('Test Territory Check', sch, sh1); 
    Test.stopTest();
}
}