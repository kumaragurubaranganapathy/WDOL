/**
Trigger Name    : Associations_Trigger
Description     : This is a Trigger for the Associations__c object. 
Created By      : Deloitte Inc.,
Created Date    : 19th June 2019
Modification Log:
-------------------------------------------------------------------------------------------------------------- 
Developer                   Date                   Description
--------------------------------------------------------------------------------------------------------------            
Pramod                   19 june 2019                  Initial Creation
*/
trigger Associations_Trigger on Associations__c (before insert,before update,before Delete,after Insert,after Update,after Delete,after Undelete) {
 /*Checking whehter triggers have been disabled for the user or not*/
    Global_Settings__c globalSetting = Global_Settings__c.getInstance(UserInfo.getUserId());
    if(globalSetting.Disable_Triggers__c == true) {
        /*If the triggers have been disabled, then do not call the trigger handler*/
        return;
    }
    new Associations_Trigger_Handler().run();

}