/**
    * User Story: 135 - Mailing Address on Portal
    * Class Name: AddressJSUtility_CC
    * Test Class Name: AddressJSUtility_CC_Test
    * Description: This class serves as backend controller for AddressJSUtility component. It contains all utility methods and 
    *                    Geo Webservice calls. Address component is generic component and can be used for various pages. It is capable to 
    *                    create US Address, Military Address and International Address.
    * Date:        Developer/Company                    Description
    * ---------------------------------------------------------------------------------------------------------------------------------------- *
    * 07/16/2018   Sharad Maheshwari/Deloitte           Initial Creation
    **/
    public class AddressJSUtility_CC 
    {
        public class EditRMInput
        {
            public string accountId {get;set;}
            public string contactId {get;set;}
            public string licenseId {get;set;}
            public string permitId {get;set;}
            
            public string primaryEntityType {get;set;}
            public boolean isLPJobRemaining {get;set;}
            public boolean isPPJobRemaining {get;set;}
            public string contextParcelId {get;set;}
            public string contextAddressType {get;set;}
        }
        
        public class LicenseBusinessAddressResult 
        {
            public boolean isSuccess {get;set;}
            public String message {get;set;}
            public String accountId {get;set;}
            public String contactId {get;set;}
            
            public GlobalAddressConfig  addressConfig {get;set;}
            
            public List<ParcelRecord> parcelRecords {get;set;}
            public List<MUSW__License_Parcel__c> licenseParcels {get;set;}
            public LicenseBusinessAddressResult()
            {
                parcelRecords = new List<ParcelRecord>();
                licenseParcels = new List<MUSW__License_Parcel__c>();
            }
        }
        
        public class PermitBusinessAddressResult 
        {
            public boolean isSuccess {get;set;}
            public String message {get;set;}
            public String accountId {get;set;}
            public String contactId {get;set;}
            
            public GlobalAddressConfig  addressConfig {get;set;}
            
            public List<ParcelRecord> parcelRecords {get;set;}
            public List<MUSW__Permit_Parcel__c> permitParcels {get;set;}
            public PermitBusinessAddressResult()
            {
                parcelRecords = new List<ParcelRecord>();
                permitParcels = new List<MUSW__Permit_Parcel__c>();
            }
        }
        
        public class BusinessAddressRMIn
        {
            public String accountId {get;set;}
            public String contactId {get;set;}
            public String PrimaryEntityType {get;set;}
            public String parcelId {get;set;}
            public String accountParcelJunctionId {get;set;}
            public String contactParcelJunctionId {get;set;}
            public String licenseParcelJunctionId {get;set;} 
            public String permitParcelJunctionId {get;set;}
            public String contextLicenseId {get;set;}
            public String contextPermitId {get;set;}
            
        }
        
        
        public class BusinessAddressDBOpResult
        {
            public boolean isSuccess {get;set;}
            public string message {get;set;}
            
            public BusinessAddressRMIn rmParam {get;set;}
            
            public List<ParcelRecord> parcelRecords {get;set;}
            public List<MUSW__License_Parcel__c> licenseParcels {get;set;}
            public List<MUSW__Permit_Parcel__c> permitParcels {get;set;}
            
            public BusinessAddressDBOpResult()
            {
                parcelRecords = new List<ParcelRecord>();
                licenseParcels = new List<MUSW__License_Parcel__c>();
                permitParcels = new List<MUSW__Permit_Parcel__c>();
                rmParam = new BusinessAddressRMIn() ;
            }
            
        }
        
        public class ParcelRecord
        {
            public MUSW__Parcel__c parcel {get;set;}
            public Parcel_Account__c parcelAccount {get;set;}
            public MUSW__Parcel_Contact2__c parcelContact {get;set;}
            public ParcelRecord(Parcel_Account__c parcelAccountIn , MUSW__Parcel_Contact2__c parcelContactIn)
            {
                parcelAccount = parcelAccountIn ;
                parcelContact = parcelContactIn ;
            }
            
            public void setParcel(MUSW__Parcel__c parcelin)
            {
                 parcel =  parcelIn ;
            }
        }
        
        public class BusinessAddressResult 
        {
            public boolean isSuccess {get;set;}
            public String message {get;set;}
            public List<Id> accountIds {get;set;}
            public List<Id> contactIds {get;set;}
            public Map<Id,List<ParcelRecord>> dataMap {get;set;}
        }
        
        public class RMBusinessAddressResult
        {
            public boolean isSuccess {get;set;}
            public String message {get;set;}
            public MUSW__Parcel__c addressRecord {get;set;}
            //Todo
            public List<GeoResult> geoAddresses {get;set;}
            public Boolean isMatchingAddressFound {get;set;}
            public RawAddress inputRawAddress {get;set;}
            //Todo
            //public GeoResult inputGeoResult {get;set;}
            public RMBusinessAddressResult()
            {
                //Todo
                geoAddresses = new List<GeoResult>();
                inputRawAddress = new RawAddress();
                //Todo
                //inputGeoResult = new GeoResult() ;
            }
        }
        
        public class GeoCodeCombo 
        {
            public List<GeoResult> geoResults {get;set;}
            public GeoResult matchingAddress {get;set;}
            public GeoCodeCombo(GeoResult matchingRes , List<GeoResult> geoResultsIn)
            {
                geoResults = new List<GeoResult>() ;
                geoResults.addAll(geoResultsIn) ;
                matchingAddress =   matchingRes ;
            }
        }
        
        /*
         * Inner class definations to represent configurations  
         * It contains all address records associated with profile 
         * and some other configurable items like dropdown options
         */

        public class GlobalAddressConfig
        {
            public List<string> addressTypeOptions {get;set;}
            public List<string> milCityOptions {get;set;}
            public List<string> milStateOptions {get;set;}
            public List<string> stateList {get;set;}
            public List<string> intCntrList {get;set;}
            public List<string> countyList {get;set;}

            /*
             *  Inner class constructor
             */ 

            public GlobalAddressConfig()
            {
                milStateOptions = new List<string>{'AA','AE','AP'};
                milCityOptions  = new List<string>{'APO','FPO','DPO'};
                addressTypeOptions = new List<string>{label.Str_US_Address, label.Str_Military_Address, label.Str_International_Address};
                intCntrList = new List<string>();
                
                for(Schema.PicklistEntry f : MUSW__Parcel__c.Country__c.getDescribe().getPicklistValues())
                {
                    if(f.getLabel() != label.Str_United_States) 
                        intCntrList.add(f.getLabel());
                }
                stateList = new List<string>();
                for(Schema.PicklistEntry f : MUSW__Parcel__c.MUSW__State__c.getDescribe().getPicklistValues())
                {
                    stateList.add(f.getLabel());
                }
                countyList = new List<string>();
                for(Schema.PicklistEntry f : MUSW__Parcel__c.County__c.getDescribe().getPicklistValues())
                {
                    if(f.getLabel() != label.Str_Out_Of_State)
                    {
                        countyList.add(f.getLabel());
                    }   
                }
            }
        }

            
        /*
         * Inner class to represent raw address component
         */ 
        public class RawAddress
        {
            //public String contextProfileId  {get;set;}
            public string addressType {get;set;}
            public string addressName {get;set;}
            public boolean militaryFlag {get;set;}
            public string addressCountry {get;set;}
            public string addressLine1 {get;set;}
            public string addressLine2 {get;set;}
            public string city {get;set;}
            public string state {get;set;}
            public string zipCode  {get;set;}
            public string addressCounty {get;set;}
            public string IntAddress {get;set;}
            public string parcelId {get;set;}
            public string junctionId {get;set;}
            public Double latitude {get; set;}
            public Double longitude {get; set;}
            public String accountParcelJunctionId{get;set;}
            
            
            
            public String businessAddressType {get;set;}
            public String BusinessAccountId {get;set;}
            public Boolean EnableAutoLinkingWithAccount {get;set;}
            
            public Boolean EnableAutoLinkingWithContact {get;set;}
            public String BusinessContactId {get;set;}
            
            public Boolean saveAsaAddressOnEntityFlag {get;set;}
             
            /*
             * Default constructor 
             */ 
            public RawAddress(){}
        }
        
        /* 
         * Inner class to represent outcome of Geo webservice 
         */ 
        
        public class GeoResult
        {
            public Integer index {get; set;}
            public String addressLine1 {get; set;}
            public String addressLine2 {get; set;}
            public String city {get; set;}
            public String state {get; set;}
            public String zipCode {get; set;}
            public String matchCode {get; set;}
            public String locationQualityCode {get; set;}
            public Integer locationConfidenceCode {get; set;}
            public Double latitude {get; set;}
            public Double longitude {get; set;}
            public boolean validated {get; set;}
            public boolean bMatchingAddress {get;set;}
            public string sfdcID {get;set;}

            public string addressName {get;set;}
            public string addressCountry {get;set;}
            public string addressCounty {get;set;}
            public boolean militaryAddress{get;set;}
            
            //Field specific to Account handling 
            public String businessAddressType {get;set;}
            public String BusinessAccountId {get;set;}
            
            public Boolean EnableAutoLinkingWithAccount {get;set;}

            public Boolean EnableAutoLinkingWithContact {get;set;}
            public String BusinessContactId {get;set;}
            
            public Boolean saveAsaAddressOnEntityFlag {get;set;}
           
            /*
             * Default constructor
             */
            public GeoResult()
            {}
            
            
            public GeoResult(Integer indexIn,
                             string AddressLine1In,
                             string AddressLine2In,
                             string cityIn, 
                             string stateIn , 
                             string zipcodeIn, 
                             string matchCodeIn,
                             string locationQualityCodeIn , 
                             Integer locationConfidenceCodeIn , 
                             Double latitudeIn , 
                             Double longitudeIn,
                             String addressCountyIn,
                             Boolean validatedIn,
                             RawAddress rAddress )
            {
                this.index = indexIn ;
                this.AddressLine1 = AddressLine1In ;
                this.AddressLine2=AddressLine2In;
                this.City = cityIn ;
                this.state = stateIn ;
                this.zipCode = zipcodeIn ;
                this.matchCode = matchCodeIn ;
                this.locationQualityCode = locationQualityCodeIn ;
                this.locationConfidenceCode = locationConfidenceCodeIn ;
                this.latitude = latitudeIn  ;
                this.longitude = longitudeIn ;
                this.validated = validatedIn;
                this.addressCounty  = addressCountyIn ;
                this.bMatchingAddress = false ;
                this.sfdcId = null ;
                
                if(this.validated)
                {
                    this.addressCountry = label.Str_United_States ; 
                }
                

                this.addressName = rAddress.addressName ;
                this.businessAddressType =  rAddress.businessAddressType  ;
                this.BusinessAccountId = rAddress.BusinessAccountId ;
                this.EnableAutoLinkingWithAccount = rAddress.EnableAutoLinkingWithAccount ;
                
                this.BusinessContactId = rAddress.BusinessContactId ;
                this.EnableAutoLinkingWithContact = rAddress.EnableAutoLinkingWithContact ;
                
                this.saveAsaAddressOnEntityFlag = rAddress.saveAsaAddressOnEntityFlag ;
            }
            
            /*
             *  Parameterized costructor 
             * @param   RawAddress      RawAddress object , It will convert RawAddress to GeoResult 
             * @see     GeoResult
             * @see     RawAddress
             */ 
            
            public GeoResult( RawAddress rAddress)
            {
                 if(rAddress.AddressLine1 != null 
                && rAddress.AddressLine1 != '' 
                && rAddress.AddressLine2 != null 
                && rAddress.AddressLine2 != '' )
                {
                    this.AddressLine1 = rAddress.AddressLine1  + ' ' +  rAddress.AddressLine2 ;
                }else
                {
                    this.AddressLine1 = rAddress.AddressLine1 ;
                }

                this.City = rAddress.city ;
                this.state = rAddress.state ;
                this.zipCode = rAddress.zipCode  ;
                this.validated = false;
                this.sfdcId = rAddress.parcelId ;
                this.latitude = rAddress.latitude;
                this.longitude = rAddress.longitude;
                
                this.addressCounty = rAddress.addressCounty ;
                this.addressCountry = rAddress.addressCountry ;
                
                // Business address specific mapping 
                this.businessAddressType =  rAddress.businessAddressType  ;
                this.BusinessAccountId = rAddress.BusinessAccountId ;
                this.EnableAutoLinkingWithAccount = rAddress.EnableAutoLinkingWithAccount ;
                this.addressName = rAddress.addressName ;
                
                
                this.EnableAutoLinkingWithContact = rAddress.EnableAutoLinkingWithContact ;
                this.BusinessContactId = rAddress.BusinessContactId ;
                
                this.saveAsaAddressOnEntityFlag = rAddress.saveAsaAddressOnEntityFlag ;
            }
            
        }
        
       
       
        // Business Address start here 
        ///////////////////////////
        // Save selected GeoAddres
        
        @RemoteAction
        public static RMBusinessAddressResult saveSelectedGeoCodedAddress(GeoResult gr )
        {
            RMBusinessAddressResult retRes = new RMBusinessAddressResult();
            try{
                //Todo
                //retRes.inputGeoResult  = gr ;
                MUSW__Parcel__c parcel = new MUSW__Parcel__c(); 
                parcel = geoToParcelMapping(gr,parcel) ;
                
                if(parcel.MUSW__Primary_Contact__c == null )
                {
                    parcel.MUSW__Primary_Contact__c = [Select Id , ContactId from User Where ID =: UserInfo.getUserId() limit 1].ContactId ;
                }

                UPSERT parcel ;
                
                if(gr.EnableAutoLinkingWithAccount != null &&  gr.EnableAutoLinkingWithAccount == true )
                {
                    performAccountParcelHandling(gr.BusinessAccountId , gr.businessAddressType ,parcel);
                }
                
                if(gr.EnableAutoLinkingWithContact != null &&  gr.EnableAutoLinkingWithContact == true )
                {
                    performContactParcelHandling(gr.BusinessContactId , gr.businessAddressType ,parcel , gr.saveAsaAddressOnEntityFlag );
                }
                
                retRes.isSuccess = true ;
                retRes.message = label.Str_Operation_completed_successfully ;
                retRes.addressRecord = parcel ;
                retRes.isMatchingAddressFound = true ;
            }catch(DmlException ex)
            {
                if(ex.getMessage().contains('STRING_TOO_LONG')||  ex.getMessage().contains('data value too large'))
                {
                 retRes.message = 'length of address too long';
                retRes.isSuccess = false ;
                }
                else{
                retRes.message = toString(ex);
                retRes.isSuccess = false ;
                }
            }
            catch(exception ex)
            { 
                ErrorLogger.logGeneralException(ex, UserInfo.getUserId(), 'AddressJS_Utility_CC', null, 'saveSelectedGeoCodedAddress', 'AddressJS_Utility_CC', label.str_HIGH);
                retRes.message = toString(ex);
                retRes.isSuccess = false ;
            }
                
            return retRes ;
        }
        
         
        @RemoteAction
        public static RMBusinessAddressResult saveBusinessAddress(RawAddress rawAddr)
        {
            RMBusinessAddressResult retRes = new RMBusinessAddressResult();
           retRes.inputRawAddress = rawAddr ;       
           boolean bSaveParcelToDb = false;
            try
            {
                MUSW__Parcel__c parcel = new MUSW__Parcel__c();
                parcel.Comments__c = rawAddr.addressName ;
                parcel.Status__c = label.ST_Active ;
                //Todo
                parcel.Is_This_A_Military_Address__c = false ;

                if(rawAddr.parcelId instanceof ID)
                {
                    parcel.Id = rawAddr.parcelId ;
                }
                parcel.MUSW__Latitude__c = rawAddr.latitude;
                parcel.MUSW__Longitude__c = rawAddr.longitude;
                 
                if(rawAddr.addressType == label.Str_Military_Address)
                {
                    parcel.Validated__c = false;
                    parcel.Is_This_A_Military_Address__c =rawAddr.militaryFlag ;
                    parcel.MUSW__City__c = rawAddr.city.unescapeHtml4();
                    parcel.MUSW__State__c = rawAddr.state;
                    parcel.MUSW__Post_Zip_Code__c = rawAddr.zipCode;
                    if(rawAddr.AddressLine2 != null )
                    {
                        parcel.MUSW__Street2__c = rawAddr.AddressLine1.unescapeHtml4() + ' ' + rawAddr.AddressLine2.unescapeHtml4() ;
                    }else
                    {
                        parcel.MUSW__Street2__c = rawAddr.AddressLine1.unescapeHtml4() ;
                    }
                    
                    parcel.Country__c =rawAddr.addressCountry ; 
                    bSaveParcelToDb = true ; 
                    
                    // NULLIFY NON MILITARY FIELDS
                    parcel.International_Address__c = null ;
                    parcel.County__c = null ;
                    
                }else if(rawAddr.addressType == label.Str_International_Address)
                {
                    parcel.International_Address__c = rawAddr.intAddress.unescapeHtml4() ;
                    parcel.Country__c =rawAddr.addressCountry.unescapeHtml4() ;
                    bSaveParcelToDb = true ;
                    
                    // NULLIFY NON INTERNATIONAL FIELDs
                    parcel.MUSW__City__c = null;
                    parcel.MUSW__State__c = null;
                    parcel.MUSW__Post_Zip_Code__c = null;
                    parcel.Is_This_A_Military_Address__c = false ;
                    parcel.MUSW__Street2__c = null ;
                    parcel.County__c = null ;
                    
                }else if(rawAddr.addressType == label.Str_US_Address)
                {   //ToDo
                    
                    GeoCodeCombo geocodeCompoRes =   prepareGeoCodedBusinessAddress(rawAddr) ;
                    if(geocodeCompoRes.matchingAddress != null )
                    {
                        parcel = geoToParcelMapping(geocodeCompoRes.matchingAddress,parcel) ;
                        bSaveParcelToDb = true ;
                        retRes.isMatchingAddressFound = true ;
                        retRes.geoAddresses.addAll(geocodeCompoRes.geoResults);
                    }else
                    {
                        retRes.geoAddresses.addAll(geocodeCompoRes.geoResults);
                        retRes.isMatchingAddressFound = false ;
                        bSaveParcelToDb = false ;
                    }
                    
                    //added temporarily by Sharad
                    /*parcel.MUSW__City__c = rawAddr.city.unescapeHtml4();
                    parcel.MUSW__State__c = rawAddr.state;
                    parcel.MUSW__Post_Zip_Code__c = rawAddr.zipCode;
                    parcel.Country__c =rawAddr.addressCountry.unescapeHtml4() ;
                     if(rawAddr.AddressLine2 != null )
                    {
                        parcel.MUSW__Street2__c = rawAddr.AddressLine1.unescapeHtml4() + ' ' + rawAddr.AddressLine2.unescapeHtml4() ;
                    }else
                    {
                        parcel.MUSW__Street2__c = rawAddr.AddressLine1.unescapeHtml4() ;
                    }
                    bSaveParcelToDb = true;*/
                }
                
                if(bSaveParcelToDb)
                {               
                    //If Primary contact is not set , then set current logged in users contact id 
                    if(parcel.MUSW__Primary_Contact__c == null )
                    {
                        parcel.MUSW__Primary_Contact__c = [Select Id , ContactId from User Where ID =: UserInfo.getUserId() limit 1].ContactId ;
                    }
                    System.debug('after upsert-value inserted in parcel');
                    UPSERT parcel ;
                    //String name = [Select id from musw__parcel__c where MUSW__State__c= 'CA'].id;
                    System.debug('after upsert-value inserted in parcel');
                    /*Commented as the same code was being called again from saveSelectedGeoCodedAddress which was leading to duplicate entry
                    into parcel_account and parcel_contact*/
                    /* Updated the code to call the below methods for International and Military addresses */
                    if(rawAddr.addressType == label.Str_International_Address || rawAddr.addressType == label.Str_Military_Address || rawAddr.addressType == label.Str_US_Address){
                        if(rawAddr.EnableAutoLinkingWithAccount != null &&  rawAddr.EnableAutoLinkingWithAccount == true )
                        {
                            performAccountParcelHandling(rawAddr.BusinessAccountId , rawAddr.businessAddressType ,parcel);
                        }
                        
                        if(rawAddr.EnableAutoLinkingWithContact != null &&  rawAddr.EnableAutoLinkingWithContact == true )
                        {
                            performContactParcelHandling(rawAddr.BusinessContactId , rawAddr.businessAddressType ,parcel , rawAddr.saveAsaAddressOnEntityFlag );
                        }
                    }
                    
                                    
                    retRes.isMatchingAddressFound = true ;
                }else
                {
                    parcel = null ;
                }
                
                retRes.isSuccess = true ;
                retRes.addressRecord = parcel ;
                retRes.message = label.Str_Operation_completed_successfully ;
            }catch(exception ex){
                ErrorLogger.logGeneralException(ex, UserInfo.getUserId(), 'AddressJSUtility_CC', null, 'saveBusinessAddress', 'AddressJSUtility_CC', label.str_HIGH);
                retRes.isSuccess = false ;
                retRes.message = toString(ex);
            }
            return retRes ;
        }
        
        private static void performAccountParcelHandling(String BusinessAccountId , String businessAddressType , MUSW__Parcel__c parcel)
        {
            if(BusinessAccountId != null && BusinessAccountId instanceof ID )
            {
                if(businessAddressType != null && businessAddressType != '' )
                {
                    if(businessAddressType == label.Str_Mailing)
                    {
                        List<Parcel_Account__c> acParcels = [Select ID ,Parcel__c , Account__c , Physical__c , Mailing__c , Primary__c , Public__c from Parcel_Account__c Where Account__c = : BusinessAccountId AND Parcel__c =: parcel.Id  AND Mailing__c = true ] ;
                        if(acParcels != null && acParcels.isEmpty() == true )
                        {
                            Parcel_Account__c pJun = new Parcel_Account__c( Account__c = BusinessAccountId , Parcel__c = parcel.Id, Mailing__c = true);
                            INSERT pJun ;   
                        }
                    }else if (businessAddressType == label.Str_Public)
                    {
                        List<Parcel_Account__c> acParcels = [Select ID ,Parcel__c , Account__c , Physical__c , Mailing__c , Primary__c , Public__c from Parcel_Account__c Where Account__c = : BusinessAccountId AND Parcel__c =: parcel.Id  AND Public__c = true ] ;
                        if(acParcels != null && acParcels.isEmpty() == true )
                        {
                            Parcel_Account__c pJun = new Parcel_Account__c( Account__c = BusinessAccountId , Parcel__c = parcel.Id, Public__c = true);
                            INSERT pJun ;   
                        }
                    }else if(businessAddressType == label.Str_Physical)
                    {   System.debug('inside::businessAddressType::' + businessAddressType );
                        List<Parcel_Account__c> acParcels = [Select ID ,Parcel__c , Account__c , Physical__c , Mailing__c , Primary__c , Public__c from Parcel_Account__c Where Account__c = : BusinessAccountId AND Parcel__c =: parcel.Id  AND Physical__c = true ] ;
                        if(acParcels != null && acParcels.isEmpty() == true )
                        {
                            Parcel_Account__c pJun = new Parcel_Account__c( Account__c = BusinessAccountId , Parcel__c = parcel.Id, Physical__c = true);
                            INSERT pJun ;   
                        }
                    }else if(businessAddressType == label.Str_Primary)
                    {
                        List<Parcel_Account__c> acParcels = [Select ID ,Parcel__c , Account__c , Physical__c , Mailing__c , Primary__c , Public__c from Parcel_Account__c Where Account__c = : BusinessAccountId AND Parcel__c =: parcel.Id  AND Primary__c = true ] ;
                        if(acParcels != null && acParcels.isEmpty() == true )
                        {
                            Parcel_Account__c pJun = new Parcel_Account__c( Account__c = BusinessAccountId , Parcel__c = parcel.Id,Primary__c = true);
                            INSERT pJun ;   
                        }
                    }
                }
            }
        }
        
        public static MUSW__Parcel__c geoToParcelMapping(GeoResult gr , MUSW__Parcel__c addressRecord)
        {
            
            addressRecord.Status__c = label.ST_Active ;
            addressRecord.MUSW__Street2__c = gr.AddressLine1.unescapeHtml4();
            addressRecord.MUSW__City__c = gr.City;
            addressRecord.MUSW__State__c = gr.state;
            addressRecord.MUSW__Post_Zip_Code__c = gr.zipCode;
            addressRecord.Validated__c = gr.validated;
            //Mapping common fields 
            addressRecord.Comments__c = gr.addressName ;
            addressRecord.Country__c  = gr.addressCountry ;
            if(addressRecord.MUSW__State__c == 'WI') addressRecord.County__c = gr.addressCounty ;
            addressRecord.MUSW__Latitude__c = gr.latitude;
            addressRecord.MUSW__Longitude__c = gr.longitude;
            //Todo
            /*addressRecord.Match_Code__c = (gr.matchCode != null)? gr.matchCode : '';
            addressRecord.Location_Quality_Code__c = (gr.locationQualityCode != null) ? gr.locationQualityCode : '';
            addressRecord.Location_Confidence_Code__c = (gr.locationConfidenceCode != null) ? String.valueOf(gr.locationConfidenceCode) : '';
            */
            // NULLIFY NON US ADDRESS FIELDS 
            addressRecord.Is_This_A_Military_Address__c = false ;
            addressRecord.International_Address__c = null ; 
            
            if(gr.sfdcID instanceof ID)
            {
                addressRecord.Id = gr.sfdcID ;
            }
            
            return addressRecord ;
        }
        
        public Static GeoCodeCombo prepareGeoCodedBusinessAddress(RawAddress rAddress)  
        {
            transient Map<integer,GeoResult> masterAddressMap = getBusiessAddressesFromService(rAddress,  new Map<integer,GeoResult>()) ;
            GeoResult exactMatchingAddress = null;
                
            transient string fullAddressLine = '' ;
            if(rAddress.addressLine1 != null && rAddress.addressLine1 != '' && rAddress.addressLine2 != null && rAddress.addressLine2 != '' )
            {
                fullAddressLine = rAddress.addressLine1 + ' ' + rAddress.addressLine2  ; 
            }else
            {
                fullAddressLine = rAddress.addressLine1 ;
            }
            
            transient Boolean bMatchingAddressFound = false ; 
            transient integer iLastKey =0 ;
            for(integer iKey : masterAddressMap.keySet())
            {
                iLastKey = iKey ;
                GeoResult gResult = masterAddressMap.get(iKey);
                transient boolean bMatchingCounty =   (rAddress.addressCounty != null  ? ( rAddress.addressCounty  == gResult.addressCounty  ) : true ) ; 
                
                if(gResult.AddressLine1 ==  fullAddressLine
                   && gResult.City == rAddress.city
                   && gResult.state == rAddress.state
                   && gResult.zipCode == rAddress.zipCode
                   && bMatchingCounty   
                    )
                {
                    bMatchingAddressFound = true ;
                    gResult.sfdcID = rAddress.parcelId ;
                    exactMatchingAddress = gResult ;
                    break;
                }
            }    
            
            if(!bMatchingAddressFound)
            {
                integer newKey = iLastKey + 1 ;
                masterAddressMap.put(newKey , new GeoResult(rAddress ));
            }     
            return new GeoCodeCombo(exactMatchingAddress, masterAddressMap.values() ) ;
        }
        
        public static string toString(exception e)
        {
            return ' Exception type caught: ' + e.getTypeName() + '   Message: ' + e.getMessage() + '         Cause: ' + e.getCause()     + '     Line number: ' + e.getLineNumber() + '      Stack trace: ' + e.getStackTraceString();
        }
        
        
        @RemoteAction
        public static GlobalAddressConfig getPartialConfigurationsOnLoad()
        {
            return new GlobalAddressConfig();
        }
        
        
        private static Map<integer,GeoResult> getBusiessAddressesFromService(RawAddress rAddress  , Map<integer,GeoResult> masterAddressMap )
        {
            /*try{
                // Instantiate a new http object
                Http h = new Http();
                String url = '';
                
                transient Boolean org = [Select Id, isSandbox From Organization][0].isSandbox;
                if(org == true){
                    url = 'callout:Wisconsin_Endpoint_Test/address/v1/validate';
                }else{
                    url = 'callout:Wisconsin_Endpoint_Prod/address/v1/validate';
                }
                
                 // Instantiate a new HTTP request, specify the method (PUT) as well as the endpoint
                HttpRequest req = new HttpRequest();
                req.setEndpoint(url);
                req.setMethod('PUT');
                req.setHeader('Content-Type', 'application/json');
                
                JSONGenerator gen = JSON.createGenerator(true);
                gen.writeStartObject();
                gen.writeStringField('AddressLine1', rAddress.addressLine1);
                gen.writeStringField('AddressLine2', rAddress.addressLine2);
                gen.writeStringField('City', rAddress.city);
                gen.writeStringField('State', rAddress.state);
                gen.writeStringField('PostalCode', rAddress.zipCode);
                gen.writeStringField('CountryName', 'US');
                gen.writeEndObject();
                
                String reqBody = gen.getAsString();
                system.debug(reqBody);
                req.setBody(reqBody);
                
                // Send the request, and return a response
                HttpResponse res = h.send(req);
                system.debug('response received: '+res);
                system.debug('response body: '+res.getBody());
            
                GeoResult result = new GeoResult();
                result.index = 0;
                result.validated = true;
                
                JSONParser parser = JSON.createParser(res.getBody());
                while (parser.nextToken() != null) {
                    if (parser.getCurrentToken() == JSONToken.FIELD_NAME){
                        String fieldName = parser.getText();
                        parser.nextToken();
                        String fieldValue = parser.getText();
                        
                        if(fieldName == 'AddressLine1'){
                            result.addressLine1 = fieldValue;
                        }else if(fieldName == 'AddressLine2'){
                            result.addressLine2 = fieldValue;
                        }else if(fieldName == 'City'){
                            result.city = fieldValue;
                        }else if(fieldName == 'State'){
                            result.state = fieldValue;
                        }else if(fieldName == 'PostalCode'){
                            result.ZipCode = fieldValue;
                        }else if(fieldName == 'CountyName'){
                            result.addressCounty = fieldValue;
                        }else if(fieldName == 'Latitude'){
                            result.latitude = Double.valueOf(fieldValue);
                        }else if(fieldName == 'Longitude'){
                            result.longitude = Double.valueOf(fieldValue);
                        }else if(fieldName == 'ErrorCodes'){
                            result.validated = false;
                        }
                        //added just for testing- to be removed once the error code is being passed
                        //result.validated = false;
                    }
                }
                
                if (result.addressLine2 != null){
                    result.addressLine1 = result.addressLine1 + ' ' + result.addressLine2;                
                }else if(result.addressLine2 == null) {
                    result.addressLine1 = result.addressLine1;
                
                }
                result.addressLine2 = ' ';
                result.addressCountry = label.Str_United_States;
                result.addressName = rAddress.addressName ;
                result.businessAddressType =  rAddress.businessAddressType  ;
                result.BusinessAccountId = rAddress.BusinessAccountId ;
                result.EnableAutoLinkingWithAccount = rAddress.EnableAutoLinkingWithAccount ;
                result.BusinessContactId = rAddress.BusinessContactId ;
                result.EnableAutoLinkingWithContact = rAddress.EnableAutoLinkingWithContact ;
                result.saveAsaAddressOnEntityFlag = rAddress.saveAsaAddressOnEntityFlag ;
                if (result.validated){
                    masterAddressMap.put(0 , result);
                }  
                
                System.debug(result.addressLine1);
            }catch(Exception ex){
                system.debug(ex.getMessage());
            }*/
            
            return masterAddressMap ;
        }
        
        public static List<MUSW__License_Parcel__c> retrieveLicenseParcelOnly(String contextLicenseId)
        {
            return [Select Id,
                    Mailing__c,
                    Physical__c, 
                    Account__c, 
                    Public__c, 
                    Primary__c, 
                    Type__c, 
                    MUSW__License2__c, 
                    MUSW__Parcel__c
                    from MUSW__License_Parcel__c Where MUSW__License2__c =: contextLicenseId AND MUSW__Parcel__c != null AND  MUSW__Parcel__r.Status__c = :Label.ST_Active AND MUSW__License2__c != null ] ;
        }
        
        public static List<MUSW__Permit_Parcel__c> retrievePermitParcelOnly(String contextPermitId)
        {
            return [Select Id,
                    Mailing__c,
                    Physical__c, 
                    Account__c, 
                    Public__c, 
                    Primary__c, 
                    Type__c, 
                    MUSW__Permit2__c, 
                    MUSW__Parcel__c
                    from MUSW__Permit_Parcel__c Where MUSW__Permit2__c =: contextPermitId AND MUSW__Parcel__c != null AND  MUSW__Parcel__r.Status__c = :Label.ST_Active AND MUSW__Permit2__c != null ] ;
        }
        
        @RemoteAction
        public static BusinessAddressDBOpResult deleteBusinessAddress(BusinessAddressRMIn rmIn )
        {
           BusinessAddressDBOpResult retRes = new BusinessAddressDBOpResult();
           retRes.rmParam = rmIn ;
           try{
                if(rmIn.parcelId != null && rmIn.parcelId instanceof ID )
                {
                    MUSW__Parcel__c parcel = new MUSW__Parcel__c(ID = rmIn.parcelId, Status__c = label.ST_Inactive) ;
                    update parcel ;    
                }
                
                // TODO - Check with TEAM if we really need to delete junctions 
                // Delete all related junctions 
                /*
                List<sObject> junctionsToDelete = new List<sObject>() ;
                List<sObject> so1 = [Select ID from Parcel_Account__c Where Parcel__c =: rmIn.parcelId ] ;
                junctionsToDelete.addAll(so1);
                List<sObject> so2 = [Select ID from MUSW__Parcel_Contact2__c Where MUSW__Parcel__c =: rmIn.parcelId ] ;
                junctionsToDelete.addAll(so2);
                List<sObject> so3 = [Select ID from MUSW__License_Parcel__c Where MUSW__Parcel__c =: rmIn.parcelId ] ;
                junctionsToDelete.addAll(so3);
                
                if(junctionsToDelete.isEmpty() == false )
                {
                    DELETE junctionsToDelete ;
                }
                
                */

                List<Id> accountIds = new List<ID>();
                if(rmIn.accountId != null && rmIn.accountId instanceof Id )
                {
                    accountIds.add(rmIn.accountId) ;
                }
                
                List<Id> contactIds = new List<ID>();
                
                if(rmIn.contactId != null && rmIn.contactId instanceof Id)
                {
                    contactIds.add(rmIn.contactId) ;
                }
                
                Map<Id,List<ParcelRecord>> mapParcels = prepareMapOfParcelRecords(accountIds,contactIds,rmIn.PrimaryEntityType);
                for(List<ParcelRecord> each : mapParcels.values())
                {
                    retRes.parcelRecords.addAll(each);
                }
                
                retRes.licenseParcels.addAll(retrieveLicenseParcelOnly(rmIn.contextLicenseId));
                retRes.permitParcels.addAll(retrievePermitParcelOnly(rmIn.contextPermitId));
                
                retRes.isSuccess = true ;
                retRes.message = label.Str_Operation_completed_successfully ;
            }catch(Exception ex)
            {
                retRes.isSuccess = false ;
                retRes.message = toString(ex) ;
            }
            return retRes ;
        }
        
        public static String handleLicenseParcelOperations(ID licenseId , ID parcelId , String addressType )
        {
            string retRes = '' ;
            try
            {
                //Removed parcel filter from SOQL ,
                // by considering each license can have only one address of each type 
                //  /*AND  MUSW__Parcel__c = : parcelId */
                List<MUSW__License_Parcel__c> junctionList = new List<MUSW__License_Parcel__c>() ;
                System.debug('addressType::'+addressType);
                if(addressType == label.Str_Public)
                {
                    List<MUSW__License_Parcel__c> lpJunctions = [Select ID ,MUSW__Parcel__c,Account__c,MUSW__License2__c , Physical__c , Primary__c , Public__c , Mailing__c from MUSW__License_Parcel__c Where MUSW__License2__c =: licenseId  AND Public__c = true ] ;
                    if(!lpJunctions.isEmpty()){
                        delete lpJunctions ;
                    }
                    
                    MUSW__License_Parcel__c newJunction = new MUSW__License_Parcel__c(MUSW__Parcel__c= parcelId ,MUSW__License2__c = licenseId  ,Public__c  = true ) ;
                    insert newJunction ;
                    
                    // Try to update Licese record with Public Address - Parcel Id 
                    MUSW__License2__c licToUp = new MUSW__License2__c(ID=licenseId , Public_Address__c=parcelId );
                    update licToUp ;
                    
                }else if(addressType == label.Str_Mailing)
                {
                    List<MUSW__License_Parcel__c> lpJunctions = [Select ID ,MUSW__Parcel__c,Account__c,MUSW__License2__c , Physical__c , Primary__c , Public__c , Mailing__c from MUSW__License_Parcel__c Where MUSW__License2__c =: licenseId  AND Mailing__c = true ] ;
                    if(!lpJunctions.isEmpty()){
                        delete lpJunctions ;
                    }
                    
                    MUSW__License_Parcel__c newJunction = new MUSW__License_Parcel__c(MUSW__Parcel__c= parcelId ,MUSW__License2__c = licenseId  ,Mailing__c  = true ) ;
                    insert newJunction ;
                    
                    // Try to update Licese record with Parcel Id 
                    MUSW__License2__c licToUp = new MUSW__License2__c(ID=licenseId , MUSW__Parcel__c=parcelId );
                   update licToUp ;
                }else if(addressType == label.Str_Physical)
                {
                    List<MUSW__License_Parcel__c> lpJunctions = [Select ID ,MUSW__Parcel__c,Account__c,MUSW__License2__c , Physical__c , Primary__c , Public__c , Mailing__c from MUSW__License_Parcel__c Where MUSW__License2__c =: licenseId  AND Physical__c = true ] ;
                    if(!lpJunctions.isEmpty()){
                        delete lpJunctions ;
                    }
                    System.debug('addressType');
                    MUSW__License_Parcel__c newJunction = new MUSW__License_Parcel__c(MUSW__Parcel__c= parcelId ,MUSW__License2__c = licenseId  ,Physical__c  = true ) ;
                    insert newJunction ;                
                    
                }else if(addressType == label.Str_Primary)
                {
                    List<MUSW__License_Parcel__c> lpJunctions = [Select ID ,MUSW__Parcel__c,Account__c,MUSW__License2__c , Physical__c , Primary__c , Public__c , Mailing__c from MUSW__License_Parcel__c Where MUSW__License2__c =: licenseId  AND Primary__c = true ] ;
                    if(!lpJunctions.isEmpty()){
                        delete lpJunctions ;
                    }
                    
                    MUSW__License_Parcel__c newJunction = new MUSW__License_Parcel__c(MUSW__Parcel__c= parcelId ,MUSW__License2__c = licenseId  ,Primary__c  = true ) ;
                    insert newJunction ;
                    
                }
                
                retRes = 'SUCCESS====Operation completed successfully' ;
            }catch(exception ex)
            {
                retRes = 'Error====: (Creating License Parcel Junctions )' + ex.getMessage() ;
                ErrorLogger.logGeneralException(ex, UserInfo.getUserId(), 'AddressJSUtility_CC', null, 'handleLicenseParcelOperations', 'AddressJSUtility_CC', label.str_HIGH);
            }   
            
            return retRes ; 
        }
        
        public static String handlePermitParcelOperations(ID permitId , ID parcelId , String addressType )
        {
            System.debug('handlePermitParcelOperations called');
            string retRes = '' ;
            try
            {
                //Removed parcel filter from SOQL ,
                // by considering each license can have only one address of each type 
                //  /*AND  MUSW__Parcel__c = : parcelId */
                List<MUSW__Permit_Parcel__c> junctionList = new List<MUSW__Permit_Parcel__c>() ;
                
                if(addressType == label.Str_Public)
                {
                    List<MUSW__Permit_Parcel__c> ppJunctions = [Select ID ,MUSW__Parcel__c,Account__c,MUSW__Permit2__c , Physical__c , 
                                                                Primary__c , Public__c , Mailing__c 
                                                                from MUSW__Permit_Parcel__c 
                                                                Where MUSW__Permit2__c =: permitId  
                                                                AND Public__c = true ] ;
                    if(!ppJunctions.isEmpty()){
                        delete ppJunctions ;
                    }
                                    
                    MUSW__Permit_Parcel__c newJunction = new MUSW__Permit_Parcel__c(MUSW__Parcel__c= parcelId ,
                                                                                    MUSW__Permit2__c = permitId,
                                                                                    Public__c  = true ) ;
                    insert newJunction ;
                    
                    // Try to update Licese record with Public Address - Parcel Id 
                    MUSW__Permit2__c permitToUp = new MUSW__Permit2__c(ID=permitId, Public_Address__c=parcelId);
                    update permitToUp ;
                    
                }else if(addressType == label.Str_Mailing)
                {
                    List<MUSW__Permit_Parcel__c> ppJunctions = [Select ID ,MUSW__Parcel__c,Account__c,MUSW__Permit2__c , Physical__c , 
                                                                Primary__c , Public__c , Mailing__c 
                                                                from MUSW__Permit_Parcel__c 
                                                                Where MUSW__Permit2__c =: permitId  
                                                                AND Mailing__c = true ] ;
                    if(!ppJunctions.isEmpty()){
                        delete ppJunctions ;
                    }
                    
                    MUSW__Permit_Parcel__c newJunction = new MUSW__Permit_Parcel__c(MUSW__Parcel__c= parcelId ,
                                                                                    MUSW__Permit2__c = permitId  ,
                                                                                    Mailing__c  = true ) ;
                    insert newJunction ;
                    
                    // Try to update Licese record with Parcel Id 
                    MUSW__Permit2__c permitToUp = new MUSW__Permit2__c(ID=permitId , MUSW__Parcel__c=parcelId );
                   update permitToUp ;
                }/*else if(addressType == label.Str_Physical)
                {
                    List<MUSW__Permit_Parcel__c> ppJunctions = [Select ID ,MUSW__Parcel__c,Account__c,MUSW__License2__c , Physical__c , Primary__c , Public__c , Mailing__c from MUSW__License_Parcel__c Where MUSW__License2__c =: licenseId  AND Physical__c = true ] ;
                    if (Schema.sObjectType.MUSW__Permit_Parcel__c.isDeletable()) {
                        delete ppJunctions ;
                    }
                    
                    MUSW__Permit_Parcel__c newJunction = new MUSW__License_Parcel__c(MUSW__Parcel__c= parcelId ,MUSW__License2__c = licenseId  ,Physical__c  = true ) ;
                    insert newJunction ;                
                    
                }else if(addressType == label.Str_Primary)
                {
                    List<MUSW__License_Parcel__c> ppJunctions = [Select ID ,MUSW__Parcel__c,Account__c,MUSW__License2__c , Physical__c , Primary__c , Public__c , Mailing__c from MUSW__License_Parcel__c Where MUSW__License2__c =: licenseId  AND Primary__c = true ] ;
                    if (Schema.sObjectType.MUSW__License_Parcel__c.isDeletable()) {
                        delete ppJunctions ;
                    }
                    
                    MUSW__License_Parcel__c newJunction = new MUSW__License_Parcel__c(MUSW__Parcel__c= parcelId ,MUSW__License2__c = licenseId  ,Primary__c  = true ) ;
                    insert newJunction ;
                    
                }*/
                
                retRes = 'SUCCESS====Operation completed successfully' ;
                System.debug('retRes '+retRes);
            }catch(exception ex)
            {
                retRes = 'Error====: (Creating Permit Parcel Junctions )' + ex.getMessage() ;
                ErrorLogger.logGeneralException(ex, UserInfo.getUserId(), 'AddressJSUtility_CC', null, 'handlePermitParcelOperations', 'AddressJSUtility_CC', label.str_HIGH);
            }   
            
            return retRes ; 
        }
        
        
        private static void performContactParcelHandling(String BusinessContactId , String businessAddressType , MUSW__Parcel__c parcel , Boolean bEnableTaggingOnJunction)
        {
            if(BusinessContactId != null && BusinessContactId instanceof ID )
            {
                List<MUSW__Parcel_Contact2__c> junctionToUpdate = new List<MUSW__Parcel_Contact2__c>();
                List<MUSW__Parcel_Contact2__c> junctionToInsert = new List<MUSW__Parcel_Contact2__c>();
                List<MUSW__Parcel_Contact2__c> contParcels = [Select MUSW__Primary__c,Id,MUSW__Parcel__c , Mailing__c,Public__c,MUSW__Contact__c from MUSW__Parcel_Contact2__c WHERE  MUSW__Contact__c = : BusinessContactId AND MUSW__Parcel__c =: parcel.Id ] ;
                        
                
                if(businessAddressType != null && businessAddressType != '' )
                {
                    if(businessAddressType == label.Str_Mailing)
                    {
                        
                        if(contParcels != null && contParcels.isEmpty() == true )
                        {
                            MUSW__Parcel_Contact2__c pJun = new MUSW__Parcel_Contact2__c( MUSW__Contact__c = BusinessContactId , MUSW__Parcel__c = parcel.Id);
                            
                            if(bEnableTaggingOnJunction != null && bEnableTaggingOnJunction == true )
                            {
                                pJun.Mailing__c = true ;
                            }
                            junctionToInsert.add(pJun) ;
                                
                        }else
                        {
                            MUSW__Parcel_Contact2__c pJun = contParcels[0]; 
                            
                            if(bEnableTaggingOnJunction != null && bEnableTaggingOnJunction == true )
                            {
                                pJun.Mailing__c = true ;
                            }
                            
                            junctionToUpdate.add(pJun) ;    
                            
                        }
                    }else if (businessAddressType == label.Str_Public)
                    {
                        if(contParcels != null && contParcels.isEmpty() == true )
                        {
                            MUSW__Parcel_Contact2__c pJun = new MUSW__Parcel_Contact2__c( MUSW__Contact__c = BusinessContactId , MUSW__Parcel__c = parcel.Id);
                            
                            if(bEnableTaggingOnJunction != null && bEnableTaggingOnJunction == true )
                            {
                                pJun.Public__c = true ;
                            }
                            junctionToInsert.add(pJun) ;
                                
                        }else
                        {
                            MUSW__Parcel_Contact2__c pJun = contParcels[0]; 
                            
                            if(bEnableTaggingOnJunction != null && bEnableTaggingOnJunction == true )
                            {
                                pJun.Public__c = true ;
                            }
                            
                            junctionToUpdate.add(pJun) ;    
                            
                        }
                        
                    }else if(businessAddressType == label.Str_Physical)
                    {
                        
                    }else if(businessAddressType == label.Str_Primary)
                    {
                        
                        if(contParcels != null && contParcels.isEmpty() == true )
                        {
                            MUSW__Parcel_Contact2__c pJun = new MUSW__Parcel_Contact2__c( MUSW__Contact__c = BusinessContactId , MUSW__Parcel__c = parcel.Id);
                            
                            if(bEnableTaggingOnJunction != null && bEnableTaggingOnJunction == true )
                            {
                                pJun.MUSW__Primary__c = true ;
                                
                                // Now query other junctions and update their primary flag 
                                // Based on Latest decision , we are not unchecking flag
                                /* 
                                for( MUSW__Parcel_Contact2__c rec :  [Select MUSW__Primary__c,Id,MUSW__Parcel__c , Mailing__c,Public__c,MUSW__Contact__c from MUSW__Parcel_Contact2__c WHERE  MUSW__Contact__c = : BusinessContactId AND MUSW__Primary__c =: true ] )
                                {
                                    rec.MUSW__Primary__c = false ;
                                    junctionToUpdate.add(rec);
                                }
                                */
                            }
                            
                            junctionToInsert.add(pJun) ;    
                        }else
                        {
                            MUSW__Parcel_Contact2__c pJun = contParcels[0]; 
                            
                            if(bEnableTaggingOnJunction != null && bEnableTaggingOnJunction == true )
                            {
                                pJun.MUSW__Primary__c = true ;
                                
                                // Now query other junctions and update their primary flag 
                                /*
                                Based on latest decision 
                                we are not going to update uncheck flag
                                for( MUSW__Parcel_Contact2__c rec :  [Select MUSW__Primary__c,Id,MUSW__Parcel__c , Mailing__c,Public__c,MUSW__Contact__c from MUSW__Parcel_Contact2__c WHERE  MUSW__Contact__c = : BusinessContactId AND MUSW__Primary__c =: true ] )
                                {
                                    rec.MUSW__Primary__c = false ;
                                    junctionToUpdate.add(rec);
                                }
                                */
                            }
                            
                            junctionToUpdate.add(pJun) ;    
                            
                        }
                        
                    }
                }
                
                if(junctionToInsert.isEmpty() == false)
                {
                    INSERT junctionToInsert ;
                }
                
                if(junctionToUpdate.isEmpty() == false)
                {
                    UPDATE junctionToUpdate ;
                }
                
            }
            
        }
        
        
        @RemoteAction 
        public static BusinessAddressResult getBusinessAddressListOnLoad(List<Id> accountIds , List<Id> contactIds , String primaryEntityType )
        {
            BusinessAddressResult retRes = new BusinessAddressResult() ;
            
            retRes.accountIds = new List<Id>() ;
            retRes.accountIds.addAll(accountIds) ;
            
            retRes.contactIds = new List<Id>();
            retRes.contactIds.addAll(contactIds) ;
            
            Map<Id, List<ParcelRecord> > mapParcelRecords = prepareMapOfParcelRecords(accountIds,contactIds,primaryEntityType);
            
            retRes.dataMap = new  Map<Id,List<ParcelRecord>>() ;
            retRes.dataMap.putAll(mapParcelRecords); 
            
            retRes.isSuccess = true ;
            retRes.message = label.Str_Operation_completed_successfully ;

            return retRes ;
        }
        
        @RemoteAction 
        public static LicenseBusinessAddressResult getLicenseBusinessAddressDetails(EditRMInput rmIn)
        {
            LicenseBusinessAddressResult retRes = new LicenseBusinessAddressResult() ;
            
            SavePoint sp = Database.setSavePoint() ;
            boolean successOperationOne = true ;
            string successMessageOne = '' ;
            
            String accountId = rmIn.accountId ;
            String contactId = rmIn.contactId ;
            String licenseId = rmIn.licenseId ;
            //String permitId = rmIn.permitId;
                   
            if(rmIn.isLPJobRemaining != null && rmIn.isLPJobRemaining == true )
            {
                if(rmIn.contextParcelId != null && rmIn.contextParcelId instanceof Id && licenseId != null && licenseId instanceof ID && rmIn.contextAddressType != null )
                {
                    String result = handleLicenseParcelOperations(licenseId,rmIn.contextParcelId,rmIn.contextAddressType );
                    if(result.split('====')[0] == label.Err_Error_Message)
                    {
                        successOperationOne = false ;
                        successMessageOne = result.split('====')[1] ;
                        Database.rollback(sp);
                    }   
                }   
            } 
                    
            retRes.accountId = accountId ;
            retRes.contactId = contactId ;
            
            List<Id> accountIds = new List<ID>();
            if(accountId != null && accountId instanceof Id )
            {
                accountIds.add(accountId) ;
            }
            
            List<Id> contactIds = new List<ID>();
            
            if(contactId != null && contactId instanceof Id)
            {
                contactIds.add(contactId) ;
            }
            
            Map<Id, List<ParcelRecord> > mapParcelRecords = prepareMapOfParcelRecords(accountIds,contactIds,rmIn.primaryEntityType);
            
            for(List<ParcelRecord> lst : mapParcelRecords.values())
            {
                retRes.parcelRecords.addAll(lst);   
            }
            
            if(licenseId != null && licenseId != '')
           {
             retRes.licenseParcels.addAll(retrieveLicenseParcelOnly(licenseId)) ;
             system.debug('inside licenseParcel');
           }
            
            
            // Prepare configuration 
            retRes.addressConfig = new  GlobalAddressConfig();
            
            retRes.isSuccess = successOperationOne  ;
            retRes.message = successMessageOne + 'Search Operation completed successfully';//TODO label.Str_Search_Operation_completed_successfully ;
            System.debug('result::'+retRes);
            return retRes ;
        }
        
        @RemoteAction 
        public static PermitBusinessAddressResult getPermitBusinessAddressDetails(EditRMInput rmIn)
        {
            PermitBusinessAddressResult retRes = new PermitBusinessAddressResult() ;
            
            SavePoint sp = Database.setSavePoint() ;
            boolean successOperationOne = true ;
            string successMessageOne = '' ;
            
            String accountId = rmIn.accountId ;
            String contactId = rmIn.contactId ;
            //String licenseId = rmIn.licenseId ;
            String permitId = rmIn.permitId;
                   
            if(rmIn.isPPJobRemaining != null && rmIn.isPPJobRemaining == true )
            {
                if(rmIn.contextParcelId != null && rmIn.contextParcelId instanceof Id && permitId != null && permitId instanceof ID && rmIn.contextAddressType != null )
                {
                    String result = handlePermitParcelOperations(permitId,rmIn.contextParcelId,rmIn.contextAddressType );
                    if(result.split('====')[0] == label.Err_Error_Message)
                    {
                        successOperationOne = false ;
                        successMessageOne = result.split('====')[1] ;
                        Database.rollback(sp);
                    }   
                }   
            }
                    
            retRes.accountId = accountId ;
            retRes.contactId = contactId ;
            
            List<Id> accountIds = new List<ID>();
            if(accountId != null && accountId instanceof Id )
            {
                accountIds.add(accountId) ;
            }
            
            List<Id> contactIds = new List<ID>();
            
            if(contactId != null && contactId instanceof Id)
            {
                contactIds.add(contactId) ;
            }
            
            Map<Id, List<ParcelRecord> > mapParcelRecords = prepareMapOfParcelRecords(accountIds,contactIds,rmIn.primaryEntityType);
            
            for(List<ParcelRecord> lst : mapParcelRecords.values())
            {
                retRes.parcelRecords.addAll(lst);   
            }
            
            if(permitId != null && permitId != '')
           {
             retRes.permitParcels.addAll(retrievePermitParcelOnly(permitId)) ;
           }
            
            
            // Prepare configuration 
            retRes.addressConfig = new  GlobalAddressConfig();
            
            retRes.isSuccess = successOperationOne  ;
            retRes.message = successMessageOne + 'Search Operation completed successfully';//TODO label.Str_Search_Operation_completed_successfully ;
            
            return retRes ;
        }
            
        private static Map<Id, List<ParcelRecord> > prepareMapOfParcelRecords(List<Id> accountIds , List<Id> contactIds , String primaryEntityType )
        {
            Set<ID> parcelIds = new Set<ID>();
            Map<Id, List<ParcelRecord> > mapParcelRecords = new Map<Id, List<ParcelRecord>>();
            
            if(primaryEntityType == label.API_Account)
            {
                for(Parcel_Account__c pa : [ Select Primary__c, Public__c, /*Physical__c, */Parcel__c, Name, Mailing__c, Id, Account__c/*, Account_Type__c*/ From Parcel_Account__c  Where Account__c IN :accountIds  AND Parcel__c != null  AND Parcel__r.Status__c = :Label.ST_Active ] )  
                {
                    parcelIds.add(pa.Parcel__c); 
                    
                    if(mapParcelRecords.containsKey(pa.Account__c))
                    {
                        List<ParcelRecord> records = mapParcelRecords.get(pa.Account__c) ;
                        records.add(new ParcelRecord(pa , null ));
                        mapParcelRecords.put(pa.Account__c, records) ;
                    }else
                    {
                        List<ParcelRecord> recordsNew = new List<ParcelRecord>();
                        recordsNew.add(new ParcelRecord(pa , null ));
                        mapParcelRecords.put(pa.Account__c, recordsNew) ;
                    }
                }
            }
            
            if(primaryEntityType == label.Str_Contact)
            {
                for(MUSW__Parcel_Contact2__c pc :  [Select MUSW__Primary__c,Id,MUSW__Parcel__c ,Mailing__c,Public__c,MUSW__Contact__c from MUSW__Parcel_Contact2__c WHERE  MUSW__Contact__c IN : contactIds  AND MUSW__Parcel__c != null  AND MUSW__Parcel__r.Status__c = :Label.ST_Active])
                {
                    parcelIds.add(pc.MUSW__Parcel__c);
                    
                    if(mapParcelRecords.containsKey(pc.MUSW__Contact__c))
                    {
                        List<ParcelRecord> records = mapParcelRecords.get(pc.MUSW__Contact__c) ;
                        records.add(new ParcelRecord( null , pc ));
                        mapParcelRecords.put(pc.MUSW__Contact__c, records) ;
                    }else
                    {
                        List<ParcelRecord> recordsNew = new List<ParcelRecord>();
                        recordsNew.add(new ParcelRecord(null , pc ));
                        mapParcelRecords.put(pc.MUSW__Contact__c, recordsNew) ;
                    }
                    
                }
            }
            
            Map<Id,MUSW__Parcel__c> parcelMap = new Map<Id,MUSW__Parcel__c>([Select ID , 
                            //Type__c,
                            Name,
                            MUSW__Street__c,
                            MUSW__Street2__c,
                            MUSW__City__c,
                            MUSW__State__c,
                            MUSW__Post_Zip_Code__c,
                            Country__c,
                            County__c,
                            International_Address__c ,
                            Comments__c,
                            Is_This_A_Military_Address__c ,
                            Status__c 
                                from MUSW__Parcel__c Where Id IN :parcelIds  and Status__c = :Label.ST_Active order by LastModifiedDate DESC]);
            
            for(List<ParcelRecord> lst : mapParcelRecords.values())
            {
                for(ParcelRecord p : lst)
                {
                    if(p.parcelAccount != null && p.parcelAccount.Parcel__c != null )
                    {
                        p.setParcel(parcelMap.get(p.parcelAccount.Parcel__c));
                    }else if(p.parcelContact != null && p.parcelContact.MUSW__Parcel__c != null)
                    {
                        p.setParcel(parcelMap.get(p.parcelContact.MUSW__Parcel__c));
                    }       
                }
            }

            return mapParcelRecords ;
        }
        
        
        private static void printDebugInfo(string contactId , String eventName)
        {
            for(MUSW__Parcel_Contact2__c jn : [Select Id , MUSW__Contact__c, MUSW__Parcel__c ,MUSW__Parcel__r.MUSW__Primary_Contact__c, Public__c, MUSW__Primary__c from MUSW__Parcel_Contact2__c  Where MUSW__Contact__c =:contactId  ])
            {
                system.debug('Parcel Id ------>' + jn.MUSW__Parcel__c ) ;
                system.debug('Primary contact of parcel ------' + jn.MUSW__Parcel__r.MUSW__Primary_Contact__c) ;
            }
            
        }
        
        private static void performSaveAsEntityOperations(EditRMInput rmIn)
        {
            if(rmIn.primaryEntityType == label.Str_Contact && rmIn.contactId != null && rmIn.contactId instanceof Id)
            {
                printDebugInfo(rmIn.contactId, 'Remote method started ------- ') ;
                
                if(rmIn.contextAddressType == label.Str_Primary)
                {
                    List<MUSW__Parcel_Contact2__c> toUpdate = new List<MUSW__Parcel_Contact2__c>() ;
                    
                    /*
                    Based on latest decision , this functionality is removed temp.
                    for(MUSW__Parcel_Contact2__c pc : [ Select MUSW__Contact__c, MUSW__Parcel__c , Public__c, MUSW__Primary__c,Name, Mailing__c, Id From MUSW__Parcel_Contact2__c  Where MUSW__Contact__c =:rmIn.contactId AND MUSW__Primary__c = true  ] )  
                    {
                        pc.MUSW__Primary__c = false ;
                        toUpdate.add(pc);
                    }
                    */
                    
                    if(toUpdate.isEmpty() == false )
                    {
                        UPDATE toUpdate ;
                    }
                
                    // Check if junction exist for current combination 
                    
                    List<MUSW__Parcel_Contact2__c> lstJunct = [Select Id ,  MUSW__Contact__c,MUSW__Primary__c, MUSW__Parcel__c from MUSW__Parcel_Contact2__c  WHERE  MUSW__Contact__c =:rmIn.contactId AND MUSW__Parcel__c =: rmIn.contextParcelId limit 1 ] ;
                    if(lstJunct.isEmpty() == false )
                    {
                        lstJunct[0].MUSW__Primary__c = true ;
                        
                        update lstJunct ;
                    }else
                    {
                        //Create new Junction
                        MUSW__Parcel_Contact2__c junctObject = new MUSW__Parcel_Contact2__c(MUSW__Primary__c = true , MUSW__Contact__c =rmIn.contactId, MUSW__Parcel__c = rmIn.contextParcelId);
                        INSERT  junctObject ;
                    }
                    
                }
            }
        }
        
        @RemoteAction 
        public static BusinessAddressResult saveAsAddressOnEntity(EditRMInput rmIn )
        {
            BusinessAddressResult retRes = new BusinessAddressResult() ;
            try
            {
                retRes.accountIds = new List<Id>() ;
                
                if(rmIn.accountId != null && rmIn.accountId instanceof Id)
                {
                    retRes.accountIds.add(rmIn.accountId) ;
                }
                        
                retRes.contactIds = new List<Id>();
                
                if(rmIn.contactId != null && rmIn.contactId instanceof Id)
                {
                    retRes.contactIds.add(rmIn.contactId) ;
                }
                
                performSaveAsEntityOperations(rmIn) ;
                
                Map<Id, List<ParcelRecord> > mapParcelRecords = prepareMapOfParcelRecords(retRes.accountIds,retRes.contactIds,rmIn.primaryEntityType);
                
                retRes.dataMap = new  Map<Id,List<ParcelRecord>>() ;
                retRes.dataMap.putAll(mapParcelRecords); 
                
                retRes.isSuccess = true ;
                retRes.message = label.Str_Operation_completed_successfully ;
            }catch(exception ex)
            {
                ErrorLogger.logGeneralException(ex, UserInfo.getUserId(), 'AddressJSUtility_CC', null, 'handlePermitParcelOperations', 'AddressJSUtility_CC', label.str_HIGH);
                retRes.isSuccess = false ; 
                retRes.message = label.Err_Error_Message + ' ::' + ex.getMessage() ;
            }
            return retRes ;
        }

    }