/*
* classname 	:  DOL_License_Linking
* @description 	:  This class is used to link all  the data from  one contact to  another contact
* @author 		:  Mangesh
* @date 		:  07/11/2019
* MODIFICATION LOG:
* DEVELOPER                     DATE                               DESCRIPTION
* ---------------------------------------------------------------------------------------------
* Mangesh	      07/11/2019	     This class is created as part of user stories 2385 and 2386
**/

public without Sharing class DOL_License_Linking {
/**
* method 		: getAccountList
* @description 	: Get list of accounts basis security code
* @author 		: MAngesh
* @param <SecurityCode> <Security code on account object>
* @return <Returns list of account> 
* */
    @AuraEnabled
    public static List<Account> getAccountList(String securityCode) {
        DOL_AppUtility.isAuthenticatedUser() ;
        List<Account> lstAcc = new List<Account>();
        
        for(Account accCon  : [select id ,Name, UBI_Number__c,ShippingAddress from Account where Security_Code__c =:securityCode ]) {
            lstAcc.add(accCon);
        }
        if(!lstAcc.isEmpty()){
           return lstAcc;  
        } else {
          return lstAcc;
        }
    }
/**
* method 		: createAccountContact
* @description 	: Create account contact association
* @author 		: Mangesh
* @param <accID> <AccountID to  create account contact association
* @return <Success/Failure message> 
* */
     @AuraEnabled
    public static String  createAccountContact(String accID) {
     //Boolean isInsert = Add_BusinessController.createAccountContactObject(accID);
         DOL_AppUtility.isAuthenticatedUser() ;
        MUSW__Account_Contact__c retRes ;
        String message = '';
        User currentUser = [SELECT Id,Name,firstname,lastname,ContactId,email from User Where ID = :UserInfo.getUserId() LIMIT 1];
        list<MUSW__Account_Contact__c> businessList = new list<MUSW__Account_Contact__c>([SELECT Id, MUSW__Contact__c, MUSW__Account__r.Name, MUSW__Account__r.BillingStreet, MUSW__Account__r.BillingCity, MUSW__Account__r.BillingState, MUSW__Account__r.BillingPostalCode, MUSW__Account__r.BillingCountry FROM MUSW__Account_Contact__c WHERE MUSW__Contact__c =: currentUser.ContactId AND MUSW__Account__c =: accID ]);
        list<MUSW__Account_Contact__c> lstac = new list<MUSW__Account_Contact__c>();
        try{
            if(businessList.size()==0){
                MUSW__Account_Contact__c ac = new MUSW__Account_Contact__c();
                ac.MUSW__Account__c = accID;
                ac.MUSW__Contact__c = currentUser.ContactId;
                ac.Status__c= 'Active' ;
                ac.isAdminContact__c = True;
                ac.Role__c = 'Administrator';
                ac.Account_Admin__c = true;
                ac.Email__c = currentUser.Email;
                ac.First_Name__c = currentUser.firstname;
                ac.Middle_Name__c = currentUser.firstname;
                ac.Last_Name__c = currentUser.lastName;
                ac.Email__c = currentUser.email;
                ac.Title__c = 'Administrator';
                lstac.add(ac);
                Utilityclass_withsharing.insertList(lstac);
                system.debug('ac234567'+ac);
                message = 'User linked with  account succeessfully!'; 
            } else {
                message = 'Account already  linked with  your contact';
            }
        } catch(Exception e){
            message = 'Error occurred please contact system admin!';  
            DOL_CreateErrorLog_Exception.addError(e,'DOL_License_Linking','createAccountContact');
        }
        return message;
    }
/**
* method 		: getLicenseList
* @description 	: Get license details of a contact
* @author 		: Mangesh
* @return <List of license> 
* */
    @AuraEnabled
    public static List<MUSW__License2__c> getLicenseList(String securityCode,String firstname,string lastname,string ssn, String licenseNumber, String licenseType, Date dob) {
        DOL_AppUtility.isAuthenticatedUser() ;
        List<MUSW__License2__c> lstlicense = new List<MUSW__License2__c>();
        system.debug('abcd123'+securityCode);
        if(securityCode != '') {
            system.debug('abcd'+securityCode);
            for(MUSW__License2__c accCon  : [select id ,MUSW__Applicant__r.Name,MUSW__Applicant__c,Name,Credential_Type__c,MUSW__Status__c,Email__c
                                             from MUSW__License2__c where MUSW__Applicant__r.Security_Code__c =:securityCode ]) {
                                                 // MUSW__License__c license = new MUSW__License__c(); 
                                                 lstlicense.add(accCon);                                              
                                             }
        } else if(licenseType != '' && licenseNumber != '') {
            for(MUSW__License2__c accCon  : [select id ,MUSW__Applicant__c,MUSW__Applicant__r.Name,Name,Credential_Type__c,MUSW__Status__c,Email__c
                                             from MUSW__License2__c 
                                             where Name =:licenseNumber and MUSW__Applicant__r.FirstName= :firstname
                                             and MUSW__Applicant__r.LastName= :lastname and MUSW__Applicant__r.Last_4_Digits_of_SSN__c =:ssn
                                             and Credential_Type__c =:licenseType and Date_of_Birth__c=: dob]) {
                                                 lstlicense.add(accCon);                                              
                                             }
        } else {            
            for(MUSW__License2__c accCon  : [select id ,MUSW__Applicant__c,MUSW__Applicant__r.Name,Name,Credential_Type__c,MUSW__Status__c,Email__c
                                             from MUSW__License2__c 
                                             where  MUSW__Applicant__r.FirstName= :firstname
                                             and MUSW__Applicant__r.LastName= :lastname and MUSW__Applicant__r.Last_4_Digits_of_SSN__c =:ssn
                                             and Date_of_Birth__c=: dob]) {
                                                 lstlicense.add(accCon);                                              
                                             }
            
        }

        if(!lstlicense.isEmpty()){
            return lstlicense;  
        } else {
            return lstlicense;
        }
    }
    /**
* method 		: updateLicenseContact
* @description 	: To move all the details from one account to  loggedin user account
* @author 		: Mangesh
* @param <contactId> <contactId> to move all the details from one account to  loggedin user account
* @return <Success/Failure message> 
* */
   @AuraEnabled    
    public static String updateLicenseContact(String contactId) {
        DOL_AppUtility.isAuthenticatedUser() ;
        string str = '';
        Boolean isSucccess = false;
        List<Request__c>  lstrequset = new List<Request__c>();
        List<MUSW__Account_Contact__c> lstAssociation = new List<MUSW__Account_Contact__c>();
        List<BGBK__Cart__c> lstCart = new List<BGBK__Cart__c>();
        List<MUSW__License2__c> lstlicense = new List<MUSW__License2__c>();
        List<Contact>  lstContacts =[select id, (select id,ownerId,Contact__c from Requests__r),(select id,ownerId,MUSW__Contact__c from MUSW__Account_Contacts__r),
                                  (select id,MUSW__Applicant__c,ownerId from  MUSW__License2s__r),(select id,ownerId,BGBK__Contact__c from  BGBK__Carts__r) 
                                   from  Contact where Id =:contactId LIMIT 1];

        if(!lstContacts.isEmpty()) {
            if(!lstContacts[0].Requests__r.isEmpty()){
               lstrequset.addAll(lstContacts[0].Requests__r); 
            }
            if(!lstContacts[0].MUSW__Account_Contacts__r.isEmpty()){
                lstAssociation.addAll(lstContacts[0].MUSW__Account_Contacts__r);
            }
            if(!lstContacts[0].MUSW__License2s__r.isEmpty()) {
               lstlicense.addAll(lstContacts[0].MUSW__License2s__r);
            }
            if(!lstContacts[0].BGBK__Carts__r.isEmpty()) {
               lstCart.addAll(lstContacts[0].BGBK__Carts__r);   
            }
        } 
        
        User currentUser = [SELECT Id,Name,firstname,lastname,ContactId,email from User Where ID = :UserInfo.getUserId() LIMIT 1];
        Id owner = currentUser.Id;
        Savepoint sp = Database.setSavepoint();
        if(!lstlicense.isEmpty()){
            for(MUSW__License2__c license : lstlicense){
                license.MUSW__Applicant__c = currentUser.ContactId;
                license.ownerId = owner;
            }
            try{
              Database.update(lstlicense);
              //Utilityclass_withsharing.updateList(lstlicense);
              isSucccess = true;
            } catch (Exception ex) {
                isSucccess = false;
                DOL_CreateErrorLog_Exception.addError(ex,'DOL_License_Linking','updateLicenseContact');
                Database.rollback(sp);

            }
        } 
       if(!lstrequset.isEmpty()){
            for(Request__c request : lstrequset){
                request.Contact__c = currentUser.ContactId;
                request.ownerId = owner;
            }
            try {
                Database.update(lstrequset);
              //  Utilityclass_withsharing.updateList(lstrequset);
                isSucccess = true;        
            } catch (Exception ex) {
                isSucccess = false;
                DOL_CreateErrorLog_Exception.addError(ex,'DOL_License_Linking','updateLicenseContact');
                Database.rollback(sp);
            }
        } 
        if(!lstAssociation.isEmpty()){
            for(MUSW__Account_Contact__c accCon : lstAssociation){
                accCon.MUSW__Contact__c = currentUser.ContactId;
                accCon.ownerId = owner;
            }
            try {
              //  Utilityclass_withsharing.updateList(lstAssociation);
               Database.update(lstAssociation);
                isSucccess = true;        
            } catch (Exception ex) {
                isSucccess = false;
                DOL_CreateErrorLog_Exception.addError(ex,'DOL_License_Linking','updateLicenseContact');
                Database.rollback(sp);
            }
        } 
        if(!lstCart.isEmpty()){
            for(BGBK__Cart__c cart : lstCart){
                cart.BGBK__Contact__c = currentUser.ContactId;
                cart.ownerId = owner;
            }
            try {
                Database.update(lstCart);
              //   Utilityclass_withsharing.updateList(lstCart);
                 isSucccess = true;        
            } catch (Exception ex) {
                isSucccess = false;
                DOL_CreateErrorLog_Exception.addError(ex,'DOL_License_Linking','updateLicenseContact');
                Database.rollback(sp);
            }
        }        
        if(isSucccess) {
            str = 'Linked successfully';
        } else  {
            str= 'Some error occured ! Please contact system admin';
        }
        return  str;
    }

    @AuraEnabled
    public static List<String> getLicenseType() {
      DOL_AppUtility.isAuthenticatedUser() ;
      List<String> options = new List<String>();
        if(!Polaris_UtilityClass.getPicklist().isEmpty()) {
            options.addAll(Polaris_UtilityClass.getPicklist());
        }
        return options;
        
    }
    @AuraEnabled
    public static string sendActivationEmail(){
        DOL_AppUtility.isAuthenticatedUser() ;
        User currentUser = [SELECT Id,Name,firstname,lastname,ContactId,email 
                            from User Where ID = :UserInfo.getUserId() LIMIT 1];
        List<Contact> currentContact = [Select Email,Id,Last_4_Digits_of_SSN__c,FirstName,LastName,Birthdate 
                                        from Contact where ID =: currentUser.ContactId lIMIT 1];
        string message='';
        String maskedEmail ='';

        if(!currentContact.isEmpty()) {
            List<String> email= new List<String>();
            email.add(currentContact[0].Email);
            maskedEmail = email[0].replaceAll('(^[^@]{3}|(?!^)\\G)[^@]', '$1*');
        }
        message = 'Activation code will be emailed to' + ' ' + maskedEmail;
        return message;
    } 
    @AuraEnabled
    public static string sendActivationCodeEmail(){
        DOL_AppUtility.isAuthenticatedUser() ;
        User currentUser = [SELECT Id,Name,firstname,lastname,ContactId,email 
                            from User Where ID = :UserInfo.getUserId() LIMIT 1];
        List<Contact> currentContact = [Select Email,Id,Last_4_Digits_of_SSN__c,FirstName,LastName,Birthdate 
                                        from Contact where ID =: currentUser.ContactId lIMIT 1];
        OrgWideEmailAddress orgWideAddress = [select Id, DisplayName, Address from OrgWideEmailAddress where DisplayName = :label.Str_Org_Wide_Address];
          List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        String message='';
        List<Contact> lstContact = new List<Contact>();
        List<String> email= new List<String>();
        if(!currentContact.isEmpty()) {
            email.add(currentContact[0].Email);
             lstContact = [SELECT Email,Id,Name,Security_Code__c 
                                        from contact where Id !=: currentUser.ContactId
                                        AND FirstName =:currentContact[0].FirstName 
                                       AND LastName =: currentContact[0].LastName AND Last_4_Digits_of_SSN__c =:currentContact[0].Last_4_Digits_of_SSN__c Limit 1];
            
            
        } else {
            message =  Label.System_Admin_Contact_Message;
            return message;
        }
        if(!lstContact.isEmpty() && orgWideAddress != null && !email.isEmpty()) {
            for(Contact con : lstContact) {

                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setSubject('Activation code for professional linking license');
                mail.setHtmlBody('ActivationCode : ' +con.Security_Code__c);
                mail.setToAddresses(email);
                mail.setOrgWideEmailAddressId(orgWideAddress.Id);
                mails.add(mail);
            }

        } else {
            message= Label.System_Admin_Contact_Message;
            return message;
        }
        
        if(!mails.isEmpty()){
            Messaging.sendEmail(mails);
            string maskedEmail = email[0].replaceAll('(^[^@]{3}|(?!^)\\G)[^@]', '$1*');
            message = Label.Activation_Code_Sent_Message + ' ' + maskedEmail;
        }
        
        return message;
    }
}