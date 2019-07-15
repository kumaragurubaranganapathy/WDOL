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
      @AuraEnabled
    public static List<String> getContactUserInfo(Id conId){
         List<String> usrInfo = new List<String>();
        try{
         List<User> userDetail = [select id,UserType,Name from User where ContactId=:conId];
         String userType= userDetail[0].UserType;
         String userName = userDetail[0].Name;
         usrInfo.add(userType);
         usrInfo.add(userName);
        }
		catch(Exception e){
            HandleException.LogException(e,'LnP_comHeaderPublicFormsApexController','getCurrentUserInfo');
        }
         return usrInfo;
      }
}