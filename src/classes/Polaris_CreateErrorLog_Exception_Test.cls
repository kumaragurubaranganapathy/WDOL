@isTest
public class Polaris_CreateErrorLog_Exception_Test {
@isTest
    public static void testMethod1(){
        try{
            Integer i = 10/0;
        }catch(Exception e){
            Polaris_CreateErrorLog_Exception.addError(e, 'Test', 'Test');
        }
    }
    
    @isTest
    public static void testMethod2(){
        try{
            Integer i = 10/0;
        }catch(Exception e){
            Polaris_CreateErrorLog_Exception.createErrorLogs(e, 'Test', 'Test');
        }
    }
    
    @isTest
    public static void testMethod3(){
        try{
            Integer i = 10/0;
        }catch(Exception e){
            Id id = Polaris_CreateErrorLog_Exception.logApplicationError(e, 'Test', 'Test');
            
        }
    }
}