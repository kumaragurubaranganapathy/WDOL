/**
* User Story: 88-Allow applicant to submit another initial application for the same application type  
* Name: AllowToCreateAnotherApplication_Test
* Type: Test Class
* Description: Test Class for AllowToCreateAnotherApplication
* Date:        Developer/Company                    Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 07/27/2018   Sharad Maheshwari/Deloitte           Initial Creation
**/
@isTest
public class AllowToCreateAnotherApplication_Test {
    
    String applicant;
    String applicationType;
    String credentialTypeOrProgramArea;
    String credentialOrPermitType; 
    String applicationMethod;
    	
    @isTest static void testCredentialApplication() {
        
        Global_Settings__c globalSettings = new Global_Settings__c(Name = Userinfo.getUserName(), Disable_Triggers__c = true);
        insert globalSettings;
        
        
        AllowToCreateAnotherApplication allowAnotherApp = new AllowToCreateAnotherApplication();
        //List<MUSW__License2__c> credentialList = news List<MUSW__License2__c>();
        
        Account ac = CreateTestDataUtility.createAccount();
        insert ac;
        
        Contact con = CreateTestDataUtility.createContact(ac.id);
        insert con;
        
        User u = CreateTestDataUtility.createCommunityUser(con.Id);
        System.runAs(u){
        Test.startTest();
        MUSW__License2__c license = CreateTestDataUtility.createLicense(ac.id, con.Id);		            
        //credentialList.add(license);        
        insert license;
		MUSW__License2__c license1 = CreateTestDataUtility.createLicense(ac.id, con.Id);		            
        license1.Application_Type__c = 'Trades Credential';
        license1.Credential_type__c = 'Dwelling Contractor';
        license1.Credential__c = 'Dwelling Contractor';
        license1.Application_Method__c = 'General Application';
        insert license1;
		MUSW__License2__c license2 = CreateTestDataUtility.createLicense(ac.id, con.Id);		            
        license2.Application_Type__c = 'Delegated Municipality';
        license2.Credential_type__c = 'Delegated Municipality Agent';
        license2.Credential__c = 'Delegated Agent - Plumbing';
        license2.Application_Method__c = 'General Application';
        insert license2;
		
        /*Testing Manufactured Homes Credential*/
        boolean allowAnotherAppResult = allowAnotherApp.AllowToCreateAnotherApplication(con.id, 
                                                                                  'Manufactured Homes', 
                                                                                  'Manufactured Homes Credential', 
                                                                                  'Manufactured Homes Installer', 
                                                                                  'Course Completion',
                                                                                   null);
		System.assertEquals(false, allowAnotherAppResult);            
        license.MUSW__Status__c = 'Submitted';
        update license;
		allowAnotherAppResult = allowAnotherApp.AllowToCreateAnotherApplication(con.id, 
                                                                                  'Manufactured Homes', 
                                                                                  'Manufactured Homes Credential', 
                                                                                  'Manufactured Homes Installer', 
                                                                                  'Course Completion',
                                                                               	   null);            
        System.assertEquals(false, allowAnotherAppResult);
		license.MUSW__Status__c = 'Active';
		update license;
		allowAnotherAppResult = allowAnotherApp.AllowToCreateAnotherApplication(con.id, 
                                                                                  'Manufactured Homes', 
                                                                                  'Manufactured Homes Credential', 
                                                                                  'Manufactured Homes Installer', 
                                                                                  'Course Completion',
                                                                                   null);            
        System.assertEquals(false, allowAnotherAppResult);
		license.MUSW__Status__c = 'Withdrawal';
		upsert license;
		allowAnotherAppResult = allowAnotherApp.AllowToCreateAnotherApplication(con.id, 
                                                                                  'Manufactured Homes', 
                                                                                  'Manufactured Homes Credential', 
                                                                                  'Manufactured Homes Installer', 
                                                                                  'Course Completion',
                                                                                   null);            
        //System.assertEquals(true, allowAnotherAppResult);
        /*Testing Manufactured Homes Titling*/
        /*boolean allowAnotherAppResult3 = allowAnotherApp.AllowToCreateAnotherApplication(con.id, 
                                                                                  'Manufactured Homes', 
                                                                                  'Manufactured Homes Titling', 
                                                                                  'Manufactured Homes Certificate of Title', 
                                                                                  'Additional Secured Party',
                                                                                   null);
		System.assertEquals(true, allowAnotherAppResult3);           
		*/
        //System.assertEquals(true, allowAnotherAppResult);
        /*Testing Trades Credential*/   
        boolean allowAnotherAppResult1 = allowAnotherApp.AllowToCreateAnotherApplication(con.id, 
                                                                                  'Trades Credential', 
                                                                                  'Dwelling Contractor', 
                                                                                  'Dwelling Contractor', 
                                                                                  'General Application',
                                                                                   ac.Id);
		System.assertEquals(false, allowAnotherAppResult1);            
        license1.MUSW__Status__c = 'Submitted';
        update license1;
		allowAnotherAppResult1 = allowAnotherApp.AllowToCreateAnotherApplication(con.id, 
                                                                                  'Trades Credential', 
                                                                                  'Dwelling Contractor', 
                                                                                  'Dwelling Contractor', 
                                                                                  'General Application',
                                                                               	   ac.Id);            
        System.assertEquals(false, allowAnotherAppResult1);
		license1.MUSW__Status__c = 'Active';
		update license1;
		allowAnotherAppResult1 = allowAnotherApp.AllowToCreateAnotherApplication(con.id, 
                                                                                  'Trades Credential', 
                                                                                  'Dwelling Contractor', 
                                                                                  'Dwelling Contractor', 
                                                                                  'General Application',
                                                                                   ac.Id);            
        System.assertEquals(false, allowAnotherAppResult1);
		license1.MUSW__Status__c = 'Withdrawal';
		upsert license1;
		allowAnotherAppResult1 = allowAnotherApp.AllowToCreateAnotherApplication(con.id, 
                                                                                  'Trades Credential', 
                                                                                  'Dwelling Contractor', 
                                                                                  'Dwelling Contractor', 
                                                                                  'General Application',
                                                                                   ac.Id);            
        //System.assertEquals(true, allowAnotherAppResult);
        /*Testing Delegated Municipality*/    
		boolean allowAnotherAppResult2 = allowAnotherApp.AllowToCreateAnotherApplication(con.id, 
                                                                                  'Delegated Municipality', 
                                                                                  'Delegated Municipality Agent', 
                                                                                  'Delegated Agent - Plumbing', 
                                                                                  'General Application',
                                                                                   ac.Id);
		System.assertEquals(false, allowAnotherAppResult2);            
        license2.MUSW__Status__c = 'Submitted';
        update license2;
		allowAnotherAppResult2 = allowAnotherApp.AllowToCreateAnotherApplication(con.id, 
                                                                                  'Delegated Municipality', 
                                                                                  'Delegated Municipality Agent', 
                                                                                  'Delegated Agent - Plumbing', 
                                                                                  'General Application',
                                                                               	   ac.Id);            
        System.assertEquals(false, allowAnotherAppResult2);
		license2.MUSW__Status__c = 'Active';
		update license2;
		allowAnotherAppResult2 = allowAnotherApp.AllowToCreateAnotherApplication(con.id, 
                                                                                  'Delegated Municipality', 
                                                                                  'Delegated Municipality Agent', 
                                                                                  'Delegated Agent - Plumbing', 
                                                                                  'General Application',
                                                                                   ac.Id);            
        System.assertEquals(false, allowAnotherAppResult2);
		license2.MUSW__Status__c = 'Withdrawal';
		upsert license2;
		allowAnotherAppResult2 = allowAnotherApp.AllowToCreateAnotherApplication(con.id, 
                                                                                  'Delegated Municipality', 
                                                                                  'Delegated Municipality Agent', 
                                                                                  'Delegated Agent - Plumbing', 
                                                                                  'General Application',
                                                                                   ac.Id);            
        //System.assertEquals(true, allowAnotherAppResult);
		/*Testing Plan Review*/                        
		allowAnotherAppResult = allowAnotherApp.AllowToCreateAnotherApplication(con.id, 
                                                                                  'Plan Review', 
                                                                                  'POWTS', 
                                                                                  'POWTS State-Owned Pirvy Registration', 
                                                                                  '',
                                                                                   ac.Id);            
        //System.assertEquals(true, allowAnotherAppResult);
		
		allowAnotherAppResult = allowAnotherApp.AllowToCreateAnotherApplication(con.id, 
                                                                                  'Permit to Operate', 
                                                                                  'Uniform Dwellings', 
                                                                                  'Wisconsin Uniform Camping Permit', 
                                                                                  '',
                                                                                   ac.Id);            
        //System.assertEquals(true, allowAnotherAppResult);

		allowAnotherAppResult = allowAnotherApp.AllowToCreateAnotherApplication(con.id, 
                                                                                  'Random', 
                                                                                  '', 
                                                                                  '', 
                                                                                  '',
                                                                                  ac.Id);            
        //System.assertEquals(true, allowAnotherAppResult);            
            Test.stopTest();
        }
		
        
    	
    }
    	

}