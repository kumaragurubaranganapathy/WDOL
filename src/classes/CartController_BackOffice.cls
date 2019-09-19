/*************************************************************************************************************
** Name             : CartController_BackOffice
** Description      : Controller for BO Cart Page 
** Version          : 1.0
** Built By         : 
**------------------------------------------------------------------------------------------------------------
** Modification Log:
**-------------------
** Developer                    Date            Version            Description
** Sujila Nair, Deloitte        02/10/2018        2.0              R5 - Updated Fee Expiration implementation
**------------------------------------------------------------------------------------------------------------
** Review Log:
**--------------------
** Reviewer                     Date            Version            Description
**------------------------------------------------------------------------------------------------------------
**
*************************************************************************************************************/
public class CartController_BackOffice {
    private BGBK.CartService bgCartService;
    public boolean isPortalUser {get; set;}
    public MUSW__Receipt__c receipt {get; set;}
    public MUSW__Receipt__c receiptAsPay {get; set;}
    public List<MUSW__Receipt__c> receipts {get; set;}
    public Decimal amountTendered {get; set;}
    public boolean processSuccessful { get; set; }
    public boolean checkNumber  {get; set;}
    public String batchNum      {get; set;}
    public String paymentComment {get; set;}
    public String transactionNum {get; set;} 
    private BGBK__CartSettings__c m_settings;
    public Boolean canSelectReceipt { get; private set;}
    private BGBK.ReceiptService m_rs;
    public MUSW__Receipt__c[] exs {get; set;}
    Set <String> picklistSelections {get; set;}
    public String selectedPaymentOption {get; set;} 
    public Selectoption[] pmtMethods {get; set;}
    private String correspondingLicenseId = DOL_AppConstants.NULL_EMPTY_STRING;
    
    public String selectedBoard 
    {
        get
        {
            if(selectedBoard == null && boards.size() == 2)
                selectedBoard = boards[1].getValue();
            system.debug(selectedBoard);
            return selectedBoard;
        }
        set;
    }
    
    public Decimal totalAmount
    {
        get
        {
            Decimal amount = 0.0;
            for(FeeWrapper feeWrapper : fees)
                if(feeWrapper.checked)
                amount += feeWrapper.fee.MUSW__Outstanding_Fee__c;
            
            return amount;
        }
    }
    
    public List<SelectOption> boards
    {
        get
        {
            if(boards == null)
            {
                Set<String> boardSet = new Set<String>();
                for(MUSW__Fee__c fee : feeList)
                    boardSet.add(fee.Board__c);
                
                boards = new List<SelectOption>();
                boards.add(new SelectOption('--None--','--None--'));
                
                for(String board : boardSet)
                    if(board != null)
                    boards.add(new SelectOption(board, board));
                system.debug('boards are'+boards);  
            }
            
            return boards;
        }
        private set;
    }
    
    public String selectedTab 
    {
        get
        {
            if(selectedTab == null)
                selectedTab = DOL_AppConstants.NULL_EMPTY_STRING + 'Fees';
            
            return selectedTab;
        }
        set;
    }
    
    public BGBK__Cart__c cart
    {
        get
        {
            if(cart == null)
                cart = bgCartService.getCart();
            
            return cart;
        }
        private set;
    }
    
    public BGBK__Cart__c dummyCart
    {
        get
        {
            if(dummyCart == null)
                dummyCart = new BGBK__Cart__c();
            
            return dummyCart;
        }
        private set;
    }
    
    public Contact contact
    {
        get
        {
            if(contact == null)
                contact = bgCartService.getActiveContact();
            
            return contact;                
        }
        set;
    }
    public boolean isBackToRecordVisible{get;set;}
    
    // List of fee sObjects
    public List<MUSW__Fee__c> feeList
    {
        get
        {
            if(feeList == null)
            {
                feeList = bgCartService.getCartFees(true);
            }
            
            return feeList;
        }
        private set;
    }
    
    public List<FeeWrapper> fees
    {
        get
        {
            if(fees == null)
            {
                fees = new List<FeeWrapper>();
                if(!String.isEmpty(selectedBoard))
                {
                    system.debug(selectedBoard);
                    for(MUSW__Fee__c fee : feeList)
                        if(fee.board__c == selectedBoard)
                        fees.add(new FeeWrapper(fee, false));
                }
            }
            system.debug('fees'+fees);
            return fees;
        }
        set;
    }
    
    public List<MUSW__Fee__c> selectedFees{
        get
        {
            selectedFees = new List<MUSW__Fee__c>();
            for(FeeWrapper feeW : fees)
                if(feeW.checked)
                selectedFees.add(feeW.fee);
            return selectedFees;
        }
        set;
    }
    
    public BGBK.PaymentGatewayService.RequestProperties formProperties
    {
        get
        {
            if(formProperties == null)
            {
                List<BGBK.Payable> payables = new List<BGBK.Payable>();
                
                for(FeeWrapper feeWrapper : fees)
                    if(feeWrapper.checked)
                    payables.add(new BGBK.Payable(feeWrapper.fee, feeWrapper.fee.MUSW__Outstanding_Fee__c));
                
                Map<String, String> miscMap = new Map<String, String>{'board' => selectedBoard};
                    
                   // CBossPaymentGateway cbossGateway = new CBossPaymentGateway();
                //formProperties = cbossGateway.getGatewayRequestFields(payables, null, bgCartService.getCart(),  bgCartService.getActiveAccount(), dummyCart.BGBK__Contact__c == null ? bgCartService.getActiveContact() : new Contact(Id = dummyCart.BGBK__Contact__c), miscMap);
            }
            
            return formProperties;
        }
        private set;
    }
    
    public CartController_BackOffice()
    {   
        picklistSelections = new Set <String> (); 
        checkNumber = false;
        Id cartId = System.currentPageReference().getParameters().get('cartId');
        isBackToRecordVisible = false;
        //instantiate cart service 
        if(cartId != null)
            bgCartService = new BGBK.CartService(null, cartId);
        else{
            bgCartService = new BGBK.CartService();
        }
        
        //instantiate receipt service, receipt and receipts
        m_rs = new BGBK.ReceiptService();
        receipt = new MUSW__Receipt__c();
        receipts = new List<MUSW__Receipt__c>{receipt};
            
            //set isPortUser by Utility
            isPortalUser = BGCM.UtilityUser.isPortalUser();
        
        
        m_settings = BGBK__CartSettings__c.getValues(Label.Str_Default);
        if (m_settings != null){
            canSelectReceipt = Boolean.valueOf(m_settings.BGBK__Allow_Existing_Receipt__c) && !isPortalUser;
        }
        else {
            //throw new BGCM.BGException(label.Str_Default_Cart_Settings_are_missing, true);
        }
    }
    
    public void availableReceipts () {
        pmtMethods = new Selectoption[]{};
            for (Schema.PicklistEntry pe : MUSW__Receipt__c.MUSW__Payment_Method__c.getDescribe().getPicklistValues()){
                pmtMethods.add(new Selectoption(pe.getValue(), pe.getLabel()));
                picklistSelections.add(pe.getValue());
            }
        if (contact != null && canSelectReceipt) {
            exs = m_rs.getAvailableReceiptsFor(contact.Id);
            if (exs.size() > 0){
                for (MUSW__Receipt__c r : exs){
                    pmtMethods.add(new Selectoption(r.Id, 'Existing:' + r.Name + ': $' + r.MUSW__Amount_Available__c));
                }
            }
        }
    }
    
    public Id parentid = null;
    public void continueToCheckout(){
        try{
            availableReceipts ();
            List<MUSW__Fee__c> feesToUpdate = new List<MUSW__Fee__c>();
            List < MUSW__Fee__c > parentFeesTodelete = new List < MUSW__Fee__c > ();
            List < MUSW__Fee__c > feesTodelete = new List < MUSW__Fee__c > ();
            List < sObject > parentObjectsTObeUpdated = new List < sObject > ();
            Map<String, FeeTable__c> FeeTable = RulesEngineFeeHandler.getAll();
            Set<Id> selectedFees = new Set<Id>();
            for(FeeWrapper feeWrapper : fees){
                feesToUpdate.add(new MUSW__Fee__c(Id = feeWrapper.fee.id, MUSW__Amount_Waived__c = feeWrapper.fee.MUSW__Amount_Waived__c));
                if(feeWrapper.checked){
                    String ruleName = DOL_AppConstants.NULL_EMPTY_STRING;
                    if(String.isNotBlank(feeWrapper.fee.Upsert_Id__c) && (feeWrapper.fee.Upsert_Id__c).contains('_')){
                        //Splits the Upsert Id on Fee to get the Parent Id and the Rule Name
                        for(String s: (feeWrapper.fee.Upsert_Id__c).split('_')){
                            if(s.length() < 15){
                                if(s.length() > 4){ ruleName = s; }
                            }
                            else{
                                parentid = ID.valueOf(s);
                            }
                        }    
                        if(FeeTable != null && FeeTable.containsKey(ruleName)){
                            //Checks to see if the created date of the fee is less than or equal to the Expiry Date on custom setting
                            FeeTable__c feeSetting = FeeTable.get(ruleName);
                            if(feeSetting!= null && feeSetting.Expiry_Date__c != null && feeSetting.Parent_Status_Field_API_Name__c != null 
                               && feeSetting.Status_value_Before_Fee_Generation__c != null 
                               && (getDate(feeWrapper.fee.CreatedDate) < feeSetting.Expiry_Date__c)){
                                   parentFeesTodelete.add(feeWrapper.fee); //Add it to the list for deletion
                                   feesTodelete.add(feeWrapper.fee);
                                   String sobjectName = parentid.getSobjectType().getDescribe().getName(); //Creates a new istance of parent Object based on the parentId from the Upsert_id__c field on fee
                                   Schema.SObjectType targetType = Schema.getGlobalDescribe().get(sobjectName);
                                   SObject newSobject = targetType.newSObject();
                                   newSobject.put('Id', parentid);
                                   newSobject.put(feeSetting.Parent_Status_Field_API_Name__c, feeSetting.Status_value_Before_Fee_Generation__c);
                                   parentObjectsTObeUpdated.add(newSobject);
                               }
                        }
                    }
                    selectedFees.add(feeWrapper.fee.Id);
                }
            }
            
            if(parentFeesTodelete.size() > 0){
                for (FeeWrapper feeWrapper: fees){
                    for(MUSW__Fee__c  feeToDel : parentFeesTodelete){
                        if(String.isNotBlank(feeWrapper.fee.Upsert_Id__c) && feeWrapper.fee.Upsert_Id__c.contains(feeToDel.id)){
                            feesTodelete.add(feeWrapper.fee);
                        }
                    }
                }
            }
            if(!feesTodelete.isEmpty()){
                isBackToRecordVisible = true;
                if (Schema.sObjectType.MUSW__Fee__c.isDeletable()) {
   					delete feesTodelete;
				}
                
                update parentObjectsTObeUpdated;
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.Str_The_fees_you_selected_have_expired_as_the_application_has_changed_click));
                return;
            }
            
            if(selectedFees.isEmpty()){
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.Str_Please_select_the_fees_you_wish_to_pay_before_continuing));
                return;
            }
            update feesToUpdate;
            
            feeList = null;        
            resetFeeList();
            
            for(FeeWrapper feeWrapper : fees)
                if(selectedFees.contains(feeWrapper.fee.Id))
                feeWrapper.checked = true;
            
            selectedTab = DOL_AppConstants.NULL_EMPTY_STRING + 'checkout';
        }catch(DMLException e){
            ApexPages.addMessages(e);
        }
        
    }
    public void backToItems()
    {
        selectedTab = DOL_AppConstants.NULL_EMPTY_STRING + 'Fees';
    }
    
    public Date getDate(Datetime dt){
        Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
        return myDate;
    }
    
    
    public PageReference backToRecord(){
        PageReference backToRecord = new PageReference('/'+parentid);
        backToRecord.setRedirect(true);
        return backToRecord;
    }
    
    public void resetFeeList()
    {
        fees = null;
    }
    
    /*public PageReference redirectToPaymentGateway()
    {
        List<String> queryParameters = new List<String>();
        
        for(String gatewayKey : formProperties.gatewayFields.keySet())
            queryParameters.add(gatewayKey + '=' + EncodingUtil.urlEncode(formProperties.gatewayFields.get(gatewayKey), label.Str_UTF_8));
        
        for(String paymentKey : formProperties.paymentFields.keySet())
            queryParameters.add(paymentKey + '=' + EncodingUtil.urlEncode(formProperties.paymentFields.get(paymentKey), label.Str_UTF_8));
        
        String queryString = String.join(queryParameters, '&');
        
        wwwCbossComDatatransfertokenizer10.BasicHttpBinding_Tokenization cbt = new wwwCbossComDatatransfertokenizer10.BasicHttpBinding_Tokenization();
        
        
        String token = Test.isRunningTest() ? 'TestToken123' : cbt.Tokenize(queryString);
        
        PageReference pr;
        
        if (!OH_Utilities.runningInASandbox())
            pr = new PageReference(Cboss_Settings__c.getInstance(label.Str_production).Payment_Gateway_URL__c);
        else
            pr = new PageReference(Cboss_Settings__c.getInstance(label.Str_sandbox).Payment_Gateway_URL__c);
        
        pr.getParameters().put('id', token);
        
        return pr;
    }*/
    
    public void processBackofficePayment(){
        try{
            Account acc = bgCartService.getActiveAccount();
            Map<MUSW__Receipt__c, Decimal> rsAmt = new Map<MUSW__Receipt__c, Decimal>();
            if(picklistSelections.contains(selectedPaymentOption)==false){
                receipt = m_rs.getReceipt((Id)selectedPaymentOption);
            }    
            receipt.BGBK__Cart__c = cart.Id;
            //receipt.Board__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Notary';
            receipt.MUSW__Amount_Tendered__c = amountTendered;
            receipt.Batch_Number__c = batchNum;
            //receipt.Payment_Comments__c = paymentComment;
            //receipt.Transaction_Number__c = transactionNum;
            receipt.MUSW__Paid_by__c = acc.Id;
            receipt.MUSW__Receipt_Paid_By__c = contact.Id;
            receipt.MUSW__Payment_Method__c = selectedpaymentOption;
            rsAmt.put(receipt, amountTendered);
            
            /*for(MUSW__Fee__c selectedFee : selectedFees){
                selectedFee.Transaction_Number__c = transactionNum;  
                if(selectedFee.MUSW__License2__c <> null)
                correspondingLicenseId = selectedFee.MUSW__License2__c;
            }
            update selectedFees;*/
            List<BGBK__Item__c> lstItems = new List<BGBK__Item__c>();								
	        BGBK__Transaction__c transactionReference  = new BGBK__Transaction__c();								
            transactionReference.BGBK__Account__c = acc.id;
            transactionReference.BGBK__Contact__c = contact.id;
            //transactionReference.BGBK__Total_Amount__c = amountTendered;
            insert transactionReference;
            
            
            
            //Get the available receipts            
            //instantiate payables and use in the fee wrapper
            List<BGBK.Payable> payables = new List<BGBK.Payable>();
            
            for(FeeWrapper feeWrapper : fees){
                if(feeWrapper.checked){
                    payables.add(new BGBK.Payable(feeWrapper.fee, feeWrapper.fee.MUSW__Outstanding_Fee__c));
                }
            }
            
            //instantiate the payment service
            BGBK.PaymentService m_ps = new BGBK.PaymentService();
            cart.BGBK__Process_DateTime__c = System.now();
            processSuccessful = m_ps.processPayment(payables, rsAmt, acc.Id, cart.BGBK__Process_DateTime__c);
            
            // Decimal pmtAmt = totalSelected; // - totalBalance;
            bgCartService.closeCart(amountTendered, acc.Id, cart.BGBK__Contact__c, cart.BGBK__Process_DateTime__c);
            
            selectedTab = DOL_AppConstants.NULL_EMPTY_STRING + 'Confirm';
            
            BGBK__Payment__c paymentinfo = new BGBK__Payment__c();
            if(!receipts.isEmpty())
            paymentinfo = [select id from BGBK__Payment__c where BGBK__Receipt__c = :receipts[0].id and BGBK__Receipt__c != null order by createddate desc LIMIT 1];
            
            Decimal value1 = (amountTendered*Integer.valueOf('10'))/100;
			Decimal value2 = amountTendered - value1;
            BGBK__Item__c itemData = new BGBK__Item__c();
            itemData.BGBK__Transaction__c = transactionReference.id;
            itemData.BGBK__Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Fee';
            itemData.BGBK__Price_Per_Unit__c = value1;
            itemData.BGBK__Fund__c= DOL_AppConstants.NULL_EMPTY_STRING + 'a1S5B0000007b3z';
			itemData.BGBK__Quantity__c = 1;
			if(paymentinfo <> null)
			itemData.BGBK__Payment__c = paymentinfo.id;
			if(!receipts.isEmpty())
			itemData.BGBK__Receipt__c = receipts[0].id;
			lstItems.add(itemData);
			
			BGBK__Item__c itemData1 = new BGBK__Item__c();
            itemData1.BGBK__Transaction__c = transactionReference.id;
            itemData1.BGBK__Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Fee';
            if(!receipts.isEmpty())
            itemData1.BGBK__Receipt__c = receipts[0].id;
            itemData1.BGBK__Fund__c= DOL_AppConstants.NULL_EMPTY_STRING + 'a1S5B0000007b3p';
            itemData1.BGBK__Price_Per_Unit__c = -value1;
            if(paymentinfo <> null)
			itemData1.BGBK__Payment__c = paymentinfo.id;
			itemData1.BGBK__Quantity__c = 1;
			lstItems.add(itemData1);
			
			BGBK__Item__c itemData2 = new BGBK__Item__c();
            itemData2.BGBK__Transaction__c = transactionReference.id;
            itemData2.BGBK__Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Fee';
            if(!receipts.isEmpty())
            itemData2.BGBK__Receipt__c = receipts[0].id;
            itemData2.BGBK__Fund__c= DOL_AppConstants.NULL_EMPTY_STRING + 'a1S5B0000007b3z';
            itemData2.BGBK__Price_Per_Unit__c = value2;
            if(paymentinfo <> null)
			itemData2.BGBK__Payment__c = paymentinfo.id;
			itemData2.BGBK__Quantity__c = 1;
			lstItems.add(itemData2);
			
			BGBK__Item__c itemData3 = new BGBK__Item__c();
            itemData3.BGBK__Transaction__c = transactionReference.id;
            itemData3.BGBK__Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Fee';
            if(!receipts.isEmpty())
            itemData3.BGBK__Receipt__c = receipts[0].id;
            itemData3.BGBK__Fund__c= DOL_AppConstants.NULL_EMPTY_STRING + 'a1S5B0000007b3u';
            itemData3.BGBK__Price_Per_Unit__c = -value2;
            if(paymentinfo <> null)
			itemData3.BGBK__Payment__c = paymentinfo.id;
			itemData3.BGBK__Quantity__c = 1;
			lstItems.add(itemData3);
			
            System.debug('Behave');
            for(MUSW__Fee_Payment__c feepayment:[Select id,MUSW__Fee__r.MUSW__Type__c,MUSW__Fee__r.MUSW__Amount__c from MUSW__Fee_Payment__c  where MUSW__Receipt__c=:receipts[0].id and MUSW__Fee__r.MUSW__Type__c=: DOL_AppConstants.NULL_EMPTY_STRING + 'Bad Check Fee']){
                
            BGBK__Item__c itemData4 = new BGBK__Item__c();
            itemData4.BGBK__Transaction__c = transactionReference.id;
            itemData4.BGBK__Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Fee';
            itemData4.BGBK__Receipt__c = receipts[0].id;
            itemData4.BGBK__Fund__c= DOL_AppConstants.NULL_EMPTY_STRING + 'a1S5B0000007b3u';
            itemData4.BGBK__Price_Per_Unit__c = -feepayment.MUSW__Fee__r.MUSW__Amount__c ;
            if(paymentinfo <> null)
			itemData4.BGBK__Payment__c = paymentinfo.id;
			itemData4.BGBK__Quantity__c = 1;
			lstItems.add(itemData4);
              
                System.debug('itemData4 '+itemData4);
            BGBK__Item__c itemData5 = new BGBK__Item__c();
            itemData5.BGBK__Transaction__c = transactionReference.id;
            itemData5.BGBK__Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Fee';
            itemData5.BGBK__Receipt__c = receipts[0].id;
            itemData5.BGBK__Fund__c= DOL_AppConstants.NULL_EMPTY_STRING + 'a1S5B0000007b3z';
            itemData5.BGBK__Price_Per_Unit__c = feepayment.MUSW__Fee__r.MUSW__Amount__c ;
            if(paymentinfo <> null)
			itemData5.BGBK__Payment__c = paymentinfo.id;
			itemData5.BGBK__Quantity__c = 1;
			lstItems.add(itemData5);
                 System.debug('itemData5 '+itemData5);
            }
              System.debug('Behave');
            System.debug('lstItems '+lstItems);
			insert lstItems;
			
        }catch(Exception ex){
            ApexPages.addMessages(ex);
        }
        //sendEmailWithAllAttachments();
    }
    
    public void showCheck () {
        if(receipt.MUSW__Payment_Method__c == 'Check'){
            checkNumber = true;
        }else{
            checkNumber = false;
        }
    } 
    
    /*public void sendEmailWithAllAttachments()
    {
        //try{
        Blob body;
        Blob body2;
        
        PageReference pdf = Page.ApplicationSaveIncomplete;
    
        // add parent id to the parameters for standardcontroller
        pdf.getParameters().put('applicationType','License');
        MUSW__License2__c licData = new MUSW__License2__c();
        if(correspondingLicenseId <> null && correspondingLicenseId <> '')
        {
            licData = [select id, MUSW__Applicant__c, MUSW__Applicant__r.Email from MUSW__License2__c where id = :correspondingLicenseId order by createddate desc LIMIT 1];
        }
        else
            licData = [select id from MUSW__License2__c order by createddate desc LIMIT 1];
        
        pdf.getParameters().put('pid',licData.id);
        
        PageReference pdf2 = Page.CartPrint_Global;
        pdf2.getParameters().put('cartId',cart.Id);
        pdf2.getParameters().put('email',contact.email);
        pdf2.getParameters().put('recId',receipt.Id);
        try {
          
          // returns the output of the page as a PDF
          body = pdf.getContent();
          body2= pdf2.getContent();
          
        // need to pass unit test -- current bug  
        } catch (VisualforceException e) {
          //body = Blob.valueOf('Some Text');
        }
            
        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        attach.setContentType('application/pdf');
        attach.setFileName('application.pdf');
        attach.setInline(false);
        attach.Body = body;
        
        Messaging.EmailFileAttachment attach2 = new Messaging.EmailFileAttachment();
        attach2.setContentType('application/pdf');
        attach2.setFileName('receipt.pdf');
        attach2.setInline(false);
        attach2.Body = body2;
    
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setUseSignature(false);
        List<String> strProvidedIds = new List<String>();
        
        List<String> lstEmailIds = new List<String>();
        lstEmailIds = Label.EmailList.split(',');
        
        if(!lstEmailIds.isEmpty())
        strProvidedIds.addAll(lstEmailIds);
        //mail.setToAddresses(lstEmailIds );
        else
        strProvidedIds.add('skanjilal@deloitte.com');
        
        if(licData <> null && licData.MUSW__Applicant__c <> null && licData.MUSW__Applicant__r.Email <> null)
        {strProvidedIds.add(licData.MUSW__Applicant__r.Email);
        System.debug(' Sumeet Inside Data  '+licData.MUSW__Applicant__r.Email);
        }
        //mail.setToAddresses(new List<String>{'skanjilal@deloitte.com'});
        
        mail.setToAddresses(strProvidedIds);
        
        mail.setSubject('PDF Email Payment Confirmation Acknowledgement');
        mail.setHtmlBody(Label.EmailBody);
        if(body <> null)
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach,attach2 }); 
        else
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach2 }); 
        
        // Send the email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        //}catch(Exception ex){System.debug}
    
    }*/
    
    public class FeeWrapper
    {
        public FeeWrapper(MUSW__Fee__c fee, boolean checked)
        {
            this.fee = fee;
            this.checked = checked;
        }
        
        public boolean checked {get; set;}
        public MUSW__Fee__c fee {get; set;}
    }
    
}