/**
* Name: CredCEhoursScheduler
* Type: Class
* Description: Scheduler Class to identify Credential CE hours
* Date:        Developer/Company                   Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 02/13/2019   Srikanth Kottam/Deloitte          Initial Creation
**/

global with sharing class CredCEhoursScheduler implements Schedulable{
    /***************************************************************************************************
* @Description : Runs Batch to 
* @Param       : SchedulableContext
* @Return      : void
****************************************************************************************************/
    global void execute(SchedulableContext sc) {
        //query renewals which are in submitted status and for whom the credential is CE Eligible and credential status is Active/Late Renewal
        String query='Select id, name, CE_Hours__c, Renewal_Cycle_End_Date__c, ' + 
               		 'Renewal_window__c, MUSW__Expiration_Date__c, LastModifiedBy.Name ' +
               		 'from MUSW__License2__c where CE_Eligible__c = true limit 200';
        System.debug('query from scheduler'+ query);
        
        //Call the batch to calcuate and send report
        CredCEhoursFix ceReportBatch = new CredCEhoursFix(query); 
        try{
            database.executebatch(ceReportBatch, 100);
        }
        catch(Exception e){
            ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'CredCEhoursScheduler', 'ceReportBatch', 'Schedulable', 'CredCEhoursScheduler', label.Str_Low);            
        }
    }

}