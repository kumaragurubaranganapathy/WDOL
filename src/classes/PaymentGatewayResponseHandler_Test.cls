@isTest
public class PaymentGatewayResponseHandler_Test {

    @testSetup
    public static void setupTestData(){
        Global_Settings__c globalSetting = new Global_Settings__c(Name = UserInfo.getUsername(), Disable_Triggers__c = true);
        insert globalSetting;
        
        BGBK__CartSettings__c cartSettings = new BGBK__CartSettings__c(Name = 'Default', BGBK__Payable_Parents__c = 'MUSW__License2__c, MUSW__Application2__c, License_Renewal__c', BGBK__Payment_Gateway_Data_Encryption_Key__c = 'BasicGovPayments');
        insert cartSettings;
        
        /*Creating test Account*/
        Account acc = new Account();
        acc = CreateTestDataUtility.createAccount();
        /*Inserting test Account*/
        insert acc;
        
        /*Creating test Contact*/
        Contact con = CreateTestDataUtility.createContact(acc.Id);
        /*Inserting test Contact*/
        insert con;   
        
        /*Creating test License*/
        Musw__License2__c license1 = CreateTestDataUtility.createLicense(acc.Id, con.Id);
        /*Inserting test License to fire License Trigger*/
        insert license1;
        
        BGBK__Cart__c cart = new BGBK__Cart__c();
        cart.BGBK__Account__c = acc.Id;
        cart.BGBK__Contact__c = con.Id;
        cart.BGBK__Expiration_DateTime__c = DateTime.now().addDays(60);
        insert cart;
        
        MUSW__Fee__c fee = new MUSW__Fee__c();
        fee.MUSW__Amount__c = 188;
        fee.BGBK__Cart__c = cart.Id;
        fee.Contact__c = con.Id;
        fee.MUSW__License2__c = license1.Id;
        insert fee;
        
        MUSW__Receipt__c receipt = new MUSW__Receipt__c();
        receipt.BGBK__Cart__c = cart.Id;
        receipt.Status__c = 'Draft';
        receipt.Selected_Fees__c = fee.Id;
        insert receipt;
        
        globalSetting.Disable_Triggers__c = false;
        update globalSetting;
    }
    
    @isTest
    public static void testCreditCardResponse(){
        MUSW__Receipt__c receipt = [Select Id From MUSW__Receipt__c limit 1];
        
        String mockResponse = '<?xml version="1.0" encoding="UTF-8"?>';
		mockResponse += '<!DOCTYPE PaymentInfo SYSTEM "https://epayment.epymtservice.com/dtds/RTPC-ver2_0.dtd">';
		mockResponse += '<PaymentInfo><ConfirmationId>ABCABC000001566</ConfirmationId><UserID>1234567</UserID>';
        mockResponse += '<BillerProductCode>Payment</BillerProductCode><PaymentMethod>Credit Card</PaymentMethod>';
		mockResponse += '<PaymentChannel>WEB</PaymentChannel><PaymentAmount>188.00</PaymentAmount>';
		mockResponse += '<ConvenienceFee>1.00</ConvenienceFee><PaymentEffectiveDate>2012-06-07</PaymentEffectiveDate>';
		mockResponse += '<AmountDue>133.00</AmountDue><DueDate>2012-06-06</DueDate><TransactionMode>PAYMENT</TransactionMode>';
		mockResponse += '<Parameter><ParameterName>ShoppingCartID</ParameterName><ParameterValue>' + receipt.Id + '</ParameterValue>';
		mockResponse += '</Parameter><Parameter><ParameterName>PassedReq</ParameterName><ParameterValue>abc123</ParameterValue>';
		mockResponse += '</Parameter><Parameter><ParameterName>CollectNum</ParameterName><ParameterValue>123</ParameterValue>';
		mockResponse += '</Parameter><PayerFirstName>John</PayerFirstName><PayerLastName>Smith</PayerLastName><PaymentAddress>';
		mockResponse += '<StreetAddress1>123 Main St.</StreetAddress1><StreetAddress2>Street Address2</StreetAddress2><City>Chicago</City>';
		mockResponse += '<State>IL</State><Zip>60103</Zip><Country>US</Country></PaymentAddress><PayerPhoneNumber>6308554686</PayerPhoneNumber>';
		mockResponse += '<PayerEmail>john.smith@usbank.com</PayerEmail><LastFourAccountNumber>0001</LastFourAccountNumber>';
		mockResponse += '<BillerBusinessDate>2012-06-06</BillerBusinessDate></PaymentInfo>';
        
        RestRequest req = new RestRequest();
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(mockResponse);
        System.RestContext.request = req;
        System.RestContext.response = new RestResponse();
        
        PaymentGatewayResponseHandler.processPost();
    }
    
    @isTest
    public static void testACHResponse(){
        MUSW__Receipt__c receipt = [Select Id From MUSW__Receipt__c limit 1];
        
        String mockResponse = '<?xml version="1.0" encoding="UTF-8"?>';
		mockResponse += '<!DOCTYPE PaymentInfo SYSTEM "https://epayment.epymtservice.com/dtds/RTPC-ver2_0.dtd">';
		mockResponse += '<PaymentInfo><ConfirmationId>ABCABC000001566</ConfirmationId><UserID>1234567</UserID>';
        mockResponse += '<BillerProductCode>Payment</BillerProductCode><PaymentMethod>ACH</PaymentMethod>';
		mockResponse += '<PaymentChannel>WEB</PaymentChannel><PaymentAmount>188.00</PaymentAmount>';
		mockResponse += '<ConvenienceFee>1.00</ConvenienceFee><PaymentEffectiveDate>2012-06-07</PaymentEffectiveDate>';
		mockResponse += '<AmountDue>133.00</AmountDue><DueDate>2012-06-06</DueDate><TransactionMode>PAYMENT</TransactionMode>';
		mockResponse += '<Parameter><ParameterName>ShoppingCartID</ParameterName><ParameterValue>' + receipt.Id + '</ParameterValue>';
		mockResponse += '</Parameter><Parameter><ParameterName>PassedReq</ParameterName><ParameterValue>abc123</ParameterValue>';
		mockResponse += '</Parameter><Parameter><ParameterName>CollectNum</ParameterName><ParameterValue>123</ParameterValue>';
		mockResponse += '</Parameter><PayerFirstName>John</PayerFirstName><PayerLastName>Smith</PayerLastName><PaymentAddress>';
		mockResponse += '<StreetAddress1>123 Main St.</StreetAddress1><StreetAddress2>Street Address2</StreetAddress2><City>Chicago</City>';
		mockResponse += '<State>IL</State><Zip>60103</Zip><Country>US</Country></PaymentAddress><PayerPhoneNumber>6308554686</PayerPhoneNumber>';
		mockResponse += '<PayerEmail>john.smith@usbank.com</PayerEmail><LastFourAccountNumber>0001</LastFourAccountNumber>';
		mockResponse += '<BillerBusinessDate>2012-06-06</BillerBusinessDate></PaymentInfo>';
        
        RestRequest req = new RestRequest();
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(mockResponse);
        System.RestContext.request = req;
        System.RestContext.response = new RestResponse();
        
        PaymentGatewayResponseHandler.processPost();
    }
    
}