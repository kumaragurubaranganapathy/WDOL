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
                licList.add(lic);
            }else if(lic.MUSW__Status__c == 'Active' && lic.MUSW__Expiration_Date__c != null && lic.Application_Type__c == 'Notary Public' && lic.MUSW__Issue_Date__c != trigger.oldMap.get(lic.id).MUSW__Issue_Date__c ){
                licList.add(lic);
            }
            String licName = lic.Name;
          
            if(lic.Credential_Type__c == 'Appraiser Course' && String.isNotEmpty(licName) && String.isNotBlank(licName) && !licName.containsAny('A') ){
               
                if(lic.Provider_Type__c == 'Secondary Provider'){
                    licName = 'A'+licName+'S';
                }else{
                    licName = 'A'+licName;
                }
                lic.Name = licName;
            }
        }
        if(!licList.isEmpty()){
            WA_License_utility.updateRenewalFields(licList);
        }
    }

}