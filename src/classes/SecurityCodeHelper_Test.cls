@isTest
public class SecurityCodeHelper_Test {
    
    public static testMethod void testContact()     {
        Test.startTest();
        
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('User Account').getRecordTypeId();
        Id ConRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        
        Account acc = DOL_TestDataFactory.createAccount(AccRecTypeId);
        acc.Security_Code__c ='accExtId';
        update acc;
        //securityCodeHelper.setAccountSecurityCode();
        Contact con = DOL_TestDataFactory.createContact(ConRecTypeId,acc.id);
        con.Security_Code__c = 'conExtId';
		update con;   
        //SecurityCodeHelper.setContactSecurityCode();
        Test.stopTest();
    }

}