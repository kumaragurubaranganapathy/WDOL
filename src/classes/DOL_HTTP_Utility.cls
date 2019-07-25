/**
* User Story: 2298
* Class Name: DOL_HTTP_Utility
* Test Class Name: ****
* Description: HTTP utility class
* Date:        Developer/Company                    Description
* ----------------------------------------------------------------------------*
* 07/08/2019   Laltu Banerjee/Deloitte           Initial Creation
**/
public class DOL_HTTP_Utility {
    
    public static HttpResponse doHttpRequest(String url,String requestType, String requestBody, String urlParams, String headers){
        List<HttpApiHeader> httpApiHeaders = null;
        List<HttpUrlParam> httpUrlParams = null;
        String params = '';
        if(headers != null && headers != '')
        	httpApiHeaders = new HttpApiHeader().parse(headers);
        if(urlParams != null && urlParams != '')
        	httpUrlParams = new HttpUrlParam().parse(urlParams);
        
        if(httpUrlParams != null && httpUrlParams.size() > 0){
            for(HttpUrlParam param : httpUrlParams){
                params += param.key+'='+param.value+'&';
            }
        }
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url+'?'+params);
        req.setMethod(requestType);
        req.setBody(requestBody);
        for(HttpApiHeader h : httpApiHeaders){
            req.setHeader(h.key, h.value);
        }
        System.debug('req = '+req);
        Http http = new Http();
        return http.send(req);
    }

    public static HttpResponse doHttpRequest(String url,String requestType, String requestBody, Map<String,String> paramMap, Map<String,String> headerMap ){
        List<HttpApiHeader> httpApiHeaders = null;
        String params = '';
        if(headerMap != null && headerMap.size() > 0 ){
            httpApiHeaders = new List<HttpApiHeader>();
            for( String hm : headerMap.keySet()){
                httpApiHeaders.add(new HttpApiHeader(hm,headerMap.get(hm)));
            }
        }

        HttpRequest req = new HttpRequest();
        req.setEndpoint(url+'?'+params);
        req.setMethod(requestType);
        req.setBody(requestBody);
        if(httpApiHeaders != null){
            for(HttpApiHeader h : httpApiHeaders){
                req.setHeader(h.key, h.value);
            }
        }
        System.debug('req = '+req);
        Http http = new Http();
        return http.send(req);

    }
    
    public class HttpApiHeader{
        public String key { get; set; }
        public String value { get; set; }

        public HttpApiHeader(){}

        public HttpApiHeader( String k, String v){
            key = k;
            value = v;
        }
        
        public List<HttpApiHeader> parse(String jsonInput){
            return (List<HttpApiHeader>) System.JSON.deserialize(jsonInput, List<HttpApiHeader>.class);
        }
    }
    
    public class HttpUrlParam{
        public String key { get; set; }
        public String value { get; set; }
        
        public List<HttpUrlParam> parse(String jsonInput){
            return (List<HttpUrlParam>) System.JSON.deserialize(jsonInput, List<HttpUrlParam>.class);
        }
    }

}