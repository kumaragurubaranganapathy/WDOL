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
	
    public String ReturnValue {get; private set;} // getting receiptId in Return Value
    public String TransactionConfirmationID { get; private set;}
    public String UserID {get; private set;}
    public String BillerProductCode {get; private set;}
    public String PaymentMethod { get; private set; }
    public String ConvenienceFee { get; private set; }
    public String PaymentAmount { get; private set; }
    public String PaymentEffectiveDate { get; private set; } // Effective Date YYYYMMDD
    public String AmountDue { get; private set; }
    public String TransactionMode { get; private set; }
    public String ReplacesConfirmationId { get; private set; }
    public String InitiationDateTime { get; private set; } // Intiation datetime YYYYMMDD:HHMMSS
    public String CreditCardNumber { get; private set; } // Last 4 digit in case of CC
    public String CreditCardType { get; private set; } // Card type
    public String CreditCardExpDate { get; private set; } 
    public String AccountNumber { get; private set; } // In case of ACH
    public String ProductDescription { get; private set; }
    public String BillerBusinessDate { get; private set; }
    public String IsPayorRegistered { get; private set; }
    public String Email { get; private set; }
    public String SFDCId { get; private set; }
    public String SFDCfeeId { get; private set; } // DOL_AppConstants.ePaymentUrlListValuesSeperator seperated feeId
    public String SFDCappId { get; private set; }
    public String SFDClicId { get; private set; }
    
    public List<String> sfdcFeeIds {get; private set;}

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
		SFDCfeeId = sessionDataMap.get('SFDCfeeId');
		SFDCappId = sessionDataMap.get('SFDCappId');
		SFDClicId = sessionDataMap.get('SFDClicId');

        sfdcFeeIds = new List<String>();
        system.debug(' SFDCfeeId '+SFDCfeeId);
        if(SFDCfeeId != null && SFDCfeeId != ''){
            sfdcFeeIds = SFDCfeeId.split(DOL_AppConstants.ePaymentUrlListValuesSeperator);
        }
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
            receipt.Initiation_Date_and_Time__c = DOL_AppUtility.getDateTime(InitiationDateTime, 'YYYYMMDD:HHMMSS');
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
        receipt.US_Bank_Payment_Status__c = 'Processed';
    }

}