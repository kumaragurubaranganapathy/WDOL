trigger DRE2_MUSW_Review_c on MUSW__Review__c (after insert, before update, before delete, after undelete) {
 Global_Settings__c settings = Global_Settings__c.getInstance(UserInfo.getUserId());
    if(settings.Disable_Triggers__c == true)
    return; BGCM.TriggerManager.execute('DRE2_MUSW_Review_c', new DRETriggerHandler()); }