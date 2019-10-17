public class LnP_HomePageWidgetApexController {
     @AuraEnabled
    public static Map<String,String> getCustomLabelMap(){
       try{
   //    System.debug('Exe Here0000 ');
       Map<String, String> mapWidgetLabels = new Map<String, String>();
       mapWidgetLabels = DE_LandingPageCustomLabels.getWidgetLabels();

       return mapWidgetLabels;
       }catch(Exception ex)
        {   DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
    }
    
    @AuraEnabled
    public static List<String> getCurrentUserInfo(){
         try{
         List<String> usrInfo = new List<String>();
         String userType= UserInfo.getUserType();
         String userName = UserInfo.getName();
         usrInfo.add(userType);
         usrInfo.add(userName);
         return usrInfo;
         }catch(Exception ex)
        {   DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
    }
    
    @AuraEnabled
    public static void logError(){    
        try{
            Account a = new Account();
            insert a;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
    }
}