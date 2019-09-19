@isTest
public class DOL_Dao_Test {
	
    @isTest
    public static void test(){
        DOL_Dao dao = new DOL_Dao();
        Contact con = TestUtility.getContact();
        insert con;
        
        
        MUSW__Receipt__c receipt = new MUSW__Receipt__c();
        receipt.Bank_Name__c = 'DOL Bank';
        receipt.MUSW__Payment_Gateway_Transaction_Number__c = '000000ABCD';
        insert receipt;
        
        MUSW__Fee__c fees = new MUSW__Fee__c();
        fees.Account_Number__c = '123456UYTR';
        fees.AFRS_AR_Code__c = '8989898';
        insert fees;
        
        List<String> ids = new List<String>();
        ids.add(fees.Id);
        
        List<MUSW__Fee__c> sObjectList = new List<MUSW__Fee__c>();
        sObjectList.add(fees);
        
        dao.getContactDetailsForSessionTransfer(con.Id);
        dao.getReceiptForCartPage(receipt.Id);
        dao.getReceiptByTransactionId(receipt.MUSW__Payment_Gateway_Transaction_Number__c);
        dao.getReceiptByTransactionId('test');
        dao.getFeeAndFeePayment(ids);
        
        Dol_Dao.save(fees);
        Dol_Dao.save(sObjectList);
    }
}