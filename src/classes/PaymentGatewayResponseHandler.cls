@RestResource(urlMapping='/PaymentGatewayResponse')
global without sharing class PaymentGatewayResponseHandler{

    @HttpPost
    global static ServiceResponse processPost() {
        //system.debug('PaymentGatewayResponseHandler Called at: ' + DateTime.now());
        
        ServiceResponse response = new ServiceResponse();
        try{
            handlePaymentResponse(RestContext.request.requestBody);
            
            response.responseCode = 200;
            response.responseStatus = DOL_AppConstants.NULL_EMPTY_STRING + 'OK';
        }catch(Exception ex){
            response.responseCode = -1;
            response.responseStatus = ex.getMessage();
           // system.debug(ex.getMessage());
            
           // ErrorLogger.logGeneralException(ex, UserInfo.getUserId(), 'Payment Realtime', 'Error While Processing Payment Response', 'processPost', 'PaymentGatewayResponseHandler', 'HIGH');
        }
        
        return response;
    }
    
    private static void handlePaymentResponse(Blob body){
        PaymentResponse payResponse = new PaymentResponse();
        payResponse.transactionId = DOL_AppConstants.NULL_EMPTY_STRING + '';
        payResponse.confirmationId = DOL_AppConstants.NULL_EMPTY_STRING + '';
        payResponse.userId = DOL_AppConstants.NULL_EMPTY_STRING + '';
        payResponse.paymentMethod = DOL_AppConstants.NULL_EMPTY_STRING + '';
        payResponse.paymentAmount = 0;
        payResponse.convenienceFee = 0;
        payResponse.lastFourAccNumber = DOL_AppConstants.NULL_EMPTY_STRING + '';
        
        String bodyString = body.toString();
        
     //   system.debug('bodyString: ' + bodyString);
        
        Dom.Document bodyDocument = new Dom.Document();
        bodyDocument.load(bodyString);
        
        Dom.XmlNode root = bodyDocument.getRootElement();
        String rootNameSpace = root.getNameSpace();
        
        for(Dom.XmlNode node : bodyDocument.getRootElement().getChildElements()){
            if(node.getName() == 'ConfirmationId'){
                payResponse.ConfirmationId = node.getText();
            }
            if(node.getName() == 'UserID'){
                payResponse.userId = node.getText();
            }
            if(node.getName() == 'PaymentMethod'){
                payResponse.paymentMethod = node.getText();
            }
            if(node.getName() == 'CardType'){
                payResponse.cardType = node.getText();
            }
            if(node.getName() == 'PaymentAmount'){
                String pa = node.getText();
                if(pa != null && pa != ''){
                    payResponse.paymentAmount = Decimal.valueOf(pa); 
                }
            }
            if(node.getName() == 'ConvenienceFee'){
                String pa = node.getText();
                if(pa != null && pa != ''){
                    payResponse.convenienceFee = Decimal.valueOf(pa); 
                }
            }
            if(node.getName() == 'PaymentEffectiveDate'){
                String pa = node.getText();
                if(pa != null && pa != ''){
                    payResponse.paymentEffectiveDate = Date.valueOf(pa); 
                }
            }
            if(node.getName() == 'LastFourAccountNumber'){
                payResponse.lastFourAccNumber = node.getText();
            }
            
            if(node.getName() == 'Parameter'){
                String parameterName = node.getChildElement('ParameterName', null).getText();
                if(parameterName == 'ShoppingCartID'){
                    payResponse.transactionId = node.getChildElement('ParameterValue', null).getText();
                }
            }
        }
        
        MUSW__Receipt__c receipt = [Select Id, Name, Selected_Fees__c, BGBK__Cart__c, BGBK__Cart__r.BGBK__Contact__c, 
                                            BGBK__Cart__r.BGBK__Account__c, MUSW__Receipt_Paid_By__c,
                                            MUSW__Amount_Tendered__c, MUSW__Payment_Gateway_Transaction_Number__c,
                                            MUSW__Payment_Method__c, MUSW__Card_Type__c, MUSW__Card_Number__c,
                                            MUSW__Effective_Date__c
                                            From MUSW__Receipt__c where Id = :payResponse.transactionId];
        
        List<String> lstFeeIds = receipt.Selected_Fees__c.split(',');
      //  system.debug('lstFeeIds==='+lstFeeIds);
        if(payResponse.paymentMethod == 'ACH'){
            if(lstFeeIds != null && lstFeeIds.size() > 0){
                List<MUSW__Fee__c> lstFeesToUpdate = new List<MUSW__Fee__c>();
                for(Id feeId : lstFeeIds){
                    MUSW__Fee__c fee = new MUSW__Fee__c(Id = feeId);
                    fee.BGBK__Cart_Exclude__c = true;
                    fee.MUSW__Payment_Comment__c  = DOL_AppConstants.NULL_EMPTY_STRING + 'ACH Payment Pending';
                    
                    lstFeesToUpdate.add(fee);
                }
                
                if(lstFeesToUpdate.size() > 0){
                    update lstFeesToUpdate;
                }
            }
            
            if(payResponse.ConfirmationId != ''){
                receipt.MUSW__Payment_Gateway_Transaction_Number__c = payResponse.ConfirmationId;
                
                update receipt;
            }
        }else{        
            List <BGBK.Payable> payables = new List <BGBK.Payable>();
            
            List<String> lstFeeFields = Utilities.getAllFieldsSObject('MUSW__Fee__c', new Set<String>(), false);
            String feeFields = String.join(lstFeeFields, ',');
            String query = DOL_AppConstants.NULL_EMPTY_STRING + 'Select ' + feeFields + ' From MUSW__Fee__c where Id IN :lstFeeIds';
            
            for(MUSW__Fee__c fee : Database.query(query)){
                payables.add(new BGBK.Payable(fee, fee.MUSW__Outstanding_Fee__c));
            }
            
            receipt.MUSW__Receipt_Paid_By__c = receipt.BGBK__Cart__r.BGBK__Contact__c;
            receipt.MUSW__Amount_Tendered__c = payResponse.paymentAmount;
            receipt.MUSW__Payment_Gateway_Transaction_Number__c = payResponse.ConfirmationId;
            receipt.MUSW__Payment_Method__c = payResponse.paymentMethod;
            receipt.MUSW__Card_Number__c = payResponse.lastFourAccNumber;
            receipt.MUSW__Card_Type__c = payResponse.cardType;
            receipt.MUSW__Effective_Date__c = payResponse.paymentEffectiveDate;
            receipt.Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Complete';
            receipt.Convenience_Fee__c = payResponse.convenienceFee;
            
            BGBK.PaymentTransactionInfo pti = new BGBK.PaymentTransactionInfo();
            pti.transactionId = payResponse.ConfirmationId;
            pti.transactionStatus = BGBK.PaymentTransactionInfo.TransactionStatusType.SUCCESS;
            pti.transactionResponse = new Map<String,String>();
            pti.isNonGatewayTransaction = false;
            pti.receiptPayableAmount = payResponse.paymentAmount;
    
            Map<MUSW__Receipt__c, BGBK.PaymentTransactionInfo> receiptTransMap = new Map<MUSW__Receipt__c, BGBK.PaymentTransactionInfo>{receipt => pti};
            
            BGBK.PaymentService ps = new BGBK.PaymentService();
          //  system.debug('payables==='+payables);
          //  system.debug('receiptTransMap==='+receiptTransMap);
          //  system.debug('receipt.BGBK__Cart__r.BGBK__Account__c==='+receipt.BGBK__Cart__r.BGBK__Account__c);
            
            ps.processGatewayPayment(payables, receiptTransMap, receipt.BGBK__Cart__r.BGBK__Account__c, System.now());
            
            BGBK.CartService bgCartService = new BGBK.CartService(null, receipt.BGBK__Cart__c);
            bgCartService.closeCart(payResponse.paymentAmount, receipt.BGBK__Cart__r.BGBK__Account__c, receipt.BGBK__Cart__r.BGBK__Contact__c, System.now());
        }
    }
    
    global class PaymentResponse{
        public String transactionId {get; set;}
        public String confirmationId {get; set;}
        public String userId {get; set;}
        public String paymentMethod {
            get;
            set{
                paymentMethod = value;
                if(value == 'CC'){
                    paymentMethod = DOL_AppConstants.NULL_EMPTY_STRING + 'Credit Card';
                }
            }
        }
        public Decimal paymentAmount {get; set;}
        public Decimal convenienceFee {get; set;}
        public Date paymentEffectiveDate {get; set;}
        public String lastFourAccNumber {get; set;}
        public String cardType {
            get;
            set{
                cardType = value;
                if(value == 'MC'){
                    cardType = DOL_AppConstants.NULL_EMPTY_STRING + 'MasterCard';
                }else if(value == 'VISA'){
                    cardType = DOL_AppConstants.NULL_EMPTY_STRING + 'Visa';
                }else if(value == 'AMEX'){
                    cardType = DOL_AppConstants.NULL_EMPTY_STRING + 'Amex';
                }
            }
        }
        public String BankRTN {get; set;}
        public String BankName {get; set;}
        public String SECCode {get; set;}
        public String paymentStatus {get; set;}
        public String reasonDescription {get; set;}
        public Date returnDate {get; set;}
    }
    
    global class ServiceResponse{
        public Integer responseCode {get; set;}
        public String responseStatus {get; set;}
    }
}