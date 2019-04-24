/**
* Name: License2Trigger
* Type: Trigger
* Description: Trigger on Renewal_Application__c which calls RenewalApplicationTriggerHandler if trigger have not been disabled
* Date:        Developer/Company                 	Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 8/2/2018   Akosa Okwudiafor/Deloitte           Initial Creation
**/
trigger RenewalApplicationTrigger on Renewal_Application__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
		System.debug('()()() in trigger RenewalApplicationTrigger');
        /*Checking whehter triggers have been disabled for the user or not*/
    Global_Settings__c globalSetting = Global_Settings__c.getInstance(UserInfo.getUserId());
    if(globalSetting.Disable_Triggers__c == true) {
        System.debug('()()() triggers disabled');
        /*If the triggers have been disabled, then do not call the trigger handler*/
        return;
    }
    System.debug('()()() trigger is working');
    /*If the triggers have not been disabled, then call the trigger handler which then executes the required
		code based on before/after insert/update/delete/undelete condition*/
    TriggerDispatcher.Run(new RenewalApplicationTriggerHandler());   
}