/**
Trigger Name    : Associations_Trigger_Handler
Description     : This is a Trigger Handler for the Associations__c object. 
Created By      : Deloitte Inc.,
Created Date    : 19th June 2019
Modification Log:
-------------------------------------------------------------------------------------------------------------- 
Developer                   Date                   Description
--------------------------------------------------------------------------------------------------------------            
Pramod                   19 june 2019                  Initial Creation
*/
public class Associations_Trigger_Handler extends TriggerHandler {
    
    public Associations_Trigger_Handler (){
        
        // sets the number of times account handler has to be executed, can be used to prevent recursion.
        
    }
    //overiding the trigger handler
    public override void beforeInsert() {
        
        AssociationUtility.restrictChildLicensesCount(trigger.new);
        
    }
    //overiding the trigger handler
    public override void beforeUpdate() {
        
        AssociationUtility.restrictChildLicensesCount(trigger.new);
    }
    
    //overiding the trigger handler
    public override void beforeDelete() {
        
        
    }
    //overiding the trigger handler
    public override void afterInsert() {
        
        
    }
    //overiding the trigger handler
    public override void afterUpdate() {
        
        
    }
    //overiding the trigger handler
    public override void afterDelete() {
        
        
    } 
    //overiding the trigger handler
    public override void afterUndelete() {
        
        
    }    
    
    
}