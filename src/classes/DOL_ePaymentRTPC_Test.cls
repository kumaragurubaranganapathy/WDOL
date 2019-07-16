@isTest
public class DOL_ePaymentRTPC_Test {
    @testSetup
    private static void setupTestData()
    {
        new BGBK.TestMock();
        insert new BGBK__CartSettings__c(Name='Default');
    }
    
    @isTest
    public static void processRtpcRequestTest(){
        Account account = new Account(Name='Test Account');
        insert account;
        
        Contact c = new Contact(LastName='Test Contact',FirstName='BasicGov', Email='test@basicgov.com',Account=account,MUSW__Account_Relationship__c='Owner');
        insert c;
        
        Contact cq = [select AccountId from Contact where Id=:c.Id];
        
        /* MUSW__Parcel__c par = new MUSW__Parcel__c(Name='xyz123abc');
        insert par;
        
        MUSW__Permit2__c perm = new MUSW__Permit2__c(MUSW__Type__c='Building', MUSW__Parcel__c=par.id, MUSW__Applicant__c=c.Id, Application_Type__c = 'Engineers', 
                                                       	  Program_Area__c = 'POWTS', Permit_Type__c = 'POWTS Petition for Variance');
        insert perm; */
        
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
        
        String jsonRequest = TestUtility.getDolEpaymentRtpcPojoJson(testCart.id, 
                                               String.join(feeIds,DOL_AppConstants.ePaymentUrlListValuesSeperator), 
                                               receipt.id,
                                               totalDue);
        
        new DOL_ePaymentRTPC().processEpaymentRTPCRequest(jsonRequest);
        new DOL_ePaymentRTPC().processEpaymentRTPCRequest('');
        
    }
}