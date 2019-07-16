@isTest
public class PortalForgotPassword_CC_Test {
	public static testMethod User createTestData(){
        Account acc = CreateTestDataUtility.createAccount(); 
        Insert acc;
        Contact con = CreateTestDataUtility.createContact(acc.Id);
        Insert con;
        User communityUser = CreateTestDataUtility.createCommunityUser(con.Id);
        insert communityUser;
        return communityUser;
    }
    public static testMethod void Pass(){
        User testCommunityUser = createTestData();
        system.runAs(testCommunityUser){
            Test.startTest();
            PortalForgotPassword_CC forgotPass = new PortalForgotPassword_CC();
            forgotPass.username = 'tuser@mailinator.com';
            forgotPass.resetPassword();
            Test.stopTest();
        }
    }
    public static testMethod void Fail(){
        User testCommunityUser = createTestData();
        system.runAs(testCommunityUser){
            Test.startTest();
            PortalForgotPassword_CC forgotPass = new PortalForgotPassword_CC();
            forgotPass.username = 'tuserNew@mailinator.com';
            forgotPass.lastfourSSN = '1111';
            forgotPass.password = 'Password';
            forgotPass.confirmPassword = 'hello';
            forgotPass.resetPassword();
            system.assertNotEquals(forgotPass.getResult(),null);
            Test.stopTest();
        }
    }
}