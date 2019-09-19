public without sharing class CommunityRegistrationController {
    
    @AuraEnabled
    public static string registerNewCommunityUser(String firstN,String middleN,String lastN,String phoneN,String email,String pwd,String confirmpwd,string birthdate) 
    {
        try{
        List<User> existinguser = [Select ID,Username from User Where Username = :email Limit 1 ];
        String successmsg;
        if(!existinguser.isEmpty()){
            successmsg = DOL_AppConstants.NULL_EMPTY_STRING + 'User with this emailID  already exists!!';
        } else {
            Savepoint sp = Database.setSavepoint();
            Contact contactRecord ;
            
            try {
                contactRecord = handleAccountContactCreation(firstN,middleN,lastN,phoneN,email,pwd,confirmpwd,birthdate);
            } catch (DMLException dmEx) {
                successmsg = dmEx.getMessage();
                for (Integer i = 0; i < dmEx.getNumDml(); i++) {
                    Database.rollback(sp);
                }
            }
            try{
                if (contactRecord != null ) {
                     successmsg = handleCommunityUserOperations(contactRecord , contactRecord.AccountId , pwd ) ;
                }
            } catch(DMLException dmEx) {
                Database.rollback(sp);
                successmsg = dmEx.getMessage(); 
            }
            
        }
        
        return successmsg;
        }
        catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            return null;
        }
    }
    public static Contact handleAccountContactCreation(String firstN,String middleN,String lastN,String phoneN,String email,String pwd,String confirmpwd, String birthdate) {
        try{
        Contact retRes = null ;
        String passwordParameter = pwd;
        List<User> users = [Select Id FROM User WHERE Name =: System.Label.Admin_Name and isActive = true LIMIT 1  ] ;
        ID DEFAULT_ACCOUNT_OWNERID =  users[0].Id;
        Account acc = new Account(name = firstN + middleN + lastN,OwnerId = DEFAULT_ACCOUNT_OWNERID);
        insert acc;
        System.debug('Account Creation done' + acc.id);                                
        
        retRes = new Contact(
            LastName = lastN,
            FirstName = firstN,
            Email = email,
            AccountId = acc.Id,
            Birthdate =Date.valueOf(birthdate)
        );
        
        insert retRes ;
        System.debug('Contact Creation done' + retRes.id);                                      
        
        return retRes ;
        }
        catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            return null;
        }
    }
    public static String handleCommunityUserOperations(Contact con,  Id accId , string passwordIn  ) {
        try{
        system.debug('inside handle');
        profile profileId = [SELECT ID FROM profile WHERE name=: DOL_AppConstants.NULL_EMPTY_STRING + 'eSLA Customer Community Plus Login User'];
        String successmsg = DOL_AppConstants.NULL_EMPTY_STRING;
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
            
            u.Username = userNameInput;
            u.FirstName = con.firstName;
            u.LastName = con.lastName;
            u.ContactId = con.Id;
            u.ProfileId = profileId.Id; 
            transient string tempNickName = String.valueOf(Math.random()) + '-' + u.lastName;
            if (tempNickName.length() > 30 ) {
                tempNickName = tempNickName.substring(2, 30) ;
            }
            
            u.CommunityNickname = tempNickName ;
            u.Alias = fullname.substring(0, aliasLength);
            u.languagelocalekey = DOL_AppConstants.NULL_EMPTY_STRING + 'en_US';
            u.localesidkey = DOL_AppConstants.NULL_EMPTY_STRING + 'en_US';
            u.timezonesidkey = DOL_AppConstants.NULL_EMPTY_STRING + 'America/Tijuana';
            u.emailencodingkey = DOL_AppConstants.NULL_EMPTY_STRING + 'UTF-8';
            Id userId;
           /* List<User> existinguser = [Select ID,Username from User Where Username = :con.Email Limit 1 ] ;*/
             userId = Site.createExternalUser(u, con.AccountId, passwordIn);
            if(userId != null){
                successmsg = DOL_AppConstants.NULL_EMPTY_STRING + 'User created successfully';
            } else {
                successmsg = DOL_AppConstants.NULL_EMPTY_STRING + 'Please contact system admin';
            }
             
            
           
        } catch (Exception ex){
            successmsg = ex.getMessage();
            system.debug('exception'+ex.getMessage());
            successmsg = ex.getMessage();        
        }
        
        return successmsg ;
        }
        catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            return null;
        }
    }
    
        
    
}