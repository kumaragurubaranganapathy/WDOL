@IsTest
global class DOL_MockHttpResponse implements HttpCalloutMock,WebServiceMock{
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"example":"test"}');
        res.setStatusCode(200);
        return res;
    }
    global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
       melissadataaddresscheckservice.doAddressCheckResponse_element respElement = 
           new melissadataaddresscheckservice.doAddressCheckResponse_element();
       //respElement.mdwebserviceaddress.ResponseArray = 'Mock response';
       response.put('response_x', respElement); 
   }
}