@isTest(SeeAllData=false)
private class Dol_Batch_UpdtErrorPostElpasedTime_Test {
    
    @isTest static void test_method_one() {
        List<Dol_Integration_Settings__mdt> elapsedSettings = [SELECT MasterLabel, DeveloperName, Value__c  FROM Dol_Integration_Settings__mdt Limit 1];

        Dol_Batch_Monitor__c batchMonitor = new Dol_Batch_Monitor__c();
        batchMonitor.Name = DOL_AppConstants.NULL_EMPTY_STRING + 'INT-004.01';
        batchMonitor.Batch_Name__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Send Life to Death file to Governors Office(OFM)';
        insert batchMonitor;

        Dol_Batch_Monitor_Detail__c batchChild = new Dol_Batch_Monitor_Detail__c();
        batchChild.Parent_Batch__c = batchMonitor.id;
        batchChild.Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Running' ;
        batchChild.Start_Time__c = System.today().addDays(-1);
        insert  batchChild;
        test.startTest();
            Dol_Batch_UpdtErrorPostElpasedTime batchObj = new Dol_Batch_UpdtErrorPostElpasedTime();
            id batchJob = database.executeBatch(batchObj);
        test.stopTest();

    }
}