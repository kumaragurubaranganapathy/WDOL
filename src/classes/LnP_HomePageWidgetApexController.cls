public class LnP_HomePageWidgetApexController {
	 @AuraEnabled
    public static Map<String,String> getCustomLabelMap(){
       System.debug('Exe Here0000 ');
       Map<String, String> mapWidgetLabels = new Map<String, String>();
       mapWidgetLabels = DE_LandingPageCustomLabels.getWidgetLabels();

       return mapWidgetLabels;
    }
    
    @AuraEnabled
    public static List<String> getCurrentUserInfo(){
         List<String> usrInfo = new List<String>();
         String userType= UserInfo.getUserType();
         String userName = UserInfo.getName();
         usrInfo.add(userType);
         usrInfo.add(userName);
         return usrInfo;
    }
    
    @AuraEnabled
    public static void logError(){    
        try{
            Account a = new Account();
            insert a;
        } catch(Exception e){
            HandleException.LogException(e,'LnP_HomePageWidgetApexController','logError');
        }
    }
}