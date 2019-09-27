/**
* User Story: ****
* Class Name: DOL_ProcessPayment
* Test Class Name: ****
* Description: Class to implement functionality for process payment
                Called from ePayment related classes
* Date:        Developer/Company                    Description
* ------------------------------------------------------------------------------------------------*
* 07/08/2019   Laltu Banerjee/Deloitte           Initial Creation
**/
public class DOL_ProcessPayment {

    public FeeVO[] feeVOs;
    public ReceiptVO[] receiptVOs;

    private BGBK.CartService m_cs;
    private BGBK.PaymentService m_ps;
    private BGBK.ReceiptService m_rs;
    private BGBK__Cart__c cart;
    private Account acc ;
    private String accountSelected ;
    private BGBK.Payable[] payables ;

    private Id payeeContactId;
    private Id cartId;
    private List<String> feeIdList;
    private MUSW__Receipt__c receipt;
    private Decimal paymentAmount;
    private Id receiptId;
    
    public DOL_ProcessPayment(Id payeeContactId, Id cartId, 
                            List<String> feeIdList, MUSW__Receipt__c receipt,
                            Decimal paymentAmount ) {
        this.payeeContactId = payeeContactId;
        this.cartId = cartId;
        this.feeIdList = feeIdList;
        this.receipt = receipt;
        this.paymentAmount = paymentAmount;
    }

    public void doPayment(){
        validateInput();
        initFinancialObject();
        processEpayment();
    }

    private void validateInput(){
        if(feeIdList == null || receipt == null || paymentAmount == null || cartId == null)
            throw new CustomException('Required Field is not present Input, feeIdList = '
                                        +feeIdList+' receipt = '+receipt+' paymentAmount = '
                                        +paymentAmount+' cartId = '+cartId);
    }

    private void validateNCRInput(){
        if(feeIdList == null || receipt == null || paymentAmount == null )
            throw new CustomException('Required Field is not present Input, feeIdList = '
                                        +feeIdList+' receipt = '+receipt+' paymentAmount = '
                                        +paymentAmount+' cartId = '+cartId);
    }

    private void initFinancialObject(){
        MUSW__Fee__c[] allCartFees;
        feeVOs = new FeeVO[]{};
        receiptVOs = new ReceiptVO[]{};

        m_ps = new BGBK.PaymentService();
        m_rs = new BGBK.ReceiptService();

        accountSelected = receipt.MUSW__Paid_By__c;

        if( feeIdList != null && ! feeIdList.isEmpty() ){
            String queryString = DOL_AppUtility.getQueryString('MUSW__Fee__c');
            queryString += ' where id IN :feeIdList';
            allCartFees = (List<MUSW__Fee__c>)Database.query(queryString);
            for(MUSW__Fee__c fee : allCartFees ){
                feeVOs.add(new FeeVO(fee, true));
            }
            receipt.MUSW__Amount_Tendered__c = null;
            receipt.Status__c = 'Complete';
            ReceiptVO newReceiptVO = new ReceiptVO(receipt, paymentAmount, m_rs);
            newReceiptVO.pmtMethodSelected=receipt.MUSW__Payment_Method__c;
            receiptVOs.add(newReceiptVO);
        }else{
            throw new CustomException('Fee Id List found null or Blank');
        }
    }

    private void processEpayment(){
        Savepoint sp = null;
        Boolean processSuccessful = false;
        Map<MUSW__Receipt__c, Decimal> rsAmt = new Map<MUSW__Receipt__c, Decimal>();
        for (ReceiptVO rvo : receiptVOs){
            MUSW__Receipt__c receipt = rvo.r;
            rsAmt.put(receipt, rvo.amount);
        }
        preparePayables();
        try{
            sp = Database.setSavePoint();
            update receipt;
            processSuccessful = m_ps.processPayment(payables, rsAmt, accountSelected, System.now());
            if(! processSuccessful){
                throw new CustomException('BGBK Method Failed to process payment , Payment not succeded');
            }
        }
        catch(Exception error){
            if(sp != null)
                    Database.rollback(sp);
            throw error;
        }
        
    }

    // Below method will be used for NCR Payment
    // Rollback is not required here,
    // Rollback is in place APEX class DOL_Process_NCR_Data_Batch
    public void doPaymentForNCR(){
        validateNCRInput();
        MUSW__Fee__c[] allCartFees;
        feeVOs = new FeeVO[]{};
        receiptVOs = new ReceiptVO[]{};

        m_ps = new BGBK.PaymentService();
        m_rs = new BGBK.ReceiptService();

        accountSelected = receipt.MUSW__Paid_By__c;

        String queryString = DOL_AppUtility.getQueryString('MUSW__Fee__c');
        queryString += ' where id IN :feeIdList';
        allCartFees = (List<MUSW__Fee__c>)Database.query(queryString);
        for(MUSW__Fee__c fee : allCartFees ){
            feeVOs.add(new FeeVO(fee, true));
        }

        receipt.MUSW__Amount_Tendered__c = null;
        receipt.Status__c = 'Complete';
        ReceiptVO newReceiptVO = new ReceiptVO(receipt, paymentAmount, m_rs);
        newReceiptVO.pmtMethodSelected=receipt.MUSW__Payment_Method__c;
        receiptVOs.add(newReceiptVO);

        Boolean processSuccessful = false;
        Map<MUSW__Receipt__c, Decimal> rsAmt = new Map<MUSW__Receipt__c, Decimal>();
        for (ReceiptVO rvo : receiptVOs){
            MUSW__Receipt__c receipt = rvo.r;
            rsAmt.put(receipt, rvo.amount);
        }

        preparePayables();
        try{
            update receipt;
            processSuccessful = m_ps.processPayment(payables, rsAmt, accountSelected, System.now());
            if(! processSuccessful){
                throw new CustomException('BGBK Method Failed to process payment , Payment not succeded');
            }
        }
        catch(Exception error){
            throw error;
        }
    }

    private void preparePayables(){     
        payables = new BGBK.Payable[]{};
        for (FeeVO fvo : feeVos) 
        {
            if (fvo.isSelected && fvo.paymentAmount>0)
                payables.add(new BGBK.Payable(fvo.f, fvo.paymentAmount));
        }
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
        
        /* /*  can also be an ex receipt id  */
        
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

    

    // Inner Class end

}