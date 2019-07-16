@isTest
public class UtilitiesTest 
{
    public static Id ContactId;
    public static Id AccountId;
    @testSetup static void setup() {
        Account acc = new Account();
        acc = CreateTestDataUtility.createAccount();
        insert acc;
        Contact con = CreateTestDataUtility.createContact(acc.Id);
        insert con;  
        ContactId = con.Id;
        MUSW__Permit2__c activePermit = CreateTestDataUtility.createPermit(acc.Id, con.Id);
        activePermit.musw__status__c = 'Active';
        List<MUSW__Permit2__c> permits = new List<MUSW__Permit2__c>{activePermit};
        insert permits;
        Renewal_Application__c renewalApplication = new Renewal_Application__c(Permit__c = permits[0].Id);
        insert renewalApplication;
    }
    
    public static testmethod void unitTestForRecordTypeCheck()
    {
        Test.startTest ();
        Id recId = [Select Id from RecordType where DeveloperName = 'Universal_Default_License_Record_Type' and sObjectType = 'MUSW__License2__c' limit 1 ].Id  ;
        
        system.assertEquals(recId,Utilities.getRecordTypeForName('MUSW__License2__c' , 'Universal Default License Record Type') ) ;
        Test.stopTest ();	
    }
    
    public static testMethod void unitTestToCheckGuestUser()
    {
        Test.startTest ();
        //Below should assert
        system.assert(!Utilities.isGuestUserLoggedIn()) ;
        
        // Create contact 
        Account acct = new Account(Name = 'Citizen') ;
        INSERT acct ;
        Contact profileRecord = new Contact(FirstName='Mr Profile ' , LastName = 'demo LastName' , AccountId = acct.Id ) ;
        INSERT profileRecord ;
        
        Contact con2 = Utilities.getFullProfileDetails(profileRecord.Id) ;
        
        system.assertEquals(profileRecord.Id , con2.Id) ;
        
        // All fields getAllFieldsSObject
        
        List<String> fieldsList = Utilities.getAllFieldsSObject('Contact' , new set<string>{'FirstName','LastName'}) ;
        List<String> fieldsLists = Utilities.getAllFieldsSObject('Contact' , new set<string>{'FirstName','LastName'},true) ;
        system.assert(fieldsList.size() > 0 ) ;
        Test.stopTest ();
    }    
    
    public static testMethod void checkedBlockedEmails()
    {
        Test.startTest ();
        //Below should assert
        system.assert(!Utilities.isGuestUserLoggedIn()) ;
        
        // Create contact 
        Account acct = new Account(Name = 'Citizen') ;
        INSERT acct ;
        Contact profileRecord = new Contact(FirstName='Mr Profile ' , LastName = 'demo LastName' , AccountId = acct.Id ,email='testing@test.com') ;
        INSERT profileRecord ;
        Utilities.checkBlockedEmail(profileRecord);
        utilities.runningInASandbox();
        Test.stopTest ();
    }    
    
    @isTest
    public static void testCreateInvoiceFail(){
        MUSW__Permit2__c permit = [Select Id from MUSW__Permit2__c limit 1];
        Test.startTest();
        Utilities.createInvoice(permit);
        Test.stopTest();
        List<BGBK__Bill__c> invoices = [Select Id from BGBK__Bill__c];
        System.assert(invoices.size() == 0, 'Invoices should not be created');
    }
    
    @isTest
    public static void testCreateInvoiceForPermit(){
        MUSW__Permit2__c permit = [Select Id from MUSW__Permit2__c limit 1];
        permit.Generate_Invoice__c = true;
        permit.MUSW__Total_Fees__c = 150.00;
        update permit;
        Test.startTest();
        Utilities.createInvoice(permit);
        Test.stopTest();
        List<BGBK__Bill__c> invoices = [Select Id from BGBK__Bill__c];
        System.assert(invoices.size() == 1, 'One Invoices should be created');
    }
    
    @isTest
    public static void testCreateInvoiceForPermitRenwal(){
        Renewal_Application__c renewal = [Select Id from Renewal_Application__c limit 1];
        renewal.Generate_Invoice__c = true;
        renewal.Total_Fees__c = 150.00;
        update renewal;
        Test.startTest();
        Utilities.createInvoice(renewal);
        Test.stopTest();
        List<BGBK__Bill__c> invoices = [Select Id from BGBK__Bill__c];
        System.assert(invoices.size() == 1, 'One Invoices should be created');
    }
    
    @isTest
    public static void testCommonUtilMethods(){
        String testString;
        System.assertEquals(true, CommonUtil.isBlank(testString), 'String should be blank');
        Decimal testNumber;
        System.assertEquals(true, CommonUtil.isNull(testNumber), 'Decimal should be null');
        testString = 'test';
        System.assertEquals(true, CommonUtil.isNotBlank(testString), 'String should not be null');
        Date testDate;
        System.assertEquals(true, CommonUtil.isDateBlank(testDate), 'Date should be blank');
        System.assertEquals(true, CommonUtil.isEmpty(new List<String>()), 'List should be blank');
        System.assertEquals(true, CommonUtil.isNotEmpty(new List<String>{'Test'}), 'List should not be Empty');
        System.assertEquals(10, CommonUtil.toInteger('10'), 'Should return number 10');
        System.assertEquals(10, CommonUtil.toDecimal('10'), 'Should return number 10');
        System.assertEquals(null, CommonUtil.getDateValue(''), 'Should return null date');
        System.assertEquals(Date.newInstance(2018, 10, 15), CommonUtil.getDateValue('2018-10-15'), 'Should return null date');
        System.assert(CommonUtil.getRecordTypes('Account') != null);
        System.assert(CommonUtil.getFields('Account') != null);
    }
}