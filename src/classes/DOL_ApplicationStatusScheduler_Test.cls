@isTest
public class DOL_ApplicationStatusScheduler_Test {
    @isTest
    public static void testSchedule(){
        Test.startTest();
        DOL_Batch_ApplictionsStatusScheduler sh1 = new DOL_Batch_ApplictionsStatusScheduler();   
        String sch = '0 46 * * * ?';
        system.schedule('DOL_Batch_ApplictionsStatusUpdate', sch, sh1); //system method to schedule apex class
        
        Test.stopTest();
    }
    
}