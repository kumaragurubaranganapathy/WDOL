/*Name: ModifyTimeResources
*This batch updates the time availability if the new availability start date is now past the start tme.
* Date:        - Case#/Project:            - Developer/Company                               - Description
* ------------------------------------------------------------------------------------------------------------------------- *
* 11/17.2017                           - Okwudiafor Akosa, Deloitte                  - Initial Implementation.
*/
global class ModifyTimeResources implements Database.Batchable < sObject > {
    public String Query;
    global ModifyTimeResources() {
        Query ='Select id,Time_Availability__c,New_Time_Availability__c from Resource_Availability__c where New_Availability_Start_Date__c=today and New_Time_Availability__c!=null limit 1000';
    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        for (Resource_Availability__c res : (List<Resource_Availability__c>) scope) {
            if(res.New_Time_Availability__c.contains(Label.ST_Unavailable))
            {
                           res.Time_Availability__c =''; 
            }
            else{
                            res.Time_Availability__c = res.New_Time_Availability__c;
            }
            res.New_Time_Availability__c = '';
            res.New_Availability_Start_Date__c  = null;
        }
        if (scope != null) {
            update scope;
        }
    }
    
    global void finish(Database.BatchableContext BC) {
    }
}