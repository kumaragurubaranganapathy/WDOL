/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class PaymentGatewayService {
    global BGBK__CartSettings__c cs;
    global String depositFields;
    global String feeFields;
    global BGBK.PaymentGatewayService.RequestProperties formProperties;
    global Map<String,String> gatewayResponses;
    global String invoiceFields;
    global PaymentGatewayService() {

    }
    global abstract Map<String,String> afterTransactionProcessing(Map<String,List<SObject>> param0, BGBK.PaymentTransactionInfo param1);
    global virtual Boolean authenticate(Id accountId) {
        return null;
    }
    global List<BGBK.Payable> getDecryptedPayables(String encryptedPayableStr) {
        return null;
    }
    global String getEncryptedPayables(List<BGBK.Payable> payables) {
        return null;
    }
    global virtual Map<String,String> getGatewayCredentials() {
        return null;
    }
    global BGBK.PaymentGatewayService.RequestProperties getGatewayRequestFields(List<BGBK.Payable> payables, MUSW__Receipt__c receipt, BGBK__Cart__c cart, Account account, Contact contact, Map<String,String> miscellaneous) {
        return null;
    }
    global virtual Map<String,String> getGatewayResponseList() {
        return null;
    }
    global virtual Map<String,String> initializeGateway(Map<String,Object> prerequisites) {
        return null;
    }
    global abstract BGBK.PaymentTransactionInfo paymentGatewayResponseHandler(System.PageReference param0);
    global abstract Map<String,String> populateGatewayPaymentFormData(List<BGBK.Payable> param0, MUSW__Receipt__c param1, BGBK__Cart__c param2, Account param3, Contact param4, Map<String,String> param5);
    global abstract Map<String,String> populateGatewaySpecificFormData(Map<String,String> param0);
global class RequestProperties {
    global String formPostUrl {
        get;
        set;
    }
    global Map<String,String> gatewayFields {
        get;
        set;
    }
    global Map<String,String> paymentFields {
        get;
        set;
    }
    global RequestProperties() {

    }
}
}
