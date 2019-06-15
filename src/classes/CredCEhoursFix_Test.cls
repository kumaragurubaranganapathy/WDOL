/**
* Name: CredCEhoursFix_Test
* Type: Class
* Description: Test Class for CredCEhoursFix
* Date:        Developer/Company                   Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 02/08/2018   Srikanth Kottam/Deloitte          Initial Creation
**/
@isTest
public class CredCEhoursFix_Test {
    
    @testSetup
    public static void setupTestData(){
        Global_Settings__c globalSetting = new Global_Settings__c(Name = UserInfo.getUsername(), Disable_Triggers__c = true);
        insert globalSetting;
        
        /*Creating test Account*/
        Account acc = new Account();
        acc = CreateTestDataUtility.createAccount();
        /*Inserting test Account*/
        insert acc;
        
        /*Creating test Contact*/
        Contact con = CreateTestDataUtility.createContact(acc.Id);
        /*Inserting test Contact*/
        insert con;
        
        /*Creating test License*/
        Musw__License2__c license1 = CreateTestDataUtility.createLicense(acc.Id, con.Id);
        license1.Application_Type__c = 'Trades Credential'; 
        license1.Credential_type__c = 'Soil Professions';
        license1.Credential__c = 'Soil Tester';
        license1.Application_Method__c = 'Examination';
        license1.MUSW__Status__c = 'Active';
        date toddate = Date.today();
        date exdate = toddate.addYears(2);
        license1.MUSW__Expiration_Date__c = exdate;
        license1.CE_Hours__c = 7.0;
        insert license1;
        
        Classes__c cls1 = new Classes__c(Name='Test Class1', End_Date_Time__c= Date.today(), Hours__c=5.0, 
                                         Credential__c=license1.Id, CE_Status__c='Applied');
        insert cls1;
        
        Classes__c cls2 = new Classes__c(Name='Test Class2', End_Date_Time__c= Date.today(), Hours__c=3.0, 
                                         Credential__c=license1.Id, CE_Status__c='Applied');
		insert cls2;
        
        globalSetting.Disable_Triggers__c = false;
        update globalSetting;
    }
    
    static testMethod void testBatch(){
        
        MUSW__License2__c lic = [Select Id, MUSW__Applicant__c From MUSW__License2__c 
                                 where Credential__c = 'Soil Tester' limit 1];
        system.assertNotEquals(lic.id, null);
        Test.startTest();
        
        String query = 'Select id, name, CE_Hours__c, Renewal_Cycle_End_Date__c, '+
                   'Renewal_window__c, MUSW__Expiration_Date__c, LastModifiedBy.Name '+
            	   'from MUSW__License2__c where id = \'' +lic.id+'\'';
        system.debug('query>>>'+query);
        CredCEhoursFix obj = new CredCEhoursFix(query);
        DataBase.executeBatch(obj, 1); 
        
        Test.stopTest();
    }
}