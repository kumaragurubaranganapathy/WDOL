trigger DRE2_MUSW_Receipt_c on MUSW__Receipt__c (after insert, before update, before delete, after undelete) { BGCM.TriggerManager.execute('DRE2_MUSW_Receipt_c', new DRETriggerHandler()); }