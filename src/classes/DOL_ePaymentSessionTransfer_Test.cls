@isTest
public class DOL_ePaymentSessionTransfer_Test {
	
    @isTest
    public static void test(){
        Contact con = TestUtility.getContact();
        insert con;
        List<String>  ids = new List<String>();
        ids.add('0000001');
        ids.add('0000002');
        ids.add('000003');
        
        DOL_ePaymentSessionTransferDetails detail = new DOL_ePaymentSessionTransferDetails(
        											'product Code',
        											'567','CC',con.id,'56666tyyy',ids,true);
        DOL_ePaymentSessionTransferDetails detail2 = new DOL_ePaymentSessionTransferDetails(
        											'product-code','564','CC',con.Id);
        
        String encryptedString = DOL_ePaymentSessionTransfer.getEncryptedSessionString(detail);
        DOL_ePaymentSessionTransfer.decryptSessionData(encryptedString);
    }
}