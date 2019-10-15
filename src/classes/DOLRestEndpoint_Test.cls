/**
The below test class will cover
DOLRestEndpoint, DOL_SaveDataForIntegrationBatch, 
DOL_ContentVersionUtility, DOL_ProcessIntContentDoc_Batch, DOL_RTPC_Input
 */
@isTest
public class DOLRestEndpoint_Test {
	
    @isTest
    public static void test(){
       
        DOL_RTPC_Input rtpc = new DOL_RTPC_Input();
        rtpc.PaymentAmount = DOL_AppConstants.NULL_EMPTY_STRING + '345.0';
        List<DOL_RTPC_Input> rtpcLst = new List<DOL_RTPC_Input>();
        rtpcLst.add(rtpc);

        DOL_EpaymentRemittanceInput remittance = new DOL_EpaymentRemittanceInput();
        remittance.paymentAmount = DOL_AppConstants.NULL_EMPTY_STRING + '345.0';
        List<DOL_EpaymentRemittanceInput> remittanceLst = new List<DOL_EpaymentRemittanceInput>();
        remittanceLst.add(remittance);

        DOL_NCR_Input ncr = new DOL_NCR_Input();
        ncr.ValidationAmount = DOL_AppConstants.NULL_EMPTY_STRING + '567.0';
        List<DOL_NCR_Input> ncrLst = new List<DOL_NCR_Input>();
        ncrLst.add(ncr);

        DOL_DOR_Input dor = new DOL_DOR_Input();
        dor.dolProfCode = DOL_AppConstants.NULL_EMPTY_STRING + '4560';
        List<DOL_DOR_Input> dorLst = new List<DOL_DOR_Input>();
        dorLst.add(dor);
        
        RestRequest req = new RestRequest();
        RestResponse resp = new RestResponse();

        req.httpMethod = DOL_AppConstants.NULL_EMPTY_STRING + 'POST';
        req.addHeader('content-type', 'application/json');
        req.requestURI = DOL_AppConstants.NULL_EMPTY_STRING + '/services/apexrest/DOLRestEndpoint';
        //req.requestBody = Blob.valueOf(JSON.serialize(pojo)); 
        
        RestContext.response = resp;
        
        req.addHeader('request-type','EPAYMENT_RTPC_CALL');
        req.requestBody = Blob.valueOf(JSON.serialize(rtpcLst));
        RestContext.request = req;
        DOLRestEndpoint.postRequest();
        
        req.addHeader('request-type','EPAYMENT_REMITTANCE_CALL');
        req.requestBody = Blob.valueOf(JSON.serialize(remittanceLst));
        RestContext.request = req;
        DOLRestEndpoint.postRequest();

        req.addHeader('request-type','NCR_FILE_DATA');
        req.requestBody = Blob.valueOf(JSON.serialize(ncrLst));
        RestContext.request = req;
        DOLRestEndpoint.postRequest();

        req.addHeader('request-type','DOR');
        req.requestBody = Blob.valueOf(JSON.serialize(dorLst));
        RestContext.request = req;
        DOLRestEndpoint.postRequest();
        
        // for exception
        req.requestBody = null;
        req.addHeader('request-type','');
        RestContext.request = req;
        DOLRestEndpoint.postRequest();
        
    }
}