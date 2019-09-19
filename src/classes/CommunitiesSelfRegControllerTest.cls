/**
 * An apex page controller that supports self registration of users in communities that allow self registration
 */
@IsTest public with sharing class CommunitiesSelfRegControllerTest {
    @IsTest(SeeAllData=true) 
    public static void testCommunitiesSelfRegController() {
        CommunitiesSelfRegController controller = new CommunitiesSelfRegController();
        controller.firstName = DOL_AppConstants.NULL_EMPTY_STRING + 'FirstName';
        controller.lastName = DOL_AppConstants.NULL_EMPTY_STRING + 'LastName';
        controller.email = DOL_AppConstants.NULL_EMPTY_STRING + 'test@force.com';
        controller.communityNickname = DOL_AppConstants.NULL_EMPTY_STRING + 'test';
        
        // registerUser will always return null when the page isn't accessed as a guest user
        System.assert(controller.registerUser() == null);    
        
        controller.password = DOL_AppConstants.NULL_EMPTY_STRING + 'abcd1234';
        controller.confirmPassword = DOL_AppConstants.NULL_EMPTY_STRING + 'abcd123';
        System.assert(controller.registerUser() == null);  
    }    
}