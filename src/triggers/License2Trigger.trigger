/**
* Name: License2Trigger
* Type: Trigger
* Description: Trigger on MUSW__License2__c which calls License2TriggerHandler if trigger have not been disabled
* Date:        Developer/Company                    Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 06/13/2018   Sharad Maheshwari/Deloitte           Initial Creation
**/

trigger License2Trigger on MUSW__License2__c(before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    
    /*Checking whehter triggers have been disabled for the user or not*/
    Global_Settings__c globalSetting = Global_Settings__c.getInstance(UserInfo.getUserId());
    if(globalSetting.Disable_Triggers__c == true) {
        /*If the triggers have been disabled, then do not call the trigger handler*/
        return;
    }
    
    system.debug('inside trigger');
    //if(Fee_Waiver.lictrgexcflg){return;}
    /*If the triggers have not been disabled, then call the trigger handler which then executes the required
        code based on before/after insert/update/delete/undelete condition*/
    TriggerDispatcher.Run(new License2TriggerHandler());  
    //added to update renewal fields on License -- siddhesh 
    
   if(trigger.isBefore && trigger.isupdate){
        List<MUSW__License2__c> licList = new List<MUSW__License2__c>();
        for(MUSW__License2__c lic : trigger.new){
            //padma.commented to update renewal date when issuedate changes
            //if(lic.MUSW__Status__c != trigger.oldMap.get(lic.id).MUSW__Status__c && lic.MUSW__Status__c == 'Active' && lic.MUSW__Expiration_Date__c != null){
            if(lic.MUSW__Expiration_Date__c != trigger.oldMap.get(lic.id).MUSW__Expiration_Date__c && lic.MUSW__Status__c == 'Active' && lic.MUSW__Expiration_Date__c != null){
                system.debug('inside if nazneen' +lic);
                system.debug('inside trigger nazneen1' +lic.id);
                licList.add(lic);
            }
            
           system.debug('outside if n loop nazneen' +licList);
        }
        if(!licList.isEmpty()){
            WA_License_utility.updateRenewalFields(licList);
        }
    }

}