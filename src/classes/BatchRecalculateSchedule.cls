/*Name: BatchRecalculateSchedule
  *Description: BatchRecalculateSchedule to auto renew avalibility of LOCATION resources
  This Class is a batch class which will renew Location schedule expiring in next 4 weeks
  * Date:        - Case#/Project:            - Developer/Company                               - Description
  * ------------------------------------------------------------------------------------------------------------------------- *
*/


global class BatchRecalculateSchedule implements Database.Batchable < sObject > {
  public String Query;
  global BatchRecalculateSchedule() {
    Query = 'Select ' + Commonutil.getFields('Resource_Week_Availability__c') +
    ' from Resource_Week_Availability__c where Autorenewal__c =true';
  }
  global Database.QueryLocator start(Database.BatchableContext BC) {
    return Database.getQueryLocator(query);
  }

  global void execute(Database.BatchableContext BC, List<sObject> scope) {
    for (Resource_Week_Availability__c res : (List<Resource_Week_Availability__c>) scope) {
      res.Schedule_Valid_From__c = System.today();
      res.Schedule_Valid_till__c = System.today().addDays(120);
    }
    if (scope != null) {
      update scope;
    }
  }

  global void finish(Database.BatchableContext BC) {
  }
}