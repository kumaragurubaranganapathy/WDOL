/*******************************************************************************
* Name          :   CommunitiesRegistrationController
* Author        :   
* Date          :   
* Description   :   Controller for registration page
*-------------------------------------------------------------------------------
UPDATES
Version         Developer               Date            Description
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
Test class Name
               
*******************************************************************************/

public without sharing class CommunitiesRegistrationController {

//  public string ssnForPage {get; set;}	***Dharan Shah --- COMMENTED this as the requirement is not to have SSN on the New User Account Page --- 03/27***
    public Boolean registerWOLicense {get;set;}
    public boolean isPageConfValid {get; set;}
    public String userType {get; set;}
    public RegResult result ;
    
    private  ID DEFAULT_ACCOUNT_OWNERID ;
    private  ID COMMUNITY_PROFILE_ID ;
    public Contact newCon {get; set;}
    public string passwordParameter {get; set;}
//  public string birthDateString {get; set;}	***Dharan Shah --- COMMENTED this as the requirement is not to have DOB on the New User Account Page --- 03/27***
    
    public String getResultData() {
        return JSON.serialize(result);
    }

    public RegResult getResultObject() {
        return result ;
    }

    public class RegResult {
        public boolean isSuccess {get; set;}
        public List<string> messages {get; set;}
        public List<string> displayMessages {get; set;}
        public RegResult() {
            isSuccess = false ;
            messages = new List<String>() ;
            displayMessages = new List<String>();
        }
    }

    public class SiteUserOperation {
        public string password {get; set;}
        public User userRecord {get; set;}
        public boolean isSuccess {get; set;}
        public Id userId {get; set;}
        public List<string> displayMessages {get; set;}
        public List<string> messages {get; set;}

        public SiteUserOperation() {
            isSuccess = false ;
            messages = new List<String>() ;
            displayMessages = new List<string>() ;
        }
    }
    
    public CommunitiesRegistrationController() {
        result = new RegResult();
        result.isSuccess = true ;
        isPageConfValid = true ;
        registerWOLicense = true;
//      ssnForPage = '' ;	***Dharan Shah --- COMMENTED this as the requirement is not to have SSN on the New User Account Page --- 03/27***
        
        userType = UserInfo.getUserType();
        
        List<User> users = [Select Id FROM User WHERE Name = 'System Administrator' LIMIT 1  ] ;
        if (users.isEmpty() == false ) {
            DEFAULT_ACCOUNT_OWNERID = users[0].Id ;
        } else {
            result.isSuccess = false ;
            result.messages.add(Label.Err_Default_Account_owner_is_not_configured) ;
        }
        /*Modified on : 26/3/19
         *Modified by : Rishap
         *Purpose : Org didn't have 'Customer Login User' license , hence the Business Account was not been created from the Portal. So changed to Customer Community Plus Login
         */
      //  List<Profile> profiles = [Select ID from Profile Where Name = : System.label.Customer_Community_Login_User Limit 1 ] ;
      List<Profile> profiles = [Select ID from Profile Where Name = : System.label.Customer_Community_Plus_Login_User Limit 1 ] ;
        if (profiles.isEmpty() == false ) {
            COMMUNITY_PROFILE_ID = profiles[0].Id ;
        } else {
            result.isSuccess = false ;
            result.messages.add(Label.Err_Default_Community_profile_is_not_configured) ;
        }
        
        newCon = new Contact();
        isPageConfValid = result.isSuccess ;       
        result.Displaymessages.addAll(result.messages) ;
    }

    public SiteUserOperation handleCommunityUserOperations(Contact con,  Id accId , string passwordIn  ) {

        SiteUserOperation retRes = new SiteUserOperation() ;
        try {
            string userNameInput = null;
            User u = new User();
            String fullname = con.firstName + con.lastName;
            Integer nameLength = fullname.length();
            Integer aliasLength = (nameLength >= 5) ? 5 : nameLength;
            if (con.Email != null && con.Email != '') {
                userNameInput = con.Email ;
                u.Email = con.Email;
            }
			
            u.Phone	= String.valueof(newCon.Phone);		//Dharan Shah
            u.Username = userNameInput;
            u.FirstName = con.firstName;
            u.LastName = con.lastName;
            u.ContactId = con.Id;
            u.ProfileId = COMMUNITY_PROFILE_ID;
            transient string tempNickName = String.valueOf(Math.random()) + '-' + u.lastName  ;
            if (tempNickName.length() > 30 ) {
                tempNickName = tempNickName.substring(2, 30) ;
            }

            u.CommunityNickname = tempNickName ;
            u.Alias = fullname.substring(0, aliasLength);
            u.languagelocalekey = 'en_US';
            u.localesidkey = 'en_US';
            u.timezonesidkey = 'America/New_York';
            u.emailencodingkey = 'UTF-8';
            
            Id userId;
            userId = Site.createExternalUser(u, con.AccountId, passwordIn);
           
            if (userId != null) {
                retRes.userId = userId ;
                retRes.userRecord = u ;
                retRes.isSuccess = true ;
                retRes.password = passwordIn ;
            } else {
                retRes.isSuccess = false ;
                if(Test.isRunningTest() == false){
                    Site.validatePassword(u, passwordIn, passwordIn);
                }
                for(ApexPages.Message msg : ApexPages.getMessages()){
                    retRes.displayMessages.add(msg.getDetail());
                    retRes.messages.add(msg.getDetail());
                }
            }
        }catch (Exception ex){
            retRes.isSuccess = false ;
            retRes.displayMessages.add(ex.getMessage());
            retRes.messages.add(ex.getMessage());           
        }

        return retRes ;
    }

/*			*****Dharan Shah --- COMMENTED this method as the requirement is not to have SSN on the New User Account Page --- 03/27*****						
    @TestVisible private Contact CheckForExistingContact() {
        Contact con = null;
        String lastFourDigits = ssnForPage.right(4);
        String ssnForDatabase = ssnForPage.replaceAll('-', '') ;
        
        List<Contact> contactEmails = [SELECT id, Social_Security_Number_Encrypted__c FROM Contact where Last_4_Digits_of_SSN__c = :lastFourDigits];
        for (Contact existingContact : contactEmails) {
            if (existingContact.Social_Security_Number_Encrypted__c == ssnForDatabase ) {
                con = existingContact;
            }
        }
        return con;
    }
*/
    private Contact handleAccountContactCreation() {
        Contact retRes = null ;

        Account acc = new Account(name = newCon.firstName + ' ' + newCon.lastName, OwnerId = DEFAULT_ACCOUNT_OWNERID);
        insert acc;
        
/*		*****Dharan Shah --- COMMENTED this as the requirement is not to have SSN on the New User Account Page --- 03/27*****
        transient string ssnForDB ;
        if (ssnForPage != null) {
            ssnForDB = ssnForPage.replaceAll('-', '') ;
        }
*/
        retRes = new Contact(
            LastName = newCon.lastName,
            FirstName = newCon.firstName,
            Email = newCon.Email,
            //Social_Security_Number_Encrypted__c = ssnForDB,		***Dharan Shah --- COMMENTED this as the requirement is not to have SSN on the New User Account Page --- 03/27***
            AccountId = acc.Id,
            Phone = newCon.Phone,		//Dharan Shah
            MiddleName = newCon.MiddleName,
            Birth_State_Province__c = '', //Adding this to replace default value Wisconsin from Picklist
            Birth_Country__c = '',
            MUSW__Account_Relationship__c = 'Owner' // Adding this to define relationship
        );
        
/*      
   		***Dharan Shah --- COMMENTED this as the requirement is not to have DOB on the New User Account Page --- 03/27***

        if (birthDateString != null && birthDateString != '') {
            retRes.Birthdate = Date.parse(birthDateString);
        }
*/
        INSERT retRes ;
        return retRes ;
    }

    public PageReference registerNewCommunityUser() {
        PageReference ret = null ;
        Savepoint sp = Database.setSavepoint();
        result = new RegResult();
        result.isSuccess = false ;
        try {
            
            boolean emailPass = Utilities.checkBlockedEmail (newCon);
            if (!emailPass) {
                                result.messages.add(label.Err_You_are_not_allowed_to_register_with_this_Email_Please_choose_different_one);
                                result.displayMessages.add(Label.Err_You_are_not_allowed_to_register_with_this_Email_Please_choose_different_one);
                                return ret;
            } 
            
            Contact conRecord ;
            
/*          *****Dharan Shah --- COMMENTED this as the requirement is not to have SSN on the New User Account Page --- 03/27*****
   
            if (newCon != null && ssnForPage != null &&  ssnForPage != '') {
                conRecord = CheckForExistingContact() ;
                newCon.Reason_for_No_SSN__c = null ;
            }
            else {
                newCon.Social_Security_Number_Encrypted__c = null ;
            }
*/            
            
            if (conRecord == null ) {
                result.messages.add(Label.Contact_Record_not_found_Create_new_one);
                try {
                    Contact contactRecord;
                    try {
                        contactRecord = handleAccountContactCreation();
                    } catch (DMLException dmEx) {
                        result.isSuccess = false ;
                        result.messages.add(Label.Exception_while_creating_new_Account_Contact + dmEx.getMessage());
                        result.messages.add(dmEx.getMessage());
                        for (Integer i = 0; i < dmEx.getNumDml(); i++) {
                            result.displayMessages.add(dmEx.getDmlMessage(i));
                        }
                        Database.rollback(sp);
                    }
                    
                    if (contactRecord != null ) {
                        SiteUserOperation uRes = handleCommunityUserOperations(contactRecord , contactRecord.AccountId , passwordParameter ) ;
                        
                        result.messages.addAll(uRes.messages) ;
                        
                        if (uRes.isSuccess ) {
                            PageReference tempRet = Site.Login(uRes.UserRecord.username  , uRes.password , 'Dashboard') ;
                            
                            if (tempRet != null ) {
                                tempRet.getParameters().put('retURL', '/apex/Dashboard');
                                ret = tempRet ;
                                result.isSuccess = true ;
                                ret.setRedirect(true);
                            } else {
                                result.isSuccess = false ;
                                result.messages.add(Label.Err_Unable_to_login_to_site) ;
                                result.displayMessages.add(Label.Err_There_is_some_issue_with_application_Please_contact_us_for_support) ;
                            }
                        } else {
                            Database.rollback(sp);
                            result.isSuccess = uRes.isSuccess ;
                            result.messages.addAll(uRes.messages);
                            result.displayMessages.addAll(uRes.displayMessages) ;
                        }
                    }
                } catch (exception e) {
                    result.isSuccess = false ;
                    result.messages.add(' Exception type caught: ' + e.getTypeName() + '   Message: ' + e.getMessage() + '         Cause: ' + e.getCause()     + '     Line number: ' + e.getLineNumber() + '      Stack trace: ' + e.getStackTraceString()) ;
                    result.displayMessages.add(Label.Err_Error_occurred_while_processing_your_request_Please_contact_us_for_further ) ;
                    Database.rollback(sp);
                }
            } else {
                result.displayMessages.add(Label.ContactExistsError ) ;
                result.messages.add('Existing contact -------' + JSON.serialize(conRecord)) ;
                result.isSuccess = false ;
            }
        } catch (exception exp) {
            result.displayMessages.add(exp.getMessage() ) ;
            result.messages.add(exp.getMessage()  ) ;
            result.isSuccess = false ;
        }
        return ret ;
    }
    
}