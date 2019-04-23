/**
 * An apex page controller that takes the user to the right start page based on credentials or lack thereof
 */
public with sharing class CommunitiesLandingController {
    
    // Code we will invoke on page load.
    public PageReference forwardToStartPage() {
        Boolean isGuestUser = (UserInfo.getUserType() == 'Guest');
        
        //Set the default landing page to the guest user's home page
        PageReference landingPage = new PageReference(Label.URL_PortalHome_GuestUser);
        
        //If the current user is not a guest user then redirect to actual home page
        if(isGuestUser == false){
            landingPage = new PageReference(Label.URL_PortalHome);
        }
        
        return landingPage;
        //return Network.communitiesLanding();
    }
    
    public CommunitiesLandingController() {}
}