public class ePaymentResponseController {
    public String userMsg { get; private set; }
    
    public ePaymentResponseController(){
        //String message = String.valueOf(Url.getSalesforceBaseUrl().toExternalForm());
       	String encryptedSessionData = System.currentPageReference().getParameters().get('session');
        String decryptedSessionData = DOL_ePaymentSessionTransfer.decryptSessionData(encryptedSessionData);
        DOL_ePaymentReturnSession ePaymentReturnSession = new DOL_ePaymentReturnSession();
        ePaymentReturnSession.mapDataFromSessionString(decryptedSessionData);
        userMsg = ''+ePaymentReturnSession;
    }
}