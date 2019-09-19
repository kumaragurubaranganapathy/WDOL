@RestResource(urlMapping='/Dol_BatchMonitoring/*')
global class Dol_BatchMonitoring{
    @HttpPost
    global static Dol_BatchMonitoringResponse doPost(Dol_BatchMonitoringRequest inputRequest){
        Dol_BatchMonitoringResponse outputResponse = new Dol_BatchMonitoringResponse();
        if(inputRequest!=null && inputRequest.method.equalsIgnoreCase('start')){
            String childID = createBatchRequest(inputRequest.batchId);
            if(Dol_IntegrationUtil.isNotBlank(childID)){
                outputResponse.status = DOL_AppConstants.SUCCESS_STRING_LOWERCASE;
                outputResponse.childRecoRdId = childID;
            }else {
                outputResponse.status = DOL_AppConstants.FAILED_STRING_LOWERCASE;
            }
        }else if(inputRequest!=null && inputRequest.method.equalsIgnoreCase('update')){
             if(updateBatchRequest(inputRequest.childRecoRdId,inputRequest.recordCount,inputRequest.error,inputRequest.status,inputRequest.targetDropLocation)){
                 outputResponse.status = DOL_AppConstants.SUCCESS_STRING_LOWERCASE;
             }else{
                 outputResponse.status = DOL_AppConstants.FAILED_STRING_LOWERCASE;
             }
        }
        return outputResponse;
    }

    global static String createBatchRequest(String batchId){
        System.debug('starting***');
        String childRecordId;
        List<Dol_Batch_Monitor__c> batchList;
        String childRecId=null;
        String response;

        try{
            if(batchId != null && batchId != ''){
            batchList = [Select id,Name,Batch_Name__c from Dol_Batch_Monitor__c where Name =: batchId  AND Name != null Limit 1];
                if(Dol_IntegrationUtil.isNotEmpty(batchList)){
                    Dol_Batch_Monitor_Detail__c childrecord = new Dol_Batch_Monitor_Detail__c();
                    childrecord.Start_Time__c = system.now();
                    childrecord.Parent_Batch__c = batchList[0].id;
                    childrecord.Status__c = DOL_AppConstants.RUNNING_STRING_SENTANCECASE;
                    upsert childrecord; 
                    childRecId = childrecord.id; 
                }
            }
        }catch (Exception e){
            System.debug('exception occoured'+e.getMessage()+e.getStackTraceString());
            DebugErrorLoggger.LogError(e, '', '','Dol_BatchMonitoring','createBatchRequest','Create Method failed');
        }
        
        return childRecId;
    }

    global static boolean updateBatchRequest(String childRecordId, String recordCount, String error, String status, String targetDropLocation){
        Dol_Batch_Monitor_Detail__c childRec;
        try{
            childRec = [Select id,Start_Time__c,End_Time__c,Error_Details__c,Parent_Batch__c,Status__c,Total_Records__c FROM Dol_Batch_Monitor_Detail__c WHERE ID=:childRecordId LIMIT 1];
            if(childRec != null){
                childRec.End_Time__c = System.now();
                childRec.Total_Records__c = recordCount != null ? integer.valueof(recordCount) :0;
                childRec.Error_Details__c = error != null ? error : '';
                childRec.Status__c = status != null ? status : '';
                childRec.Target_Drop_Location__c = targetDropLocation !=null ? targetDropLocation : '';
            }
            upsert childRec;
            return true;
        }catch (Exception e){
            System.debug('exception occoured'+e.getMessage()+e.getStackTraceString());
            DebugErrorLoggger.LogError(e, '', '','Dol_BatchMonitoring','updateBatchRequest','Update Method failed');
            return false;
        }
    }

    global class Dol_BatchMonitoringRequest {
        public String method{get;set;}
        public String batchId{get;set;}
        public String childRecoRdId{get;set;}
        public String status{get;set;}
        public String error{get;set;}
        public String recordCount{get;set;}
        public String targetDropLocation{get;set;}
    }

    global class Dol_BatchMonitoringResponse{
        public String status{get;set;}
        public String childRecoRdId{get;set;}
    }

}