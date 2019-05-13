trigger Dol_IsParcelRecordUpdatedForASC on MUSW__Parcel__c (after update) {
     List<Id> parcelIds  = new List<Id>();
     List<MUSW__License2__c> licenseList = new List<MUSW__License2__c>();
     List<MUSW__License2__c> licenseListToUpdt = new List<MUSW__License2__c>();
   
     for(MUSW__Parcel__c par : trigger.new){
         if((par.MUSW__Street2__c != trigger.oldmap.get(par.id).MUSW__Street2__c 
             || par.MUSW__City__c != trigger.oldmap.get(par.id).MUSW__City__c
             || par.MUSW__State__c != trigger.oldmap.get(par.id).MUSW__State__c
             || par.MUSW__Post_Zip_Code__c != trigger.oldmap.get(par.id).MUSW__Post_Zip_Code__c))
         {
             parcelIds.add(par.id);
         }
    }
    if(Dol_IntegrationUtil.isNotEmpty(parcelIds)){
        licenseList = [select id,Name,Send_information_to_ASC__c from MUSW__License2__c  where MUSW__Parcel__c =:parcelIds];
    }
    for(MUSW__License2__c lic : licenseList){
        lic.Send_information_to_ASC__c = true;
        licenseListToUpdt.add(lic);
    }
    if(Dol_IntegrationUtil.isNotEmpty(licenseListToUpdt)){
        upsert licenseListToUpdt;
    }
    
}