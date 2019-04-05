@RestResource(urlMapping='/PaymentGatewayBatch')
global class PaymentGatewayBatchHandler {
    
    @HttpPost
    global static ServiceResponse processPost() {
        system.debug('PaymentGatewayBatchHandler Called at: ' + DateTime.now());
        
        ServiceResponse response = new ServiceResponse();
        try{
            handlePaymentResponse(RestContext.request.requestBody);
            
            response.responseCode = 200;
            response.responseStatus = 'OK';
        }catch(Exception ex){
            response.responseCode = -1;
            response.responseStatus = ex.getMessage();
            system.debug(ex.getMessage());
            
            ErrorLogger.logGeneralException(ex, UserInfo.getUserId(), 'Payment Batch', 'Error While Processing Payment Response', 'processPost', 'PaymentGatewayBatchHandler', 'HIGH');
        }
        
        return response;
    }
    
    private static void handlePaymentResponse(Blob body){
        Map<Id, PaymentGatewayResponseHandler.PaymentResponse> mapPaymentResponse = new Map<Id, PaymentGatewayResponseHandler.PaymentResponse>();
        
        String bodyString = body.toString();
        system.debug('bodyString: ' + bodyString);
        
        Dom.Document bodyDocument = new Dom.Document();
        bodyDocument.load(bodyString);
        
        Dom.XmlNode root = bodyDocument.getRootElement();
        String rootNameSpace = root.getNameSpace();
        
        for(Dom.XmlNode node2 : bodyDocument.getRootElement().getChildElements()){
            system.debug('cp2 ' + node2.getName());
            if(node2.getName() == 'TransactionDetail'){
                PaymentGatewayResponseHandler.PaymentResponse payResponse = new PaymentGatewayResponseHandler.PaymentResponse();
                payResponse.transactionId = '';
                payResponse.confirmationId = '';
                payResponse.userId = '';
                payResponse.paymentMethod = '';
                payResponse.paymentAmount = 0;
                payResponse.convenienceFee = 0;
                payResponse.lastFourAccNumber = '';
                
                for(Dom.XmlNode node3 : node2.getChildElements()){
                    if(node3.getName() == 'TransactionConfirmationId'){
                        payResponse.ConfirmationId = node3.getText();
                    }
                    if(node3.getName() == 'UserID'){
                        payResponse.userId = node3.getText();
                    }
                    if(node3.getName() == 'PaymentMethod'){
                        payResponse.paymentMethod = node3.getText();
                    }
                    if(node3.getName() == 'PaymentAmount'){
                        String pa = node3.getText();
                        if(pa != null && pa != ''){
                            payResponse.paymentAmount = Decimal.valueOf(pa); 
                        }
                    }
                    if(node3.getName() == 'ConvenienceFee'){
                        String pa = node3.getText();
                        if(pa != null && pa != ''){
                            payResponse.convenienceFee = Decimal.valueOf(pa); 
                        }
                    }
                    if(node3.getName() == 'PaymentEffectiveDate'){
                        String pa = node3.getText();
                        if(pa != null && pa != ''){
                            payResponse.paymentEffectiveDate = Date.valueOf(pa); 
                        }
                    }
                    if(node3.getName() == 'LastFourAccountNumber'){
                        payResponse.lastFourAccNumber = node3.getText();
                    }
                    if(node3.getName() == 'PaymentStatus'){
                        payResponse.PaymentStatus = node3.getText();
                    }
                    if(node3.getName() == 'ReasonDescription'){
                        payResponse.ReasonDescription = node3.getText();
                    }
                    if(node3.getName() == 'ReturnDate'){
                        String pa = node3.getText();
                        if(pa != null && pa != ''){
                            payResponse.ReturnDate = Date.valueOf(pa); 
                        }
                    }
                    if(node3.getName() == 'ACHDetail'){
                        payResponse.BankRTN = node3.getChildElement('BankRTN', null).getText();
                        payResponse.BankName = node3.getChildElement('BankName', null).getText();
                        payResponse.SECCode = node3.getChildElement('SECCode', null).getText();
                        payResponse.lastFourAccNumber = node3.getChildElement('LastFourAccountNumber', null).getText();
                    }
                    if(node3.getName() == 'CardDetail'){
                        payResponse.cardType = node3.getChildElement('CardType', null).getText();
                        payResponse.lastFourAccNumber = node3.getChildElement('LastFourAccountNumber', null).getText();
                    }
                    
                    if(node3.getName() == 'Paramters'){
                        for(Dom.XmlNode node4 : node3.getChildElements()){
                            if(node4.getName() == 'Parameter'){
                                String parameterName = node4.getChildElement('Name', null).getText();
                                if(parameterName == 'ShoppingCartID'){
                                    payResponse.transactionId = node4.getChildElement('Value', null).getText();
                                    system.debug('found ShoppingCartID' + payResponse.transactionId);
                                }
                            }
                        }
                    }
                }
                
                system.debug('payResponse: ' + payResponse);
                try{
                    mapPaymentResponse.put(payResponse.transactionId, payResponse);
                }catch(Exception ex){
                    //If invalid id is received in the file, then ignore the error.
                }
            }
        }
        
        try{
            system.debug('Receipt Ids being processed: ' + mapPaymentResponse.keySet());        
            Map<Id, MUSW__Receipt__c> mapReceipt = new Map<Id, MUSW__Receipt__c>([Select Id, Name, Selected_Fees__c, BGBK__Cart__c, BGBK__Cart__r.BGBK__Contact__c, 
                                                BGBK__Cart__r.BGBK__Account__c, MUSW__Receipt_Paid_By__c,
                                                MUSW__Amount_Tendered__c, MUSW__Payment_Gateway_Transaction_Number__c,
                                                MUSW__Payment_Method__c, MUSW__Card_Type__c, MUSW__Card_Number__c,
                                                MUSW__Effective_Date__c, (Select Id From BGBK__Payments__r)
                                                From MUSW__Receipt__c where Id IN :mapPaymentResponse.keySet()]);
            
            Set<Id> setFeeIds = new Set<Id>();
            for(Id receiptId : mapReceipt.keySet()){
                MUSW__Receipt__c receipt = mapReceipt.get(receiptId);
				PaymentGatewayResponseHandler.PaymentResponse payResponse = mapPaymentResponse.get(receiptId);
                
                if((receipt.BGBK__Payments__r == null || receipt.BGBK__Payments__r.size() == 0) && payResponse.PaymentStatus == 'PROCESSED'){
                    List<Id> lstFeeIds = receipt.Selected_Fees__c.split(',');
                    setFeeIds.addAll(lstFeeIds);
                }
            }
            
            List<String> lstFeeFields = Utilities.getAllFieldsSObject('MUSW__Fee__c', new Set<String>(), false);
            String feeFields = String.join(lstFeeFields, ',');
            String query = 'Select ' + feeFields + ' From MUSW__Fee__c where Id IN :setFeeIds';
            Map<Id, MUSW__Fee__c> mapFee = new Map<Id, MUSW__Fee__c> ((List<MUSW__Fee__c>) Database.query(query));
            
            List<MUSW__Fee__c> lstFeesToUpdate = new List<MUSW__Fee__c>();
            List<MUSW__Receipt__c> lstReceiptsToUpdate = new List<MUSW__Receipt__c>();
            for(Id receiptId : mapReceipt.keySet()){
                MUSW__Receipt__c receipt = mapReceipt.get(receiptId);
                PaymentGatewayResponseHandler.PaymentResponse payResponse = mapPaymentResponse.get(receiptId);
                //Do not process the payment again if the payment was already processed during real time response.
                //In case of ACH payments as well as in case of payments where a response was not received in real-time,
                //the receipt record would not have any payment records associated with it.
                //If that is the case, process the payment.
                if((receipt.BGBK__Payments__r == null || receipt.BGBK__Payments__r.size() == 0) && payResponse.PaymentStatus == 'PROCESSED'){
                    List<String> lstFeeIds = receipt.Selected_Fees__c.split(',');
                    List <BGBK.Payable> payables = new List <BGBK.Payable>();
                    
                    for(Id feeId : lstFeeIds){
                        MUSW__Fee__c fee = mapFee.get(feeId);
                        if(payResponse.paymentMethod == 'ACH'){
                            MUSW__Fee__c f1 = new MUSW__Fee__c(Id = fee.Id, MUSW__Payment_Comment__c = 'ACH Payment Received');
                            lstFeesToUpdate.add(f1);
                        }
                        payables.add(new BGBK.Payable(fee, fee.MUSW__Outstanding_Fee__c));
                    }
                    
                    receipt.MUSW__Receipt_Paid_By__c = receipt.BGBK__Cart__r.BGBK__Contact__c;
                    receipt.MUSW__Amount_Tendered__c = payResponse.paymentAmount;
                    receipt.MUSW__Payment_Gateway_Transaction_Number__c = payResponse.ConfirmationId;
                    receipt.MUSW__Payment_Method__c = payResponse.paymentMethod;
                    receipt.MUSW__Card_Number__c = payResponse.lastFourAccNumber;
                    receipt.MUSW__Effective_Date__c = payResponse.paymentEffectiveDate;
                    receipt.Status__c = 'Complete';
                    receipt.Convenience_Fee__c = payResponse.convenienceFee;
                    receipt.Bank_RTN__c = payResponse.BankRTN;
                    receipt.Bank_Name__c = payResponse.BankName;
                    receipt.Bank_SEC_Code__c = payResponse.SECCode;
                    
                    BGBK.PaymentTransactionInfo pti = new BGBK.PaymentTransactionInfo();
                    pti.transactionId = payResponse.ConfirmationId;
                    pti.transactionStatus = BGBK.PaymentTransactionInfo.TransactionStatusType.SUCCESS;
                    pti.transactionResponse = new Map<String,String>();
                    pti.isNonGatewayTransaction = false;
                    pti.receiptPayableAmount = payResponse.paymentAmount;
            
                    Map<MUSW__Receipt__c, BGBK.PaymentTransactionInfo> receiptTransMap = new Map<MUSW__Receipt__c, BGBK.PaymentTransactionInfo>{receipt => pti};
                    
                    BGBK.PaymentService ps = new BGBK.PaymentService();
                    ps.processGatewayPayment(payables, receiptTransMap, receipt.BGBK__Cart__r.BGBK__Account__c, System.now());
                    
                    BGBK.CartService bgCartService = new BGBK.CartService(null, receipt.BGBK__Cart__c);
                    bgCartService.closeCart(payResponse.paymentAmount, receipt.BGBK__Cart__r.BGBK__Account__c, receipt.BGBK__Cart__r.BGBK__Contact__c, System.now());
                }else if((receipt.BGBK__Payments__r != null || receipt.BGBK__Payments__r.size() > 0) && payResponse.PaymentStatus == 'PROCESSED' && payResponse.paymentMethod == 'Credit Card'){
                    receipt.MUSW__Card_Type__c = payResponse.cardType;
                    receipt.MUSW__Card_Number__c = payResponse.lastFourAccNumber;
                    lstReceiptsToUpdate.add(receipt);
                }else if(payResponse.PaymentStatus != 'PROCESSED'){
                    List<String> lstFeeIds = receipt.Selected_Fees__c.split(',');
                    String status = '';
                    String comments = '';
                    if(payResponse.PaymentStatus == 'RETURNED'){
                        status = 'Returned';
                    }else if(payResponse.PaymentStatus == 'Refunded'){
                        status = 'Refunded';
                    }else{
                        status = 'Other';
                    }
                    
                    comments = payResponse.ReasonDescription;
                    if(payResponse.ReturnDate != null){
                        comments = comments + ' : Return Date: ' + payResponse.ReturnDate;
                    }
                    
                    if(lstFeeIds != null && lstFeeIds.size() > 0){                    
                        for(Id feeId : lstFeeIds){
                            MUSW__Fee__c fee = new MUSW__Fee__c(Id = feeId);
                            fee.MUSW__Payment_Comment__c  = comments;
                            
                            lstFeesToUpdate.add(fee);
                        }
                    }
                    
                    receipt.Review_Required__c = true;
                    receipt.Status__c = status;
                    receipt.MUSW__Comments__c = comments;
                    
                    lstReceiptsToUpdate.add(receipt);
                }
            }
            
            if(lstFeesToUpdate.size() > 0){
                update lstFeesToUpdate;
            }
            if(lstReceiptsToUpdate.size() > 0){
                system.debug('lstReceiptsToUpdate>>>'+lstReceiptsToUpdate);
                update lstReceiptsToUpdate;
            }
        }catch(Exception ex){
            system.debug(ex.getMessage());
            ErrorLogger.logGeneralException(ex, UserInfo.getUserId(), 'Payment Batch', 'Error While Processing Payment Response', 'processPost', 'PaymentGatewayBatchHandler', 'HIGH');
        }
    }
    
    global class ServiceResponse{
        public Integer responseCode {get; set;}
        public String responseStatus {get; set;}
    }
}