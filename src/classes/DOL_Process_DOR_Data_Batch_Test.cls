@IsTest
public class DOL_Process_DOR_Data_Batch_Test {
	
    @IsTest
    public static void TestDORBatch(){
        Id accRecId = SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_Account').getRecordTypeId();
        Account acc = DOL_TestDataFactory.createAccount(accRecId);
        
        Id conRecId = SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Contact').getRecordTypeId();
        Contact c = DOL_TestDataFactory.createContact(conRecId, acc.Id);
        
        Contact cq = [select AccountId from Contact where Id=:c.Id];

        MUSW__Account_Contact__c accCon = new MUSW__Account_Contact__c(MUSW__Account__c=acc.Id,	
                                                                       MUSW__Contact__c=c.Id);
        insert accCon;
        
        DOL_DOR_Input rec = TestUtility.getDolDorInput();
        DOL_Integration_Batch_Input__c tempBatchInput = new DOL_Integration_Batch_Input__c();
        tempBatchInput.File_Name__c = rec.fileName;
        tempBatchInput.Input__c = JSON.serialize(rec);
        tempBatchInput.Input_Type__c = 'DOR';
        tempBatchInput.Status__c = 'UNPROCESSED';
        insert tempBatchInput;
        
        test.startTest();
    	    DOL_Process_DOR_Data_Batch batchObj = new DOL_Process_DOR_Data_Batch();
		    id batchJob = database.executeBatch(batchObj);
    	test.stopTest();
    }
}