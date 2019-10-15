@isTest
public class CartControllerTest {
    
   @testSetup
    public static void setup(){
        BGBK__CartSettings__c cs = new BGBK__CartSettings__c();
        cs.Name = 'Default';
        cs.BGBK__Allow_Existing_Receipt__c = true;
        cs.BGBK__Allow_Multiple_Payment_Methods__c = true;
        cs.BGBK__Allow_Partial_Payments__c = true;
        cs.BGBK__Allow_Pay_By_Deposit__c = true;
        cs.BGBK__Enable_Cashier_Cart__c = true;
        cs.BGBK__BG_Verification_PIN_API_Name__c = 'PIN__c';
        cs.BGBK__Cart_Page__c = 'Cart';
        cs.BGBK__Payment_Gateway_Data_Encryption_Key__c = 'BasicGovPayments';
        insert cs;
    }
    @isTest
    public static void testMethod1(){
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('User Account').getRecordTypeId();
        Account acc = DOL_TestDataFactory.createAccount(accRecId);
        
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        Contact c = DOL_TestDataFactory.createContact(conRecId, acc.Id);
        
        MUSW__Account_Contact__c accCon = new MUSW__Account_Contact__c(MUSW__Account__c=acc.Id,	
                                                                       MUSW__Contact__c=c.Id);
        insert accCon;
        
        BGBK__Cart__c testCart = new BGBK__Cart__c(BGBK__Account__c= acc.Id, 
                                                   BGBK__Contact__c= c.Id, 
                                                   BGBK__Expiration_DateTime__c=system.now().addDays(1));
        insert testCart;
        
        Id LicenseRecType = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        MUSW__License2__c lic = DOL_TestDataFactory.createLicense(LicenseRecType, acc.Id, 'Architects', 'Architect', 'General Application');
        
        MUSW__Fee__c objFee = DOL_TestDataFactory.createFeeWithLicense('General',100.00,lic.id);
        objFee.BGBK__Cart__c = testCart.Id;
        update objFee;
        
        MUSW__Fee__c objFee2 = DOL_TestDataFactory.createFeeWithLicense('Trust Expense - Staff Hours',100.00,lic.id);
        objFee2.BGBK__Cart__c = testCart.Id;
        update objFee2; 
        
        Double totalDue = 0;
        
        List<String> feeIds = new List<String>();
        feeIds.add(objFee.Id);
        feeIds.add(objFee2.Id);
        totalDue = objFee.MUSW__Amount__c;
        
        
        // create Receipt
        MUSW__Receipt__c receipt = new MUSW__Receipt__c();
        receipt.BGBK__Cart__c = testCart.Id;
        receipt.Status__c = 'Draft';
        receipt.Bank_Name__c = DOL_AppConstants.NULL_EMPTY_STRING + 'DOL Bank';
        receipt.MUSW__Payment_Gateway_Transaction_Number__c = DOL_AppConstants.NULL_EMPTY_STRING + '000000ABCD';
        receipt.Selected_Fees__c = String.join(feeIds,',');
        insert receipt;
        
        List<MUSW__Fee__c> feeList = new List<MUSW__Fee__c>();
        feeList.add(objFee);
        feeList.add(objFee2);
        
        
        Test.startTest();
        PageReference pageRef = Page.Cart;
        pageRef.getParameters().put('feeId', String.valueOf(objFee.Id));
        pageRef.getParameters().put('id', String.valueOf(testCart.Id));
        Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(feeList);
        stdSetController.setSelected(feeList);
        CartController cartCtrl = new CartController(stdSetController);
        cartCtrl.initOrder();
        cartCtrl.accountChanged();
        cartCtrl.refreshFeesTab();
        cartCtrl.checkout();
        cartCtrl.review();
        cartCtrl.addReceipt();
        cartCtrl.preparePayables();
        cartCtrl.checkExistingReceipt();
        //cartCtrl.onPaymentConfirmation();
        cartCtrl.process();
        cartCtrl.startPoll();
        cartCtrl.batchJobPoll();
        cartCtrl.abandon();
        cartCtrl.backToItems();
        cartCtrl.cancel();
        cartCtrl.redirectToPaymentGateway();
        cartCtrl.returnToPrevPage();
        
        Test.stopTest();
        
        
        
    }
    
    @isTest
    public static void testMethod2(){
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('User Account').getRecordTypeId();
        Account acc = DOL_TestDataFactory.createAccount(accRecId);
        
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        Contact c = DOL_TestDataFactory.createContact(conRecId, acc.Id);
        
        Contact cq = [select AccountId from Contact where Id=:c.Id];
        
        MUSW__Account_Contact__c accCon = new MUSW__Account_Contact__c(MUSW__Account__c=acc.Id,	
                                                                       MUSW__Contact__c=c.Id);
        insert accCon;
        
        BGBK__Cart__c testCart = new BGBK__Cart__c(BGBK__Account__c= cq.AccountId, 
                                                   BGBK__Contact__c= cq.Id, 
                                                   BGBK__Expiration_DateTime__c=system.now().addDays(1));
        insert testCart;
        
        Id LicenseRecType = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        MUSW__License2__c lic = DOL_TestDataFactory.createLicense(LicenseRecType, acc.Id, 'Architects', 'Architect', 'General Application');
        
        MUSW__Fee__c objFee = DOL_TestDataFactory.createFeeWithLicense('General',100.00,lic.id);
        objFee.BGBK__Cart__c = testCart.Id;
        update objFee;
        
        MUSW__Fee__c objFee2 = DOL_TestDataFactory.createFeeWithLicense('Trust Expense - Staff Hours',100.00,lic.id);
        objFee2.BGBK__Cart__c = testCart.Id;
        update objFee2; 
        
        Double totalDue = 0;
        
        List<String> feeIds = new List<String>();
        feeIds.add(objFee.Id);
        feeIds.add(objFee2.Id);
        totalDue = objFee.MUSW__Amount__c;
        
        
        // create Receipt
        MUSW__Receipt__c receipt = new MUSW__Receipt__c();
        receipt.BGBK__Cart__c = testCart.Id;
        receipt.Status__c = 'Draft';
        receipt.Bank_Name__c = DOL_AppConstants.NULL_EMPTY_STRING + 'DOL Bank';
        receipt.MUSW__Payment_Gateway_Transaction_Number__c = DOL_AppConstants.NULL_EMPTY_STRING + '000000ABCD';
        receipt.Selected_Fees__c = String.join(feeIds,',');
        insert receipt;
        
        List<MUSW__Fee__c> feeList = new List<MUSW__Fee__c>();
        feeList.add(objFee);
        feeList.add(objFee2);
        
        
        Test.startTest();
        PageReference pageRef = Page.Cart;
        pageRef.getParameters().put('feeId', String.valueOf(objFee.Id));
        Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(feeList);
        stdSetController.setSelected(feeList);
        CartController cartCtrl = new CartController(stdSetController);
        cartCtrl.initOrder();
        cartCtrl.accountChanged();
        cartCtrl.refreshFeesTab();
        cartCtrl.checkout();
        cartCtrl.review();
        cartCtrl.addReceipt();
        cartCtrl.preparePayables();
        cartCtrl.checkExistingReceipt();
        //cartCtrl.onPaymentConfirmation();
        cartCtrl.process();
        cartCtrl.startPoll();
        cartCtrl.batchJobPoll();
        cartCtrl.sendPdf();
        cartCtrl.abandon();
        cartCtrl.backToItems();
        cartCtrl.redirectToPaymentGateway();
        cartCtrl.returnToPrevPage();
        
        Test.stopTest();
     }
    
    @isTest
    public static void testMethod3(){
        
        User portalUser =  DOL_TestDataFactory.createPortalAccountUser();
        
        system.runAs(portalUser){
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('User Account').getRecordTypeId();
        Account acc = DOL_TestDataFactory.createAccount(accRecId);
        
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        Contact c = DOL_TestDataFactory.createContact(conRecId, acc.Id);
        
        Contact cq = [select AccountId from Contact where Id=:c.Id];
        
        MUSW__Account_Contact__c accCon = new MUSW__Account_Contact__c(MUSW__Account__c=acc.Id,	
                                                                       MUSW__Contact__c=c.Id);
        insert accCon;
        
        BGBK__Cart__c testCart = new BGBK__Cart__c(BGBK__Account__c= cq.AccountId, 
                                                   BGBK__Contact__c= cq.Id, 
                                                   BGBK__Expiration_DateTime__c=system.now().addDays(1));
        insert testCart;
        
        Id LicenseRecType = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        MUSW__License2__c lic = DOL_TestDataFactory.createLicense(LicenseRecType, acc.Id, 'Architects', 'Architect', 'General Application');
        
        MUSW__Fee__c objFee = DOL_TestDataFactory.createFeeWithLicense('General',100.00,lic.id);
        objFee.BGBK__Cart__c = testCart.Id;
        update objFee;
        
        MUSW__Fee__c objFee2 = DOL_TestDataFactory.createFeeWithLicense('Trust Expense - Staff Hours',100.00,lic.id);
        objFee2.BGBK__Cart__c = testCart.Id;
        update objFee2; 
        
        Double totalDue = 0;
        
        List<String> feeIds = new List<String>();
        feeIds.add(objFee.Id);
        feeIds.add(objFee2.Id);
        totalDue = objFee.MUSW__Amount__c;
        
        
        // create Receipt
        MUSW__Receipt__c receipt = new MUSW__Receipt__c();
        receipt.BGBK__Cart__c = testCart.Id;
        receipt.Status__c = 'Draft';
        receipt.Bank_Name__c = DOL_AppConstants.NULL_EMPTY_STRING + 'DOL Bank';
        receipt.MUSW__Payment_Gateway_Transaction_Number__c = DOL_AppConstants.NULL_EMPTY_STRING + '000000ABCD';
        receipt.Selected_Fees__c = String.join(feeIds,',');
        insert receipt;
        
        
        List<MUSW__Fee__c> feeList = new List<MUSW__Fee__c>();
        feeList.add(objFee);
        feeList.add(objFee2);
        
        
        
            PageReference pageRef = Page.Cart;
            pageRef.getParameters().put('feeId', String.valueOf(objFee.Id));
            pageRef.getParameters().put('id', String.valueOf(testCart.Id));
            Test.setCurrentPage(pageRef);
            ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(feeList);
            stdSetController.setSelected(feeList);
            CartController cartCtrl = new CartController(stdSetController);
            cartCtrl.initOrder();
            cartCtrl.accountChanged();
            cartCtrl.refreshFeesTab();
            cartCtrl.checkout();
            cartCtrl.review();
            cartCtrl.addReceipt();
            cartCtrl.preparePayables();
            cartCtrl.checkExistingReceipt();
            //cartCtrl.onPaymentConfirmation();
            cartCtrl.process();
            cartCtrl.startPoll();
            cartCtrl.batchJobPoll();
            cartCtrl.abandon();
            cartCtrl.backToItems();
            cartCtrl.cancel();
            cartCtrl.contactChanged();
            cartCtrl.redirectToPaymentGateway();
            cartCtrl.returnToPrevPage();
        }
       
    }
    
    @isTest
    public static void testMethod4(){
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('User Account').getRecordTypeId();
        Account acc = DOL_TestDataFactory.createAccount(accRecId);
        
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        Contact c = DOL_TestDataFactory.createContact(conRecId, acc.Id);
        
        Contact cq = [select AccountId from Contact where Id=:c.Id];
        
        MUSW__Account_Contact__c accCon = new MUSW__Account_Contact__c(MUSW__Account__c=acc.Id,	
                                                                       MUSW__Contact__c=c.Id);
        insert accCon;
        
        BGBK__Cart__c testCart = new BGBK__Cart__c(BGBK__Account__c= cq.AccountId, 
                                                   BGBK__Contact__c= cq.Id, 
                                                   BGBK__Expiration_DateTime__c=system.now().addDays(1));
        insert testCart;
        
        Id LicenseRecType = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        MUSW__License2__c lic = DOL_TestDataFactory.createLicense(LicenseRecType, acc.Id, 'Architects', 'Architect', 'General Application');
        
        MUSW__Fee__c objFee = DOL_TestDataFactory.createFeeWithLicense('General',100.00,lic.id);
        objFee.BGBK__Cart__c = testCart.Id;
        update objFee;
        
        MUSW__Fee__c objFee2 = DOL_TestDataFactory.createFeeWithLicense('Trust Expense - Staff Hours',100.00,lic.id);
        objFee2.BGBK__Cart__c = testCart.Id;
        update objFee2; 
        
        Double totalDue = 0;
        
        List<String> feeIds = new List<String>();
        feeIds.add(objFee.Id);
        feeIds.add(objFee2.Id);
        totalDue = objFee.MUSW__Amount__c;
        
        
        // create Receipt
        MUSW__Receipt__c receipt = new MUSW__Receipt__c();
        receipt.BGBK__Cart__c = testCart.Id;
        receipt.Status__c = 'Draft';
        receipt.Bank_Name__c = DOL_AppConstants.NULL_EMPTY_STRING + 'DOL Bank';
        receipt.MUSW__Payment_Gateway_Transaction_Number__c = DOL_AppConstants.NULL_EMPTY_STRING + '000000ABCD';
        receipt.Selected_Fees__c = String.join(feeIds,',');
        insert receipt;
        
        List<MUSW__Fee__c> feeList = new List<MUSW__Fee__c>();
        feeList.add(objFee);
        feeList.add(objFee2);
        
        
        Test.startTest();
        PageReference pageRef = Page.Cart;
        pageRef.getParameters().put('depositAccountId', String.valueOf(acc.Id));
        Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(feeList);
        stdSetController.setSelected(feeList);
        CartController cartCtrl = new CartController(stdSetController);
        cartCtrl.initOrder();
        cartCtrl.accountChanged();
        cartCtrl.refreshFeesTab();
        cartCtrl.checkout();
        cartCtrl.review();
        cartCtrl.preparePayables();
        //cartCtrl.useDeposit();
        //cartCtrl.validateAmount();
        cartCtrl.checkExistingReceipt();
        //cartCtrl.onPaymentConfirmation();
        //cartCtrl.TransferFee();
        cartCtrl.process();
        cartCtrl.startPoll();
        cartCtrl.batchJobPoll();
        //cartCtrl.sendPdf();
        cartCtrl.abandon();
        //cartCtrl.printReceipt();
        cartCtrl.backToItems();
        cartCtrl.cancel();
        //cartCtrl.refreshTotal();
        //cartCtrl.refreshTotalAndCheckout();
        //cartCtrl.contactChanged();
        //cartCtrl.doReconcile();
        //cartCtrl.cancelReconcile();
        //cartCtrl.checkGatewayRequirementforPaymentMethod();
        cartCtrl.redirectToPaymentGateway();
        cartCtrl.returnToPrevPage();
        
        Test.stopTest();
     }
    
    @isTest
    public static void testMethod5(){
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('User Account').getRecordTypeId();
        Account acc = DOL_TestDataFactory.createAccount(accRecId);
        BGBK__Bill__c inv = new BGBK__Bill__c();
        inv.BGBK__Recipient2__c = acc.Id;
        insert inv;
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        Contact c = DOL_TestDataFactory.createContact(conRecId, acc.Id);
        
        Contact cq = [select AccountId from Contact where Id=:c.Id];
        
        MUSW__Account_Contact__c accCon = new MUSW__Account_Contact__c(MUSW__Account__c=acc.Id,	
                                                                       MUSW__Contact__c=c.Id);
        insert accCon;
        
        BGBK__Cart__c testCart = new BGBK__Cart__c(BGBK__Account__c= cq.AccountId, 
                                                   BGBK__Contact__c= cq.Id, 
                                                   BGBK__Expiration_DateTime__c=system.now().addDays(1));
        insert testCart;
        
        Id LicenseRecType = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        MUSW__License2__c lic = DOL_TestDataFactory.createLicense(LicenseRecType, acc.Id, 'Architects', 'Architect', 'General Application');
        
        MUSW__Fee__c objFee = DOL_TestDataFactory.createFeeWithLicense('General',100.00,lic.id);
        objFee.BGBK__Cart__c = testCart.Id;
        objFee.BGBK__Invoice__c = inv.Id;
        update objFee;
        
        MUSW__Fee__c objFee2 = DOL_TestDataFactory.createFeeWithLicense('Trust Expense - Staff Hours',100.00,lic.id);
        objFee2.BGBK__Cart__c = testCart.Id;
        update objFee2; 
        
        Double totalDue = 0;
        
        List<String> feeIds = new List<String>();
        feeIds.add(objFee.Id);
        feeIds.add(objFee2.Id);
        totalDue = objFee.MUSW__Amount__c;
        
        
        // create Receipt
        MUSW__Receipt__c receipt = new MUSW__Receipt__c();
        receipt.BGBK__Cart__c = testCart.Id;
        receipt.Status__c = 'Draft';
        receipt.Bank_Name__c = DOL_AppConstants.NULL_EMPTY_STRING + 'DOL Bank';
        receipt.MUSW__Payment_Gateway_Transaction_Number__c = DOL_AppConstants.NULL_EMPTY_STRING + '000000ABCD';
        receipt.Selected_Fees__c = String.join(feeIds,',');
        insert receipt;
        
        List<MUSW__Fee__c> feeList = new List<MUSW__Fee__c>();
        feeList.add(objFee);
        feeList.add(objFee2);
        
        
        
        
        Test.startTest();
        PageReference pageRef = Page.Cart;
        pageRef.getParameters().put('invoiceId', String.valueOf(inv.Id));
        Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(feeList);
        stdSetController.setSelected(feeList);
        CartController cartCtrl = new CartController(stdSetController);
        cartCtrl.initOrder();
        cartCtrl.accountChanged();
        cartCtrl.refreshFeesTab();
        cartCtrl.checkout();
        cartCtrl.review();
        cartCtrl.addReceipt();
        //cartCtrl.delReceipt();
        cartCtrl.preparePayables();
        //cartCtrl.useDeposit();
        //cartCtrl.validateAmount();
        cartCtrl.checkExistingReceipt();
        //cartCtrl.onPaymentConfirmation();
        //cartCtrl.TransferFee();
        cartCtrl.process();
        cartCtrl.startPoll();
        cartCtrl.batchJobPoll();
        cartCtrl.abandon();
        cartCtrl.backToItems();
        cartCtrl.cancel();
        cartCtrl.redirectToPaymentGateway();
        cartCtrl.returnToPrevPage();
        
        Test.stopTest();
     }
    
    
    @isTest
    public static void testMethodEPayment(){
        
        Map<String,String> integrationMetadataMap = DOL_AppConstants.integrationSettingsMetadataMap;
    
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('User Account').getRecordTypeId();
        Account acc = DOL_TestDataFactory.createAccount(accRecId);
        
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        Contact c = DOL_TestDataFactory.createContact(conRecId, acc.Id);
        
        Contact cq = [select AccountId from Contact where Id=:c.Id];
        
        MUSW__Account_Contact__c accCon = new MUSW__Account_Contact__c(MUSW__Account__c=acc.Id,	
                                                                       MUSW__Contact__c=c.Id);
        insert accCon;
        
        BGBK__Cart__c testCart = new BGBK__Cart__c(BGBK__Account__c= cq.AccountId, 
                                                   BGBK__Contact__c= cq.Id, 
                                                   BGBK__Expiration_DateTime__c=system.now().addDays(1));
        insert testCart;
        BGBK__Bill__c inv = new BGBK__Bill__c();
        inv.BGBK__Recipient2__c = acc.Id;
        inv.BGBK__Cart__c = testCart.Id;
        insert inv;
        
        Id LicenseRecType = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        MUSW__License2__c lic = DOL_TestDataFactory.createLicense(LicenseRecType, acc.Id, 'Architects', 'Architect', 'General Application');
        
        MUSW__Fee__c objFee = DOL_TestDataFactory.createFeeWithLicense('General',100.00,lic.id);
        objFee.BGBK__Cart__c = testCart.Id;
        objFee.BGBK__Invoice__c = inv.Id;
        update objFee;
        
        MUSW__Fee__c objFee2 = DOL_TestDataFactory.createFeeWithLicense('Trust Expense - Staff Hours',100.00,lic.id);
        objFee2.BGBK__Cart__c = testCart.Id;
        update objFee2; 
        
        Double totalDue = 0;
        
        List<String> feeIds = new List<String>();
        feeIds.add(objFee.Id);
        feeIds.add(objFee2.Id);
        totalDue = objFee.MUSW__Amount__c;
        
        
        // create Receipt
        MUSW__Receipt__c receipt = new MUSW__Receipt__c();
        receipt.BGBK__Cart__c = testCart.Id;
        receipt.Status__c = 'Draft';
        receipt.Bank_Name__c = DOL_AppConstants.NULL_EMPTY_STRING + 'DOL Bank';
        receipt.MUSW__Payment_Gateway_Transaction_Number__c = DOL_AppConstants.NULL_EMPTY_STRING + '000000ABCD';
        receipt.Selected_Fees__c = String.join(feeIds,',');
        insert receipt;
        
        
        List<MUSW__Fee__c> feeList = new List<MUSW__Fee__c>();
        feeList.add(objFee);
        feeList.add(objFee2);
                
        String returnSessionString = DOL_AppConstants.NULL_EMPTY_STRING + 'TransactionConfirmationID=000000ABCD&SFDClicId='+receipt.Id+'&PaymentEffectiveDate=20190923&InitiationDateTime=20190923***060215&PaymentMethod=ACH&AccountNumber=7654&CreditCardNumber=545498765';
        DOL_ePaymentSessionTransferDetails detail = new DOL_ePaymentSessionTransferDetails('Licensing',
                                                                                           '100',
                                                                                           'ACH',
                                                                                           c.Id,
                                                                                           testCart.Id,
                                                                                           feeIds,
                                                                                           true);
        detail.returnValue = lic.Id;
        detail.SFDClicId = receipt.Id;
        
        
            // setting contact details
            detail.setContactDetails();
            // get the Map of requiredParam and Value
            Map<String,String> sessionDetailsMap = detail.getSessionDetailsMap();
            // creation of session String
            String sessionDetailForEncryption = '';
            for(String key : sessionDetailsMap.keySet()){
                sessionDetailForEncryption += key+'='+sessionDetailsMap.get(key)+'&';
            }
        	sessionDetailForEncryption+='TransactionConfirmationID=000000ABCD&PaymentEffectiveDate=20190923&InitiationDateTime=20190923***060215&AccountNumber=7654&CreditCardNumber=545498765';
            System.debug('sessionDetailForEncryption = '+sessionDetailForEncryption);
            // conversion of session string into encrypted string
            String encryptedSessionDetailString = CryptoUtility.getEncryptedString('AES256', 
                                                  	integrationMetadataMap.get(DOL_AppConstants.ePaymentEncryptionKeyLabel), 
                                                    integrationMetadataMap.get(DOL_AppConstants.ePaymentEncryptionIVLabel), 
                                                    sessionDetailForEncryption);
            
        
        
        Test.startTest();
        //Test.setCurrentPage(Page.Cart);
        Test.setCurrentPageReference(Page.Cart);
        System.currentPageReference().getParameters().put('session', encryptedSessionDetailString);
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(feeList);
        stdSetController.setSelected(feeList);
        CartController cartCtrl = new CartController(stdSetController);
        cartCtrl.initOrder();
        cartCtrl.accountChanged();
        cartCtrl.refreshFeesTab();
        cartCtrl.checkout();
        cartCtrl.review();
        cartCtrl.addReceipt();
        cartCtrl.preparePayables();
        cartCtrl.checkExistingReceipt();
        //cartCtrl.onPaymentConfirmation();
        cartCtrl.process();
        cartCtrl.startPoll();
        cartCtrl.batchJobPoll();
        cartCtrl.sendPdf();
        cartCtrl.abandon();
        cartCtrl.backToItems();
        cartCtrl.redirectToPaymentGateway();
        cartCtrl.returnToPrevPage();
        
        Test.stopTest();
        
        
        
    }
    
    
}