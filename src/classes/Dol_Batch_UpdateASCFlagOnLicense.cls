global with sharing class Dol_Batch_UpdateASCFlagOnLicense implements 
Database.Batchable<sObject>, Database.Stateful , Database.AllowsCallouts {
    
    global Integer elapsedtime;
    global String errorMsg;
    global List<Dol_Batch_Monitor_Detail__c> finalChildList;
    global List<Contact> contactList;
    global List<MUSW__Parcel__c> parcelList;

    global Database.QueryLocator start(Database.BatchableContext BC){
        System.debug('Dol_Batch_UpdateASCFlagOnLicense::start...');
          return Database.getQueryLocator([select id,Name,Send_information_to_ASC__c,MUSW__Applicant__c,MUSW__Applicant__r.IsContactRecordUpdatedForASC__c,MUSW__Parcel__c,MUSW__Parcel__r.IsParcelRecordUpdatedForASC__c from MUSW__License2__c  where (MUSW__Applicant__r.IsContactRecordUpdatedForASC__c = true or MUSW__Parcel__r.IsParcelRecordUpdatedForASC__c = true) and Send_information_to_ASC__c = false]);
    }
    
    
    global void execute(Database.BatchableContext BC, List<MUSW__License2__c> licenseList){      
        System.debug('... licenseList -'+licenseList);
        List<MUSW__License2__c> finalLicenseList= new List<MUSW__License2__c>();
		contactList = new List<Contact>();
        parcelList = new List<MUSW__Parcel__c>();
        if(Dol_IntegrationUtil.isNotEmpty(LicenseList)){
            for(MUSW__License2__c licenseRecord : LicenseList){
                licenseRecord.Send_information_to_ASC__c = true;
                if(Dol_IntegrationUtil.isNotBlank(licenseRecord.MUSW__Applicant__c) && licenseRecord.MUSW__Applicant__r.IsContactRecordUpdatedForASC__c == true){
                    Contact con = new Contact(id =licenseRecord.MUSW__Applicant__c,IsContactRecordUpdatedForASC__c = false);
                    if(!contactList.contains(con)){
                        contactList.add(con);
                    } 
                    
                }
                if(Dol_IntegrationUtil.isNotBlank(licenseRecord.MUSW__Parcel__c) && licenseRecord.MUSW__Parcel__r.IsParcelRecordUpdatedForASC__c == true){
                    MUSW__Parcel__c par = new MUSW__Parcel__c(id =licenseRecord.MUSW__Parcel__c,IsParcelRecordUpdatedForASC__c = false);
                    if(!parcelList.contains(par)){
                       parcelList.add(par);
                    }
                    
                }
                
                finalLicenseList.add(licenseRecord);
            }
            System.debug('finalLicenseList -'+finalLicenseList);
            Database.UpsertResult[] lsr;
            if(Dol_IntegrationUtil.isNotEmpty(finalLicenseList)) {
                try{
                    lsr = Database.upsert(finalLicenseList,false);
                } catch(Exception e) {
                    System.debug('Dol_Batch_UpdateASCFlagOnLicense - Exception: '+e);
                    DebugErrorLoggger.LogError(e, '', '','Dol_Batch_UpdateASCFlagOnLicense','BatchExecute','Batch Execute Method failed');
                }
            }
            
        }
    }
    
    
    global void finish(Database.BatchableContext BC){   
        Database.UpsertResult[] conatctListUpst;
        Database.UpsertResult[] parcelListUpst;
            if(Dol_IntegrationUtil.isNotEmpty(contactList)) {
                try{
                    conatctListUpst = Database.upsert(contactList,false);
                } catch(Exception e) {
                    System.debug('Dol_Batch_UpdateASCFlagOnLicense - Exception: '+e);
                    DebugErrorLoggger.LogError(e, '', '','Dol_Batch_UpdateASCFlagOnLicense','Batchfinish','Batch finish Method failed');
                }
            }
        	if(Dol_IntegrationUtil.isNotEmpty(parcelList)) {
                try{
                    parcelListUpst = Database.upsert(parcelList,false);
                } catch(Exception e) {
                    System.debug('Dol_Batch_UpdateASCFlagOnLicense - Exception: '+e);
                    DebugErrorLoggger.LogError(e, '', '','Dol_Batch_UpdateASCFlagOnLicense','Batchfinish','Batch finish Method failed');
                }
            }
    }
}