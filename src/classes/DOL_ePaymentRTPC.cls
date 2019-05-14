/************************************************************************************************************
** Name             : DOL_ePaymentRTPC
** Description   	: Process Real Time Payment Conformation request from ePayment 
** Version          : 1.0
**-------------------------------------------------------------------------------------------------------------------------------
** Revision History:
**---------------------------
** [Laltu Banerjee]: Created
*************************************************************************************************************/
public class DOL_ePaymentRTPC {

    public static HTTPRestResponse processEpaymentRTPCRequest(String json){
        HTTPRestResponse response = HTTPRestResponse.getInstance();
        try{
            DOL_ePaymentRTPCPOJO ePaymentRTPCData = DOL_ePaymentRTPCPOJO.parse(json);
            response.addLog('json Input'+json);
            response.addLog('Inside processEpaymentRTPCRequest');
            response.setStatusCode(200);
        }
        catch(Exception error){
            response.addErrorMsg('message :- '+error.getMessage());
            response.addErrorMsg('StackTrace :- '+error.getStackTraceString());
            response.setStatusCode(400);
        }
        return response;
    }

}