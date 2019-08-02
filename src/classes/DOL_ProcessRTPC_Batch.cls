
/**
* User Story: ****
* Class Name: DOL_ProcessRTPC_Batch
* Test Class Name: ****
* Description: To process RTPC records in Batch
* Date:        Developer/Company                    Description
* ------------------------------------------------------------------------------------------------*
* 07/29/2019   Laltu Banerjee/Deloitte           Initial Creation
**/
global with sharing class DOL_ProcessRTPC_Batch implements Database.Batchable<sObject>{

    public DOL_ProcessRTPC_Batch() {}

    global Database.QueryLocator start(Database.BatchableContext BC){
        System.debug('DOL_Epayment_ProcessRemittanceData::start...');
        Datetime dt = Datetime.now().addMinutes(0); // Get date time for one 15 min back
        return Database.getQueryLocator([ select id, File_Name__c, INFO__c, Input__c, Status__c, Input_Type__c 
                                        from DOL_Integration_Batch_Input__c 
                                        where Status__c = 'UNPROCESSED' and 
                                        Input_Type__c = 'RTPC' and 
                                        LastModifiedDate <=: dt ]
                                        );
    }

    global void execute(Database.BatchableContext BC, List<DOL_Integration_Batch_Input__c> rtpcRecords){
        if(rtpcRecords != null && !rtpcRecords.isEmpty()){
            
            DOL_RTPC_Input tempRtpcInput;
            List<DOL_RTPC_Input.Parameter> tempParameterList;
            String receiptId,cartId,SFDCappId;
            Map<String,String> parameterMap;
            MUSW__Receipt__c receipt;
            DOL_ProcessPayment processPayment;
            
            for(DOL_Integration_Batch_Input__c record : rtpcRecords){
                try{
                    parameterMap = new Map<String,String>();
                    record.INFO__c = '';
                    tempRtpcInput = DOL_RTPC_Input.parse(record.Input__c);
                    for(DOL_RTPC_Input.Parameter parameter : tempRtpcInput.Parameter ){
                        parameterMap.put(parameter.ParameterName,parameter.ParameterValue);
                    }
                    
                    receiptId = parameterMap.get('SFDClicId');
                    cartId = parameterMap.get('SFDCId');
                    SFDCappId = parameterMap.get('SFDCappId');

                    if(String.isBlank(receiptId)){
                       throw new CustomException('Input Receipt Id is null or blank, Parameter name for reading receipt is SFDClicId'); 
                    }
                    receipt = [select id, Status__c, Selected_Fees__c, MUSW__Payment_Method__c, MUSW__Paid_By__c, MUSW__Receipt_Paid_by__c from MUSW__Receipt__c where id =: receiptId ];
                    if(receipt == null){
                        throw new CustomException('Invalid receipt Id, receipt Id = '+receiptId+' is not present in ORG ');
                    }
                    updateReceiptFromRTPCPojo(tempRtpcInput, receipt);
                    if(receipt.Status__c == 'Complete'){
                        update receipt;
                    }
                    else{
                        processPayment = new DOL_ProcessPayment(Id.valueOf(SFDCappId),
                                        Id.valueOf(cartId),
                                        receipt.Selected_Fees__c.split(','),
                                        receipt,
                                        Decimal.valueOf(tempRtpcInput.PaymentAmount)
                                        );
                        processPayment.doPayment();
                        
                    }
                    record.INFO__c = 'Process Completed Successfully';
                    record.Status__c = 'SUCCESSFUL'; 

                }catch(Exception error){
                    record.INFO__c += 'error Msg = '+error.getMessage()+' StackTrace = '+error.getStackTraceString();
                    record.Status__c = 'FAILED';
                }
            }
            update rtpcRecords;
        }
    }

    global void finish(Database.BatchableContext BC){   
        
    }

    private void updateReceiptFromRTPCPojo(DOL_RTPC_Input rtpcData, MUSW__Receipt__c receipt){
        if(! String.isBlank(rtpcData.ConfirmationId)){
            receipt.Transaction_Confirmation_ID__c = rtpcData.ConfirmationId;
            receipt.MUSW__Payment_Gateway_Transaction_Number__c = rtpcData.ConfirmationId;
        }
        if(! String.isBlank(rtpcData.PaymentMethod))
            receipt.MUSW__Payment_Method__c = rtpcData.PaymentMethod;
        if(!String.isBlank(rtpcData.PaymentEffectiveDate))
            receipt.MUSW__Effective_Date__c = DOL_AppUtility.getDate(rtpcData.PaymentEffectiveDate,'YYYY-MM-DD');
        if(!String.isBlank(rtpcData.DueDate))
            receipt.Date__c = DOL_AppUtility.getDate(rtpcData.DueDate,'YYYY-MM-DD');
        if(!String.isBlank(rtpcData.PayerFirstName))
            receipt.Payer_First_Name__c = rtpcData.PayerFirstName;
        if(!String.isBlank(rtpcData.PayerLastName))
            receipt.Payer_Last_Name__c = rtpcData.PayerLastName;
        if(!String.isBlank(rtpcData.LastFourAccountNumber) && DOL_AppUtility.isValidDecimalValue(rtpcData.LastFourAccountNumber))
            receipt.Last_4_digits_of_Credit_Card_or_ACH__c = Decimal.valueOf(rtpcData.LastFourAccountNumber);
        if(!String.isBlank(rtpcData.CardType))
            receipt.MUSW__Card_Type__c = rtpcData.CardType;
        if(!String.isBlank(rtpcData.PaymentAuthorization))
            receipt.Card_Authorized__c = rtpcData.PaymentAuthorization;
    }
}
