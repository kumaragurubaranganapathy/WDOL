@isTest
public class ComplaintMainTriggerHandlerTest {
    public static testMethod void populateComplaintCountOnLicense(){
        
        //Insert License
        Map<Id,MUSW__Complaint2__c> compMap = new Map<Id,MUSW__Complaint2__c>();
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        
        Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c lic1 = DOL_TestDataFactory.createLicense(LicRecTypeId1, a.Id, 'Architects', 'Architect', 'General Application');
        
        MUSW__Complaint2__c complaintRecord1 = DOL_TestDataFactory.createComplaintRecord('Cemeteries','Active', lic1.Id);
        MUSW__Complaint2__c complaintRecord2 = DOL_TestDataFactory.createComplaintRecord('Cemeteries','Active', lic1.Id);
        
        ComplaintMainTriggerHandler comp = new ComplaintMainTriggerHandler();
        comp.AfterInsert(compMap);
    } 
    
    public static testMethod void populateZeroComplaintCountOnLicense(){
        
        //Insert License
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account accObj = DOL_TestDataFactory.createAccount(AccRecTypeId);
        
        Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c licObj = DOL_TestDataFactory.createLicense(LicRecTypeId1, accObj.Id, 'Architects', 'Architect', 'General Application');
        
        MUSW__Complaint2__c complaintRecord1 = DOL_TestDataFactory.createComplaintRecord('Cemeteries','Active', licObj.Id);
        MUSW__Complaint2__c complaintRecord2 = DOL_TestDataFactory.createComplaintRecord('Cemeteries','Active', licObj.Id);
        
        System.debug('***complaintRecord***'+complaintRecord1);  
        complaintRecord1.MUSW__State__c = 'Closed';
        complaintRecord2.MUSW__State__c = 'Closed';
        update complaintRecord1;
        update complaintRecord2;
        System.debug('***licObj**'+licObj);
        System.assertEquals(null, licObj.Open_Complaints__c);
        Database.DeleteResult delCompl = Database.delete(complaintRecord2.Id, false);
        System.assert(delCompl.isSuccess());
        Database.UndeleteResult undelCompl = Database.undelete(complaintRecord2.Id);
        System.assert(undelCompl.isSuccess());
    }    
    
}