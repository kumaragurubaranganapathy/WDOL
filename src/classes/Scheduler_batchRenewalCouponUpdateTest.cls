@isTest
public class Scheduler_batchRenewalCouponUpdateTest{
    public static testmethod void testScheduleMethod(){
        Test.startTest();
        Scheduler_batchRenewalCouponUpdate sbc = new Scheduler_batchRenewalCouponUpdate();
        String sch ='0 48 * * * ?'; 
		System.schedule('Schedule to update Account Name', sch,sbc);
        Scheduler_batchRenewalCouponUpdate.scheduleMe();
        Test.stopTest();
    }
}