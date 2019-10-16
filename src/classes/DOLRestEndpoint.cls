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
    /**
    ** Name 			: postRequest
    ** Input			: retrive from requestBody
    ** Functionality	: retrive the requestBody and requestType and pass it to processRequest()
    ** Return			: DOL_RestResponse
    ** Author			: Laltu Banerjee
    ** Note             : 
    */
    @HttpPost
    global static DOL_RestResponse postRequest(){
        //System.debug('Inside DOLRestEndpoint postRequest');
        RestRequest req = RestContext.request;
        DOL_RestResponse resp = new DOL_RestResponse();
        String jsonBody;
        String requestType;
        try{
            jsonBody = req.requestBody.toString();
            requestType = req.headers.get('request-type');
            String info = ' requestType = '+requestType+' body = '+jsonBody;
            HTTPRestResponse output = processRequest(jsonBody,requestType);
            resp.setResponse(output);
        }catch(Exception error){
            Id errorLogId = DOL_CreateErrorLog_Exception.logApplicationError(error);
            resp.statusCode = '400';
            resp.log = 'error occured :- '+error.getMessage()+
                        ' stack trace '+error.getStackTraceString()+
                        ' error log created = '+errorLogId;
            resp.status = 'failed';
            
        }
        RestContext.response.statusCode = Integer.valueOf(resp.statusCode);
        return resp;
    }

    /**
    ** Name 			: processRequest
    ** Input			: jsonBody :- requestBody, requestType :- header value
    ** Functionality	: call DOL_SaveDataForIntegrationBatch with body and Input type
                            based on requestType, if requestType not matches with any throw Exception
    ** Return			: HTTPRestResponse
    ** Author			: Laltu Banerjee
    ** Note             : This method called from DOLRestEndpoint -> postRequest()
    */
    private static HTTPRestResponse processRequest(String jsonBody, String requestType){
        HTTPRestResponse output = null;
        if(requestType == 'EPAYMENT_RTPC_CALL'){
            output = new DOL_SaveDataForIntegrationBatch().saveDataForIntegrationBatch(jsonBody,'RTPC');
        }
        else if(requestType == 'EPAYMENT_REMITTANCE_CALL'){
            output = new DOL_SaveDataForIntegrationBatch().saveDataForIntegrationBatch(jsonBody,'REMITTANCE');
        }
        else if(requestType == 'NCR_FILE_DATA'){
            output = new DOL_SaveDataForIntegrationBatch().saveDataForIntegrationBatch(jsonBody,'NCR');
        }
        else if(requestType == 'DOR'){
            output = new DOL_SaveDataForIntegrationBatch().saveDataForIntegrationBatch(jsonBody,'DOR');
        }
        else{
            throw new CustomException('Request type header value is not valid');
        }
        return output;
    }
    
    /**
    ** Name         : DOL_RestResponse
    ** Description  : To wrap the outgoing HTTP response
     */
    global class DOL_RestResponse{
        String log;
        String statusCode;
        String status;
        
        /**
        ** set the response from HTTPRestResponse
         */
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