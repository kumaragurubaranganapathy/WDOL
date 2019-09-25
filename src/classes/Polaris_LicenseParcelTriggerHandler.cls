public with sharing class Polaris_LicenseParcelTriggerHandler {
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    public Polaris_LicenseParcelTriggerHandler(boolean isExecuting, integer size)
    {
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
    public void OnAfterInsert(list<MUSW__License_Parcel__c> licenseParcelList)
    {
        
        //logic for updating the Parcel feild on license which is captured in LicenseParcel 
        system.debug('Trigger On After Insert ');
        
        Map<Id, MUSW__License2__c> licenseMap = new  Map<Id, MUSW__License2__c>([Select Id, MUSW__Parcel__c from MUSW__License2__c limit 200]) ;
        
        list<MUSW__License2__c> licensetoUpdate = new list<MUSW__License2__c>();
        for(MUSW__License_Parcel__c lp : licenseParcelList){
            if(lp.Mailing__c == true && lp.MUSW__Parcel__c != null && lp.MUSW__License2__c != null){                
                MUSW__License2__c licRec = licenseMap.get(lp.MUSW__License2__c) ;
                licRec.MUSW__Parcel__c = lp.MUSW__Parcel__c;
                licensetoUpdate.add(licRec);
            }
        }
        if(!licensetoUpdate.isEmpty() ){
            update licensetoUpdate;
        }
        
    }
    
    public void OnBeforeInsert(list<MUSW__License_Parcel__c> licenseParcelList)
    {
        system.debug('Trigger On Before Insert ');
    }    
    
    public void OnAfterUpdate( List<MUSW__License_Parcel__c> newlicenseParcelList, List<MUSW__License_Parcel__c> oldlicenseParcelList, 
                              Map<ID, MUSW__License_Parcel__c> newlicenseParcelMap , Map<ID, MUSW__License_Parcel__c> oldlicenseParcelMap ) 
    {
        //logic for updating the Parcel feild on license which is captured in LicenseParcel 
        system.debug('Trigger On After Update ');
        Map<Id, MUSW__License2__c> licenseMap = new  Map<Id, MUSW__License2__c>([Select Id, MUSW__Parcel__c from MUSW__License2__c]) ;
        
        list<MUSW__License2__c> licensetoUpdate = new list<MUSW__License2__c>();
        
        for(MUSW__License_Parcel__c lp : newlicenseParcelList){
            if(lp.Mailing__c == true && lp.MUSW__Parcel__c != null && lp.MUSW__License2__c != null){   
                if((oldlicenseParcelMap.get(lp.Id).MUSW__Parcel__c != lp.MUSW__Parcel__c) || (oldlicenseParcelMap.get(lp.Id).MUSW__License2__c != lp.MUSW__License2__c)){
                    MUSW__License2__c licRec = licenseMap.get(lp.MUSW__License2__c) ;
                    licRec.MUSW__Parcel__c = lp.MUSW__Parcel__c;
                    licensetoUpdate.add(licRec);
                }
                
            }
        }
        if(!licensetoUpdate.isEmpty() ){
            update licensetoUpdate;
        }
        
    }
    
    public void OnBeforeUpdate( List<MUSW__License_Parcel__c> newlicenseParcelList, List<MUSW__License_Parcel__c> oldlicenseParcelList, 
                               Map<ID, MUSW__License_Parcel__c> newlicenseParcelMap , Map<ID, MUSW__License_Parcel__c> oldlicenseParcelMap ) 
    {
        
        system.debug('Trigger On Before Update ');
        
    }
}