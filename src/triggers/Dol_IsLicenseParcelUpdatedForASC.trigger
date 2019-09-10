trigger Dol_IsLicenseParcelUpdatedForASC on MUSW__License_Parcel__c (after insert, after update) {
    Global_Settings__c gs = Global_Settings__c.getInstance(UserInfo.getUserId());
    if(gs.Disable_Triggers__c == true){
        // If the triggers have been disabled, then do not call the trigger handler
        return;
    }
     List<Id> licenseParcelIds  = new List<Id>();
     List<MUSW__License_Parcel__c> licenseParceList = new List<MUSW__License_Parcel__c>();
     List<MUSW__License_Parcel__c> updtlicenseParceList = new List<MUSW__License_Parcel__c>();
    
    if(trigger.isinsert && trigger.isafter){
        System.debug('inside new');
      for (MUSW__License_Parcel__c licP : trigger.new){
            if(licP.Mailing__c  == true ){
                licenseParcelIds.add(licP.id);
            }
        }
    }
    if(Dol_IntegrationUtil.isNotEmpty(licenseParcelIds)){
        licenseParceList = [Select id, MUSW__License2__c, MUSW__License2__r.Credential_Type__c from MUSW__License_Parcel__c where id =: licenseParcelIds AND MUSW__License2__r.Credential_Type__c in ('Certified Residential Appraiser','Certified General Appraiser','State Licensed Appraiser')];
        for(MUSW__License_Parcel__c parLic : licenseParceList){
            for(MUSW__License_Parcel__c licP : trigger.new){
                licP.IsLicenseParcelUpdatedForASC__c = true;
            }
        }
    }
    
     if(trigger.isupdate && trigger.isafter){
         for(MUSW__License_Parcel__c licP : trigger.new){
             System.debug('inside Lic update');
             if(licP.Mailing__c == true && trigger.oldmap.get(licP.id).Mailing__c != true && licP.IsLicenseParcelUpdatedForASC__c != true && licP.MUSW__License2__c != null ) {
                     System.debug('inside Lic update after'+licP);
                 licenseParcelIds.add (licP.id);
             }
         }
         if(Dol_IntegrationUtil.isNotEmpty(licenseParcelIds)){
            licenseParceList = [Select id, MUSW__License2__c,IsLicenseParcelUpdatedForASC__c, MUSW__License2__r.Credential_Type__c from MUSW__License_Parcel__c where id =: licenseParcelIds AND MUSW__License2__r.Credential_Type__c in ('Certified Residential Appraiser','Certified General Appraiser','State Licensed Appraiser')];
                for(MUSW__License_Parcel__c licenseParceL : licenseParceList){
                    licenseParceL.IsLicenseParcelUpdatedForASC__c = true;
                    updtlicenseParceList.add(licenseParceL);
                }
            }
         if(Dol_IntegrationUtil.isNotEmpty(updtlicenseParceList)){
            upsert updtlicenseParceList;
         }
     }   
}