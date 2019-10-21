@IsTest
public class DOL_HTTP_Utility_Test {
	
    @IsTest
    public static void testHttpUtility(){
        Test.setMock(HttpCalloutMock.class, new DOL_MockHttpResponse());
    	Map<String,String> headerMap = new  Map<String,String>();
        Map<String,String> paramMap = new  Map<String,String>();
        String reqBody = DOL_AppConstants.NULL_EMPTY_STRING+'this is test';
        headerMap.put('Content-Type','application/json');
        paramMap.put('t1','t2');
        String url = DOL_AppConstants.NULL_EMPTY_STRING+'callout:DOL_Mule_API/v1/dorUpload';
        HttpResponse httpResp;
        
        httpResp = DOL_HTTP_Utility.doHttpRequest(url,
        						'POST',
                             	reqBody,
                                paramMap,headerMap);
        
        DOL_HTTP_Utility.HttpApiHeader httpHeader = new DOL_HTTP_Utility.HttpApiHeader('Content-Type','application/json');
        DOL_HTTP_Utility.HttpUrlParam urlParam = new DOL_HTTP_Utility.HttpUrlParam();
        urlParam.key = DOL_AppConstants.NULL_EMPTY_STRING+'t1';
        urlParam.value = DOL_AppConstants.NULL_EMPTY_STRING+'t2';
        List<DOL_HTTP_Utility.HttpApiHeader> headerLst = new List<DOL_HTTP_Utility.HttpApiHeader>();
        List<DOL_HTTP_Utility.HttpUrlParam> paramLst = new List<DOL_HTTP_Utility.HttpUrlParam>();
        headerLst.add(httpHeader);
        paramLst.add(urlParam);
        
        httpResp = DOL_HTTP_Utility.doHttpRequest(url, 
                                                  DOL_AppConstants.NULL_EMPTY_STRING+'POST', 
                                                  DOL_AppConstants.NULL_EMPTY_STRING+'this is test',
                                                  JSON.serialize(paramLst), 
                                                  JSON.serialize(headerLst));
        
    }
    
    
    public static void testMethod2(){
        Test.setMock(HttpCalloutMock.class, new DOL_MockHttpResponse());
        String url = DOL_AppConstants.NULL_EMPTY_STRING+'callout:DOL_Mule_API/v1/dorUpload';
        HttpResponse httpResp;
        DOL_HTTP_Utility.HttpApiHeader httpHeader = new DOL_HTTP_Utility.HttpApiHeader('Content-Type','application/json');
        DOL_HTTP_Utility.HttpUrlParam urlParam = new DOL_HTTP_Utility.HttpUrlParam();
        urlParam.key = DOL_AppConstants.NULL_EMPTY_STRING+'t1';
        urlParam.value = DOL_AppConstants.NULL_EMPTY_STRING+'t2';
        List<DOL_HTTP_Utility.HttpApiHeader> headerLst = new List<DOL_HTTP_Utility.HttpApiHeader>();
        List<DOL_HTTP_Utility.HttpUrlParam> paramLst = new List<DOL_HTTP_Utility.HttpUrlParam>();
        headerLst.add(httpHeader);
        paramLst.add(urlParam);
        
        httpResp = DOL_HTTP_Utility.doHttpRequest(url, 
                                                  DOL_AppConstants.NULL_EMPTY_STRING+'POST', 
                                                  DOL_AppConstants.NULL_EMPTY_STRING+'this is test',
                                                  JSON.serialize(paramLst), 
                                                  JSON.serialize(headerLst));
    }
}