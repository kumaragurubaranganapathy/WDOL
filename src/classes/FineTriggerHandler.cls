/**
* Name: FineTriggerHandler
* Type: Class
* Description: Trigger Handler for Fine__c object being called from FineTrigger
* Date:        Developer/Company                   Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 08/22/2018   Srikanth Kottam/Deloitte          Initial Creation
**/
public class FineTriggerHandler implements BGCM.ITriggerHandler{
	public void onAfterDelete() {}
    public void onAfterInsert() {
        AfterMethod();
    }
    public void onAfterUndelete() {}
    public void onAfterUpdate() {
        AfterMethod();
    }
    public void onBeforeDelete() {}
    public void onBeforeInsert() {}
    public void onBeforeUndelete() {}
    public void onBeforeUpdate() {}
    
    public void AfterMethod(){
        //Sharing the fine records method call
        FineUsersharing controller = new FineUsersharing();
        controller.shareFineRecords(Trigger.New);
    }
}