@isTest
public class DE_CreateLightningServerResponse_Test {
	@isTest
    public static void testController1(){
        DE_CreateLightningServerResponse res = new DE_CreateLightningServerResponse();
        
    } 
    @isTest
    public static void testController2(){
        DE_CreateLightningServerResponse res = new DE_CreateLightningServerResponse(true, 'Successful',null,null);
    }
    
    @isTest
    public static void testController3(){
        DE_CreateLightningServerResponse res = new DE_CreateLightningServerResponse(true, 'Successful',null);
   } 
    @isTest
    public static void testController4(){
        DE_CreateLightningServerResponse res = new DE_CreateLightningServerResponse(true,new map<String, Object>(),new map<String, Object>());
    }
    @isTest
    public static void testController5(){
        DE_CreateLightningServerResponse res = new DE_CreateLightningServerResponse(false, 'Error',null,null);
    }
    
}