/*
* User Story: 69 - Obtain Security code from portal
*
* Name: ForgotSecurityCode_CC
* Type: Custom Controller
* Description: Custom Controller for ForgotSecurityCode component
*
* Date:        Developer/Company                   Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 07/02/2018   Srikanth Kottam/Deloitte           Initial Creation
*/
public class ForgotSecurityCode_CC {
    public contact con{get;set;}
    public String SecurityCode{get;set;}
    public String SocialSecurityNumber{get;set;}
    public String FEINnumber{get;set;}
    public String email{get;set;}
    public Boolean isError {get; set;}
    public String ErrorMessage {get; set;}
    
    public ForgotSecurityCode_CC() {
        FEINnumber = '';
        con = new contact();
    }
    
    public class Response{
        public Boolean isError {get; set;}
        public String errorMessage {get; set;}
        public Boolean isEmailMissing {get;set;}
        public Contact cont {get;set;}
        
        public Response(Boolean isError, String errorMessage, Boolean isEmailMissing, Contact cont){
            this.isError = isError;
            this.errorMessage = errorMessage;
            this.isEmailMissing = isEmailMissing;
            this.cont = cont;
        }
    }
    
    @RemoteAction
    public static Response sendSecurityCode(String SocialSecurityNumber, String email) {
        Response response = obtainSecurityCode('',SocialSecurityNumber);   
        if(response.cont != null && response.isError && response.isEmailMissing){
            Email_Notification__c emailNotification = new Email_Notification__c(email__c = email,
                                                                                Param1__c = response.cont.FirstName,
                                                                                Param2__c = response.cont.LastName,
                                                                                Param3__c = response.cont.Security_Code__c,
                                                                                Type__c = 'Send Individual Security Code');
            insert emailNotification;
            response.isError = false;
        }
        return response;
    }
    
    @RemoteAction
    public static Response obtainSecurityCode(String email, String SocialSecurityNumber) {
        Response response = new Response(true,'Please provide either Email address or SSN',false, null);
        List<Contact> contactList;
        String Last4SSN;
        if(String.isNotBlank(email)){
            contactList = new List<Contact>([Select Id, name, firstname, lastname, email, 
                                         Security_Code__c, Social_Security_Number_Encrypted__c,
                                         Last_4_Digits_of_SSN__c from contact
                                         where email =: email]);
            searchByEmail(contactList,email,response);
        }else if(String.isNotBlank(SocialSecurityNumber)){
            Last4SSN = SocialSecurityNumber.right(4);
            contactList = new List<Contact>([Select Id, name, firstname, lastname, email, 
                                         Security_Code__c, Social_Security_Number_Encrypted__c,
                                         Last_4_Digits_of_SSN__c from contact
                                         where Last_4_Digits_of_SSN__c =: Last4SSN]); 
            searchBySSN(contactList,SocialSecurityNumber,response);
        }
        return response;
    }
    
    public static Response searchByEmail(List<Contact> contactList, String email,Response response){
        response.errorMessage = Label.Str_Email_address_not_on_File2;
        if(contactList != null && contactList.size() == 1){
            sendEmailCon(contactList[0]);
            response.isError = false;
            response.errorMessage = ''; 
        }else if(contactList != null && contactList.size() > 1){
            response.errorMessage = Label.Str_Multiple_Contacts;
        }
        return response;
    }
    
    public static Response searchBySSN(List<Contact> contactList, String SocialSecurityNumber,Response response){
        response.errorMessage = Label.Str_SSN_not_on_File;
        Contact matchedContact = null;
        Integer matchedContacts = 0;
        if(contactList != null && contactList.size() > 0){
            for(Contact cont : contactList){
                if(cont.Social_Security_Number_Encrypted__c == SocialSecurityNumber){
                    matchedContact = cont;
                    matchedContacts++;
                }
            }
            if(matchedContacts == 1 && String.isNotBlank(matchedContact.email)){
                sendEmailCon(matchedContact);
                response.isError = false;
                response.errorMessage = '';
            }else if(matchedContacts == 1 && String.isBlank(matchedContact.email)){
                response.isEmailMissing = true;
                response.errorMessage = Label.Str_Email_address_not_on_File;
                response.cont = matchedContact;
            }else if(matchedContacts > 1){
                response.isError = true;
                response.errorMessage = Label.Str_Multiple_Contacts;
            }
        }
        return response;
    }
    
    
    public void findBusinessSecurityCode() {
        isError = false;
        ErrorMessage = '';
        User u = [Select ContactId from user where id=:UserInfo.getUserId() limit 1];
        
        if (FEINnumber != '') {  
            String Last4SSN = FEINnumber.right(4);
            boolean socialMatchMet = false;
            try {
                List < Account > aList = new List < Account > ([Select Id, Name,Email__c, FEIN_Number_Encrypted__c, Last_4_Digits_of_FEIN__c,Security_code__c from Account
                                                                where
                                                                Last_4_Digits_of_FEIN__c =: Last4SSN
                                                               ]);
                if (aList.size() > 0) {
                    Integer numMatches = 0;
                    Account matchedAccount = null;
                    for(Account ac:aList){
                        if (ac.FEIN_Number_Encrypted__c == FEINnumber) {
                            System.debug('FEIN matched');
                            numMatches = numMatches + 1;
                            matchedAccount = ac;
                        }
                    }
                    if(numMatches > 1){
                        isError = true;
                        ErrorMessage = 'Multiple Contacts found';
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ErrorMessage));
                    }else if(numMatches == 1){
                        SecurityCode = matchedAccount.Security_code__c;
                        if (SecurityCode != null && SecurityCode != '' && matchedAccount.email__c != null) {
                            Email_Notification__c emailNotification = new Email_Notification__c(Email__c=matchedAccount.email__c,Param3__c=SecurityCode,Param4__c=matchedAccount.Name,Type__c= 'Send Business Security Code',Recipient_Contact__c=u.ContactId);
                            insert emailNotification;
                        }else{
                            isError = true;
                            ErrorMessage =  'Your Business FEIN or Email could not be found';
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ErrorMessage));
                        }
                    }else if(numMatches == 0){
                        isError = true;
                        ErrorMessage = 'Your Business FEIN or Email could not be found';
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ErrorMessage));
                    }
                }
                else {
                    isError = true;
                    ErrorMessage = 'Your Business FEIN or Email could not be found';
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ErrorMessage));
                }
            } catch (exception e) {
                isError = true;
                ErrorMessage = 'Your Business FEIN or Email could not be found';
                ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'ForgotSecurityCode', ErrorMessage, 'ForgotSecurityCode', 'ForgotSecurityCode', label.str_HIGH);
            }
        } else if (Email != '') {
            try {
                boolean EmailMatchMet = false;
                List < Account > aList = new List < Account > ([Select Id, Name,Email__c, FEIN_Number_Encrypted__c, Last_4_Digits_of_FEIN__c, Security_code__c from Account
                                                                where
                                                                Email__c =: Email Limit 1
                                                               ]);
                if (aList.size() > 1) {
                    isError = true;
                    ErrorMessage = 'Multiple Contacts Found';
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ErrorMessage));
                }else if (aList.size() == 1) {
                    if (aList[0].Security_code__c != null) {
                        SecurityCode = alist[0].Security_code__c;
                        Email_Notification__c emailNotification = new Email_Notification__c(Email__c=aList[0].email__c,Param3__c=SecurityCode,Param4__c=aList[0].Name,Type__c= 'Send Business Security Code',Recipient_Contact__c=u.ContactId);
                        insert emailNotification;
                        EmailMatchMet = true;
                    }
                    if(EmailMatchMet == false)
                    {
                        isError = true;
                        ErrorMessage = 'Your Business FEIN or Email could not be found';
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ErrorMessage));
                    }
                }
                else{
                    isError = true;
                    ErrorMessage = 'Your Business FEIN or Email could not be found';
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ErrorMessage));
                }
            } catch (exception e) {
                isError = true;
                ErrorMessage = 'Your Business FEIN or Email could not be found';
                ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'ForgotSecurityCode', ErrorMessage, 'ForgotSecurityCode', 'ForgotSecurityCode', label.str_HIGH);
            }
        }
    }
    
    public static void sendEmailCon(Contact con){
        //SecurityCode = con.Security_Code__c;
        Email_Notification__c emailNotification = new Email_Notification__c(email__c = con.Email,
                                                                            Recipient_Contact__c = con.Id,
                                                                            Param1__c = con.FirstName,
                                                                            Param2__c = con.LastName,
                                                                            Param3__c = con.Security_Code__c,
                                                                            Type__c = 'Send Individual Security Code');
        insert emailNotification;
    }
    public void sendEmailArc(ArchivedContact__c acon){
        SecurityCode = acon.Contact__r.Security_Code__c;
        Email_Notification__c emailNotification = new Email_Notification__c(email__c = acon.Email__c,
                                                                            Recipient_Contact__c = acon.Contact__c,
                                                                            Param1__c = acon.Contact__r.FirstName,
                                                                            Param2__c = acon.Contact__r.LastName,
                                                                            Param3__c = SecurityCode,
                                                                            Type__c = 'Send Individual Security Code');
        insert emailNotification;
    }
}