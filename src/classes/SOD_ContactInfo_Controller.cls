public class SOD_ContactInfo_Controller {
@AuraEnabled 
    public static Contact fetchContact(){
     // query current user information  
      Contact oCon = [select id,Name,Salutation,FirstName,LastName,Birthdate,Email,MobilePhone FROM contact Where id =: userInfo.getUserId()];
        return oCon;
    }
}