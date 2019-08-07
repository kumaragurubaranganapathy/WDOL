trigger Dol_IsLicenseRecordUpdatedForASC on MUSW__License2__c (after insert, after update) {
    List<Id> licenseIds  = new List<Id>();
    List<MUSW__License2__c> licenseList = new List<MUSW__License2__c>();
    List<MUSW__License2__c> licenseListtoUpdt = new List<MUSW__License2__c>();
    
    if(trigger.isinsert && trigger.isafter){
        for (MUSW__License2__c lic : trigger.new){
            if(lic.MUSW__Applicant__c  != null && lic.MUSW__Parcel__c != null){
                licenseIds.add(lic.id);
            }
        }
        licenseList = [select id,Name,Send_information_to_ASC__c from MUSW__License2__c  where id=:licenseIds];
        
        if(Dol_IntegrationUtil.isNotEmpty(licenseList)){
            for(MUSW__License2__c lic :licenseList){
                lic.Send_information_to_ASC__c = true;
                licenseListtoUpdt.add(lic);
            }
        }
        if(Dol_IntegrationUtil.isNotEmpty(licenseListtoUpdt)){
            upsert licenseListtoUpdt;
        }    
    }
    if(trigger.isupdate && trigger.isafter){
        for (MUSW__License2__c lic : trigger.new){
            if(lic.MUSW__Applicant__c  != null && lic.MUSW__Parcel__c != null &&
                                        (lic.MUSW__Applicant__c != trigger.oldmap.get(lic.id).MUSW__Applicant__c
                                          || lic.MUSW__Parcel__c != trigger.oldmap.get(lic.id).MUSW__Parcel__c 
                                          || lic.MUSW__Status__c != trigger.oldmap.get(lic.id).MUSW__Status__c 
                                          || lic.MUSW__Expiration_Date__c != trigger.oldmap.get(lic.id).MUSW__Expiration_Date__c
                                          || lic.MUSW__Type__c != trigger.oldmap.get(lic.id).MUSW__Type__c)
              ){
                licenseIds.add(lic.id);
            }
        }
        licenseList = [select id,Name,MUSW__Status__c,MUSW__Expiration_Date__c , MUSW__Type__c ,Send_information_to_ASC__c,
                       MUSW__Applicant__c,MUSW__Applicant__r.UID__c,MUSW__Applicant__r.LastName,MUSW__Applicant__r.FirstName,
                       MUSW__Applicant__r.MiddleName,MUSW__Applicant__r.Phone,MUSW__Applicant__r.Company_Name__c,
                       MUSW__Parcel__c, MUSW__Parcel__r.MUSW__Street2__c, MUSW__Parcel__r.MUSW__City__c ,MUSW__Parcel__r.MUSW__State__c,MUSW__Parcel__r.MUSW__Post_Zip_Code__c
                       from MUSW__License2__c  where id=:licenseIds];
        
        if(Dol_IntegrationUtil.isNotEmpty(licenseList)){
            for(MUSW__License2__c lic :licenseList){
                lic.Send_information_to_ASC__c = true;
                licenseListtoUpdt.add(lic);
            }
        }
        if(Dol_IntegrationUtil.isNotEmpty(licenseListtoUpdt)){
            upsert licenseListtoUpdt;
        }    
    }
    


}