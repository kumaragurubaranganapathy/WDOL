/*************************************************************************************************************
** User Story: 
**************************************************************************************************************
** Trigger Name     : EmailNotificationTrigger
** Description      : EmailNotificationTrigger
** Version          : 1.0
** Built By         : Shiva Achukatla
**------------------------------------------------------------------------------------------------------------
** Modification Log:
**------------------
** Developer                  Date          Version               Description
**------------------------------------------------------------------------------------------------------------
** Akosa Okwudiafor           16/08/2018     1.0                   Created
** Review Log:
**---------------
** Reviewer                   Date           Version                Description
**------------------------------------------------------------------------------------------------------------
**
*************************************************************************************************************/
trigger EmailNotificationTrigger on Email_Notification__c (
    before insert, 
    before update, 
    before delete, 
    after insert, 
    after update, 
    after delete, 
    after undelete) {
        Boolean isTriggerDisabled = false;
        Global_Settings__c settings = Global_Settings__c.getInstance(UserInfo.getUserId());
        if (settings.Disable_Triggers__c == true) {
            return;
        }
        TriggerDispatcher.Run(new EmailnotificationTriggerhandler());
}