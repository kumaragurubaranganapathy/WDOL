trigger Dol_IsLicenseRecordUpdatedForASC on MUSW__License2__c (before insert, before update) {
    
    /*Checking whehter triggers have been disabled for the user or not*/
    Global_Settings__c globalSetting = Global_Settings__c.getInstance(UserInfo.getUserId());
    if(globalSetting.Disable_Triggers__c == true) {
        /*If the triggers have been disabled, then do not call the trigger handler*/
        return;
    }
    public static boolean runOnce = false;
    List<Id> licenseIds  = new List<Id>();
    List<MUSW__License2__c> licenseList = new List<MUSW__License2__c>();
    List<MUSW__License2__c> licenseListtoUpdt = new List<MUSW__License2__c>();
    
    if(trigger.isinsert && trigger.isbefore && runOnce== false){
        runOnce = true;
        for (MUSW__License2__c lic : trigger.new){
            if(lic.MUSW__Applicant__c  != null && lic.MUSW__Status__c  != 'Generate Fee' && lic.Send_information_to_ASC__c != true){
                lic.Send_information_to_ASC__c = true;
            }
        }
    }   
       
    if(trigger.isupdate && trigger.isbefore && runOnce== false){
        runonce = true;
        for (MUSW__License2__c lic : trigger.new){
            if(lic.MUSW__Applicant__c  != null && lic.Send_information_to_ASC__c != true && (lic.MUSW__Applicant__c != trigger.oldmap.get(lic.id).MUSW__Applicant__c
                                          || lic.MUSW__Status__c != trigger.oldmap.get(lic.id).MUSW__Status__c 
                                          || lic.MUSW__Expiration_Date__c != trigger.oldmap.get(lic.id).MUSW__Expiration_Date__c
                                          || lic.MUSW__Type__c != trigger.oldmap.get(lic.id).MUSW__Type__c)){
                lic.Send_information_to_ASC__c = true;                                                                
             }
                
       }
    }    
}