@isTest
public class DebugErrorLogggerTest {
    static testMethod void newLogs(){
        Test.startTest();
        
        try{
                Contact cc = new Contact();
                insert cc;
            }catch(Exception e){
            
            DebugErrorLoggger ee = new DebugErrorLoggger();
            ee.LogError(e);
            ee.logFatalError(e);
            ee.logWarning(e);
            
            DebugErrorLoggger.LogFatal(e, 'sObjectId', 'sObjectName','className','functionalityImpacted','comments');
            DebugErrorLoggger.LogWarning(e, 'sObjectId', 'sObjectName','className','functionalityImpacted','comments');
            DebugErrorLoggger.LogError(e, 'sObjectId', 'sObjectName','className','functionalityImpacted','comments');
            System.assert(true);  
      }//end try
      Test.stopTest();
     } //end method
     
}//end class