public class LnP_comHeaderPublicFormsApexController_2 {
	 @AuraEnabled
    public static Map<String,String> getCommonHeaderCustomLabels(){
         Map<String, String> mapCommonHeaderLabels = new Map<String, String>();
        try{
            mapCommonHeaderLabels.put('Home','Home;'+System.Label.Polaris_Portal_Home+',');
            mapCommonHeaderLabels.put('Professional','Professional;'+System.Label.Polaris_Portal_Dashboard+',');
            mapCommonHeaderLabels.put('Business','Business;'+System.Label.Polaris_Portal_Business_Dashboard+',');
            mapCommonHeaderLabels.put('License Lookup','License Lookup;'+System.Label.Polaris_Portal_LicenseLookup+',');
            mapCommonHeaderLabels.put('Education','Education;'+System.Label.Polaris_Portal_Education+',');
            
            mapCommonHeaderLabels.put('New Dashbord','New Dashbord;'+System.Label.Polaris_Portal_NewDashboard+',');
            //mapCommonHeaderLabels.put('New Dashbord','New Dashbord;https://dev-polaris.cs32.force.com/lightningwashington/s/newdashboard,');
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