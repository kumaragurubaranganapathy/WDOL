trigger RequestTrigger on Request__c (before update,after update) {
    System.debug('in RequestTrigger');
    /*Checking whehter triggers have been disabled for the user or not*/
    Global_Settings__c globalSetting = Global_Settings__c.getInstance(UserInfo.getUserId());
    if(globalSetting.Disable_Triggers__c == true) {
        return;
    }
    TriggerDispatcher.Run(new RequestTriggerHandler());   
    
}