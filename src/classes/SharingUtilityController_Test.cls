@isTest(SeeAllData=true)
public class SharingUtilityController_Test {
  @isTest
    public static void testMethod1(){
        BGBK__Refund2__c ref = new BGBK__Refund2__c(BGBK__Amount__c = 100);
        SharingUtilityController uc = new SharingUtilityController();
        list<BGBK__Refund2__c> refList = new List<BGBK__Refund2__c>();
        List<sObject> lstData = new List<sObject>{new MUSW__Animal__c(), new Account()};
         uc.Sharing_Utility_InsertRecords(lstData);
        refList.add(ref);
        
          uc.Sharing_Utility_UpsertRecords(refList);
          uc.Sharing_Utility_UpsertRecords(new List<Account>{new Account()});
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
        uc.Sharing_Utility_queryDelegatedUsers(new Set<Id>{a.id});
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
        User u1 = DOL_TestDataFactory.createPortalUser('PLname', 'pLtal', profile1.Id, 'test785@mailinator.com', con.Id);
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
    
    @isTest
    public static void testMethod7(){
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        
        Id conRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        Contact con = DOL_TestDataFactory.createContact(conRecTypeId, a.Id);
        
        Map<Id,Id> accIdMap = new Map<Id,Id>();
        accIdMap.put(a.Id,a.Id);
        
        MUSW__Account_Contact__c accCont = DOL_TestDataFactory.createAccountContact(con.Id, a.Id);
        
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        
        Set<Id> accIdSet = new Set<Id>();
        accIdSet.add(a.Id);
        
        List<id> accIdList = new List<Id>();
        accIdList.add(a.Id);
        
        User u1 = DOL_TestDataFactory.createPortalUser('Portal Lname', 'pLnamePortal', profile1.Id, 'test785@mailinator.com', con.Id);
        List<User> uList = new List<User>();
        uList.add(u1);
        
        Schema.SObjectType accountType = Schema.getGlobalDescribe().get('Account');
        SObject newAccount = accountType.newSObject();
        
        String objectRelationShip = 'MUSW__License2__c.Ultimate_Parent_Account__c';
        SharingUtilityController uc = new SharingUtilityController();
        uc.Sharing_Utility_BreakObjectRelationship(objectRelationShip, accIdSet, accIdMap, newAccount);
        
        
        String objectRelationShip2 = 'MUSW__License2__c.MUSW__Applicant__c';
        
        Schema.SObjectType contactType = Schema.getGlobalDescribe().get('Contact');
        SObject newContact = contactType.newSObject();
        
        List<Id> contactIds = new List<Id>();
        contactIds.add(con.Id);
        
        Map<Id,Id> conObjMap = new Map<Id,Id>();
        conObjMap.put(con.Id, con.Id);
        
        uc.Sharing_Utility_BreakObjectRelationship_for_UserUpgrade(objectRelationShip2, contactIds, conObjMap, newContact);
     }
    
    @isTest
    public static void testMethod8(){
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        
        Id conRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        Contact con = DOL_TestDataFactory.createContact(conRecTypeId, a.Id);
        
        MUSW__Account_Contact__c accCont = DOL_TestDataFactory.createAccountContact(con.Id, a.Id);
        List<Id> conList = new List<Id>();
        conList.add(con.Id);
        
        Set<Id> accIdSet = new Set<Id>();
        accIdSet.add(a.Id);
        
        Set<Id> conId = new Set<Id>();
        conId.add(con.Id);
            
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User u1 = DOL_TestDataFactory.createPortalUser('Portal Lname', 'pLnamePortal', profile1.Id, 'test785@mailinator.com', con.Id);
        List<User> uList = new List<User>();
        uList.add(u1);
        Profile profile2 = [Select Id from Profile where name = 'eSLA Customer Community Plus Login User'];
        User u2 = DOL_TestDataFactory.createPortalUser('Portal Lname', 'pLtal', profile2.Id, 'test785@mailinator.com', con.Id);
        insert u2;
        Map<Id,Id> accIdMap = new Map<Id,Id>();
        accIdMap.put(a.Id,a.Id);
        
        Map<Id,Id> accConMap = new Map<Id,Id>();
        accConMap.put(a.Id, accCont.Id);
        
        Map<Id,List<Id>> conAccConMap = new Map<Id,List<Id>>();
        conAccConMap.put(accCont.Id,conList);
        
        Map<Id,Id> conUserMap = new Map<Id,Id>();
        conUserMap.put(con.Id,u1.Id);
        
        Id LicenseRecType = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        MUSW__License2__c lic = DOL_TestDataFactory.createLicense(LicenseRecType, a.Id, 'Architects', 'Architect', 'General Application');
        
        BGBK__Cart__c testCart = new BGBK__Cart__c(BGBK__Account__c= con.AccountId, 
                                                   BGBK__Contact__c= con.Id, 
                                                   BGBK__Expiration_DateTime__c=system.now().addDays(1));
        insert testCart;
        
        MUSW__Fee__c objFee = DOL_TestDataFactory.createFeeWithLicense('General',100.00,lic.id);
        objFee.BGBK__Cart__c = testCart.Id;
        update objFee;
        
        Set<Id> feeList = new Set<Id>();
        feeList.add(objFee.Id);
		     
        SharingUtilityController uc = new SharingUtilityController();
        test.startTest();
        
        uc.dynamicShareObjectUpsert(accIdMap, accConMap, conAccConMap, conUserMap, 'MUSW__Fee__c', 'Insert_Fee_Share__c', 'Edit');
        // uc.dynamicShareObjectUpsert(accIdMap, accConMap, conAccConMap, conUserMap, ' ', 'Insert_Fee_Share__c', 'Edit');
        uc.ShareRecordProcessingUtility(feeList, 'MUSW__Fee__c', 'After Insert', '', 'Share_Credential_Fee_on_insert');
        uc.ShareRecordProcessingUtility(feeList, 'MUSW__Fee__c', 'After Insert', '', 'Create_Fee_by_Delegate__c');
        uc.ShareRecordProcessingUtility(conId, 'MUSW__Permit2__c', 'After Insert', '', 'Insert_PermitShare__c');
        uc.shareRecords(accIdMap, accIdSet, 'Id', 'Edit', '', 'Account', 'Manual');
        uc.shareRecords(accIdMap, accIdSet, 'MUSW__Account__c', 'Edit', '', 'MUSW__Account_Contact__c', 'Share_Account_Contact__c');
        uc.ShareRecords_CreatedByDelegate(conList, conList, 'Contact', '');
        uc.ShareRecords_CreatedByDelegate(conList, conList, 'MUSW__Fee__c', '');
        test.stopTest();
    }
    
    
}