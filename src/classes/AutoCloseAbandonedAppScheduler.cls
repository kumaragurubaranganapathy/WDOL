/**
 * User Story: 285
 * Name: AutoCloseAbandonedAppScheduler
 * Type: Class
 * Description: Scheduler class to run the batch class to auto close abandoned applications
 * Date:        - Case#/Project:            - Developer/Company                         - Description
 * ------------------------------------------------------------------------------------------------------------------------- *
 * 07/09/2018   Sharad Maheshwari/Deloitte           Initial Creation 
 */
global with sharing class AutoCloseAbandonedAppScheduler implements Schedulable{
    
    /***************************************************************************************************
	* @Description : Runs Batch to autoclose abandoned applications
	* @Param       : SchedulableContext
	* @Return      : void
	****************************************************************************************************/
    global void execute(SchedulableContext sc) {
        	
        	//Runs Batch to autoclose abandoned credentials
            Name_Value_Pair__mdt credentialDays = [select Value__c from Name_Value_Pair__mdt where Label = :Label.Str_AutoCloseCredentialsIn_nDays];
            String autoCloseCredentialDays = credentialDays.Value__c;        
            String autoCloseCredentialQuery = 'SELECT Id, Name, Application_Type__c, Credential_Type__c, Credential__c, MUSW__Status__c FROM MUSW__License2__c'+
                ' WHERE MUSW__Status__c = \''+Label.ST_Pending+'\''+
                ' AND LastModifiedDate < LAST_N_DAYS:'+autoCloseCredentialDays+'';       
            AutoCloseAbandonedCredentialBatch autoCloseCredentialsBatch = new AutoCloseAbandonedCredentialBatch(autoCloseCredentialQuery); 
        try{
            database.executebatch(autoCloseCredentialsBatch, Integer.valueOf(Label.Str_Batch_Execution_Limit));
        }
        catch(Exception e){
            System.debug('test exception');
            ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'AutoCloseAbandonedAppScheduler', 'credential', 'Schedulable', 'AutoCloseAbandonedAppScheduler', label.Str_Low);            
        }
        
    }       
    
}