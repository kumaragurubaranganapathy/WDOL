trigger Dol_IsLicenseParcelUpdatedForASC on MUSW__License_Parcel__c (after insert, after update) {
    Global_Settings__c gs = Global_Settings__c.getInstance(UserInfo.getUserId());
    if(gs.Disable_Triggers__c == true){
        // If the triggers have been disabled, then do not call the trigger handler
        return;
    }
   TriggerDispatcher.Run(new Polaris_LicenseParcelTriggerHandler());
}