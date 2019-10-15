@IsTest
public class DOL_Epayment_ProcessRemittanceData_Test {
	
    @IsTest
    public static void test_method_one(){
        Id accRecId = SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_Account').getRecordTypeId();
        Account acc = DOL_TestDataFactory.createAccount(accRecId);
        
        Id conRecId = SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Contact').getRecordTypeId();
        Contact c = DOL_TestDataFactory.createContact(conRecId, acc.Id);
        
        Contact cq = [select AccountId from Contact where Id=:c.Id];

        MUSW__Account_Contact__c accCon = new MUSW__Account_Contact__c(MUSW__Account__c=acc.Id,	
                                                                       MUSW__Contact__c=c.Id);
        insert accCon;
                
        BGBK__Cart__c testCart = new BGBK__Cart__c(BGBK__Account__c= cq.AccountId, 
                                                   BGBK__Contact__c= cq.Id, 
                                                   BGBK__Expiration_DateTime__c=system.now().addDays(1));
        insert testCart;
        
        Id businessLicenseType = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c lic = DOL_TestDataFactory.createLicense(businessLicenseType, acc.Id, 'Architects', 'Architect', 'General Application');
        
        MUSW__Fee__c objFee = DOL_TestDataFactory.createFeeWithLicense('General',100.00,lic.id);
        objFee.BGBK__Cart__c = testCart.Id;
        update objFee;
        
        Double totalDue = 0;
        List<String> feeIds = new List<String>();
        feeIds.add(objFee.Id);
        totalDue = objFee.MUSW__Amount__c;
        
        // create Receipt
        MUSW__Receipt__c receipt = new MUSW__Receipt__c();
        receipt.BGBK__Cart__c = testCart.Id;
        receipt.Status__c = 'Draft';
        receipt.Selected_Fees__c = String.join(feeIds,',');
        insert receipt;
        
		DOL_EpaymentRemittanceInput input = TestUtility.getDOLEpaymentRemittanceInput(totalDue, 
                                                        receipt.Id, 
                                                        testCart.Id, 
                                                        String.join(feeIds,DOL_AppConstants.ePaymentUrlListValuesSeperator),
                                                        c.Id
                                                        );
        
        DOL_Integration_Batch_Input__c rmtBatchInput = new DOL_Integration_Batch_Input__c();
        rmtBatchInput.File_Name__c = input.fileName;
        rmtBatchInput.Input__c = JSON.serialize(input);
        rmtBatchInput.Input_Type__c = 'REMITTANCE';
        rmtBatchInput.Status__c = 'UNPROCESSED';
        insert rmtBatchInput;

        test.startTest();
    	    DOL_Epayment_ProcessRemittanceData batchObj = new DOL_Epayment_ProcessRemittanceData();
		    id batchJob = database.executeBatch(batchObj);
    	test.stopTest();
    }
}