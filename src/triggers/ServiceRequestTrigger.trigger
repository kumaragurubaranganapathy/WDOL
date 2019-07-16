/*************************************************************************************************************
**************************************************************************************************************
** Trigger Name     : ServiceRequestTrigger
** Description      : Trigger for Service Request            
** Version          : 1.0
** Built By         : 
**********************************************************************************/

trigger ServiceRequestTrigger on MUSW__Application2__c  (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    //This is to check whether bypass the trigger or not
    Global_Settings__c settings = Global_Settings__c.getInstance(UserInfo.getUserId());
    if (settings.Disable_Triggers__c == true) 
        return;
    //Trigger handler
    TriggerDispatcher.Run(new ServiceRequestTriggerHandler()); 

}