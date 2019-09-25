public class LnP_HomeThemeFooterApexController {
	 @AuraEnabled
    public static Map<String,String> getUrlMap(){
        try{
        Map<String,String> urlMap = new Map<String,String>();
       // List<de_HomeFooterUrlList__mdt> records =[select Label,URL__c from de_HomeFooterUrlList__mdt];
        
        for(de_HomeFooterUrlList__mdt rec:[select Label,URL__c from de_HomeFooterUrlList__mdt]){
            urlMap.put(rec.Label,rec.URL__c);
        }
          return urlMap;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
      }
    
     @AuraEnabled
    public static Map<String,String> getFooterCustomLabels(){
         Map<String, String> mapFooterLabels = new Map<String, String>();
        try{
         mapFooterLabels = DE_LandingPageCustomLabels.getFooterLabels();
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
          
         return mapFooterLabels;
      }
}