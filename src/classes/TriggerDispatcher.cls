/**
* Name: TriggerDispatcher
* Type: Class
* Description: Trigger Dispatcher class to call required trigger method from ITriggerHandler class
* Date:        Developer/Company                 	Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 06/13/2018   Sharad Maheshwari/Deloitte           Initial Creation
**/

public class TriggerDispatcher {
    /*
Call this method from your trigger, passing in an instance of a trigger handler which implements ITriggerHandler.
This method will fire the appropriate methods on the handler depending on the trigger context.
*/
    public static void run(BGCM.ITriggerHandler handler) {
        
        // Detect the current trigger context and fire the relevant methods on the trigger handler:
        
        // Before trigger logic
        if(Trigger.IsBefore) {
            if(Trigger.IsInsert){
                handler.onBeforeInsert();
            }
            if(Trigger.IsUpdate){
                handler.onBeforeUpdate();
            }
            if(Trigger.IsDelete){
                handler.onBeforeDelete();
            }
        }
        
        // After trigger logic
        if(Trigger.IsAfter) {
            if(Trigger.IsInsert){
                handler.onAfterInsert();
            }
            if(Trigger.IsUpdate){
                handler.onAfterUpdate();
            }
            if(trigger.IsDelete){
                handler.onAfterDelete();
            }
            if(trigger.isUndelete){
                handler.onAfterUndelete();
            }
        }
    }
}