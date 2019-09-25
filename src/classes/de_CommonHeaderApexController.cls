public class de_CommonHeaderApexController {
     @AuraEnabled
    public static Map<String,String> getCommonHeaderCustomLabels(){
         try{
         Map<String, String> mapCommonHeaderLabels = new Map<String, String>();
         mapCommonHeaderLabels = DE_LandingPageCustomLabels.getCommonHeaderLabels(); 
          
         return mapCommonHeaderLabels;
         }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
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
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
      }


}