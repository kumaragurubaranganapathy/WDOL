public class de_CommonFooterApexController {
	 @AuraEnabled
    public static Map<String,String> getCommonFooterCustomLabels(){
         try{
         Map<String, String> mapCommonFooterLabels = new Map<String, String>();
         mapCommonFooterLabels = DE_LandingPageCustomLabels.getCommonFooterLabels(); 
          
         return mapCommonFooterLabels;
         }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
      }
}