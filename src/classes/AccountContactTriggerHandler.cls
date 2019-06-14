/**
* Name: License2Trigger
* Type: Class
* Description: Trigger Handler for MUSW__Account_Contact__c object being called from AccountContactTrigger
* Date:        Developer/Company                 	Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 08/16/2018   Srikanth Kottam/Deloitte           Initial Creation
**/
public class AccountContactTriggerHandler implements BGCM.ITriggerHandler{
	public void onAfterDelete() {}
    public void onAfterInsert() {
        afterMethod();
    }
    public void onAfterUndelete() {}
    public void onAfterUpdate() {
         afterMethod();
    }
    public void onBeforeDelete() {}
    public void onBeforeInsert() {}
    public void onBeforeUndelete() {}
    public void onBeforeUpdate() {}
    
    public void afterMethod(){
        // Sharing records with Customer Community Plus Portal user
        ApexUserSharingModel apexSharing = new ApexUserSharingModel();
        apexSharing.getAccountIds(Trigger.isInsert, Trigger.isUpdate, (Map<Id, MUSW__Account_Contact__c>)Trigger.OldMap, (Map<Id, MUSW__Account_Contact__c>)Trigger.NewMap);
        System.debug('inSide AccountContactTriggerHandler');
    }
}