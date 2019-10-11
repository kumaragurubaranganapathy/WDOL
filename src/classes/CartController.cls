public with sharing class CartController
{
    public FeeVO[] feeVOs { get; set; }
    public InvoiceVO[] invoiceVOs { get; set; }
    public ReceiptVO[] receiptVOs { get; set; }
    public DepositVo[] depositVOs { get; set; }
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
    public Contact objContact { get; set; }// US 1976
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
    public Boolean isBusinessCart { get; set; } // US 1976
    public Boolean canPayPartial { get; private set; }
    public Boolean canPayMulti { get; private set; }
    public Boolean isFeeTransfer { get; private set; }
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
    private Id m_accId;
    
    public string isBLic; 
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
    //card
    public Decimal amountTendered {get; set;}
    public boolean checkNumber  {get; set;}
    public String batchNum      {get; set;}
    public String paymentComment {get; set;}
    public String transactionNum {get; set;}
    
    public String encryptedSessionInfo {get; set;}
    public boolean requestFromEPayment {get; set;}
    public DOL_ePaymentReturnSession ePaymentReturnSession {get; set;}
    public String isBisuneesLic {get;set;}
    public string checkOptionName {get;set;} //- Added as a part of bug 6337 by Abhilasha 
    
    public CartController(ApexPages.StandardSetController c)
    {
        checkOptionName = DOL_AppConstants.CASHIER_CHECK;//'Check/Cashier\'s Check'; // Added as a part of bug 6337 by Abhilasha
        processSuccessful = false;
        totalSelected = 0;
        totalSelectedOutstanding = 0;
        m_totalOwed = 0;
        isPortalUser = BGCM.UtilityUser.isPortalUser();
        //system.debug('isPortalUser123'+isPortalUser);
        //Code to avoid 
        //isPortalUser = false; // This variable need to be false for portal
        currURL = String.valueOf(URL.getSalesforceBaseUrl().toExternalForm());
        m_isNotFromVF = false;
        checkReceiptAmount = true;
        isBisuneesLic =System.currentPageReference().getParameters().get('isBLic');
        //Check if it is business cart
        isBusinessCart = false;
        if(isPortalUser){
            objContact =[SELECT id,Name,BusinessCartToOpen__c from contact where id in (select contactid from user where id =: userinfo.getUserId())];
            if (objContact!=null && objContact.BusinessCartToOpen__c != null){
                m_accId =objContact.BusinessCartToOpen__c;
                isBusinessCart = true;
            }
        }
        
        encryptedSessionInfo = System.currentPageReference().getParameters().get('session');
        if( encryptedSessionInfo != null){
            activeTab = DOL_AppConstants.CONFIRM_STRING;//'confirm';
            requestFromEPayment = true;
            String decryptedSessionData = DOL_ePaymentSessionTransfer.decryptSessionData(encryptedSessionInfo);
            ePaymentReturnSession = new DOL_ePaymentReturnSession();
            ePaymentReturnSession.mapDataFromSessionString(decryptedSessionData);
            m_cartId = ePaymentReturnSession.SFDCId;
        }
        else{
            activeTab = DOL_AppConstants.FEE_STRING;//'fees';
            requestFromEPayment = false; 
            m_pid = System.currentPageReference().getParameters().get('id');
            isBLic = System.currentPageReference().getParameters().get('isBLic');
            system.debug('m_pid$$'+m_pid);
            m_cartId = System.currentPageReference().getParameters().get('cartId');
            m_invoiceId = System.currentPageReference().getParameters().get('invoiceId');
            m_depositId = System.currentPageReference().getParameters().get('depositId');
            m_feeId = System.currentPageReference().getParameters().get('feeId');
            m_depositAccountId = System.currentPageReference().getParameters().get('depositAccountId')==''?null:System.currentPageReference().getParameters().get('depositAccountId');
            retURL = System.currentPageReference().getParameters().get('retURL');
        }

        //retURL = 'https://dev-polaris.cs32.force.com/Dashboard';
        if (m_pid != null) m_pid = String.escapeSingleQuotes(m_pid);
        
        if (m_cartId != null) m_cartId = String.escapeSingleQuotes(m_cartId);
        if (m_invoiceId != null) m_invoiceId = String.escapeSingleQuotes(m_invoiceId);
        
        // instantiate service layer
        if (m_invoiceId != null)
        {
            BGBK__Bill__c inv = [select BGBK__Recipient2__c from BGBK__Bill__c where Id = :m_invoiceId];
            m_cs = new BGBK.CartService(inv.BGBK__Recipient2__c);
            system.debug('the if m_cs' +m_cs);
            
        }
        else if (m_depositAccountId != null)
        {
            m_cs = new BGBK.CartService(m_depositAccountId);
            system.debug('the else if m_cs' +m_cs);
            
        }
        else if (m_accId != null)
        {
        system.debug('Account id ##$$ m_cs' +m_accId);
            m_cs =  new BGBK.CartService(m_accId);
            system.debug('Account cart ##$$ m_cs' +m_cs);
            
        }
        else {
            m_cs = (m_pid != null || m_cartId != null) ? new BGBK.CartService(m_pid, m_cartId) : new BGBK.CartService();
        system.debug('the else m_cs' +m_cs);
        
        }
        m_ps = new BGBK.PaymentService();
        m_rs = new BGBK.ReceiptService();
        m_payableDeposits = new Map<BGBK.Payable, List<MUSW__Deposit__c>>();
        m_depositsMap = new Map<Id, MUSW__Deposit__c>();
        m_depositsIndexMap = new Map<Integer, MUSW__Deposit__c>();
        m_excludeGatewayPmtMethod = false;
        isGatewayRequiredforPaymentMethod = false;
        checkReceiptAmount = true;
        
        canCreate = m_ps.canCreate();
        feeVOs = new FeeVO[]{};
        invoiceVOs = new InvoiceVO[]{};
        receiptVOs = new ReceiptVO[]{};
        depositVOs = new DepositVO[]{};
        // manual Add to Cart (add fees on parent to m_selectedFees list)
        if (m_pid != null)
        {
            m_selectedFees = new Map<Id, MUSW__Fee__c>((List<MUSW__Fee__c>)c.getSelected());
        }
        else if(m_feeId!=null)    // ELGIN-232
        {
            m_selectedFees = new Map<Id,MUSW__Fee__c>();
            m_selectedFees.put(m_feeId,new MUSW__Fee__c(Id=m_feeId));
        }
        
        // control parameters for internal users based on cart settings
        m_settings = BGBK__CartSettings__c.getValues('Default');
        if (m_settings != null)
        {
            canPayPartial = Boolean.valueOf(m_settings.BGBK__Allow_Partial_Payments__c) && !isPortalUser;
            canPayPartial = false; 
            canPayMulti = Boolean.valueOf(m_settings.BGBK__Allow_Multiple_Payment_Methods__c) && !isPortalUser;
            canSelectReceipt = Boolean.valueOf(m_settings.BGBK__Allow_Existing_Receipt__c) && !isPortalUser;
        }
        else
        {
            throw new BGCM.BGException('Default Cart Settings are missing.', true);
        }
        system.debug('contact = '+ m_cs.getActiveContact() );
        paymentGatewaySettings = [Select Id, DeveloperName, Endpoint__c, Biller_ID__c, Biller_Group_ID__c, Product_Code__c From Payment_Gateway_Settings__mdt where DeveloperName = 'US_Bank_Settings' limit 1];
        
        
    }
    
    public void initOrder()
    {
         //clearoff account id from contact US 1976
         
        if(isPortalUser && objContact.BusinessCartToOpen__c != ''){
            objContact.BusinessCartToOpen__c =DOL_AppConstants.NULL_EMPTY_STRING;//'';
            update objContact;
        }
        
        ApexPages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=10');
        // don't run if coming from Monexa
        if (m_pid == null && m_cartId == null && m_invoiceId == null && m_depositId == null && m_feeId==null && !UserInfo.getUserType().contains('CustomerSuccess') && UserInfo.getUserType() != 'CspLitePortal') return;
        system.debug('m_pid::'+m_pid);
        system.debug('m_cartId::'+m_cartId);
        system.debug('m_invoiceId::'+m_invoiceId);
        system.debug('m_depositId::'+m_depositId);
        system.debug('m_feeId::'+m_feeId);
        con = m_cs.getActiveContact();            
         a = m_cs.getActiveAccount();
         cart = m_cs.getActiveCart();
        if(isBusinessCart){
          con = objContact; 
          cart.BGBK__Contact__c =objContact.id;
        }
        
        if(requestFromEPayment){
            system.debug('isnide first if');
            
            if(a != null)
                accountSelected = a.Id;
            invoices = m_cs.getCartInvoices(true);
            deposits = m_cs.getCartDeposits(true);
            
            system.debug('isnide first if con' +con);
            system.debug('isnide first if a' +a);
            if (con != null) email = con.Email;
            system.debug('a.Email__c$$'+a.Email__c);
            if(isBusinessCart) {
                Account objAcc = [select Email__c from Account where id =: a.id];
                email= objAcc.Email__c;// US 1976
            }
            List<String> feeIdList = ePaymentReturnSession.sfdcFeeIds;
            system.debug('feeIdList = '+feeIdList);
            fees = new List<MUSW__Fee__c>();
            if( feeIdList != null && feeIdList.size() > 0 ){
                MUSW__Fee__c[] allCartFees = m_cs.getCartFees(true);
                system.debug('allCartFees1$$'+allCartFees);
                for(MUSW__Fee__c fee : allCartFees){
                    if(feeIdList.contains(fee.id))
                        fees.add(fee);
                }
                Decimal tempOutstanding = 0;
                for (MUSW__Fee__c f : fees){
                    system.debug('feessss'+f);
                    feeVOs.add(new FeeVO(f, true)); // here true means fee is selected by user
                    tempOutstanding += f.MUSW__Outstanding_Fee__c;
                }
                m_totalOwed = tempOutstanding;
                totalSelected = tempOutstanding;
                totalSelectedOutstanding = tempOutstanding;
            }
			//defect 8051
			if(invoices.size()>0){
				Set<Id> invoiceIds = new Set<Id>();
				map<id,BGBK__Bill__c> mapInvoiceIdInvoice = new map<id,BGBK__Bill__c>();
				for(BGBK__Bill__c objInvoice : invoices){
					invoiceIds.add(objInvoice.id);
					mapInvoiceIdInvoice.put(objInvoice.id, objInvoice);
					
				}
				List<MUSW__Fee__c> invoiceFee = DOL_License_Linking.fetchFeeFromInvoice(invoiceIds);
				system.debug('invoiceFee$$'+invoiceFee);
				system.debug('feeIdList$$'+feeIdList);
				invoices = new List<BGBK__Bill__c>();
				for(MUSW__Fee__c objFee: invoiceFee){
					if(feeIdList.contains(objFee.id) &&(!invoices.contains(mapInvoiceIdInvoice.get(objFee.BGBK__Invoice__c))) ){
						//if(!InvoiceVOs.contains(new InvoiceVO(mapInvoiceIdInvoice.get(objFee.BGBK__Invoice__c))))
						invoiceVOs.add(new InvoiceVO(mapInvoiceIdInvoice.get(objFee.BGBK__Invoice__c)));
						invoices.add(mapInvoiceIdInvoice.get(objFee.BGBK__Invoice__c));
					}
				}
			}
			system.debug('InvoiceVOs$$'+invoiceVOs);

            system.debug('Intializing receipt');
            // initialize receipt
            rs = new MUSW__Receipt__c[]{};
                if(ePaymentReturnSession.TransactionConfirmationID != null && 
                   ePaymentReturnSession.TransactionConfirmationID != ''){
                       system.debug('Transaction id:-'+ePaymentReturnSession.TransactionConfirmationID);
                       String tempReceiptId = ePaymentReturnSession.ReturnValue;
                       if(tempReceiptId == null || tempReceiptId == ''){
                           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Receipt Id is absent in the response, which is required to complete the transaction. Please contact ePayment gateway');
                           ApexPages.addMessage(myMsg);
                           return;
                       }
                       receiptId=tempReceiptId;
                       MUSW__Receipt__c receipt = [select id,Status__c,MUSW__Payment_Method__c from MUSW__Receipt__c where id =: receiptId FOR UPDATE];
                       //Boolean paymentProcessed = updateReceipt(tempReceiptId,ePaymentReturnSession.TransactionConfirmationID);
                       if(receipt == null){
                           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Receipt with Id ='+receiptId+' is not present in Salesforce');
                           ApexPages.addMessage(myMsg);
                           return;
                       }
						receipt.MUSW__Paid_By__c=accountSelected;
						receipt.BGBK__Cart__c =cart.Id;

                       ePaymentReturnSession.updateReceipt(receipt);
                       if(receipt.Status__c == 'Complete'){
                            update receipt;
                            onPaymentConfirmation();
                       }
                       else{
                            receipt.Status__c = DOL_AppConstants.COMPLETE_STRING;//'Complete';
                            receipt.MUSW__Amount_Tendered__c = null;
                            rs.add(receipt);
                            ReceiptVO newReceiptVO = new ReceiptVO(receipt, Decimal.valueOf(ePaymentReturnSession.PaymentAmount), m_rs);
                            newReceiptVO.pmtMethodSelected=receipt.MUSW__Payment_Method__c;
                            receiptVOs.add(newReceiptVO);
                            cart.BGBK__Process_DateTime__c = System.now();
                    processEPayment(receipt);
                       }
                   }
            else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'ePayment Transaction is failed');
                ApexPages.addMessage(myMsg);
                return;
            }
        }
        else{
            
            // cart = m_cs.getCart();
            system.debug('cart$$'+cart);
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
            if (m_selectedFees != null) m_cs.addFeesToCart(m_selectedFees.values());
            if (m_invoiceId != null) m_cs.addInvoicesToCart(new BGBK__Bill__c[]{new BGBK__Bill__c(Id=m_invoiceId)});
            if(m_depositId != null) addDepositsToCart();

            fees = m_cs.getCartFees(true);
             system.debug('fees$$'+fees);
            invoices = m_cs.getCartInvoices(true);
            deposits = m_cs.getCartDeposits(true);
            if(a != null)
                accountSelected = a.Id;
            system.debug('the accountSelected' +accountSelected);
            system.debug('the con is' +con);
            if (con != null) email = con.Email;
            if(isBusinessCart) {
                Account objAcc = [select Email__c from Account where id =: a.id];
                email= objAcc.Email__c;// US 1976
                system.debug('email$$$'+email);
                
            }
            
            // remove invoiced fees from cart
            Set<Id> feesToRemove = new Set<Id>();
            Map<Id, BGBK__Bill__c> invoicesToAdd = new Map<Id, BGBK__Bill__c>();
            String invoicedFees = DOL_AppConstants.NULL_EMPTY_STRING;//'';
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
            }
            
            if (invoicesToAdd.size() > 0)
            {
                m_cs.addInvoicesToCart(invoicesToAdd.values());
                m_cs.removeFeesFromCart(feesToRemove);
                
                fees = m_cs.getCartFees(true); // re-query for fees
                system.debug('fees$$'+fees);
                invoices = m_cs.getCartInvoices(true); // re-query for invoices
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'The following fee(s) are already invoiced:'+invoicedFees + '. The corresponding invoices have been added to your cart');
                ApexPages.addMessage(myMsg);
            }
            
            // add fees into VO objects
            
            for (MUSW__Fee__c f : fees)
            {
                system.debug('feessss'+f);
                //commenting as a part of bug 7018
               /* Boolean selected;
                if(m_selectedFees != null){
                    selected = m_selectedFees.containsKey(f.Id);
                }else{
                    selected = false;
                }*/
                //commented as a part of bug 5532 by Abhilasha
                //uncommenting as a part of bug 7018
                //setting true so that all fees are selected on cart load as a part of bug 7326
                //Boolean selected = m_selectedFees == null || m_selectedFees.containsKey(f.Id);
                Boolean selected = true;
				feeVOs.add(new FeeVO(f, selected));
                m_totalOwed += f.MUSW__Outstanding_Fee__c;
                
                if (selected)
                {
                    totalSelected += f.MUSW__Outstanding_Fee__c;
                    totalSelectedOutstanding += f.MUSW__Outstanding_Fee__c;
                }
            }
            
            // add invoices into VO objects
            
            for (BGBK__Bill__c i : invoices)
            {
                invoiceVOs.add(new InvoiceVO(i));
                m_totalOwed += i.BGBK__Balance_Due__c;
                totalSelected += i.BGBK__Balance_Due__c;
                totalSelectedOutstanding += i.BGBK__Balance_Due__c;
            }

            Decimal depositsUnpaid   = populateDepositVOs();

            m_totalOwed   += depositsUnpaid;
            totalSelected += depositsUnpaid;
            totalSelectedOutstanding += depositsUnpaid;
            
            // initialize receipt
            rs = new MUSW__Receipt__c[]{};
            
            addReceipt();
            receiptVOs[0].pmtMethodSelected = pmtMethods[0].getValue();
            // update cart amount
            system.debug('the value of cart is' +cart);
            cart.BGBK__Total_Amount__c = m_totalOwed;
            update cart;
            
            // set Process Date
            cart.BGBK__Process_DateTime__c = System.now();
            // set the payables that might be needed for portal users
            preparePayables();
        }
    }
    
    /**
     * ELGIN-264: show total payment
     */    
    public Decimal totalPayment
    {
        get
        {
            Decimal total = 0;
            for (ReceiptVO rvo : receiptVOs)
            {
                  if(rvo.amount!=null)
                    total += rvo.amount;
            }
            return total;
        }
    }
    
    
    /*
    * Method to return all available payment methods
    */
    public Selectoption[] pmtMethods
    {
        get
        {
            pmtMethods = new Selectoption[]{};
            List<String> BackOffice_Payment_MethodsList = System.Label.BackOffice_Payment_Methods.split(',');
            //initial payment method OR
            //multiple payment methods where initial payment method is not Deposit
            if(receiptVOs.size() <= 1 || receiptVOs[0].pmtMethodSelected != 'Deposit') 
            {
                String includeGateway = m_excludeGatewayPmtMethod?' AND BGBK__isGateway_Required__c = false':'';
                BGBK__Payment_Method__mdt[] methods = Database.query('SELECT DeveloperName, Label, BGBK__isPortal_Accessible__c, BGBK__isGateway_Required__c'
                                                                +' from BGBK__Payment_Method__mdt WHERE BGBK__isActive__c = true'
                                                                + includeGateway
                                                                +' order by BGBK__Order__c ASC');
                
                // Parse Custom Metadata type Payment Methods and construct the select option pmtMethods
                for(BGBK__Payment_Method__mdt method : methods) {
                    // If its a internal we show, or if we are a portal user, the method should be portal accessible
                    if (isPortalUser && method.BGBK__isPortal_Accessible__c) {
                        pmtMethods.add(new SelectOption(method.Label,method.Label));
                    }
                    if(!isPortalUser){
                        if(BackOffice_Payment_MethodsList != null){
                            if(BackOffice_Payment_MethodsList.contains(method.Label)){
                                pmtMethods.add(new SelectOption(method.Label,method.Label));
                            }
                        } 
                    }
                }

                //don't include Deposit if multiple payment methods where initial payment method is not Deposit
               if(m_settings.BGBK__Allow_Pay_By_Deposit__c && deposits.size() == 0 && receiptVOs.size() <= 1){
                    if(!isPortalUser){  // Added the check to remove deposit option for Portal user as per demo feedback [Chiranth 7/25/2019]
                        pmtMethods.add(new SelectOption('Deposit', 'Deposit'));
                    }
                }

                //Add 'Exisiting Receipt' payment method
                if(!isPortalUser && canSelectReceipt)
                {
                    pmtMethods.add(new Selectoption('Other', 'Existing Receipt'));
                }
            }
            else //multiple payment methods where initial paymenth method is Deposit
            {  
                if(m_settings.BGBK__Allow_Pay_By_Deposit__c && deposits.size() == 0){
                    pmtMethods.add(new SelectOption('Deposit', 'Deposit'));
                }
            }
            //Removing sort as a part of BUG: 6985
            //pmtMethods.sort(); // added by Abhilasha as a part of CR:6292
            return pmtMethods;
        }
        set;
    }

    /*
    * Method to give a map of the receiptfields according to the payment method
    */
    public Map<String,String[]> receiptFields
    {
        get
        {
            receiptFields = new Map<String,String[]>();
            // set that will contain all the fields of receipt object
            Set<String> receiptFieldSet = Schema.SObjectType.MUSW__Receipt__c.fields.getMap().keySet();
            // Verify if the specified fields in the custom settings exists, and if yes, construct the field map 
            for(BGBK__Payment_Method__mdt method:[select DeveloperName, Label,BGBK__Receipt_Fields__c from BGBK__Payment_Method__mdt WHERE BGBK__isActive__c = true]) {
                if(method.BGBK__Receipt_Fields__c != null) {
                    String [] verifiedReceiptFields = new String[]{};
                    for(String field : method.BGBK__Receipt_Fields__c.split(',') ){
                        field = field.trim();
                        if(receiptFieldSet.contains(field.toLowerCase()))
                            verifiedReceiptFields.add(field);
                    }
                    receiptFields.put(method.Label,verifiedReceiptFields);
                }
                else 
                    receiptFields .put(method.Label,new String[]{});
            }
            // put the payment method not contained in the custom metadata type
            receiptFields.put('Other',new String[]{});
            receiptFields.put('Deposit',new String[]{});
            return receiptFields ;
        }
        set;
    }
    
    private Account[] m_accs = new Account[]{};
    public List<SelectOption> accounts
    {
        get
        {
            if (accounts == null)
            {
                accounts = new List<SelectOption>();
                m_accs = m_cs.getAccountList();
                for (Account acc : m_accs)
                {            
                    //throw new BGCM.BGException('Account : '+acc, true);
                    String addr = (acc.BillingStreet!= null) ? ' / ' + acc.BillingStreet: '';
                    accounts.add(new SelectOption(String.valueOf(acc.Id), acc.Name + addr));
                }    
            }
            
            return accounts;
        }
        set;
    }
    
    /*public void removeFee()
    {
         m_cs.removeFeeFromCart(feeSelected);
    }*/
    
    public void accountChanged()
    {
        for (Account acc : m_accs)
        {                
            if (acc.Id == accountSelected)
            {   
                a = acc;
                break;
            }
        }
    }

    /*
    * Repopulate the financials attached to the cart when coming back to items tab 
    */
    public void refreshFeesTab(){
        fees = m_cs.getCartFees(true);
        invoices = m_cs.getCartInvoices(true);
        deposits = m_cs.getCartDeposits(true);
        activeTab = DOL_AppConstants.FEE_STRING;//'fees';
        return;
    }

    public void checkout()
    {       
        if (String.isBlank(accountSelected) && !m_settings.BGBK__Enable_Cashier_Cart__c)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select an Account first.');
            ApexPages.addMessage(myMsg);
            return;
        }

        if( con == null ){
            for(ReceiptVO rvo : receiptVOs){
                if(rvo.r.MUSW__Receipt_Paid_by__c == null){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select an Contact first');
                    ApexPages.addMessage(myMsg);
                    return;
                }
            }
        }
        
        if (totalSelected <= 0)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Cannot Checkout when Total Selected is zero or less. Select Fees to pay.');
            ApexPages.addMessage(myMsg);
            return;
        }

        // Check the default Payment method and based on that checnge the value for isGatewayRequiredforPaymentMethod
        // By Default value of isGatewayRequiredforPaymentMethod is false
        String paymentMethodLabel = pmtMethods[0].getValue();
        BGBK__Payment_Method__mdt[] paymentMethodGatewayDetails = [SELECT BGBK__isGateway_Required__c FROM BGBK__Payment_Method__mdt WHERE BGBK__isActive__c = true AND Label = :paymentMethodLabel LIMIT 1]; 
        if(paymentMethodGatewayDetails.size() > 0) {        
            if(paymentMethodGatewayDetails[0].BGBK__isGateway_Required__c)        
                isGatewayRequiredforPaymentMethod = true;    
        }
        
        activeTab = DOL_AppConstants.CHECKOUT_STRING;//'checkout';
        
        /*// we need to let user switch between Select Fee tab and Pay Fees tab, we need to requery fees
        fees = m_cs.getCartFees(true);*/
        
        // remove unselected fees (needed for CartConfirm)
        for (Integer i=0; i<fees.size(); i++)
        {
            for (FeeVO feeVo : feeVOs)
            {
               if (fees[i].Id == feeVo.f.Id && !feeVo.isSelected )
               {
                   fees.remove(i);
               }
            }
        }
        
        // remove unselected invoices (needed for CartConfirm)
        for (Integer i=0; i<invoices.size(); i++)
        {
            for (InvoiceVO invVo : invoiceVOs)
            {
               if (invoices[i].Id == invVo.i.Id && !invVo.isSelected )
               {
                   invoices.remove(i);
               }
            }
        }
        
        // remove unselected deposits (needed for CartConfirm)
        for (Integer i=0; i<deposits.size(); i++)
        {
            for (DepositVO depVo : depositVOs)
            {
               if (deposits[i].Id == depVo.deposit.Id && !depVo.isSelected )
               {
                   deposits.remove(i);
               }
            }
        }

        if(receiptVOs[0].amount == null || receiptVOs[0].amount != totalSelected)
        {
            // by default use one Receipt
            //rs[0].MUSW__Amount_Tendered__c = totalSelected;
            receiptVOs[0].amount = totalSelected;
        }  

        preparePayables();  
    }
    
    public void review()
    {       
        if (String.isBlank(accountSelected) && !m_settings.BGBK__Enable_Cashier_Cart__c)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select an Account first.');
            ApexPages.addMessage(myMsg);
            return;
        }
        activeTab = DOL_AppConstants.REVIEW_STRING;//'review';
         
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'No payment gateway is integrated with the system for credit card payment. Please select other payment methods and proceed.');
        ApexPages.addMessage(myMsg);
        return;
       
        /* MONEXA
        for (MUSW__Receipt__c r : rs)
        {
            if (r.MUSW__Payment_Method__c == 'Credit Card' && !Test.isRunningTest())
            {
                gateway = new PaymentGateway();
                Boolean validLogin = gateway.authenticate(a.Id);
                if (!validLogin)
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid login credentials for the Payment Gateway.'));
                }
                monexaSessionKey = gateway.getSessionKey(r.MUSW__Amount_Tendered__c);
            }
        }*/
    }
    
    public Boolean updateReceipt(String receiptId, String transactionConformationId){
        Boolean paymentProcessed = false;
        Id conId = (con != null) ? con.Id : null;
        MUSW__Receipt__c receipt = [select id,Status__c,MUSW__Payment_Method__c,MUSW__Paid_By__c,MUSW__Receipt_Paid_by__c,BGBK__Cart__c,MUSW__Amount_Tendered__c from MUSW__Receipt__c where id =: receiptId FOR UPDATE];
        if(receipt.Status__c == 'Complete'){
            paymentProcessed = true;// Here True means this transaction already processed by RTPC call.
        }
        receipt.Status__c = DOL_AppConstants.COMPLETE_STRING;//'Complete';
        receipt.MUSW__Paid_By__c=(a != null)?a.Id:null;
        receipt.MUSW__Receipt_Paid_by__c=conId;
        receipt.MUSW__Payment_Gateway_Transaction_Number__c = transactionConformationId;
        receipt.MUSW__Amount_Tendered__c = null;
        
        system.debug('receipt updated');
        rs.add(receipt);
        ReceiptVO newReceiptVO = new ReceiptVO(receipt, Decimal.valueOf(ePaymentReturnSession.PaymentAmount), m_rs);
        newReceiptVO.pmtMethodSelected=receipt.MUSW__Payment_Method__c;
        receiptVOs.add(newReceiptVO);
        return paymentProcessed;
    }

    public void addReceipt()
    {
        // default to Check eventho it's already defaulted on the field
        // VF page doesn't see the default field value
        Id conId = (con != null) ? con.Id : null;
        Id paidBy = (a != null) ? a.Id : null;
        String pmtSelected;
        
        if(receiptVOs.size() > 0 && receiptVOs[0].pmtMethodSelected != 'Deposit') {
            pmtSelected = pmtMethods[0].getValue();
        } else {
            pmtSelected = DOL_AppConstants.DEPOSIT_STRING;//'Deposit';
        }
        MUSW__Receipt__c r = new MUSW__Receipt__c(MUSW__Payment_Method__c=pmtSelected, MUSW__Paid_By__c=paidBy, MUSW__Receipt_Paid_by__c=conId, BGBK__Cart__c=cart.Id);
        rs.add(r);
        ReceiptVO newReceiptVO = new ReceiptVO(r, r.MUSW__Amount_Tendered__c, m_rs);
        newReceiptVO.pmtMethodSelected=pmtSelected;
        system.debug('the value of newReceiptVO' +newReceiptVO);
        receiptVOs.add(newReceiptVO);
        // if there more than one receipt(so multiple payment methods) we hide all the gateway payment methods
        if(receiptVOs.size() > 1)
            m_excludeGatewayPmtMethod = true;
    }
 
    public void delReceipt()
    {
        receiptVOs.remove(delRecIndex);
        m_excludeGatewayPmtMethod = receiptVOs.size() > 1?true:false;
    }
   
     public void preparePayables(){
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

    /**
    *  Find the deposit and use the amount to pay for the fee
    */
    public void useDeposit(){
        if(receiptVOs[currentRowIndex].payableReceipt.MUSW__Deposit__c != null){
            if(m_depositsMap.size()>1 && m_depositsMap.containsKey(receiptVOs[currentRowIndex].payableReceipt.MUSW__Deposit__c)){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Cannot select same deposit twice. Please select another deposit.');
                ApexPages.addMessage(myMsg);
                return;
            }
            Id depositId = receiptVOs[currentRowIndex].payableReceipt.MUSW__Deposit__c;
            
            List<MUSW__Deposit__c> deposits = [SELECT Id, MUSW__Available_Amount__c 
                                               FROM MUSW__Deposit__c 
                                               WHERE Id = :depositId AND MUSW__Available_Amount__c > 0];
            
            if(!deposits.isEmpty()){
                receiptVOs[currentRowIndex].amount = deposits[0].MUSW__Available_Amount__c;
                m_depositsMap.put(deposits[0].Id, deposits[0]);
                m_depositsIndexMap.put(currentRowIndex, deposits[0]);
            }
            else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'The deposit selected doesn\'t have available amount. Please select another deposit');
                ApexPages.addMessage(myMsg);
            }
        }
    }

    /**
    *  Make sure user doesn't select amoutn larger than deposit's available amount
    */
    public void validateAmount(){
        MUSW__Deposit__c currentDeposit = m_depositsIndexMap.get(currentRowIndex-1);
        if(receiptVOs[currentRowIndex-1].amount > currentDeposit.MUSW__Available_Amount__c){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Selected amount is larger than the amount available for the deposit. Amount should be ' + currentDeposit.MUSW__Available_Amount__c + ' or less.');
            ApexPages.addMessage(myMsg);
            return;
        }
    }

    /*
     * Sets the rvo.amount if Exixting Receipt is used as the payment method
     * @param ReceiptVO
     */
    public void getExistingReceiptAmount(ReceiptVO rvo){
        if(rvo.r.MUSW__Amount_Available__c < rvo.amount)
        {
            rvo.amount = rvo.r.MUSW__Amount_Available__c;
        }
    }
 
    /*
    * Check selected receipt amount and throw a message if nothing is selected or the amount is not enough
    */
    public void checkExistingReceipt() {
       checkDuplicateReceipt();
       if(!checkReceiptAmount){
            return;
        }
       Decimal totalReceipt = 0;
        for (Integer i=0; i<receiptVOs.size(); i++)
        {
            ReceiptVO rvo = receiptVOs[i];
            if(rvo.amount <= 0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a positive amount to pay.'));
                checkReceiptAmount = false;
                return;
            }

            if(rvo.pmtMethodSelected == 'Deposit'){
                //System.debug('^^^ currentDeposit '+m_depositsIndexMap);
              //  System.debug('^^^ receiptVOs '+receiptVOs);
                MUSW__Deposit__c currentDeposit = m_depositsIndexMap.get(i);
                if(receiptVOs[i].amount > currentDeposit.MUSW__Available_Amount__c){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Selected amount is larger than the amount available for the deposit. Amount should be ' + currentDeposit.MUSW__Available_Amount__c + ' or less.');
                    ApexPages.addMessage(myMsg);
                    checkReceiptAmount = false;
                    return;
                }
                Decimal depositAmount = rvo.amount;

                for(FeeVO fvo : feeVos){
                    if(depositAmount <= 0){
                        break;
                    }

                    if(fvo.isSelected && fvo.paymentAmount > 0){
                        Decimal paymentAmount = Math.min(fvo.paymentAmount, depositAmount);
                        fvo.paymentAmount -= paymentAmount;
                        depositAmount     -= paymentAmount;
                        m_payableDeposits.put(new BGBK.Payable(fvo.f, paymentAmount), new List<MUSW__Deposit__c>{currentDeposit});
                    }
                }

                for(InvoiceVO ivo : invoiceVos){
                    if(depositAmount <= 0){
                        break;
                    }

                    if(ivo.isSelected && ivo.paymentAmount > 0){
                        Decimal paymentAmount = Math.min(ivo.paymentAmount, depositAmount);
                        ivo.paymentAmount -= paymentAmount;
                        depositAmount     -= paymentAmount;
                        m_payableDeposits.put(new BGBK.Payable(ivo.i, paymentAmount), new List<MUSW__Deposit__c>{currentDeposit});
                    }
                }
                //remove this receipt from the cart as another receipt will be created through payable receipt trigger
                rvo.r.BGBK__Cart__c = null;
                continue;
            }

            if(rvo.amount!=null)
                totalReceipt += rvo.amount;
              // DPS-70: validation for 'Other' payment method
              if(rvo.pmtMethodSelected == 'Other')
              {
                  if(rvo.existingPmt.BGBK__Receipt__c == null)
                  {
                      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a Receipt for your payment.'));
                      checkReceiptAmount = false;
                      return;
                  }
                  
                  //set the receipt and payment method of "Other" payment method here
                  rvo.r = m_rs.getReceipt(rvo.existingPmt.BGBK__Receipt__c);
                  // for existing receipt, no need to update the payment method, to keep the original payment method
                  //rvo.r.MUSW__Payment_Method__c = rvo.pmtMethodSelected;
                  if(!m_isNotFromVF)
                    getExistingReceiptAmount(rvo);
                  if(rvo.r.MUSW__Amount_Available__c < rvo.amount) {
                        if(!canPayPartial) {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The Receipt '+rvo.r.Name+' doesn\'t have enough money for allocation. Select another Payment Method.'));
                            checkReceiptAmount = false;
                            return;
                        } else {
                            rvo.amount = rvo.r.MUSW__Amount_Available__c;
                        }
                  }
                  
            }
        }
    }

    /*      
    * Check selected receipt to see if it already have been added       
    */      
    private void checkDuplicateReceipt() {      
        Set<Id> receipts = new Set<Id>();
        Set<Id> deposits = new Set<Id>();       
        // if receipt is already contained in the receiptsVO, throw an error for let the user choose another receipt        
        for (Integer i=0; i<receiptVOs.size(); i++)     
        {       
            ReceiptVO rvo = receiptVOs[i];  
            if(rvo.existingPmt.BGBK__Receipt__c != null) {  
                if(!receipts.contains(rvo.existingPmt.BGBK__Receipt__c))
                {   
                  receipts.add(rvo.existingPmt.BGBK__Receipt__c);   
                }
                else
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You can not use one receipt multiple times in a single transaction.'));        
                    checkReceiptAmount = false;     
                    rvo.existingPmt.BGBK__Receipt__c = null;
                    rvo.amount = null;      
                    return;
                }   
            }
            
            if(rvo.payableReceipt.MUSW__Deposit__c != null) {
                if(!deposits.contains(rvo.payableReceipt.MUSW__Deposit__c))
                {
                    deposits.add(rvo.payableReceipt.MUSW__Deposit__c);
                }
                else
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You can not use one deposit multiple times in a single transaction.'));        
                    checkReceiptAmount = false;     
                    rvo.payableReceipt.MUSW__Deposit__c = null;     
                    rvo.amount = null;      
                    return;
                }
            }
        }       
    }

    public void processEPayment(MUSW__Receipt__c receiptRec){
        Savepoint sp = null;
        if(cart.BGBK__Contact__c != null && cart.BGBK__Contact__r.Name == null) {
            Contact c = [SELECT Name,Email,AccountId From Contact WHERE Id =:cart.BGBK__Contact__c];
            cart.BGBK__Contact__r = c;
        }
        Map<MUSW__Receipt__c, Decimal> rsAmt = new Map<MUSW__Receipt__c, Decimal>();
        for (ReceiptVO rvo : receiptVOs){
            //system.debug('rvo==='+rvo);
            MUSW__Receipt__c receipt = rvo.r;
            rsAmt.put(receipt, rvo.amount);
        }
        sp = Database.setSavePoint();
        //system.debug('rs==='+rs);
        if(!rs.isEmpty()){
            //upsert rs;
        }
        preparePayables();
        try{
            processSuccessful = m_ps.processPayment(payables, rsAmt, accountSelected, cart.BGBK__Process_DateTime__c);
            system.debug('process successfull '+processSuccessful); 
            if(processSuccessful)   {
                onPaymentConfirmation();
                m_cs.closeCart(totalPayment, accountSelected, cart.BGBK__Contact__c, cart.BGBK__Process_DateTime__c);
            } else {
                if(sp != null)
                    Database.rollback(sp);     
            }
        }
        catch (Exception e)
        {
            if(sp != null)
                Database.rollback(sp);
            Id errorId = DOL_CreateErrorLog_Exception.logApplicationError(e);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()+' Please check with Salesforce Team with Id '+errorId ));
            return;
        }
        
    }
    
    // Below Method will be called in Case ePayment Confirmation
    public void onPaymentConfirmation(){
        String feePaymentQuery = DOL_AppConstants.FEE_PAYMENT_SOQL_QUERY_STRING;/*'SELECT MUSW__Fee__r.License_Number__c, MUSW__Fee__r.portal_name__c, MUSW__Fee__r.Application_Type__c,'
            +'MUSW__Fee__r.License_Type__c, MUSW__Fee__r.Application_Method__c, MUSW__Fee__r.MUSW__Amount__c, MUSW__Payment_Amount__c,'
            +'MUSW__Fee__r.MUSW__Outstanding_Fee__c, Id, MUSW__Fee__c,BGBK__Invoice__c,'
            +'BGBK__Invoice__r.Name,BGBK__Invoice__r.BGBK__Balance_Due__c,BGBK__Invoice__r.BGBK__Invoice_Date__c,MUSW__Receipt__c '
            +'FROM MUSW__Fee_Payment__c '
            +'WHERE MUSW__Receipt__c = :receiptId';*/
        feePayments = (List<MUSW__Fee_Payment__c>)Database.query(feePaymentQuery);
        for(MUSW__Fee_Payment__c fp : feePayments){
            fp.BGBK__Cart__c = cart.Id;
        }
        update feePayments;
        
        rs.clear();
        String receiptQuery = DOL_AppUtility.getQueryString('MUSW__Receipt__c');
        receiptQuery += ' WHERE Id = :receiptId';
        rs.add( ((List<MUSW__Receipt__c>)Database.query(receiptQuery)).get(0) );
    }

    /*Vinanthi :Added below method for US 1835*/
    public PageReference  TransferFee(){
        string pinToTransferFee;
        if(receiptVOs.size()>1){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Multiple payment methods are not allowed for Fee Transfer.'));
            return null;
        } 
        System.debug('****receipt***'+ receiptVOs);
        for(ReceiptVO objRVO : receiptVOs){
           if( objRVO.r.Cart_PIN__c == null){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter a valid PIN'));//Added by Vinanthi for US 1835
                    return null;
                }else{
                    pinToTransferFee=objRVO.r.Cart_PIN__c;
                } 
        }
        List<Id> feeIds = new List<Id>();
        System.debug(' fees '+ fees);
        for(MUSW__Fee__c objFee:fees){
            feeIds.add(objFee.Id);
        }
        List<Account> lstAcc =[SELECT id,ThirdPary_Billing_Code__c from Account WHERE ThirdPary_Billing_Code__c =:pinToTransferFee];
        
        //List<BGBK__Cart__c> lstCart =[SELECT id,BGBK__Account__c from BGBK__Cart__c WHERE PIN__c =:pinToTransferFee];
        if(lstAcc.size()>0){
            string sPin=BGBK.CartManager.getCartPIN(lstAcc[0]);
            BGBK.CartManager.transferFeesToCart(feeIds, lstAcc[0].id, pinToTransferFee); 
            String portalURL = URL.getSalesforceBaseUrl().toExternalForm() + '/lightningwashington/s/newdashboard';
            PageReference pageRef = new PageReference(portalURL); 
            return pageRef;
        } else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter a valid PIN'));//Added by Vinanthi for US 1835
                    return null;
        }
        
        
    }
    public void process()
    {
     System.debug(' fees '+ fees);
     System.debug('****receipt***'+ receiptVOs);
     
       
        
    /* if (totalBalance > 0 && !canPayPartial) Padma. To avoid unecessary error message
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Insufficient funds. Tender at least the Amount owing.'));
            return;
        } */
        if (String.isBlank(accountSelected) && !m_settings.BGBK__Enable_Cashier_Cart__c)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select an Account first.'));
            return;
        }
       /* for(Integer i=0; i<receiptVOs.size(); i++){
            if((receiptVOs[i].r.MUSW__Amount_Tendered__c - receiptVOs[i].r.MUSW__Amount_Used__c) <= 0.25 ){
                system.debug('!!!underpayment : ');
            }
        }*/
        for (Integer i=0; i<receiptVOs.size(); i++)
        {
            ReceiptVO rvo = receiptVOs[i];
            system.debug('nazneen' +rvo);
            // Don't go with this method if Payment Method is ACH or Credit Card, US - 4691
            if( rvo.r.MUSW__Payment_Method__c == 'ACH' || rvo.r.MUSW__Payment_Method__c == 'Credit Card'){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select Process ePayment Button '));
                isGatewayRequiredforPaymentMethod = true;
                return;
            }
            // US-4691 end
            if (rvo.r.MUSW__Payment_Method__c == 'Deposit' && rvo.payableReceipt.MUSW__Deposit__c == null)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a deposit.'));
                return;
            } else if(rvo.r.MUSW__Payment_Method__c == 'Check' && (rvo.r.MUSW__Check_Number__c == null && rvo.r.Payee__c == null)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please fill in all fields'));
                return;
            }else if(rvo.r.MUSW__Payment_Method__c == 'Pay by Employer'){
                if( rvo.r.Cart_PIN__c == null){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid payment method'));//Added by Vinanthi for US 1835
                    return;
                }else{
                    return;
                }
            }
        }

        // ELGIN-251: validation disallow underpay 
        checkReceiptAmount = true;
        m_isNotFromVF = true;
        checkExistingReceipt();
        if(!checkReceiptAmount){
            return;
        }
        
        activeTab = DOL_AppConstants.CONFIRM_STRING;//'confirm';

        if(cart.BGBK__Contact__c != null && cart.BGBK__Contact__r.Name == null) {
            Contact c = [SELECT Name,Email,AccountId From Contact WHERE Id =:cart.BGBK__Contact__c];
            cart.BGBK__Contact__r = c;
        }
        
        // apply waives
        update fees;
        
       //Added by Nazneen on 31/05 to capture inatke method for portal and counter type of receipts
       BGBK__Cart__c cartForIMCheck= [SELECT Id, Name, BGBK__Account__c, BGBK__BG_Payment_Batch__r.id FROM BGBK__Cart__c where Id=: cart.Id]; 
       
        system.debug('the values of cartForIMCheck' +cartForIMCheck);
        // reset receipt list based on VO list
        rs.clear();
        Map<MUSW__Receipt__c, Decimal> rsAmt = new Map<MUSW__Receipt__c, Decimal>();
        system.debug('receiptVOs6789'+receiptVOs);
        for (ReceiptVO rvo : receiptVOs)
        {
            MUSW__Receipt__c receipt = rvo.r;
            system.debug('the rvo fields are:' +rvo);
            // update only new receipts, leave exisiting receipts
            if(receipt.Id == null){
              if(receipt.MUSW__Amount_Tendered__c == null || receipt.MUSW__Amount_Tendered__c == 0){
                  receipt.MUSW__Amount_Tendered__c =   rvo.amount;
              }
              else{
                  receipt.MUSW__Amount_Tendered__c =  (receipt.MUSW__Amount_Tendered__c-(rvo.amount!=null?rvo.amount:0));           
              }
            }                       
            receipt.BGBK__Cart__c = cart.Id;
            
            //Added by Nazneen on 31/05 to capture inatke method for portal and counter type of receipts
            if(receipt.Intake_Method__c == null || receipt.Intake_Method__c == ''){
                if(cartForIMCheck.BGBK__BG_Payment_Batch__c != null || !isPortalUser){ // added as a part of bug 2164
                    receipt.Intake_Method__c=DOL_AppConstants.COUNTER_STRING;//'Counter';
                }
                else{
                    receipt.Intake_Method__c=DOL_AppConstants.PORTAL_STRING;//'Portal';
                }
            }
            //rsAmt.put(receipt, rvo.amount);
            if(rvo.pmtMethodSelected != 'Deposit')                
                rs.add(receipt);
                
        }
        
        
        
        if(!rs.isEmpty()){
            system.debug('nazneen--->' +rs);
            //upsert rs;
        }
        
        system.debug('***rs***--->' +rs);
        
        //Populate the map once the receipts were inserted so we can populate the Id
        for (ReceiptVO rvo : receiptVOs){
            MUSW__Receipt__c receipt = rvo.r;
            rsAmt.put(receipt, rvo.amount);
        }

        preparePayables();
        
        Set<Id> feePaymentIds = new Set<Id>();
        try
        {
            

         //   system.debug('**** RS: ' + rs);
            if((payables.size() + m_payableDeposits.size()) <= 150) {
                // below code can be used when Process Payment by Batch functionality is not required
                if(!m_payableDeposits.isEmpty()){
                    feePaymentIds = processDepositPayment();
                    processSuccessful = !feePaymentIds.isEmpty();
                } else {
                    processSuccessful = m_ps.processPayment(payables, rsAmt, accountSelected, cart.BGBK__Process_DateTime__c);
                }
    
                if(processSuccessful)   {
                    Set<MUSW__Receipt__c> receipts = rsAmt.keySet();
                    populateFeeAndInvoicePayment(receipts, feePaymentIds);
                    depositPayments = populateDepositPayment(receipts);
                    // Multiple Receipt Fix BUG - 2497, Developer :- Laltu Banerjee
                    // Get Receipt Id created in this transaction
                    if(rs.size()>0){
                        receiptId = rs.get(0).Id;
                    }
                    // ELGIN-237: re-query receipt in order to get the receipt numbers
                    MUSW__Receipt__c[] allCartReceipt = m_cs.getCartReceipts();
                    rs.clear();
                    for(MUSW__Receipt__c receipt : allCartReceipt){
                        if(receipt.id == receiptId){
                            rs.add(receipt);
                            break;
                        }
                    }
                    // Multiple Receipt Fix BUG - 2497 , ends
                } else {        
                    // this call is made for testing the clean receipt method.      
                    // Within the org, it should throw a exception, so it will go to the catch, but can't be handled via tests.     
                    cleanReceiptsAfterPaymentFail(receiptVOs);      
                }
                
                m_cs.closeCart(totalPayment, accountSelected, cart.BGBK__Contact__c, cart.BGBK__Process_DateTime__c);
            } else {    
                // below code can be used to invoke the ProcessPaymentBatch mechanism when trying to pay large list of payables
                startPoll();
                if(!m_payableDeposits.isEmpty()){
                    jobId = m_ps.processDepositPaymentByBatch(m_payableDeposits, cart.BGBK__Process_DateTime__c);
                } else {
                    jobId = m_ps.processPaymentByBatch(payables, rsAmt, accountSelected, cart.BGBK__Process_DateTime__c);
                }
            }
        }
        catch (Exception e)
        {
            cleanReceiptsAfterPaymentFail(receiptVOs);
            
            String ExceptionString = e.getMessage();
            if(ExceptionString.Contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
                String FormatException = ExceptionString.substringAfterLast('FIELD_CUSTOM_VALIDATION_EXCEPTION,');
                String Exceptionthrown = FormatException.substringBefore(':');
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Exceptionthrown));
                return;
            }
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            return;
        }
        system.debug('***size**'+feePaymentIds.size()+'***feePaymentIds**'+feePaymentIds+'***totalSelectedOutstanding*******'+totalSelectedOutstanding+'***totalPayment**'+totalPayment);
        //totalSelectedOutstanding = totalSelectedOutstanding -totalPayment;
        //system.debug('****totalSelectedOutstanding*'+totalSelectedOutstanding);
    }
    
    /* public void redirectToPaymentGateway(){
        MUSW__Receipt__c receipt = new MUSW__Receipt__c();
        receipt.BGBK__Cart__c = m_cs.getCart().Id;
        receipt.Status__c = 'Draft';
       // receipt.Intake_Method__c = 'Portal';
        
        system.debug('inside redirectToPaymentGateway ');
        
        List<String> feeIds = new List<String>();
        for (FeeVO feeVo : feeVOs){
            if (feeVo.isSelected){
                feeIds.add(feeVo.f.Id);
            }
        }
        receipt.MUSW__Amount_Tendered__c = totalSelected;
        receipt.Selected_Fees__c = String.join(feeIds, ',');
        receipt.MUSW__Payment_Method__c = receiptVOs[Integer.valueOf(currentReceiptIndex)].r.MUSW__Payment_Method__c;
       
        insert receipt;
        
        receiptId = receipt.Id;
    } */

    public void createReceiptForPaymentGateway(){
        MUSW__Receipt__c receipt = receiptVOs[0].r;
        receipt.BGBK__Cart__c = cart.Id;
        receipt.Status__c = DOL_AppConstants.DRAFT_STRING;//'Draft';
        receipt.MUSW__Payment_Gateway_Transaction_Number__c = DOL_AppConstants.TEMP_STRING;//'temp';   // BG Case 10041
        List<String> feeIds = new List<String>();
        for (FeeVO feeVo : feeVOs){
            if (feeVo.isSelected){
                feeIds.add(feeVo.f.Id);
            }
        }
        receipt.Selected_Fees__c = String.join(feeIds, ',');
        
        //Added by Vinanthi for defect 4999
        BGBK__Cart__c cartForIMCheck= [SELECT Id, Name, BGBK__Account__c, BGBK__BG_Payment_Batch__r.id FROM BGBK__Cart__c where Id=: cart.Id];
         if(receipt.Intake_Method__c == null || receipt.Intake_Method__c == ''){
            if(cartForIMCheck.BGBK__BG_Payment_Batch__c != null || !isPortalUser){ // added as a part of bug 2164
                receipt.Intake_Method__c=DOL_AppConstants.COUNTER_STRING;//'Counter';
            }
            else{
                receipt.Intake_Method__c=DOL_AppConstants.PORTAL_STRING;//'Portal';
            }
           }
        // defect 4999 ends here
        insert receipt;
        receiptId = receipt.Id;
    }

    /*
    * Start polling : update keep polling to true and set the processing message
    */
    public void startPoll() {
        keepPolling = true;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Processing Payment ...'));
    }
    
    /*
    * Polling through the ProcessPaymentBatch jobs to check status and update message in VF page
    */
    public void batchJobPoll() {
        AsyncApexJob job = [SELECT JobItemsProcessed, TotalJobItems, Status, ExtendedStatus FROM AsyncApexJob WHERE Id=:jobId];
        if(job.Status != 'Completed' && job.Status != 'Aborted') {
            if(job.TotalJobItems == 0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Processing payment: Job in queue...'));
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Processing payment: '+Math.floor(100.0*job.JobItemsProcessed/job.TotalJobItems)+'% ...'));
            }
        } else {
            // When the jobs are completed with errors display the error message
            if(job.ExtendedStatus != null)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Payment process failed '+job.ExtendedStatus.toLowerCase()+'. A more detailed description of that error, along with any subsequent errors, is emailed to the user who started the running batch class.'));
                keepPolling = false;
                jobId = null;
                processSuccessful = false;
                cleanReceiptsAfterPaymentFail(receiptVOs);
            }
            // when the jobs are complete with no errors
            else
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Payment processing is now '+job.Status.toLowerCase()+'.'));
                keepPolling = false;
                jobId = null;
                processSuccessful = true;
                if(m_cs == null)
                    m_cs = getCartService(m_pid,m_cartId);
                
                transient MUSW__Receipt__c[] tempRs = m_cs.getCartReceipts();
                rs = tempRs;

                if(processSuccessful){
                    Set<Id> feePaymentIds = new Set<Id>();
                    // poupulate the fee/invoice/deposit payments if payment processing is successful so far
                    if(processSuccessful)
                    {
                        Set<MUSW__Receipt__c> receipts = new Set<MUSW__Receipt__c>();
                        receipts.addAll(rs);
                        populateFeeAndInvoicePayment(receipts, feePaymentIds);
                        depositPayments = populateDepositPayment(receipts);
                    }
                }

                // close cart and send email once the jobs are completed
                m_cs.closeCart(totalPayment, accountSelected, cart.BGBK__Contact__c, cart.BGBK__Process_DateTime__c);
                sendPdf();
            }
        }
    }

    /*
    * Get the Cart Service instance
    * @param Id parent id
    * @param Id cart Id
    * @return BGBK.CartService
    */
    public static BGBK.CartService getCartService(Id pid, Id cId){
        transient BGBK.CartService tempService = (pid != null || cId != null) ? new BGBK.CartService(pid, cId) : new BGBK.CartService();
        return tempService;
    }


    public void sendPdf()
    {
        if (!processSuccessful) return;
        
        Id[] feeIds = new List<Id>((new Map<Id, MUSW__Fee__c>(fees)).keySet());
        //system.debug('Lastname$$$'+con.LastName);
        if(a != null) {
        if (con == null) con = new Contact(Id=cart.BGBK__Contact__c,AccountId = a.Id,LastName = a.Name);
        } else {
            if (con == null) con = new Contact(Id=cart.BGBK__Contact__c);
        }
        con.Email = email;
        m_cs.sendConfirmEmail(feeIds, con, BGBK.CartService.AttachmentFormat.PDF, 'Cart Payment Receipt', null);
    }
    
    public pageReference abandon()
    {
        m_cs.abandonCart();
        pageReference  pr = (retURL!=null) ? new pageReference(retURL) : new pageReference('/apex/BGBK__CartSearch');
        pr.setredirect(true);
        return pr;
    }
    
    //Added for BUG:3573
    public PageReference printReceipt(){
        //onClick="window.open('/apex/BGBK__CartPrint?cartId={!cart.Id}&email={!email}');"
        if(!isPortalUser){
            PageReference pageRef = new PageReference('/apex/BGBK__CartPrint?cartId='+cart.Id+'&email='+email); 
            return pageRef;
        }else{
            PageReference pageRef = new PageReference('/BGBK__CartPrint?cartId='+cart.Id+'&email='+email); 
            return pageRef;
        }
    }
    
    public PageReference  backToItems()
    {
        //added as a part of BUG: 2965 when paying from back office and clicking back,navigate to correct page.
        if(!isPortalUser){
            return cancel();
        }else{
            // selectedTab = label.Str_Fees;
            //String portalURL = URL.getSalesforceBaseUrl().toExternalForm() + '/lightningwashington/s/user-feedback&isBizLic='+isBisuneesLic;
            String portalURL = URL.getSalesforceBaseUrl().toExternalForm() + '/lightningwashington/s/user-feedback?isBizLic='+isBLic;
            PageReference pageRef = new PageReference(portalURL); // Srujan - added to show Feedback Component
            return pageRef; 
        }
    }
    
    public pageReference cancel()
    {
        return getPageReference();
    }
    
    public Decimal totalBalance
    {
        get
        {
            Decimal totalr = 0;
            for (ReceiptVO rvo : receiptVOs)
            {
                Decimal ramt = (rvo.amount != null) ? rvo.amount : 0;
                totalr += ramt;
            }
            totalBalance = m_totalOwed - totalr;
            return totalBalance;
        }
        set;
    }
    
    /*
     *  Get the unselected item ids from page and refresh the total
     */
    public void refreshTotal()
    {
        for (FeeVo feeVo : feeVOs)
        {
            feeVo.isSelected = !itemsUnselected.contains(feeVo.f.Id);
        }
        
        for (InvoiceVo invVo : invoiceVOs)
        {
            invVo.isSelected = !itemsUnselected.contains(invVo.i.Id);
        }

        for (DepositVo depVo : depositVOs)
        {
            depVo.isSelected = !itemsUnselected.contains(depVo.deposit.Id);
        }
        
        // reset itemsUnselected
        itemsUnselected = DOL_AppConstants.NULL_EMPTY_STRING;//'';
        updateTotal();
    }
    
    /*
     *  Update fee total based on user input and check out
     */
    public void refreshTotalAndCheckout()
    {
        refreshTotal();
        Checkout();
    }
    
    /**
     * user changed contact
     */
    public void contactChanged()
    {
        reconcileCart = cart.BGBK__Contact__c!=null ? findActiveCartByContact(cart.BGBK__Contact__c) : null;
        
        if(reconcileCart == null)    // did not find active cart 
        {
            m_reconcileOriginalContact = cart.BGBK__Contact__c;
        }
        //Added by Abhilasha as a part of bug:4012
        if(con == null){ //check if existing cart has contact.
            if(cart.BGBK__Contact__c != null){
                Contact cont = [Select Id,AccountId,Email From Contact Where Id = :cart.BGBK__Contact__c limit 1];
                Id AccountId = cont.AccountId;
                String contEmail = cont.Email; 
                email = contEmail; // for bug 6292
                for(ReceiptVO rvo : receiptVOs){
                    if(rvo.r.MUSW__Receipt_Paid_by__c == null){
                        rvo.r.MUSW__Receipt_Paid_By__c = cart.BGBK__Contact__c;
                        rvo.r.MUSW__Paid_By__c = AccountId;
                    }
                }
            }
        }
        
    }
    
    
    /**
     * do reconcile, abandon current cart and navigate user to new reconciled cart
     */
    public PageReference doReconcile()
    {
       // System.debug('===============>doReconcile');
       MUSW__Fee__c[] updateFees = new List<MUSW__Fee__c>();
       for(FeeVO fvo : feeVOs)
       {
           MUSW__Fee__c fee = fvo.f;
           fee.BGBK__Cart__c = reconcileCart.id;
           updateFees.add(fee);
       }

       BGBK__Bill__c[] updateInvoices = new List<BGBK__Bill__c>();
       for(InvoiceVO ivo : invoiceVOs)
       {
           BGBK__Bill__c invoice = ivo.i;
           invoice.BGBK__Cart__c = reconcileCart.id;
           updateInvoices.add(invoice);
       }  
       
       update updateFees;
       update updateInvoices;
       
       // abandon current cart
       m_cs.abandonCart();
       
       // navigate to new cart
       pageReference  pr = new pageReference('/apex/Cart?cartId='+reconcileCart.id);
       pr.setredirect(true);
        
       return pr;
    }
    
    /**
     * cancel reconcile cart, restore previoius contact
     */
    public PageReference cancelReconcile()
    {
        reconcileCart = null;
        cart.BGBK__Contact__c = m_reconcileOriginalContact;
        return null;
    }
    
    private BGBK__Cart__c findActiveCartByContact(Id contactId)
    {
        BGBK__Cart__c[] cs = [select Id from BGBK__Cart__c where BGBK__Contact__r.id = :contactId and BGBK__Status__c = 'Open' and BGBK__Expiration_DateTime__c >= TODAY and id!=:m_cartId limit 1];
        return (cs!=null && cs.size()>0) ? cs[0] : null;
    }
        
    private void updateTotal()
    {
        totalSelected = 0;
        totalSelectedOutstanding = 0;
        for (FeeVO feeVo : feeVOs)
        {
            if (feeVo.isSelected)
            {
                Decimal paymentAmount = feeVo.paymentAmount;
                Decimal outstandingAmount = feeVo.f.MUSW__Outstanding_Fee__c;
                System.debug('****Fee****outstandingAmount**********'+outstandingAmount);
                if(paymentAmount !=null){
                    totalSelected += paymentAmount ;
                }
                if(outstandingAmount != null){
                    totalSelectedOutstanding += outstandingAmount;
                }
                System.debug('**Fee******totalSelectedOutstanding**********'+totalSelectedOutstanding);
            }
        }
        
        for (InvoiceVo invVo : invoiceVOs)
        {
            if (invVo.isSelected)
            {
                Decimal paymentAmount = invVo.paymentAmount;
                Decimal outstandingAmount = invVo.i.BGBK__Balance_Due__c;
                if(paymentAmount != null){
                    totalSelected += paymentAmount ;
                }
                if(outstandingAmount != null){
                    totalSelectedOutstanding += outstandingAmount;
                    System.debug('**Invoice******totalSelectedOutstanding**********'+totalSelectedOutstanding);
                }
            }
        }

        totalSelected += populateSelectedDepositsTotal();
        System.debug('**final******totalSelectedOutstanding**********'+totalSelectedOutstanding);
        totalSelectedOutstanding += populateSelectedUnpaidDepositsTotal();
        System.debug('**final 2******totalSelectedOutstanding**********'+totalSelectedOutstanding);
    }

        /**
    * Populate the payments for fees
    * @param Set<MUSW__Receipt__c> receipts that were created or updated during process payment
    * @param Set<Id> feePaymentIds fee payments that were created for the fees/invoices were processed
    * @return void
    */
    private void populateFeeAndInvoicePayment(Set<MUSW__Receipt__c> receipts, Set<Id> feePaymentIds){
        Set<Id> receiptIds = new Set<Id>();
        Set<Id> invoiceIds = new Set<Id>();
        Set<Id> feeIds     = new Set<Id>();

        feePayments = new List<MUSW__Fee_Payment__c>();
        invoicePayments = new List<MUSW__Fee_Payment__c>();

        Map<Id, MUSW__Fee_Payment__c[]> invTofeePaymentMap = new Map<Id, MUSW__Fee_Payment__c[]>();

        for(MUSW__Receipt__c receipt : receipts){
            receiptIds.add(receipt.Id);
        }
        for (FeeVO fvo : feeVOs)  {
            // only selected fees should be queried for
            if(fvo.isSelected) 
                feeIds.add(fvo.f.Id);            
        }
        for(InvoiceVO ivo : invoiceVOs){
            // only selected invoices should be queried for
            if(ivo.isSelected)
                invoiceIds.add(ivo.i.Id);
        }
        system.debug('feeIds123 '+feeIds);
        Set<MUSW__Fee_Payment__c> payments = new Set<MUSW__Fee_Payment__c>();
        payments.addAll(queryFeePayments(receiptIds));
        system.debug('payments123'+payments);
        if(feePaymentIds != null && !feePaymentIds.isEmpty()){
            payments.addAll(queryFeePaymentsById(feePaymentIds));
        }

        Map<Id, MUSW__Fee__c> feeMap = new Map<Id, MUSW__Fee__c>(
                                    [SELECT Id, BGBK__Invoice__c
                                    FROM MUSW__Fee__c
                                    WHERE BGBK__Invoice__c IN :invoiceIds]);

        for(MUSW__Fee_Payment__c payment : payments){
            if(feeIds.contains(payment.MUSW__Fee__c)){
                feePayments.add(payment);
            }
            else if(feeMap.containsKey(payment.MUSW__Fee__c)){
                MUSW__Fee_Payment__c[] invPayment = invTofeePaymentMap.get(payment.BGBK__Invoice__c);
                if(invPayment == null){
                    invTofeePaymentMap.put(payment.BGBK__Invoice__c, new MUSW__Fee_Payment__c[]{payment});
                }
                else{
                    invTofeePaymentMap.get(payment.BGBK__Invoice__c).add(payment);
                }
            }
        }
        system.debug('feePayments123'+feePayments);
        system.debug('invoicePayments123'+invoicePayments);
        //return null so cart confirm shows table of fees/invoices if payments are empty
        if(feePayments.isEmpty()){
            feePayments = null;
        }

        if(invTofeePaymentMap.isEmpty()){
            invoicePayments = null;
        }
        else{
            List<MUSW__Fee_Payment__c> iPayments = new List<MUSW__Fee_Payment__c>();
            for(Id invId : invTofeePaymentMap.keySet())
            {
                iPayments.addAll(invTofeePaymentMap.get(invId));
            }
            invoicePayments.addAll(iPayments);
        }
    }

    /**
    * Query the fee payments for receipts in this transaction
    * @param Set<Id> Receipt Ids from the payments processed
    * @return List<MUSW__Fee_Payment__c> List Fee Payment with the receipt ids in param
    */
    private List<MUSW__Fee_Payment__c> queryFeePayments(Set<Id> receiptIds){
        List<Schema.FieldSetMember> fieldSets = SObjectType.MUSW__Fee_Payment__c.FieldSets.BGBK__Feebasic.getFields();
        String query = DOL_AppConstants.SELECT_STRING_WITH_SPACE;//'SELECT ';

        //Populate fields from field set
        for(Schema.FieldSetMember f : fieldSets) {
            String fieldName = f.getFieldPath();
            query            += fieldName + ', ';
        }
        // also query based on cart id
        Id cartId = cart!=null? cart.Id:m_cartId!=null?m_cartId:'';
        System.debug('receiptIds='+receiptIds);
        System.debug('cartId = '+cartId);
        query += 'Id, MUSW__Fee__c,BGBK__Invoice__c,BGBK__Invoice__r.Name,BGBK__Invoice__r.BGBK__Balance_Due__c,BGBK__Invoice__r.BGBK__Invoice_Date__c, MUSW__Receipt__c ' +
        'FROM MUSW__Fee_Payment__c WHERE MUSW__Receipt__c IN :receiptIds and MUSW__Receipt__r.MUSW__Payment_Method__c != \'Deposit\' and BGBK__Cart__c = :cartId';
        system.debug('query123'+query);
        return (List<MUSW__Fee_Payment__c>)Database.query(query);
    }

     /**
    * Query the fee payments fby Id
    * @param Set<Id> Fee Payment Ids from the payments processed
    * @return List<MUSW__Fee_Payment__c> List Fee Payments with the ids in param
    */
    private List<MUSW__Fee_Payment__c> queryFeePaymentsById(Set<Id> ids){
        List<Schema.FieldSetMember> fieldSets = SObjectType.MUSW__Fee_Payment__c.FieldSets.BGBK__Feebasic.getFields();
        String query = DOL_AppConstants.SELECT_STRING_WITH_SPACE;//'SELECT ';

        //Populate fields from field set
        for(Schema.FieldSetMember f : fieldSets) {
            String fieldName = f.getFieldPath();
            query            += fieldName + ', ';
        }
        // also query based on cart id
        Id cartId = cart!=null? cart.Id:m_cartId!=null?m_cartId:'';

        query += 'Id, MUSW__Fee__c,BGBK__Invoice__c,BGBK__Invoice__r.Name,BGBK__Invoice__r.BGBK__Balance_Due__c,BGBK__Invoice__r.BGBK__Invoice_Date__c, MUSW__Receipt__c ' +
        'FROM MUSW__Fee_Payment__c WHERE Id IN :ids and BGBK__Cart__c = :cartId';

        return (List<MUSW__Fee_Payment__c>)Database.query(query);
    }

    /**
    * Populate the payments for deposits
    * @param Set<MUSW__Receipt__c> receipts
    * @return List<MUSW__Payable_Receipt__c> list of deposit payments
    */
    public List<MUSW__Payable_Receipt__c> populateDepositPayment(Set<MUSW__Receipt__c> receipts){
        Set<Id> receiptIds = new Set<Id>();
        Set<Id> depositIds = new Set<Id>();

        for(MUSW__Receipt__c receipt : receipts){
            receiptIds.add(receipt.Id);
        }
        for (DepositVO dvo : depositVOs)  { 
            //only selected deposits should be queried for 
            if(dvo.isSelected)
                depositIds.add(dvo.deposit.Id);            
        }

        List<Schema.FieldSetMember> fieldSets = SObjectType.MUSW__Payable_Receipt__c.FieldSets.BGBK__Deposit_Basic.getFields();
        String query = DOL_AppConstants.SELECT_STRING_WITH_SPACE;//'SELECT ';

        //Populate fields from field set
        for(Schema.FieldSetMember f : fieldSets) {
            String fieldName = f.getFieldPath();
            query            += fieldName + ', ';
        }
        // also query based on cart id
        Id cartId = cart!=null? cart.Id:m_cartId!=null?m_cartId:'';

        query += 'Id, MUSW__Deposit__c, MUSW__Receipt__c ' + 
        'FROM MUSW__Payable_Receipt__c WHERE MUSW__Deposit__c IN :depositIds AND MUSW__Receipt__c IN :receiptIds and BGBK__Cart__c = :cartId';

        List<MUSW__Payable_Receipt__c> payments = (List<MUSW__Payable_Receipt__c>)Database.query(query);
        
        //return null so cart confirm shows table of fees if payments are empty
        if(payments.isEmpty()){
            return null;
        }

        return payments;
    }

    /**
    *    Uses an indexed receipt label to query gateway requirement     
    */      
    public void checkGatewayRequirementforPaymentMethod() {     
        String paymentMethodLabel = receiptVOs[Integer.valueOf(currentReceiptIndex)].r.MUSW__Payment_Method__c;     
        BGBK__Payment_Method__mdt[] paymentMethodGatewayDetails = [SELECT BGBK__isGateway_Required__c FROM BGBK__Payment_Method__mdt WHERE BGBK__isActive__c = true AND Label = :paymentMethodLabel LIMIT 1];       
        if(paymentMethodLabel == 'Pay by Employer'){
            isFeeTransfer= true;
        } 
        else{
            isFeeTransfer= false;
        }
        if(paymentMethodGatewayDetails.size() > 0) {        
            if(paymentMethodGatewayDetails[0].BGBK__isGateway_Required__c)        
                isGatewayRequiredforPaymentMethod = true;       
            else        
                isGatewayRequiredforPaymentMethod = false;      
        }       
        else        
            isGatewayRequiredforPaymentMethod = false;     
    }

    /**
    *   Add deposits from page reference to a cart
    */
    private void addDepositsToCart(){
        m_depositId = String.escapeSingleQuotes(m_depositId.remove(' '));

        List<String> depositIdStrings = m_depositId.split(',');
        Set<Id> depositIds            = (Set<Id>)JSON.deserialize(JSON.serialize(depositIdStrings), Set<Id>.class);

        m_cs.addDepositsToCart(depositIds);
    }

    /**
    *   Populate DepositVO list and calculate the total unpaid amount
    */
    private Decimal populateDepositVOs(){
        Decimal amountUnpaid = 0;

        for (MUSW__Deposit__c deposit : deposits){
            depositVOs.add(new DepositVO(deposit));
            amountUnpaid += deposit.MUSW__Unpaid_Amount__c;
        }
        return amountUnpaid;
    }

    /**
    *   Calculate the total payment amount for selected deposits
    */
    private Decimal populateSelectedDepositsTotal(){
        Decimal totalAmount = 0;
        for (DepositVO depVO : depositVOs){
            if (depVO.isSelected && depVO.paymentAmount != null){
                totalAmount += depVO.paymentAmount; 
            }
        }

        return totalAmount;
    }

    /**
    *   Calculate the total unpaid amount for selected deposits
    */
    private Decimal populateSelectedUnpaidDepositsTotal(){
        Decimal totalAmount = 0;
        for (DepositVO depVO : depositVOs){
            if (depVO.isSelected && depVO.deposit.MUSW__Unpaid_Amount__c != null){
                totalAmount += depVO.deposit.MUSW__Unpaid_Amount__c; 
            }
        }

        return totalAmount;
    }

    /**
    *   Pay for fees by deposit and populate the payments generated through PaymentService
    */
    private Set<Id> processDepositPayment(){
        System.debug('^^^ m_payableDeposits '+m_payableDeposits);
        Set<Id> feePaymentIds     = m_ps.processDepositPayment(m_payableDeposits, cart.BGBK__Process_DateTime__c);
        System.debug('^^^ feePaymentIds '+feePaymentIds);
        Decimal depositPaidAmount = 0;
        Decimal initialAmount     = 0;

        processSuccessful = feePaymentIds != null && feePaymentIds.size()>0;
        List<MUSW__Fee_Payment__c> feePayments = [SELECT BGBK__Payment__c, MUSW__Payment_Amount__c FROM MUSW__Fee_Payment__c WHERE Id IN :feePaymentIds];
        Set<Id> paymentIds = new Set<Id>();

        for(BGBK.Payable payment : m_payableDeposits.keySet()){
            initialAmount += payment.amount;
        }

        for(MUSW__Fee_Payment__c feeP : feePayments){
            paymentIds.add(feeP.BGBK__Payment__c);
            depositPaidAmount +=feeP.MUSW__Payment_Amount__c;
        }
        
        return feePaymentIds;
    }
    
    private pageReference getPageReference()
    {
        pageReference pr;
        if (retURL != null)
        {
            pr = new pageReference(retURL);
        }
        else if (m_pid != null)
        {
            pr = new pageReference('/'+ m_pid);
        }
        else
        {
             pr = new pageReference('/apex/BGBK__CartSearch');
        }
        pr.setredirect(true);
        return pr;
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
            if(recToDel.size() > 0)     
                delete recToDel;        
        }       
    }

    @testVisible private class DepositVO
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

    
    @testVisible
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

    /**
    ** Name             : redirectToPaymentGateway
    ** Input            : N/A
    ** Functionality    : To redirect the user from salesforce to ePayment gateway
    ** Return           : PageReference
    ** Author           : Laltu Banerjee
    ** Note             : This is called from cart.page in case of payment method 'Credit Card' and 'ACH'
    */
    public PageReference redirectToPaymentGateway(){
        try{
            String payerContactId;
            String paymentMethod;
            String paymentAmount;

            paymentAmount = String.valueOf(receiptVOs[0].amount);
            payerContactId = receiptVOs[0].r.MUSW__Receipt_Paid_By__c;
            paymentMethod = receiptVOs[0].r.MUSW__Payment_Method__c;
            
            if (String.isBlank(accountSelected) && !m_settings.BGBK__Enable_Cashier_Cart__c)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select an Account first.'));
                return null;
            }
            // Put a check if paymentMethod other then the below don't process further
            //change the value of isGatewayRequiredforPaymentMethod to false
            //which will change the buttons for payments
            if( paymentMethod != 'ACH' && paymentMethod != 'Credit Card'){
                isGatewayRequiredforPaymentMethod = false;
                return null;
            }
            if(String.isBlank(payerContactId)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select an Payer first.'));
                return null;
            }
            // create receipt manually before proceding to payment gateway
            createReceiptForPaymentGateway();
            // list of all selected feeIds
            List<String> feeIds = new List<String>();
            for (FeeVO feeVo : feeVOs){
                if (feeVo.isSelected){
                    feeIds.add(feeVo.f.Id);
                }
            }
            // Defect 8051
            if(invoiceVOs.size()>0){
                Set<Id> invoiceIds = new Set<Id>();
                for (InvoiceVO invoiceVo : invoiceVOs){
                    if (invoiceVo.isSelected){
                        invoiceIds.add(invoiceVo.i.Id);
                    }
               }
                system.debug('invoiceIds$$'+invoiceIds);
                if(invoiceIds.size()>0)  { 
                     List<MUSW__Fee__c> invoiceFee = DOL_License_Linking.fetchFeeFromInvoice(invoiceIds);
                         //[SELECT Id, BGBK__Invoice__c FROM MUSW__Fee__c WHERE BGBK__Invoice__c IN :invoiceIds];
                    for(MUSW__Fee__c oFee: invoiceFee){
                        feeIds.add(oFee.Id);
                    }
                 }
            }
            system.debug('feeIds$$'+feeIds);
            
            
            
            // create the object DOL_ePaymentSessionTransferDetails with required parameter
            DOL_ePaymentSessionTransferDetails sessionTransferDetails = new DOL_ePaymentSessionTransferDetails(paymentGatewaySettings.Product_Code__c,
                                                                                                            paymentAmount,
                                                                                                            paymentMethod,
                                                                                                            payerContactId,
                                                                                                            cart.Id,
                                                                                                            feeIds,
                                                                                                            isPortalUser);
            sessionTransferDetails.returnValue = receiptId;
            sessionTransferDetails.SFDClicId = receiptId;
            System.debug('SFDClicId='+receiptId);
            // get the encrypted string
            encryptedSessionInfo = DOL_ePaymentSessionTransfer.getEncryptedSessionString(sessionTransferDetails);
            // Create the PageReference and setting the params
            PageReference pageRef = new PageReference(paymentGatewaySettings.Endpoint__c);
            pageRef.getParameters().put('billerId',paymentGatewaySettings.Biller_Id__c);
            pageRef.getParameters().put('billerGroupId',paymentGatewaySettings.Biller_Group_Id__c);
            pageRef.getParameters().put('session',encryptedSessionInfo);
            pageRef.setRedirect(true);
            return pageRef;
        }
        catch(Exception error){
            Id errorLogId = DOL_CreateErrorLog_Exception.logApplicationError(error);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
            'Error occured during proceeding to payment gateway, Please contact Salesforce Team with Id :: '+errorLogId));
            return null;
        }
        
    }
	
	//Added by Abhilasha as a part of bug 6264
    public void returnToPrevPage(){
        activeTab = DOL_AppConstants.FEE_STRING;//'fees';
    }

}