trigger Dol_IsLicenseParcelUpdatedForASC on MUSW__License_Parcel__c (after insert, after update) {
     List<Id> permitParcelIds  = new List<Id>();
     List<MUSW__License_Parcel__c> permitParcelList = new List<MUSW__License_Parcel__c>();
     List<MUSW__License_Parcel__c> updtPermitParcelList = new List<MUSW__License_Parcel__c>();
    
    if(trigger.isinsert && trigger.isafter){
        System.debug('inside new');
      for (MUSW__License_Parcel__c pLic : trigger.new){
            if(pLic.Mailing__c  == true ){
                System.debug('inside mailing true');
                permitParcelIds.add(pLic.id);
            }
        }
        System.debug('permitParcelIds'+permitParcelIds);
        permitParcelList = [select id,IsLicenseParcelUpdatedForASC__c from MUSW__License_Parcel__c  where id=:permitParcelIds];
        System.debug('permitParcelList'+permitParcelList);
        for(MUSW__License_Parcel__c parcelLic : permitParcelList){
               parcelLic.IsLicenseParcelUpdatedForASC__c = TRUE;
               updtPermitParcelList.add(parcelLic);
    	}
        if(Dol_IntegrationUtil.isNotEmpty(updtPermitParcelList)){
            upsert updtPermitParcelList;
        } 
    }
    
     if(trigger.isupdate && trigger.isafter){
         for(MUSW__License_Parcel__c permitPar : trigger.new){
             if(permitPar.Mailing__c == TRUE && trigger.oldmap.get(permitPar.id).Mailing__c != TRUE) {
                 permitParcelIds.add(permitPar.id);
             }
        }
        System.debug('permitParcelIds'+permitParcelIds);
        if(Dol_IntegrationUtil.isNotEmpty(permitParcelIds)){
            permitParcelList = [select id,IsLicenseParcelUpdatedForASC__c  from MUSW__License_Parcel__c  where id =:permitParcelIds];
        }
    
        for(MUSW__License_Parcel__c permitPar : permitParcelList){
            for(MUSW__License_Parcel__c pPar : trigger.new){
                pPar.IsLicenseParcelUpdatedForASC__c = true;
            }     
        }
     }   
}