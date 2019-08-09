trigger DRE2_MUSW_Inspection_c on MUSW__Inspection__c (after insert, before update, before delete, after undelete) { 
    Global_Settings__c gs = Global_Settings__c.getInstance(UserInfo.getUserId());
    if(gs.Disable_Triggers__c == true){
        // If the triggers have been disabled, then do not call the trigger handler
        return;
    }
	BGCM.TriggerManager.execute('DRE2_MUSW_Inspection_c', new DRETriggerHandler()); 
}