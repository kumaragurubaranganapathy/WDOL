@isTest
public class DE_WidgetController_Test {
	@isTest
    public static void testGetCustomLabelMap(){
        DE_WidgetController.getCustomLabelMap();
    }
    
    @isTest
    public static void testErrorLogger(){
        try{
            DE_WidgetController.errorLogger();
        }catch(Exception ex){
            
        }
    }
    
    @isTest
    public static void testErrorLogger22(){
        try{
            DE_WidgetController.errorLogger22();
        }catch(Exception ex){
            
        }
    }
}