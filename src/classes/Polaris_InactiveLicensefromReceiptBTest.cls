@isTest
public class Polaris_InactiveLicensefromReceiptBTest {
    
    public static testMethod void testBatch(){
        
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('User Account').getRecordTypeId();
        Id ConRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        Id LicRecTypeId = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        
        Account acc = DOL_TestDataFactory.createAccount(AccRecTypeId);   
        Id licRecordTypeId = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        MUSW__License2__c licenseObj = DOL_TestDataFactory.createLicense(licRecordTypeId,acc.Id,'Funerals','Embalmer Intern','General Application');
        licenseObj.MUSW__Status__c = 'Draft';
        licenseObj.Polaris_DHP__c = true;
        update licenseObj;
        
        MUSW__Fee__c fee = DOL_TestDataFactory.createFeeWithLicense('Credential', 100.00 ,licenseObj.Id);
       fee.MUSW__Amount_Paid__c = 50.00;
        update fee;
        
        MUSW__Receipt__c rec = DOL_TestDataFactory.createReceipt('Cash',100.00,'Counter');
        rec.DHP__c = true;
        rec.Inactivate_License_Date__c = System.today();
        update rec;

		MUSW__Fee_Payment__c feePayment = new MUSW__Fee_Payment__c();
       feePayment.MUSW__Fee__c = fee.Id;
        feePayment.MUSW__Receipt__c = rec.Id;
        insert feePayment;
        
        test.startTest();
        Polaris_InactiveLicensefromReceiptBatch obj = new Polaris_InactiveLicensefromReceiptBatch();
        Database.executeBatch(obj);
        test.stopTest();
        
        
    }     
    
}