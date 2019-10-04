@isTest
public class ValidationErrorTest {
    public static testmethod void testValidationErrorMethod(){
        ValidationError ve = new ValidationError();
        //Sobject_Field_Testing sft = new Sobject_Field_Testing();
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('User Account').getRecordTypeId();
        //Insert Account
        Account acc = new Account(Name= 'Test Account');
        acc.RecordTypeId = AccRecTypeId;
        acc.Account_Status__c = 'Active';
        Test.startTest();
        insert acc;
        Test.stopTest();
        ve.addError(acc.Account_Status__c,'Error In Field');
        ve.addError( acc.Account_Status__c, 'Background Section', 'Error In Field', 1 );
        ve.addCompError('BusinessAddress', 'ErrorMessage');
        ve.hasErrors();
        ve.serializeErrors();
        ve.serializeCompErrors();
        Sobject_Field_Testing.getRequiredFields('Account');
    }
}