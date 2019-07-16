global class Dol_RestAPIservice { 

    global static HttpResponse callSOSservice(String ubi) {
    
    HttpResponse res = new HttpResponse();
        try{
            HttpRequest req = new HttpRequest();
            String url = 'https://dol-polaris-exp-dev.us-e2.cloudhub.io/api/v1/sosUbi?ubi='+ubi+'&format=json&version=2&callback=?';
            req.setEndpoint(url);
            req.setMethod('GET');
            Http http = new Http();

            if(!Test.isRunningTest()) {
                //hardcoding the  response.
                res = http.send(req);
                system.debug('res**'+res);
                system.debug('res=='+res.getBody());
                // res.setBody(Dol_SOSResponse_Test.mockSOSserviceResponse);
                // res.setStatusCode(200);
            }else {
                res.setBody(Dol_SOSResponse_Test.mockSOSserviceResponse);
                res.setStatusCode(200);
            }
        } catch (Exception e){
            System.debug('exception occoured'+e.getMessage()+e.getStackTraceString());
            DebugErrorLoggger.LogError(e, '', '','callSOSservice','callSOSservice','callSOSservice Method failed');
        }
        return res;
    }
    @Future(callout=true)
    global static void callASCservice(String ssn , Id contactId) {   
    HttpResponse res = new HttpResponse();
    
        try{
            HttpRequest req = new HttpRequest();
            //https://dol-polaris-exp-dev.us-e2.cloudhub.io/api/v1/ssnUID?ssn=2341
            req.setEndpoint('https://dol-polaris-exp-dev.us-e2.cloudhub.io/api/v1/ssnUID?ssn='+ssn);
            req.setMethod('GET');
            Http http = new Http();

            if(!Test.isRunningTest()) {
                //hardcoding the  response.
                res = http.send(req);
            }else {
                res.setBody(Dol_ASCResponse_Test.mockSOSserviceResponse);
                res.setStatusCode(200);
            }
            if (res.getStatusCode() == 200) {
                Dol_ASCResponse response = (Dol_ASCResponse)JSON.deserialize(res.getBody(), Dol_ASCResponse.class);
                System.debug('response'+response);
                Contact con = new Contact(id = contactId );
                con.UID__c = response.DolResponse.uid !=  null ? response.DolResponse.uid : '';
                update con;
                System.debug('updatedConatct'+con);
            }    
        } catch (Exception e){
            System.debug('exception occoured'+e.getMessage()+e.getStackTraceString());
            DebugErrorLoggger.LogError(e, '', '','callASCservice','callASCservice','callASCservice Method failed');
        }
    }
    
}