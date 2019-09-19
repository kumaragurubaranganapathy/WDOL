public class TestUtility {
    
    public static Contact getContact(){
        Contact con = new Contact();
        con.LastName = DOL_AppConstants.NULL_EMPTY_STRING + 'DOL Test';
        return con;
    }
    public static Customer_Envelope__c getCEnvelope(){
        Customer_Envelope__c cEnvelope = new Customer_Envelope__c();
        return cEnvelope;
    }
    public static Account getAccount(){
        Account acc = new Account();
        acc.Name = DOL_AppConstants.NULL_EMPTY_STRING + 'Testacc';
        return acc;
    }
    
    
    public static MUSW__Parcel__c getParcel(){
        MUSW__Parcel__c parcel = new MUSW__Parcel__c();
        parcel.Name= DOL_AppConstants.NULL_EMPTY_STRING + 'testparcel';
        parcel.Country__c= DOL_AppConstants.NULL_EMPTY_STRING + 'United States';
        parcel.MUSW__City__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Columbia';
        parcel.MUSW__Street_Number__c= DOL_AppConstants.NULL_EMPTY_STRING + '12';
        parcel.MUSW__State__c= DOL_AppConstants.NULL_EMPTY_STRING + 'WI';
        parcel.MUSW__Post_Zip_Code__c= DOL_AppConstants.NULL_EMPTY_STRING + '65021';
        parcel.County__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Adams';
        parcel.Address_Type__c= DOL_AppConstants.NULL_EMPTY_STRING + 'HOME';
        parcel.Status__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Active';
        return parcel;
    }
    
    public static MUSW__Inspection__c getInspection(){
        MUSW__Inspection__c inspection = new MUSW__Inspection__c();
        
        return inspection;
    }
    
    public static MUSW__Deposit__c getDeposit(){
        MUSW__Deposit__c dep = new MUSW__Deposit__c();
        dep.wadol_Program_Type__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Geologist';
        return dep;
    }
    public static MUSW__License2__c getLicense(){
        MUSW__License2__c testLicen = new MUSW__License2__c();
        testLicen.RecordTypeId= DOL_AppConstants.NULL_EMPTY_STRING + '012r000000074cjAAA';
        testLicen.Application_Type__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Architects';
        testLicen.Credential_Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Architect';
        insert testLicen;
        return testLicen;
    }
    public static Renewal_Application__c getRenewalApp(){
        Renewal_Application__c RenewApp = new Renewal_Application__c();
        RenewApp.RecordTypeId= DOL_AppConstants.NULL_EMPTY_STRING + '012r000000074dCAAQ';
        insert RenewApp;
        return RenewApp;
    }
    public static MUSW__Application2__c getApp(){
        MUSW__Application2__c testApp = new MUSW__Application2__c();
        testApp.MUSW__Type__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Change Name';
        return testApp;
    }
    public static LnP_Licence_Application__c getLicenseApp(){
        LnP_Licence_Application__c testLicenseApp = new LnP_Licence_Application__c();
        testLicenseApp.Name= DOL_AppConstants.NULL_EMPTY_STRING + 'TestName';
        return testLicenseApp;
    }
    
    public static String getDolEpaymentRtpcPojoJson(Id cartId,String feeIds,Id receiptId,Double paymentDue ){
        DOL_ePaymentRTPCPOJO rtpcReq = new DOL_ePaymentRTPCPOJO();
        rtpcReq.ConfirmationId = DOL_AppConstants.NULL_EMPTY_STRING + 'QWERT1234';
        rtpcReq.UserID = DOL_AppConstants.NULL_EMPTY_STRING + 'ABCD';
        rtpcReq.BillerProductCode = DOL_AppConstants.NULL_EMPTY_STRING + 'ABCD';
        
        rtpcReq.PaymentMethod = DOL_AppConstants.NULL_EMPTY_STRING + 'CC';
        rtpcReq.PaymentChannel = DOL_AppConstants.NULL_EMPTY_STRING + '';
        rtpcReq.PaymentAmount = String.valueOf(paymentDue);
        rtpcReq.PaymentEffectiveDate = DOL_AppConstants.NULL_EMPTY_STRING + '20190604';
        rtpcReq.AmountDue = String.valueOf(paymentDue);
        rtpcReq.DueDate = DOL_AppConstants.NULL_EMPTY_STRING + '20190604';
        rtpcReq.TransactionMode = DOL_AppConstants.NULL_EMPTY_STRING + 'ABC';
        rtpcReq.PayerFirstName = DOL_AppConstants.NULL_EMPTY_STRING + 'Test1';
        rtpcReq.PayerLastName = DOL_AppConstants.NULL_EMPTY_STRING + 'Test1';
        
        rtpcReq.PayerPhoneNumber = DOL_AppConstants.NULL_EMPTY_STRING + '1234567891';
        rtpcReq.PayerEmail = DOL_AppConstants.NULL_EMPTY_STRING + 'test@gmail.com';
        rtpcReq.LastFourAccountNumber = DOL_AppConstants.NULL_EMPTY_STRING + '1234';
        rtpcReq.CardType = DOL_AppConstants.NULL_EMPTY_STRING + 'VISA';
        rtpcReq.PaymentAuthorization = DOL_AppConstants.NULL_EMPTY_STRING + 'Yes';
        
        DOL_ePaymentRTPCPOJO.Parameter p1 = new DOL_ePaymentRTPCPOJO.Parameter();
        p1.ParameterName = DOL_AppConstants.NULL_EMPTY_STRING + 'SFDClicId';
        p1.ParameterValue = receiptId;
        DOL_ePaymentRTPCPOJO.Parameter p2 = new DOL_ePaymentRTPCPOJO.Parameter();
        p2.ParameterName = DOL_AppConstants.NULL_EMPTY_STRING + 'SFDCId';
        p2.ParameterValue = cartId;
        DOL_ePaymentRTPCPOJO.Parameter p3 = new DOL_ePaymentRTPCPOJO.Parameter();
        p3.ParameterName = DOL_AppConstants.NULL_EMPTY_STRING + 'SFDCfeeIds';
        p3.ParameterValue = feeIds;
        DOL_ePaymentRTPCPOJO.Parameter p4 = new DOL_ePaymentRTPCPOJO.Parameter();
        p4.ParameterName = DOL_AppConstants.NULL_EMPTY_STRING + 'SFDCappId';
        p4.ParameterValue = DOL_AppConstants.NULL_EMPTY_STRING + '';
        
        List<DOL_ePaymentRTPCPOJO.Parameter> params = new List<DOL_ePaymentRTPCPOJO.Parameter>();
        params.add(p1);
        params.add(p2);
        params.add(p3);
        params.add(p4);
        
        rtpcReq.Parameter = params;
        
        return JSON.serialize(rtpcReq);
    }
    
    public static DOL_EpaymentRemittanceInput getDOLEpaymentRemittanceInput(Decimal totalDue,Id receiptId,Id cartId,String feeIds){
        DOL_EpaymentRemittanceInput input = new DOL_EpaymentRemittanceInput();
        input.recordIndicator = DOL_AppConstants.NULL_EMPTY_STRING + 'Detail';
        input.transactionConfirmationId = DOL_AppConstants.NULL_EMPTY_STRING + 'Detail';
        input.cfTransactionConfirmationID = DOL_AppConstants.NULL_EMPTY_STRING + 'Detail';
        input.recurringRefId = DOL_AppConstants.NULL_EMPTY_STRING + 'Detail';
        input.billerPayorId = DOL_AppConstants.NULL_EMPTY_STRING + 'Detail';
        input.billerProductCode = DOL_AppConstants.NULL_EMPTY_STRING + 'Detail';
        input.amountDue = String.valueOf(totalDue);
        input.dueDate = DOL_AppConstants.NULL_EMPTY_STRING + '20190606';
        input.paymentAmount = String.valueOf(totalDue);
        input.convenienceFee = null;
        input.totalAmount = String.valueOf(totalDue);
        input.paymentEffectiveDate = DOL_AppConstants.NULL_EMPTY_STRING + '20190606';
        input.billerBusinessDate = DOL_AppConstants.NULL_EMPTY_STRING + '20190606';
        
        input.billerBusinessDate= DOL_AppConstants.NULL_EMPTY_STRING + '20190606';
        input.initiationDate= DOL_AppConstants.NULL_EMPTY_STRING + '20190606';
        input.initiationTime= DOL_AppConstants.NULL_EMPTY_STRING + '04:40:56';
        input.paymentMethod= DOL_AppConstants.NULL_EMPTY_STRING + 'ACH';
        input.cardType= DOL_AppConstants.NULL_EMPTY_STRING + 'VISA';
        input.avsCode= DOL_AppConstants.NULL_EMPTY_STRING + 'ABC';
        input.cvdCode= DOL_AppConstants.NULL_EMPTY_STRING + 'ABC';
        input.rankRTN= DOL_AppConstants.NULL_EMPTY_STRING + 'ABC';
        input.bankName= DOL_AppConstants.NULL_EMPTY_STRING + 'ABC';
        input.secCode= DOL_AppConstants.NULL_EMPTY_STRING + 'ABC';
        input.lastFourAccountNumber= DOL_AppConstants.NULL_EMPTY_STRING + '1234';
        input.paymentAuthorization= DOL_AppConstants.NULL_EMPTY_STRING + 'Yes';
        input.paymentStatus= DOL_AppConstants.NULL_EMPTY_STRING + 'Success';
        input.achReturnCode= DOL_AppConstants.NULL_EMPTY_STRING + 'ABC';
        input.reasonDescription= DOL_AppConstants.NULL_EMPTY_STRING + 'ABC';
        input.returnDate= DOL_AppConstants.NULL_EMPTY_STRING + 'ABC';
        input.paymentChannel= DOL_AppConstants.NULL_EMPTY_STRING + 'ABC';
        input.adminOrgID= DOL_AppConstants.NULL_EMPTY_STRING + 'ABC';
        input.adminUserID= DOL_AppConstants.NULL_EMPTY_STRING + 'ABC';
        input.userId= DOL_AppConstants.NULL_EMPTY_STRING + 'ABC';
        input.firstName= DOL_AppConstants.NULL_EMPTY_STRING + 'ABC';
        input.lastName= DOL_AppConstants.NULL_EMPTY_STRING + 'ABC';
        input.companyName= DOL_AppConstants.NULL_EMPTY_STRING + 'ABC';
        input.phone= DOL_AppConstants.NULL_EMPTY_STRING + 'ABC';
        input.streetAddress1= DOL_AppConstants.NULL_EMPTY_STRING + 'ABC';
        input.streetAddress2= DOL_AppConstants.NULL_EMPTY_STRING + 'ABC';
        input.city= DOL_AppConstants.NULL_EMPTY_STRING + 'ABC';
        input.state= DOL_AppConstants.NULL_EMPTY_STRING + 'ABC';
        input.zipPostalCode= DOL_AppConstants.NULL_EMPTY_STRING + 'ABC';
        input.zipCode4= DOL_AppConstants.NULL_EMPTY_STRING + 'ABC';
        input.country= DOL_AppConstants.NULL_EMPTY_STRING + 'ABC';
        input.email= DOL_AppConstants.NULL_EMPTY_STRING + 'ABC';
        
        input.paymentAddress = null;
        input.sfdcParameter1Name= DOL_AppConstants.NULL_EMPTY_STRING + 'SFDClicId';
        input.sfdcParameter1Value=receiptId;
        input.sfdcParameter2Name= DOL_AppConstants.NULL_EMPTY_STRING + 'SFDCId';
        input.sfdcParameter2Value=cartId;
        input.sfdcParameter3Name= DOL_AppConstants.NULL_EMPTY_STRING + 'SFDCfeeIds';
        input.sfdcParameter3Value=feeIds;
        input.sfdcParameter4Name= DOL_AppConstants.NULL_EMPTY_STRING + 'SFDCappId';
        input.sfdcParameter4Value= DOL_AppConstants.NULL_EMPTY_STRING + 'ABC';
        input.filename= DOL_AppConstants.NULL_EMPTY_STRING + 'ABC.xml';
        
        return input;
    }
    
}
