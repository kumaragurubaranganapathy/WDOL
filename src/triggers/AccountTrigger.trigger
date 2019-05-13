/**
* Name: AccountTrigger
* Type: Trigger
* Description: Trigger on Account Object which calls AccountTriggerHandler if trigger have not been disabled
* Date:        Developer/Company                    Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 08/06/2018   Srikanth Kottam/Deloitte           Initial Creation
**/
trigger AccountTrigger on Account (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    /*Checking whether triggers have been disabled for the user or not*/
    Global_Settings__c gs = Global_Settings__c.getInstance(UserInfo.getUserId());
    if(gs.Disable_Triggers__c == true){
        // If the triggers have been disabled, then do not call the trigger handler
        return;
    }
    //calling the trigger handler
    TriggerDispatcher.Run(new AccountTriggerHandler());
}