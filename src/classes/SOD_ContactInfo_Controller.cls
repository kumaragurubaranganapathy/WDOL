public class SOD_ContactInfo_Controller {
@AuraEnabled 
    public static Contact fetchContact(){
     // query current user information  
     try{
      Contact oCon = [select id,Name,Salutation,FirstName,LastName,Birthdate,Email,MobilePhone FROM contact Where id =: userInfo.getUserId()];
        return oCon;
     }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
    }
}