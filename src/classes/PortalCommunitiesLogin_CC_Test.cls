@isTest
public class PortalCommunitiesLogin_CC_Test {
    public static testMethod User createTestData(){
        Account acc = CreateTestDataUtility.createAccount(); 
        Insert acc;
        Contact con = CreateTestDataUtility.createContact(acc.Id);
        Insert con;
        User communityUser = CreateTestDataUtility.createCommunityUser(con.Id);
        insert communityUser;
        return communityUser;
    }
    public static testMethod void LoginPass(){
        User testCommunityUser = createTestData();
        system.runAs(testCommunityUser){
            Test.startTest();
            PortalCommunitiesLogin_CC portalLogin = new PortalCommunitiesLogin_CC();
            portalLogin.userName = 'tuser@mailinator.com';
            portalLogin.password ='password';
            portalLogin.userRememberMe = true;
            portalLogin.loginMessage = 'test';
            portalLogin.forwardToAuthPage();
            portalLogin.login();
            portalLogin.userCookiesSet();
            Test.stopTest();
        }
        
    }
    public static testMethod void LoginFail(){
        User testCommunityUser = createTestData();
        system.runAs(testCommunityUser){
            Test.startTest();
            PortalCommunitiesLogin_CC portalLogin = new PortalCommunitiesLogin_CC();
            portalLogin.userName = 'test';
            portalLogin.password = null;
            portalLogin.userRememberMe = false;
            // portalLogin.loginMessage = 'test';
            // portalLogin.forwardToAuthPage();
            portalLogin.login();
            portalLogin.userCookiesSet();
            Test.stopTest();
        }
    }
    
}