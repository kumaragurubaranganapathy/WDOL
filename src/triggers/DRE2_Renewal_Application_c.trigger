trigger DRE2_Renewal_Application_c on Renewal_Application__c (after insert, before update, before delete, after undelete) { BGCM.TriggerManager.execute('DRE2_Renewal_Application_c', new DRETriggerHandler());
    
 }