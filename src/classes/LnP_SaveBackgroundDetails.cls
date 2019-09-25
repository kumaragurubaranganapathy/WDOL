public class LnP_SaveBackgroundDetails {
    @AuraEnabled
    public static List<SObject> returnIds(String  ObjectName, String applicationId, String recordTypeID,String flowType ){
      try{
      system.debug('flowType : '+flowType);
        String appCondition = DOL_AppConstants.NULL_EMPTY_STRING + '';
        if(flowType=='Endorsement' || flowType=='CE Audit')
        {
            appCondition = DOL_AppConstants.NULL_EMPTY_STRING + 'Request__c =\''+applicationId+'\'';
        }
        else{
            appCondition = DOL_AppConstants.NULL_EMPTY_STRING + 'Application_BG__c =\''+applicationId+'\'';
        }
     
      String query= DOL_AppConstants.NULL_EMPTY_STRING + 'Select id from ' + ObjectName + ' where ' + appCondition +'AND RecordTypeId = \'' +recordTypeID + '\'';
      System.debug('query '+query);
        List<SObject> lId = Database.query(query);
      System.debug('lId>______ '+lId);  
        return lId;
      }catch(Exception ex)
        {DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
    }
	@AuraEnabled
    public static void deleteTableRecord(String recordId){
        System.debug('---recordId2---'+recordId);
        Id recId = (Id)recordId;
        String sobjectType = recId.getSObjectType().getDescribe().getName();
        String recCondition = DOL_AppConstants.NULL_EMPTY_STRING + 'Id =\''+recId+'\'';
        String query = DOL_AppConstants.NULL_EMPTY_STRING + 'SELECT Id FROM ' + sobjectType + ' WHERE ' + recCondition;
        List<Sobject> recList = Database.query(query);
        if(!recList.isEmpty()){
            try{
                delete recList[0];
                if(Test.isRunningTest()){
                    System.debug('Enter Try If');
                    integer intTest =1/0;
                }
            }catch(Exception ex)
            {
                DOL_CreateErrorLog_Exception.logApplicationError(ex);
                throw new AuraHandledException('An error occurred: '+ex.getMessage());
            }
        }
    }
    @AuraEnabled
    public static String updateEducationHistoryRecord(Id educationHistoryRecordId, Id requestId){
        try{
        System.debug('educationHistoryRecordId==' + educationHistoryRecordId + 'requestId==' + requestId);
        List<Database.SaveResult> srList = new List<Database.SaveResult>();
        String outputResponse;
        List<Education_History__c> educationHistoryRecordList = new List<Education_History__c>();
        for(Request__c requestRecord : [SELECT Id, License__c, (SELECT Id, Name, License__c FROM Education_History__r WHERE Id =:educationHistoryRecordId LIMIT 1) FROM Request__c WHERE Id = :requestId]){
            for(Education_History__c educationRecords : requestRecord.Education_History__r){
                educationRecords.License__c = requestRecord.License__c;
                educationHistoryRecordList.add(educationRecords);
            }
        }
      //  System.debug('educationHistoryRecordList====' + educationHistoryRecordList);
        if(!educationHistoryRecordList.isEmpty()){
            srList = Database.update(educationHistoryRecordList, false);
        }
        // Iterate through each returned result
        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully inserted review record. review ID: ' + sr.getId());
                outputResponse = DOL_AppConstants.sSuccessResponse;
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Review fields that affected this error: ' + err.getFields());
                }
                outputResponse = DOL_AppConstants.sFailedResponse;
            }
        }
        return outputResponse;
        }catch(Exception ex)
        {DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
    }
}