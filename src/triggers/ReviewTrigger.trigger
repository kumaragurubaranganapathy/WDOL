trigger ReviewTrigger on MUSW__Review__c  (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    Global_Settings__c globalSetting = Global_Settings__c.getInstance(UserInfo.getUserId());
    if(globalSetting.Disable_Triggers__c == true) {
        /*If the triggers have been disabled, then do not call the trigger handler*/
        return;
    }
    TriggerDispatcher.Run(new ReviewTriggerHandler());   
    
}