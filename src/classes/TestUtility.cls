public class TestUtility {
    
    public static Contact getContact(){
        Contact con = new Contact();
        con.LastName = 'DOL Test';
        return con;
    }
    public static Customer_Envelope__c getCEnvelope(){
        Customer_Envelope__c cEnvelope = new Customer_Envelope__c();
        return cEnvelope;
    }
    public static Account getAccount(){
        Account acc = new Account();
        acc.Name = 'Testacc';
        return acc;
    }
    
    
    public static MUSW__Parcel__c getParcel(){
        MUSW__Parcel__c parcel = new MUSW__Parcel__c();
        parcel.Name='testparcel';
        parcel.Country__c='United States';
        parcel.MUSW__City__c='Columbia';
        parcel.MUSW__Street_Number__c='12';
        parcel.MUSW__State__c='WI';
        parcel.MUSW__Post_Zip_Code__c='65021';
        parcel.County__c='Adams';
        parcel.Address_Type__c='HOME';
        parcel.Status__c='Active';
        return parcel;
    }
    
    public static MUSW__Inspection__c getInspection(){
        MUSW__Inspection__c inspection = new MUSW__Inspection__c();
        
        return inspection;
    }
    
    public static MUSW__Deposit__c getDeposit(){
        MUSW__Deposit__c dep = new MUSW__Deposit__c();
        dep.wadol_Program_Type__c='Geologist';
        return dep;
    }
    public static MUSW__License2__c getLicense(){
        MUSW__License2__c testLicen = new MUSW__License2__c();
        testLicen.RecordTypeId='012r000000074cjAAA';
        testLicen.Application_Type__c='Architects';
        testLicen.Credential_Type__c = 'Architect';
        insert testLicen;
        return testLicen;
    }
    public static Renewal_Application__c getRenewalApp(){
        Renewal_Application__c RenewApp = new Renewal_Application__c();
        RenewApp.RecordTypeId='012r000000074dCAAQ';
        insert RenewApp;
        return RenewApp;
    }
    public static MUSW__Application2__c getApp(){
        MUSW__Application2__c testApp = new MUSW__Application2__c();
        testApp.MUSW__Type__c='Change Name';
        return testApp;
    }
    public static LnP_Licence_Application__c getLicenseApp(){
        LnP_Licence_Application__c testLicenseApp = new LnP_Licence_Application__c();
        testLicenseApp.Name='TestName';
        return testLicenseApp;
    }
    
    public static String getDolEpaymentRtpcPojoJson(Id cartId,String feeIds,Id receiptId,Double paymentDue ){
        DOL_ePaymentRTPCPOJO rtpcReq = new DOL_ePaymentRTPCPOJO();
        rtpcReq.ConfirmationId = 'QWERT1234';
        rtpcReq.UserID = 'ABCD';
        rtpcReq.BillerProductCode = 'ABCD';
        
        rtpcReq.PaymentMethod = 'CC';
        rtpcReq.PaymentChannel = '';
        rtpcReq.PaymentAmount = String.valueOf(paymentDue);
        rtpcReq.PaymentEffectiveDate = '20190604';
        rtpcReq.AmountDue = String.valueOf(paymentDue);
        rtpcReq.DueDate = '20190604';
        rtpcReq.TransactionMode = 'ABC';
        rtpcReq.PayerFirstName = 'Test1';
        rtpcReq.PayerLastName = 'Test1';
        
        rtpcReq.PayerPhoneNumber = '1234567891';
        rtpcReq.PayerEmail = 'test@gmail.com';
        rtpcReq.LastFourAccountNumber = '1234';
        rtpcReq.CardType = 'VISA';
        rtpcReq.PaymentAuthorization = 'Yes';
        
        DOL_ePaymentRTPCPOJO.Parameter p1 = new DOL_ePaymentRTPCPOJO.Parameter();
        p1.ParameterName = 'SFDClicId';
        p1.ParameterValue = receiptId;
        DOL_ePaymentRTPCPOJO.Parameter p2 = new DOL_ePaymentRTPCPOJO.Parameter();
        p2.ParameterName = 'SFDCId';
        p2.ParameterValue = cartId;
        DOL_ePaymentRTPCPOJO.Parameter p3 = new DOL_ePaymentRTPCPOJO.Parameter();
        p3.ParameterName = 'SFDCfeeIds';
        p3.ParameterValue = feeIds;
        DOL_ePaymentRTPCPOJO.Parameter p4 = new DOL_ePaymentRTPCPOJO.Parameter();
        p4.ParameterName = 'SFDCappId';
        p4.ParameterValue = '';
        
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
        input.recordIndicator = 'Detail';
        input.transactionConfirmationId = 'Detail';
        input.cfTransactionConfirmationID = 'Detail';
        input.recurringRefId = 'Detail';
        input.billerPayorId = 'Detail';
        input.billerProductCode = 'Detail';
        input.amountDue = String.valueOf(totalDue);
        input.dueDate = '20190606';
        input.paymentAmount = String.valueOf(totalDue);
        input.convenienceFee = null;
        input.totalAmount = String.valueOf(totalDue);
        input.paymentEffectiveDate = '20190606';
        input.billerBusinessDate = '20190606';
        
        input.billerBusinessDate='20190606';
        input.initiationDate='20190606';
        input.initiationTime='04:40:56';
        input.paymentMethod='ACH';
        input.cardType='VISA';
        input.avsCode='ABC';
        input.cvdCode='ABC';
        input.rankRTN='ABC';
        input.bankName='ABC';
        input.secCode='ABC';
        input.lastFourAccountNumber='1234';
        input.paymentAuthorization='Yes';
        input.paymentStatus='Success';
        input.achReturnCode='ABC';
        input.reasonDescription='ABC';
        input.returnDate='ABC';
        input.paymentChannel='ABC';
        input.adminOrgID='ABC';
        input.adminUserID='ABC';
        input.userId='ABC';
        input.firstName='ABC';
        input.lastName='ABC';
        input.companyName='ABC';
        input.phone='ABC';
        input.streetAddress1='ABC';
        input.streetAddress2='ABC';
        input.city='ABC';
        input.state='ABC';
        input.zipPostalCode='ABC';
        input.zipCode4='ABC';
        input.country='ABC';
        input.email='ABC';
        
        input.paymentAddress = null;
        input.sfdcParameter1Name='SFDClicId';
        input.sfdcParameter1Value=receiptId;
        input.sfdcParameter2Name='SFDCId';
        input.sfdcParameter2Value=cartId;
        input.sfdcParameter3Name='SFDCfeeIds';
        input.sfdcParameter3Value=feeIds;
        input.sfdcParameter4Name='SFDCappId';
        input.sfdcParameter4Value='ABC';
        input.filename='ABC.xml';
        
        return input;
    }
    
}