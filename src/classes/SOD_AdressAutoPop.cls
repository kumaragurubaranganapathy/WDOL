public class SOD_AdressAutoPop {
    @AuraEnabled
    public static SOD_Autocomplete_Wrapper getAutoComplete(string strPrefix) {
        try{
        strPrefix = EncodingUtil.urlEncode(strPrefix, 'UTF-8');
        SOD_Address_Auth__c objCS = SOD_Address_Auth__c.getInstance('Auto_Complete_Address');
        String url = objCS.url__c
            + 'auth-id=' +objCS.AuthID__c
            + '&auth-token=' +objCS.AuthToken__c
            + '&key=' +objCS.Key__c
            + '&prefix=' + strPrefix;
        
     //   system.debug('URL = '+url);
        SOD_Autocomplete_Wrapper response = SOD_Autocomplete_Wrapper.parse(makeAPICall(url));
     //   system.debug('response111' +response);
        return response;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
    }
    
    
    /*public static string getZipCode(string state, string city) {
        
        SOD_Address_Auth__c objCS = SOD_Address_Auth__c.getInstance('Zip_Code');
        String url = objCS.url__c
            + 'auth-id=' +objCS.AuthID__c
            + '&auth-token=' +objCS.AuthToken__c
            + '&city=' +city
            + '&state=' +state;
        
  //      system.debug('URL = '+url);
        List<SOD_ZipCode_Wrapper> objZip = SOD_ZipCode_Wrapper.parse(makeAPICall(url));
  //      system.debug(objZip[0].zipcodes[0].zipcode);
        return objZip[0].zipcodes[0].zipcode;
    }*/
    @TestVisible
    private static string makeAPICall(string url) {
        
        Http http = new Http();
        HttpRequest httpRequest = new HttpRequest();
        HttpResponse httpResponse = new HttpResponse();
        httpRequest.setMethod('GET');
        httpRequest.setEndpoint(url);
        httpRequest.setTimeout(120000);
        httpResponse = http.send(httpRequest); 
   //     system.debug('httpResponse = '+httpResponse);
        
        if (httpResponse.getStatusCode() == 200){
         //   system.debug(httpResponse.getBody());
            return httpResponse.getBody();    
        } else {
         //   System.debug(httpResponse.getStatusCode());
       //     System.debug(httpResponse.getBody());
            throw new AuraHandledException(httpResponse.getBody());
        }  
    }
    
    /*@AuraEnabled
    public static SOD_Autocomplete_Wrapper callgetAutoComplete(string strPrefix){
        SOD_Autocomplete_Wrapper response = getAutoComplete(strPrefix);
         return response;
    }*/
}