trigger AnswerTrigger on Answer__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    System.debug('in answertrigger');
 Global_Settings__c settings = Global_Settings__c.getInstance(UserInfo.getUserId());
     
    if (settings.Disable_Triggers__c == true) 
            return;
    //trigger Handler
    System.debug('before answertriggerhandler');
    TriggerDispatcher.Run(new AnswerTriggerHandler()); 
}