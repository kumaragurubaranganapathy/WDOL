@isTest
public class Scheduler_batchRenewalLetter_SeTest{
    public static testmethod void testLicenseCertMethod(){
        Test.startTest();
        Scheduler_batchRenewalLetter_SecondWeek bsl = new Scheduler_batchRenewalLetter_SecondWeek();
        String sch ='0 30 0 ? * 4#2 *'; 
        System.schedule('Renewal Letter Update test',sch,bsl);
        Scheduler_batchRenewalLetter_SecondWeek.scheduleMe();
        Test.stopTest();
    }
}