public class Dol_RestAPIservice { 

    public static HttpResponse callSOSservice(String ubi) {
    
    HttpResponse res = new HttpResponse();
        try{
            HttpRequest req = new HttpRequest();
            String url = DOL_AppConstants.DEV_POLARIS_V1_API_URL+'?ubi='+ubi+'&format=json&version=2&callback=?';
            req.setEndpoint('callout:DOL_Mule_API/v1/sosUbi?ubi='+ubi+'&format=json&version=2&callback=?');
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
    
    /* [Nibedita Swain/ July 8, 2019] 
        Convert SSN to UBI – this is now out of Release 1 as it was dependent on API.
        Workaround – Send SSN instead of UBI (This is tested and verified with ASC)
        Changes – We have to revert the code which was built for triggering this transaction from Salesforce

    @Future(callout=true)
    public static void callASCservice(String ssn , Id contactId) {   
    HttpResponse res = new HttpResponse();
    
        try{
            HttpRequest req = new HttpRequest();
            //req.setEndpoint('https://dol-polaris-exp-dev.us-e2.cloudhub.io/api/v1/ssnUID?ssn='+ssn);
            req.setEndpoint('callout:UID_and_UBI_Search/v1/ssnUID?ssn='+ssn);
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
    }*/
    public static HttpResponse BackOfficeUploadToSAN(Dol_UploadDocumenttoSAN.UploadData uploadobj) {
    
    HttpResponse res = new HttpResponse();
        try{
            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:DOL_Mule_API/v1/kofaxAdd');
            req.setMethod('POST');
            req.setHeader('content-type', 'application/json; charset=utf-8');
            String requestPayload = json.serialize(uploadobj);
            req.setBody(requestPayload);
            system.debug('req**'+req.getBody());
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
            DebugErrorLoggger.LogError(e, '', '','BackOfficeUploadToSAN','BackOfficeUploadToSAN','BackOfficeUploadToSAN Method failed');
        }
        return res;
    }
    
    public static HttpResponse BackOfficeDeleteFileURL(Dol_DeleteAttachmentFromSubmission.DeleteData deleteObj) {
    
    HttpResponse res = new HttpResponse();
        try{
            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:DOL_Mule_API/v1/kofaxDelete');
            req.setMethod('POST');
            req.setHeader('content-type', 'application/json; charset=utf-8');
            String requestPayload = json.serialize(deleteObj);
            req.setBody(requestPayload);
            system.debug('req**'+req.getBody());
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
            DebugErrorLoggger.LogError(e, '', '','BackOfficeDeleteFileURL','BackOfficeDeleteFileURL','BackOfficeDeleteFileURL Method failed');
        }
        return res;
    }
    
    public static HttpResponse portalUploadToSAN(List<Dol_UploadDocumenttoSAN.UploadData> uploadobj) {
    
    HttpResponse res = new HttpResponse();
        try{
            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:DOL_Mule_API/v1/kofaxUpload');
            req.setMethod('POST');
            req.setHeader('content-type', 'application/json; charset=utf-8');
            String requestPayload = json.serialize(uploadobj);
            req.setBody(requestPayload);
            system.debug('req**'+req.getBody());
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
            DebugErrorLoggger.LogError(e, '', '','portalUploadToSAN','portalUploadToSAN','portalUploadToSAN Method failed');
        }
        return res;
    }
    
    public static HttpResponse getTokenImage(Dol_ViewTiffFile.ImageBody imageBody) {
    
    HttpResponse res = new HttpResponse();
        try{
            HttpRequest req = new HttpRequest();
            String url = DOL_AppConstants.DEV_POLARIS_V1_API_URL_GENERATEIMAGETOKEN_URI;
            req.setEndpoint('callout:DOL_Mule_API/v1/generateImageToken');
            req.setMethod('POST');
            req.setHeader('content-type', 'application/json; charset=utf-8');
            String requestPayload = json.serialize(imageBody);
            req.setBody(requestPayload);
            Http http = new Http();

            if(!Test.isRunningTest()) {
                res = http.send(req);
                system.debug('getTokenImage response**'+res);
                system.debug('getTokenImage res=='+res.getBody());
            }else {
                res.setBody(Dol_ImageTokenResponse_Test.mockResponse);
                res.setStatusCode(200);
            }
        } catch (Exception e){
            System.debug('exception occoured'+e.getMessage()+e.getStackTraceString());
            DebugErrorLoggger.LogError(e, '', '','getTokenImage','getTokenImage','getTokenImage Method failed');
        }
        return res;
    }
}