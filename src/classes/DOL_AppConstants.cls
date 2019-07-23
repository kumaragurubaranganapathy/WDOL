public class DOL_AppConstants {

    public static final String ePaymentEncryptionKeyLabel = 'ePayment Encryption Key';
    public static final String ePaymentEncryptionIVLabel = 'ePayment Encryption Init Vector';
    public static final String ePaymentEncryptionAlgoLabel = 'ePayment Encryption Algo Name';
    public static final String ePaymentReturnUrlPortalUser = 'ePayment Return Url Portal User';
    public static final String ePaymentReturnUrlNonPortalUser = 'ePayment Return Url Non Portal User';
    public static final String ePaymentSessionValuesSeperator = '|';
    public static final String ePaymentUrlListValuesSeperator = 'SEPARATOR';
	public static final List<String> PORTAL_PROFILES = new List<String>{'eSLA Customer Community Plus Login User','eSLA Customer Community Login User'};

    public static Map<String,String> integrationSettingsMetadataMap = new Map<String,String>();
    static{
        for(Dol_Integration_Settings__mdt metadata : [select label,Value__c from Dol_Integration_Settings__mdt]){
            integrationSettingsMetadataMap.put(metadata.label,metadata.Value__c);
        }
    }
    
}