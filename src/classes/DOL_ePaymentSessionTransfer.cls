public class DOL_ePaymentSessionTransfer {
	private static final Map<String,String> integrationMetadataMap = DOL_AppConstants.integrationSettingsMetadataMap;
    
    public static String getEncryptedSessionString(DOL_ePaymentSessionTransferDetails sessionTransferDetails ){
        if(sessionTransferDetails != null){
            sessionTransferDetails.setContactDetails();
            Map<String,String> sessionDetailsMap = sessionTransferDetails.getSessionDetailsMap();
            String sessionDetailForEncryption = DOL_AppConstants.NULL_EMPTY_STRING;
            for(String key : sessionDetailsMap.keySet()){
                sessionDetailForEncryption += key+'='+sessionDetailsMap.get(key)+DOL_AppConstants.ePaymentSessionValuesSeperator;
            }
            system.debug('session Details for encrypt ' +sessionDetailForEncryption );
            String encryptedSessionDetailString = CryptoUtility.getEncryptedString('AES256', 
                                                  	integrationMetadataMap.get(DOL_AppConstants.ePaymentEncryptionKeyLabel), 
                                                    integrationMetadataMap.get(DOL_AppConstants.ePaymentEncryptionIVLabel), 
                                                    sessionDetailForEncryption);
            system.debug('encrypted session details :- '+encryptedSessionDetailString);
            return encryptedSessionDetailString;
        }
        return null;
    }
    
    public static String decryptSessionData(String encryptedSessionData){
        String decryptedSessionData = CryptoUtility.getDecryptedString('AES256', 
                                                    integrationMetadataMap.get(DOL_AppConstants.ePaymentEncryptionKeyLabel), 
                                                    integrationMetadataMap.get(DOL_AppConstants.ePaymentEncryptionIVLabel), 
                                                    encryptedSessionData);
        return decryptedSessionData;
    }
    
}