public class LnP_ApplicationsController {
    public class application{
        public Id appId;
    }
    @AuraEnabled
    public static List<MUSW_Application2__c> getApplications(){ 
        list<MUSW_Application2__c> ApplicationList = new list<MUSW_Application2__c>();
        String Condition1 = 'MUSW__Status__c = \'Pending\'';
        String str = 'Select Id, Name FROM MUSW_Application2__c WHERE '+Condition1 + 'ORDER BY CREATEDDATE DESC';
  		system.debug('str--'+str);
        ApplicationList = Utilityclass_withsharing.queryRecords(Str);
        
        return ApplicationList;
	}
    
}