public class LnP_comHeaderPublicFormsApexController {
	 @AuraEnabled
    public static Map<String,String> getCommonHeaderCustomLabels(){
         Map<String, String> mapCommonHeaderLabels = new Map<String, String>();
        try{
            mapCommonHeaderLabels = DE_LandingPageCustomLabels.getCommonHeaderLabels();
        }
        catch(Exception e){
            HandleException.LogException(e,'LnP_comHeaderPublicFormsApexController','getCommonHeaderCustomLabels');
        }
         return mapCommonHeaderLabels;
      }
    
     @AuraEnabled
    public static List<String> getCurrentUserInfo(){
         List<String> usrInfo = new List<String>();
        try{
         String userType= UserInfo.getUserType();
         String userName = UserInfo.getName();
         usrInfo.add(userType);
         usrInfo.add(userName);
        }
		catch(Exception e){
            HandleException.LogException(e,'LnP_comHeaderPublicFormsApexController','getCurrentUserInfo');
        }
         return usrInfo;
      }
}