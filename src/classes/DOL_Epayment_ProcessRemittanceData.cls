global class DOL_Epayment_ProcessRemittanceData implements Database.Batchable<sObject> {
    
    private DOL_EpaymentRemittanceInput tempRemittanceInput;
    private DOL_Integration_Batch_Input__c tempRecord;
    private MUSW__Receipt__c receipt ;
    private Map<String,String> parameterMap ;
    private DOL_ProcessPayment processPayment;

    private String cartId = '',SFDCfeeIds='',SFDCappId='',receiptId = '';

    private DOL_Dao dao = new DOL_Dao();

    global DOL_Epayment_ProcessRemittanceData(){
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        System.debug('DOL_Epayment_ProcessRemittanceData::start...');
        return Database.getQueryLocator([ 
                                        select id, File_Name__c, INFO__c, Input__c, Status__c, Input_Type__c 
                                        from DOL_Integration_Batch_Input__c 
                                        where Status__c = 'UNPROCESSED' and Input_Type__c = 'REMITTANCE' 
                                        ]);
    }
    
    global void execute(Database.BatchableContext BC, List<DOL_Integration_Batch_Input__c> remittanceRecords){
        
        if(remittanceRecords != null && remittanceRecords.size() > 0){
            Boolean isRecordProcessed;
            for(DOL_Integration_Batch_Input__c record : remittanceRecords){
                tempRecord = record;
                isRecordProcessed = false;
                try{
                    tempRemittanceInput = DOL_EpaymentRemittanceInput.parse(record.Input__c);
                    receipt = null;
                    parameterMap = new Map<String,String>();
                    parameterMap.put(tempRemittanceInput.sfdcParameter1Name,tempRemittanceInput.sfdcParameter1Value);
                    parameterMap.put(tempRemittanceInput.sfdcParameter2Name,tempRemittanceInput.sfdcParameter2Value);
                    parameterMap.put(tempRemittanceInput.sfdcParameter3Name,tempRemittanceInput.sfdcParameter3Value);
                    parameterMap.put(tempRemittanceInput.sfdcParameter4Name,tempRemittanceInput.sfdcParameter4Value);

                    receiptId = parameterMap.get('SFDClicId');
                    cartId = parameterMap.get('SFDCId');
                    SFDCfeeIds = parameterMap.get('SFDCfeeId');
                    SFDCappId = parameterMap.get('SFDCappId');
                    
                    receipt = [ select id, Status__c, Selected_Fees__c, MUSW__Payment_Method__c, MUSW__Paid_By__c, MUSW__Receipt_Paid_by__c 
                                from MUSW__Receipt__c 
                                where id =: receiptId ];
                    
                    updateReceiptFromRemittanceInput();
                    if(receipt.Status__c == 'Complete' ){
                        update receipt;
                    }else{
                        processPayment = new DOL_ProcessPayment(Id.valueOf(SFDCappId),
                                        Id.valueOf(cartId),
                                        receipt.Selected_Fees__c.split(','),
                                        receipt,
                                        Decimal.valueOf(tempRemittanceInput.PaymentAmount)
                                        );
                        processPayment.doPayment();
                    }
                    record.INFO__c = 'Process Completed Successfully';
                    record.Status__c = 'SUCCESSFUL';

                }catch(Exception error){
                    tempRecord.INFO__c += 'error occured :- '+error.getMessage()+' stack trace '+error.getStackTraceString();
                    record.Status__c = 'FAILED';
                }
            }
            DOL_Dao.save(remittanceRecords);
        }
    }
    
    global void finish(Database.BatchableContext BC){ }

    private void updateReceiptFromRemittanceInput(){
        if(! String.isBlank(tempRemittanceInput.transactionConfirmationId) ){
            receipt.MUSW__Payment_Gateway_Transaction_Number__c = tempRemittanceInput.transactionConfirmationId;
            receipt.Transaction_Confirmation_ID__c = tempRemittanceInput.transactionConfirmationId;
        }
        if(! String.isBlank(tempRemittanceInput.paymentMethod))
            receipt.MUSW__Payment_Method__c = tempRemittanceInput.paymentMethod;
        if(! String.isBlank(tempRemittanceInput.dueDate))
            receipt.Date__c = DOL_AppUtility.getDate(tempRemittanceInput.dueDate,'YYYYMMDD');
        if(! String.isBlank(tempRemittanceInput.paymentAmount))
            receipt.MUSW__Amount_Tendered__c = Decimal.valueOf(tempRemittanceInput.paymentAmount);
        if(! String.isBlank(tempRemittanceInput.totalAmount))
            receipt.MUSW__Amount_Tendered__c = Decimal.valueOf(tempRemittanceInput.totalAmount);
        if(! String.isBlank(tempRemittanceInput.paymentEffectiveDate))
            receipt.MUSW__Effective_Date__c = DOL_AppUtility.getDate(tempRemittanceInput.paymentEffectiveDate,'YYYYMMDD');
        if(! String.isBlank(tempRemittanceInput.billerBusinessDate))
            receipt.ACH_BillerBusinessDate__c = DOL_AppUtility.getDate(tempRemittanceInput.billerBusinessDate,'YYYYMMDD');
        if(! String.isBlank(tempRemittanceInput.initiationDate) && ! String.isBlank(tempRemittanceInput.initiationTime))
            receipt.Initiation_Date_and_Time__c = DOL_AppUtility.getDateTime(tempRemittanceInput.initiationDate+' '+tempRemittanceInput.initiationTime,'YYYYMMDD HHmmSS');
        if(! String.isBlank(tempRemittanceInput.paymentMethod))
            receipt.MUSW__Payment_Method__c = tempRemittanceInput.paymentMethod;
        if(! String.isBlank(tempRemittanceInput.cardType))
            receipt.MUSW__Card_Type__c = tempRemittanceInput.cardType;
        if(! String.isBlank(tempRemittanceInput.lastFourAccountNumber) && DOL_AppUtility.isValidDecimalValue(tempRemittanceInput.lastFourAccountNumber) )
            receipt.Last_4_digits_of_Credit_Card_or_ACH__c = Decimal.valueOf(tempRemittanceInput.lastFourAccountNumber);
        if(! String.isBlank(tempRemittanceInput.paymentAuthorization))
            receipt.Card_Authorized__c = tempRemittanceInput.paymentAuthorization;
        if(! String.isBlank(tempRemittanceInput.paymentStatus))
            receipt.US_Bank_Payment_Status__c = tempRemittanceInput.paymentStatus;
        if(! String.isBlank(tempRemittanceInput.firstName))
            receipt.Payer_First_Name__c = tempRemittanceInput.firstName;
        if(! String.isBlank(tempRemittanceInput.lastName))
            receipt.Payer_Last_Name__c = tempRemittanceInput.lastName;
        if(! String.isBlank(tempRemittanceInput.companyName))
            receipt.Company_Name__c = tempRemittanceInput.companyName;
    }

}