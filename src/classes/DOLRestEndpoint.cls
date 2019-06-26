/************************************************************************************************************
** Name             : DOLRestEndpoint
** Description   	: DOLRestEndpoint act as an entry point to the application and divert the request with json to respective APEX
                      class based on the input of header "request-type".
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
        String jsonBody;
        String requestType;
        try{
            jsonBody = req.requestBody.toString();
            requestType = req.headers.get('request-type');
            // log the input
            String info = ' requestType = '+requestType+' body = '+jsonBody;
            DebugErrorLoggger.dolLogger(Dol_LoggerInput.getDolLoggerForInfo(info,requestType,'DOLRestEndpoint'));
            
            HTTPRestResponse output = processRequest(jsonBody,requestType);
            resp.setResponse(output);
            //log the output
            DebugErrorLoggger.dolLogger(Dol_LoggerInput.getDolLoggerForInfo(resp.log+' status = '+resp.status,requestType,'DOLRestEndpoint'));
        }catch(Exception error){
            resp.statusCode = '400';
            resp.log = 'error occured :- '+error.getMessage()+' stack trace '+error.getStackTraceString();
            resp.status = 'failed';
            // log the error
            DebugErrorLoggger.dolLogger(Dol_LoggerInput.getDolLoggerForError(resp.log,requestType,'DOLRestEndpoint'));
        }
        return resp;
    }

    private static HTTPRestResponse processRequest(String jsonBody, String requestType){
        HTTPRestResponse output = null;
        if(requestType == 'EPAYMENT_RTPC_CALL'){
            output = new DOL_ePaymentRTPC().processEpaymentRTPCRequest(jsonBody);
        }
        if(requestType == 'EPAYMENT_REMITTANCE_CALL'){
            output = new DOL_EpaymentSaveRemittanceData().saveRemittanceData(jsonBody);
        }
        if(requestType == 'NCR_FILE_DATA'){
            output = new DOL_SaveNCRData().saveNCRData(jsonBody);
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
        String status {get; set;}
        
        public void setResponse(HTTPRestResponse intputResponse){
            this.log = 'Logs :- '+intputResponse.getLogs()+' error :- '+intputResponse.geterrorMsgs();
            this.statusCode = ''+intputResponse.getStatusCode();
            if(intputResponse.getStatusCode() == 200)
            	this.status = 'success';
        	else
            	this.status = 'failed';
        }
    }
}