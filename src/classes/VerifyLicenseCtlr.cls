public class VerifyLicenseCtlr {
    
    public SearchFields searchField {get; set;}
    public MUSW__License2__c credential {get; set;}
    public MUSW__Permit2__c permit {get; set;}
    public String credentialList {get;set;}
    private static String searchType {get; set;}
    private static String queryLimit {get;set;}
    public boolean isGuestUserLoggedIn {get;set;}
    private final Map<String,String> SOURCE_CONFIG = new Map<String, String>{Label.API_License2 => 'credential', Label.API_MUSW_Permit2 => 'permit'};
        public List<SelectOption> permitStatusOptions {get;set;}  
    public List<SelectOption> credentialStatusOptions {get;set;} 
    
    /**
* Constructor
* */
    public VerifyLicenseCtlr(){
        searchField = new SearchFields();
        credential = new MUSW__License2__c();
        permit = new MUSW__Permit2__c();
        credential.RecordTypeId = Utilities.getRecordTypeForName(label.API_License2, 'eSLA Portal');
        permit.RecordTypeId = Utilities.getRecordTypeForName(label.API_Permit, 'eSLA Portal');
        credentialList = Label.Str_All_Credentials;
        isGuestUserLoggedIn = Utilities.isGuestUserLoggedIn();
        getAppStatus();
    }
    
    /**
* Method to Search for Credential or Permit based on Search Critiera
* */
    @RemoteAction
    public static List<SearchResult> findSearchResult(SearchFields searchCritera) {
        List<SearchResult> searchResults = new List<SearchResult>();
        searchType = searchCritera.searchType;
        //if Both then query from Credential + query from Permit and then combine result
        List<String> searchObjects = new List<String>{};
            queryLimit = searchCritera.searchObject.equals('both') ? String.valueOf(Integer.valueOf(label.Str_Query_Limit)/2) : label.Str_Query_Limit;
        String searchObj = (!searchCritera.searchObject.equals('both')) ? searchCritera.searchObject : label.API_License2;
        String query = searchCritera.getSearchQuery(searchObj);
        System.debug('credential/permit Query ::' +query);
        searchResults = getSearchResults(searchResults, query, searchObj);
        query = '';
        if(searchCritera.searchObject.equals('both')){
            query = searchCritera.getSearchQuery(label.API_Permit);
            System.debug('permitQuery ::' +query);
        }
        searchResults = getSearchResults(searchResults, query, label.API_Permit);
        System.debug('searchResults>>>>>>>>>>'+searchResults);
        return searchResults;
    }
    
    /**
* Function to get search results
* */
    private static List<SearchResult> getSearchResults(List<SearchResult> searchResults, String query, String objectName){
        if(String.isBlank(query)) {
            return searchResults;            
        }
        List<SObject> resultList = Database.query(query);
        Map<ID, String> answerMap = new Map<ID, String>();
        List<ID> titleIDList = new List<ID>();
        List<ID> ceEligibleLicenseIDList = new List<ID>();
        List<Renewal_Application__c> ceEligibleRenewalList = new List<Renewal_Application__c>();
        Boolean isCEEligible;
        for (SObject obj : resultList) {
            if(objectName == label.API_License2){
                isCEEligible = Boolean.valueOf(obj.get('CE_Eligible__c'));
                if(isCEEligible){
                    ceEligibleLicenseIDList.add(String.valueOf(obj.get('Id')));
                }
                if(String.valueOf(obj.get('Credential_Type__c')) == 'Manufactured Homes Titling'){
                    ID titleID = String.valueOf(obj.get('Id'));
                    titleIDList.add(titleID);
                }                
            }            
        }
        if(titleIDList.size() > 0){
            List<Answer__c> answerList = [Select id, name, License__c, Answer_Text__c from Answer__c 
                                           where License__r.id IN :titleIDList and (External_id_of_Question__c = 'Ex-QUE-MHCOT-5' 
                                                                    OR External_id_of_Question__c = 'Ex-QUE-MHCOT-SP-2')];
            for(Answer__c answer: answerList){
                if(answerMap.containsKey(answer.License__c)){
                    String concatenatedAnswer = answerMap.get(answer.License__c) + ', ' +answer.Answer_Text__c;
                    answerMap.put(answer.License__c, concatenatedAnswer);
                }else{
                    answerMap.put(answer.License__c, answer.Answer_Text__c);
                }
            }
            System.debug(answerMap); 
        }
        
        if(ceEligibleLicenseIDList.size() > 0){
            ceEligibleRenewalList = [SELECT license__r.Id, Id, CE_Hours__c
                                                                  FROM Renewal_Application__c
                                                                  WHERE license__r.id IN :ceEligibleLicenseIDList
                                                                  AND Renewal_Status__c = :Label.ST_Submitted];
            
        }        
        
        for (SObject obj : resultList) {
            Decimal ceHours = -99996645.23;
            if(ceEligibleRenewalList.size() > 0){
            for(Renewal_Application__c renewalRecord: ceEligibleRenewalList){
                System.debug('in for loop for renewalRecord- CE');
                if(obj.get('Id') == renewalRecord.License__r.Id){
                    System.debug('in if id == id');
                    ceHours = renewalRecord.CE_Hours__c;
                    System.debug('renewal CE Hours '+ ceHours);
           		}
                
            }
            }
            searchResults.add(new SearchResult(obj, objectName, answerMap, ceHours));
        }
        return searchResults;
    }
    
    /**
* Get State list with Abberviated options
* */
    public List<SelectOption> abbeviatedStateOptions {
        get {
            if (abbeviatedStateOptions != null)
                return abbeviatedStateOptions;
            
            abbeviatedStateOptions = new List<SelectOption>();
            abbeviatedStateOptions.add(new selectoption(label.Str_None, '---Select--'));
            for (Schema.PicklistEntry ple : Schema.SObjectType.MUSW__Parcel__c.fields.MUSW__State__c.getPicklistValues())
                abbeviatedStateOptions.add(new SelectOption(ple.getLabel(), ple.getValue()));
            
            return abbeviatedStateOptions;
        }
        private set;
    }
    
    /**
* Get County options for WI
* */
    public List<SelectOption> countyOptions {
        get {
            if (countyOptions != null) {
                return countyOptions;
            }
            countyOptions = new List<SelectOption>();
            countyOptions.add(new selectoption(label.Str_None, '---Select--'));
            for (Schema.PicklistEntry ple : Schema.SObjectType.MUSW__Parcel__c.fields.County__c.getPicklistValues())
                countyOptions.add(new SelectOption(ple.getLabel(), ple.getValue()));
            
            return countyOptions;
        }
        private set;
    }
    
    /**
* Action menthod to clear county value when state is selected other than WI
* */
    public void refreshCounty() {
        searchField.county = '';
    }
    
    /**
* Update status based on application type
* */
    private void getAppStatus(){
        permitStatusOptions = new List<SelectOption>();
        permitStatusOptions.add(new selectoption(label.Str_None, '---Select--'));
        credentialStatusOptions = new List<SelectOption>();
        credentialStatusOptions.add(new selectoption(label.Str_None, '---Select--'));
        List<String> restrictedStatus = new List<String>(Label.Str_Restricted_Public_Lookup_Status.split(';'));
        for (Schema.PicklistEntry ple : Schema.SObjectType.MUSW__Permit2__c.fields.MUSW__Status__c.getPicklistValues()){
            if(!restrictedStatus.contains(ple.getValue())){
                permitStatusOptions.add(new SelectOption(ple.getLabel(), ple.getValue()));
            }
        }
        for (Schema.PicklistEntry ple : Schema.SObjectType.MUSW__License2__c.fields.MUSW__Status__c.getPicklistValues()){
            if(!restrictedStatus.contains(ple.getValue())){
                credentialStatusOptions.add(new SelectOption(ple.getLabel(), ple.getValue()));
            }
        }
        
    }
    
    /**
* POJO for search fields
* */
    public Class SearchFields {
        // individual fields
        public String businessName {get; set;}
        public String firstName {get; set{if (value != null) firstName = value.trim();}}
        public String lastName {get; set{if (value != null) lastName = value.trim();}}
        public String OwnerName {get; set{if (value != null) OwnerName = value.trim();}}//for Titling
        public String MNFSerialNumber {get; set{if (value != null) MNFSerialNumber = value.trim();}}//for Titling
        public String middleName {get; set{if (value != null) middleName = value.trim();}}
        public String contactAliases {get; set{if (value != null) contactAliases = value.trim();}}
        public String dba {get; set{if (value != null) dba = value.trim();}}
        public String appTypeCredential {get; set;}
        public String credential {get; set;}
        public String permitType {get; set;}
        public String credentialNumber {get; set{if (value != null) credentialNumber = value.trim();}}
        public String street {get; set{if (value != null) street = value.trim();}}
        public String city {get; set{if (value != null) city = value.trim();}}
        public String state {get; set;}
        public String county {get; set;}
        public String searchType {get; set;}
        public String searchObject {get;set;}
        public String siteId {get;set;}
        public String status {get;set;}
        public SearchFields(){}
        
        /**
* Get Search query based on Search Object
* */
        public String getSearchQuery(String searchObject){
            System.debug('searchObject>>>>>>>>'+searchObject);
            String query = getDefaultSearchFields(searchObject,'Public_Lookup_Fields');
            query += queryReleationColumns();
            query += 'Id FROM ' +searchObject; 
            return buildWhereConditions(query, searchObject);
        }
        
        /**
* Added conditions to where clause
* */
        private String buildWhereConditions(String query, String objectApiName){
            
            query += ' WHERE Hide_From_Portal__c = False AND MUSW__Status__c NOT IN (\'Pending\',\'Generate Fee\')'; 
            query += (searchType.equals('individual') || searchType.equals('title')) ? ' AND Business_License__c = false' : ' AND Business_License__c = true';
            
            //Added by Sharad as the individual license query was displaying titles as well- 
            //As per Rinku Patel, Titles, should only be displayed when user explicitly searches for Title using the Title option on public lookup
            query = (searchType.equals('individual') && objectApiName.equals('MUSW__License2__c')) ? query +=' AND Credential_Type__c != \'Manufactured Homes Titling\'' : query; 
            query = (searchType.equals('title')) ? query +=' AND Credential_Type__c = \'Manufactured Homes Titling\'' : query; 
            
            query = (String.isNotBlank(this.firstName)) ? query +=' AND MUSW__Applicant__r.FirstName LIKE \'' +String.escapeSingleQuotes(this.firstName) + '%\'' : query; 
            query = (String.isNotBlank(this.lastName)) ? query +=' AND MUSW__Applicant__r.LastName LIKE \'' +String.escapeSingleQuotes(this.lastName) + '%\'' : query;
            query = (String.isNotBlank(this.middleName)) ? query +=' AND MUSW__Applicant__r.MiddleName LIKE \'' +String.escapeSingleQuotes(this.middleName) + '%\'' : query;
            query = (String.isNotBlank(this.contactAliases)) ? query +=' AND MUSW__Applicant__r.Aliases__c LIKE \'' +String.escapeSingleQuotes(this.contactAliases) + '%\'' : query;
            query = (String.isNotBlank(this.dba)) ? getDBAFilter(query,objectApiName) : query;
            query = (String.isNotBlank(this.businessName)) ? query +=' AND Licensee_Name__c LIKE \'' + String.escapeSingleQuotes(this.businessName) + '%\'' : query;
            query = (String.isNotBlank(this.appTypeCredential)) ? query +=' AND Application_Type__c = \'' +String.escapeSingleQuotes(this.appTypeCredential) + '\'': query;
            query = (String.isNotBlank(this.credential)) && objectApiName == Label.API_License2 ? query +=' AND Credential__c = \'' +String.escapeSingleQuotes(this.credential) + '\'' : query;
            query = (String.isNotBlank(this.permitType)) && objectApiName == Label.API_MUSW_Permit2 ? query +=' AND Permit_Type__c = \'' +String.escapeSingleQuotes(this.permitType) + '\'' : query;
            query = (String.isNotBlank(this.street)) ? query +=' AND Public_Address__r.MUSW__Street__c LIKE \'' +String.escapeSingleQuotes(this.street) +'%\'' : query;
            query = (String.isNotBlank(this.city)) ? query +=' AND Public_Address__r.MUSW__City__c LIKE \'' +String.escapeSingleQuotes(this.city) +'%\'' : query;
            query = (String.isNotBlank(this.state) && !this.state.equals(label.Str_None)) ? query +=' AND Public_Address__r.MUSW__State__c = \'' +String.escapeSingleQuotes(this.state) +'\'' : query;
            query = (String.isNotBlank(this.county)) ? query +=' AND Public_Address__r.County__c = \'' +String.escapeSingleQuotes(this.county) +'\'' : query;
            query = (String.isNotBlank(this.credentialNumber)) && objectApiName == Label.API_License2 ? query +=' AND ( NAME LIKE \'%' +String.escapeSingleQuotes(this.credentialNumber) +'%\'  OR MUSW__Applicant__r.Cust_Id__c = \'' +String.escapeSingleQuotes(this.credentialNumber) +'\'  OR MUSW__Primary_Licensee__r.Cust_Id__c = \'' +String.escapeSingleQuotes(this.credentialNumber) +'\') ': query;
            query = (String.isNotBlank(this.credentialNumber))  && objectApiName == Label.API_MUSW_Permit2 ? query +=' AND ( NAME LIKE \'%' +String.escapeSingleQuotes(this.credentialNumber) +'%\'  OR MUSW__Applicant__r.Cust_Id__c = \'' +String.escapeSingleQuotes(this.credentialNumber) +'\' OR MUSW__Account__r.Cust_Id__c = \'' +String.escapeSingleQuotes(this.credentialNumber) +'\')': query;
            query = (String.isNotBlank(this.siteId)) ? query +=' AND MUSW__Project2__r.Site_Id__c = \'' +String.escapeSingleQuotes(this.siteId) +'\'' : query;
            query = (String.isNotBlank(this.OwnerName)) && objectApiName == Label.API_License2 && searchType.equals('title')? query +=' AND Owner_Name__c LIKE \'%' +String.escapeSingleQuotes(this.OwnerName) +'%\'' : query;
            query = (String.isNotBlank(this.MNFSerialNumber)) && objectApiName == Label.API_License2 && searchType.equals('title')? query +=' AND Manufactured_Homes_Serial_Number__c LIKE \'%' +String.escapeSingleQuotes(this.MNFSerialNumber) +'%\'' : query;
            query = (String.isNotBlank(this.status) && !this.status.equals(label.Str_None)) ? query +=' AND MUSW__Status__c = \'' +String.escapeSingleQuotes(this.status) +'\'' : query;
            query += ' LIMIT '+queryLimit;
            return query;
        }
        
        private String getDBAFilter(String query, String ObjectName){
            String relationship = (ObjectName.equals(Label.API_License2) ? 'MUSW__Primary_Licensee__r.Doing_Business_As_1__c' : 'MUSW__Account__r.Doing_Business_As_1__c');    
            return query +=' AND ' +relationship+ ' LIKE \'' +this.dba + '%\'';                      
        }
    }
    
    /**
* Create default search query fields configured in Field Set
* */
    public static String getDefaultSearchFields(String sobjectTypeApi, String fieldSetApi){
        String query = 'SELECT ';
        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
        System.debug('GlobalDescribeMap+++'+GlobalDescribeMap);
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(sobjectTypeApi);
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetApi);
        System.debug('fieldSetObj>>>'+fieldSetObj);
        for(Schema.FieldSetMember fsm : fieldSetObj.getFields()){
            query += fsm.getFieldPath() + ', ';
        }
        query += (sobjectTypeApi) == Label.API_License2 ? +'Owner_Name__c, Manufactured_Homes_Serial_Number__c, MUSW__Applicant__r.Cust_Id__c, MUSW__Primary_Licensee__r.Cust_Id__c, ':'MUSW__Applicant__r.Cust_Id__c, MUSW__Account__r.Cust_Id__c, ';
        return query;
    }
    
    public static String queryReleationColumns(){
        return 'Public_Address__r.MUSW__Street__c, Public_Address__r.MUSW__City__c, Public_Address__r.MUSW__State__c, Public_Address__r.County__c, Public_Address__r.Country__c, Public_Address__r.MUSW__Post_Zip_Code__c,MUSW__Project2__r.Site_Id__c, ';
    }
    
    /**
* POJO for Search results
* */
    public class SearchResult {
        public String Name {get; set;}
        public String OwnerName {get; set;}
        public String MNFSerialNumber {get;set;}
        public String Type {get; set;}
        public String RecNumber {get; set;}
        public String Status {get; set;}
        public String SubStatus {get; set;}
        public String LegalAction {get; set;}
        public String Street {get; set;}
        public String City {get; set;}
        public String State {get; set;}
        public String County {get; set;}
        public String Zip {get;set;}
        public Date IssueDate {get; set;}
        public Date ExpirationDate {get; set;}
        public String CEHours {get;set;}
        public String RecordId {get;set;}
        public String ObjectName {get;set;}
        public String Country {get;set;}
        public String ApplicationType {get;set;}
        public String CEHoursPerCycle {get;set;}
        public String CEHoursNeeded {get;set;}
        public String SiteId {get;set;}
        public Boolean isBusinessLicense {get;set;}
        public Boolean customerId {get;set;}
        public String custID {get;set;}
        public List<String> Lienpartynames {get;set;}
        public String LienParties {get;set;}
        
        
        public SearchResult(SObject sobj,  String objectName, Map<ID, String> answerMap, Decimal ceHoursFromRenewalIfAny){
            this.Name = String.valueOf((Boolean.valueOf(sobj.get('Business_License__c')) ? sobj.get('Licensee_Name__c') : sobj.get('Applicant_Full_Name__c'))); 
            this.OwnerName = objectName.equals(label.API_License2) ? String.valueOf(sobj.get('Owner_Name__c')) : '';
            String ManufacturedSerialNum = objectName.equals(label.API_License2) ? String.valueOf(sobj.get('Manufactured_Homes_Serial_Number__c')) : '';
            this.MNFSerialNumber =  String.isNotBlank(ManufacturedSerialNum)? ManufacturedSerialNum: '';
            this.ApplicationType = String.valueOf(sobj.get('Application_Type__c'));
            this.Type = objectName.equals(label.API_License2) ? String.valueOf(sobj.get('Credential__c')) : String.valueOf(sobj.get('Permit_Type__c'));
            this.RecNumber = String.valueOf(sobj.get('Name'));
            this.Status = String.valueOf(sobj.get('MUSW__Status__c'));
            this.SubStatus = String.valueOf(sobj.get('Sub_Status__c'));
            SObject publicAddress = sobj.getSObject('Public_Address__r');
            System.debug('publicAddress '+publicAddress);
            this.Street = String.valueOf(publicAddress != null ? publicAddress.get('MUSW__Street__c') : '');
            this.City = String.valueOf(publicAddress != null ? publicAddress.get('MUSW__City__c') : '');
            this.State = String.valueOf(publicAddress != null ? publicAddress.get('MUSW__State__c') : '');
            //this.State = String.valueOf(sobj.get('Public_Address__r.MUSW__State__c'));
            this.County = String.valueOf(publicAddress != null ? publicAddress.get('County__c') : '');
            this.Country = String.valueOf(publicAddress != null ? publicAddress.get('Country__c') :'');
            this.Zip = String.valueOf(publicAddress != null ? publicAddress.get('MUSW__Post_Zip_Code__c') : '');
            this.IssueDate = Date.valueOf(sobj.get('MUSW__Issue_Date__c'));
            this.ExpirationDate = Date.valueOf(sobj.get('MUSW__Expiration_Date__c'));
            //Added the below if-else condition to show hours from Renewal Application if there is one in submitted state
            if(ceHoursFromRenewalIfAny != -99996645.23){
                this.CEHours = String.valueOf(ceHoursFromRenewalIfAny);
                this.CEHoursPerCycle = String.valueOf(sobj.get('CE_Hours_per_Cycle__c'));
                Decimal ceHoursNeeded = (Decimal)sobj.get('CE_Hours_per_Cycle__c') - ceHoursFromRenewalIfAny;                
                this.CEHoursNeeded = (String.valueOf(sobj.get('MUSW__Renewal_Date__c')) == null || String.valueOf(sobj.get('MUSW__Renewal_Date__c')) == '') ? '0' : String.valueOf(ceHoursNeeded < 0 ? 0 : ceHoursNeeded);                
            }else{
                this.CEHours = objectName.equals(label.API_License2) ? String.valueOf(sobj.get('CE_Hours__c')) : '';
                this.CEHoursPerCycle = objectName.equals(label.API_License2) ? String.valueOf(sobj.get('CE_Hours_per_Cycle__c')) : '';
                this.CEHoursNeeded = objectName.equals(label.API_License2) ? String.valueOf(sobj.get('CE_Hours_Needed__c')) : '';
            }
                        
            this.RecordId = String.valueOf(sobj.get('Id'));
            SObject project = sobj.getSObject('MUSW__Project2__r');
            this.SiteId = String.valueOf(project != null  ? project.get('Site_Id__c') : '');
            this.ObjectName = objectName;
            this.isBusinessLicense = Boolean.valueOf(sobj.get('Business_License__c'));
            if(Boolean.valueOf(sobj.get('Business_License__c')) == True){
                if(objectName == label.API_License2){
                    SObject account = sobj.getSObject('MUSW__Primary_Licensee__r');
                    this.custID = String.valueOf(account != null  ? account.get('Cust_Id__c') : '');
                }else{
                    SObject account = sobj.getSObject('MUSW__Account__r');
                    this.custID = String.valueOf(account != null  ? account.get('Cust_Id__c') : '');
                }
                
            }else{
                SObject contact = sobj.getSObject('MUSW__Applicant__r');
                this.custID = String.valueOf(contact != null  ? contact.get('Cust_Id__c') : '');
            }
            
            if(answerMap.containsKey(this.RecordId)){
                    LienParties = answerMap.get(this.RecordId);
                    List<String> lstString = answerMap.get(this.RecordId).split(',');
					this.Lienpartynames = lstString;
                }
            
        }
    }
}