public class CEAudit_Request {
    //method to get Education History Related List for Specific License
    @AuraEnabled
    public static Request__c getLicenseRecordData(Id requestId){
        //System.debug('requestId=== ' + requestId);
        try{
        for(Request__c requestRecord : [SELECT Id, License__c, License_Type__c, License__r.Profession_Code__c FROM Request__c
                                        WHERE Id = :requestId LIMIT 1]){
                                            return requestRecord; 
                                        }
        return null;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
    }
    
}