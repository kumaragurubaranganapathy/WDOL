public class Mule_API_Testing_Utility {

    public static void test(){
        DOL_Mule_API_Info__c apiInfo = [select Request_Body__c, Request_Type__c, API_URI__c, Headers__c from DOL_Mule_API_Info__c where id = 'a3fr0000000C35v'];
        MuleApiHeader header = new MuleApiHeader();
        List<MuleApiHeader> headers = header.parse(apiInfo.Headers__c);
        
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(apiInfo.API_URI__c);
        req.setMethod(apiInfo.Request_Type__c);
        req.setBody(apiInfo.Request_Body__c);
        //req.requestBody = Blob.valueOf(apiInfo.Request_Body__c);
        
        for(MuleApiHeader h : headers){
            req.setHeader(h.key, h.value);
        }
      //  System.debug('req = '+req);
        Http http = new Http();
        HttpResponse resp = http.send(req);
        //System.debug('output = '+resp.getBody());
    }
    
    public class MuleApiHeader{
        public String key { get; set; }
        public String value { get; set; }
        
        public List<MuleApiHeader> parse(String jsonInput){
            return (List<MuleApiHeader>) System.JSON.deserialize(jsonInput, List<MuleApiHeader>.class);
        }
    }
}