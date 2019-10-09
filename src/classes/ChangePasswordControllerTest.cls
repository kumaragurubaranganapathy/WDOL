/**
 * An apex page controller that exposes the change password functionality
 */
@IsTest public with sharing class ChangePasswordControllerTest {
     @IsTest(SeeAllData=true) public static void testChangePasswordController() {
        // Instantiate a new controller with all parameters in the page
        ChangePasswordController controller = new ChangePasswordController();
        controller.oldPassword = DOL_AppConstants.NULL_EMPTY_STRING + '123456';
        controller.newPassword = DOL_AppConstants.NULL_EMPTY_STRING + 'qwerty1'; 
        controller.verifyNewPassword = DOL_AppConstants.NULL_EMPTY_STRING + 'qwerty1';                
        
        System.assertEquals(controller.changePassword(),null);                           
    }    
}