@IsTest
public class DOL_Integration_SCHED_Test {
	
    @IsTest
    public static void testRTPCScheduler(){
        Test.startTest();
        DOL_ProcessRTPC_Batch_SCHED schedulable = new DOL_ProcessRTPC_Batch_SCHED();
        String cronExp = '0 46 * * * ?';
        System.schedule('DOL_ProcessRTPC_Batch_SCHED', cronExp, schedulable);
        Test.stopTest();
    }
    
    @IsTest
    public static void testNCRScheduler(){
        Test.startTest();
        DOL_Process_NCR_Data_Batch_SCHED schedulable = new DOL_Process_NCR_Data_Batch_SCHED();
        String cronExp = '0 46 * * * ?';
        System.schedule('DOL_Process_NCR_Data_Batch_SCHED', cronExp, schedulable);
        Test.stopTest();
    }
    
    @IsTest
    public static void testDORScheduler(){
        Test.startTest();
        DOL_Process_DOR_Data_Batch_SCHED schedulable = new DOL_Process_DOR_Data_Batch_SCHED();
        String cronExp = '0 46 * * * ?';
        System.schedule('DOL_Process_DOR_Data_Batch_SCHED', cronExp, schedulable);
        Test.stopTest();
    }
    
    @IsTest
    public static void testRemittanceScheduler(){
        Test.startTest();
        DOL_Epayment_ProcessRemittanceData_SCHED schedulable = new DOL_Epayment_ProcessRemittanceData_SCHED();
        String cronExp = '0 46 * * * ?';
        System.schedule('DOL_Epayment_ProcessRemittanceData_SCHED', cronExp, schedulable);
        Test.stopTest();
    }
}