/**
 * An apex page controller that exposes the site login functionality
 */
@IsTest global with sharing class SiteLoginControllerTest {
    @IsTest(SeeAllData=true) global static void testSiteLoginController () {
        // Instantiate a new controller with all parameters in the page
        SiteLoginController controller = new SiteLoginController ();
        controller.username = DOL_AppConstants.NULL_EMPTY_STRING + 'test@salesforce.com';
        controller.password = DOL_AppConstants.NULL_EMPTY_STRING + '123456'; 
                
        System.assertEquals(controller.login(),null);                           
    }    
}