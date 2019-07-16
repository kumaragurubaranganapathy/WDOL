@isTest
private class Dol_BatchMonitoring_Test {
    
    @isTest static void test_method_start() {
    Dol_BatchMonitoring.Dol_BatchMonitoringRequest inputRequest = new Dol_BatchMonitoring.Dol_BatchMonitoringRequest();
    inputRequest.method = 'start';
    inputRequest.batchId = 'INT-004.01';

    Dol_Batch_Monitor__c batchMonitor = new Dol_Batch_Monitor__c();
    batchMonitor.Name = 'INT-004.01';
    batchMonitor.Batch_Name__c ='Send Life to Death file to Governors Office(OFM)';
    insert batchMonitor;
    test.startTest();
        Dol_BatchMonitoring.doPost(inputRequest);
    test.stopTest();  
    }
    
    @isTest static void test_method_update() {
        Dol_Batch_Monitor__c batchMonitor = new Dol_Batch_Monitor__c();
        batchMonitor.Name = 'INT-004.01';
        batchMonitor.Batch_Name__c ='Send Life to Death file to Governors Office(OFM)';
        insert batchMonitor;

        Dol_Batch_Monitor_Detail__c batchChild = new Dol_Batch_Monitor_Detail__c();
        batchChild.Parent_Batch__c = batchMonitor.id;
        batchChild.Status__c = 'Running' ;
        batchChild.Start_Time__c = System.today().addDays(-1);
        insert  batchChild;

        Dol_BatchMonitoring.Dol_BatchMonitoringRequest inputRequest = new Dol_BatchMonitoring.Dol_BatchMonitoringRequest();
        inputRequest.method = 'update';
        inputRequest.childRecordId = batchChild.id;
        inputRequest.recordCount = '300';
        inputRequest.error = 'error occoured';
        inputRequest.status = 'Error';
        inputRequest.targetDropLocation = '/c/folder';
        test.startTest();
            Dol_BatchMonitoring.doPost(inputRequest);
        test.stopTest(); 
    }
    
    
}