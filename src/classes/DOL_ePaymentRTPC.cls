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
        DOL_Dao dolDao = new DOL_Dao();
        try{
            DOL_ePaymentRTPCPOJO ePaymentRTPCData = DOL_ePaymentRTPCPOJO.parse(json);
            // get the parameters.
            List<DOL_ePaymentRTPCPOJO.Parameter> parameterList = ePaymentRTPCData.Parameter;
            MUSW__Receipt__c receipt = null;
            for(DOL_ePaymentRTPCPOJO.Parameter parameter : parameterList ){
                if(parameter.ParameterName == 'SFDClicId'){
                    receipt = new MUSW__Receipt__c(id = parameter.ParameterValue);
                    break;
                }
            }
            if(receipt == null){
                receipt = dolDao.getReceiptByTransactionId(ePaymentRTPCData.ConfirmationId);
            }
            
            // If receipt is still null , cannot move forward with RTPC call
            if(receipt != null){
                updateReceiptFromRTPCPojo(ePaymentRTPCData,receipt);
                DOL_Dao.save(receipt);
                response.addLog('receipt updated successfully');
                response.addLog('success');
            }
            else{
                response.addLog('receiptId is not found, so cannot move forward');
                response.addLog('RTPC call unsucessfull');
            }
            response.setStatusCode(200);
        }
        catch(Exception error){
            response.addErrorMsg('message :- '+error.getMessage());
            response.addErrorMsg('StackTrace :- '+error.getStackTraceString());
            response.setStatusCode(400);
        }
        return response;
    }

    private static void updateReceiptFromRTPCPojo(DOL_ePaymentRTPCPOJO rtpcData, MUSW__Receipt__c receipt){
        if(isNotNullOrBlank(rtpcData.ConfirmationId))
            receipt.MUSW__Payment_Gateway_Transaction_Number__c = rtpcData.ConfirmationId;
        if(isNotNullOrBlank(rtpcData.PaymentMethod)){
            receipt.MUSW__Payment_Method__c = rtpcData.PaymentMethod;
            if(receipt.MUSW__Payment_Method__c == 'CC')
                receipt.MUSW__Payment_Method__c = 'Credit Card';
        }
        if(isNotNullOrBlank(rtpcData.PaymentAmount))
            receipt.MUSW__Amount_Tendered__c = Decimal.valueOf(rtpcData.PaymentAmount);
        if(isNotNullOrBlank(rtpcData.PaymentEffectiveDate))
            receipt.MUSW__Effective_Date__c = Date.valueOf(rtpcData.PaymentEffectiveDate);
        if(isNotNullOrBlank(rtpcData.DueDate))
            receipt.Date__c = Date.valueOf(rtpcData.DueDate);
        if(isNotNullOrBlank(rtpcData.PayerFirstName))
            receipt.Payer_First_Name__c = rtpcData.PayerFirstName;
        if(isNotNullOrBlank(rtpcData.PayerLastName))
            receipt.Payer_Last_Name__c = rtpcData.PayerLastName;
        if(isNotNullOrBlank(rtpcData.LastFourAccountNumber))
            receipt.Last_4_digits_of_Credit_Card_or_ACH__c = Decimal.valueOf(rtpcData.LastFourAccountNumber);

    }

    private static boolean isNotNullOrBlank(String input){
        if(input != null && input != '')
            return true;
        return false;
    }

}