trigger ContactTrigger on Contact (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    Global_Settings__c gs = Global_Settings__c.getInstance(UserInfo.getUserId());
    if(gs.Disable_Triggers__c == true){
        // If the triggers have been disabled, then do not call the trigger handler
        return;
    }
    //calling the trigger handler
    TriggerDispatcher.Run(new ContactTriggerHandler()); 
}