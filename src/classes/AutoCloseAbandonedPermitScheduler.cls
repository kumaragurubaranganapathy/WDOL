global with sharing class AutoCloseAbandonedPermitScheduler implements Schedulable{
    
    /***************************************************************************************************
	* @Description : Runs Batch to autoclose abandoned applications
	* @Param       : SchedulableContext
	* @Return      : void
	****************************************************************************************************/
    global void execute(SchedulableContext sc) {
        	
        //Runs Batch to autoclose abandoned PTO's, Plan Reviews and Titles
        
        Name_Value_Pair__mdt permitDays = [select Value__c from Name_Value_Pair__mdt where Label = :Label.Str_AutoClosePermitsIn_nDays];
            String autoClosePermitDays = permitDays.Value__c;        
            String autoClosePermitQuery = 'SELECT Id, Name, Application_Type__c, Program_Area__c, Permit_Type__c, MUSW__Status__c, Sub_Status__c '+
                ' FROM MUSW__Permit2__c'+
                ' WHERE MUSW__Status__c = \''+Label.ST_In_Review+'\''+
                ' AND Sub_Status__c = \''+ Label.ST_Additional_Information_Required +'\''+
        		' AND LastModifiedDate < LAST_N_DAYS:'+autoClosePermitDays+'' +
                ' AND Application_Type__c IN (\'' + Label.Str_Permit_to_Operate + '\',' + '\'' + Label.Str_Manufactured_Homes_Communities +'\')';          
        
            AutoCloseAbandonedPTOTitlePRBatch autoClosePermitsBatch = new AutoCloseAbandonedPTOTitlePRBatch(autoClosePermitQuery); 
        try{
            database.executebatch(autoClosePermitsBatch, Integer.valueOf(Label.Str_Batch_Execution_Limit));
        }
        catch(Exception e){
            System.debug('test exception');
            ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'AutoCloseAbandonedAppScheduler', 'permit', 'Schedulable', 'AutoCloseAbandonedAppScheduler', label.Str_Low);            
        }
        
    }       
    
}