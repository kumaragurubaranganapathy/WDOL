@isTest
private class Dol_BatchMonitoring_Test {
    
    @isTest static void test_method_start() {
    Dol_BatchMonitoring.Dol_BatchMonitoringRequest inputRequest = new Dol_BatchMonitoring.Dol_BatchMonitoringRequest();
    inputRequest.method = DOL_AppConstants.NULL_EMPTY_STRING + 'start';
    inputRequest.batchId = DOL_AppConstants.NULL_EMPTY_STRING + 'INT-004.01';

    Dol_Batch_Monitor__c batchMonitor = new Dol_Batch_Monitor__c();
    batchMonitor.Name = DOL_AppConstants.NULL_EMPTY_STRING + 'INT-004.01';
    batchMonitor.Batch_Name__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Send Life to Death file to Governors Office(OFM)';
    insert batchMonitor;
    test.startTest();
        Dol_BatchMonitoring.doPost(inputRequest);
    test.stopTest();  
    }
    
    @isTest static void test_method_update() {
        Dol_Batch_Monitor__c batchMonitor = new Dol_Batch_Monitor__c();
        batchMonitor.Name = DOL_AppConstants.NULL_EMPTY_STRING + 'INT-004.01';
        batchMonitor.Batch_Name__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Send Life to Death file to Governors Office(OFM)';
        insert batchMonitor;

        Dol_Batch_Monitor_Detail__c batchChild = new Dol_Batch_Monitor_Detail__c();
        batchChild.Parent_Batch__c = batchMonitor.id;
        batchChild.Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Running' ;
        batchChild.Start_Time__c = System.today().addDays(-1);
        insert  batchChild;

        Dol_BatchMonitoring.Dol_BatchMonitoringRequest inputRequest = new Dol_BatchMonitoring.Dol_BatchMonitoringRequest();
        inputRequest.method = DOL_AppConstants.NULL_EMPTY_STRING + 'update';
        inputRequest.childRecordId = batchChild.id;
        inputRequest.recordCount = DOL_AppConstants.NULL_EMPTY_STRING + '300';
        inputRequest.error = DOL_AppConstants.NULL_EMPTY_STRING + 'error occoured';
        inputRequest.status = DOL_AppConstants.NULL_EMPTY_STRING + 'Error';
        inputRequest.targetDropLocation = DOL_AppConstants.NULL_EMPTY_STRING + '/c/folder';
        test.startTest();
            Dol_BatchMonitoring.doPost(inputRequest);
        test.stopTest(); 
    }
    
    
}