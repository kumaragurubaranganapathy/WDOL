public class LnP_comFooterPublicFormsApexController {
	@AuraEnabled
    public static Map<String,String> getCommonFooterCustomLabels(){
         Map<String, String> mapCommonFooterLabels = new Map<String, String>();
         try{
            mapCommonFooterLabels = DE_LandingPageCustomLabels.getCommonFooterLabels(); 
         }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
         return mapCommonFooterLabels;
      }
}