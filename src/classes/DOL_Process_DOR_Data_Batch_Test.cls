@IsTest
public class DOL_Process_DOR_Data_Batch_Test {
	
    @IsTest
    public static void TestDORBatch(){
        String accUBI = DOL_AppConstants.NULL_EMPTY_STRING+'607241888';
        Id accRecId = SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_Account').getRecordTypeId();
        Account acc = DOL_TestDataFactory.createAccount(accRecId);
        acc.UBI_Number__c = accUBI;
        update acc;
        
        Id conRecId = SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Contact').getRecordTypeId();
        Contact c = DOL_TestDataFactory.createContact(conRecId, acc.Id);
        
        Contact cq = [select AccountId from Contact where Id=:c.Id];

        MUSW__Account_Contact__c accCon = new MUSW__Account_Contact__c(MUSW__Account__c=acc.Id,	
                                                                       MUSW__Contact__c=c.Id);
        insert accCon;
        
        Id businessLicenseType = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c lic = DOL_TestDataFactory.createLicense(businessLicenseType, 
                                                                  acc.Id, 
                                                                  'Architects', 
                                                                  'Architect', 
                                                                  'General Application');
        // Input with existing license
        DOL_DOR_Input rec = TestUtility.getDolDorInput(lic.Id,accUBI);
        DOL_Integration_Batch_Input__c tempBatchInput = new DOL_Integration_Batch_Input__c();
        tempBatchInput.File_Name__c = rec.fileName;
        tempBatchInput.Input__c = JSON.serialize(rec);
        tempBatchInput.Input_Type__c = 'DOR';
        tempBatchInput.Status__c = 'UNPROCESSED';
        insert tempBatchInput;
        
        // Input with new license
        DOL_DOR_Input rec1 = TestUtility.getDolDorInput(DOL_AppConstants.NULL_EMPTY_STRING,accUBI);
        DOL_Integration_Batch_Input__c tempBatchInput1 = new DOL_Integration_Batch_Input__c();
        tempBatchInput1.File_Name__c = rec.fileName;
        tempBatchInput1.Input__c = JSON.serialize(rec1);
        tempBatchInput1.Input_Type__c = 'DOR';
        tempBatchInput1.Status__c = 'UNPROCESSED';
        insert tempBatchInput1;
        
        // Input with incorrect data
        DOL_DOR_Input rec2 = TestUtility.getDolDorInput(DOL_AppConstants.NULL_EMPTY_STRING,accUBI);
        rec2.dorEntityName = DOL_AppConstants.NULL_EMPTY_STRING;
        rec2.dorBusinessName = DOL_AppConstants.NULL_EMPTY_STRING;
        rec2.dolProfCode = DOL_AppConstants.NULL_EMPTY_STRING;
        rec2.dorLicenseStatus = DOL_AppConstants.NULL_EMPTY_STRING;
        rec2.dorLicenseUBI = DOL_AppConstants.NULL_EMPTY_STRING;
        rec2.dorLicenseBusID = DOL_AppConstants.NULL_EMPTY_STRING;
        rec2.dorLicenseLocID = DOL_AppConstants.NULL_EMPTY_STRING;
        
        DOL_Integration_Batch_Input__c tempBatchInput2 = new DOL_Integration_Batch_Input__c();
        tempBatchInput2.File_Name__c = rec2.fileName;
        tempBatchInput2.Input__c = JSON.serialize(rec2);
        tempBatchInput2.Input_Type__c = 'DOR';
        tempBatchInput2.Status__c = 'UNPROCESSED';
        insert tempBatchInput2;
        
        test.startTest();
        	Test.setMock(HttpCalloutMock.class, new DOL_MockHttpResponse());
    	    DOL_Process_DOR_Data_Batch batchObj = new DOL_Process_DOR_Data_Batch();
		    id batchJob = database.executeBatch(batchObj);
    	test.stopTest();
    }
}