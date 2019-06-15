@isTest
global class CleanAddress_MockService implements HttpCalloutMock {
    
	global HTTPResponse respond(HTTPRequest req) {
        String body = '{"RecordID": "0","AddressLine1": "1001 International Pkwy","Address": "1001 International Pkwy","Suite": "100",' + 
            			'"City": "Lake Mary","State": "Florida","PostalCode": "32746","PostalCodeFull": "32746","Province": "Florida","CountyName": "Seminole",' + 
            			'"TimezoneCode": "5","TimezoneString": "Eastern Time","Latitude": "28.7598","Longitude": "-81.3479"}';
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
    	res.setBody(body);
        res.setStatusCode(200);
        return res;
    }
    
}