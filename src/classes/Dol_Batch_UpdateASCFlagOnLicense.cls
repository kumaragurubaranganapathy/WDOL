global with sharing class Dol_Batch_UpdateASCFlagOnLicense implements 
Database.Batchable<sObject>, Database.Stateful , Database.AllowsCallouts {
    
    global Integer elapsedtime;
    global String errorMsg;
    global List<Dol_Batch_Monitor_Detail__c> finalChildList;
    global List<Contact> contactList;
    global List<MUSW__Parcel__c> parcelList;
    global List<MUSW__License_Parcel__c> licParcelList;
    global List<MUSW__License2__c> licenseList;
    global List<Id> licenseIds = new List<Id>();
    
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        //System.debug('Dol_Batch_UpdateASCFlagOnLicense::start...');
          return Database.getQueryLocator([select id, IsLicenseParcelUpdatedForASC__c, MUSW__License2__c, MUSW__License2__r.Send_information_to_ASC__c, 
                                           MUSW__License2__r.MUSW__Applicant__r.IsContactRecordUpdatedForASC__c, MUSW__Parcel__c,
                                           MUSW__Parcel__r.IsParcelRecordUpdatedForASC__c from MUSW__License_Parcel__c 
                                           where (IsLicenseParcelUpdatedForASC__c= true Or MUSW__License2__r.MUSW__Applicant__r.IsContactRecordUpdatedForASC__c = true or MUSW__Parcel__r.IsParcelRecordUpdatedForASC__c = true) 
                                           and MUSW__License2__r.Send_information_to_ASC__c = false and MUSW__License2__r.Credential_Type__c in('Certified Residential Appraiser','Certified General Appraiser','State Licensed Appraiser')]);
    }
    
    global void execute(Database.BatchableContext BC, List<MUSW__License_Parcel__c> licenseParcelList){      
        //System.debug('... licenseParcelList -'+licenseParcelList);
        List<MUSW__License2__c> finalLicenseList= new List<MUSW__License2__c>();
		contactList = new List<Contact>();
        parcelList = new List<MUSW__Parcel__c>();
        licParcelList = new List<MUSW__License_Parcel__c>();
        if(Dol_IntegrationUtil.isNotEmpty(licenseParcelList)){
            for(MUSW__License_Parcel__c licenseParRecord : licenseParcelList){
            	//licenseParRecord.MUSW__License2__r.Send_information_to_ASC__c = true;
                if(Dol_IntegrationUtil.isNotBlank(licenseParRecord.MUSW__License2__r.MUSW__Applicant__c) && licenseParRecord.MUSW__License2__r.MUSW__Applicant__r.IsContactRecordUpdatedForASC__c == true){
                    Contact con = new Contact(id = licenseParRecord.MUSW__License2__r.MUSW__Applicant__c,IsContactRecordUpdatedForASC__c = false);
                    if(!contactList.contains(con)){
                        contactList.add(con);
                    } 
                    
                }
                if(Dol_IntegrationUtil.isNotBlank(licenseParRecord.MUSW__Parcel__c) && licenseParRecord.MUSW__Parcel__r.IsParcelRecordUpdatedForASC__c == true){
                    MUSW__Parcel__c par = new MUSW__Parcel__c(id =licenseParRecord.MUSW__Parcel__c,IsParcelRecordUpdatedForASC__c = false);
                    if(!parcelList.contains(par)){
                       parcelList.add(par);
                    }  
                }
                
                if(licenseParRecord.IsLicenseParcelUpdatedForASC__c == true){
                    MUSW__License_Parcel__c licPar = new MUSW__License_Parcel__c(id =licenseParRecord.id,IsLicenseParcelUpdatedForASC__c= false );
                    if(!licParcelList.contains(licPar)){
                       licParcelList.add(licPar);
                    }  
                }
                if(Dol_IntegrationUtil.isNotBlank(licenseParRecord.MUSW__License2__c)){
                    MUSW__License2__c lic = new MUSW__License2__c(id = licenseParRecord.MUSW__License2__c,Send_information_to_ASC__c = true);
                    if(!finalLicenseList.contains(lic)){
                       finalLicenseList.add(lic);
                    }  
                }
                
            }
            //System.debug('finalLicenseList -'+finalLicenseList);
            Database.UpsertResult[] lsr;
            if(Dol_IntegrationUtil.isNotEmpty(finalLicenseList)) {
                try{
                    lsr = Database.upsert(finalLicenseList,false);
                } catch(Exception e) {
                    //System.debug('Dol_Batch_UpdateASCFlagOnLicense - Exception: '+e);
                    DebugErrorLoggger.LogError(e, '', '','Dol_Batch_UpdateASCFlagOnLicense','BatchExecute','Batch Execute Method failed');
                }
            }
            
        }
    }
    
    
    global void finish(Database.BatchableContext BC){   
        Database.UpsertResult[] conatctListUpst;
        Database.UpsertResult[] parcelListUpst;
        Database.UpsertResult[] licParcelListUpst;
            if(Dol_IntegrationUtil.isNotEmpty(contactList)) {
                try{
                    conatctListUpst = Database.upsert(contactList,false);
                } catch(Exception e) {
                    //System.debug('Dol_Batch_UpdateASCFlagOnLicense - Exception: '+e);
                    DebugErrorLoggger.LogError(e, '', '','Dol_Batch_UpdateASCFlagOnLicense','Batchfinish','Batch finish Method failed');
                }
            }
        	if(Dol_IntegrationUtil.isNotEmpty(parcelList)) {
                try{
                    parcelListUpst = Database.upsert(parcelList,false);
                } catch(Exception e) {
                    //System.debug('Dol_Batch_UpdateASCFlagOnLicense - Exception: '+e);
                    DebugErrorLoggger.LogError(e, '', '','Dol_Batch_UpdateASCFlagOnLicense','Batchfinish','Batch finish Method failed');
                }
            }
        	if(Dol_IntegrationUtil.isNotEmpty(licParcelList)) {
                try{
                    licParcelListUpst = Database.upsert(licParcelList,false);
                } catch(Exception e) {
                    //System.debug('Dol_Batch_UpdateASCFlagOnLicense - Exception: '+e);
                    DebugErrorLoggger.LogError(e, '', '','Dol_Batch_UpdateASCFlagOnLicense','Batchfinish','Batch finish Method failed');
                }
            }
    }
}