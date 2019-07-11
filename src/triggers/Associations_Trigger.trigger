/**
Trigger Name    : Associations_Trigger
Description     : This is a Trigger for the Associations__c object. 
Created By      : Deloitte Inc.,
Created Date    : 19th June 2019
Modification Log:
-------------------------------------------------------------------------------------------------------------- 
Developer                   Date                   Description
--------------------------------------------------------------------------------------------------------------            
Pramod                   19 june 2019                  Initial Creation
*/
trigger Associations_Trigger on Associations__c (before insert,before update,before Delete,after Insert,after Update,after Delete,after Undelete) {

    new Associations_Trigger_Handler().run();

}