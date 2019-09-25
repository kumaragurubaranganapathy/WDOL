public class LnP_LicenseQuestionsApexController {
    @AuraEnabled
    public static Map<String,String> getAllStaticTexts(){
		 Map<String, String> mapJSON = new Map<String, String>();
         try{
           mapJSON = DE_LandingPageCustomLabels.getWizardStaticTexts(); 
         }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        } 
          
         return mapJSON;
    }
    
    @AuraEnabled
    public static List<String> getPicklistOptions(String field){
        try{
        List<String> options = new List<String>();
        
        return options;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
    }
    
    @AuraEnabled
    public static Id startAnApplication(String board, String licenseType, String applicationType){
        try{
        Id abc  = DOL_AppConstants.NULL_EMPTY_STRING + 'a3Er0000000Thl4';
        return abc;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
    }
    
    

}