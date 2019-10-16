@IsTest
public class DOL_ProcessRTPC_Batch_Test {
	
    @IsTest
    public static void testRtpcBatch(){
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
        MUSW__License2__c lic = DOL_TestDataFactory.createLicense(businessLicenseType, 
                                                                  acc.Id, 
                                                                  'Architects', 
                                                                  'Architect', 
                                                                  'General Application');
        
        MUSW__Fee__c objFee = DOL_TestDataFactory.createFeeWithLicense('General',100.00,lic.id);
        objFee.BGBK__Cart__c = testCart.Id;
        update objFee;
        
        Double totalDue = 0;
        List<String> feeIds = new List<String>();
        feeIds.add(objFee.Id);
        totalDue = objFee.MUSW__Amount__c;
        
        MUSW__Receipt__c receipt = new MUSW__Receipt__c();
        receipt.BGBK__Cart__c = testCart.Id;
        receipt.Status__c = 'Draft';
        receipt.Selected_Fees__c = String.join(feeIds,',');
        insert receipt;
        
        String rtpcInput = TestUtility.getRtpcInput(testCart.Id,
                                    String.join(feeIds,DOL_AppConstants.ePaymentUrlListValuesSeperator),
                                    receipt.Id,
                                    totalDue,c.Id);
        
        DOL_Integration_Batch_Input__c rtpcBatchInput = new DOL_Integration_Batch_Input__c();
        rtpcBatchInput.Input__c = rtpcInput;
        rtpcBatchInput.Input_Type__c = 'RTPC';
        rtpcBatchInput.Status__c = 'UNPROCESSED';
        insert rtpcBatchInput;
        Test.setCreatedDate(rtpcBatchInput.Id, Datetime.now().addMinutes(-30));
        
        Test.startTest();
        DOL_ProcessRTPC_Batch batch = new DOL_ProcessRTPC_Batch();
        Database.executeBatch(batch);
        Test.stopTest();
    }
}