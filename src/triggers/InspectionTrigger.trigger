/**
* Name: License2Trigger
* Type: Trigger
* Description: Trigger on MUSW__Inspection__c which calls InspectionTriggerHandler if trigger have not been disabled
* Date:        Developer/Company                    Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 06/13/2018   Aishwaria Rangineni           Initial Creation
**/
trigger InspectionTrigger on MUSW__Inspection__c  (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    /*Checking whehter triggers have been disabled for the user or not*/
    Global_Settings__c globalSetting = Global_Settings__c.getInstance(UserInfo.getUserId());
    if(globalSetting.Disable_Triggers__c == true) {
        /*If the triggers have been disabled, then do not call the trigger handler*/
        return;
    }
    TriggerDispatcher.Run(new InspectionTriggerHandler());   
    
    
}