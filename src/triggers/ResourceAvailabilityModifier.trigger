trigger ResourceAvailabilityModifier on Resource_Availability_Modifier__c (before insert) {
  Boolean isTriggerDisabled = false;
    Global_Settings__c settings = Global_Settings__c.getInstance(UserInfo.getUserId());
    if (settings != null) {
        isTriggerDisabled = settings.Disable_Triggers__c;
    }
    
    if (!isTriggerDisabled) {
       ResourceAvailabilityModifierHandler.ResourceAvailabilityModifierHandlerManager(Trigger.new);
    }
}