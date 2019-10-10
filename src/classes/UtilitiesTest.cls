@isTest
public class UtilitiesTest {
    @isTest
    static void testRecordCreations(){
        Id recType = Utilities.getRecordTypeForName('Contact', 'Contact');
        
        Set<String> fieldsToExclude = new Set<String>();
        fieldsToExclude.add('MiddleName');
        List<String> listStr = Utilities.getAllFieldsSObject('Contact', fieldsToExclude);
        
        List<String> listOfFields1 = Utilities.getAllFieldsSObject('Contact', fieldsToExclude, true);
        List<String> listOfFields2 = Utilities.getAllFieldsSObject('Contact', fieldsToExclude, false);
        
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('User_Account').getRecordTypeId();
        Account acc = DOL_TestDataFactory.createAccount(accRecordTypeId);
        
        Id contactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Contact').getRecordTypeId();
        Contact con = DOL_TestDataFactory.createContact(contactRecordTypeId, acc.Id);
        con.Email = 'test@test.com';
        update con;
        Contact contactProfile = Utilities.getFullProfileDetails(String.valueOf(con.Id));
        
        Boolean isGuestLoggedIn = Utilities.isGuestUserLoggedIn();
        
        Boolean checkingBlockedEmail = Utilities.checkBlockedEmail(con);
        con.Email = 'testing@test.com';
        update con;
        checkingBlockedEmail = Utilities.checkBlockedEmail(con);
        
        Boolean sandboxRun = Utilities.runningInASandbox();
        
        Date targetDate = Date.newInstance(2020, 02, 01);
        BusinessHours bh = [SELECT Id FROM BusinessHours WHERE IsDefault = true];
        Date nextBusDay = Utilities.getNextBusinessDay(bh.Id, targetDate);
        
        Set<String> setCred = Utilities.getallCredentials();
        
    }
}