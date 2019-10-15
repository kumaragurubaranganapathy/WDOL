@isTest
public class Polaris_LicenseParcelTriggerHandler_Test {
    
    @testSetup
    private static void setupTestData()
    {   
        Account account = new Account(Name= DOL_AppConstants.NULL_EMPTY_STRING + 'Test Account',UBI_Number__c ='79068467');
        insert account;
        Contact c = new Contact(LastName= DOL_AppConstants.NULL_EMPTY_STRING + 'Test Contact44',FirstName= DOL_AppConstants.NULL_EMPTY_STRING + 'BasicGov', Email= DOL_AppConstants.NULL_EMPTY_STRING + 'test@basicgov.com',Account=account
                               ,Unique_ID_To_Provide__c='No_SSN_or_ITIN');
        insert c;

        Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        MUSW__License2__c lic1 = DOL_TestDataFactory.createLicenseIndividual(LicRecTypeId1, c.Id, 'Appraisers - Real Estate', 'Certified General Appraiser', 'General Application');
        MUSW__Parcel__c par = new MUSW__Parcel__c(Name= DOL_AppConstants.NULL_EMPTY_STRING + 'xyz123Unique1', Address_Type__c='PHYSICAL ADDRESS',MUSW__Primary_Contact__c= c.Id);
        insert par;
        MUSW__Parcel__c par4 = new MUSW__Parcel__c(Name= DOL_AppConstants.NULL_EMPTY_STRING + 'xyz123Unique4', Address_Type__c='PHYSICAL ADDRESS',MUSW__Primary_Contact__c= c.Id);
        insert par4;
        MUSW__Parcel__c par2 = new MUSW__Parcel__c(Name= DOL_AppConstants.NULL_EMPTY_STRING + 'xyz123Unique2', Address_Type__c='MAILING ADDRESS',MUSW__Primary_Contact__c=c.id);
        insert par2;
        MUSW__Parcel__c par3 = new MUSW__Parcel__c(Name= DOL_AppConstants.NULL_EMPTY_STRING + 'xyz123Unique3',Address_Type__c='MAILING ADDRESS', is_Physical_and_Mailing_Address_Same__c=true,MUSW__Primary_Contact__c =c.id);
        insert par3;
        List<MUSW__Parcel__c > lstparcel = [Select Id,Address_Type__c,is_Physical_and_Mailing_Address_Same__c FROM MUSW__Parcel__c where MUSW__Primary_Contact__r.name ='BasicGov Test Contact44'];        
         List<MUSW__License_Parcel__c> licenseParcelList = new List<MUSW__License_Parcel__c>();
        for(MUSW__Parcel__c parcelInstance : lstparcel) {
            MUSW__License_Parcel__c licenseParcelRecord = new MUSW__License_Parcel__c();
            licenseParcelRecord.MUSW__Parcel__c = parcelInstance.Id;
            licenseParcelRecord.MUSW__License2__c    = lic1.id;
            licenseParcelRecord.Status__c = 'Active';
            if(parcelInstance.Address_Type__c == DOL_AppConstants.CAP_MAILING_ADDRESS && !parcelInstance.is_Physical_and_Mailing_Address_Same__c){
                licenseParcelRecord.Mailing__c = true;
            }else if(parcelInstance.Address_Type__c == DOL_AppConstants.CAP_MAILING_ADDRESS && parcelInstance.is_Physical_and_Mailing_Address_Same__c){
                licenseParcelRecord.Mailing__c = true;
                licenseParcelRecord.Physical__c = true;
            }else{
                licenseParcelRecord.Physical__c = true;
            }
            licenseParcelList.add(licenseParcelRecord); 
        }
        insert licenseParcelList;
       
    }
    
    @isTest
    public static void testTriggerInsert(){
        List<MUSW__Parcel__c > lstparcel = [Select Id,Address_Type__c,is_Physical_and_Mailing_Address_Same__c FROM MUSW__Parcel__c where MUSW__Primary_Contact__r.name ='BasicGov Test Contact44'];
        List<MUSW__License2__c> lstlicense =[select id from MUSW__License2__c where Application_Type__c = 'Appraisers - Real Estate'];
        List<MUSW__License_Parcel__c> licenseParcelList = new List<MUSW__License_Parcel__c>();
        for(MUSW__Parcel__c parcelInstance : lstparcel) {
            MUSW__License_Parcel__c licenseParcelRecord = new MUSW__License_Parcel__c();
            licenseParcelRecord.MUSW__Parcel__c = parcelInstance.Id;
            licenseParcelRecord.MUSW__License2__c    = lstlicense[0].id;
            licenseParcelRecord.Status__c = 'Active';
            if(parcelInstance.Address_Type__c == DOL_AppConstants.CAP_MAILING_ADDRESS && !parcelInstance.is_Physical_and_Mailing_Address_Same__c){
                licenseParcelRecord.Mailing__c = true;
            }else if(parcelInstance.Address_Type__c == DOL_AppConstants.CAP_MAILING_ADDRESS && parcelInstance.is_Physical_and_Mailing_Address_Same__c){
                licenseParcelRecord.Mailing__c = true;
                licenseParcelRecord.Physical__c = true;
            }else{
                licenseParcelRecord.Physical__c = true;
            }
            licenseParcelList.add(licenseParcelRecord); 
        }
        insert licenseParcelList;
         system.assertEquals(4, licenseParcelList.size());
        
    }
      @isTest
    public static void testTriggerUpdate(){
        List<MUSW__License_Parcel__c> licenseParcelList =[select id,MUSW__Parcel__r.name,MUSW__Parcel__r.Address_Type__c,MUSW__Parcel__r.is_Physical_and_Mailing_Address_Same__c from MUSW__License_Parcel__c  where MUSW__Parcel__r.name in ('xyz123Unique1','xyz123Unique2','xyz123Unique3','xyz123Unique4')];
        for(MUSW__License_Parcel__c lstparcel2 : licenseParcelList) {
            if(lstparcel2.MUSW__Parcel__r.Address_Type__c == 'PHYSICAL ADDRESS' && lstparcel2.MUSW__Parcel__r.name  =='xyz123Unique1') {                
               lstparcel2.Mailing__c = true;
            }
        }
        update licenseParcelList;
        system.assertEquals(4, licenseParcelList.size());
        
    }
    @isTest
    public static void testTriggerDelete(){
        List<MUSW__License_Parcel__c> licenseParcelList =[select id,MUSW__Parcel__r.Address_Type__c,MUSW__Parcel__r.is_Physical_and_Mailing_Address_Same__c from MUSW__License_Parcel__c  where MUSW__Parcel__r.name in ('xyz123Unique1','xyz123Unique2','xyz123Unique3')];
        delete licenseParcelList;
        undelete licenseParcelList;
    }
}