trigger DRE2_Endorsement_c on Endorsement__c (after insert, before update, before delete, after undelete) { 
    Global_Settings__c gs = Global_Settings__c.getInstance(UserInfo.getUserId());
    if(gs.Disable_Triggers__c == true){
        // If the triggers have been disabled, then do not call the trigger handler
        return;
    }
    BGCM.TriggerManager.execute('DRE2_Endorsement_c', new DRETriggerHandler()); 
}