@isTest
public class RefundTriggerTest {
	private static testmethod void testRejectionWithComment()
    {
        // Generate sample work item using utility method.
        Id testWorkItemId = generateAndSubmitObject();
        
        // Reject the submitted request, providing a comment.
        Approval.ProcessWorkitemRequest testRej = new Approval.ProcessWorkitemRequest();
        testRej.setComments('Rejecting request with a comment.');
        testRej.setAction  ('Reject');
        testRej.setWorkitemId(testWorkItemId);
    
        Test.startTest();        
            // Process the rejection
            Approval.ProcessResult testRejResult =  Approval.process(testRej);
        Test.stopTest();
        
        // Verify the rejection results
        System.assert(testRejResult.isSuccess(), 'Rejections that include comments should be permitted');
        System.assertEquals('Rejected', testRejResult.getInstanceStatus(), 
          'Rejections that include comments should be successful and instance status should be Rejected');
    }
    
    /*
        For this test, create an object for approval, then reject the request, mark the approval status as pending, then
        without a comment explaining why. The rejection should be halted, and
        and an apex page message should be provided to the user.
    */
    private static testmethod void testRejectionWithoutComment()
    {
        // Generate sample work item using utility method.
        Id testWorkItemId = generateAndSubmitObject();
        
        // Reject the submitted request, without providing a comment.
        Approval.ProcessWorkitemRequest testRej = new Approval.ProcessWorkitemRequest();
        testRej.setComments('');
        testRej.setAction  ('Reject');      
        testRej.setWorkitemId(testWorkItemId);
    
        Test.startTest();        
            // Attempt to process the rejection
            try
            {
                Approval.ProcessResult testRejResult =  Approval.process(testRej);
                system.assert(false, 'A rejection with no comment should cause an exception');
            }
            catch(DMLException e)
            {
                system.assertEquals('Operation Cancelled: Please provide a rejection reason!', 
                                    e.getDmlMessage(0), 
                  'error message should be Operation Cancelled: Please provide a rejection reason!'); 
            }
        Test.stopTest();
    }
    
    
   
    
    /*
        Utility method for creating single object, and submitting for approval.
        
        The method should return the Id of the work item generated as a result of the submission.
    */
    private static Id generateAndSubmitObject()
    {
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c lic1 = DOL_TestDataFactory.createLicense(LicRecTypeId1, a.Id, 'Architects', 'Architect', 'General Application');
        MUSW__Fee__c fee = DOL_TestDataFactory.createFeeWithLicense('Fine', 100, lic1.Id);
        
        MUSW__Receipt__c receipt = DOL_TestDataFactory.createReceipt('cash',100,'Counter');
        
        
        // Create a sample refund record and then submit it for approval.
        BGBK__Refund2__c ref = new BGBK__Refund2__c();
        ref.BGBK__Amount__c = 50;
        ref.Fee__c = fee.Id;
        ref.Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Requested';
        insert ref;
        
        BGBK__Receipt_Refund__c recRefund = DOL_TestDataFactory.createReceiptRefund(ref.Id,receipt.Id,null);
        
        MUSW__Fee__c fee2 = DOL_TestDataFactory.createFeeWithLicense('Credential', 200, lic1.Id);
        ref.Fee__c = fee2.Id;
        update ref;
        
        
        
        
        User us = [select Id from User where Id =: UserInfo.getUserId()];
        list<Id> userList = new List<Id>();
        userList.add(us.Id);
        Approval.ProcessSubmitRequest testReq = new Approval.ProcessSubmitRequest();
        testReq.setObjectId(ref.Id);
        testReq.setNextApproverIds(userList);
        Approval.ProcessResult reqResult = Approval.process(testReq);
        
        System.assert(reqResult.isSuccess(),'Unable to submit new invoice statement record for approval');
        
        return reqResult.getNewWorkitemIds()[0];
    }
    
    @isTest
    public static void testRefund1(){
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c lic1 = DOL_TestDataFactory.createLicense(LicRecTypeId1, a.Id, 'Notary Public', 'Notary Public', 'General Application');
        MUSW__Fee__c fee = DOL_TestDataFactory.createFeeWithLicense('Fine', 100, lic1.Id);
        
        // Create a sample refund record and then submit it for approval.
        BGBK__Refund2__c ref = new BGBK__Refund2__c();
        ref.BGBK__Amount__c = 100;
        ref.Fee__c = fee.Id;
        ref.Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Requested';
        insert ref;
        
        MUSW__Fee__c fee2 = DOL_TestDataFactory.createFeeWithLicense('Credential', 200, lic1.Id);
        ref.Fee__c = fee2.Id;
        ref.Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Rejected';
        update ref;
    }
    
     @isTest
    public static void testRefund2(){
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c lic1 = DOL_TestDataFactory.createLicense(LicRecTypeId1, a.Id, 'Appraisal Management Companies', 'Appraisal Management Company', 'General Application');
        MUSW__Fee__c fee = DOL_TestDataFactory.createFeeWithLicense('Fine', 100, lic1.Id);
        
        // Create a sample refund record and then submit it for approval.
        BGBK__Refund2__c ref = new BGBK__Refund2__c();
        ref.BGBK__Amount__c = 100;
        ref.Fee__c = fee.Id;
        ref.Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Requested';
        insert ref;
        
        MUSW__Fee__c fee2 = DOL_TestDataFactory.createFeeWithLicense('Credential', 200, lic1.Id);
        ref.Fee__c = fee2.Id;
        update ref;
    }
     @isTest
    public static void testRefund3(){
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c lic1 = DOL_TestDataFactory.createLicense(LicRecTypeId1, a.Id, 'Camping Resorts', 'Camping Resort Company', 'General Application');
        MUSW__Fee__c fee = DOL_TestDataFactory.createFeeWithLicense('Fine', 100, lic1.Id);
        
        // Create a sample refund record and then submit it for approval.
        BGBK__Refund2__c ref = new BGBK__Refund2__c();
        ref.BGBK__Amount__c = 100;
        ref.Fee__c = fee.Id;
        ref.Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Requested';
        insert ref;
        
        MUSW__Fee__c fee2 = DOL_TestDataFactory.createFeeWithLicense('Credential', 200, lic1.Id);
        ref.Fee__c = fee2.Id;
        update ref;
    }
     @isTest
    public static void testRefund4(){
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c lic1 = DOL_TestDataFactory.createLicense(LicRecTypeId1, a.Id, 'Appraisers - Real Estate', 'Appraiser Course', 'General Application');
        MUSW__Fee__c fee = DOL_TestDataFactory.createFeeWithLicense('Fine', 100, lic1.Id);
        
        // Create a sample refund record and then submit it for approval.
        BGBK__Refund2__c ref = new BGBK__Refund2__c();
        ref.BGBK__Amount__c = 100;
        ref.Fee__c = fee.Id;
        ref.Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Requested';
        insert ref;
        
        MUSW__Fee__c fee2 = DOL_TestDataFactory.createFeeWithLicense('Credential', 200, lic1.Id);
        ref.Fee__c = fee2.Id;
        update ref;
    }
     @isTest
    public static void testRefund5(){
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c lic1 = DOL_TestDataFactory.createLicense(LicRecTypeId1, a.Id, 'Timeshares', 'Timeshare Company', 'General Application');
        MUSW__Fee__c fee = DOL_TestDataFactory.createFeeWithLicense('Fine', 100, lic1.Id);
        
        // Create a sample refund record and then submit it for approval.
        BGBK__Refund2__c ref = new BGBK__Refund2__c();
        ref.BGBK__Amount__c = 100;
        ref.Fee__c = fee.Id;
        ref.Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Requested';
        insert ref;
        
        MUSW__Fee__c fee2 = DOL_TestDataFactory.createFeeWithLicense('Credential', 200, lic1.Id);
        ref.Fee__c = fee2.Id;
        update ref;
    }
}