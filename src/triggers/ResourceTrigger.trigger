trigger ResourceTrigger on Resource__c (after insert,before update, after update) {
    Boolean isTriggerDisabled = false;
    Global_Settings__c settings = Global_Settings__c.getInstance(UserInfo.getUserId());
    if (settings != null) {
        isTriggerDisabled = settings.Disable_Triggers__c;
    }
    
    if (!isTriggerDisabled) {
        if((Trigger.isInsert || Trigger.isUpdate) && Trigger.isAfter){
            List<Resource__c> newResources = [Select Id,User__c from Resource__c where ID=: Trigger.new];
            TimeSlotsHelper.ConfigureResources(newResources);
        }
        
    }
}