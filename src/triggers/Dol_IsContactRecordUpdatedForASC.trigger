trigger Dol_IsContactRecordUpdatedForASC on Contact (after update) {
     List<Id> contactIds  = new List<Id>();
     List<MUSW__License2__c> licenseList = new List<MUSW__License2__c>();
     List<MUSW__License2__c> licenseListToUpdt = new List<MUSW__License2__c>();
   
     for(Contact con : trigger.new){
         if((con.UID__c != trigger.oldmap.get(con.id).UID__c || con.LastName != trigger.oldmap.get(con.id).LastName
             || con.FirstName != trigger.oldmap.get(con.id).FirstName|| con.MiddleName != trigger.oldmap.get(con.id).MiddleName
             || con.Phone != trigger.oldmap.get(con.id).Phone || con.Company_Name__c != trigger.oldmap.get(con.id).Company_Name__c))
         {
             contactIds.add(con.id);
         }
    }
    if(Dol_IntegrationUtil.isNotEmpty(contactIds)){
        licenseList = [select id,Send_information_to_ASC__c from MUSW__License2__c  where MUSW__Applicant__c =:contactIds];
    }
    for(MUSW__License2__c lic : licenseList){
        lic.Send_information_to_ASC__c = true;
        licenseListToUpdt.add(lic);
    }
    if(Dol_IntegrationUtil.isNotEmpty(licenseListToUpdt)){
        System.debug('licenseListToUpdt'+licenseListToUpdt);
        upsert licenseListToUpdt;
    }
    
}