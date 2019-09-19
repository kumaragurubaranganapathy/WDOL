/**
 * Class containing tests for SiteRegisterController
 */
@IsTest public with sharing class SiteRegisterControllerTest {
    @IsTest(SeeAllData=true) static void testRegistration() {
        SiteRegisterController controller = new SiteRegisterController();
        controller.username = DOL_AppConstants.NULL_EMPTY_STRING + 'test@force.com';
        controller.email = DOL_AppConstants.NULL_EMPTY_STRING + 'test@force.com';
        controller.communityNickname = DOL_AppConstants.NULL_EMPTY_STRING + 'test';
        // registerUser will always return null when the page isn't accessed as a guest user
        System.assert(controller.registerUser() == null);    
        
        controller.password = DOL_AppConstants.NULL_EMPTY_STRING + 'abcd1234';
        controller.confirmPassword = DOL_AppConstants.NULL_EMPTY_STRING + 'abcd123';
        System.assert(controller.registerUser() == null);  
    }
}