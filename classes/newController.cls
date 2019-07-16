public class newController {
  //   public FeeVO[] feeVOs { get; set; }
  //  public InvoiceVO[] invoiceVOs { get; set; }
  //  public ReceiptVO[] receiptVOs { get; set; }//
  //  public DepositVo[] depositVOs { get; set; }
    public BGBK__Cart__c cart { get; set; }
    public MUSW__Receipt__c[] rs { get; set; } // public for CartConfirm
    public MUSW__Fee__c[] fees { get; private set; } // public for CartConfirm
    public BGBK__Bill__c[] invoices { get; private set; } // public for CartConfirm
    public MUSW__Deposit__c[] deposits { get; private set; } // public for CartConfirm
    public MUSW__Fee_Payment__c[] feePayments {get; private set;}
    public MUSW__Fee_Payment__c[] invoicePayments {get; private set;}
    public MUSW__Payable_Receipt__c[] depositPayments {get; private set;}
    public Account a { get; set; }
    public Contact con { get; set; }
    public Id m_reconcileOriginalContact;
    public BGBK__Cart__c reconcileCart { get; private set;}
    public String email { get; set; }
    public String activeTab { get; set; }
    public Decimal totalSelected { get; set; }
    public Decimal totalSelectedOutstanding { get; set; }
    public String confirmMsg { get; set; }
    public String parentLabel { get; private set; }
    public Boolean isPortalUser { get; private set; }
    public boolean processSuccessful { get; set; }
    public String processResult { get; set; }
    public String processResultCode { get; set; }
    public string transactionId { get; set; }
    public String processStatus { get; private set; }
    public String cardMasked { get; set; }   
    public String accountSelected { get; set; }
    public Id feeSelected { get; set; }
    public Boolean canCreate { get; private set; }
    public Boolean canPayPartial { get; private set; }
    public Boolean canPayMulti { get; private set; }
    public Boolean canSelectReceipt { get; private set; }
    public Boolean checkReceiptAmount { get; private set; }
    public String itemsUnselected { get;set;}
    public Integer currentRowIndex {get; set;}
    public Integer delRecIndex {get; set;}
    public String feeIdsStr { get; set; }
    public String currURL { get; set; }
    public BGBK.Payable[] payables {get; set;}
    public Boolean keepPolling { get; set; }
    public Id jobId{ get; set; }
    public Id depositjobId{ get; set; }
    public String currentReceiptIndex{get;set;}     
    public Boolean isGatewayRequiredforPaymentMethod {get;private set;}     
    public String retUrl {get;set;}
    public Payment_Gateway_Settings__mdt paymentGatewaySettings {get; set;}
    public Id receiptId {get; set;}
    
    @TestVisible private BGBK.CartService m_cs;
    private BGBK.PaymentService m_ps;
    private BGBK.ReceiptService m_rs;
    private Id m_pid;
    @TestVisible private Id m_cartId;
    private Id m_invoiceId;
    private Id m_feeId;
    private Id m_depositAccountId;
    private String m_depositId;
    private Map<Id, MUSW__Fee__c> m_selectedFees;
    private Map<Id, MUSW__Deposit__c> m_depositsMap;
    @TestVisible private Map<Integer, MUSW__Deposit__c> m_depositsIndexMap;
    private Decimal m_totalOwed;
    private BGBK__CartSettings__c m_settings;
    @TestVisible private Map<BGBK.Payable, List<MUSW__Deposit__c>> m_payableDeposits;
    private Boolean m_isNotFromVF;
    private Boolean m_excludeGatewayPmtMethod;

    public newController(ApexPages.StandardSetController c){
        
    }
     public void initOrder()
    {
      /*  ApexPages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=10');
        // don't run if coming from Monexa
      
        if (m_pid == null && m_cartId == null && m_invoiceId == null && m_depositId == null && m_feeId==null && !UserInfo.getUserType().contains('CustomerSuccess') && UserInfo.getUserType() != 'CspLitePortal'){
         //   hardcodes
         //   return;
        } 
               
        con = m_cs.getActiveContact();
                    
        a = m_cs.getActiveAccount();
         cart = m_cs.getActiveCart();
        /* commented for a testing in elgin
        if(isPortalUser) cart = m_cs.getActiveCart();
        else    
        {
            cart = m_cs.getCart();
            if (cart.BGBK__Expiration_DateTime__c < System.now() || cart.BGBK__Status__c == 'Closed')
            {
                if (m_cartId != null)
                {
                    throw new BGCM.BGException('Cart is either closed or expired.', true);
                }
                else cart = m_cs.getActiveCart();
            }
        }
        */
      /*  if (m_selectedFees != null) m_cs.addFeesToCart(m_selectedFees.values());
        if (m_invoiceId != null) m_cs.addInvoicesToCart(new BGBK__Bill__c[]{new BGBK__Bill__c(Id=m_invoiceId)});
        if(m_depositId != null) addDepositsToCart();

        fees = m_cs.getCartFees(true);
        invoices = m_cs.getCartInvoices(true);
        deposits = m_cs.getCartDeposits(true);
        accountSelected = a.Id;
        if (con != null) email = con.Email;
        
        // remove invoiced fees from cart
        Set<Id> feesToRemove = new Set<Id>();
        Map<Id, BGBK__Bill__c> invoicesToAdd = new Map<Id, BGBK__Bill__c>();
        String invoicedFees = '';
        for (MUSW__Fee__c f : fees)
        {
            if (f.BGBK__Invoice__c != null)
            {
                feesToRemove.add(f.Id);
                invoicedFees += (invoicedFees=='')? f.MUSW__Type__c + ' (' + f.Name + ')': ', ' + f.MUSW__Type__c + ' (' + f.Name + ')';
                if (!invoicesToAdd.containsKey(f.BGBK__Invoice__c))
                {
                    invoicesToAdd.put(f.BGBK__Invoice__c, new BGBK__Bill__c(Id=f.BGBK__Invoice__c));
                }
            }
        } */
        
     /*   if (invoicesToAdd.size() > 0)
        {
            m_cs.addInvoicesToCart(invoicesToAdd.values());
            m_cs.removeFeesFromCart(feesToRemove);
            
            fees = m_cs.getCartFees(true); // re-query for fees
            invoices = m_cs.getCartInvoices(true); // re-query for invoices
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'The following fee(s) are already invoiced:'+invoicedFees + '. The corresponding invoices have been added to your cart');
            ApexPages.addMessage(myMsg);
        } */
        
        // add fees into VO objects
        
      /*  for (MUSW__Fee__c f : fees)
        {
            Boolean selected = m_selectedFees == null || m_selectedFees.containsKey(f.Id);
            feeVOs.add(new FeeVO(f, selected));
            m_totalOwed += f.MUSW__Outstanding_Fee__c;
            
            if (selected)
            {
                totalSelected += f.MUSW__Outstanding_Fee__c;
                totalSelectedOutstanding += f.MUSW__Outstanding_Fee__c;
            }
        }  */
        
        // add invoices into VO objects
        
/*for (BGBK__Bill__c i : invoices)
        {
            invoiceVOs.add(new InvoiceVO(i));
            m_totalOwed += i.BGBK__Balance_Due__c;
            totalSelected += i.BGBK__Balance_Due__c;
            totalSelectedOutstanding += i.BGBK__Balance_Due__c;
        }  */

     /*   Decimal depositsUnpaid   = populateDepositVOs();

        m_totalOwed   += depositsUnpaid;
        totalSelected += depositsUnpaid;
        totalSelectedOutstanding += depositsUnpaid;
        
        // initialize receipt
        rs = new MUSW__Receipt__c[]{};
        
      //  addReceipt();
       // receiptVOs[0].pmtMethodSelected = pmtMethods[0].getValue();
        // update cart amount
        cart.BGBK__Total_Amount__c = m_totalOwed;
        update cart;
          
        // set Process Date
        cart.BGBK__Process_DateTime__c = System.now();*/
        // set the payables that might be needed for portal users
       // preparePayables();
    }
    

}