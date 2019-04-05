@isTest
public class CommunitiesRegistrationController_Test {

    static testmethod void  test_registerNewCommunityUser(){
        
        Test.startTest();
        
        Contact c =new Contact(Firstname = 'testfname', Middlename = 'R', Lastname = 'testLname', Email = 'test@mailinator.com');
        
        CommunitiesRegistrationController cgr = new CommunitiesRegistrationController();
        cgr.newCon = c;
        cgr.ssnForPage = '323-23-2345';
        cgr.birthDateString = '01/01/1970';
        cgr.passwordParameter = 'testpassword';
        cgr.registerNewCommunityUser();
        System.assert(cgr.registerNewCommunityUser() == null);
        test.stopTest();
    }
    
     /*static testmethod void  test_registerNewCommunityUserwithnoSSN(){
        
        Test.startTest();
        
        Contact c =new Contact(Firstname = 'testfname1', Middlename = 'R', Lastname = 'testLname1', Email = 'test@mailinator1.com');
        
        CommunitiesRegistrationController cgr = new CommunitiesRegistrationController();
        cgr.newCon = c;
        cgr.registerNewCommunityUser();
        
        test.stopTest();
    }*/
    
    
}