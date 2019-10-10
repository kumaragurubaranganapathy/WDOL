@isTest
public class AccountValidatorTest {
    @isTest
    static void validationMethod(){
        Application_Field__c appField1 = DOL_TestDataFactory.createApplicationField('Email__c', 'Camping Resorts', 'Camping Resort Company', 'Account');
        appField1.License__c = true;
        update appField1;
        Application_Field__c appField2 = DOL_TestDataFactory.createApplicationField('Email_Primary_Contact__c', 'Camping Resorts', 'Camping Resort Company', 'Account');
        appField2.License__c = true;
        update appField2;
        Application_Field__c appField3 = DOL_TestDataFactory.createApplicationField('Phone_Primary_Contact__c', 'Camping Resorts', 'Camping Resort Company', 'Account');
        appField3.License__c = true;
        appField3.Permit_Renewal__c = true;
        update appField3;
        
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_Account').getRecordTypeId();
        Account acc = DOL_TestDataFactory.createAccount(accRecordTypeId);
        
        Test.startTest();
        ValidationError ve = new ValidationError();
        
        AccountValidator.validate(ve, acc.Id, 'Camping Resort Company', 'Camping Resort Company', 'License__c');
        AccountValidator.validate(ve, acc.Id, 'Manufactured Homes Communities', 'Mechanical', 'Permit_Renewal__c');
        Test.stopTest();
    }
}