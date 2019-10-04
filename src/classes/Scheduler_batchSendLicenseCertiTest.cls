@isTest
public class Scheduler_batchSendLicenseCertiTest{
    public static testmethod void testLicenseCertMethod(){
        Test.startTest();
        Scheduler_batchSendLicenseCerti bsl = new Scheduler_batchSendLicenseCerti();
        String sch ='0 48 * * * ?'; 
        System.schedule('Schedule to update Account Name',sch,bsl);
        Scheduler_batchSendLicenseCerti.scheduleMe();
        Test.stopTest();
    }
}