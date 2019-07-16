public class de_CommonHeaderApexController {
     @AuraEnabled
    public static Map<String,String> getCommonHeaderCustomLabels(){
         Map<String, String> mapCommonHeaderLabels = new Map<String, String>();
         mapCommonHeaderLabels = DE_LandingPageCustomLabels.getCommonHeaderLabels(); 
          
         return mapCommonHeaderLabels;
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


}