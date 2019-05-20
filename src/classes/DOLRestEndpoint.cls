/************************************************************************************************************
** Name             : DOLRestEndpoint
** Description   	: DOLRestEndpoint act as an entry point to the application and divert the request with json to respective APEX
                      class based on the input of header REQUESTTYPE.
** Version          : 1.0
**-------------------------------------
** Revision History:
**---------------------------
** [Laltu Banerjee]: Created
*************************************************************************************************************/

@RestResource(urlMapping='/DOLRestEndpoint')
global class DOLRestEndpoint {

    @HttpPost
    global static DOL_RestResponse postRequest(){
        system.debug('Inside DOLRestEndpoint postRequest');
        RestRequest req = RestContext.request;
        DOL_RestResponse resp = new DOL_RestResponse();
        //RestResponse resp = RestContext.response;
        String jsonBody;
        String requestType;
        try{
            jsonBody = req.requestBody.toString();
            system.debug('body '+jsonBody);
            requestType = req.headers.get('REQUESTTYPE');
            system.debug('requestType '+requestType);
            HTTPRestResponse output = processRequest(jsonBody,requestType);
            //resp.log = 'Logs :- '+output.getLogs()+' error :- '+output.geterrorMsgs();
            //resp.statusCode = ''+output.getStatusCode();
            resp.statusCode = ''+output.getStatusCode();
            resp.log = 'Logs :- '+output.getLogs()+' error :- '+output.geterrorMsgs();
        }catch(Exception error){
            resp.statusCode = '400';
            resp.log = 'error occured :- '+error.getMessage()+' stack trace '+error.getStackTraceString();
        }
        return resp;
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
    
    global class DOL_RestResponse{
        String log {get; set;}
        String statusCode {get; set;}
    }
}