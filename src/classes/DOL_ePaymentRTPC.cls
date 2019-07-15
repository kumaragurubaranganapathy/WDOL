/************************************************************************************************************
** Name             : DOL_ePaymentRTPC
** Description   	: Process Real Time Payment Conformation request from ePayment 
** Version          : 1.0
**-------------------------------------------------------------------------------------------------------------------------------
** Revision History:
**---------------------------
** [Laltu Banerjee]: Created
*************************************************************************************************************/
public class DOL_ePaymentRTPC {

    public FeeVO[] feeVOs { get; set; }
    public InvoiceVO[] invoiceVOs { get; set; }
    public ReceiptVO[] receiptVOs { get; set; }
    public DepositVo[] depositVOs { get; set; }

    private Id m_cartId;
    private BGBK.CartService m_cs;
    private BGBK.PaymentService m_ps;
    private BGBK.ReceiptService m_rs;
    private Map<BGBK.Payable, List<MUSW__Deposit__c>> m_payableDeposits;
    private Map<Id, MUSW__Deposit__c> m_depositsMap;
    private Map<Integer, MUSW__Deposit__c> m_depositsIndexMap;
    private BGBK__CartSettings__c m_settings;
    
    
    private Boolean checkReceiptAmount { get; private set; }
    private Boolean canCreate { get; private set; }
    private Contact con { get; set; }
    private Account acc { get; set; }
    private BGBK__Cart__c cart { get; set; }
    private String accountSelected { get; set; }
    private String email { get; set; }
    private MUSW__Receipt__c[] rs { get; set; }
    private MUSW__Fee__c[] fees { get; private set; }
    private Decimal totalSelected { get; set; }
    private Decimal totalSelectedOutstanding { get; set; }
    private Decimal m_totalOwed { get; set; }
    private BGBK.Payable[] payables {get; set;}
    private boolean processSuccessful { get; set; }
    private DOL_ePaymentRTPCPOJO ePaymentRTPCData { get; set; }
    private MUSW__Receipt__c receipt {get; set; }

    //RTPC Input
    private String cartId = '',SFDCfeeIds='',SFDCappId='',receiptId = '';
    

    private DOL_Dao dao = new DOL_Dao();
    private HTTPRestResponse response = HTTPRestResponse.getInstance();

    public  HTTPRestResponse processEpaymentRTPCRequest(String json){

        Map<String,String> parameterMap = new Map<String,String>();
        receipt = null;
        try{
            ePaymentRTPCData = DOL_ePaymentRTPCPOJO.parse(json);
            // get the parameters.
            List<DOL_ePaymentRTPCPOJO.Parameter> parameterList = ePaymentRTPCData.Parameter; 
            for(DOL_ePaymentRTPCPOJO.Parameter parameter : parameterList ){
                parameterMap.put(parameter.ParameterName,parameter.ParameterValue);
            }
            receiptId = parameterMap.get('SFDClicId');
            cartId = parameterMap.get('SFDCId');
            SFDCfeeIds = parameterMap.get('SFDCfeeIds');
            SFDCappId = parameterMap.get('SFDCappId');

            if(isNotNullOrBlank(receiptId)){
                receipt = new MUSW__Receipt__c(id=receiptId);
            }
            if(receipt != null){
                updateReceiptFromRTPCPojo(ePaymentRTPCData,receipt);
                DOL_Dao.save(receipt);
                if(! isPaymentRecorded()){
                    initFinancialObject();
                    processEpayment();
                }
                response.addLog('receipt updated successfully');
                response.addLog('success');
                response.setStatusCode(200);
            }else{
                response.addErrorMsg('ReceiptId not found , not able to process RTPC request');
                response.setStatusCode(400);
            }
        }
        catch(Exception error){
            response.addErrorMsg('message :- '+error.getMessage());
            response.addErrorMsg('StackTrace :- '+error.getStackTraceString());
            response.setStatusCode(400);
        }
        return response;
    }


    private void updateReceiptFromRTPCPojo(DOL_ePaymentRTPCPOJO rtpcData, MUSW__Receipt__c receipt){
        if(isNotNullOrBlank(rtpcData.ConfirmationId))
            receipt.MUSW__Payment_Gateway_Transaction_Number__c = rtpcData.ConfirmationId;
        if(isNotNullOrBlank(rtpcData.PaymentMethod)){
            receipt.MUSW__Payment_Method__c = rtpcData.PaymentMethod;
            if(receipt.MUSW__Payment_Method__c == 'CC')
                receipt.MUSW__Payment_Method__c = 'Credit Card';
        }
        if(isNotNullOrBlank(rtpcData.PaymentAmount))
            receipt.MUSW__Amount_Tendered__c = Decimal.valueOf(rtpcData.PaymentAmount);
        if(isNotNullOrBlank(rtpcData.PaymentEffectiveDate))
            receipt.MUSW__Effective_Date__c = DOL_AppUtility.getDate(rtpcData.PaymentEffectiveDate,'YYYYMMDD');
        if(isNotNullOrBlank(rtpcData.DueDate))
            receipt.Date__c = DOL_AppUtility.getDate(rtpcData.DueDate,'YYYYMMDD');
        if(isNotNullOrBlank(rtpcData.PayerFirstName))
            receipt.Payer_First_Name__c = rtpcData.PayerFirstName;
        if(isNotNullOrBlank(rtpcData.PayerLastName))
            receipt.Payer_Last_Name__c = rtpcData.PayerLastName;
        if(isNotNullOrBlank(rtpcData.LastFourAccountNumber))
            receipt.Last_4_digits_of_Credit_Card_or_ACH__c = Decimal.valueOf(rtpcData.LastFourAccountNumber);
        if(isNotNullOrBlank(rtpcData.CardType))
            receipt.MUSW__Card_Type__c = rtpcData.CardType;
        if(isNotNullOrBlank(rtpcData.PaymentAuthorization))
            receipt.Card_Authorized__c = rtpcData.PaymentAuthorization;
    }

    private boolean isPaymentRecorded(){
        boolean paymentRecordFound = false;
        List<String> sfdcFeeIdList = sfdcFeeIds.split(DOL_AppConstants.ePaymentUrlListValuesSeperator);
        List<MUSW__Fee__c> fees = dao.getFeeAndFeePayment(sfdcFeeIdList);
        if(fees != null && fees.size() > 0){
        	List<MUSW__Fee_Payment__c> feePayments = fees.get(0).MUSW__Payments__r;
            if(feePayments != null && feePayments.size() > 0)
            	paymentRecordFound = true;
        }
        return paymentRecordFound;
    }

    private void initFinancialObject(){
        //intantiate the variables
        m_cartId = cartId;
        m_cs = new BGBK.CartService(null, m_cartId);
        m_ps = new BGBK.PaymentService();
        m_rs = new BGBK.ReceiptService();
        m_payableDeposits = new Map<BGBK.Payable, List<MUSW__Deposit__c>>();
        m_depositsMap = new Map<Id, MUSW__Deposit__c>();
        m_depositsIndexMap = new Map<Integer, MUSW__Deposit__c>();
        checkReceiptAmount = true;
        
        canCreate = m_ps.canCreate();
        feeVOs = new FeeVO[]{};
        invoiceVOs = new InvoiceVO[]{};
        receiptVOs = new ReceiptVO[]{};
        depositVOs = new DepositVO[]{};

        m_settings = BGBK__CartSettings__c.getValues('Default');
        con = m_cs.getActiveContact();
        acc = m_cs.getActiveAccount(); // updated as acc
        cart = m_cs.getActiveCart();
        

        accountSelected = acc.Id;
        if (con != null) email = con.Email;
        // initlization ends here
        // extract fees and receipt
        List<String> feeIdList = SFDCfeeIds.split(DOL_AppConstants.ePaymentUrlListValuesSeperator);
        fees = new List<MUSW__Fee__c>();
        if( feeIdList != null && feeIdList.size() > 0 ){
            MUSW__Fee__c[] allCartFees = m_cs.getCartFees(true);
            for(MUSW__Fee__c fee : allCartFees){
                            if(feeIdList.contains(fee.id))
                                fees.add(fee);
                        }
            Decimal tempOutstanding = 0;
            for (MUSW__Fee__c f : fees){
                feeVOs.add(new FeeVO(f, true)); // here true means fee is selected by user
                tempOutstanding += f.MUSW__Outstanding_Fee__c;
                }
            m_totalOwed = tempOutstanding;
            totalSelected = tempOutstanding;
            totalSelectedOutstanding = tempOutstanding;
            // extract fees and receipt ends here
        }

        rs = new MUSW__Receipt__c[]{};
        rs.add(receipt);
        ReceiptVO newReceiptVO = new ReceiptVO(receipt, Decimal.valueOf(ePaymentRTPCData.PaymentAmount), m_rs);
        newReceiptVO.pmtMethodSelected=receipt.MUSW__Payment_Method__c;
        receiptVOs.add(newReceiptVO);
        cart.BGBK__Process_DateTime__c = System.now();
    }

    private void processEpayment(){
        if(cart.BGBK__Contact__c != null && cart.BGBK__Contact__r.Name == null) {
            Contact c = [SELECT Name,Email,AccountId From Contact WHERE Id =:cart.BGBK__Contact__c];
            cart.BGBK__Contact__r = c;
        }
        Map<MUSW__Receipt__c, Decimal> rsAmt = new Map<MUSW__Receipt__c, Decimal>();
        for (ReceiptVO rvo : receiptVOs){
            MUSW__Receipt__c receipt = rvo.r;
            rsAmt.put(receipt, rvo.amount);
        }
        if(!rs.isEmpty()){
            upsert rs;
        }
        preparePayables();
        try{
            Set<Id> feePaymentIds = new Set<Id>();
            processSuccessful = m_ps.processPayment(payables, rsAmt, accountSelected, cart.BGBK__Process_DateTime__c);
            if(processSuccessful){
                if(cart.BGBK__Last_Payment_Amount__c == null)
                    cart.BGBK__Last_Payment_Amount__c = Decimal.valueOf(ePaymentRTPCData.PaymentAmount);
                else
                    cart.BGBK__Last_Payment_Amount__c += Decimal.valueOf(ePaymentRTPCData.PaymentAmount);
                update cart;
            }else{
                response.addErrorMsg('Payment is not processed successfully');
                //cleanReceiptsAfterPaymentFail(receiptVOs);
            }

        }catch(Exception error){
            response.addErrorMsg('error occured '+error.getMessage());
            response.addErrorMsg(' stack trace '+error.getStackTraceString());
            //cleanReceiptsAfterPaymentFail(receiptVOs);
        }

    }

    private void preparePayables(){
        System.debug(' inside preparePayables'); 
        System.debug(' fee '+feeVos);
        System.debug(' invoiceVos '+invoiceVos);
        System.debug(' depositVOs '+depositVOs);

        payables = new BGBK.Payable[]{};
        
        for (FeeVO fvo : feeVos) if (fvo.isSelected && fvo.paymentAmount>0) payables.add(new BGBK.Payable(fvo.f, fvo.paymentAmount));
        for (InvoiceVO ivo : invoiceVos) if (ivo.isSelected && ivo.paymentAmount>0) payables.add(new BGBK.Payable(ivo.i, ivo.paymentAmount));
        for (DepositVO depVO : depositVOs){
            if(depVO.isSelected){
                payables.add(new BGBK.Payable(depVO.deposit, depVO.paymentAmount));
            }
        }
    }

    private static boolean isNotNullOrBlank(String input){
        if(input != null && input != '')
            return true;
        return false;
    }

    // Inner Classes required for Payment transactions
    private class FeeVO
    {
        public MUSW__Fee__c f { get; set; }
        public Boolean isSelected { get; set; }
        public Decimal paymentAmount { get; set; }
        public FeeVO(MUSW__Fee__c fee, Boolean sel)
        {
            f = fee;
            isSelected = sel;
            paymentAmount = f.MUSW__Outstanding_Fee__c;
        }
    }

    private class InvoiceVO
    {
        public BGBK__Bill__c i { get; set; }
        public Boolean isSelected { get; set; }
        public Decimal paymentAmount { get; set; }
        public InvoiceVO(BGBK__Bill__c inv)
        {
            i = inv;
            isSelected = true;
            paymentAmount = i.BGBK__Balance_Due__c;
        }
    }

    private class ReceiptVO
    {
        public MUSW__Receipt__c r { get; set; }
        public Decimal amount { get; set; }
        public BGBK__Payment__c existingPmt { get; set; }
        public MUSW__Payable_Receipt__c payableReceipt {get; set;}
        private BGBK.ReceiptService m_rs;
        private MUSW__Receipt__c m_backR; // backup receipt (used when r is overriden by existing receipt and we want the original receipt back)
        
        public ReceiptVO(MUSW__Receipt__c rec, Decimal amt, BGBK.ReceiptService rsvc)
        {
            r = rec;
            amount = amt;
            r.MUSW__Amount_Tendered__c = (r.MUSW__Amount_Tendered__c == null ? amount: (r.MUSW__Amount_Tendered__c-amount));            
            existingPmt = new BGBK__Payment__c();
            payableReceipt = new MUSW__Payable_Receipt__c();
            m_backR = rec;
            m_rs = rsvc;
        }
        
        /*  can also be an ex receipt id  */
        public String pmtMethodSelected
        {
            get;
            set
            {
                pmtMethodSelected = value;
                if (pmtMethodSelected.startsWith('a0c'))
                {
                    r = m_rs.getReceipt((Id)pmtMethodSelected);
                }
                else
                {
                    r = m_backR;
                    r.MUSW__Payment_Method__c = pmtMethodSelected;
                }
            }
        }
    }

    private class DepositVO
    {
        public MUSW__Deposit__c deposit { get; set; }
        public Boolean isSelected       { get; set; }
        public Decimal paymentAmount    { get; set; }

        public DepositVO(MUSW__Deposit__c dep)
        {
            deposit         = dep;
            paymentAmount   = dep.MUSW__Unpaid_Amount__c;
            isSelected      = true;
        }
    }

}