@isTest
global class WebServiceMockImpl implements HttpCalloutMock {
   global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        return res;
    }
}