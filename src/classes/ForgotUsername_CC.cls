public class ForgotUsername_CC {
    public Contact con {get;set;}
    public String userName {get;set;}
    public boolean isGuestUserLoggedIn {get;set;}
    
    public ForgotUsername_CC() {
        con = new Contact();
        isGuestUserLoggedIn = Utilities.isGuestUserLoggedIn();
    }
    
    public void findUserName(){
        result = new ForgotUserRes();
        try
        {
            list<Contact> clist = new list<Contact>([SELECT Id, FirstName, LastName, Birthdate, Last_4_Digits_of_SSN__c 
                                                     From Contact Where 
                                                     FirstName =: con.firstName AND 
                                                     LastName =: con.lastName AND 
                                                     Birthdate =: con.Birthdate AND 
                                                     Last_4_Digits_of_SSN__c =: con.Last_4_Digits_of_SSN__c Limit 1]);
            if(cList.size() > 0)
            {
                list<User> ulist = new list<User>([SELECT Id, UserName, IsActive From User Where ContactId =: cList[0].Id LIMIT 1]);
                if(uList.size()>0)
                {
                    if(uList[0].IsActive == false)
                    {
                        result.isSuccess = false ;
                        result.message = label.Err_User_has_been_deactivated ;
                    }
                    else
                    {
                        result.isSuccess = true ;
                        result.message = uList[0].UserName;   
                    }
                }else
                {
                    result.isSuccess = false ;
                    result.message = label.Err_User_not_found_Please_Contact_us ;
                }
            }else
            {
                result.isSuccess = false ;
                result.message =System.Label.Err_ContactDoesntExistError ;
            }
        }catch(exception ex)
        {
            result.isSuccess = false ;
            result.message = 'Error : ' + ex.getMessage() ;
            ErrorLogger.logGeneralException(ex, UserInfo.getUserId(), 'ForgotUsername_CC', 'General exception', 'findUserName', 'ForgotUsername_CC', 'Low');
        }
    }
    public class ForgotUserRes{
        public boolean isSuccess {get;set;}
        public string message {get;set;}
    }
    
    public ForgotUserRes result ;
    public string getResult(){
        return JSON.serialize(result);
    }
}