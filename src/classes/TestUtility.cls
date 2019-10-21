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
        parcel.MUSW__State__c= DOL_AppConstants.NULL_EMPTY_STRING + 'WA';
        parcel.MUSW__Post_Zip_Code__c= DOL_AppConstants.NULL_EMPTY_STRING + '665021';
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
    
    public static MUSW__License2__c getBusinessLicense(){
        MUSW__License2__c testLicence = new MUSW__License2__c();
        testLicence.RecordTypeId= Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        testLicence.Application_Type__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Architects';
        testLicence.Credential_Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Architect';
        return testLicence;
    }
    
    public static Renewal_Application__c getRenewalApplication(MUSW__License2__c licenseRecord){
        Renewal_Application__c tempRenewalApplication = new Renewal_Application__c();
        tempRenewalApplication.Applicant__c = licenseRecord.MUSW__Applicant__c;
        tempRenewalApplication.Application_Type__c = licenseRecord.Application_Type__c;
        tempRenewalApplication.Phone__c = licenseRecord.Phone__c;
        tempRenewalApplication.Credential_Type__c = licenseRecord.Credential_Type__c;
        tempRenewalApplication.Credential__c = licenseRecord.Credential_Type__c;
        tempRenewalApplication.Licensee__c = licenseRecord.MUSW__Primary_Licensee__c;
        tempRenewalApplication.License__c = licenseRecord.Id;
        tempRenewalApplication.Renewal_Status__c = 'Generate Fee';
        tempRenewalApplication.Renewal_Reinstatement_Type__c = 'Renewal';
        return tempRenewalApplication;
    }
    
    /*
     * Commenting the below as not refrenced from org
     * Also hardcoded recordType will break in higher enviroment
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
	*/
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
    
    public static String getRtpcInput(Id cartId,
                                         String feeIds,
                                         Id receiptId,
                                         Double paymentDue,
                                         Id conId){
        DOL_RTPC_Input rtpcReq = new DOL_RTPC_Input();
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
        
        DOL_RTPC_Input.Parameter p1 = new DOL_RTPC_Input.Parameter();
        p1.ParameterName = DOL_AppConstants.NULL_EMPTY_STRING + 'SFDClicId';
        p1.ParameterValue = receiptId;
        DOL_RTPC_Input.Parameter p2 = new DOL_RTPC_Input.Parameter();
        p2.ParameterName = DOL_AppConstants.NULL_EMPTY_STRING + 'SFDCId';
        p2.ParameterValue = cartId;
        DOL_RTPC_Input.Parameter p3 = new DOL_RTPC_Input.Parameter();
        p3.ParameterName = DOL_AppConstants.NULL_EMPTY_STRING + 'SFDCfeeIds';
        p3.ParameterValue = feeIds;
        DOL_RTPC_Input.Parameter p4 = new DOL_RTPC_Input.Parameter();
        p4.ParameterName = DOL_AppConstants.NULL_EMPTY_STRING + 'SFDCappId';
        p4.ParameterValue = conId;
        
        List<DOL_RTPC_Input.Parameter> params = new List<DOL_RTPC_Input.Parameter>();
        params.add(p1);
        params.add(p2);
        params.add(p3);
        params.add(p4);
        
        rtpcReq.Parameter = params;
        
        return JSON.serialize(rtpcReq);
    }
    
    public static DOL_EpaymentRemittanceInput getDOLEpaymentRemittanceInput(Decimal totalDue,
                                                                            Id receiptId,
                                                                            Id cartId,
                                                                            String feeIds,
                                                                           	Id conId
                                                                           ){
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
        input.sfdcParameter4Value= conId;
        input.filename= DOL_AppConstants.NULL_EMPTY_STRING + 'ABC.xml';
        
        return input;
    }
    
    public static DOL_DOR_Input getDolDorInput(String polarisID,String dorLicenseUBI){
        DOL_DOR_Input dorInput = new DOL_DOR_Input();
        dorInput.polarisID= polarisID;
        dorInput.dorLicenseFullUBI= DOL_AppConstants.NULL_EMPTY_STRING + '6027340270010001';
        dorInput.dorLicenseUBI= dorLicenseUBI;
        dorInput.dorLicenseBusID= DOL_AppConstants.NULL_EMPTY_STRING + '001';
        dorInput.dorLicenseLocID= DOL_AppConstants.NULL_EMPTY_STRING + '0001';
        dorInput.dorLicenseStatus= DOL_AppConstants.NULL_EMPTY_STRING + '';
        dorInput.dorLicenseCode= DOL_AppConstants.NULL_EMPTY_STRING + '';
        dorInput.dorLicenseFirstIssuanceDate= DOL_AppConstants.NULL_EMPTY_STRING + '20110805';
        dorInput.dorLicenseExpirationDate= DOL_AppConstants.NULL_EMPTY_STRING + '20190731';
        dorInput.dorLicenseNumber= DOL_AppConstants.NULL_EMPTY_STRING + '223319';
        dorInput.dorBusinessType= DOL_AppConstants.NULL_EMPTY_STRING + 'Sole Proprietor';
        dorInput.dorEntityName= DOL_AppConstants.NULL_EMPTY_STRING + '';
        dorInput.dorBusinessName= DOL_AppConstants.NULL_EMPTY_STRING + 'ROBERT G. LIEBLING, ARCHITECT';
        dorInput.dorOwnerFirstName= DOL_AppConstants.NULL_EMPTY_STRING + 'ROBERT';
        dorInput.dorOwnerMiddleName= DOL_AppConstants.NULL_EMPTY_STRING + 'GARY';
        dorInput.dorOwnerLastName= DOL_AppConstants.NULL_EMPTY_STRING + 'LIEBLING';
        dorInput.dorLocMailAddr1= DOL_AppConstants.NULL_EMPTY_STRING + '23612 SE 165TH ST';
        dorInput.dorLocMailAddr2= DOL_AppConstants.NULL_EMPTY_STRING + 'Street No.123';
        dorInput.dorLocMailCity= DOL_AppConstants.NULL_EMPTY_STRING + 'ISSAQUAH';
        dorInput.dorLocMailState= DOL_AppConstants.NULL_EMPTY_STRING + 'WA';
        dorInput.dorLocMailZip= DOL_AppConstants.NULL_EMPTY_STRING + '980278413';
        dorInput.dorLocPhysicalAddr1= DOL_AppConstants.NULL_EMPTY_STRING + '23612 SE 165TH ST';
        dorInput.dorLocPhysicalAddr2= DOL_AppConstants.NULL_EMPTY_STRING + '';
        dorInput.dorLocPhysicalCity= DOL_AppConstants.NULL_EMPTY_STRING + 'ISSAQUAH';
        dorInput.dorLocPhysicalState= DOL_AppConstants.NULL_EMPTY_STRING + 'WA';
        dorInput.dorLocPhysicalZip= DOL_AppConstants.NULL_EMPTY_STRING + '980278413';
        dorInput.dorLocOpenDate= DOL_AppConstants.NULL_EMPTY_STRING + '20070501';
        dorInput.dorTradeName= DOL_AppConstants.NULL_EMPTY_STRING + 'ROBERT G. LIEBLING, ARCHITECT';
        dorInput.dolProfCode= DOL_AppConstants.NULL_EMPTY_STRING + '20811';
        dorInput.fileName= DOL_AppConstants.NULL_EMPTY_STRING + '';
        dorInput.dorEndorsementCode= DOL_AppConstants.NULL_EMPTY_STRING + '0052';
        dorInput.dorLicenseStatus = DOL_AppConstants.NULL_EMPTY_STRING + 'Active';
        List<DOL_DOR_Input.GovernPerson> govPersonList = new List<DOL_DOR_Input.GovernPerson>();
        
        DOL_DOR_Input.GovernPerson govPerson = new DOL_DOR_Input.GovernPerson();
        govPerson.dorGovPerFirstName = DOL_AppConstants.NULL_EMPTY_STRING + 'Gov First Name';
        govPerson.dorGovPerMiddleName = DOL_AppConstants.NULL_EMPTY_STRING + 'Middle Name';
        govPerson.dorGovPerLastName = DOL_AppConstants.NULL_EMPTY_STRING + 'LastName';
        govPersonList.add(govPerson);
        
        dorInput.governPerson = govPersonList;
        return dorInput;
    }
    
    public static DOL_NCR_Input getNCRInput(Id licenseId, String validationAmount){
        DOL_NCR_Input ncrInput = new DOL_NCR_Input();
        ncrInput.FileName = DOL_AppConstants.NULL_EMPTY_STRING + 'FileName';
        ncrInput.ImageLabel = DOL_AppConstants.NULL_EMPTY_STRING + 'ImageLabel';
        ncrInput.LicenseNumber = DOL_AppConstants.NULL_EMPTY_STRING + '1111';
        ncrInput.ncrFileImageURL = DOL_AppConstants.NULL_EMPTY_STRING + 'ImageUrl';
        ncrInput.ProfCode = DOL_AppConstants.NULL_EMPTY_STRING + '23104';
        ncrInput.ValidationDate = DOL_AppConstants.NULL_EMPTY_STRING + '22092019';
        ncrInput.ValidationItemNum = DOL_AppConstants.NULL_EMPTY_STRING + '2222';
        ncrInput.ValidationSeqNum = DOL_AppConstants.NULL_EMPTY_STRING + '001';
        ncrInput.PolarisRecordID = licenseId;
        ncrInput.ValidationAmount = validationAmount;
        return ncrInput;
    }
    
}