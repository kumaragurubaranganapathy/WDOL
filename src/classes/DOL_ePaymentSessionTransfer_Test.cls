@isTest
public class DOL_ePaymentSessionTransfer_Test {
	private static String contactId;
    @testSetUp
    private static void testSetUp(){
        Contact con = new Contact(lastName='sdfzDF');
        insert con;
        contactId = con.id;
    }
    @isTest
    public static void test(){
        List<String> strList = new List<String>();
        strList.add('sdfdf');
        strList.add('sfsdf');
        DOL_ePaymentSessionTransferDetails ePaymentSessionTransfer = new DOL_ePaymentSessionTransferDetails('productCode','234','CC',contactId,contactId,strList,true);
        DOL_ePaymentSessionTransfer.getEncryptedSessionString(ePaymentSessionTransfer);
        
    }
}