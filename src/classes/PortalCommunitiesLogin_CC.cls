/*
* User Story: 146 - Ability to log in
*
* Name: PortalCommunitiesLogin_CC
* Type: Custom Controller
* Description: Custom Controller for PortalCommunityLogin component
*
* Date:        Developer/Company                 	Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 06/27/2018   Srikanth Kottam/Deloitte           Initial Creation
*/
global with sharing class PortalCommunitiesLogin_CC {
    global String username {get;set;}
    global String password {get;set;}
    global Boolean userRememberMe{get;set;}
 //   public String securityBanner{get;set;}
 //   public Newsfeed__c instructions{get;Set;}
 //   public Newsfeed__c instructions2{get;Set;}
    public Boolean isUserLocked {get;Set;} 
    public String urlDocLicTypes {get; set;}
    public boolean isGuestUser {get;set;} 
    
    global PortalCommunitiesLogin_CC() {
        isUserLocked = false;
   //     securityBanner = new FetchInstructions().getInstructions('Login Security Message', Label.InstructionTypeName_Page);
   //     instructions = new FetchInstructions().getInstructionObject('Login Instructions', Label.InstructionTypeName_Page);
   //     instructions2 = new FetchInstructions().getInstructionObject('Login Instructions- No Account', Label.InstructionTypeName_Page);  
        
        for(Document doc : [Select Id From Document where Name = 'ListofLicenseTypes' order by LastModifiedDate desc limit 1]){
                urlDocLicTypes = '/servlet/servlet.FileDownload?file=' + doc.Id;
        }
        isGuestUser = Utilities.isGuestUserLoggedIn();
    }
    
    // Code we will invoke on page load.
   global PageReference forwardToAuthPage() {
        String startUrl = System.currentPageReference().getParameters().get('startURL');
        String displayType = System.currentPageReference().getParameters().get('display');
        return Network.forwardToAuthPage(startUrl, displayType);
    }
    
    global PageReference login()
    {
       loginMessage = '' ; 
       PageReference retRes = null ;
       
        try{
       isUserLocked = false;
       User loginUser = [select id,Name,UserName from User where UserName =: username.trim() AND IsActive = true limit 1]; 
       UserLogin userStatus = [SELECT Id,IsPasswordLocked,UserId FROM UserLogin WHERE UserId =: loginUser.Id  limit 1];    
       if(userStatus != null && userStatus.IsPasswordLocked){ 
                isUserLocked = true;
                loginMessage = 'Your account has been locked because you reached the maximum number of invalid logon attempts.Please try again in 30 minutes.'; 
                return retRes;
       }
       //userCookiesSet();
            if(password != '' || password != null){
                system.debug('username'+username);
                system.debug('password'+password);
                retRes =  Site.login(username, password, null); 
                system.debug('retRes'+retRes);
            }
       
        }catch(Exception e){
            retRes = null;
        }
       system.debug('retRes'+retRes);
        if(retRes == null)
       {
                loginMessage = 'Please check your username and password.';
       }else
       {  
               retRes.getParameters().put('retURL','/apex/Dashboard'); 
       }
        
       return retRes ; 
    }
    
    public string loginMessage {get;set;} 

    /*
    * @description: This method is to set or remove user info cookies
    * @param: none
    * @return type: none
    */
    global void userCookiesSet(){
        if(userRememberMe == true){
            Apexpages.currentPage().setCookies(new Cookie[]{new Cookie('prtlUsrName',username,null,315569260,true)});      
            Apexpages.currentPage().setCookies(new Cookie[]{new Cookie('prtlRemebrMe',String.valueof(userRememberMe),null,315569260,true)});
        } 
        else if(userRememberMe ==false){
            Apexpages.currentPage().setCookies(new Cookie[]{new Cookie('prtlUsrName',username,null,0,true)});      
            Apexpages.currentPage().setCookies(new Cookie[]{new Cookie('prtlRemebrMe',String.valueof(userRememberMe),null,0,true)});
        }
    }
    
}