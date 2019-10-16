/*
* User Story: 71 - Portal user password reset
*
* Name: PortalForgotPassword_CC
* Type: Custom Controller
* Description: Custom Controller for PortalForgotPassword component
*
* Date:        Developer/Company                    Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 07/02/2018   Srikanth Kottam/Deloitte           Initial Creation
*/
public class PortalForgotPassword_CC {
    public String userName {get;set;}
    public String lastfourSSN {get;set;}
    public String password {get;set;}
    public String confirmPassword {get;set;}
    public Boolean isSuccess{get;set;}
    
    public boolean isGuestUserLoggedIn {get;set;}

    public PortalForgotPassword_CC() 
    {
        isSuccess = false;
        isGuestUserLoggedIn = Utilities.isGuestUserLoggedIn();
    }


    public void resetPassword()
    {
        userName = userName.trim() ;
        result = new ForgotPasswordRes();
      //  system.debug('userName '+userName);        
       // List<User> users = [Select ID , Username from User where (username =: userName OR Alternate_Email__c =: userName) and isActive = true ] ;
        List<User> users = [Select ID , Username from User where username =: userName and isActive = true ] ;
     //   system.debug('users '+users);
        if(users.isEmpty() == false )
        {            
            Boolean isSuccess = Site.forgotPassword(users[0].Username);
            result.isSuccess = isSuccess ;
            result.message = DOL_AppConstants.NULL_EMPTY_STRING + 'An email has been sent to you at '+ users[0].Username +'. Click on the link in the email to complete Password reset. If you need further assistance, please contact your Department for additional information and support.' ;
           // system.debug('If loop>>>');
        }else
        {
           // system.debug('Else loop>>>');
            result.isSuccess = false ;
            result.message =  system.label.Str_Service_Help_Desk;
        }
    }
    
    public class ForgotPasswordRes
    {
        public boolean isSuccess {get;set;}
        public string message {get;set;}
    }
    
    public ForgotPasswordRes result ;
    public string getResult()
    {
        return JSON.serialize(result);
    }
    
}