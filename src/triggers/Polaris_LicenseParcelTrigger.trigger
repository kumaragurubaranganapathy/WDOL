trigger Polaris_LicenseParcelTrigger on MUSW__License_Parcel__c (after insert, after update , before insert ,before update) {
    Global_Settings__c gs = Global_Settings__c.getInstance(UserInfo.getUserId());
    if(gs.Disable_Triggers__c == true){
        // If the triggers have been disabled, then do not call the trigger handler
        return;
    }    
	Polaris_LicenseParcelTriggerHandler handler = new Polaris_LicenseParcelTriggerHandler(Trigger.isExecuting, Trigger.size);
    
    if( Trigger.isInsert )
    {
        if(Trigger.isBefore)
        {
            handler.OnBeforeInsert(trigger.New);
        }
        else
        {
            handler.OnAfterInsert(trigger.New);
        }
    }
    else if ( Trigger.isUpdate )
    {
        if(Trigger.isBefore)
        {
            handler.OnBeforeUpdate(trigger.New ,trigger.Old,Trigger.NewMap,Trigger.OldMap);
        }
        else
        {
            handler.OnAfterUpdate(trigger.New ,trigger.Old,Trigger.NewMap,Trigger.OldMap);
        }
    }
}