/************************************************************************************************************
** Name             : DOLRestEndpoint
** Description   	: DOLRestEndpoint act as an entry point to the application and divert the request with json to respective APEX
                      class based on the input of header REQUESTTYPE.
** Version          : 1.0
**-------------------------------------------------------------------------------------------------------------------------------
** Revision History:
**---------------------------
** [Laltu Banerjee]: Created
*************************************************************************************************************/

@RestResource(urlMapping='/DOLRestEndpoint')
global class DOLRestEndpoint {

    @HttpPost
    global static void postRequest(){
        RestRequest req = RestContext.request;
        RestResponse resp = RestContext.response;
        String jsonBody;
        String requestType;
        try{
            jsonBody = req.requestBody.toString();
            requestType = req.headers.get('REQUESTTYPE');
            HTTPRestResponse output = processRequest(jsonBody,requestType);
            resp.statusCode = output.getStatusCode();
            resp.responseBody = Blob.valueOf('Logs :- '+output.getLogs()+' error :- '+output.geterrorMsgs());
        }catch(Exception error){
            resp.statusCode = 400;
            resp.responseBody = Blob.valueOf('error occured :- '+error.getMessage()+' stack trace '+error.getStackTraceString());
        }
    }

    private static HTTPRestResponse processRequest(String jsonBody, String requestType){
        HTTPRestResponse output = null;
        if(requestType == 'EPAYMENT_RTPC_CALL'){
            output = DOL_ePaymentRTPC.processEpaymentRTPCRequest(jsonBody);
        }
        if(output == null){
            output = HTTPRestResponse.getInstance();
            output.addErrorMsg('Request Type Header value is not valid');
            output.setStatusCode(400);
        }
        return output;
    }
}