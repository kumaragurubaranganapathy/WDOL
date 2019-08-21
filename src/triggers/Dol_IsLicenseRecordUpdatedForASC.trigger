trigger Dol_IsLicenseRecordUpdatedForASC on MUSW__License2__c (after insert, after update) {
    /*Checking whehter triggers have been disabled for the user or not*/
    Global_Settings__c globalSetting = Global_Settings__c.getInstance(UserInfo.getUserId());
    if(globalSetting.Disable_Triggers__c == true) {
        /*If the triggers have been disabled, then do not call the trigger handler*/
        return;
    }
	List<Id> licenseIds  = new List<Id>();
    List<MUSW__License2__c> licenseList = new List<MUSW__License2__c>();
    List<MUSW__License2__c> licenseListtoUpdt = new List<MUSW__License2__c>();
    
    if(trigger.isinsert && trigger.isafter){
        for (MUSW__License2__c lic : trigger.new){
            if(lic.MUSW__Applicant__c  != null && lic.MUSW__Status__c  != 'Generate Fee' ){
                licenseIds.add(lic.id);
            }
        }
		if(!licenseIds.isEmpty()){   // Added the check before query to ensure query is fired only when the licenseIDs are present  
			licenseList = [select id,Name,MUSW__Status__c,Send_information_to_ASC__c from MUSW__License2__c  where id=:licenseIds];
        }
        if(Dol_IntegrationUtil.isNotEmpty(licenseList)){
            for(MUSW__License2__c lic :licenseList){
                if(lic.MUSW__Status__c  != 'Generate Fee'){
                    lic.Send_information_to_ASC__c = true;
                    licenseListtoUpdt.add(lic);
                } 
            }
        }
        if(Dol_IntegrationUtil.isNotEmpty(licenseListtoUpdt)){
            upsert licenseListtoUpdt;
        }    
    }
    if(trigger.isupdate && trigger.isafter){
        for (MUSW__License2__c lic : trigger.new){
            if(lic.MUSW__Applicant__c  != null && (lic.MUSW__Applicant__c != trigger.oldmap.get(lic.id).MUSW__Applicant__c
                                          || lic.MUSW__Status__c != trigger.oldmap.get(lic.id).MUSW__Status__c 
                                          || lic.MUSW__Expiration_Date__c != trigger.oldmap.get(lic.id).MUSW__Expiration_Date__c
                                          || lic.MUSW__Type__c != trigger.oldmap.get(lic.id).MUSW__Type__c))
                licenseIds.add(lic.id);
            }
		if(!licenseIds.isEmpty()){   // Added the check before query to ensure query is fired only when the licenseIDs are present  
        licenseList = [select id,Send_information_to_ASC__c,(select id,MUSW__Parcel__c from MUSW__License2_Parcels__r where Mailing__c = true) from MUSW__License2__c  where id=:licenseIds];
        }
        if(Dol_IntegrationUtil.isNotEmpty(licenseList)){
            for(MUSW__License2__c lic :licenseList){
                if(Dol_IntegrationUtil.isNotEmpty(lic.MUSW__License2_Parcels__r)){
                    lic.Send_information_to_ASC__c = true;
                    licenseListtoUpdt.add(lic);  
                }
            }
        }  
        if(Dol_IntegrationUtil.isNotEmpty(licenseListtoUpdt)){
            upsert licenseListtoUpdt;
        }    
    }
}