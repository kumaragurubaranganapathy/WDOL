trigger DRE2_ContentDocumentLink on ContentDocumentLink (after insert, before update, before delete, after undelete) { BGCM.TriggerManager.execute('DRE2_ContentDocumentLink', new DRETriggerHandler()); }