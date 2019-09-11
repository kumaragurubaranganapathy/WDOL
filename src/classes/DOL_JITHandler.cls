global without sharing class DOL_JITHandler implements Auth.SamlJitHandler {

    private class JitException extends Exception{
                
    }
    
    private class JITErrorObject {
        String errorMessage = DOL_AppConstants.NULL_EMPTY_STRING;
        String debugType = DOL_AppConstants.NULL_EMPTY_STRING;
        String debugMessage = DOL_AppConstants.NULL_EMPTY_STRING;
        
        public JITErrorObject(String errorMessage, String debugType, String debugMessage){
            this.errorMessage = errorMessage;
            this.debugType = encrypt(debugType);
            this.debugMessage = encrypt(debugMessage);
        }
        public JITException getJitException(){
            return new JitException(JSON.serialize(this));
        } 
    }
       
    global User createUser(Id samlSsoProviderId, Id communityId, Id portalId, String federationIdentifier, Map<String, String> attributes, String assertion) {
        try {   
            system.debug('federationIdentifier==='+federationIdentifier);
            system.debug('attributes==='+attributes);
            if(!validSAMLAttributes(attributes)){
                throw new JITErrorObject(DOL_AppConstants.sJITErrorMessageOne,DOL_AppConstants.sJITErrorMessageTwo,DOL_AppConstants.sJITErrorMessageThree).getJitException();
            }else{   
                User user = getUserByEmail(attributes.get(Label.SAML_Attribute_Email));
                system.debug('user***'+user);
                if (user != null){
                    If(user.ContactId == null){
                        System.debug('internal user=='+user);
                        
                        Contact portalUserContact = getContactByEmailAndName(attributes.get(Label.SAML_Attribute_Name),attributes.get(Label.SAML_Attribute_Email));
                        System.debug('existingcontact=='+portalUserContact);
                        
                        If(portalUserContact == null){   
                            Account acc = createAccount(attributes.get(Label.SAML_Attribute_Name),attributes.get(Label.SAML_Attribute_Email));
                            System.debug('acc=='+acc);
                            portalUserContact = createContact (attributes.get(Label.SAML_Attribute_Name),  attributes.get(Label.SAML_Attribute_Email), acc.id);
                            System.debug('newContact=='+portalUserContact);
                        }
                        user  = createUser (portalUserContact, federationIdentifier,attributes.get(Label.SAML_Attribute_User));
                    }else If(user.ContactId != null){
                        System.debug('existing portal user=='+user);
                        user.FederationIdentifier = federationIdentifier;
                         try{
                            update user;
                            system.debug('user :: '  + user);
                        }catch(Exception e){
                            System.debug('We cannot update this user :: ' + e.getMessage() + ' -- ' + e.getStackTraceString());
                        }
                    }
                    return user;
                }else{   
                    Contact portalUserContact = getContactByEmailAndName(attributes.get(Label.SAML_Attribute_Name),attributes.get(Label.SAML_Attribute_Email));
                     System.debug('existingcontact=='+portalUserContact);
                    //Contact newContact = new Contact();
                    //if contact record with Same emial ,FN and LN does not exist in Salesforce
                    If(portalUserContact == null){   
                        Account acc = createAccount(attributes.get(Label.SAML_Attribute_Name),attributes.get(Label.SAML_Attribute_Email));
                        System.debug('acc=='+acc);
                        portalUserContact = createContact (attributes.get(Label.SAML_Attribute_Name),  attributes.get(Label.SAML_Attribute_Email), acc.id);
                        System.debug('newContact=='+portalUserContact);
                    }
                    user  = createUser (portalUserContact, federationIdentifier,attributes.get(Label.SAML_Attribute_User));
                    return user;
                }
            }
        }catch(Exception ex){
            If(ex.getTypeName() == DOL_AppConstants.sJITException)
                throw ex;
            throw new JITErrorObject(DOL_AppConstants.sJITErrorMessageOne, 'Exception '+ ex.getTypeName(), ex.getMessage() + ' Trace ' + ex.getStackTraceString()).getJitException();
        }
    }

    global void updateUser(Id userId, Id samlSsoProviderId, Id communityId, Id portalId,
         String federationIdentifier, Map<String, String> attributes, String assertion) {
         User u = [SELECT Id, FirstName, ContactId FROM User WHERE Id=:userId];
             System.debug('updateUser Block'+u);
             System.debug('attributes**'+attributes);
    }
    
    private Boolean validSAMLAttributes(Map<String, String> attributes){
        return attributes.containsKey(Label.SAML_Attribute_User) && attributes.containsKey(Label.SAML_Attribute_Email) && attributes.containsKey(Label.SAML_Attribute_Name) ;
    }
    
    private User getUserByEmail(String email){
        List<User> users = [SELECT Id, Name, alias, Email, FederationIdentifier, ContactId FROM User WHERE Email = :email];
        if(users.size() > 0)
            return users[0];
        else
            return null;
    }
    
    private Contact getContactByEmailAndName(String name, String email){
        String userFullname = name; 
        String firstName  = DOL_AppConstants.NULL_EMPTY_STRING + '';
        String lastName  = DOL_AppConstants.NULL_EMPTY_STRING + '';

        if(userFullname.contains(' ')){
            String[] splitName = userFullname.split(' ');
            firstName = splitName[0];
            lastName = splitName[1];
        }else{
            lastName =  userFullname;
        }

        List<Contact> contacts = [SELECT Id, AccountId, FirstName, LastName, Email FROM Contact WHERE Email = :email AND FirstName= :firstName AND LastName=:lastName] ;
        System.debug('existing contacts'+contacts);
        if(contacts.size() > 0)
            return contacts[0];
        else
            return null;
    }

   /* private Account getAccountByEmail(String email)
    {
        List<Account> Account = [SELECT Id,Name,Email FROM Account WHERE Email = :email];
        If(Account.size() > 0)
            return Account[0];
        Else
            return null;
    }*/

    @TestVisible private  Contact createContact(String name,  String emailVal, String accountId){
        Id contRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        String userFullname = name; 
        String firstName  = DOL_AppConstants.NULL_EMPTY_STRING + '';
        String lastName  = DOL_AppConstants.NULL_EMPTY_STRING + '';

        if(userFullname.contains(' ')){
            String[] splitName = userFullname.split(' ');
            firstName = splitName[0];
            lastName = splitName[1];
        }else{
            lastName =  userFullname;
        }
        
        Contact contact = new Contact(
            FirstName = firstName,
            LastName = lastName,
            Email = emailVal,
            Recordtypeid = contRecordTypeId,
            AccountId = accountId
        );
        try{
            insert contact;
            system.debug('contact :: '  + contact);
        }catch(Exception e){
            System.debug('We cannot insert this contact :: ' + e.getMessage() + ' -- ' + e.getStackTraceString());
        }
        return contact;
    }
    @TestVisible private  Account createAccount(String name,  String emailVal){
        Id acctRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('User Account').getRecordTypeId();
        List<User> users = [Select Id FROM User WHERE Name =: System.Label.Admin_Name and isActive = true LIMIT 1  ] ;
        ID DEFAULT_ACCOUNT_OWNERID =  users[0].Id;
        
        Account account = new Account(
            Name = name,
            //Email = emailVal
            OwnerId = DEFAULT_ACCOUNT_OWNERID,
            RecordTypeId = acctRecordTypeId,
            Account_Status__c  = DOL_AppConstants.NULL_EMPTY_STRING + 'Active'
        );
        try{
            insert account;
            system.debug('account :: '  + account);
        }catch(Exception e){
            System.debug('We cannot insert this account :: ' + e.getMessage() + ' -- ' + e.getStackTraceString());
        }
        return account;
    }
   @TestVisible  private  User createUser(Contact contact, String fedId, String username) {
        User user = new User();
        if(contact!= null){
            user.FirstName  = contact.FirstName;
            user.LastName   = contact.LastName; 
            user.email  = contact.Email;
            user.Username = contact.Email+'.WADOL';
            }
        if(Dol_IntegrationUtil.isNotBlank(username)){
            String alias = DOL_AppConstants.NULL_EMPTY_STRING + ''; 
            if(username != null && username.length() > 5) {
                alias = username.substring(0, 5);
            }
            else if(username != null && username.length() <= 5){
              alias = username;  
            }
            user.Alias = alias;
            transient string tempNickName = String.valueOf(Math.random()) + '-' + contact.LastName  ;
            if (tempNickName.length() > 30 ) {
                tempNickName = tempNickName.substring(2, 30) ;
            }
            
            user.CommunityNickname = tempNickName ;
        }
        
        if( Dol_IntegrationUtil.isNotBlank(fedId)) {
            user.FederationIdentifier = fedId;
        }
                
        Profile p = [SELECT Id FROM Profile WHERE name =: DOL_AppConstants.NULL_EMPTY_STRING + 'eSLA Customer Community Plus Login User'];
        user.ProfileId = p.Id;
        user.ContactId = contact.Id;
        user.IsActive = true; 
        user.Languagelocalekey = DOL_AppConstants.NULL_EMPTY_STRING + 'en_US';
        user.Localesidkey = DOL_AppConstants.NULL_EMPTY_STRING + 'en_US';
        user.Timezonesidkey = DOL_AppConstants.NULL_EMPTY_STRING + 'America/Los_Angeles';
        user.Emailencodingkey = DOL_AppConstants.NULL_EMPTY_STRING + 'UTF-8';
        System.debug('user==**'+user);
        try{
            insert user;
            system.debug('user :: '  + user);
        }catch(Exception e){
            System.debug('We cannot insert this user :: ' + e.getMessage() + ' -- ' + e.getStackTraceString());
        }
        return user;
    }
    private static String encrypt(String data){
        //String keystr = WCB_App_SettingUtil.defaultSettings.Encryptionkey;
        String keystr = DOL_AppConstants.sJITKey;
        String algorithm = DOL_AppConstants.sJITAlgorithm;
        if(String.isEmpty(data)){
            return null;
        }
        Blob key = EncodingUtil.base64Decode(keystr);
        Blob blob_data = Blob.valueOf(data);
        return EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(algorithm, key, blob_data));

    }
}