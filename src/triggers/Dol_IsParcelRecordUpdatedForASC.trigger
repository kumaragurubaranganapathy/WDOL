trigger Dol_IsParcelRecordUpdatedForASC on MUSW__Parcel__c (before update) {
     List<Id> parcelIds  = new List<Id>();
     List<MUSW__Parcel__c> parcelList = new List<MUSW__Parcel__c>();
   
     for(MUSW__Parcel__c par : trigger.new){
         if((par.MUSW__Street2__c != trigger.oldmap.get(par.id).MUSW__Street2__c 
             || par.MUSW__City__c != trigger.oldmap.get(par.id).MUSW__City__c
             || par.MUSW__State__c != trigger.oldmap.get(par.id).MUSW__State__c
             || par.MUSW__Post_Zip_Code__c != trigger.oldmap.get(par.id).MUSW__Post_Zip_Code__c))
         {
             parcelIds.add(par.id);
         }
    }
    System.debug('parcelIds'+parcelIds);
    if(Dol_IntegrationUtil.isNotEmpty(parcelIds)){
        parcelList = [select id,IsParcelRecordUpdatedForASC__c,(Select id from MUSW__Parcel_License2s__r where Mailing__c =true)  from MUSW__Parcel__c  where id =:parcelIds];
    }

    for(MUSW__Parcel__c parcel : parcelList){
        if(Dol_IntegrationUtil.isNotEmpty(parcel.MUSW__Parcel_License2s__r)){ 
            for(MUSW__Parcel__c par : trigger.new){
                par.IsParcelRecordUpdatedForASC__c = true;
            }     
        }
    }
}