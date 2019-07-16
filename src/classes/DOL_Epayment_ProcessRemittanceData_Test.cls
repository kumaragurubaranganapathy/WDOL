@isTest
public class DOL_Epayment_ProcessRemittanceData_Test {
	@testSetup
    private static void setupTestData()
    {
        new BGBK.TestMock();
        insert new BGBK__CartSettings__c(Name='Default');
    }
    
    @isTest
    public static void test_method_one(){
        Account account = new Account(Name='Test Account');
        insert account;
        
        Contact c = new Contact(LastName='Test Contact',FirstName='BasicGov', Email='test@basicgov.com',Account=account,MUSW__Account_Relationship__c='Owner');
        insert c;
        
        Contact cq = [select AccountId from Contact where Id=:c.Id];
                
        BGBK__Cart__c testCart = new BGBK__Cart__c(BGBK__Account__c= cq.AccountId, BGBK__Contact__c= cq.Id, BGBK__Expiration_DateTime__c=system.now().addDays(1));
        insert testCart;
        
        MUSW__Fee__c f1 = new MUSW__Fee__c(MUSW__Amount__c=20, BGBK__Cart__c = testCart.Id);
        MUSW__Fee__c f2 = new MUSW__Fee__c(MUSW__Amount__c=120,  BGBK__Cart__c = testCart.Id);
        MUSW__Fee__c[] fees = new MUSW__Fee__c[]{f1,f2};
        insert fees;
        
        Double totalDue = 0;
        List<String> feeIds = new List<String>();
        for(MUSW__Fee__c fee : fees){
            feeIds.add(fee.id);
            totalDue += fee.MUSW__Amount__c;
        }
        
        // create Receipt
        MUSW__Receipt__c receipt = new MUSW__Receipt__c();
        receipt.BGBK__Cart__c = testCart.Id;
        receipt.Status__c = 'Draft';
        receipt.Selected_Fees__c = String.join(feeIds,',');
        insert receipt;
        
		DOL_EpaymentRemittanceInput input = TestUtility.getDOLEpaymentRemittanceInput(totalDue, receipt.Id, testCart.Id, String.join(feeIds,DOL_AppConstants.ePaymentUrlListValuesSeperator));
        EpaymentRemittanceData__c obj = new EpaymentRemittanceData__c();
        obj.File_Name__c = input.fileName;
        obj.Details__c = JSON.serialize(input);
        insert obj;
        
        test.startTest();
    		DOL_Epayment_ProcessRemittanceData batchObj = new DOL_Epayment_ProcessRemittanceData();
			id batchJob = database.executeBatch(batchObj);
    	test.stopTest();
    }
}