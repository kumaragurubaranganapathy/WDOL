/**
* Name: ParcelTriggerHandler
* Type: Class
* Description: Trigger Handler for MUSW__Parcel__c object being called from ParcelTrigger
* Date:        Developer/Company                   Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 07/12/2018   Srikanth Kottam/Deloitte           Initial Creation
* 08/22/2018   Srikanth Kottam/Deloitte             Apex Sharing
**/
public class ParcelTriggerHandler implements BGCM.ITriggerHandler {
    
    public ParcelTriggerHandler() {
        //This is to check whether bypass the trigger or not
        Global_Settings__c settings = Global_Settings__c.getInstance(UserInfo.getUserId());
        if (settings.Disable_Triggers__c == true)
            return;
    }
    
    public void onBeforeDelete() {}
    public void onBeforeInsert() {
        Beforemethod();
    }
    public void onBeforeUndelete() {}
    public void onBeforeUpdate() {
        Beforemethod();
    }
    public void onAfterDelete() {}
    public void onAfterInsert() {
        Aftermethod();
    }
    public void onAfterUndelete() {}
    public void onAfterUpdate() {
        Aftermethod();
    }
    Public void Beforemethod() {
        for (MUSW__Parcel__c p : (list<MUSW__Parcel__c>) Trigger.new) {
            if (p.International_Address__c != null) {
                String address = p.International_Address__c;
                if (address.length() > 80) address = address.substring(0, 80);
                p.Name = address;
            }
            
        }
        
    }
    
    Public void Aftermethod(){
        //This Method is called when already an AccountContact Record exists on an Account and parcel records get Created. This Record will be shared with the community Plus User
        //ParcelUsersharing controller = new ParcelUsersharing();
        //controller.ParcelSharing_RecordInsert(Trigger.New);
        //End of Parcel_UsersharingModel

        //Share the Parcel records when the Delegated Admin is the applicant on the Credential/Permit
        PracelCreatedByDelegate DelegateController = new PracelCreatedByDelegate();
        DelegateController.shareParcelRecords(Trigger.New);
    }
}