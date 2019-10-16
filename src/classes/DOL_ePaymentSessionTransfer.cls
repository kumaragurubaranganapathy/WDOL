/**
* User Story        : ****
* Class Name        : DOL_ePaymentSessionTransfer
* Test Class Name   : DOL_ePaymentSessionTransfer_Test
* Description       : Helper class to create the session string and convert it into encrypted String or Decrypted string.
* Date:        Developer/Company                    Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 06/23/2019   Laltu Banerjee/Deloitte           Initial Creation
**/
public class DOL_ePaymentSessionTransfer {
	private static final Map<String,String> integrationMetadataMap = DOL_AppConstants.integrationSettingsMetadataMap;
    
    /**
    ** Name 			: getEncryptedSessionString
    ** Input			: sessionTransferDetails 
    ** Functionality	: create the session string and then encrypt it.
    ** Return			: encrypted string
    ** Author			: Laltu Banerjee
    ** Note             : called from CartController -> redirectToPaymentGateway
    ** Date (MM/DD/YYYY): 06/23/2019 
    */
    public static String getEncryptedSessionString(DOL_ePaymentSessionTransferDetails sessionTransferDetails ){
        if(sessionTransferDetails != null){
            // setting contact details
            sessionTransferDetails.setContactDetails();
            // get the Map of requiredParam and Value
            Map<String,String> sessionDetailsMap = sessionTransferDetails.getSessionDetailsMap();
            // creation of session String
            String sessionDetailForEncryption = '';
            for(String key : sessionDetailsMap.keySet()){
                sessionDetailForEncryption += key+'='+sessionDetailsMap.get(key)+DOL_AppConstants.ePaymentSessionValuesSeperator;
            }
            //System.debug('sessionDetailForEncryption = '+sessionDetailForEncryption);
            // conversion of session string into encrypted string
            String encryptedSessionDetailString = CryptoUtility.getEncryptedString('AES256', 
                                                  	integrationMetadataMap.get(DOL_AppConstants.ePaymentEncryptionKeyLabel), 
                                                    integrationMetadataMap.get(DOL_AppConstants.ePaymentEncryptionIVLabel), 
                                                    sessionDetailForEncryption);
            return encryptedSessionDetailString;
        }
        return null;
    }
    
    /**
    ** Name 			: decryptSessionData
    ** Input			: encryptedSessionData 
    ** Functionality	: Decrypt the input with the help of class CryptoUtility
    ** Return			: Decrypted String
    ** Author			: Laltu Banerjee
    ** Note             : called from CartController -> constructor
    ** Date (MM/DD/YYYY): 06/23/2019 
    */
    public static String decryptSessionData(String encryptedSessionData){
        String decryptedSessionData = CryptoUtility.getDecryptedString('AES256', 
                                                    integrationMetadataMap.get(DOL_AppConstants.ePaymentEncryptionKeyLabel), 
                                                    integrationMetadataMap.get(DOL_AppConstants.ePaymentEncryptionIVLabel), 
                                                    encryptedSessionData);
        return decryptedSessionData;
    }
    
}