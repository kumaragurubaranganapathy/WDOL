/**
* Name: LicenseUpdateBatch_Test
* Type: Test Class
* Description: Test Class for LicenseUpdateBatch
* Date:        Developer/Company                    Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 5-13-2019   Padmavathi D/Deloitte           Initial Creation
**/
@isTest
public class LicenseUpdateBatch_Test {
  @isTest
    static MUSW__License2__c createData(){
        List<Account> accList = new List<Account>();
        
        // Account Creation  
        Account a = CreateTestDataUtility.createAccount();
        accList.add(a);
        insert accList;
        
        // Contact Creation 
        Contact c = CreateTestDataUtility.createContact(a.Id);
        insert c;
        
        // Credential Creation 
       MUSW__License2__c license = CreateTestDataUtility.createLicense(a.id,c.id);
       license.MUSW__Status__c='Active';
       license.name=license.name+'1';
       license.MUSW__Expiration_Date__c=System.Today()-1;
       system.debug('***'+license);
       insert license;
       
       return license;
    }
    
    @isTest
    static void testBatch(){
        MUSW__License2__c lic = createData();
        Test.startTest();
        String Query = 'Select Id, MUSW__Status__c,MUSW__Expiration_Date__c from MUSW__License2__c where MUSW__Expiration_Date__c<Today and MUSW__Status__c=\'Active\'';
        LicenseUpdateBatch batch = new LicenseUpdateBatch(Query);
        Database.executeBatch(batch, 1);
        Test.stopTest();
    }
}