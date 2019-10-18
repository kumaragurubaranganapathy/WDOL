@isTest
public class Polaris_DynamicSQL_Test {
  
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
        MUSW__License2__c lic2 = new MUSW__License2__c(MUSW__Status__c='Active',Name='System Number',Related_License__c= lic1.Id,Application_Type__c='Appraisers - Real Estate'
                                                      ,Credential_Type__c = 'Certified General Appraiser',Application_Method__c = 'General Application');
        insert lic2;
        MUSW__Submission__c sub  = New MUSW__Submission__c(Public_Distribution_URL__c='abc',MUSW__License2__c=lic1.id,Public_Disciplinary_Action__c=true);
        insert sub;
        MUSW__Parcel__c par = new MUSW__Parcel__c(Name= DOL_AppConstants.NULL_EMPTY_STRING + 'xyz123Unique1', Address_Type__c='PHYSICAL ADDRESS',MUSW__Primary_Contact__c= c.Id);
        insert par;

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
        MUSW__Parcel__c par4 = new MUSW__Parcel__c(Name= DOL_AppConstants.NULL_EMPTY_STRING + 'xyz123Unique4', Address_Type__c='PHYSICAL ADDRESS',MUSW__Primary_Contact__c= c.Id);
        insert par4;
        MUSW__License_Parcel__c licenseParcelRecord = new MUSW__License_Parcel__c();
        licenseParcelRecord.MUSW__Parcel__c = par4.Id;
        licenseParcelRecord.MUSW__License2__c    = lic2.id;
        licenseParcelRecord.Status__c = 'Active';
        if(par4.Address_Type__c == DOL_AppConstants.CAP_MAILING_ADDRESS && !par4.is_Physical_and_Mailing_Address_Same__c){
            licenseParcelRecord.Mailing__c = true;
        }else if(par4.Address_Type__c == DOL_AppConstants.CAP_MAILING_ADDRESS && par4.is_Physical_and_Mailing_Address_Same__c){
            licenseParcelRecord.Mailing__c = true;
            licenseParcelRecord.Physical__c = true;
        }else{
            licenseParcelRecord.Physical__c = true;
        }
        insert licenseParcelRecord;        
        Profile p = [SELECT Id FROM Profile WHERE Name='CPQ Integration User'];
        User u2 = new User(Alias = 'newUser', Email='newuser5676@testorg.com',
                           EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                           LocaleSidKey='en_US', ProfileId = p.Id,
                           TimeZoneSidKey='America/Los_Angeles', UserName='newuser5676@testorg.com');
        insert u2;
        
    }
    @isTest  
    private static void setDataForClass() {
        String objectName ='MUSW__License_Parcel__c';
        string field = 'MUSW__License2__r.License_Printable_Name__c,MUSW__License2__r.Name,MUSW__License2__r.Credential_Type__c,MUSW__License2__r.MUSW__Status__c,MUSW__License2__r.Sub_Status__c,MUSW__Parcel__r.MUSW__City__c,MUSW__License2__r.Related_License__c,MUSW__License2__r.RecordType.Name';
        String objectname2 ='License_Type__mdt';
        string field2 ='Credential_Type__c,IndividualBusinessType__c';
        List<String> lstFieldsName = field.split(',');
        List<String> lstFieldsName2 = field2.split(',');
        Map<String,String> mapCriteria = new Map<String,String>();
        mapCriteria.put('MUSW__License2__r.Credential_Type__c','Certified General Appraiser');
        Map<String,String> mapCriteriaOr = new Map<String,String>();
        mapCriteriaOr.put('MUSW__License2__r.RecordType.Name','Individual');
        Map<String,String> mapCriteriaOrCorrect = new Map<String,String>();
        mapCriteriaOrCorrect.put('1','MUSW__License2__r.RecordType.Name=Individual');
        Map<String,String> mapCriteria2 = new Map<String,String>();
        mapCriteria2.put('IndividualBusinessType__c','Individual');
        boolean bIsStatusIncluded =false;
        boolean showDeciplinary= true;
        Map<String,String> mapCriteriaLicesne = new Map<String,String>();
        mapCriteriaLicesne.put('Application_Type__c','Appraisers - Real Estate');
        string objectApi =  'MUSW__License2__c';
        string fieldsList = 'Name,Id';
        List<String> lstFieldsName3 = fieldsList.split(',');
        Map<String,String> mapCriteriaOror = new Map<String,String>();
        mapCriteriaOror.put('Delivery_Method__c','Individual');
        mapCriteriaOror.put('Credential_Type__c','Appraisers - Real Estate');
        Polaris_DynamicSQL pds = new Polaris_DynamicSQL();
        Polaris_DynamicSQL.generateQuery(objectname2, lstFieldsName2, mapCriteria2);
        Polaris_DynamicSQL.generateQueryLimit(objectApi, lstFieldsName3, mapCriteriaOror,50);
        Polaris_DynamicSQL.generateQueryWithGenericOR(objectName,lstFieldsName,mapCriteria,mapCriteriaOrCorrect,bIsStatusIncluded,showDeciplinary); 
       // Polaris_DynamicSQL.generateQueryWithGenericOR(objectApi,lstFieldsName,mapCriteriaLicesne,mapCriteriaOrCorrect,bIsStatusIncluded,showDeciplinary); 
        Polaris_DynamicSQL.generateQueryWithGenericOR(objectName,lstFieldsName,mapCriteria,mapCriteriaOrCorrect,true,showDeciplinary); 
        Polaris_DynamicSQL.generateQueryWithOR(objectName,lstFieldsName,mapCriteria,true,showDeciplinary); 
         Polaris_DynamicSQL.generateQueryWithOR(objectName,lstFieldsName,mapCriteria,false,showDeciplinary);
        //Polaris_DynamicSQL.generateQueryWithORDetails(objectname2, lstFieldsName2, mapCriteria2,false,showDeciplinary);    
        try{
           Polaris_DynamicSQL.generateQueryLimit(objectName,lstFieldsName,mapCriteria,50);  
        }   catch(Exception ex) {
            
        }
        try{
         Polaris_DynamicSQL.generateQuery(objectName, lstFieldsName, mapCriteria);   
        }   catch(Exception ex) {
            
        }
        try{
          Polaris_DynamicSQL.generateQueryWithGenericOR(objectName,lstFieldsName,mapCriteria,mapCriteriaOr,bIsStatusIncluded,showDeciplinary);  
        }   catch(Exception ex) {
            
        }    
        try{
            Polaris_DynamicSQL.generateQueryWithOR(objectName,lstFieldsName2,mapCriteria,false,showDeciplinary); 
        }   catch(Exception ex) {
            
        } 
        
        
    }
    @isTest
    public static void testgenerateQueryWithORparent(){
       List<MUSW__License2__c> lstlicense =[select id from MUSW__License2__c where Application_Type__c = 'Appraisers - Real Estate' and Related_License__c != null];
        String value = String.valueof(lstlicense[0].id);
        String objectName ='MUSW__License_Parcel__c';
        String fields = 'MUSW__License2__c,MUSW__License2__r.Related_License__r.MUSW__Applicant__r.Full_Name__c,MUSW__License2__r.Related_License__r.Name, MUSW__License2__r.Related_License__r.Credential_Type__c,MUSW__License2__r.Related_License__r.MUSW__Status__c';
        List<String> lstFieldsName = fields.split(',');
        Map<String,String> mapCriteria = new Map<String,String>();
        mapCriteria.put('MUSW__License2__c',value);
        Polaris_DynamicSQL.generateQueryWithORparent(objectName,lstFieldsName,mapCriteria,false);
        Polaris_DynamicSQL.generateQueryWithORparent(objectName,lstFieldsName,mapCriteria,true);
       ///Polaris_DynamicSQL.generateQueryWithORDetails(objectName,lstFieldsName,mapCriteria,true,true);
    }
        @isTest
    public static void testgenerateQueryWithORparentNegative(){
       List<MUSW__License2__c> lstlicense =[select id from MUSW__License2__c where Application_Type__c = 'Appraisers - Real Estate' and Related_License__c = null];
        String value = String.valueof(lstlicense[0].id);
        String objectName ='MUSW__License_Parcel__c';
        String fields = 'MUSW__License2__c,MUSW__License2__r.Related_License__r.MUSW__Applicant__r.Full_Name__c,MUSW__License2__r.Related_License__r.Name, MUSW__License2__r.Related_License__r.Credential_Type__c,MUSW__License2__r.Related_License__r.MUSW__Status__c';
        List<String> lstFieldsName = fields.split(',');
        Map<String,String> mapCriteria = new Map<String,String>();
        mapCriteria.put('MUSW__License2__c',value);
        try{
             Polaris_DynamicSQL.generateQueryWithORparent(objectName,lstFieldsName,mapCriteria,false);
        }
        catch(Exception ex) {
            
        }
    }
    
        @isTest
    public static void testfetchMetaDataValues(){
        Map<String,List<String>> testRes = Polaris_DynamicSQL.fetchMetaDataValues();
        MUSW__License2__c obj = new MUSW__License2__c(); 
        Account obj2 = new Account();
        Polaris_DynamicSQL.MapgetPicklistFieldValues('MUSW__License2__c','Application_Type__c');
        Polaris_DynamicSQL.getPicklistFieldValues('MUSW__License2__c','Application_Type__c');
        Polaris_DynamicSQL.getPicklistOptions(obj,'Application_Type__c','Credential_Type__c');  
        try {
          Polaris_DynamicSQL.getPicklistFieldValues('MUSW__License2__c','cvb');  
        } catch(Exception ex) {
            
        }
        try {
            Polaris_DynamicSQL.MapgetPicklistFieldValues('MUSW__License2__c','');  
        } catch(Exception ex) {
            
        }
        try {
            Polaris_DynamicSQL.getPicklistOptions(obj2,'Application_Type__c','');  
        } catch(Exception ex) {
            
        }
        try {
            Polaris_DynamicSQL ibj = new Polaris_DynamicSQL();
            ibj.operator = '=0';
            List<Polaris_DynamicSQL> lstobj= new List<Polaris_DynamicSQL>();
            lstobj.add(ibj);
            Polaris_DynamicSQL.generateWhereQuery(lstobj);  
        } catch(Exception ex) {
            
        }
    }
    
     @isTest
    public static void testaddComplaint(){
       User u3 = [SELECT Id FROM User WHERE UserName='newuser5676@testorg.com'];
       String ida= Polaris_DynamicSQL.addComplaint();
        String abc = '{"selectedProfession":"Appraisers - Real Estate","professionalData":{"firstName":"Robert","lastName":"Smith","licenseNumber":"","email":"","phone":"","address":"","city":"","state":"Washington","county":""},"businessData":{"businessName":"test","doingBusinessAs":"","licenseNumber":"","email":"robinsmith5555@mailinator.com","phone":"","address":"Goudiya Matam Street","city":"Kovvur","state":"Washington","county":""},"information":{"firstName":"Robert","lastName":"Smith","businessName":"","email":"robinsmith5555@mailinator.com","phone":"","address":"Goudiya Matam Street","city":"Kovvur","state":"Washington","zipcode":"53435"},"complaintSummary":"test description","agreeCheck":true,"anonymous":true}';
        Polaris_DynamicSQL.saveComplaint(abc,ida);
        try {
             Polaris_DynamicSQL.saveComplaint(abc,'ggg');
        } catch(Exception ex) {
            
        }
    }
         @isTest
    public static void testwrapperClass(){
        Polaris_DynamicSQL.professionalDataClass test = new Polaris_DynamicSQL.professionalDataClass();
        test.address='abc';
        test.city='abc';
        test.county='cde';
        test.email='cde';
        test.firstName ='ede';
        test.lastName='etet';
        test.licenseNumber='ahd';
        test.licenseStatus='ff';
        test.phone='56546';
        
        Polaris_DynamicSQL.informationClass infotest = new Polaris_DynamicSQL.informationClass();
        infotest.address='abc';
        infotest.city='abc';
        infotest.state='cde';
        infotest.firstName ='ede';
        infotest.lastName='etet';
        infotest.email='etet';
        infotest.zipcode='ff';
        infotest.phone='56546';
        infotest.middleName='56546';
        
        Polaris_DynamicSQL.businessDataClass busintest = new Polaris_DynamicSQL.businessDataClass();
        busintest.address='abc';
        busintest.businessName='abc';
        busintest.county='cde';
        busintest.doingBusinessAs ='ede';
        busintest.email='etet';
        busintest.licenseStatus='ff';
        busintest.phone='56546';

    }
}