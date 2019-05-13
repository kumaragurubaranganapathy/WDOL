public class de_CommonFooterApexController {
	 @AuraEnabled
    public static Map<String,String> getCommonFooterCustomLabels(){
         Map<String, String> mapCommonFooterLabels = new Map<String, String>();
         mapCommonFooterLabels = DE_LandingPageCustomLabels.getCommonFooterLabels(); 
          
         return mapCommonFooterLabels;
      }
}