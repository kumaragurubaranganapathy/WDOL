/**
* User Story: 212 - Deletion of Records
* Name: RecordDeletionScheduler_Test
* Type: Test Class
* Description: Test Class for RecordDeletionScheduler
* Date:        Developer/Company                    Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 07/30/2018   Kotam/Babita K/Deloitte           Initial Creation
**/
@isTest
public class RecordDeletionBatch_Test {
	public static testmethod void testBatch(){
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('User Account').getRecordTypeId();
        Id ConRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        Id LicRecTypeId = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        
        Account acc = DOL_TestDataFactory.createAccount(AccRecTypeId);  
        
        Contact con = DOL_TestDataFactory.createContact(ConRecTypeId,acc.id);
        
        MUSW__License2__c lic = DOL_TestDataFactory.createLicense(LicRecTypeId, acc.Id, 'Architects', 'Architect', 'General Application');
        lic.MUSW__Applicant__c =  con.Id;
        lic.Marked_for_Deletion__c =true;
        update lic;
        
        for(Object_API_Setting__mdt objApi : [Select Id, MasterLabel, Object_API_Name__c from Object_API_Setting__mdt limit 200]){
            if(objApi.Object_API_Name__c != null){
                String Query = DOL_AppConstants.NULL_EMPTY_STRING + 'Select Id, Marked_for_Deletion__c from ' + objApi.Object_API_Name__c + ' where Marked_for_Deletion__c=true';
                RecordDeletionBatch batch = new RecordDeletionBatch(Query);
                Database.executeBatch(batch, 1);
            }
        }
    }
}