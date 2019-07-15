trigger ComplaintMainTrigger on MUSW__Complaint2__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    RunTriggerDispatcher.run(new ComplaintMainTriggerHandler());
}