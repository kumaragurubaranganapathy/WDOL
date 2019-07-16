@isTest
public class PaymentGatewayBatchHandler_Test {
	
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
        
        String mockResponse = '<TransactionDetails><TransactionDetail><TransactionConfirmationId>XWIX17021936224</TransactionConfirmationId>';
        mockResponse += '<BillerPayorId>233104</BillerPayorId><BillerProductCode>DeptComShopCart</BillerProductCode><AmountDue>25.00</AmountDue><PaymentAmount>25.00</PaymentAmount>';
        mockResponse += '<ConvenienceFee>0.00</ConvenienceFee><TotalAmount>25.00</TotalAmount><PaymentEffectiveDate>2018-09-17</PaymentEffectiveDate><InitiationDate>2018-09-13</InitiationDate>';
        mockResponse += '<InitiationTime>18:03:42</InitiationTime><PaymentMethod>Credit Card</PaymentMethod><PaymentChannel>WEB</PaymentChannel><PaymentStatus>PROCESSED</PaymentStatus>';
        mockResponse += '<PaymentAuthorization>042000010912270</PaymentAuthorization><Paramters><Parameter><Name>ShoppingCartID</Name><Value>' + receipt.Id + '</Value></Parameter><Parameter>';
        mockResponse += '<Name>SpecialEventCode</Name><Value>x</Value></Parameter><Parameter><Name>TaxAmount</Name><Value>0</Value></Parameter><Parameter><Name>UserID</Name><Value>9611</Value>';
        mockResponse += '</Parameter><Parameter><Name>parm10</Name><Value>XXX</Value></Parameter><Parameter><Name>parm6</Name><Value>XXX</Value></Parameter><Parameter><Name>parm7</Name>';
        mockResponse += '<Value>XXX</Value></Parameter><Parameter><Name>parm8</Name><Value>XXX</Value></Parameter><Parameter><Name>parm9</Name><Value>XXX</Value></Parameter></Paramters>';
        mockResponse += '<ACHDetail><BankRTN>075000022</BankRTN><BankName>US BANK NA</BankName><SECCode>WEB</SECCode><LastFourAccountNumber>4196</LastFourAccountNumber></ACHDetail>';
        mockResponse += '<ContactInformation><FirstName>STEVEN</FirstName><LastName>IMMEL</LastName><CompanyName>SMI CONSTRUCTION</CompanyName><Phone>9209223188</Phone><Email>abbyimmel@att.net</Email>';
        mockResponse += '<Address><StreetAddress1>446 E 2ND ST</StreetAddress1><City>FOND DU LAC</City><State>WI</State><ZipPostalCode>54935</ZipPostalCode><Country>US</Country></Address>';
        mockResponse += '</ContactInformation></TransactionDetail></TransactionDetails>';
        
        RestRequest req = new RestRequest();
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(mockResponse);
        System.RestContext.request = req;
        System.RestContext.response = new RestResponse();
        
        PaymentGatewayBatchHandler.processPost();
    }
    
    @isTest
    public static void testACHResponse(){
        MUSW__Receipt__c receipt = [Select Id From MUSW__Receipt__c limit 1];
        
        String mockResponse = '<TransactionDetails><TransactionDetail><TransactionConfirmationId>XWIX17021936224</TransactionConfirmationId>';
        mockResponse += '<BillerPayorId>233104</BillerPayorId><BillerProductCode>DeptComShopCart</BillerProductCode><AmountDue>25.00</AmountDue><PaymentAmount>25.00</PaymentAmount>';
        mockResponse += '<ConvenienceFee>0.00</ConvenienceFee><TotalAmount>25.00</TotalAmount><PaymentEffectiveDate>2018-09-17</PaymentEffectiveDate><InitiationDate>2018-09-13</InitiationDate>';
        mockResponse += '<InitiationTime>18:03:42</InitiationTime><PaymentMethod>ACH</PaymentMethod><PaymentChannel>WEB</PaymentChannel><PaymentStatus>PROCESSED</PaymentStatus>';
        mockResponse += '<PaymentAuthorization>042000010912270</PaymentAuthorization><Paramters><Parameter><Name>ShoppingCartID</Name><Value>' + receipt.Id + '</Value></Parameter><Parameter>';
        mockResponse += '<Name>SpecialEventCode</Name><Value>x</Value></Parameter><Parameter><Name>TaxAmount</Name><Value>0</Value></Parameter><Parameter><Name>UserID</Name><Value>9611</Value>';
        mockResponse += '</Parameter><Parameter><Name>parm10</Name><Value>XXX</Value></Parameter><Parameter><Name>parm6</Name><Value>XXX</Value></Parameter><Parameter><Name>parm7</Name>';
        mockResponse += '<Value>XXX</Value></Parameter><Parameter><Name>parm8</Name><Value>XXX</Value></Parameter><Parameter><Name>parm9</Name><Value>XXX</Value></Parameter></Paramters>';
        mockResponse += '<ACHDetail><BankRTN>075000022</BankRTN><BankName>US BANK NA</BankName><SECCode>WEB</SECCode><LastFourAccountNumber>4196</LastFourAccountNumber></ACHDetail>';
        mockResponse += '<ContactInformation><FirstName>STEVEN</FirstName><LastName>IMMEL</LastName><CompanyName>SMI CONSTRUCTION</CompanyName><Phone>9209223188</Phone><Email>abbyimmel@att.net</Email>';
        mockResponse += '<Address><StreetAddress1>446 E 2ND ST</StreetAddress1><City>FOND DU LAC</City><State>WI</State><ZipPostalCode>54935</ZipPostalCode><Country>US</Country></Address>';
        mockResponse += '</ContactInformation></TransactionDetail></TransactionDetails>';
        
        RestRequest req = new RestRequest();
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(mockResponse);
        System.RestContext.request = req;
        System.RestContext.response = new RestResponse();
        
        PaymentGatewayBatchHandler.processPost();
    }
    
    @isTest
    public static void testReturned(){
        MUSW__Receipt__c receipt = [Select Id From MUSW__Receipt__c limit 1];
        
        String mockResponse = '<TransactionDetails><TransactionDetail><TransactionConfirmationId>XWIX17021936224</TransactionConfirmationId>';
        mockResponse += '<BillerPayorId>233104</BillerPayorId><BillerProductCode>DeptComShopCart</BillerProductCode><AmountDue>25.00</AmountDue><PaymentAmount>25.00</PaymentAmount>';
        mockResponse += '<ConvenienceFee>0.00</ConvenienceFee><TotalAmount>25.00</TotalAmount><PaymentEffectiveDate>2018-09-17</PaymentEffectiveDate><InitiationDate>2018-09-13</InitiationDate>';
        mockResponse += '<InitiationTime>18:03:42</InitiationTime><PaymentMethod>Credit Card</PaymentMethod><PaymentChannel>WEB</PaymentChannel><PaymentStatus>RETURNED</PaymentStatus><ReasonDescription>Declined by the bank</ReasonDescription>';
        mockResponse += '<ReturnDate>2018-09-17</ReturnDate><PaymentAuthorization>042000010912270</PaymentAuthorization><Paramters><Parameter><Name>ShoppingCartID</Name><Value>' + receipt.Id + '</Value></Parameter><Parameter>';
        mockResponse += '<Name>SpecialEventCode</Name><Value>x</Value></Parameter><Parameter><Name>TaxAmount</Name><Value>0</Value></Parameter><Parameter><Name>UserID</Name><Value>9611</Value>';
        mockResponse += '</Parameter><Parameter><Name>parm10</Name><Value>XXX</Value></Parameter><Parameter><Name>parm6</Name><Value>XXX</Value></Parameter><Parameter><Name>parm7</Name>';
        mockResponse += '<Value>XXX</Value></Parameter><Parameter><Name>parm8</Name><Value>XXX</Value></Parameter><Parameter><Name>parm9</Name><Value>XXX</Value></Parameter></Paramters>';
        mockResponse += '<ACHDetail><BankRTN>075000022</BankRTN><BankName>US BANK NA</BankName><SECCode>WEB</SECCode><LastFourAccountNumber>4196</LastFourAccountNumber></ACHDetail>';
        mockResponse += '<ContactInformation><FirstName>STEVEN</FirstName><LastName>IMMEL</LastName><CompanyName>SMI CONSTRUCTION</CompanyName><Phone>9209223188</Phone><Email>abbyimmel@att.net</Email>';
        mockResponse += '<Address><StreetAddress1>446 E 2ND ST</StreetAddress1><City>FOND DU LAC</City><State>WI</State><ZipPostalCode>54935</ZipPostalCode><Country>US</Country></Address>';
        mockResponse += '</ContactInformation></TransactionDetail></TransactionDetails>';
        
        RestRequest req = new RestRequest();
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(mockResponse);
        System.RestContext.request = req;
        System.RestContext.response = new RestResponse();
        
        PaymentGatewayBatchHandler.processPost();
    }
}