@isTest
public class SharingUtilityController_Test {
    private static String licenseId;
    private static String permitId;
    private static String accountId;
    private static String contactId;
    private static string busaccountid;
    private static string buspermitId;
    
	@testsetup static void setupData() {
        // create acct
        List<Account> lstAccounts = new List<Account>();
        Account acc = CreateTestDataUtility.createAccount();
        lstAccounts.add(acc);
        Account acc1 = CreateTestDataUtility.createCitizenAccount(); 
        lstAccounts.add(acc1);
        Account acc2= CreateTestDataUtility.createBusinessAccount();
        lstAccounts.add(acc2);
        Database.insert(lstAccounts);
        accountId = acc.Id;
        busaccountid=acc2.id;
        Contact c = CreateTestDataUtility.createContact(acc.id);
        Date myDate = Date.newInstance(1960, 2, 17);
        c.BirthDate = myDate;
        c.Served_in_Military__c = 'No';
        Database.insert(c);     
        contactId = c.Id;
        
        Id recordTypeId = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Universal Default License Record Type').getRecordTypeId();
        MUSW__License2__c license = new MUSW__License2__c(RecordTypeId = recordTypeId,
                                                          Application_Type__c = 'Trades Credential', 
                                                          Credential_type__c = 'Dwelling Contractor', 
                                                          Credential__c = 'Dwelling Contractor', 
                                                          Application_Method__c = 'General Application',
                                                          musw__status__c = 'Pending', 
                                                          MUSW__Primary_Licensee__c = busaccountid, 
                                                          MUSW__Applicant__c = contactId, 
                                                          Non_US_Citizen__c = 'Yes');
        
        insert license;
        licenseId=license.id;
        
     /*   
        MUSW__permit2__c p = CreateTestDataUtility.createPermit(accountId,c.Id); 
        insert p;
        permitId=p.id; */
    }
    @isTest
    public static void testSharingInsertRecords() {
        List<sObject> sObj = new List<sObject>();
        List<Id> conId = new List<Id>();
        List<MUSW__License2__share> licShare = new List<MUSW__License2__share>();
        List<MUSW__License2__share> licSharefail = new List<MUSW__License2__share>();
        Map <Id, Id> cMap = new Map <Id, Id>();
        Set <Id> ContactIds = new Set<ID>();
        if(contactId != null || contactId != ''){
            ContactIds.add(contactId);
            conId.add(contactId);
            cMap.put(licenseId, contactId);
        }
        if(licenseId != null && licenseId != ''){
			MUSW__License2__share credShare = new MUSW__License2__share();     
            credShare.parentId = licenseId;
            credShare.UserOrGroupId = contactId;
            credShare.AccessLevel = 'Edit';
            credShare.RowCause = 'Insert_CredentialShare__c';
            licShare.add(credShare);
            credShare.RowCause = 'Insert_CredentialShare';
            licSharefail.add(credShare);
        }
        Test.startTest();
        SharingUtilityController su = new SharingUtilityController();
        su.Sharing_Utility_UpsertRecords(licShare);
        su.Sharing_Utility_UpsertRecords(licSharefail);
        if(!ContactIds.isEmpty()){
            su.Sharing_Utility_queryDelegatedUsers(ContactIds);
        }
        //su.Sharing_Utility_BreakObjectRelationship_for_UserUpgrade('MUSW__Primary_Licensee__c', conId, cMap, 'MUSW__License2__c');
        sObj = su.Sharing_Utility_QueryShareRecords(conId, 'Select Id, from Contact limit 1');
        sObj = su.Sharing_Utility_QueryShareRecords(conId, 'Select Id from Contact limit 1');
       
        Test.stopTest();
    }
}