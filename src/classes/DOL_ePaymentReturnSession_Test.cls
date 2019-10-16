@isTest
public class DOL_ePaymentReturnSession_Test {
	@isTest
    public static void test(){
       	
        MUSW__Receipt__c receipt = new MUSW__Receipt__c();
        receipt.Bank_Name__c = DOL_AppConstants.NULL_EMPTY_STRING + 'DOL Bank';
        receipt.MUSW__Payment_Gateway_Transaction_Number__c = DOL_AppConstants.NULL_EMPTY_STRING + '000000ABCD';
        receipt.Selected_Fees__c = DOL_AppConstants.NULL_EMPTY_STRING + 'abcd,trfge';
        insert receipt;
        
        DOL_ePaymentReturnSession returnSession = new DOL_ePaymentReturnSession();
        String returnSessionString = DOL_AppConstants.NULL_EMPTY_STRING + 'TransactionConfirmationID=000000ABCD&SFDClicId='+receipt.Id+'&PaymentEffectiveDate=20190923&InitiationDateTime=20190923***060215&PaymentMethod=ACH&AccountNumber=7654&CreditCardNumber=545498765';
        returnSession.mapDataFromSessionString(returnSessionString);
        returnSession.validateSessionData();
        returnSession.updateReceipt(receipt);
        
        //to cover negative and other scnerio
        returnSession.PaymentMethod = 'other';
        returnSession.CreditCardType = 'Master';
        returnSession.updateReceipt(receipt);
        
        
        try{
            returnSession.TransactionConfirmationID = '';
            returnSession.validateSessionData();
        }catch(Exception e){
            
        }
        
        try{
            returnSession.TransactionConfirmationID = DOL_AppConstants.NULL_EMPTY_STRING+'1111';
            returnSession.SFDClicId = '';
            returnSession.validateSessionData();
        }catch(Exception e){ }
        
    }
}