public with sharing class DRETriggerHandler implements BGCM.ITriggerHandler
{
    public void onBeforeInsert() {}
    public void onBeforeUpdate() { executeDRE(); }
    public void onBeforeDelete() { executeDRE(); }
    public void onBeforeUndelete() {}
    public void onAfterInsert() { executeDRE(); }
    public void onAfterUpdate() {}
    public void onAfterDelete() {}
    public void onAfterUndelete() { executeDRE(); }
  
    private void executeDRE()
    {
        Boolean commitResults = false;
        DRE.DREOutput output = DRE.DREManager.runTrigger(commitResults);
 
        if (output == null) return;
 
        BGCM.DMLManager.upsertRecords(output.getSObjectsForUpsert());
 
        Boolean commitUpserts = false,
                commitDeletes = true,
                commitCustomResults = true,
                sendEmails = true;
  
        // must be the last thing that happens
        DRE.DREManager.commitResults(output, commitUpserts, commitDeletes, commitCustomResults, sendEmails);
    }
}