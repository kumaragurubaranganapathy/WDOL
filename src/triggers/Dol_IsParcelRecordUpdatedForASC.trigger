trigger Dol_IsParcelRecordUpdatedForASC on MUSW__Parcel__c (before update) {
    /*Checking whehter triggers have been disabled for the user or not*/
    Global_Settings__c globalSetting = Global_Settings__c.getInstance(UserInfo.getUserId());
    if(globalSetting.Disable_Triggers__c == true) {
        /*If the triggers have been disabled, then do not call the trigger handler*/
        return;
    }
     List<Id> parcelIds  = new List<Id>();
     List<MUSW__Parcel__c> parcelList = new List<MUSW__Parcel__c>();
   
     for(MUSW__Parcel__c par : trigger.new){
         if(par.IsParcelRecordUpdatedForASC__c != true && (par.MUSW__Street2__c != trigger.oldmap.get(par.id).MUSW__Street2__c 
             || par.MUSW__City__c != trigger.oldmap.get(par.id).MUSW__City__c
             || par.MUSW__State__c != trigger.oldmap.get(par.id).MUSW__State__c
             || par.MUSW__Post_Zip_Code__c != trigger.oldmap.get(par.id).MUSW__Post_Zip_Code__c))
         {
             parcelIds.add(par.id);
         }
    }
    if(Dol_IntegrationUtil.isNotEmpty(parcelIds)){
        parcelList = [select id,IsParcelRecordUpdatedForASC__c,(Select id,MUSW__License2__r.Credential_Type__c  from MUSW__Parcel_License2s__r where Mailing__c =true and Mailing__c != null and MUSW__License2__r.Credential_Type__c in ('Certified Residential Appraiser','Certified General Appraiser','State Licensed Appraiser'))  from MUSW__Parcel__c  where id =:parcelIds and id != null];
    }

    for(MUSW__Parcel__c parcel : parcelList){
        if(Dol_IntegrationUtil.isNotEmpty(parcel.MUSW__Parcel_License2s__r)){ 
            for(MUSW__Parcel__c par : trigger.new){
                par.IsParcelRecordUpdatedForASC__c = true;
            }     
        }
    }
}