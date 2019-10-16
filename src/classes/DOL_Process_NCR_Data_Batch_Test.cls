@IsTest
public class DOL_Process_NCR_Data_Batch_Test {
   	
    @IsTest
    public static void testNCRBatch(){
        Id accRecId = SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_Account').getRecordTypeId();
        Account acc = DOL_TestDataFactory.createAccount(accRecId);
        
        Id conRecId = SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Contact').getRecordTypeId();
        Contact c = DOL_TestDataFactory.createContact(conRecId, acc.Id);
        
        MUSW__Account_Contact__c accCon = DOL_TestDataFactory.createAccountContact(c.Id,acc.Id);
        
        BGBK__Cart__c testCart = new BGBK__Cart__c(BGBK__Account__c= acc.Id, 
                                                   BGBK__Contact__c= c.Id, 
                                                   BGBK__Expiration_DateTime__c=system.now().addDays(1));
        insert testCart;
        
        Id businessLicenseType = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c lic = DOL_TestDataFactory.createLicense(businessLicenseType, 
                                                                  acc.Id, 
                                                                  'Architects', 
                                                                  'Architect', 
                                                                  'General Application');
        DateTime pastDate = DateTime.now().addDays(-10);
        lic.Renewal_Eligible_Start_Date__c = Date.newinstance(pastDate.year(), pastDate.month(), pastDate.day());
        update lic;
        
        MUSW__Fee__c objFee = DOL_TestDataFactory.createFeeWithLicense('General',100.00,lic.id);
        objFee.BGBK__Cart__c = testCart.Id;
        update objFee;
        
        DOL_NCR_Input ncrInput = TestUtility.getNCRInput(lic.Id, '100');
        
        DOL_Integration_Batch_Input__c rtpcBatchInput = new DOL_Integration_Batch_Input__c();
        rtpcBatchInput.Input__c = json.serialize(ncrInput);
        rtpcBatchInput.Input_Type__c = 'NCR';
        rtpcBatchInput.Status__c = 'UNPROCESSED';
        insert rtpcBatchInput;
        
        Test.startTest();
        DOL_Process_NCR_Data_Batch batch = new DOL_Process_NCR_Data_Batch();
        Database.executeBatch(batch);
        Test.stopTest();
    }
}