/**
* Controller class for application page (ApplyForSobject)
*
* @author      Okwudiafor Akosa
* @version     1.0
* @since       1.0
*
**------------------------------------------------------------------------------------------------------------
** Modification Log:
**------------------
** Developer                 Date              Version     Description
** Okwudiafor Akosa          11/28/17                        Added comments to the class.
**------------------------------------------------------------------------------------------------------------
** Review Log:
**---------------
** Reviewer                  Date           Version               Description
**------------------------------------------------------------------------------------------------------------
**
***************************************************************************************************************/

public virtual class ApplyForSobjectCtlr {
    // Initialize SObject variables
    public SObject lic {get; set;}
    public Contact contactObj {get; set;}
    public Account accountObj {get; set;}
    public MUSW__License2__c licenserec {get; set;}
    public MUSW__Permit2__c permitrec {get; set;}
    public String applicationStatus {get; set;}
    public boolean quicksavecheck;
    
    // To save API calls, for picklists
    // Section variables
    public Integer currentSection {get; set;}
    public Integer nextSection {get; set;}
    // Page name
    public String pageName;
    // Page definition service
    public PageDefService service {get; set;}
    // PDF Download Varibales
    public String renderAs { get; set; }
    public String renderedFileName { get; set;}
    public Boolean pdfrender {get; set;}
    public String str;
    public string evenDate {get; set;}
    public boolean isbackendsub = false;
    /*** Controller configuration* @see ApplyForSObjectConfig*/
    private ApplicationForSObjectConfig.ApplyForSObjectConfig ctlrConfig;
    // Page parameters
    public String licenseType = '';
    public String licenseBy = '';
    public Set<String> allplanreviewsandpermits;
    public Set<String> allcredentials;
    public String applicationType {get; set;}
    //public String applicationState {get; set;}//Added by Sharad - 08/02/2018
    public String credentialType {get; set;}
    public Id reviewedpId =null;
    public String applicationMethod {get; set;}
    public String appType {get; set;}
    public String credential {get; set;}
    public String programArea {get; set;}
    public String serviceRequestType {get; set;}
    public String parentId = '';
    public String existingRecId = '';
    public String existingRecLicenseId = '';
    public String permittype = '';
    public String certificationId = '';
    public String accountId = '';
    // Additional variables   
    public String pageTitle {get; set;}
    public String license_type {get; set;}
    public String contactId {get; set;}
    public String legalText {get; set;}
    public String boardAddress {get; set;}
    public String affidavitLink {get; set;}    
    // Global variables for address operation
    public LicenseAddressOperation licAddResult;
    public PermitAddressOperation permitAddResult;
    public String contextParcelId {get; set;}
    public String contextAddressType {get; set;}
    public String primaryEntityTypeParam {get; set;}    
    // Components
    public QuestionAnswerObj queService {get; set;}
    public PortalAttachmentSection attService {get; set;}
    
    public Employment_History__c empHistObject {get; set;}
    public List<Employment_History__c>  emplHistList{get; set;}
    public Education_History__c eduHistObject {get; set;}
    public List<Education_History__c>  eduHistList{get; set;}
    public License_Verification__c lvfHistObject {get; set;}
    public List<License_Verification__c>  lvfHistList{get; set;}
    public Affiliation__c podaffHistObject {get; set;}
    public  List<Affiliation__c>  podaffHistList {get; set;}
    public Affiliation__c dacaffHistObject {get; set;}
    public  List<Affiliation__c> dacaffHistList {get; set;}
    public Affiliation__c coaffHistObject {get; set;}
    public  List<Affiliation__c> coaffHistList {get; set;}
    public  List<MUSW__Project_Parcel__c> projparcel {get; set;}
    // Instance of a class for global license data
    public LicenseGlobalData licenseGlobalData = new LicenseGlobalData();
    public List<MUSW__License_Parcel__c> licenseAddressList {get; set;}
    public List<MUSW__Permit_Parcel__c> permitAddressList {get; set;}
    // Metadata object
    public License_Type__mdt licensetypemdt;
    
    public string evenDateStr {get; set;}
    
    /***************************************************************************************************
* @Description : To return JSON representation of the page
* @Param       : void
* @Return      : String
***************************************************************************************************/
    public String getPageAsJson() { return service.getAllSectionsSerialized(); }
    
    
    /***************************************************************************************************
* @Description :To return JSON representation of all sections
* @Param       : void
* @Return      : String
***************************************************************************************************/
    public String getAllSectionsAsListSerialized() { return service.getAllSectionsAsListSerialized(); }
    
    
    /***************************************************************************************************
* @Description :To return JSON representation of current record
* @Param       : void
* @Return      : String
***************************************************************************************************/
    public String getCurrentRecordSerialized() { return JSON.serialize(lic); }
    
    
    /***************************************************************************************************
* @Description : To return JSON string of license global data
* @Param       : void
* @Return      : String
***************************************************************************************************/
    public String getLicenseGlobalDataAsJson() {
        return JSON.serialize(licenseGlobalData);
    }
    
    /***************************************************************************************************
* @Description :   To return record type Id based on functionalarea and license type
* @Param       : String,String,String
* @Return      : String
***************************************************************************************************/
    public  String findRecordTypeIdForBoardAndLicenseType(String functionalarea, String type, String objectName) {
        if (label.Str_plan_review == applicationType||applicationType ==Label.Str_Manufactured_Homes_Communities||label.Str_ManufacturedHomesRenewal  == applicationType) {
            // Query record type
            licensetypemdt = [SELECT Id,  Label, Permit_Type__c,
                              Record_type_Name__c, Object_Name__c
                              FROM License_Type__mdt
                              WHERE Program_Area__c = :programarea
                              AND permit_Type__c = :permittype
                              AND Object_Name__c = :objectName limit 1];
        } else if(label.Str_Service_Request == applicationType) {
            // Query record type
            for(License_Type__mdt licMdt : [SELECT Id, Label, Credential_Type__c,
                                            Record_type_Name__c, Object_Name__c, Application_Type__c
                                            FROM License_Type__mdt
                                            WHERE Object_Name__c = :objectName limit 1]){
                                                
                                                licensetypemdt = licMdt;
                                                if(licMdt.Application_Type__c == serviceRequestType){
                                                    break;
                                                }
                                            }
        }else {
            // Query record type
            licensetypemdt = [SELECT Id, Label, Credential_Type__c,
                              Record_type_Name__c    , Object_Name__c
                              FROM License_Type__mdt
                              WHERE Credential_Type__c = :credentialtype
                              AND Credential__c  = :credential
                              AND Object_Name__c = :objectName limit 1];
        }
        // Return
        system.debug('!!!recordtype : ' + Utilities.getRecordTypeForName(licensetypemdt.Object_Name__c, licensetypemdt.Record_type_Name__c ));
        return Utilities.getRecordTypeForName(licensetypemdt.Object_Name__c, licensetypemdt.Record_type_Name__c );
    }
    
    
    /***************************************************************************************************
* @Description :  To get contact Id
* @Param       : void
* @Return      : void
***************************************************************************************************/
    public void getContact() {
        // Get contact id
        try {
            contactId = [Select contactId from user where id = : UserInfo.getUserId()].contactId;
            system.debug('contactId---'+contactId);
        } catch (Exception e) {
            System.debug('e '+e.getMessage());      
        }
    }
    
    
    
    /***************************************************************************************************
* @Description :  Constructor
* @Param       : void
* @Return      : void
***************************************************************************************************/
    public ApplyForSobjectCtlr() {
        Datetime myDT = Datetime.now();
        quicksavecheck = false;
        evenDateStr = string.valueof(myDT.format());
        queService = new QuestionAnswerObj('', '', '', '', '', '', '');
        str = ApexPages.currentPage().getParameters().get('pdfrender');
        string backstr= ApexPages.currentPage().getParameters().get('backendlic');
        if(backstr!=null)
            isbackendsub=boolean.valueof(backstr);        
        licenserec = new MUSW__License2__c();
        permitrec = new Musw__permit2__c();
        if (str != null)
            pdfrender = true;
        allplanreviewsandpermits =Utilities.getallPlanreviewsandpermits();
        allcredentials =Utilities.getallCredentials();
        existingRecId = ApexPages.currentPage().getParameters().get('pid');
        //applicationType = ApexPages.currentPage().getParameters().get('applicationType');
        if(existingRecId != null) {
            licenseGlobalData.licenseId = existingRecId; 
        }
        system.debug('licenseGlobalData.licenseId from constr :'+licenseGlobalData.licenseId);
        system.debug('existingRecId from constr :'+existingRecId);
        // Primary execution sequence
        primarySequence();
        if (existingRecId != null &&allcredentials.contains(applicationType) ) {
            licenserec = [select id, MUSW__Status__c, App_Submitted_Date__c from MUSW__License2__c where id = : existingRecId];
            applicationStatus = licenserec.MUSW__Status__c;
        } else if (existingRecId != null &&allplanreviewsandpermits.contains(applicationType)) {
            permitrec = [Select id, MUSW__Status__c, App_Submitted_Date__c from Musw__permit2__c where id = : existingRecId];
            applicationStatus = permitrec.MUSW__Status__c;
        } else if (existingRecId != null && (applicationType ==label.RNT_Renewal || applicationType == label.RNT_Reinstatement || applicationType == label.RNT_ReinstatementPlanReview || applicationType ==label.RNT_RenewalPlanReview) ) {
            Renewal_Application__c licRenRec = [Select id, Renewal_Status__c from Renewal_Application__c where id = :existingRecId];
            applicationStatus = licRenRec.Renewal_Status__c;
        }
        if (existingRecId != null) { editApplicationSequence(); }
        
        // New application
        else { newApplicationSequence(); }
    }
    
    /***************************************************************************************************
* @Description :  Execute primary sequence in constructor
* @Param       : void
* @Return      : void
***************************************************************************************************/
    public void primarySequence() {
        
        // Set current section
        this.currentSection = 1;
        // Get page getParameters
        getURLParameters();
        // Instantiate config class for the controller
        ctlrConfig = ApplicationForSObjectConfig.factoryMethod(applicationType);
         
        try {
           ctlrConfig.getBoardLicenseType(this);
        } catch (Exception e) {  }
        getContact();
        try{
            ctlrConfig.getExistingRecord(this);
        }catch (Exception e) {
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()) );
        }
        try{
           ctlrConfig.setBoardLicenseType(this); 
        }catch(Exception ex){}
        
        pageTitle = ctlrConfig.setPageTitle();
        if(applicationType == Label.Str_Service_Request){
            pageTitle = pageTitle + ' - ' + serviceRequestType;
            pageTitle = serviceRequestType;
        }
        
        license_type = credentialType;
        
        // Instantiate contact object
        contactObj =  new Contact();
        // Instantiate account object
        accountObj = new Account();
        // Build page service object
        createPageService();
        // Set license global data        
        setGlobalLicenseData();
        // Instantiate components
        instantiateComponents();
        
        // Get legal text
        getLegalText();
        // Get contact record
        getContactRecord();
        // Get account record
        getAccountRecord();
    }
    
    /***************************************************************************************************
* @Description : To return JSON representation of all attachments
* @Param       : void
* @Return      : String
***************************************************************************************************/
    public String getAttachmentsSerialized() {    
        if (attService != null) {
            return (String)JSON.serialize(this.attService.attachmentList);
        } else {
            return null;
        }
    } 
    
    /***************************************************************************************************
* @Description :  Action method to save (or "print") to PDF
* @Param       : void
* @Return      : PageReference
***************************************************************************************************/
    public PageReference saveToPdf() {
        system.debug('Entered savetoPDF');
        String evenDate =  Datetime.now().format();
        PageReference pageRef ;
        if (existingRecId != null && !string.isblank(existingRecId)) {
            if(parentId!=null&&parentId!=''){
                pageRef = new PageReference('/apex/SaveIncompleteApplication?applicationMethod=' + applicationMethod + '&applicationType=' + applicationType + '&pid=' + lic.id+ '&parentId='+parentId);
            } else{
                pageRef = new PageReference('/apex/SaveIncompleteApplication?applicationType=' + applicationType + '&pid=' + existingRecId);
                system.debug('Entered If loop>>>'+pageRef);
            }
        } else {
            if (lic.id == null || !quicksavecheck)
                saveRecord();
            system.debug('parentId>>>'+parentId);
            if(parentId!=null&&parentId!='')
                pageRef = new PageReference('/apex/SaveIncompleteApplication?applicationMethod=' + applicationMethod + '&applicationType=' + applicationType + '&pid=' + lic.id+ '&parentId='+parentId);
            else 
                pageRef = new PageReference('/apex/SaveIncompleteApplication?applicationType=' + applicationType + '&pid=' + lic.id);
            system.debug('Entered Else loop>>>'+pageRef);
        }
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    
    
    /***************************************************************************************************
* @Description : Execute edit application sequence
* @Param       : void
* @Return      : void
***************************************************************************************************/
    public void editApplicationSequence() {
        existingRecId = String.escapeSingleQuotes(existingRecId);
        getCurrentRecord();
    }
    
    /***************************************************************************************************
* @Description : Execute new application sequence
* @Param       : void
* @Return      : void
***************************************************************************************************/
    public void newApplicationSequence() {
        // Initialize license record
        
        lic=ctlrConfig.createInstance();
        // Get record type
        try {
            ctlrConfig.setRecordTypeField(this);
        } catch (Exception e) {
            System.debug('e '+e.getMessage());
            // Build config error message
            String msg = 'Check the LicenseTypeList__mdt object. Invalid configuration for: ' +
                'Credential Type/Program Area: ' + credentialType==''?programArea:credentialType + ', Credential/Permit type: ' + credential==''?permitType:credential + ', Object: ' + ctlrConfig.getObjectName();
            
            // Add error on page
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, msg) );
        }
    }
    
    
    /***************************************************************************************************
* @Description : Get parameters from page url
* @Param       : void
* @Return      : void
***************************************************************************************************/
    public void getURLParameters() {
        credentialType = ApexPages.currentPage().getParameters().get('credentialType');
        String revisionid=ApexPages.currentPage().getParameters().get('reviewedpId');
        reviewedpId = revisionid!=null&&revisionid!=''?Id.valueOf(revisionid):null;
        credential = ApexPages.currentPage().getParameters().get('credential');
        programArea = ApexPages.currentPage().getParameters().get('programArea'); 
        permitType = ApexPages.currentPage().getParameters().get('permitType');
        applicationMethod = ApexPages.currentPage().getParameters().get('applicationMethod');       
        applicationType = ApexPages.currentPage().getParameters().get('applicationType');       
        parentId = ApexPages.currentPage().getParameters().get('parentId');        
        accountId = ApexPages.currentPage().getParameters().get('accountId');
        existingRecId = ApexPages.currentPage().getParameters().get('pid');
        serviceRequestType = ApexPages.currentPage().getParameters().get('srType');
        pageName = ApexPages.currentPage().getUrl();
        appType = ApexPages.currentPage().getParameters().get('appType');       
        
    }
    
    /***************************************************************************************************
* @Description : Set global license data
* @Param       : void
* @Return      : void
***************************************************************************************************/
    public void setGlobalLicenseData() {
        // Set the values for the global data
        licenseGlobalData.programArea = programArea;
        licenseGlobalData.permittype = permittype;
        licenseGlobalData.credential = credential;
        licenseGlobalData.credentialType = credentialType;
        licenseGlobalData.applicationType = applicationType;
        licenseGlobalData.contactId = contactId;
        licenseGlobalData.serviceRequestType = serviceRequestType;
        licenseGlobalData.gotoscheduler=false;
    }
    
    
    /***************************************************************************************************
* @Description :Get Contact object record
* @Param       : void
* @Return      : void
***************************************************************************************************/
    public void getContactRecord() {
        try {
            // Query Contact object
            contactObj =ApplyforSobjectHelper.findContact(service,contactId);
            licenseGlobalData.contactFirstName = contactObj.FirstName;
            licenseGlobalData.contactLastName = contactObj.LastName;
        } catch (Exception e) {
            ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'ApplyForSObjectCtlr', 'General Exception', 'getContactRecord', 'ApplyForSObjectCtlr', label.Str_Low);
        }
    }
    
    
    
    /***************************************************************************************************
* @Description :Get Account object record
* @Param       : void
* @Return      : void
***************************************************************************************************/
    public void getAccountRecord() {
        
        // Execute only if we have account Id
        if (accountId != null) {
            try {
                accountObj=ApplyforSobjectHelper.findAccount(service,accountId);
                licenseGlobalData.accountId = accountObj.Id;
            } catch (Exception e) {
                ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'ApplyForSObjectCtlr', 'General Exception', 'getAccountRecord', 'ApplyForSObjectCtlr', label.Str_Low);
            }
        }
    }
    
    
    /***************************************************************************************************
* @Description :Instantiate page definition service
* @Param       : void
* @Return      : void
***************************************************************************************************/
    public void createPageService() {
        if (allcredentials.contains(applicationType)) this.service = new PageDefService(Credentialtype, Credential, PageDefService.ApplicationType.License,applicationtype);
        if ( allplanreviewsandpermits.contains(applicationType)) this.service = new PageDefService(ProgramArea, permittype, PageDefService.ApplicationType.Permit,applicationtype);
        if ( applicationType == Label.Str_Service_Request) this.service = new PageDefService(Credentialtype, Credential, PageDefService.ApplicationType.ServiceRequest,applicationtype,serviceRequestType);
        if ( applicationType == Label.RNT_Renewal) this.service = new PageDefService(Credentialtype, Credential, PageDefService.ApplicationType.Renewal,applicationtype);
        if ( applicationType == Label.RNT_Reinstatement) this.service = new PageDefService(Credentialtype, Credential, PageDefService.ApplicationType.Reinstatement,applicationtype);
        if ( applicationType == Label.Str_ManufacturedHomesRenewal ) this.service = new PageDefService(ProgramArea, permittype, PageDefService.ApplicationType.PermitRenewal,applicationtype);        
    }
    
    /**
* Method - Get legal text, functionalarea address and affidavit link
* @return    void
*/
    public void getLegalText() {
        try {
            
            // Legal text
            legalText = ctlrConfig.getLegalText(this);       
            // Affidavit link
            affidavitLink = ctlrConfig.getAffidavitLink(this);
        } catch (Exception e) {
            System.debug('Exception ' + e);
        }
    }
    
    
    /***************************************************************************************************
* @Description :Get current main object record
* @Param       : void
* @Return      : void
***************************************************************************************************/
    public virtual void getCurrentRecord() {
        // Build query
        String query = 'SELECT Id,Attestation__c, AttestationFullName__c'
            + service.pageObj.getAllFieldsAsString()+
            ctlrConfig.getCurrentRecordWhereClause();
        // Execute query and get list;
        system.debug('query123'+query);
        List<SObject> sobjList = Database.query(query);
        
        // Set the first one as current record
        lic = sobjList.get(0);
        
        // Set global parameters
        licenseGlobalData.currentRecId = (String)lic.get('Id');
        if (allcredentials.contains(applicationType)) { licenseGlobalData.licenseId = (String)lic.get('Id'); }
        if (allplanreviewsandpermits.contains(applicationType)) {licenseGlobalData.permitId = (String)lic.get('Id');}
    }
    
    
    /***************************************************************************************************
* @Description : To return JSON representation of all questions-answers
* @Param       : void
* @Return      : String
***************************************************************************************************/
    public String getQuestionsSerialized() {
        if (queService != null) {
            return (String)JSON.serialize(this.queService.questionsList);
        } else {
            return null;
        }
    }
    
    /***************************************************************************************************
* @Description :  To return JSON representation of all Answers that need to be deleted when a question is expired
* @Param       : void
* @Return      : String
***************************************************************************************************/
    public string getdeleteExpiredAnswers() {
        if (queService != null) {
            
            return (String)JSON.serialize(this.queService.answerList_ToBeDeleted);
        } else {
            return NULL;
        }
    }
    /***************************************************************************************************
* @Description : Initialize objects of visualforce components
* @Param       : void
* @Return      : void
***************************************************************************************************/
    public void instantiateComponents() {
        
        // Initialize
        this.emplHistList = new List<Employment_History__c>();
        this.eduHistList = new List<Education_History__c>();
        this.podaffHistList = new List<Affiliation__c>();
        this.dacaffHistList = new List<Affiliation__c>();
        this.lvfHistList = new List<License_Verification__c>();
        
        // To save API calls, for picklists
        empHistObject = new Employment_History__c();
        empHistObject.RecordTypeId=Utilities.getRecordTypeForName(Label.API_Employment_History,'Default Employment History');  
        podaffHistObject = new Affiliation__c();
        podaffHistObject.RecordTypeId=Utilities.getRecordTypeForName(Label.API_Affiliation,'POWTS Affiliation'); 
        dacaffHistObject = new Affiliation__c();
        dacaffHistObject.RecordTypeId=Utilities.getRecordTypeForName(Label.API_Affiliation,'Delegated Agent Affiliation'); 
        coaffHistObject = new Affiliation__c();
        coaffHistObject.RecordTypeId=Utilities.getRecordTypeForName(Label.API_Affiliation,'Manufactured Homes Titling Affiliation'); 
        eduHistObject = new Education_History__c();      
        lvfHistObject = new License_Verification__c();
        
        // Load components
        if (existingRecId != null && !(string.isblank(existingRecId))) {  
            
            // Get the license id for the current record
            if (allcredentials.contains(applicationType)) {
                //  existingRecLicenseId = existingRecId;
            } else if (applicationType ==label.RNT_Renewal|| applicationType == label.Str_ManufacturedHomesRenewal  ) {                
                // Renewal_Application__c renewal = [SELECT Id, License__c FROM Renewal_Application__c WHERE Id = : existingRecId LIMIT 1];
                //  existingRecLicenseId = renewal.License__c;
            } else if (label.Str_PTO == applicationType||label.Str_Plan_Review == applicationType||applicationType ==Label.Str_Manufactured_Homes_Communities ) { 
                
            }
            
            
            
            
            // Questions            
            if(serviceRequestType != null && serviceRequestType != ''){
                this.queService = new QuestionAnswerObj(applicationType, credentialType, credential, applicationMethod, ctlrConfig.getQuestionObjectLookup(), existingRecId, serviceRequestType);
            }
            else if(allcredentials.contains(applicationType)||
                    applicationtype==Label.RNT_Renewal||
                    applicationType==Label.RNT_Reinstatement){
                        this.queService = new QuestionAnswerObj(applicationType, credentialType, credential, applicationMethod, ctlrConfig.getQuestionObjectLookup(), existingRecId);
                        System.debug('instantiation::'+ this.queService);   
                    }
            else {
                this.queService = new QuestionAnswerObj(applicationType, programarea, permittype, applicationMethod, ctlrConfig.getQuestionObjectLookup(), existingRecId);
            }
        }
        system.debug('licenseGlobalData.licenseId :'+licenseGlobalData.licenseId);
        if (licenseGlobalData.licenseId != null) { // Examination history
            // Employment history
            try {
                String empHistQuery = 'SELECT Id, City__c, Contact__c,Employer__c,Street_Address__c, County__c, Country__c, End_date__c, Current__c, License__c,Renewal_Reinstatement_Application__c, Job_Title__c, Permit__c, Start_Date__c, Supervisor_Job_Title__c, State__c, Supervisor_Name__c, Supervisor_Phone_Number__c, Zip_code__c,Total_Hours__c FROM Employment_History__c where License__c=\'' + licenseGlobalData.licenseId + '\' Order by Name ASC LIMIT 1000';
                this.emplHistList = Database.query(empHistQuery);
            } catch (Exception e) {
                System.debug('e '+e.getMessage());
                
            }
            try {
                List<Education_History__c> edulist = new List<Education_History__c>();
                String eduHistQuery = 'SELECT State__c,Country__c,Major__c,Minor__c,Permit__c,Other__c, License__c,Renewal_Reinstatement_Application__c, Educational_Institution__c,Educational_Institution__r.Name,Education_Program__r.Name, Education_Program__c,Contact__c, Name_of_Institution__c, Start_Date__c, Degree__c, End_date__c, Id, Name FROM Education_History__c where License__c=\'' + licenseGlobalData.licenseId  + '\' Order by Name ASC LIMIT 1000';
                
                this.eduHistList = Database.query(eduHistQuery);                
                
            } catch (Exception e) {
                System.debug('e '+e.getMessage());
            }
            try {
                String lvfHistQuery = 'SELECT Id, State__c, Country__c, Credential__c, Credential_Type__c,Verified__C, Credential_Number__c, Expiration_Date__c, Status__c,License__c FROM License_Verification__c where License__c=\'' + licenseGlobalData.licenseId  + '\' Order by Name ASC LIMIT 1000';
                this.lvfHistList = Database.query(lvfHistQuery);
            } catch (Exception e) {
                System.debug('e '+e.getMessage());
            }
            try {
                String dacaffHistQuery = 'SELECT Permit_Plan_Review__c, Company__c, Service_Request__c, Credential_Name__c, Application_Type__c, Contact_s_City__c, End_date__c, Start_Date__c, Type__c, Status__c, Contact_s_Zip_code__c, Contact_s_state__c, Contact_s_Street_Address__c, Contact_s_Email__c, Contact_s_Phone__c, Credential__c, Contact_s_Name__c, Contact_s_Credential_Number__c,Type_of_Co_owner__c,Contact_s_Last_Name__c, Contact_s_Middle_Name__c,Id FROM Affiliation__c where credential__c=\'' + licenseGlobalData.licenseId  + '\' and recordtypeId=\'' + dacaffHistObject.recordtypeId  + '\' Order by Name ASC LIMIT 1000';
                this.dacaffHistList = Database.query(dacaffHistQuery);
            } catch (Exception e) {
                System.debug('e '+e.getMessage());
            }
            try {
                String coaffHistQuery = 'SELECT Permit_Plan_Review__c, Company__c, Service_Request__c, Credential_Name__c, Application_Type__c, Contact_s_City__c, End_date__c, Start_Date__c, Type__c, Status__c, Contact_s_Zip_code__c, Contact_s_state__c, Contact_s_Street_Address__c, Contact_s_Email__c, Contact_s_Phone__c, Credential__c, Contact_s_Name__c, Contact_s_Credential_Number__c,Type_of_Co_owner__c,Contact_s_Last_Name__c, Contact_s_Middle_Name__c,Id FROM Affiliation__c where credential__c=\'' + licenseGlobalData.licenseId  + '\' and recordtypeId=\'' + coaffHistObject.recordtypeId  + '\' Order by Name ASC LIMIT 1000';
                this.coaffHistList = Database.query(coaffHistQuery);
            } catch (Exception e) {
                System.debug('e '+e.getMessage());
            }
        }
        
        if(licenseglobaldata.permitId!=null)
        {
            try {
                String podaffHistQuery = 'SELECT Permit_Plan_Review__c, Company__c, Service_Request__c, Credential_Name__c, Application_Type__c, Contact_s_City__c, End_date__c, Start_Date__c, Type__c, Status__c, Contact_s_Zip_code__c, Contact_s_state__c, Contact_s_Street_Address__c, Contact_s_Email__c, Contact_s_Phone__c, Credential__c, Contact_s_Name__c, Contact_s_Credential_Number__c,Type_of_Co_owner__c,Contact_s_Last_Name__c, Contact_s_Middle_Name__c, Id FROM Affiliation__c where Permit_Plan_Review__c=\'' + licenseGlobalData.permitId  + '\'  and recordtypeId=\'' + podaffHistObject.recordtypeId  + '\' Order by Name ASC LIMIT 1000';
                this.podaffHistList = Database.query(podaffHistQuery);
            } catch (Exception e) {
                System.debug('e '+e.getMessage());
            }
            
            try {
                String permQuery = 'SELECT Id, MUSW__Project2__c FROM Musw__Permit2__c where Id=\'' + licenseGlobalData.permitId  + '\'   and MUSW__Project2__c!=null Order by Name ASC LIMIT 1000';
                Musw__Permit2__c permits = Database.query(permQuery);
                if(permits!=null){
                    MUSW__Permit_Parcel__c permparc=[Select id,MUSW__Parcel__c from MUSW__Permit_Parcel__c where MUSW__Permit2__c=:licenseGlobalData.permitId and Site__c=true limit 1];
                    this.projparcel=  [Select id,MUSW__Parcel__c ,MUSW__Project2__C,MUSW__Project2__r.County_Name__c ,MUSW__Project2__r.Name,MUSW__Project2__r.MUSW__Description__c ,MUSW__Project2__r.Municipality_Type__c,MUSW__Project2__r.Municipality_Name__c,MUSW__Project2__r.Site_Id__c,MUSW__Parcel__r.MUSW__Street2__c from MUSW__Project_Parcel__c where MUSW__Project2__c=:permits.MUSW__Project2__c and MUSW__Parcel__c=:permparc.MUSW__Parcel__c];

                    //and MUSW__Parcel__c=:permparc.MUSW__Parcel__c
                    //MUSW__Permit_Parcel__c permparc=[Select id,MUSW__Parcel__c from MUSW__Permit_Parcel__c where MUSW__Permit2__c=:licenseGlobalData.permitId and Site__c=true limit 1];
                    //this.projparcel=  [Select id,MUSW__Parcel__c ,MUSW__Project2__C,MUSW__Project2__r.County_Name__c ,MUSW__Project2__r.Name,MUSW__Project2__r.MUSW__Description__c ,MUSW__Project2__r.Municipality_Type__c,MUSW__Project2__r.Municipality_Name__c,MUSW__Project2__r.Site_Id__c,MUSW__Parcel__r.MUSW__Street2__c from MUSW__Project_Parcel__c where MUSW__Project2__c=:permits.MUSW__Project2__c ];
                }
            } catch (Exception e) {
                System.debug('e '+e.getMessage());
            }
        }
        
    }
    
    
    /***************************************************************************************************
* @Description : Build a section for the pageName and currentSection number
* @Param       : void
* @Return      : Component.Apex.Detail
***************************************************************************************************/
    public Component.Apex.Detail getsections(){
        
        // If current section is 0, show review panel
        if ( currentSection == 0 ) {
            return new Component.Apex.Detail();
        }
        
        // DOM element to which dynammic markup will be injected
        Component.Apex.Detail detail = new Component.Apex.Detail();
        
        // Loop through each section
        for (PageDefService.SectionObj sectionObj : service.PageObj.sectionObjMap.values()) {
            
            // Markup for section container
            Component.c.PageSectionComp customSec = new Component.c.PageSectionComp();
            customSec.sectionOrder = sectionObj.orderNumber;
            detail.childComponents.add(customSec);
            
            // Markup for sub-section container
            Component.Apex.Detail subDetail = new Component.Apex.Detail();
            
            // Sub-Section builder
            for (PageDefService.SubSectionObj subSectionObj : sectionObj.subSectionObjMap.values()) {
                // If fieldset
                if (subSectionObj.sType == 'Fieldset') {
                    Component.c.PageSubSectionComp customComp =  ApplyforSobjectHelper.fieldSetComponentCreator(subSectionObj, accountObj,contactObj, lic, Applicationtype, existingRecId,parentid) ; 
                    subDetail.childComponents.add(customComp);
                }
                // If component
                else if (subSectionObj.sType == 'Component') {
                    if (subSectionObj.componentName == 'ReviewAndSubmitNoAffidavit') {
                        System.debug('Inside Review and Submit');
                        Component.c.ReviewAndSubmitNoAffidavit comp1 = new Component.c.ReviewAndSubmitNoAffidavit();
                        comp1.currRecord = lic;
                        comp1.contactRecord = contactObj;
                        System.debug('queService::'+queService);
                        comp1.queList2 = queService;
                        if (contactObj.FirstName != null) {
                            comp1.AttestationFirstName = (contactObj.FirstName).trim();
                        }
                        comp1.AttestationLastName = (contactObj.LastName).trim();
                        if (legalText != null)
                            comp1.legalText = legalText;
                        if (affidavitLink != null)
                            comp1.affidavitLink = affidavitLink;
                        subDetail.childComponents.add(comp1);                     
                    } 
                    else if (subSectionObj.componentName == 'EmploymentHistoryComp') {
                        Component.c.EmploymentHistoryComp comp1 = new Component.c.EmploymentHistoryComp();
                        comp1.empHistoryList = JSON.serialize(this.emplHistList);
                        comp1.compLabel = subSectionObj.name;
                        if (subSectionObj.description != null)
                            comp1.compDesc = subSectionObj.description;
                        comp1.empHistObject = empHistObject;
                        subDetail.childComponents.add(comp1);
                    }
                    else if (subSectionObj.componentName == 'TrainingHistoryComp') {
                        Component.c.TrainingHistoryComp comp1 = new Component.c.TrainingHistoryComp();
                        comp1.empHistoryList = JSON.serialize(this.emplHistList);
                        comp1.compLabel = subSectionObj.name;
                        if (subSectionObj.description != null)
                            comp1.compDesc = subSectionObj.description;
                        comp1.empHistObject = empHistObject;
                        subDetail.childComponents.add(comp1);
                    }
                    else if (subSectionObj.componentName == 'ProjectInformationComponent') {
                        Component.c.ProjectInformationComponent comp1 = new Component.c.ProjectInformationComponent();
                        comp1.ProjectSiteList = JSON.serialize(this.projparcel);
                        comp1.compLabel = subSectionObj.name;
                        if (subSectionObj.description != null)
                            comp1.compDesc = subSectionObj.description;
                        comp1.siteObject = new Musw__project2__C();
                        subDetail.childComponents.add(comp1);
                    }
                    else if (subSectionObj.componentName == 'EducationHistoryComp') {
                        Component.c.EducationHistoryComp comp1 = new Component.c.EducationHistoryComp();
                        comp1.eduHistoryList = JSON.serialize(this.eduHistList);
                        comp1.compLabel = subSectionObj.name;
                        if (subSectionObj.description != null)
                            comp1.compDesc = subSectionObj.description;
                        comp1.eduHistObject = eduHistObject;
                        subDetail.childComponents.add(comp1); 
                    }
                    else if (subSectionObj.componentName == 'LicenseVerificationComp') {
                        Component.c.LicenseVerificationComp comp1 = new Component.c.LicenseVerificationComp();
                        comp1.lvfHistoryList = JSON.serialize(this.lvfHistList);
                        comp1.compLabel = subSectionObj.name;
                        if (subSectionObj.description != null)
                            comp1.compDesc = subSectionObj.description;
                        comp1.lvfHistObject = lvfHistObject;
                        subDetail.childComponents.add(comp1);
                    }
                    else if (subSectionObj.componentName == 'POWTSOwnerDesigner') {
                        Component.c.POWTSOwnerDesigner comp1 = new Component.c.POWTSOwnerDesigner();
                        comp1.BusinessOwnerList = JSON.serialize(this.podaffHistList);
                        comp1.compLabel = subSectionObj.name;
                        if (subSectionObj.description != null)
                            comp1.compDesc = subSectionObj.description;
                        comp1.affiliationObject = podaffHistObject;
                        subDetail.childComponents.add(comp1);
                    }
                    else if (subSectionObj.componentName == 'DelegatedAgentComponent') {
                        Component.c.DelegatedAgentComponent comp1 = new Component.c.DelegatedAgentComponent();
                        comp1.DesignatedAgentList = JSON.serialize(this.dacaffHistList);
                        comp1.compLabel = subSectionObj.name;
                        if (subSectionObj.description != null)
                            comp1.compDesc = subSectionObj.description;
                        comp1.affiliationObject = dacaffHistObject;
                        subDetail.childComponents.add(comp1);
                    }
                    else if (subSectionObj.componentName == 'CoownershipComponent') {
                        Component.c.CoownershipComponent comp1 = new Component.c.CoownershipComponent();
                        comp1.coOwnershipList = JSON.serialize(this.coaffHistList);
                        comp1.compLabel = subSectionObj.name;
                        if (subSectionObj.description != null)
                            comp1.compDesc = subSectionObj.description;
                        comp1.affiliationObject = coaffHistObject;
                        subDetail.childComponents.add(comp1);
                    }
                    else if (subSectionObj.componentName == 'BusinessAddress') {
                        Component.c.BusinessAddress addrsComp = new Component.c.BusinessAddress();
                        addrsComp.subSectionName = subSectionObj.name;
                        addrsComp.subSectionDesc = subSectionObj.Description;
                        
                        if (subSectionObj.name.containsIgnoreCase('public')) {
                            addrsComp.BusinessAddressType = 'Public' ;
                        } else if (subSectionObj.name.containsIgnoreCase('mailing')) {
                            addrsComp.BusinessAddressType = 'Mailing' ;
                        }
                        else if (subSectionObj.name.containsIgnoreCase('physical')) {
                            addrsComp.BusinessAddressType = 'Physical' ;
                            } else if (subSectionObj.name.containsIgnoreCase('primary')) {
                            addrsComp.BusinessAddressType = 'Primary' ;
                         }
                        
                        addrsComp.ShowLeftPanel = true ;
                        addrsComp.ShowAddressList = true ;
                        addrsComp.ShowAddAddressButton = true ;
                        addrsComp.RefreshAddressListOnSave = true ;
                        addrsComp.IncludeSingleSelectTypeCheckBox = true ;
                        addrsComp.EnableDelete = true ;
                        addrsComp.ShowSaveAddressAsButton = true ;
                        addrsComp.IncludeUseThisAddressAsCheckBox = true ;
                        addrsComp.JavascriptHandlerOnSaveAsClick = 'licenseQuickSaveForAddress';
                        addrsComp.AddressListColumns = 'AddressName,Address';
                        addrsComp.Id = 'generic_business_address_' +  addrsComp.BusinessAddressType ;
                        addrsComp.BusinessAddressListColWidthDefination = 'col-sm-0,col-sm-2,col-sm-0,col-sm-3,col-sm-5,col-sm-1' ;
                        if (licenseGlobalData.accountId != null ) {
                            addrsComp.AccountId = licenseGlobalData.accountId ;
                            addrsComp.EnableAutoLinkingWithAccount = true ;
                            addrsComp.PrimaryEntityType = 'Account' ;
                        } else if (licenseGlobalData.contactId != null ) {
                            addrsComp.ContactId = licenseGlobalData.contactId ;
                            addrsComp.EnableAutoLinkingWithContact = true ;
                            addrsComp.PrimaryEntityType = 'Contact' ;
                        }
                        
                        // Edit mode
                        if (licenseGlobalData.licenseId  != null) {
                            addrsComp.ComponentUsage = 'LicenseApplication';
                            addrsComp.LicenseId = licenseGlobalData.licenseId ;
                            addrsComp.ExecutionMode = 'Edit' ;
                        }
                        
                        if (licenseGlobalData.permitId  != null) {
                            addrsComp.ComponentUsage = 'PermitApplication';
                            addrsComp.permitId = licenseGlobalData.permitId ;
                            addrsComp.ExecutionMode = 'Edit' ;
                        }
                        
                        subDetail.childComponents.add(addrsComp);
                    }
                    else if (subSectionObj.componentName == 'QuestionAnswer') {
                        Component.c.QuestionAnswer comp1 = new Component.c.QuestionAnswer();
                        comp1.subSectionName = subSectionObj.name;
                        if (subSectionObj.description != null)
                            comp1.subSectionDesc = subSectionObj.description;
                        comp1.lookupFieldName = ctlrConfig.getQuestionObjectLookup();
                        comp1.objectName = ctlrConfig.getObjectName();
                        subDetail.childComponents.add(comp1);
                    }
                    else if (subSectionObj.componentName == 'LegalBackgroundquestionanswer') {
                        Component.c.LegalBackgroundquestionanswer comp1 = new Component.c.LegalBackgroundquestionanswer();
                        comp1.subSectionName = subSectionObj.name;
                        if (subSectionObj.description != null)
                            comp1.subSectionDesc = subSectionObj.description;
                        comp1.lookupFieldName = ctlrConfig.getQuestionObjectLookup();
                        comp1.objectName = ctlrConfig.getObjectName();
                        subDetail.childComponents.add(comp1);
                    }
                    else if (subSectionObj.componentName == 'AttachmentsComp') {
                        Component.c.AttachmentsComp attCcomp = new Component.c.AttachmentsComp();
                        attCcomp.subSectionName = subSectionObj.name;
                        if (subSectionObj.description != null)
                            attCcomp.subSectionDesc = subSectionObj.description;
                        attCcomp.lookupFieldName = ctlrConfig.getAttachmentObjectLookup();
                        subDetail.childComponents.add(attCcomp);
                    }
                    else if (subSectionObj.componentName == 'SRParentRecordDetails') {
                        Component.c.SRParentRecordDetails srParentComp = new Component.c.SRParentRecordDetails();
                        srParentComp.compLabel = subSectionObj.name;
                        if (subSectionObj.description != null)
                            srParentComp.compDesc = subSectionObj.description;
                        
                        String parentObjectName = '';
                        String parentName = '';
                        String parentType = '';
                        String parentStatus = '';
                        String parentSubStatus = '';
                        String applicantName = '';
                        Id parentRecId = (Id) parentId;
                        if(parentRecId.getsObjectType().getDescribe().getName() == Label.API_License2){
                            MUSW__License2__c lic = [Select Id, Name, Credential_Type__c, MUSW__Status__c, Sub_Status__c, Applicant_Full_Name__c From MUSW__License2__c where Id = :parentRecId];
                            parentObjectName = 'Credential';
                            parentName = lic.Name;
                            parentType = lic.Credential_Type__c;
                            parentStatus = lic.MUSW__Status__c;
                            parentSubStatus = (lic.Sub_Status__c == null ? '' : lic.Sub_Status__c);
                            applicantName = lic.Applicant_Full_Name__c;
                        }else if(parentRecId.getsObjectType().getDescribe().getName() == Label.API_Permit){
                            MUSW__Permit2__c per = [Select Id, Name, Permit_Type__c, MUSW__Status__c, Sub_Status__c, Applicant_Full_Name__c From MUSW__Permit2__c where Id = :parentRecId];
                            parentObjectName = 'Permit';
                            parentName = per.Name;
                            parentType = per.Permit_Type__c;
                            parentStatus = per.MUSW__Status__c;
                            parentSubStatus = (per.Sub_Status__c == null ? '' : per.Sub_Status__c);
                            applicantName = per.Applicant_Full_Name__c;
                        }
                        srParentComp.parentObjectName = parentObjectName;
                        srParentComp.parentName = parentName;
                        srParentComp.parentType = parentType;
                        srParentComp.parentStatus = parentStatus;
                        srParentComp.parentSubStatus = parentSubStatus;
                        srParentComp.applicantName = applicantName;
                        
                        subDetail.childComponents.add(srParentComp);
                    }
                }
                
                // Add sub-detail to sub-section container
                customSec.childComponents.add(subDetail);
            }
        }
        return detail;
    }
    
    
    /***************************************************************************************************
* @Description :   To find out if fee is required or not
* @Param       : void
* @Return      : String
***************************************************************************************************/
    public void getFeeRequirement() {
        
        //todo
        licenseGlobalData.noFeeRequired = true;        
        if(applicationType == Label.Str_Service_Request){
            
            List<Service_Links__mdt> srLinks = [Select Id, Payment_Required__c From Service_Links__mdt where credential__c = :licenseGlobalData.credential and Service_Request_Type__c = :licenseGlobalData.serviceRequestType];
            if(srLinks.size() > 0){
                licenseGlobalData.noFeeRequired = !(srLinks[0].Payment_Required__c);
                licenseGlobalData.isInvoiceRequired = false;
            }
        }
        else{
            System.debug('Entered here');
            licenseGlobalData.noFeeRequired = false;
            licenseGlobalData.isInvoiceRequired = false;
            String query = 'SELECT  '
                + ctlrConfig.getFeeRequirementWhereClause((String)lic.get('Id'))
                + ' LIMIT 1';
            SObject sobj = Database.query(query);
            // Set the field on main object
            licenseGlobalData.noFeeRequired = (sobj instanceof MUSW__License2__c ?  ((Boolean)sobj.get('No_Fee__c')):false); 
            licenseGlobalData.noFeeRequired = (sobj instanceof Renewal_Application__c ?  ((Boolean)sobj.get('No_Fee__c')): licenseGlobalData.noFeeRequired);
            licenseGlobalData.isInvoiceRequired = (sobj instanceof MUSW__Permit2__c ? ((Boolean)sobj.get('Generate_Invoice__c')) :false); 
            licenseGlobalData.isInvoiceRequired = (sobj instanceof Renewal_Application__c ? ((Boolean)sobj.get('Generate_Invoice__c')) :licenseGlobalData.isInvoiceRequired); 
            System.debug('licenseGlobalData.noFeeRequired >>>>>>>>>>>>'+licenseGlobalData.noFeeRequired);
        }
        
    }
    
    /***************************************************************************************************
* @Description : Saves current record
There's one scenario where we need the license id before the user clicks save&continue:
*               When the AddressComponent is in the first section and the user hasn't clicked save and
*               continue, we don't have a licenseId to associate a license
*                to the parcel record (licenseParcel junction object).
* @Param       : void
* @Return      : PageReference
***************************************************************************************************/
    public PageReference  quickSave() {
        
        // Declare result object
        Database.SaveResult saveContactResult;
        try {
            // Upsert Contact object
            saveContactResult = Database.update(contactObj, false);
            Database.SaveResult[] sr = new Database.SaveResult[] {saveContactResult};
                LicenseGlobalData.contactFirstName = contactObj.FirstName;
            LicenseGlobalData.contactLastName = contactObj.LastName;
        } catch (DMLException e) {
            ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'ApplyForSObjectCtlr', 'General Exception', 'quickSave', 'ApplyForSObjectCtlr', label.Str_Low);
            return new PageReference('/ApplicationSubmitError?PageTile=ERROR&PageHeading=Error&ErrorMsg=' + e.getMessage());
        } catch (Exception e) {
            System.debug('e '+e.getMessage());
            return null;
        }
        if(reviewedpId!=null)
        {
            lic.put('Permit2__c',reviewedpId);
        }
        // Upsert Account object
        if (accountId != null) {
            // Declare result object
            Database.SaveResult saveAccountResult;
            try {
                // Upsert Account object
                saveAccountResult = Database.update(accountObj, false);
                Database.SaveResult[] sr = new Database.SaveResult[] {saveAccountResult};
                    ErrorLogger.logDMLDatabaseResultErrors(UserInfo.getUserId(), null, sr, null, 'Account', 'quickSave', 'quickSave', 'ApplyForSObjectCtlr', 'Severity', 'ApplyForSObjectCtlr');
            } catch (Exception e) {
                ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'ApplyForSObjectCtlr', 'Update Account', 'quickSave', 'ApplyForSObjectCtlr', 'HIGH');
                // Do not proceed
                return null;
            }
        }
        // Check if a record already exists
        ctlrConfig.getExistingRecord(this);
        
        // Set values
        ctlrConfig.setFieldValues(this);
        
        try {
            
            // Upsert main object
            upsert lic;
            quicksavecheck=true;
            // Set record Id
            ctlrConfig.setLicenseId(this);
        } catch (Exception e) {
            ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'ApplyForSObjectCtlr', 'Upsert Lic', 'quickSave', 'ApplyForSObjectCtlr', 'HIGH');
        }
        return null;
    }
    
    
    /***************************************************************************************************
* @Description : To submit the application
* @Param       : void
* @Return      : PageReference
***************************************************************************************************/
    public PageReference  submitRecord() {
        Boolean ltype = false;
        // Check if a record already exists
        ctlrConfig.getExistingRecord(this);
        // Set status
        if (licenseGlobalData.noFeeRequired == false && !licenseGlobalData.isInvoiceRequired) {
            System.debug('Entered if');
            lic.put(ctlrConfig.getStatusField(), Label.ST_Generate_Fee);
        } else {
            lic.put(ctlrConfig.getStatusField(), Label.ST_Submitted);
        }
        
        // Save attestation data
        lic.put('Attestation__c', true);
        lic.put('Attestation_Date__c', system.today());
        lic.put('AttestationFullName__c', contactObj.FirstName + ' ' + contactObj.LastName);
        if(reviewedpId!=null)
        {
            lic.put('Permit2__c',reviewedpId);
        }
        String onHoldStatus;
        if(test.isRunningTest()){
            Test.setMock(HttpCalloutMock.class, new TVSVerifyApplication_Test_MockService());
        } else{
            onHoldStatus = TVSVerifyApplication.verifyDetails(lic.Id, false);
        }
        system.debug('onHoldStatus>>>'+onHoldStatus);
        if(onHoldStatus == label.ST_Active || onHoldStatus == label.ST_NoAction){
            try {
                //added by rishap : for Record Type license
              /*  String licMdtBusinessType = [SELECT IndividualBusinessType__c FROM License_Type__mdt].IndividualBusinessType__c;
               system.debug('!!!licMdtBusinessType : '+licMdtBusinessType);
                if(licMdtBusinessType == 'Business'){
                  lic.put('RecordTypeId','012r00000007At6');  
                }*/
                upsert lic;
                Utilities.createInvoice(lic);
                ctlrConfig.setLicenseId(this);
            }
            catch (DMLException ex){
                System.debug('ex '+ex.getMessage());
                if(ex != null){
                    ErrorLogger.logExceptions(UserInfo.getUserId(),ex,lic, String.valueOf(lic.getSObjectType()), 'submitRecord', 'submitRecord', 'ApplyForSObjectCtlr', 'HIGH', 'OApplyForSObjectCtlr');
                    return new PageReference('/ApplicationSubmitError?PageTile=ERROR&PageHeading=Error&ErrorMsg= Unable to save the application - Please contact the functionalarea: Ref: ' + ex);
                }
            }
            catch (Exception e) {
                ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'ApplyForSObjectCtlr', 'Upsert Lic', 'submitRecord', 'ApplyForSObjectCtlr', 'HIGH');
            }
        } 
        else{
            return new PageReference('/ApplicationSubmitError?PageTile=ERROR&PageHeading=Error&ErrorMsg= You are not able to submit new application or renew/reinstate your credential/permit at this time. Please contact DSPS customer support for more information.');
        }
        return null;
    }
    
    
    
    /***************************************************************************************************
* @Description : To reload all attachments
* @Param       : void
* @Return      : void
***************************************************************************************************/
    public void reloadAttachments() {        
        this.attService = new PortalAttachmentSection(credentialType, applicationType, lic.Id);
    }
    
    
    /***************************************************************************************************
* @Description : To reload all questions
* @Param       : void
* @Return      : void
***************************************************************************************************/
    public void reloadQuestions() {
        System.debug('serviceRequestType::'+serviceRequestType);
        System.debug('allcredentials::'+allcredentials);
        if(serviceRequestType != null && serviceRequestType != ''){
            this.queService = new QuestionAnswerObj(applicationType, credentialType, credential, applicationMethod, ctlrConfig.getQuestionObjectLookup(), lic.Id, serviceRequestType);
        }
        else if(allcredentials.contains(applicationType)||applicationtype==Label.RNT_Renewal||applicationType==Label.RNT_Reinstatement){
            this.queService = new QuestionAnswerObj(applicationType, credentialType, credential, applicationMethod, ctlrConfig.getQuestionObjectLookup(), lic.Id);
        }
        else {
            System.debug('inside reload::');
            this.queService = new QuestionAnswerObj(applicationType, programarea, permittype, applicationMethod, ctlrConfig.getQuestionObjectLookup(), lic.Id);
        }
        
    }
    
    
    /***************************************************************************************************
* @Description :  save application data (Main save method)
* @Param       : void
* @Return      : PageReference
***************************************************************************************************/
    public PageReference saveRecord() {
        // Declare result object
        if(reviewedpId!=null)
        {
            lic.put('Permit2__c',reviewedpId);
        }
        Database.SaveResult saveContactResult;
        
        
        try {
            // Upsert Contact object
            saveContactResult = Database.update(contactObj, false);
            Database.SaveResult[] sr = new Database.SaveResult[] {saveContactResult};
                ErrorLogger.logDMLDatabaseResultErrors(UserInfo.getUserId(), null, sr, null, 'Contact', 'saveRecordContact', 'saveRecordContact', 'ApplyForSObjectCtlr', 'Severity', 'ApplyForSObjectCtlr');
            LicenseGlobalData.contactFirstName = contactObj.FirstName;
            LicenseGlobalData.contactLastName = contactObj.LastName;
        } catch (DMLException e) {
            ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'ApplyForSObjectCtlr', 'Update Contact', 'quickSave', 'ApplyForSObjectCtlr', 'HIGH');
            return new PageReference('/ApplicationSubmitError?PageTile=ERROR&PageHeading=Error&ErrorMsg=' + e.getDmlMessage(0));
        } catch (Exception e) {
            ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'ApplyForSObjectCtlr', 'Update Contact', 'quickSave', 'ApplyForSObjectCtlr', 'HIGH');
            return null;
        }
        
        // If business license
        if (accountId != null) {
            
            // Declare result object
            Database.SaveResult saveAccountResult;
            
            try {
                
                // Upsert Account object
                saveAccountResult = Database.update(accountObj, false);
                Database.SaveResult[] sr = new Database.SaveResult[] {saveAccountResult};
                    ErrorLogger.logDMLDatabaseResultErrors(UserInfo.getUserId(), null, sr, null, 'Account', 'saveRecordAccount', 'saveRecordAccount', 'ApplyForSObjectCtlr', 'Severity', 'ApplyForSObjectCtlr');
            } catch (Exception e) {
                ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'ApplyForSObjectCtlr', 'Update Account', 'quickSave', 'ApplyForSObjectCtlr', 'HIGH');
                return null;
            }
        }
        
        // Set values
        ctlrConfig.setFieldValues(this);       
        // Set section number
        lic.put('Section_Number__c', service.PageObj.mapToDBSectionNumber(this.nextSection));     
        service.pageObj.removeFieldErrors();
        if (lic.Id == null) {
            Set<String> licenseStatusSet = new Set<String> {Label.St_Pending};
                Set<String> applicationRenewalStatusSet = new Set<String> {Label.St_Incomplete};
                    Set<String> permitStatusSet = new Set<String> {Label.St_Pending};
                        String query = '';
            if (lic.getSObjectType().getdescribe().getName() == Label.API_License2) {
                if(Label.CR_Manufactured_Homes_Certificate_of_Title!=licenseGlobalData.credential){
                    query = 'SELECT Id FROM MUSW__License2__c WHERE MUSW__Applicant__c =: contactid AND Credential_Type__c =: credentialtype AND Credential__c =: credential AND MUSW__Status__c IN: licenseStatusSet limit 1';
                    
                    if (String.isNotBlank(accountId)) {
                        query = 'SELECT Id FROM MUSW__License2__c WHERE MUSW__Primary_Licensee__c= :accountId AND MUSW__Applicant__c =: contactid AND Credential_Type__c =: credentialtype AND Credential__c =: credential AND MUSW__Status__c IN: licenseStatusSet limit 1';
                    }
                }
            }  
            if (lic.getSObjectType().getdescribe().getName() == Label.API_MUSW_Permit2) {
                //  query = 'SELECT Id FROM MUSW__Permit2__c WHERE MUSW__Applicant__c =: contactid AND Permit_Type__c  =: permittype AND Program_Area__c  =: programarea AND MUSW__Status__c IN: permitStatusSet limit 1';
                
                if (String.isNotBlank(accountId)) {
                    //   query = 'SELECT Id FROM MUSW__Permit2__c WHERE MUSW__Account__c= :accountId AND MUSW__Applicant__c =: contactid AND Program_Area__c  =: programarea AND Permit_Type__c  =: permittype AND MUSW__Status__c IN: permitStatusSet limit 1';
                }
                
            }
            
            
            if (lic.getSObjectType().getdescribe().getName() == Label.API_Renewal_Application&&Applicationtype==Label.RNT_Renewal) {
                query = 'SELECT Id FROM Renewal_Application__c WHERE License__c =: parentId AND Renewal_Status__c IN: applicationRenewalStatusSet AND Renewal_Reinstatement_Type__c = \'' + lic.get('Renewal_Reinstatement_Type__c') + '\' limit 1';
            }
            if (lic.getSObjectType().getdescribe().getName() == Label.API_Renewal_Application&&Applicationtype==Label.Str_ManufacturedHomesRenewal ) {
                query = 'SELECT Id FROM Renewal_Application__c WHERE Permit__c =: parentId AND Renewal_Status__c IN: applicationRenewalStatusSet AND Renewal_Reinstatement_Type__c = \'' + lic.get('Renewal_Reinstatement_Type__c') + '\' limit 1';
            }
            
            if (query != '') {
                List<SObject> checkObjList = Database.query(query);
                if (checkObjList.size() > 0) {
                    lic.id = checkObjList.get(0).id;
                }
            }
        }
        System.debug('Entered before upsert');
        // Insert current record
        Database.UpsertResult saveResult;
        try {
            System.debug('lic  '+lic);
            saveResult = Database.upsert(lic, false);
            Database.UpsertResult[] sr = new Database.UpsertResult[] {saveResult};
                ErrorLogger.logDMLDatabaseResultErrors(UserInfo.getUserId(), null, null, sr, 'License', 'saveRecordLicense', 'saveRecord', 'ApplyForSObjectCtlr', 'High', 'ApplyForSObjectCtlr');
            quicksavecheck = true;
        } catch (Exception e) {
            ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'ApplyForSObjectCtlr', 'Upsert Lic', 'quickSave', 'ApplyForSObjectCtlr', 'HIGH');
        }
        
        // If insert succeeds
        if (saveResult != null && saveResult.isSuccess()) {
            // Set section as complete
            service.PageObj.findSection(this.currentSection).flagSectionAsInProgress();
            
            // Determine the next active section on the UI
            this.currentSection = nextSection;
            
            // Set current section as active
            service.PageObj.flagSectionAsActive(this.currentSection);
            
            // Set global data
            ctlrConfig.setLicenseId(this);
            licenseGlobalData.currentRecId = lic.id;
            
            // If it was the review section and there aren't any errors
            if (nextSection ==  service.PageObj.reviewSectionNumber) {
                service.PageObj.handleReviewAndSubmitSuccess();
            }
            
            // Know if fee is required
            getFeeRequirement();
            System.debug('saveResult::');
            // Reload attachments and questions
            reloadAttachments();
            reloadQuestions();
        }
        // If insert fails
        else {
            
            if (saveResult != null) {
                // Build error map
                for (Database.Error err : saveResult.getErrors()) {
                    System.debug('err '+err);
                    System.debug(' Sumeet '+err.getMessage());
                    // Push errors to error map
                    service.handleSaveOperation( (Map<String, ValidationError.FieldError>)JSON.deserialize( err.getMessage(), Map<String, ValidationError.FieldError>.class ) );
                    
                    // Reload attachments and questions
                    if (lic.Id != null) {
                        reloadAttachments();
                        reloadQuestions();
                    }
                }
            }
            
            if (nextSection == service.PageObj.reviewSectionNumber) {
                
                // Increment current section
                this.currentSection = nextSection;
                
                // Set current section as active
                service.PageObj.flagSectionAsActive(this.currentSection);
            }
        }
        if(lic.Id != null && applicationtype==Label.Str_Plan_Review && permittype!=null && permittype!=Label.PT_POWTS_Sanitary_Permit && permittype!=LABEL.PT_POWTS_State_Owned_Privy_Registration)
        {
            String a=[select id,Type_of_Plan_Review__c from musw__permit2__c where id=:lic.id].Type_of_Plan_Review__c;
            if(a!=null&&a!='')
            {
                licenseGlobalData.goToScheduler=false;
            }
            else {
                licenseGlobalData.goToScheduler=true;
            }
        }
        
        // Return
        return null;
    }
    
    /**
* Class contains global data necessary for all the dynamic sections on the page
* @version     1.0
*/
    public class LicenseGlobalData {
        public String contactId {get; set;}
        public String accountId {get; set;}
        public String contactFirstName {get; set;}
        public String contactLastName {get; set;}
        public String licenseId {get; set;}
        public String credentialType {get; set;}
        public String credential {get; set;}
        public String programArea {get; set;}
        public String permitType {get; set;}
        public String applicationType {get; set;}
        public String currentRecId {get; set;}
        public Boolean noFeeRequired {get; set;}
        public String permitId {get; set;}
        public String serviceRequestType {get; set;}
        public Boolean isInvoiceRequired {get; set;}
        public Boolean goToScheduler {get; set;}
    }
    
    
    /***************************************************************************************************
* @Description : To build html markup for 'print preview' feature
* @Param       : void
* @Return      : Component.Apex.Detail
***************************************************************************************************/
    public Component.Apex.Detail getPrintSections() {
        system.debug('Entered Print Section');
        Component.Apex.Detail detail = new Component.Apex.Detail();
        for (PageDefService.SectionObj sectionObj : service.PageObj.sectionObjMap.values()) {
            
            // Markup for section container
            Component.c.PageSectionPrintComp customSec = new Component.c.PageSectionPrintComp();
            customSec.sectionOrder = sectionObj.orderNumber;
            detail.childComponents.add(customSec);
            
            // Markup for sub-section container
            Component.Apex.Detail subDetail = new Component.Apex.Detail();
            for (PageDefService.SubSectionObj subSectionObj : sectionObj.subSectionObjMap.values()) {
                // If fieldset
                if (subSectionObj.sType == 'Fieldset') {
                    Component.c.PageSubSectionPrintComp customComp = ApplyforSobjectHelper.printfieldSetComponentCreator(subSectionObj, accountObj,contactObj, lic, Applicationtype, existingRecId) ; 
                    subDetail.childComponents.add(customComp);
                }
                // If component
                else if (subSectionObj.sType == 'Component') {
                    
                    Component.c.PageComponentPrintComp printComp = new Component.c.PageComponentPrintComp ();
                    if (subSectionObj.componentName == 'EducationHistoryComp') {
                        printComp =ApplyforSobjectHelper.printComponentCreator(this.eduHistList,subSectionObj,null);
                    }
                    else  if (subSectionObj.componentName == 'EmploymentHistoryComp') {
                        printComp =ApplyforSobjectHelper.printComponentCreator(this.emplHistList,subSectionObj,null);
                    }
                    else  if (subSectionObj.componentName == 'TrainingHistoryComp') {
                        printComp =ApplyforSobjectHelper.printComponentCreator(this.emplHistList,subSectionObj,null);
                    }
                    else  if (subSectionObj.componentName == 'LicenseVerificationComp') {
                        printComp =ApplyforSobjectHelper.printComponentCreator(this.lvfHistList,subSectionObj,null);
                    }
                    else  if (subSectionObj.componentName == 'POWTSOwnerDesigner') {
                        printComp =ApplyforSobjectHelper.printComponentCreator(this.podaffHistList,subSectionObj,null);
                    }
                    else  if (subSectionObj.componentName == 'ProjectInformationComponent') {
                        printComp =ApplyforSobjectHelper.printComponentCreator(this.projparcel,subSectionObj,null);
                    }
                    else  if (subSectionObj.componentName == 'DelegatedAgentComponent') {
                        printComp =ApplyforSobjectHelper.printComponentCreator(this.dacaffHistList,subSectionObj,null);
                    }
                    else  if (subSectionObj.componentName == 'CoownershipComponent') {
                        printComp =ApplyforSobjectHelper.printComponentCreator(this.coaffHistList,subSectionObj,null);
                    }
                    else if(subSectionObj.componentName == 'AttachmentsComp'){
                    
                        if (existingRecId != null) {
                            this.attService = new PortalAttachmentSection(credentialType, applicationType, existingRecId);
                        } else if (LicenseGlobalData.licenseId != null) {
                            this.attService = new PortalAttachmentSection(credentialType, applicationType, LicenseGlobalData.licenseId);
                        } 
                        if (attService != null) {
                            printComp =ApplyforSobjectHelper.printComponentCreator(null,subSectionObj,attService);
                        }
                    }
                    // Address component
                    else if (subSectionObj.componentName == 'BusinessAddress') {
                        
                        String addressType = '';
                        if (subSectionObj.name.containsIgnoreCase(label.Str_Public)) {
                            addressType = ' AND Public__c = true ';
                        } else if (subSectionObj.name.containsIgnoreCase(label.Str_Mailing)) {
                            addressType = ' AND Mailing__c = true ';
                        } /*else if (subSectionObj.name.containsIgnoreCase(label.Str_Physical)) {
                        addressType = ' AND Physical_Address__c = true ';
                        } */                  
                        String selectParcelStr = 'SELECT Id, Mailing__c, '
                            + 'Account__c, Public__c, '
                            + 'Type__c, MUSW__Parcel__c, '
                            + 'MUSW__Parcel__r.Name, '
                            + 'MUSW__Parcel__r.MUSW__Street__c, MUSW__Parcel__r.Country__c, '
                            + 'MUSW__Parcel__r.County__c, MUSW__Parcel__r.MUSW__State__c, '
                            + 'MUSW__Parcel__r.MUSW__City__c, MUSW__Parcel__r.MUSW__Post_Zip_Code__c, '
                            + 'MUSW__Parcel__r.International_Address__c, MUSW__Parcel__r.Comments__c, '
                            + 'MUSW__Parcel__r.LastModifiedDate ';
                        system.debug('licenseGlobalData>>>>'+licenseGlobalData);
                        if (existingRecId != null && 
                            (allcredentials.contains(applicationType) || 
                             applicationType ==label.RNT_Renewal || 
                             applicationType == label.RNT_Reinstatement)) {
                                 selectParcelStr = selectParcelStr + ',MUSW__License2__c FROM MUSW__License_Parcel__c '
                                     + 'WHERE MUSW__License2__c = \'' + licenseGlobalData.licenseId + '\' '
                                     + 'AND MUSW__Parcel__c != null '
                                     + addressType + 'LIMIT 1';
                                 system.debug('selectParcelStr>>>>'+selectParcelStr);
                                 licenseAddressList = Database.query(selectParcelStr);
                                 system.debug('licenseAddressList>>>>'+licenseAddressList);
                                 printComp =ApplyforSobjectHelper.printAddressComponentCreator(this.licenseAddressList,subSectionObj,'Credential');
                             }
                        else if (existingRecId != null && 
                                 (allplanreviewsandpermits.contains(applicationType) || 
                                  applicationType == label.RNT_ReinstatementPlanReview || 
                                  applicationType ==label.RNT_RenewalPlanReview)) {
                                      selectParcelStr = selectParcelStr + ',MUSW__Permit2__c FROM MUSW__Permit_Parcel__c '
                                          + 'WHERE MUSW__Permit2__c = \'' + licenseGlobalData.permitId + '\' '
                                          + 'AND MUSW__Parcel__c != null '
                                          + addressType + 'LIMIT 1';
                                      permitAddressList = Database.query(selectParcelStr);
                                      printComp =ApplyforSobjectHelper.printAddressComponentCreator(this.permitAddressList,subSectionObj,'Permit');
                                  }
                        
                    }// For questions component
                    else if (subSectionObj.componentName == 'QuestionAnswer') {
                        System.debug('in subSectionObj.componentName QuestionAnswer ---> '+subSectionObj.componentName);
                        reloadQuestions();
                        printComp =ApplyforSobjectHelper.printQuestionComponentCreator(queService,subSectionObj,null);
                        
                    }
                    
                    subDetail.childComponents.add(printComp);
                }
                
                // Add to sub-section container
                customSec.childComponents.add(subDetail);
            }
        }
        return detail;
    }
    
    
    /***************************************************************************************************
* @Description :  To upsert license record and perform license parcel related operations
* @Param       : void
* @Return      : void
***************************************************************************************************/
    public void licenseQuickSave() {
        if(reviewedpId!=null)
        {
            lic.put('Permit2__c',reviewedpId);  
        }
        SavePoint sp = Database.setSavePoint() ;
        licAddResult = new LicenseAddressOperation();
        permitAddResult = new PermitAddressOperation();
        System.debug('permitAddResult '+permitAddResult);
        try {
            // Call save method
            quickSave();
            // Perform license address operations
            if (licenseGlobalData.licenseId != null ) {
                String result = AddressJSUtility_CC.handleLicenseParcelOperations(licenseGlobalData.licenseId , contextParcelId, contextAddressType );
                if (result.split('====')[0] == 'ERROR') {
                    
                    licAddResult.isSuccess = false ;
                    licAddResult.message = result.split('====')[1] ;
                    Database.rollback(sp);
                } else {
                    
                    licAddResult.isSuccess = true;
                    licAddResult.addressType = contextAddressType;
                    licAddResult.parcelId = contextParcelId;
                    licAddResult.licenseId = licenseGlobalData.licenseId;
                    licAddResult.primaryEntityType = primaryEntityTypeParam;
                    
                    if (licenseGlobalData.accountId != null) {
                        licAddResult.accountId = licenseGlobalData.accountId;
                    }
                    
                    if (licenseGlobalData.contactId != null) {
                        licAddResult.contactId = licenseGlobalData.contactId;
                    }
                    
                    licAddResult.message = 'Operation completed successfully ' ;
                }
            }else if (licenseGlobalData.permitId != null ) {
                System.debug('in if permitId!= null  calling handlePermitParcelOperations');
                String result = AddressJSUtility_CC.handlePermitParcelOperations(licenseGlobalData.permitId , contextParcelId, contextAddressType );
                System.debug('result '+result);
                if (result.split('====')[0] == 'ERROR') {
                    
                    permitAddResult.isSuccess = false ;
                    permitAddResult.message = result.split('====')[1] ;
                    Database.rollback(sp);
                } else {
                    
                    permitAddResult.isSuccess = true;
                    permitAddResult.addressType = contextAddressType;
                    permitAddResult.parcelId = contextParcelId;
                    permitAddResult.permitId = licenseGlobalData.permitId;
                    permitAddResult.primaryEntityType = primaryEntityTypeParam;
                    
                    if (licenseGlobalData.accountId != null) {
                        permitAddResult.accountId = licenseGlobalData.accountId;
                    }
                    
                    if (licenseGlobalData.contactId != null) {
                        permitAddResult.contactId = licenseGlobalData.contactId;
                    }
                    
                    permitAddResult.message = 'Operation completed successfully ' ;
                    
                    
                }
            } else {
                if (licenseGlobalData.licenseId != null ){
                    licAddResult.isSuccess = false ;
                    licAddResult.message = 'Error occured while saving license record ' ;
                }else if (licenseGlobalData.permitId != null ){
                    permitAddResult.isSuccess = false ;
                    permitAddResult.message = 'Error occured while saving permit record ' ;
                }
                
            }
        } catch (exception ex) {
            System.debug('ex '+ex.getMessage());
            if (licenseGlobalData.licenseId != null ){
                licAddResult.isSuccess = false ;
                licAddResult.message = ex.getMessage() ;
            }else if (licenseGlobalData.permitId != null ){
                permitAddResult.isSuccess = false ;
                permitAddResult.message = ex.getMessage() ;
            }
            
            Database.rollback(sp);
        }
    }
    
    
    /***************************************************************************************************
* @Description : Returns corresponding date field based on parameter
* @Param       : void
* @Return      : String
***************************************************************************************************/
    public String getlicAddrResult() {
        return JSON.serialize(licAddResult);    
        
    }
    /***************************************************************************************************
* @Description : Returns corresponding date field based on parameter
* @Param       : void
* @Return      : String
***************************************************************************************************/
    public String getpermitAddrResult() {
        return JSON.serialize(permitAddResult);    
        
        
    }
    
    /**
* Class for license address manipulation
* @version     1.0
*/
    public class LicenseAddressOperation {
        public Boolean isSuccess {get; set;}
        public String message {get; set;}
        public String parcelId {get; set;}
        public String addressType {get; set;}
        public String licenseId {get; set;}
        public String accountId {get; set;}
        public String contactId {get; set;}
        public String primaryEntityType {get; set;}
    }
    
    public class PermitAddressOperation {
        public Boolean isSuccess {get; set;}
        public String message {get; set;}
        public String parcelId {get; set;}
        public String addressType {get; set;}
        public String permitId {get; set;}
        public String accountId {get; set;}
        public String contactId {get; set;}
        public String primaryEntityType {get; set;}
    }
    
    
    
}