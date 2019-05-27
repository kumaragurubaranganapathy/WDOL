/**
* User Story: 285
* Name: HandleIncompleteRenewalsYearlyScheduler
* Type: Class
* Description: Scheduler class to run the batch class to handle incomplete renewals having CE requirements
* Date:        - Case#/Project:            - Developer/Company                         - Description
* ------------------------------------------------------------------------------------------------------------------------- *
* 09/10/2018   Sharad Maheshwari/Deloitte           Initial Creation 
*/
global with sharing class HandleIncompleteRenewalsYearlyScheduler implements Schedulable{
    
    /***************************************************************************************************
* @Description : Runs Batch to 
* @Param       : SchedulableContext
* @Return      : void
****************************************************************************************************/
    global void execute(SchedulableContext sc) {
        
        String licenseExpirationQuery='SELECT id, MUSW__Status__c, CE_Hours__c, Renewal_Cycle_End_Date__c, CE_Hours_Per_Cycle__c, MUSW__Expiration_Date__c, Application_Type__c, Is_Late_Renewal_Eligible__c  '+
                                        'FROM MUSW__License2__c  '+
                                        'WHERE (((Renewal_Cycle_End_Date__c >= TODAY) AND (MUSW__Expiration_Date__c < TODAY)) OR (Renewal_Cycle_End_Date__c < TODAY)) '+
             							'AND Credential__c NOT IN  ('+'\'' +Label.CR_Manufactured_Homes_Installer +'\''+', '+'\''+Label.CR_Dwelling_Contractor_Qualifier+'\'' +') '+
            							'AND CE_Eligible__c = TRUE';
          
        System.debug('query from final'+ licenseExpirationQuery);
          //call the next batch
        HandleIncompleteRenewalsExpirationBatch handleRenewalsExpirationBatch = new HandleIncompleteRenewalsExpirationBatch(licenseExpirationQuery); 
        try{
            database.executebatch(handleRenewalsExpirationBatch, Integer.valueOf(Label.Str_Batch_Execution_Limit));
        }
        /*
        HandleIncompleteRenewalsYearlyScheduler yearlyScheduler = new HandleIncompleteRenewalsYearlyScheduler();
        String sch = '0 0 23 30 6 ?';
        system.schedule('run yearly on june 30 11 pm', sch, yearlyScheduler);
        */
        catch(Exception e){
            System.debug('test exception');
            ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'HandleIncompleteRenewals', 'final', 'Schedulable', 'HandleIncompleteRenewals', label.Str_Low);            
        }
        
    }       
    
}