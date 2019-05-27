@isTest
global class Mockgetobjectsresponse implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {        
        // Create a fake response
                 String credentialType = 'Dwelling Contractor';
        String credential = 'Dwelling Contractor';
        string applicationType=   'Trades Credential';
CreateTestDataUtility.createQuestionsForLicense( applicationType,  credentialType, credential, 'General Application');
         List<Question__c> newslist   =[Select id,External_Id_of_Parent__c  from Question__c limit 1];
         String stringnews= Json.serialize(newslist);
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
          res.setBody(stringnews);
        res.setStatusCode(200);
        return res;
    }
}