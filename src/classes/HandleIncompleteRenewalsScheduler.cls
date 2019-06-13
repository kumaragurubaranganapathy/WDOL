/**
* User Story: 285
* Name: HandleIncompleteRenewalsScheduler
* Type: Class
* Description: Scheduler class to run the batch class to handle incomplete renewals having CE requirements
* Date:        - Case#/Project:            - Developer/Company                         - Description
* ------------------------------------------------------------------------------------------------------------------------- *
* 09/10/2018   Sharad Maheshwari/Deloitte           Initial Creation 
*/
global with sharing class HandleIncompleteRenewalsScheduler implements Schedulable{
    
    /***************************************************************************************************
* @Description : Runs Batch to 
* @Param       : SchedulableContext
* @Return      : void
****************************************************************************************************/
    global void execute(SchedulableContext sc) {
        
        //query renewals which are in submitted status and for whom the credential is CE Eligible and credential status is Active/Late Renewal
        String query='SELECT id, name, CE_Hours__c, license__r.id, license__r.CE_Eligible__c, '+
                     'license__r.CE_Hours__c, license__r.MUSW__Status__c, license__r.CE_Hours_Needed__c, '+
                     'license__r.CE_Hours_per_Cycle__c, license__r.Renewal_Window__c, ' +
                     'license__r.MUSW__Expiration_Date__c, license__r.MUSW__Total_Balance__c, '+
					 'license__r.Credential_Type__c, license__r.Credential__c, license__r.Application_Type__c '+
					'FROM Renewal_Application__c  '+
                    'WHERE Renewal_Status__c = '+'\''+Label.ST_Submitted +'\''+
                    'AND license__r.CE_Eligible__c = True '+
            		'AND license__r.MUSW__Status__c IN ('+'\'' +Label.ST_Active +'\''+', '+'\''+Label.ST_Late_Renewal+'\'' +') ';
                    //'AND license__r.MUSW__Expiration_Date__c < Today';
        System.debug('query from scheduler'+ query);
        //Call the batch to update review/license status as per the business logic
        HandleIncompleteRenewalsBatch handleRenewalsBatch = new HandleIncompleteRenewalsBatch(query); 
        try{
            database.executebatch(handleRenewalsBatch, Integer.valueOf(Label.Str_Batch_Execution_Limit));
        }
        catch(Exception e){
            ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'HandleIncompleteRenewals', 'handleRenewalsBatch', 'Schedulable', 'HandleIncompleteRenewals', label.Str_Low);            
        }
        
    }       
    
}