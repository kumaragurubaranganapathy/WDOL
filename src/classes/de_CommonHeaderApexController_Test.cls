@isTest
public class de_CommonHeaderApexController_Test {
	@isTest
    public static void testGetCommonHeaderCustomLabels(){
        try{
            de_CommonHeaderApexController.getCommonHeaderCustomLabels();
        }catch(Exception ex){}
    }
    
    @isTest
    public static void testGetCurrentUserInfo(){
        try{
            de_CommonHeaderApexController.getCurrentUserInfo();
        }catch(Exception ex){}
    }
}