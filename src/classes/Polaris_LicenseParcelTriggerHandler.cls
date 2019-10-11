public class Polaris_LicenseParcelTriggerHandler implements BGCM.ITriggerHandler {
    public void onAfterDelete() {}
    public void onAfterInsert() {
        updateLicenseRecordwithAddress();
    }
    public void onAfterUndelete() {}
    public void onAfterUpdate() {
        updateLicenseRecordwithAddressAfterUpdate();
    }
    public void onBeforeDelete() {}
    public void onBeforeInsert() {
        insertLicenseParcelUpdatedForASC ();
    }
    public void onBeforeUndelete() {}
    public void onBeforeUpdate() {  
        updateLicenseParcelUpdatedForASC();
    }
    //Code written by Nibedita in Dol_IsLicenseParcelUpdatedForASC is changed here
    private static void insertLicenseParcelUpdatedForASC () {
        List<MUSW__License_Parcel__c> triggerNew = Trigger.New;
        for(MUSW__License_Parcel__c licenseParceL : triggerNew){
            if(licenseParceL.Mailing__c  == true && (licenseParceL.License_Type__c =='Certified Residential Appraiser' 
                                                     || licenseParceL.License_Type__c == 'Certified General Appraiser' || licenseParceL.License_Type__c =='State Licensed Appraiser') )
            {
                licenseParceL.IsLicenseParcelUpdatedForASC__c = true;             
            } 
            
        }        
    }
    
    private static void updateLicenseParcelUpdatedForASC () {
        List<MUSW__License_Parcel__c> triggerNew = Trigger.New;
        Map<Id,MUSW__License_Parcel__c> oldMapLicense = (Map<Id,MUSW__License_Parcel__c>)Trigger.OldMap;
        for(MUSW__License_Parcel__c licP : triggerNew){
            System.debug('inside Lic update');
            if(licP.Mailing__c == true && oldMapLicense.get(licP.id).Mailing__c != true && licP.IsLicenseParcelUpdatedForASC__c != true && licP.MUSW__License2__c != null
               && (licP.License_Type__c =='Certified Residential Appraiser' 
                   || licP.License_Type__c == 'Certified General Appraiser' || licP.License_Type__c =='State Licensed Appraiser') ) {
                       
                       licP.IsLicenseParcelUpdatedForASC__c = true;
                   }
        }
    }
    // Code to populate address on License 
    private static void updateLicenseRecordwithAddress () {
        DOL_AppUTility.runfromDolBatchUpdateLicenseStatus = true;
        List<MUSW__License_Parcel__c> triggerNew = Trigger.New;
        List<MUSW__License2__c> licensetoUpdate = new list<MUSW__License2__c>();
        Map<Id, MUSW__License2__c> licenseMap = new  Map<Id, MUSW__License2__c>();
        List<Id> licenseParcelIds  = new List<Id>();
        for (MUSW__License_Parcel__c licP :triggerNew){
            licenseParcelIds.add(licP.MUSW__License2__c);
        }
        for (MUSW__License2__c lst  : [Select Id, MUSW__Parcel__c,Public_Address__c from MUSW__License2__c where id = :licenseParcelIds order by createdDate desc]) {
            licenseMap.put(lst.Id,lst);
        }
        for(MUSW__License_Parcel__c lp : triggerNew){
            if(!licenseMap.isEmpty()){
                MUSW__License2__c licRec = licenseMap.get(lp.MUSW__License2__c) ;
                if(!licenseMap.isEmpty() && lp.Mailing__c == true && lp.MUSW__Parcel__c != null &&  lp.Physical__c == false  && lp.MUSW__License2__c != null){                
                    licRec.MUSW__Parcel__c = lp.MUSW__Parcel__c;
                    licensetoUpdate.add(licRec);
                } else if(!licenseMap.isEmpty() && lp.Physical__c == true && lp.Mailing__c == false && lp.MUSW__Parcel__c != null && lp.MUSW__License2__c != null)  {
                    licRec.Public_Address__c = lp.MUSW__Parcel__c;
                    licensetoUpdate.add(licRec);
                } else if(!licenseMap.isEmpty() && lp.Physical__c == true  && lp.Mailing__c == true && lp.MUSW__Parcel__c != null && lp.MUSW__License2__c != null) {
                    
                    licRec.MUSW__Parcel__c = lp.MUSW__Parcel__c;
                    licRec.Public_Address__c = lp.MUSW__Parcel__c;
                    licensetoUpdate.add(licRec);   
                }
            }
        }
        if(!licensetoUpdate.isEmpty()){
            update licensetoUpdate;
        }
        
    }
    
    private static void updateLicenseRecordwithAddressAfterUpdate () {
        DOL_AppUTility.runfromDolBatchUpdateLicenseStatus = true;
        system.debug('inside test');
        List<MUSW__License_Parcel__c> triggerNew = Trigger.New;
        List<MUSW__License2__c> licensetoUpdate = new list<MUSW__License2__c>();
        Map<Id, MUSW__License2__c> licenseMap = new  Map<Id, MUSW__License2__c>();
        List<Id> licenseParcelIds  = new List<Id>();
        for (MUSW__License_Parcel__c licP :triggerNew){
            licenseParcelIds.add(licP.MUSW__License2__c);
        }
        for (MUSW__License2__c lst  : [Select Id, MUSW__Parcel__c,Public_Address__c from MUSW__License2__c where id = :licenseParcelIds order by createdDate desc]) {
            licenseMap.put(lst.Id,lst);
        }
        for(MUSW__License_Parcel__c lp : triggerNew){
            
            if(!licenseMap.isEmpty()){
                MUSW__License2__c licRec = licenseMap.get(lp.MUSW__License2__c) ;
                if(!licenseMap.isEmpty() && lp.Mailing__c == true  &&  lp.Physical__c == false  && lp.MUSW__Parcel__c != null && lp.MUSW__License2__c != null){                
                    licRec.MUSW__Parcel__c = lp.MUSW__Parcel__c;
                    licRec.Public_Address__c = null;
                    licensetoUpdate.add(licRec);
                } else if(!licenseMap.isEmpty() && lp.Physical__c == true  &&  lp.Mailing__c == false && lp.MUSW__Parcel__c != null && lp.MUSW__License2__c != null)  {    
                    licRec.Public_Address__c = lp.MUSW__Parcel__c;
                    licRec.MUSW__Parcel__c =null;
                    licensetoUpdate.add(licRec);
                    
                } else if(!licenseMap.isEmpty() && (lp.Physical__c == true  && lp.Mailing__c == true) && lp.MUSW__Parcel__c != null && lp.MUSW__License2__c != null) {
                    licRec.MUSW__Parcel__c = lp.MUSW__Parcel__c;
                    licRec.Public_Address__c = lp.MUSW__Parcel__c;
                    licensetoUpdate.add(licRec);   
                } 
            }
            
        }
        if(!licensetoUpdate.isEmpty()){
            update licensetoUpdate;
        }
        
    }
}
