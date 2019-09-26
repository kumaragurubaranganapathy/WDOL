/**
* Name: SubmissionTrigger
* Type: Trigger
* Description: Trigger on MUSW__Submission__c which calls SubmissionTriggerHandler if trigger have not been disabled
* Date:        Developer/Company                    Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 08/21/2018   Srikanth Kottam/Deloitte           Initial Creation
**/
trigger SubmissionTrigger on MUSW__Submission__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    /*Checking whehter triggers have been disabled for the user or not*/
    Global_Settings__c globalSetting = Global_Settings__c.getInstance(UserInfo.getUserId());
    if(globalSetting.Disable_Triggers__c == true) {
        /*If the triggers have been disabled, then do not call the trigger handler*/
        return;
    }
    /*If the triggers have not been disabled, then call the trigger handler which then executes the required
        code based on before/after insert/update/delete/undelete condition*/
    TriggerDispatcher.Run(new SubmissionTriggerHandler()); 
	
	 if(trigger.isBefore && trigger.isUpdate){
     set<Id> setSubIds = new set<Id>();
     for(MUSW__Submission__c obj: trigger.new){
       if(obj.MUSW__License2__c != null && obj.CustomerEnvelope__c!=null)
          setSubIds.add(obj.Id);
     }
     list<MUSW__Submission__c> mapSubmissions = [select id,MUSW__License2__c,MUSW__License2__r.Customer_Envelope__c,MUSW__License2__r.Validation_Number__c,CustomerEnvelope__c,Validation_Number__c from MUSW__Submission__c where id IN: setSubIds ];
     for(MUSW__Submission__c obj: mapSubmissions ){
       if(obj.MUSW__License2__c != null ){
       obj.MUSW__License2__r.Customer_Envelope__c = obj.CustomerEnvelope__c;
       obj.MUSW__License2__r.Validation_Number__c = obj.Validation_Number__c;
       }
     }
}
}