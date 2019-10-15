@isTest
public class DOL_ePaymentSessionTransfer_Test {
	
    @isTest
    public static void test(){
        Id accRecId = SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_Account').getRecordTypeId();
        Account acc = DOL_TestDataFactory.createAccount(accRecId);
        
        Id conRecId = SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Contact').getRecordTypeId();
        Contact c = DOL_TestDataFactory.createContact(conRecId, acc.Id);
        List<String>  ids = new List<String>();
        ids.add('0000001');
        ids.add('0000002');
        ids.add('000003');
        
        DOL_ePaymentSessionTransferDetails detail = new DOL_ePaymentSessionTransferDetails(
        											'product Code',
        											'567','CC',c.id,'56666tyyy',ids,true);
        
        String encryptedString = DOL_ePaymentSessionTransfer.getEncryptedSessionString(detail);
        DOL_ePaymentSessionTransfer.decryptSessionData(encryptedString);
    }
}