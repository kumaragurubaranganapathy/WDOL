@isTest
public class RefundTriggerTest {
/*
        For this first test, create an object for approval, then
        simulate rejeting the approval with an added comment for explanation.
        
        The rejection should be processed normally without being interrupted.
    */
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
        // Create a sample refund record and then submit it for approval.
        BGBK__Refund2__c ref = new BGBK__Refund2__c();
        ref.BGBK__Amount__c = 100;
        ref.Status__c = 'Requested';
        insert ref;
        
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
}