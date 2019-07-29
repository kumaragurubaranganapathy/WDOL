global class DOL_Epayment_ProcessRemittanceData implements Database.Batchable<sObject> {
    
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
    private DOL_EpaymentRemittanceInput tempRemittanceInput { get; set; }
    private DOL_Integration_Batch_Input__c tempRecord {get; set; }
    private MUSW__Receipt__c receipt {get; set; }
    private Map<String,String> parameterMap {get; set; }

    private String cartId = '',SFDCfeeIds='',SFDCappId='',receiptId = '';

    private DOL_Dao dao = new DOL_Dao();

    global DOL_Epayment_ProcessRemittanceData(){
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        System.debug('DOL_Epayment_ProcessRemittanceData::start...');
        return Database.getQueryLocator([ select id, File_Name__c, INFO__c, Input__c, Status__c, Input_Type__c from DOL_Integration_Batch_Input__c where Status__c = 'UNPROCESSED' and Input_Type__c = 'REMITTANCE' ]);
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

                    if(isNotNullOrBlank(receiptId)){
                        receipt = new MUSW__Receipt__c(id=receiptId);
                    }
                    
                    if(receipt != null){
                        updateReceiptFromRemittanceInput(tempRemittanceInput,receipt);
                        DOL_Dao.save(receipt);
                        if(! isPaymentRecorded()){
                            initFinancialObject();
                            processEpayment();
                        }
                        isRecordProcessed = true;
                        tempRecord.INFO__c += 'Record processed successfully';
                    }
                    else{
                        tempRecord.INFO__c += 'Receipt Id not found or not valid';
                    }
                    
                }catch(Exception error){
                    tempRecord.INFO__c += 'error occured :- '+error.getMessage()+' stack trace '+error.getStackTraceString();
                }
                if(isRecordProcessed)
                    tempRecord.Status__c = 'Processed';
                else
                    tempRecord.Status__c = 'Failed';
            }
            DOL_Dao.save(remittanceRecords);
        }
    }
    
    global void finish(Database.BatchableContext BC){   
    
    }

    private void updateReceiptFromRemittanceInput(DOL_EpaymentRemittanceInput remittanceData, MUSW__Receipt__c receipt){
        if(isNotNullOrBlank(remittanceData.transactionConfirmationId))
            receipt.MUSW__Payment_Gateway_Transaction_Number__c = remittanceData.transactionConfirmationId;
        if(isNotNullOrBlank(remittanceData.paymentMethod)){
            receipt.MUSW__Payment_Method__c = remittanceData.paymentMethod;
            if(receipt.MUSW__Payment_Method__c == 'CC')
                receipt.MUSW__Payment_Method__c = 'Credit Card';
        }
        if(isNotNullOrBlank(remittanceData.dueDate))
            receipt.Date__c = DOL_AppUtility.getDate(remittanceData.dueDate,'YYYYMMDD');
        if(isNotNullOrBlank(remittanceData.paymentAmount))
            receipt.MUSW__Amount_Tendered__c = Decimal.valueOf(remittanceData.paymentAmount);
        if(isNotNullOrBlank(remittanceData.totalAmount))
            receipt.MUSW__Amount_Tendered__c = Decimal.valueOf(remittanceData.totalAmount);
        if(isNotNullOrBlank(remittanceData.paymentEffectiveDate))
            receipt.MUSW__Effective_Date__c = DOL_AppUtility.getDate(remittanceData.paymentEffectiveDate,'YYYYMMDD');
        if(isNotNullOrBlank(remittanceData.billerBusinessDate))
            receipt.ACH_BillerBusinessDate__c = DOL_AppUtility.getDate(remittanceData.billerBusinessDate,'YYYYMMDD');
        if(isNotNullOrBlank(remittanceData.initiationDate) && isNotNullOrBlank(remittanceData.initiationTime))
            receipt.Initiation_Date_and_Time__c = DOL_AppUtility.getDateTime(remittanceData.initiationDate+' '+remittanceData.initiationTime,'YYYYMMDD HHmmSS');
        if(isNotNullOrBlank(remittanceData.paymentMethod))
            receipt.MUSW__Payment_Method__c = remittanceData.paymentMethod;
        if(isNotNullOrBlank(remittanceData.cardType))
            receipt.MUSW__Card_Type__c = remittanceData.cardType;
        if(isNotNullOrBlank(remittanceData.lastFourAccountNumber) && DOL_AppUtility.isValidDecimalValue(remittanceData.lastFourAccountNumber) )
            receipt.Last_4_digits_of_Credit_Card_or_ACH__c = Decimal.valueOf(remittanceData.lastFourAccountNumber);
        if(isNotNullOrBlank(remittanceData.paymentAuthorization))
            receipt.Card_Authorized__c = remittanceData.paymentAuthorization;
        if(isNotNullOrBlank(remittanceData.paymentStatus))
            receipt.US_Bank_Payment_Status__c = remittanceData.paymentStatus;
        if(isNotNullOrBlank(remittanceData.firstName))
            receipt.Payer_First_Name__c = remittanceData.firstName;
        if(isNotNullOrBlank(remittanceData.lastName))
            receipt.Payer_Last_Name__c = remittanceData.lastName;
        if(isNotNullOrBlank(remittanceData.companyName))
            receipt.Company_Name__c = remittanceData.companyName;

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
        ReceiptVO newReceiptVO = new ReceiptVO(receipt, Decimal.valueOf(tempRemittanceInput.PaymentAmount), m_rs);
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
                    cart.BGBK__Last_Payment_Amount__c = Decimal.valueOf(tempRemittanceInput.PaymentAmount);
                else
                    cart.BGBK__Last_Payment_Amount__c += Decimal.valueOf(tempRemittanceInput.PaymentAmount);
                update cart;
            }else{
                 tempRecord.INFO__c += 'Payment is not processed successfully';
                cleanReceiptsAfterPaymentFail(receiptVOs);
            }

        }catch(Exception error){
            tempRecord.INFO__c += 'error occured '+error.getMessage();
            //response.addErrorMsg(' stack trace '+error.getStackTraceString());
            cleanReceiptsAfterPaymentFail(receiptVOs);
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

    @TestVisible private void cleanReceiptsAfterPaymentFail(ReceiptVO[] recVos)      
    {       
        Set<Id> recToInspectForDel = new Set<Id>();     
        MUSW__Receipt__c[] recToDel = new MUSW__Receipt__c[]{};     
        for(ReceiptVO rec : recVos){        
            if(rec.pmtMethodSelected != 'Deposit' || rec.pmtMethodSelected != 'Other')      
                recToInspectForDel.add(rec.r.Id);       
        }       
        if(recToInspectForDel.size() > 0) {     
            MUSW__Receipt__c[] receiptsToDel = [SELECT Id, MUSW__Amount_Tendered__c,MUSW__Amount_Available__c FROM MUSW__Receipt__c WHERE ID in:recToInspectForDel];        
            for(MUSW__Receipt__c receipt : receiptsToDel) {     
                if(receipt.MUSW__Amount_Tendered__c == receipt.MUSW__Amount_Available__c)       
                    recToDel.add(receipt);      
            }       
            if(recToDel.size() > 0){
                delete recToDel;
                //response.addLog('receipt Deleted due to payment failure');
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