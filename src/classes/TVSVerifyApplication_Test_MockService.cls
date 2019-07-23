@isTest
global class TVSVerifyApplication_Test_MockService implements HttpCalloutMock {
    
	global HTTPResponse respond(HTTPRequest req) {
        System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
    	res.setBody('{"Id": "1234567","ApplicantId": "123456789","CustomerType": "Individual","Response": "ID","Timestamp": "2018-09-17 09:40:44.815168"}');
        res.setStatusCode(200);
        return res;
    }

}