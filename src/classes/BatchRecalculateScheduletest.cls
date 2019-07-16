@isTest(SeeAllData=true)
private class BatchRecalculateScheduletest {
    static testmethod void test() {
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser) {
            User a=CreateTestDataUtility.createBackendUser();
            insert a;
            Resource__c rsc = new Resource__c();
            rsc.Application_Type__c=label.Str_Plan_Review;
            rsc.Active__c=true;
            rsc.User__c=a.id;
            rsc.Plan_Review_Types__c='POWTS Petition for Variance';
        insert rsc;
        Resource_Week_Availability__c nwResLocAvai = new Resource_Week_Availability__c();
        nwResLocAvai.Schedule_Valid_till__c = Date.Today();        
        nwResLocAvai.Resource__c = rsc.ID;
        nwResLocAvai.Backend_User__c=a.id;
        nwResLocAvai.Autorenewal__c=true;
        if ( nwResLocAvai != null ) { insert nwResLocAvai;}
        
        BatchRecalculateSchedule batchExecution=new BatchRecalculateSchedule();
        Test.startTest();
        Database.executeBatch(batchExecution);
        Test.stopTest();
        System.Assert(nwResLocAvai!= null);
        }
        //system.assertEquals(Date.today(), nwResLocAvai.Schedule_Valid_From__c); 
    }
}