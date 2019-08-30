/************************************************************************************************************
** Name             : DOL_ePaymentReturnSession
** Description   	: Return session from ePayment passed here to reterive the details.
** Version          : 1.0
**-------------------------------------
** Revision History:
**---------------------------
** [Laltu Banerjee]: Created
*************************************************************************************************************/
public class DOL_ePaymentReturnSession {
	
    public String ReturnValue ; // getting receiptId in Return Value
    public String TransactionConfirmationID ;
    public String UserID ;
    public String BillerProductCode ;
    public String PaymentMethod ;
    public String ConvenienceFee ;
    public String PaymentAmount ;
    public String PaymentEffectiveDate ; // Effective Date YYYYMMDD
    public String AmountDue ;
    public String TransactionMode ;
    public String ReplacesConfirmationId ;
    public String InitiationDateTime ; // Intiation datetime YYYYMMDD:HHMMSS
    public String CreditCardNumber ; // Last 4 digit in case of CC
    public String CreditCardType ; // Card type
    public String CreditCardExpDate ;
    public String AccountNumber ; // In case of ACH
    public String ProductDescription ;
    public String BillerBusinessDate ;
    public String IsPayorRegistered ;
    public String Email ;
    public String SFDCId ; // Cart Id
    public String SFDCfeeId ; // DOL_AppConstants.ePaymentUrlListValuesSeperator seperated feeId
    public String SFDCappId ; // Contact Id
    public String SFDClicId ; // This is receipt Id
    public List<String> sfdcFeeIds ;

    public DOL_ePaymentReturnSession(){}
    
    
    public void mapDataFromSessionString(String sessionString){
        List<String> sessionDataList = sessionString.split('&');
        system.debug(''+sessionDataList.size());
        Map<String,String> sessionDataMap = new Map<String,String>();
        String[] tempArr;
        for(String input : sessionDataList){
            tempArr = input.split('=');
            if(tempArr.size() > 1)
                sessionDataMap.put(tempArr[0],tempArr[1]);
        }
        
        ReturnValue = sessionDataMap.get('ReturnValue');
        TransactionConfirmationID = sessionDataMap.get('TransactionConfirmationID');
        UserID = sessionDataMap.get('UserID');
		BillerProductCode = sessionDataMap.get('BillerProductCode');
		PaymentMethod = sessionDataMap.get('PaymentMethod');
		PaymentAmount = sessionDataMap.get('PaymentAmount');
		ConvenienceFee = sessionDataMap.get('ConvenienceFee');
		PaymentEffectiveDate = sessionDataMap.get('PaymentEffectiveDate');
		AmountDue = sessionDataMap.get('AmountDue');
		TransactionMode = sessionDataMap.get('TransactionMode');
		ReplacesConfirmationId = sessionDataMap.get('ReplacesConfirmationId');
		InitiationDateTime = sessionDataMap.get('InitiationDateTime');
		CreditCardNumber = sessionDataMap.get('CreditCardNumber');
		CreditCardType = sessionDataMap.get('CreditCardType');
		CreditCardExpDate = sessionDataMap.get('CreditCardExpDate');
		AccountNumber = sessionDataMap.get('AccountNumber');
		ProductDescription = sessionDataMap.get('ProductDescription');
		BillerBusinessDate = sessionDataMap.get('BillerBusinessDate');
		IsPayorRegistered = sessionDataMap.get('IsPayorRegistered');
		Email = sessionDataMap.get('Email');
		SFDCId = sessionDataMap.get('SFDCId');
		SFDCfeeId = sessionDataMap.get('SFDCfeeId'); // not using as this one giving partial Info
		SFDCappId = sessionDataMap.get('SFDCappId');
		SFDClicId = sessionDataMap.get('SFDClicId');
        sfdcFeeIds = getSelectedFees();
        system.debug('return value '+ReturnValue);     
    }

    public void updateReceipt(MUSW__Receipt__c receipt) {
        if(! String.isBlank(TransactionConfirmationID)){
            receipt.MUSW__Payment_Gateway_Transaction_Number__c = TransactionConfirmationID;
            receipt.Transaction_Confirmation_ID__c = TransactionConfirmationID;
        }
        if(! String.isBlank(PaymentEffectiveDate))
            receipt.MUSW__Effective_Date__c = DOL_AppUtility.getDate(PaymentEffectiveDate , 'YYYYMMDD');
        if(! String.isBlank(InitiationDateTime))
            receipt.Initiation_Date_and_Time__c = DOL_AppUtility.getDateTime(InitiationDateTime, 'YYYYMMDD***HHmmSS'); // *** some random value is coming
        if(PaymentMethod.equals('ACH')){
            if((!String.isBlank(AccountNumber)) && DOL_AppUtility.isValidDecimalValue(AccountNumber.right(4) ) )
                receipt.Last_4_digits_of_Credit_Card_or_ACH__c = Decimal.valueOf(AccountNumber.right(4) );
        }
        else{
            if((! String.isBlank(CreditCardNumber)) && DOL_AppUtility.isValidDecimalValue(CreditCardNumber.right(4)) )
                receipt.Last_4_digits_of_Credit_Card_or_ACH__c = Decimal.valueOf(CreditCardNumber.right(4));
            if( ! String.isBlank(CreditCardType) )
                receipt.MUSW__Card_Type__c = CreditCardType;
        }
    }

    private List<String> getSelectedFees(){
        MUSW__Receipt__c receipt = [select Id,Selected_Fees__c from MUSW__Receipt__c where Id =: SFDClicId];
        return receipt.Selected_Fees__c.split(',');
    }

    public void validateSessionData(){
        if(String.isBlank(TransactionConfirmationID)){
            throw new CustomException('Transaction Id is Blank in ePayment return session');
        }
        if(String.isBlank(this.SFDClicId)){
            throw new CustomException('Receipt Id is Blank in ePayment return session');
        }
    }

}