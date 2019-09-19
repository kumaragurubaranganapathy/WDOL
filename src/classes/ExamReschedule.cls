public class ExamReschedule {
    
    //method to get Education History Related List for Specific License
    @AuraEnabled
    public static List<Education_History__c> getEducationHistoryData(String licenseId){
        try{
        System.debug('licenseId=== ' + licenseId);
        List<Education_History__c> educationHistoryList = new List<Education_History__c>();
        Id educationHistoryRecordId = Schema.SObjectType.Education_History__c.getRecordTypeInfosByName().get('Exam').getRecordTypeId() ;
        if(String.isNotBlank(licenseId)){
            system.debug('inside debug');
            for(Education_History__c educationHistoryRecods: [Select Id, Name, License__c, License_Type__c, Exam_Type__c, Scheduled_Date__c,
                                                              Status__c, Exam_Result_Expiry_Date__c, End_date__c, Exam_Pass_Date__c,Reschedule_Possible__c,Program_Type__c,Submit_Exam_Results__c
                                                              From Education_History__c Where License__c = :licenseId
                                                              And RecordTypeId = :educationHistoryRecordId]){
                                                                  educationHistoryList.add(educationHistoryRecods);                                             
                                                              }
        }
        return educationHistoryList;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            return null;
        }
    }
    @AuraEnabled
     public static String insertRequestExam(String licId,String licenseType, String board,String ServiceRequestType,String ExamRecordId)
    {
        try{
        List<User> userInfoData = new  List<User>();
        String queryCondition = ' Id=\''+String.escapeSingleQuotes(UserInfo.getUserId())+'\'';
        System.debug('User Id ' + queryCondition);
        String queryStr = 'SELECT Username, ContactId, Contact.Name, Contact.AccountId, Contact.Account.Name FROM User WHERE  '+queryCondition + 'Limit 1';
        system.debug('queryStr '+queryStr);
        
        userInfoData = Utilityclass_withsharing.queryRecords(queryStr);
        Id getContactId = '003r000000EOhBB';
        if(userInfoData[0].ContactId != null){
            getContactId = userInfoData[0].ContactId;
        }
        system.debug('licenseType'+licenseType+'board');
        Request__c application = new Request__c();
        application.Profession__c = board; 
        application.License_Type__c = licenseType;        
        application.Stage__c = 0;
        application.Service_Request_Type__c = ServiceRequestType;
        application.Contact__c = getContactId;
        application.Exam__c = ExamRecordId;
        
        if(licId != null && licId != ''){
            application.License__c = licId;  
        }  
        try
        {          
            insert application;
        }
        catch(Exception e){
            HandleException.LogException(e,'ExamReschedule','insertRequest');            
        }
        string appId = '';
        return appId = application.Id;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            return null;
        }
    }
    
    @AuraEnabled
    public static String createReviewRecord(MUSW__License2__c licenseRecord, Id requestId){
        try{
        System.debug('licenseRecord==' + licenseRecord + 'requestId==' + requestId);
        Database.SaveResult[] srList;
        String outputResponse;
        Id reviewRecordId = Schema.SObjectType.MUSW__Review__c.getRecordTypeInfosByName().get('License Review').getRecordTypeId() ;
        List<MUSW__Review__c> reviewList = new List<MUSW__Review__c>();
        if(String.isNotBlank(licenseRecord.Id) && String.isNotBlank(requestId)){
            MUSW__Review__c reviewRecord = new MUSW__Review__c();
            reviewRecord.Request__c = requestId;
            reviewRecord.License__c = licenseRecord.Id;
            reviewRecord.License_Type__c = licenseRecord.Credential_Type__c;
            reviewRecord.Application_Type__c = licenseRecord.Application_Type__c;
            reviewRecord.MUSW__Status__c = 'In-Review';
            reviewRecord.RecordTypeId = reviewRecordId;
            reviewList.add(reviewRecord);
        }
        if(!reviewList.isEmpty()){
            srList = Database.insert(reviewList, false);
        }
        // Iterate through each returned result
        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully inserted review record. review ID: ' + sr.getId());
                outputResponse ='Successfull';
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Review fields that affected this error: ' + err.getFields());
                }
                outputResponse ='Fail';
            }
        }
        return outputResponse;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            return 'Fail';
        }
    }
}