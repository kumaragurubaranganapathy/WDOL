@istest  
public class SchedulerCallerTest {
    
    
 @istest  
      public static  void testschedule() {
        Test.StartTest();
        SchedulerCaller sh1 = new SchedulerCaller();
        
        String sch = '0 0 23 * * ?'; 
        system.schedule('SchedulerCaller', sch, sh1);
        Test.stopTest();
    }
}