/**
* User Story: 
* Class Name: ApplicationSelection_CC
* Test Class Name: ApplicationSelection_CC_Test
* Description: Controller for Application Selection
* Date:        Developer/Company                    Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 07/27/2018   Sharad Maheshwari/Deloitte           Initial Creation
**/
public with sharing class ApplicationSelection_CC 
{
    
    //public MUSW__License2__c licenseCC {get; set;}
    
    // Global variables
    public MUSW__License2__c lic {get; set;}
    public MUSW__Permit2__c permit {get; set;}
    public Newsfeed__c news {get; set;}
    public List<Question__c> queList {get; set;}
    public String questionsJson {get; set;}
    public String contactId {get; set;}
    public String accountId {get; set;}
    public String accountType {get; set;}
    public List<MUSW__Account_Contact__c> accountList {get; set;}
    public List<accountObj> accList {get; set;}
    public String applyFor {get; set;}
    public String documentId {get; set;}
    public boolean isflagchecked {get; set;}
    public boolean flagchecked {get; set;}
    public Set<String> allcredentials;
    public Set<String> allplanreviewsandpermits;
     public String applicationInstructions{get; set;}
     
    /**
* constructor
*/
    public ApplicationSelection_CC() {
        
        // Initialize objects and lists
        lic = new MUSW__License2__c();
        permit = new MUSW__Permit2__c();
        news = new Newsfeed__c();
        queList =  new List<Question__c>();
        accList = new List<accountObj>(); 
        allcredentials = Utilities.getallCredentials();
        allplanreviewsandpermits = Utilities.getallPlanreviewsandpermits();
        
        // Set license object record type for picklists
        /*Todo lic.RecordTypeId = Utilities.getRecordTypeForName(label.API_License2, label.RT_Universal_Default_License_Record_Type );*/        
        User currUser = null;
        try {
            // Get current user details
            currUser = [SELECT ContactId/*, Contact.RecordTypeId*/ FROM user WHERE Id =: UserInfo.getUserId()];
        }
        catch(Exception e) {
            System.debug(e);
        }
        isflagchecked=false;
        // Get contact Id
        contactId = currUser.ContactId;
        
    }

    /*to update flag to display new page block*/
    public void flagupdate(){
        isflagchecked = true;
    }
    
     
    
    /**
* Method - Get application instructions
* @return    void
*/
    public void getInstructions() {
        news = new Newsfeed__c();
        documentId = '';
        List<Newsfeed__c>  lstnewsFeeds  = new List<Newsfeed__c>();
        if(allcredentials.contains(lic.Application_Type__c)) {
            try {
                lstnewsFeeds = [SELECT Id, Name,  Type__c, Instructions__c, Document_API_Name__c, Answer__c FROM Newsfeed__c 
                        WHERE Credential_Type__c = :lic.Credential_Type__c
                        AND Credential__c = :lic.Credential__c
                        AND (Application_Method__c = :lic.Application_Method__c OR Application_Method__c = 'All')
                        AND Application_Type__c = :lic.Application_Type__c
                        AND Show_For__c INCLUDES (:Label.Str_Credential)
                        AND RecordType.Name = :Label.RT_Page_Instructions
                        LIMIT 1];
                //system.debug('entered try @110'+news);
                
                if(!lstnewsFeeds.isEmpty()){
                    news.Id =  lstnewsFeeds[0].id;
                    news.Name = lstnewsFeeds[0].Name;
                    news.Type__c = lstnewsFeeds[0].Type__c;
                    news.Instructions__c = lstnewsFeeds[0].Instructions__c;
                    news.Document_API_Name__c = lstnewsFeeds[0].Document_API_Name__c;
                    news.Answer__c = lstnewsFeeds[0].Answer__c;
                
                if(news !=null && news.Document_API_Name__c != ''){
                    for(Document doc : [Select id from Document where DeveloperName = :news.Document_API_Name__c limit 1]){
                        documentId = doc.Id;
                    }
                }
              }
            }
            catch(Exception e) {
               ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'ApplicationSelection_CC', 'Credential', 'getInstructions', 'ApplicationSelection_CC', label.Str_Low);
               
            }
        }else if(allplanreviewsandpermits.contains(permit.Application_Type__c)) {
            try {
                news = [SELECT Id, Name,  Type__c, Instructions__c, Document_API_Name__c, Answer__c FROM Newsfeed__c 
                        WHERE Program_Area__c = :permit.Program_Area__c
                        AND Permit_Type__c = :permit.Permit_Type__c
                        AND Show_For__c INCLUDES (:Label.Str_Permit)
                        AND RecordType.Name = :Label.RT_Page_Instructions
                        LIMIT 1];
                //system.debug('entered try @110'+news);
                
                if(news!=null && news.Document_API_Name__c != ''){
                    for(Document doc : [Select id from Document where DeveloperName = :news.Document_API_Name__c limit 1]){
                        documentId = doc.Id;
                    }
                }
            }
            catch(Exception e) {
                system.debug('entered try @118'+e);
                ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'ApplicationSelection_CC', 'Permit', 'getInstructions', 'ApplicationSelection_CC', label.Str_Low);
                 
            }
        }
    }
    
    /**
* Method - Get accounts
* @return    void
*/
    public void getAccounts() {
        
         system.debug('accList@line 130'+accList);
        // Clear accounts list
        accList.clear();
        
        // Check if individual or business license
        getIndividualOrBusinessType();
        // Only for business license types, get accounts
        if(accountType == label.Str_Business) {
            try {
                system.debug('in get accounts method');
                // Get accounts
                accountList = [SELECT Id, MUSW__Account__c,MUSW__Contact__c, MUSW__Account__r.Name, MUSW__Account__r.Business_Alias__c FROM MUSW__Account_Contact__c WHERE MUSW__Contact__c = :contactId];
                // Accumulate accounts
                for(MUSW__Account_Contact__c ac : accountList) {
                    string s1 = ac.MUSW__Account__r.Name;
                    if(ac.MUSW__Account__r.Business_Alias__c != null){
                        s1= + '('+ac.MUSW__Account__r.Business_Alias__c+')';
                        accList.add(new accountObj(ac.MUSW__Account__c, ac.MUSW__Account__r.Name + s1));
                        system.debug('acclist @149'+accList);
                    }
                    else{
                        accList.add(new accountObj(ac.MUSW__Account__c, ac.MUSW__Account__r.Name ));
                        system.debug('accountsList---in else--'+accList);
                    }
                }
            }
            catch(Exception e) {
                //system.debug('entered exception in getAccounts'+e);
                ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'ApplicationSelection_CC', 'Retrieve Account Contact Records', 'getAccounts', 'ApplicationSelection_CC', label.Str_Low);
                
            }
        }
    }
    
    /**
* Method - Get serialized string of accounts

* @return    String
*/
    //@RemoteAction
    public String getAccountsSerialized() {
        
        getAccounts();
        return JSON.serialize(accList);
    }
    
    
    /**
* Class for account object
* @version     1.0
*/
    public class accountObj {
        
        // Class variables
        public String accountId {get; set;}
        public String accountName {get; set;}
        
        
        /**
* Constructor
* @param     Account Id, Account Name
*/
        public accountObj(String accountId, String accountName) {
            
            // Assign values
            this.accountId = accountId;
            this.accountName = accountName;
        }
    }
    
    /**
* Method - Get individual or business type
* @return    void
*/
    public void getIndividualOrBusinessType() {
        
        // Initialize account type string
        accountType = '';
        
        try { 
            
            // Query account type
            if(lic.Credential__c !=null){
                
               accountType = [SELECT Id, IndividualBusinessType__c
                           FROM License_Type__mdt
                           WHERE Credential__c = :lic.Credential__c 
                           AND Object_Name__c = :Label.API_License2
                           LIMIT 1].IndividualBusinessType__c;  
            }
            else if(permit.Permit_Type__c !=null) {
                //System.debug('permt '+permit.Permit_Type__c);
                //System.debug('lab '+label.API_Permit);
                accountType = [SELECT Id, IndividualBusinessType__c
                           FROM License_Type__mdt
                           WHERE Permit_Type__c = :permit.Permit_Type__c 
                           AND Object_Name__c = :Label.API_MUSW_Permit2
                           LIMIT 1].IndividualBusinessType__c;  
            }
            
        }
        catch(Exception e) {
            ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'ApplicationSelection_CC', 'Retrieve Records', 'getIndividualOrBusinessType', 'ApplicationSelection_CC', label.Str_Low);
        }
    }
    
    /**
* Method - Get eligibility questions
* @return    void
*/
    public void getEligibilityQuestions() {
        System.debug('in geteligibilityQuestions');
        // Get accounts
        getAccounts();
        
        // If all parameters are set
        try{
            System.debug('lic.Application_Type__c '+ lic.Application_Type__c);
            System.debug('permit.Application_Type__c  '+ permit.Application_Type__c);
        //allcredentials = Utilities.getallCredentials();
        //allplanreviewsandpermits = Utilities.getallPlanreviewsandpermits();
        if(allcredentials.contains(lic.Application_Type__c)) {
            try {
                
                // Query eligibility questions 
                
                queList = [SELECT Id, Name, Credential_Type__c, Credential__c, Question_Body__c,Data_Type__c,
                           Possible_Responses__c, Qualifying_Response__c, Order_Number__c FROM Question__c 
                           WHERE Credential_Type__c = :lic.Credential_Type__c
                           AND Credential__c = :lic.Credential__c
                           AND (Application_Method__c = :lic.Application_Method__c OR Application_Method__c = 'All')
                           AND Show_For__c includes (:Label.Str_Credential)   
                           AND  Record_Type_Name__c = :Label.RT_Eligibility_questions
                           AND Status__c = :Label.ST_Active
                          
                           ORDER BY Order_Number__c];
                           System.Debug('ques data='+ queList);
            }
            catch(Exception e) {
                ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'ApplicationSelection_CC', 'Retrieve Credential Records', 'getEligibilityQuestions', 'ApplicationSelection_CC', label.Str_Low);
            }
            
            // Serialize list of questions
            questionsJson = JSON.serialize(queList);
            
            // Get instructions
            getInstructions();    
        }else if(allplanreviewsandpermits.contains(permit.Application_Type__c)) {
            try {
                
                // Query eligibility questions
                
                queList = [SELECT Id, Name, Program_Area__c, Permit_Type__c, Question_Body__c,Data_Type__c,
                           Possible_Responses__c, Qualifying_Response__c, Order_Number__c FROM Question__c 
                           WHERE Program_Area__c  = :permit.Program_Area__c
                           AND Permit_Type__c = :permit.Permit_Type__c
                           AND Show_For__c includes (:Label.STR_Permit)   
                           AND  Record_Type_Name__c = :Label.RT_Eligibility_questions
                           AND Status__c = :Label.ST_Active 
                          
                           ORDER BY Order_Number__c];
                           System.debug('ques data=' + queList);
            }
            catch(Exception e) {
                //System.debug('exception'+e);
                ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'ApplicationSelection_CC', 'Retrieve Permit Records', 'getEligibilityQuestions', 'ApplicationSelection_CC', label.Str_Low);
            }
            
            // Serialize list of questions
            questionsJson = JSON.serialize(queList);
            
            // Get instructions
            getInstructions(); 
        }
    }catch(Exception e){
        //System.debug('exception'+e);
        ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'ApplicationSelection_CC', 'Retrieve Records in general', 'getEligibilityQuestions', 'ApplicationSelection_CC', label.Str_Low);
    }
        
    }
    
     /**
* Method - Check if the user already has an application in progress
* @return    Object of MUSW__License2__c
*/
    public MUSW__License2__c checkForExistingApplication() {
        
        // Declare license object
        MUSW__License2__c licenseObject;
        
        try {
            
            // Query existing license object record
            licenseObject = [SELECT Id, MUSW__Primary_Licensee__c 
                             FROM MUSW__License2__c 
                             WHERE Application_Type__C = :lic.Application_Type__C
                             AND  Credential_Type__c = :lic.Credential_Type__c
                             AND Credential__c = :lic.Credential__c
                             AND (Application_Method__c = :lic.Application_Method__c OR Application_Method__c = 'All')
                             AND MUSW__Status__c = 'Pending'
                             AND MUSW__Applicant__c = :contactId LIMIT 1];
                 //system.debug('licenseObject from method'+licenseObject);
        }
        catch(Exception e) {
            System.debug(e);
            // OH_ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'OH_LicenseSelectionCtlr', 'Retrieve Records', 'checkForExistingApplication', 'OH_LicenseSelectionCtlr', label.Str_Low);
        }
        if(accountId != null && licenseObject != null && accountId != licenseObject.MUSW__Primary_Licensee__c) {
            licenseObject = null;
        }
        // Return license object
        return licenseObject;
    }
    
    // check if other license exists 
    public boolean checkOtherLicenses(String LicType, String[] statusToCheck){
        
        Integer licCount = [Select count() From MUSW__License2__c where MUSW__Type__c = :LicType AND MUSW__Applicant__c =:contactId AND MUSW__Status__c NOT IN :statusToCheck];
        
        if(licCount > 0)
            return true;
        else
            return false;
    }
    
    
    /**
* Method - Save data and continue to application
* @return    Pagereference with redirection URL
*/
    public PageReference saveAndContinue() {
        
        //System.debug('in save and continue');
        
        // Create pagereference
        PageReference next;
        
        // If exam application
        /*Todo for future if required
         *  if(applyFor == label.Str_Exam) {
            
            // Build pagereference
            next = Page.ExamApplication;
            next.getParameters().put(something, something);
            
            // Return pagereference
            return next;
        }
        */
                
        //Check if the user is allowed to create another application
        //System.debug('before AllowToCreateAnotherApplication');
        AllowToCreateAnotherApplication anotherApp = new AllowToCreateAnotherApplication();
        
        boolean checkAllowToCreateAnotherApp = anotherApp.AllowToCreateAnotherApplication(contactId, 
                                                                                          lic.Application_Type__C, 
                                                                                          lic.Credential_Type__C, 
                                                                                          lic.Credential__c, 
                                                                                          lic.Application_Method__c,
                                                                                          lic.MUSW__Primary_Licensee__c);
        
        //System.debug('checkAllowToCreateAnotherApp '+ checkAllowToCreateAnotherApp);
        // If existing license found
        if(!checkAllowToCreateAnotherApp) {
            
            // If not allowed to apply for another license, return null
            
               
                    ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, Label.Str_Cannot_Apply_Again) );
                    return null;
               
        }        
        
        // Get existing application record
        MUSW__License2__c licenseObject = checkForExistingApplication();
        //System.debug('licenseObject pid : '+licenseObject);
        System.debug('page.applicaiton '+Page.Application);
        
            next = Page.Application;
        
        // If incomplete existing application found
        if(licenseObject != null) {
            next.getParameters().put('pid', licenseObject.Id);
        }
        
        // Add parameters
        //System.debug('beforecallingapp applicationType'+ lic.Application_Type__C);
        //System.debug('beforecallingapp credentialType'+ lic.Credential_Type__C);
        //System.debug('beforecallingapp credential'+ lic.Credential__c);
        //allcredentials = Utilities.getallCredentials();
        //allplanreviewsandpermits = Utilities.getallPlanreviewsandpermits();
        if(allcredentials.contains(lic.Application_Type__c)) {
            next.getParameters().put('applicationType', lic.Application_Type__C);
            next.getParameters().put('credentialType', lic.Credential_Type__C);
            next.getParameters().put('credential', lic.Credential__c);
            next.getParameters().put('applicationMethod', lic.Application_Method__c);
            
        
        }else if(allplanreviewsandpermits.contains(permit.Application_Type__c)) {
            next.getParameters().put('applicationType', permit.Application_Type__C);
            next.getParameters().put('programArea', permit.Program_Area__c);
            next.getParameters().put('permitType', permit.Permit_Type__c);                
        }
        if(accountId != null) {
            next.getParameters().put('accountId',/*label.Str_accountId, */accountId);
        }
        
        // Reset applyFor variable
        applyFor = '';
        //System.debug('next '+next );
        // Return
        return next;
    } 

    /**
    * Get Application Instruction content
    **/
    public Component.Apex.OutputText getAppInstructionContent(){
        Component.Apex.OutputText oppText = new Component.Apex.OutputText(escape = false, id='instDisplay');
        oppText.value = news.Instructions__c; 
        return oppText;
    }
    
  
}