@isTest
public class DOLRestEndpoint_Test {
	
    @isTest
    public static void test(){
        
        DOL_ePaymentRTPCPOJO pojo = new DOL_ePaymentRTPCPOJO();
		pojo.AmountDue = '789';
        pojo.BillerProductCode = '123REW';
        pojo.CardType = 'VISA';
        
        RestRequest req = new RestRequest();
        RestResponse resp = new RestResponse();

        req.httpMethod = DOL_AppConstants.NULL_EMPTY_STRING + 'POST';
        req.addHeader('content-type', 'application/json');
        req.requestURI = DOL_AppConstants.NULL_EMPTY_STRING + '/services/apexrest/DOLRestEndpoint';
        req.requestBody = Blob.valueOf(JSON.serialize(pojo)); 
        
        RestContext.response = resp;
        
        req.addHeader('request-type','EPAYMENT_RTPC_CALL');
        RestContext.request = req;
        DOLRestEndpoint.postRequest();
        
        req.addHeader('request-type','EPAYMENT_REMITTANCE_CALL');
        RestContext.request = req;
        DOLRestEndpoint.postRequest();
        
        req.addHeader('request-type','');
        RestContext.request = req;
        DOLRestEndpoint.postRequest();
        
        // for exception
        req.requestBody = null;
        req.addHeader('request-type','');
        RestContext.request = req;
        DOLRestEndpoint.postRequest();
    }
}