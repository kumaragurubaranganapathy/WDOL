public class LnP_HomeThemeFooterApexController {
	 @AuraEnabled
    public static Map<String,String> getUrlMap(){
        Map<String,String> urlMap = new Map<String,String>();
        List<de_HomeFooterUrlList__mdt> records =[select Label,URL__c from de_HomeFooterUrlList__mdt];
        
        for(de_HomeFooterUrlList__mdt rec:records){
            urlMap.put(rec.Label,rec.URL__c);
        }
          return urlMap;
      }
    
     @AuraEnabled
    public static Map<String,String> getFooterCustomLabels(){
         Map<String, String> mapFooterLabels = new Map<String, String>();
        try{
         mapFooterLabels = DE_LandingPageCustomLabels.getFooterLabels();
        }
        catch(Exception e){
            HandleException.LogException(e,'LnP_HomeThemeFooterApexController','getFooterCustomLabels');
        }
          
         return mapFooterLabels;
      }
}