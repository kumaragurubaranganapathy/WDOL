trigger DRE2_MUSW_Complaint2_c on MUSW__Complaint2__c (after insert, before update, before delete, after undelete) {
/*Checking whehter triggers have been disabled for the user or not*/
    Global_Settings__c globalSetting = Global_Settings__c.getInstance(UserInfo.getUserId());
    if(globalSetting.Disable_Triggers__c == true) {
        /*If the triggers have been disabled, then do not call the trigger handler*/
        return;
    }
    
    BGCM.TriggerManager.execute('DRE2_MUSW_Complaint2_c', new DRETriggerHandler()); 
}