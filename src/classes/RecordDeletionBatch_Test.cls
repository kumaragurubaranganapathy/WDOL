/**
* User Story: 212 - Deletion of Records
* Name: RecordDeletionScheduler_Test
* Type: Test Class
* Description: Test Class for RecordDeletionScheduler
* Date:        Developer/Company                    Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 07/30/2018   Srikanth Kottam/Deloitte           Initial Creation
**/
@isTest
public class RecordDeletionBatch_Test {
	@isTest
    static Id createData(){
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
        insert license;
        Id licId = license.Id;
        return licId;
    }
    
    @isTest
    static void testBatch(){
        Id licId = createData();
        Test.startTest();
        List<MUSW__License2__c> credList = [Select Id, Marked_for_Deletion__c from MUSW__License2__c where Id =: licId];
        for(MUSW__License2__c credential : credList){
            credential.Marked_for_Deletion__c = true;
        }
        update credList;
        List<Object_API_Setting__mdt> objectApi = [Select Id, MasterLabel, Object_API_Name__c from Object_API_Setting__mdt limit 200];
        for(Object_API_Setting__mdt objApi : objectApi){
            if(objApi.Object_API_Name__c != null){
                String Query = 'Select Id, Marked_for_Deletion__c from ' + objApi.Object_API_Name__c + ' where Marked_for_Deletion__c=true';
                RecordDeletionBatch batch = new RecordDeletionBatch(Query);
                Database.executeBatch(batch, 1);
            }
        }
        Test.stopTest();
    }
}