public class LnP_DashboardApexController {
       
    @AuraEnabled
    public static Map<String,String> getDBJSON(){
         Map<String, String> mapJSON = new Map<String, String>();
        try{
       //  System.debug('mapJSON::');
         mapJSON = DE_LandingPageCustomLabels.getDashboardJSON(); 
        // System.debug('mapJSON: after::'+ mapJSON );
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
         return mapJSON;
    }
}