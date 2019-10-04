@isTest
public class ContactValidatorTest {
  /*  @testSetup
    static void createData(){
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('User_Account').getRecordTypeId();
        Account acc = DOL_TestDataFactory.createAccount(accRecordTypeId);
        
        Id conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Contact').getRecordTypeId();
        Contact con = DOL_TestDataFactory.createContact(conRecordTypeId, acc.Id);
        
        List<Application_Field__c> lstAppFields = new List<Application_Field__c>();
        List<String> lstNames = new List<String>{'Email', 'Birthdate', 'Ethnicity__c', 'Phone', 'Gender__c', 'Driver_s_License_Number__c', 'Municipality__c', 'Birth_Country__c'};
            
            Application_Field__c appField = new Application_Field__c();
        for(String name : lstNames){
            appField = DOL_TestDataFactory.createApplicationField(name, 'Geologist', 'Geologist', 'Contact');
            appField.License__c = true;
            appField.Permit__c = true;
            lstAppFields.add(appField);
        }
        update lstAppFields;
    }
    
    @isTest
    static void validateTest(){
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Contact con = [SELECT Id, Birthdate, Birth_Country__c FROM Contact LIMIT 1];
        
        List<Application_Field__c> appField = [SELECT Id, Name FROM Application_Field__c];
        
        ValidationError error = new ValidationError();
        
        ContactValidator.validate(error, String.valueOf(con.Id), 'Geologist', 'Geologist', 'License__c');
        
        con.Birthdate = Date.newInstance(1999, 02, 09);
        con.Birth_Country__c = null;
        update con;
        ContactValidator.validate(error, String.valueOf(con.Id), 'Geologist', 'Geologist', 'License__c');
        
        ContactValidator.validate(error, String.valueOf(con.Id), 'POWTS', 'Building', 'Permit__c');
        
        
    }
    */
}