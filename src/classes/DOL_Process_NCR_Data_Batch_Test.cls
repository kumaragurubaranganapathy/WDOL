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
        
        Id individualLicenseType = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        
        MUSW__License2__c lic = DOL_TestDataFactory.createLicense(individualLicenseType, 
                                                                  acc.Id, 
                                                                  'Notary Public', 
                                                                  'Notary Public', 
                                                                  'General Application');
        DateTime pastDate = DateTime.now().addDays(-10);
        lic.Renewal_Eligible_Start_Date__c = Date.newinstance(pastDate.year(), pastDate.month(), pastDate.day());
        update lic;
        
        MUSW__Fee__c objFee = DOL_TestDataFactory.createFeeWithLicense('General',100.00,lic.id);
        objFee.BGBK__Cart__c = testCart.Id;
        update objFee;
        
        DOL_NCR_Input ncrInput = TestUtility.getNCRInput(lic.Id, '100');
        ncrInput.PolarisRecordID = DOL_AppConstants.NULL_EMPTY_STRING;
        ncrInput.LicenseNumber = lic.Name;
        
        // Timeshares License
        MUSW__License2__c lic1 = DOL_TestDataFactory.createLicense(individualLicenseType, 
                                                                  acc.Id, 
                                                                  'Timeshares', 
                                                                  'Timeshare Company', 
                                                                  'General Application');
        lic1.Renewal_Eligible_Start_Date__c = Date.newinstance(pastDate.year(), pastDate.month(), pastDate.day());
        update lic1;
        
        MUSW__Fee__c objFee1 = DOL_TestDataFactory.createFeeWithLicense('General',100.00,lic1.id);
        objFee.BGBK__Cart__c = testCart.Id;
        update objFee1;
        
        DOL_NCR_Input ncrInput1 = TestUtility.getNCRInput(lic1.Id, '100');
        
        // Camping License
        MUSW__License2__c lic2 = DOL_TestDataFactory.createLicense(individualLicenseType, 
                                                                  acc.Id, 
                                                                  'Camping Resorts', 
                                                                  'Camping Resort Company', 
                                                                  'General Application');
        lic2.Renewal_Eligible_Start_Date__c = Date.newinstance(pastDate.year(), pastDate.month(), pastDate.day());
        update lic2;
        
        MUSW__Fee__c objFee2 = DOL_TestDataFactory.createFeeWithLicense('General',100.00,lic2.id);
        objFee.BGBK__Cart__c = testCart.Id;
        update objFee2;
        
        DOL_NCR_Input ncrInput2 = TestUtility.getNCRInput(lic2.Id, '100');
        
        DOL_NCR_Input ncrInput3 = TestUtility.getNCRInput(lic2.Id, '100');
        ncrInput3.PolarisRecordID = DOL_AppConstants.NULL_EMPTY_STRING;
        ncrInput3.LicenseNumber = DOL_AppConstants.NULL_EMPTY_STRING;
        
        DOL_NCR_Input ncrInput4 = TestUtility.getNCRInput(lic2.Id, '100');
        ncrInput4.PolarisRecordID = DOL_AppConstants.NULL_EMPTY_STRING;
        ncrInput4.LicenseNumber = DOL_AppConstants.NULL_EMPTY_STRING+'12345';
        
        MUSW__License2__c lic5 = DOL_TestDataFactory.createLicense(individualLicenseType, 
                                                                  acc.Id, 
                                                                  'Camping Resorts', 
                                                                  'Camping Resort Company', 
                                                                  'General Application');
        
        MUSW__Fee__c objFee5 = DOL_TestDataFactory.createFeeWithLicense('General',100.00,lic5.id);
        objFee5.BGBK__Cart__c = testCart.Id;
        update objFee5;
        
        DOL_NCR_Input ncrInput5 = TestUtility.getNCRInput(lic5.Id, '100');
        
        MUSW__License2__c lic6 = DOL_TestDataFactory.createLicense(individualLicenseType, 
                                                                  acc.Id, 
                                                                  'Camping Resorts', 
                                                                  'Camping Resort Company', 
                                                                  'General Application');
        lic6.Renewal_Eligible_Start_Date__c = Date.newinstance(pastDate.year(), pastDate.month(), pastDate.day());
        update lic6;
        
        MUSW__Fee__c objFee6 = DOL_TestDataFactory.createFeeWithLicense('General',100.00,lic6.id);
        objFee6.BGBK__Cart__c = testCart.Id;
        update objFee6;
        
        Id individualRecTypeRenewal = Schema.SObjectType.Renewal_Application__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        DOL_TestDataFactory.createRenewalApplication(individualRecTypeRenewal, lic6.Id);
        
        DOL_NCR_Input ncrInput6 = TestUtility.getNCRInput(lic6.Id, '100');
        
        List<DOL_Integration_Batch_Input__c> batchInputList = new List<DOL_Integration_Batch_Input__c>();
        DOL_Integration_Batch_Input__c batchInput = new DOL_Integration_Batch_Input__c();
        batchInput.Input__c = json.serialize(ncrInput);
        batchInput.Input_Type__c = 'NCR';
        batchInput.Status__c = 'UNPROCESSED';
        
        DOL_Integration_Batch_Input__c batchInput1 = new DOL_Integration_Batch_Input__c();
        batchInput1.Input__c = json.serialize(ncrInput1);
        batchInput1.Input_Type__c = 'NCR';
        batchInput1.Status__c = 'UNPROCESSED';
        
        DOL_Integration_Batch_Input__c batchInput2 = new DOL_Integration_Batch_Input__c();
        batchInput2.Input__c = json.serialize(ncrInput2);
        batchInput2.Input_Type__c = 'NCR';
        batchInput2.Status__c = 'UNPROCESSED';
        
        DOL_Integration_Batch_Input__c batchInput3 = new DOL_Integration_Batch_Input__c();
        batchInput3.Input__c = json.serialize(ncrInput3);
        batchInput3.Input_Type__c = 'NCR';
        batchInput3.Status__c = 'UNPROCESSED';
        
        DOL_Integration_Batch_Input__c batchInput4 = new DOL_Integration_Batch_Input__c();
        batchInput4.Input__c = json.serialize(ncrInput4);
        batchInput4.Input_Type__c = 'NCR';
        batchInput4.Status__c = 'UNPROCESSED';
        
        DOL_Integration_Batch_Input__c batchInput5 = new DOL_Integration_Batch_Input__c();
        batchInput5.Input__c = json.serialize(ncrInput5);
        batchInput5.Input_Type__c = 'NCR';
        batchInput5.Status__c = 'UNPROCESSED';
        
        DOL_Integration_Batch_Input__c batchInput6 = new DOL_Integration_Batch_Input__c();
        batchInput6.Input__c = json.serialize(ncrInput6);
        batchInput6.Input_Type__c = 'NCR';
        batchInput6.Status__c = 'UNPROCESSED';
        
        batchInputList.add(batchInput);
        batchInputList.add(batchInput1);
        batchInputList.add(batchInput2);
        batchInputList.add(batchInput3);
        batchInputList.add(batchInput4);
        batchInputList.add(batchInput5);
        batchInputList.add(batchInput6);
        insert batchInputList;
        
        Test.startTest();
        DOL_Process_NCR_Data_Batch batch = new DOL_Process_NCR_Data_Batch();
        Database.executeBatch(batch);
        Test.stopTest();
    }
}