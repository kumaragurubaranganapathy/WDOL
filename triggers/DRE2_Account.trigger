trigger DRE2_Account on Account (after insert, before update, before delete, after undelete) { BGCM.TriggerManager.execute('DRE2_Account', new DRETriggerHandler()); }