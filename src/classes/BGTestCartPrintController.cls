public class BGTestCartPrintController {
	public BGBK__Cart__c cart { get; set; }
    public MUSW__Fee__c[] fees { get; set; }
    public BGBK__Bill__c[] invoices { get; set; }
    public MUSW__Deposit__c[] deposits { get; set; }
    public MUSW__Fee_Payment__c[] feePayments {get; set;}
    public MUSW__Fee_Payment__c[] invoicePayments {get; set;}
    public MUSW__Payable_Receipt__c[] depositPayments {get; set;}
    public MUSW__Receipt__c[] rs { get; set; }
    public String emailAddress { get; set; }
    public Decimal totalAmount { get; set; }
    public String websiteUrl { get; set; }
    public BGBK__Payment__c pmt { get; set; }
    public Boolean paymentFailed { get; set; }
    public String now { get; set; }

    public BGTestCartPrintController() {
        totalAmount = 0;
        String whereRsFilter = '';
        String whereFsFilter = '';
        rs = new MUSW__Receipt__c[] {};
        now = System.now().format();

        Id cartId = System.currentPageReference().getParameters().get('cartId');
        emailAddress = System.currentPageReference().getParameters().get('email');
        Id recId = System.currentPageReference().getParameters().get('recId');
        Id pmtId = System.currentPageReference().getParameters().get('pmtId');
        String pmtFailed = System.currentPageReference().getParameters().get('pmtFailed');
        if (pmtFailed != null) paymentFailed = Boolean.valueOf(pmtFailed);

        if (!String.isBlank(cartId)) {
            BGBK.CartService cs = new BGBK.CartService(null, cartId);
            cart = cs.getCart();
            invoices = cs.getCartInvoices(false);
            deposits = cs.getCartDeposits(false);

            //System.debug('^^ recId: ' + recId);
            if (!String.isBlank(recId)) {
                BGBK.ReceiptService rsvc = new BGBK.ReceiptService();
                rs = new MUSW__Receipt__c[] {rsvc.getReceipt(recId)};
            } else {
                rs = cs.getCartReceipts();
                //System.debug('^^ receipts22222: ' + rs);
            }
            //System.debug('^^ receipts: ' + rs);
            //System.debug('^^ receipts query : ' + [SELECT Id,Name,MUSW__Payment_Gateway_Transaction_Number__c,MUSW__Status__c,Status__c,LastModifiedDate FROM MUSW__Receipt__c WHERE BGBK__Cart__c = :cartId]);
            //System.debug('^^ cart: ' + [SELECT Id, Name, BGBK__Status__c, BGBK__Process_DateTime__c, BGBK__Type__c FROM BGBK__Cart__c WHERE Id = :cartId]);

            // get fees from receipts excluding invoiced fees
            Set<Id> rsIds = (new Map<Id, MUSW__Receipt__c>(rs)).keySet();
            List<Schema.FieldSetMember> feePaymentFieldSets = SObjectType.MUSW__Fee_Payment__c.FieldSets.BGBK__Feebasic.getFields();

            //Populate fields from field set
            String fpFields = 'Id, ';
            fpFields += 'MUSW__Fee__r.' + BGCM.UtilitySObject.getFieldsetFor_Str('MUSW__Fee__c', 'BGBK__Fee_Basic').replace(', ', ', MUSW__Fee__r.');
            fpFields += ', BGBK__Invoice__r.' + BGCM.UtilitySObject.getFieldsetFor_Str('BGBK__Bill__c', 'BGBK__Invoice_Basic').replace(', ', ', BGBK__Invoice__r.');
            for (Schema.FieldSetMember f : feePaymentFieldSets) {
                String fieldName = f.getFieldPath();
                if (! fpFields.contains(fieldName))
                    fpFields += ', ' + fieldName;
            }

            // also checking if the receipt doesn't have a payment method of 'Deposit',
            // because in case of payment using deposit creates another receipt under the cart which is redundant
            feePayments = database.query('select ' + fpFields + ' from MUSW__Fee_Payment__c where (BGBK__Payment__r.BGBK__Deposit__c!=null or (MUSW__Receipt__c in :rsIds and MUSW__Receipt__r.MUSW__Payment_Method__c != \'Deposit\')) and BGBK__Invoice__c = null and BGBK__Cart__c = :cartId');

            fees = new MUSW__Fee__c[] {};
            // BGCORE-144: multiple payments could point to same fee record
            Set<Id> addedFeeIds = new Set<Id>();
            for (MUSW__Fee_Payment__c fp : feePayments) {
                if (addedFeeIds.contains(fp.MUSW__Fee__r.id)) continue;
                addedFeeIds.add(fp.MUSW__Fee__r.id);
                fees.add(fp.MUSW__Fee__r);
            }

            // Populate invoicePayments
            invoicePayments = new MUSW__Fee_Payment__c[] {};
            if (invoices.size() > 0) {
                Set<Id> invIds = new Set<Id>();
                for (BGBK__Bill__c inv : invoices) {
                    invIds.add(inv.Id);
                }
                invoicePayments = database.query('select ' + fpFields + ' from MUSW__Fee_Payment__c where MUSW__Receipt__c in :rsIds and BGBK__Invoice__c in :invIds and BGBK__Cart__c = :cartId');
            } else {
                // also checking if the receipt doesn't have a payment method of 'Deposit',
                // because in case of payment using deposit creates another receipt under the cart which is redundant
                invoicePayments = database.query('select ' + fpFields + ' from MUSW__Fee_Payment__c where BGBK__Invoice__c != null and (BGBK__Payment__r.BGBK__Deposit__c!=null or (MUSW__Receipt__c in :rsIds and MUSW__Receipt__r.MUSW__Payment_Method__c != \'Deposit\')) and BGBK__Cart__c = :cartId');
            }

            // Populate depositPayments
            depositPayments = new MUSW__Payable_Receipt__c[] {};
            List<Schema.FieldSetMember> depFieldSets = SObjectType.MUSW__Payable_Receipt__c.FieldSets.BGBK__Deposit_Basic.getFields();
            String prFields = 'Id';

            //Populate fields from field set
            for (Schema.FieldSetMember f : depFieldSets) {
                String fieldName = f.getFieldPath();
                prFields += ', ' + fieldName;
            }
            if (deposits.size() > 0) {
                Set<Id> depIds = new Set<Id>();
                for (MUSW__Deposit__c dep : deposits) {
                    depIds.add(dep.Id);
                }

                depositPayments = database.query('select ' + prFields + ' FROM MUSW__Payable_Receipt__c WHERE MUSW__Deposit__c IN :depIds and MUSW__Receipt__c in :rsIds and BGBK__Cart__c = :cartId');
            } else {
                depositPayments = database.query('select ' + prFields + ' FROM MUSW__Payable_Receipt__c WHERE MUSW__Deposit__c != null and MUSW__Receipt__c in :rsIds and BGBK__Cart__c = :cartId');
            }

            totalAmount = cart.BGBK__Last_Payment_Amount__c;
        }

        if (!String.isBlank(pmtId)) {
            pmt = database.query('Select BGBK__Receipt__r.MUSW__Receipt_Paid_By__c, BGBK__Receipt__r.Name, BGBK__Receipt__r.MUSW__Amount_Tendered__c, ' + MUSW.UtilityDb.getFieldsFor_Str('BGBK__Payment__c', false) + ' from BGBK__Payment__c where Id=:pmtId');
        }

        // get the website url to display on the print receipt page
        Account[] cis = [select Website from Account where site = 'COMPANY INFO' ];
        if (cis != null && cis.size() > 0) websiteUrl = cis[0].Website;

        //System.debug('^^^ ' + cart);
        //System.debug('^^^ ' + rs);
        //System.debug('^^^ ' + fees);
        //System.debug('^^^ ' + feePayments);
    }
}