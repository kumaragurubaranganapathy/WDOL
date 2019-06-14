/**
* User Story: 
* Class Name: ExistingUserRegistration_CC
* Test Class Name: ExistingUserRegistration_CCTest
* Description: Existing User registration Controller class
* Date:            Developer/Company                    Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 08/01/2018    Aishwaria Rangineni/Deloitte           Initial Creation
* 01/03/2019	Srikanth Reddy Kottam/Deloitte			US#2660: License Upgrade to Community Plus License on First Login - Converted Records
**/
public without sharing class ExistingUserRegistration_CC {
    
    public boolean isPageConfValid {get; set;}
    public string ssnForPage {get; set;}
    public boolean isGuestUser {get;set;} 
    public date birthDate {get; set;}
    // Start Changes by SRK 
    public List<MUSW__Account_Contact__c> accCon;
    // End of Changes
    public void handleDMLException(DMLException ex , Savepoint sp ) {
        result.isSuccess = false ;
        result.messages.add(ex.getMessage());
        for (Integer i = 0; i < ex.getNumDml(); i++) {
            result.displayMessages.add(ex.getDmlMessage(i));
        }
        
        Database.rollback(sp);
    }
    
    public void handleException(Exception e , SavePoint sp ) {
        result.isSuccess = false ;
        result.messages.add(' Exception type caught: ' + e.getTypeName() + '   Message: ' + e.getMessage() + '         Cause: ' + e.getCause()     + '     Line number: ' + e.getLineNumber() + '      Stack trace: ' + e.getStackTraceString()) ;
        system.debug('Exception>>>'+e);
        result.displayMessages.add('Err_Error_occurred_while_processing_your_request_Please_contact_administrator') ;
        Database.rollback(sp) ;
        
        ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'Contact', 'Register Portal User', 'registerExistingWithCode', 'ExistingUserRegistration_CC', 'HIGH');
    }
    
    public String getResultData() {
        return JSON.serialize(result);
    }
    
    public RegResult getResultObject() {
        return result ;
    }
    public RegResult result ;
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
    
    public ExistingUserRegistration_CC(){
        system.debug('Entered Controller');
        result = new RegResult();
        result.isSuccess = true ;
        isPageConfValid = true ;
        ssnForPage = '' ;
        
        List<User> users = [Select  Id FROM User WHERE Name = 'System Administrator' LIMIT 1  ] ;
        if (users.isEmpty() == false ) {
            DEFAULT_ACCOUNT_OWNERID = users[0].Id ;
        } else {
            result.isSuccess = false ;
            result.messages.add(label.Err_Default_Account_owner_is_not_configured) ;
        }
        
        List<Profile> profiles = [Select ID from Profile Where Name = : System.label.Customer_Community_Login_User Limit 1 ] ;
        if (profiles.isEmpty() == false ) {
            COMMUNITY_PROFILE_ID = profiles[0].Id ;
        } else {
            result.isSuccess = false ;
            result.messages.add(label.Err_Default_Community_profile_is_not_configured) ;
        } 
        
        // Start Changes by SRK 
        List<Profile> profilesPlus = [Select ID from Profile Where Name = : System.label.Customer_Community_Plus_Login_User Limit 1 ] ;
        if (profilesPlus.isEmpty() == false ) {
            COMMUNITY_PLUS_PROFILE_ID = profilesPlus[0].Id ;
        } else {
            result.isSuccess = false ;
            result.messages.add(label.Err_Default_Community_Plus_profile_is_not_configured) ;
        }    
        // End of Changes by SRK
        
        newCon = new Contact();
        isPageConfValid = result.isSuccess ;
        result.Displaymessages.addAll(result.messages) ;
        isGuestUser = Utilities.isGuestUserLoggedIn(); 
    }
    
    @TestVisible private Boolean  checkIfUserAllreadyExistForContact(Contact conIn) {
        boolean bRet = false ;
        List<User> users = [Select Id , ContactId from User Where ContactId = : conIn.Id and isActive = true limit 1 ] ;
        System.debug('users>>>>>>>>>>>>>>>>>>>>>>>>' +users);
        if (users.isEmpty() == false ) {
            result.isSuccess = false ;
            result.messages.add(Label.ContactExistsError);
            result.DisplayMessages.add(Label.ContactExistsError);
            bRet = true ;
        }
        
        return bRet ;
    }
    
    @TestVisible private boolean checkSSNnoSSNValidation(Contact existingContact) {
        boolean bRet = false ;
        if (existingContact != null && existingContact.Last_4_Digits_of_SSN__c != null && existingContact.Last_4_Digits_of_SSN__c != '') {
            if (newCon != null &&  ( ssnForPage  == null || ssnForPage == '' )) {
                bRet = true ;
            }
        }
        return bRet ;
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
    
    @TestVisible
    private Contact updateContactRecord(Id accountId, Contact existingContact, Id contactId , Contact pageCon , Date birtDateIn) {
        Contact conToUpdate = new Contact(Id = contactId) ;
        conToUpdate.AccountId = accountId ;
        
        conToUpdate.Email = pageCon.Email ;
        conToUpdate.LastName = existingContact.LastName ;
        conToUpdate.FirstName = existingContact.FirstName ;
        conToUpdate.MiddleName = existingContact.MiddleName ;
        
        if (ssnForPage != null && ssnForPage != '') {
            transient string ssnToDB = ssnForPage.replaceAll('-', '') ;
            conToUpdate.Social_Security_Number_Encrypted__c  = ssnToDB ;
        }
        
        if (birtDateIn != null) {
            conToUpdate.Birthdate = birtDateIn ;
        }
        
        UPDATE conToUpdate ;
        return conToUpdate ;
    }
    
    public PageReference registerExistingWithCode() {
        
        SavePoint sp = Database.setSavepoint() ;
        PageReference ret = null ;
        result = new RegResult();
        
        result.isSuccess = false ;
        
        //Debug purpose only
        result.messages.add('Input parameters ----- >>>> Last Name -----> ' + newCon.lastName  + '---------SEC CODE ---------' +  newCon.Security_Code__c + '----- SSN last ------' + newCon.Last_4_Digits_of_SSN__c) ;
        try {
            boolean emailPass = Utilities.checkBlockedEmail (newCon);
            system.debug('emailPass>>>'+emailPass);
            if (!emailPass) {
                result.messages.add(label.Err_You_are_not_allowed_to_register_with_this_Email_Please_choose_different_one);
                result.displayMessages.add(label.Err_You_are_not_allowed_to_register_with_this_Email_Please_choose_different_one);
                return ret;
            }
            
            transient Contact existingContact = null ;
            List<Contact> cons ;
            Boolean ssnValue = false;
            Boolean emailValue = false;
            Boolean dobValue = false;
            Boolean ssnCheck = false;
            Boolean emailCheck = false;
            Boolean dobCheck = false;
            List<Contact> conList = new List<Contact>();
            
            ssnForPage = ssnForPage.replaceAll('\\D','');
            system.debug('newCon>>>'+newCon);
            if(newCon.Security_Code__c != null){
                cons = [SELECT Id, AccountId, FirstName, MiddleName, LastName, Name, 
                        Email, Security_Code__c, Last_4_Digits_of_SSN__c, Birthdate, 
                        Social_Security_Number_Encrypted__c FROM Contact 
                        WHERE Security_Code__c = : newCon.Security_Code__c  LIMIT 1];
            }
            
            if(cons.isEmpty() == false && cons != null){
                for(Contact con : cons){
                    if(con.Email != null && con.Email != ''){
                        if(newCon.Email == con.Email){
                            emailCheck = true;
                        }
                        emailValue = true;
                    }
                    if(con.Birthdate != null){
                        if(birthDate == con.Birthdate){
                            dobCheck = true;
                        }
                        dobValue = true;
                    }
                    if(con.Social_Security_Number_Encrypted__c != null && con.Social_Security_Number_Encrypted__c != ''){
                        if(ssnForPage == con.Social_Security_Number_Encrypted__c){
                            ssnCheck = true;
                        }
                        ssnValue = true;
                    }
                }
            } 
            
            if(ssnValue == ssnCheck && dobValue == dobCheck && emailValue == emailCheck && cons.isEmpty() == false){
                conList.add(cons[0]);
            }
            
            system.debug('conList>>>'+conList);
            if (conList != null && conList.isEmpty() == false ) {
                existingContact = conList[0] ;
                // Start Changes by SRK 
                if(existingContact != null){
                    accCon = [Select Id, MUSW__Account__c, MUSW__Contact__c from MUSW__Account_Contact__c 
                              where MUSW__Contact__c =: existingContact.Id ];
                }
                // End Changes
                System.debug('Contact_found_with_provided_security_code');
                result.messages.add('Contact_found_with_provided_security_code') ;
            } else {
                result.messages.add('Contact_Not_found_in_standard_Contact_database_Lookng_for_ARCHIVED_Database') ;
                //Look for archived contacts
                List<ArchivedContact__c> archContacts  = [ SELECT Id, LastName__c, Security_Code__c, Contact__c FROM ArchivedContact__c WHERE Security_Code__c = : newCon.Security_Code__c LIMIT 1];
                if (archContacts.isEmpty() == false ) {
                    string archContId = archContacts[0].Contact__c ;
                    result.messages.add('label.Key_Found_in_Archived_databased' + archContId ) ;
                    System.debug('label.Key_Found_in_Archived_databased');
                    if (archContId != null ) {
                        List<Contact> cons2 = [SELECT Id, Social_Security_Number_Encrypted__c , AccountId, FirstName, LastName, Name, Email, Security_Code__c, Last_4_Digits_of_SSN__c, Birthdate, MiddleName FROM Contact WHERE Id = :archContId LIMIT 1 ] ;
                        if (cons2.isEmpty() == false ) {
                            existingContact = cons2[0] ;
                            // Start Changes by SRK 
                            if(existingContact != null){
                                accCon = [Select Id, MUSW__Account__c, MUSW__Contact__c from MUSW__Account_Contact__c 
                                          where MUSW__Contact__c =: existingContact.Id ];
                            }
                            // End Changes
                            System.debug('label.Contact_found_in_archived_database');
                            result.messages.add('label.Contact_found_in_archived_database' );
                        } else {
                            result.isSuccess = false ;
                            result.messages.add('label.Contact_not_found_archived_database' );
                            System.debug('label.Contact_not_found_archived_database');
                        }
                    }
                } else {
                    result.messages.add('label.Contact_not_found_archived_database'  );
                }
            }
            
            if (existingContact != null ) {
                if (checkSSNnoSSNValidation(existingContact)) {
                    System.debug('label.Err_You_are_not_allowed_to_register_without_a_Social_Security_Number');
                    result.messages.add('label.Err_You_are_not_allowed_to_register_without_a_Social_Security_Number');
                    result.displayMessages.add('label.Err_You_are_not_allowed_to_register_without_a_Social_Security_Number') ;
                    result.isSuccess = false ;
                } else {
                    ID accountIdTemp = existingContact.AccountId ;
                    if (accountIdTemp == null ) {
                        Account account = createAccountRecord(existingContact);
                        accountIdTemp = account.Id ;
                        result.messages.add('label.Str_Account_created_successfully') ;
                    }
                    
                    boolean isUserExist = checkIfUserAllreadyExistForContact(existingContact) ;
                    
                    if (isUserExist == false ) {
                        SiteUserOperation uRes = new SiteUserOperation() ;
                        try {
                            Contact conRecord = updateContactRecord(accountIdTemp , existingContact, existingContact.Id , newCon , birthDate ) ;
                            result.messages.add('label.Str_Contact_created_updated_successfully') ;
                            
                            uRes = handleCommunityUserOperations(conRecord , accountIdTemp , passwordParameter ) ;
                            
                            result.messages.addAll(uRes.messages) ;
                        } catch (DMLException ex) {
                            handleDMLException(ex , sp ) ;
                        }
                        
                        if (uRes != null && uRes.isSuccess ) {
                            // Start of Changes by SRK
                            // Recalcuate Sharing
                            if(accCon.size() > 0){
                                List<MUSW__Account_Contact__c> accountContact = new List<MUSW__Account_Contact__c>();
                                for(MUSW__Account_Contact__c ac : accCon){
                                    ac.Recalculate_Sharing__c = true;
                                    accountContact.add(ac);
                                }
                                system.debug('accountContact>>>'+accountContact);
                                if(accountContact.size() > 0){    
                                    Update accountContact;
                                }  
                            } 
                            // End of Changes by SRK
                            PageReference tempRet = Site.Login(uRes.UserRecord.username  , uRes.password , 'Dashboard') ;
                            
                            if (tempRet != null ) {
                                tempRet.getParameters().put('retURL', '/apex/Dashboard');
                                
                                ret = tempRet ;
                                result.isSuccess = true ;
                                ret.setRedirect(true);
                            } else {
                                result.isSuccess = false ;
                                result.messages.add('label.Err_Unable_to_login_to_site') ;
                            }
                        } else {
                            Database.rollback(sp);
                            result.isSuccess = uRes.isSuccess ;
                            result.messages.addAll(uRes.messages);
                            result.displayMessages.addAll(uRes.messages) ;
                        }
                    }
                }
            } else {
                if(cons.isEmpty() == false && cons != null){
                    result.displayMessages.add( System.Label.Err_ContactDoesntExistError ) ;
                } else{
                    result.displayMessages.add(System.Label.Err_Security_Code) ;
                }
                
                result.isSuccess = false ;
            }
        } catch (exception e) {
            handleException(e, sp);
        }
        return ret ;
    }
    
    public SiteUserOperation handleCommunityUserOperations(Contact con,  Id accId , string passwordIn  ) {
        
        SiteUserOperation retRes = new SiteUserOperation() ;
        
        try {
            string userNameInput = null;
            User u = new User();
            
            if (con.Email != null && con.Email != '') {
                userNameInput = con.Email ;
                u.Email = con.Email;
            }
            
            u.Username = userNameInput;
            u.FirstName = con.firstName;
            u.LastName = con.lastName;
            u.ContactId = con.Id;
            if(accCon.size() > 0){
               u.ProfileId = COMMUNITY_PLUS_PROFILE_ID; 
            }else{
                u.ProfileId = COMMUNITY_PROFILE_ID;
            }
            
            
            transient string tempNickName = String.valueOf(Math.random()) + '-' + u.lastName  ;
            if (tempNickName.length() > 30 ) {
                tempNickName = tempNickName.substring(2, 30) ;
            }
            
            u.CommunityNickname = tempNickName ;
            
            String fullname = con.firstName + con.lastName;
            Integer nameLength = fullname.length();
            Integer aliasLength = (nameLength >= 5) ? 5 : nameLength;
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
            ErrorLogger.logGeneralException(ex, UserInfo.getUserId(), 'ExistingUserRegistration_CC', null, 'handleCommunityUserOperations', 'ExistingUserRegistration_CC', label.str_HIGH);
        }
        
        return retRes ;
    }
    
    private  ID DEFAULT_ACCOUNT_OWNERID ;
    private  ID COMMUNITY_PROFILE_ID ;
    private  ID COMMUNITY_PLUS_PROFILE_ID ;
    public Contact newCon {get; set;}
    public string passwordParameter {get; set;}
    
    
    public Account createAccountRecord(Contact existCon) {
        Account acc = new Account(name = existCon.firstName + ' ' + existCon.lastName, OwnerId = DEFAULT_ACCOUNT_OWNERID);
        insert acc;
        return acc;
    }
    
    // Start of Changes by SRK
    // Check if the existing contact is associated to any Business Account
    public boolean checkAccountContact(Contact existCon){
        Boolean acCheck = false;
        List<MUSW__Account_Contact__c> acList = [Select Id, MUSW__Account__c, MUSW__Contact__c, Associate_Status__c from
                                                 MUSW__Account_Contact__c where MUSW__Contact__c =: existCon.Id and 
                                                 Associate_Status__c = 'Active'];
        system.debug('acList>>>'+acList);
        system.debug('acList.size>>>'+acList.size());
        if(acList.size() > 0){
            acCheck = true;
        }else{
            acCheck = false;
        }
        
        return acCheck;
    }
    // End of Changes by SRK
}