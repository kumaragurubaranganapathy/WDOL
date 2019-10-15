trigger Dol_IsLicenseParcelUpdatedForASC on MUSW__License_Parcel__c (after insert, after update, before insert, before update ,after delete, before delete, after undelete) {
    Global_Settings__c gs = Global_Settings__c.getInstance(UserInfo.getUserId());
    if(gs.Disable_Triggers__c == true){
        // If the triggers have been disabled, then do not call the trigger handler
        return;
    }
   TriggerDispatcher.Run(new Polaris_LicenseParcelTriggerHandler());
}