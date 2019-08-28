trigger DRE2_Account on Account (after insert, before update, before delete, after undelete){

    Global_Settings__c settings = Global_Settings__c.getInstance(UserInfo.getUserId());
    if(settings.Disable_Triggers__c == true)
    return;
 BGCM.TriggerManager.execute('DRE2_Account', new DRETriggerHandler()); 
}