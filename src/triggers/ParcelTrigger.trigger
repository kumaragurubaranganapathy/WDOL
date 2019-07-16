/**
* Name: ParcelTrigger
* Type: Trigger
* Description: Trigger on MUSW__Parcel__c which calls ParcelTriggerHandler if trigger have not been disabled
* Date:        Developer/Company                 	Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 06/13/2018   Srikanth Kottam/Deloitte           Initial Creation
**/
trigger ParcelTrigger on MUSW__Parcel__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    /*Checking whehter triggers have been disabled for the user or not*/
    Global_Settings__c globalSetting = Global_Settings__c.getInstance(UserInfo.getUserId());
    if(globalSetting.Disable_Triggers__c == true) {
        /*If the triggers have been disabled, then do not call the trigger handler*/
        return;
    }
    
    /* If the triggers have not been disabled, then call the trigger handler */
	TriggerDispatcher.Run(new ParcelTriggerHandler()); 
}