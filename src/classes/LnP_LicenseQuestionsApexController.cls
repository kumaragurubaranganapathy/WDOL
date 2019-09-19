public class LnP_LicenseQuestionsApexController {
    @AuraEnabled
    public static Map<String,String> getAllStaticTexts(){
		 Map<String, String> mapJSON = new Map<String, String>();
         try{
           mapJSON = DE_LandingPageCustomLabels.getWizardStaticTexts(); 
         }
         catch(Exception e){
            HandleException.LogException(e,'LnP_WizardApexController','getAllStaticTexts');
         } 
          
         return mapJSON;
    }
    
    @AuraEnabled
    public static List<String> getPicklistOptions(String field){
        List<String> options = new List<String>();
        
        return options;
    }
    
    @AuraEnabled
    public static Id startAnApplication(String board, String licenseType, String applicationType){
        Id abc  ='a3Er0000000Thl4';
        return abc;
    }
    
    

}