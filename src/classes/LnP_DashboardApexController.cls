public class LnP_DashboardApexController {
       
	@AuraEnabled
    public static Map<String,String> getDBJSON(){
         Map<String, String> mapJSON = new Map<String, String>();
        try{
         mapJSON = DE_LandingPageCustomLabels.getDashboardJSON(); 
        }
         catch(Exception e){
             HandleException.LogException(e,'LnP_DashboardApexController','getDBJSON');
        }
         return mapJSON;
    }
}