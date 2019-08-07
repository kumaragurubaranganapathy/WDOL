public class LnP_PublicFormsApexController {
	@AuraEnabled
    public static Map<String,String> getFormsJSON(){
         Map<String, String> mapJSON = new Map<String, String>();
         try{
           mapJSON = DE_LandingPageCustomLabels.getPublicFormsJSON(); 
         }
         catch(Exception e){
            HandleException.LogException(e,'LnP_PublicFormsApexController','getFormsJSON');
         }  
          
         return mapJSON;
    }
    @AuraEnabled
    public static SOD_Autocomplete_Wrapper getAutoComplete(string strPrefix) {
        
        strPrefix = EncodingUtil.urlEncode(strPrefix, 'UTF-8');
        SOD_Address_Auth__c objCS = SOD_Address_Auth__c.getInstance('Auto_Complete_Address');
        String url = objCS.url__c
            + 'auth-id=' +objCS.AuthID__c
            + '&auth-token=' +objCS.AuthToken__c
            + '&prefix=' + strPrefix;
        
        system.debug('URL = '+url);
        try{
           SOD_Autocomplete_Wrapper response = SOD_Autocomplete_Wrapper.parse(makeAPICall(url));
           return response; 
        }
        catch(Exception e){
            HandleException.LogException(e,'LnP_PublicFormsApexController','getAutoComplete');
            return null;
        }

 
    }
    private static string makeAPICall(string url) {

            Http http = new Http();
            HttpRequest httpRequest = new HttpRequest();
            HttpResponse httpResponse = new HttpResponse();
            httpRequest.setMethod('GET');
            httpRequest.setEndpoint(url);
            httpRequest.setTimeout(120000);
            httpResponse = http.send(httpRequest); 
            system.debug('httpResponse = '+httpResponse);
            
            if (httpResponse.getStatusCode() == 200){
                system.debug(httpResponse.getBody());
                return httpResponse.getBody();    
            } else {
                System.debug(httpResponse.getStatusCode());
                System.debug(httpResponse.getBody());
                throw new AuraHandledException(httpResponse.getBody());
            }
    }
    
    @AuraEnabled
    public static String userlogin(string usrnm, string pwd){
    string loginMessage = '';
    string errorMsg = '';
    string startUrl='/s'; 
          try{
            PageReference lgn = Site.login(usrnm, pwd, startUrl);
            aura.redirect(lgn);
            system.debug('lgn='+lgn);
        }
        catch (Exception ex) {
           errorMsg = ex.getMessage();
           HandleException.LogException(ex,'LnP_PublicFormsApexController','userlogin');
           return errorMsg;
           
        }    
         return 'Success';          
        
    }

    
}