@isTest
public class SharingUtilityController_Test {
  @isTest
    public static void testMethod1(){
        BGBK__Refund2__c ref = new BGBK__Refund2__c(BGBK__Amount__c = 100);
        SharingUtilityController uc = new SharingUtilityController();
        list<BGBK__Refund2__c> refList = new List<BGBK__Refund2__c>();
        refList.add(ref);
        uc.Sharing_Utility_InsertRecords(refList);
        uc.Sharing_Utility_UpsertRecords(refList);
    }
    
    @isTest
    public static void testMethod2(){
        BGBK__Refund2__c ref = new BGBK__Refund2__c(BGBK__Amount__c = 100);
        SharingUtilityController uc = new SharingUtilityController();
        list<BGBK__Refund2__c> refList = new List<BGBK__Refund2__c>();
        refList.add(ref);
        insert refList;
        uc.Sharing_Utility_DeleteRecords(refList);
    }
    
    @isTest
    public static void testMethod3(){
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Id conRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        Contact con = DOL_TestDataFactory.createContact(conRecTypeId, a.Id);
        Set<Id> conId = new Set<Id>();
        conId.add(con.id);
        
        SharingUtilityController uc = new SharingUtilityController();
        uc.Sharing_Utility_queryDelegatedUsers(conId);
        uc.Sharing_Utility_queryCustomMetaDataRecords('Account', 'Insert');
        uc.Sharing_Utility_getfieldMap('Account');
    }
    
    @isTest
    public static void testMethod4(){
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Id conRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        Contact con = DOL_TestDataFactory.createContact(conRecTypeId, a.Id);
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        Set<Id> accIdSet = new Set<Id>();
        accIdSet.add(a.Id);
        List<id> accIdList = new List<Id>();
        accIdList.add(a.Id);
        User u1 = DOL_TestDataFactory.createPortalUser('Portal Lname', 'pLnamePortal', profile1.Id, 'test785@mailinator.com', con.Id);
        List<User> uList = new List<User>();
        uList.add(u1);
        
        SharingUtilityController uc = new SharingUtilityController();
        uc.Sharing_Utility_contactUserMap(uList);
        uc.Sharing_Utility_QueryShareRecords(accIdList,'Select id from Account Limit 1');
        try{
            uc.Sharing_Utility_QueryShareRecords(accIdList,'Select');
        }catch(Exception ex){}
        
    }
    
    @isTest
    public static void testMethod5(){
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Id conRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        Contact con = DOL_TestDataFactory.createContact(conRecTypeId, a.Id);
        Map<Id,Id> accIdMap = new Map<Id,Id>();
        accIdMap.put(a.Id,a.Id);
        SharingUtilityController uc = new SharingUtilityController();
        try{
            uc.QueryAccountContacts(null,new List<MUSW__Account_Contact__c>(),'test');
        }catch(Exception ex){}
        
    }
    
    @isTest
    public static void testMethod6(){
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Id conRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        Contact con = DOL_TestDataFactory.createContact(conRecTypeId, a.Id);
        Map<Id,Id> accIdMap = new Map<Id,Id>();
        accIdMap.put(a.Id,a.Id);
        MUSW__Account_Contact__c accCont = DOL_TestDataFactory.createAccountContact(con.Id, a.Id);
        SharingUtilityController uc = new SharingUtilityController();
        try{
            uc.QueryAccountContacts(accIdMap,new List<MUSW__Account_Contact__c>(),'test');
        }catch(Exception ex){}
        
    }
    
}