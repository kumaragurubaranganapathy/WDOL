public class LnP_comFooterPublicFormsApexController {
	@AuraEnabled
    public static Map<String,String> getCommonFooterCustomLabels(){
         Map<String, String> mapCommonFooterLabels = new Map<String, String>();
         try{
            mapCommonFooterLabels = DE_LandingPageCustomLabels.getCommonFooterLabels(); 
         }
		 catch(Exception e){
            HandleException.LogException(e,'LnP_comFooterPublicFormsApexController','getCommonFooterCustomLabels');
         }
         return mapCommonFooterLabels;
      }
}