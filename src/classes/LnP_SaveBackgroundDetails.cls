public class LnP_SaveBackgroundDetails {
    @AuraEnabled
    public static List<SObject> returnIds(String  ObjectName, String applicationId, String recordTypeID ){
      String appCondition = 'Application_Bg__c =\''+applicationId+'\'';
      String query= 'Select id from ' + ObjectName + ' where ' + appCondition +'AND RecordTypeId = \'' +recordTypeID + '\'';
      System.debug('query '+query);
      List<SObject> lId = Database.query(query);
      System.debug('lId>______ '+lId);  
        return lId;
    }
	@AuraEnabled
    public static void deleteTableRecord(String recordId){
        System.debug('---recordId2---'+recordId);
        Id recId = (Id)recordId;
        String sobjectType = recId.getSObjectType().getDescribe().getName();
        String recCondition = 'Id =\''+recId+'\'';
        String query = 'SELECT Id FROM ' + sobjectType + ' WHERE ' + recCondition;
        List<Sobject> recList = Database.query(query);
        if(!recList.isEmpty()){
            try{
                delete recList[0];
            }
            Catch(Exception e){
                System.debug('---EXCEPTION---'+e.getMessage());
            }
        }
    }
}