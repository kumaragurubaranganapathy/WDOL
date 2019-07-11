@istest	
public class OwnerDesignerTest {
    @isTest
    public static void testSearchFunctionality() {
        
        List<Contact> contacts = ownerdesigner.getContacts('Test');
                Account acc = CreateTestDataUtility.createAccount();
        insert acc;
        Contact c = CreateTestDataUtility.createContact(acc.id);
        Date myDate = Date.newInstance(1960, 2, 17);
        c.BirthDate = myDate;
        c.Served_in_Military__c = 'No';
        Database.insert(c);     

        MUSW__permit2__c p = CreateTestDataUtility.createPermit(acc.id,c.Id); 
        insert p;
        Affiliation__c aff = new affiliation__C();
        aff.Status__c=Label.St_pending;
        aff.Type__c=Label.Str_Designer;
        aff.Permit_Plan_Review__c=p.id;
        insert aff;
       Database.UpsertResult testupsert=  ownerdesigner.upsertAffiliationRecords(aff);
        
    }
     @isTest
        public static void testFailedInsert2() {
        
        List<Contact> contacts = ownerdesigner.getContacts('Test');
                Account acc = CreateTestDataUtility.createAccount();
        insert acc;
        Contact c = CreateTestDataUtility.createContact(acc.id);
        Date myDate = Date.newInstance(1960, 2, 17);
        c.BirthDate = myDate;
        c.Served_in_Military__c = 'No';
        Database.insert(c);     

        MUSW__permit2__c p = CreateTestDataUtility.createPermit(acc.id,c.Id); 
        insert p;
        Affiliation__c aff = new affiliation__C();
        aff.Status__c=Label.St_pending;
        aff.Type__c=Label.Str_Owner;
        aff.Permit_Plan_Review__c=p.id;
        insert aff;
            Affiliation__c aff2 = new affiliation__C();
        aff2.Status__c=Label.St_pending;
        aff2.Type__c=Label.Str_Owner;
        aff2.Permit_Plan_Review__c=p.id;
       Database.UpsertResult testupsert=  ownerdesigner.upsertAffiliationRecords(aff2);
        
    }
    
    
       @isTest
        public static void testFailedInsert() {
        
        List<Contact> contacts = ownerdesigner.getContacts('Test');
                Account acc = CreateTestDataUtility.createAccount();
        insert acc;
        Contact c = CreateTestDataUtility.createContact(acc.id);
        Date myDate = Date.newInstance(1960, 2, 17);
        c.BirthDate = myDate;
        c.Served_in_Military__c = 'No';
        Database.insert(c);     

        MUSW__permit2__c p = CreateTestDataUtility.createPermit(acc.id,c.Id); 
        insert p;
        Affiliation__c aff = new affiliation__C();
        aff.Status__c=Label.St_pending;
        aff.Type__c=Label.Str_Designer;
        aff.Permit_Plan_Review__c=p.id;
        insert aff;
            Affiliation__c aff2 = new affiliation__C();
        aff2.Status__c=Label.St_pending;
        aff2.Type__c=Label.Str_Designer;
        aff2.Permit_Plan_Review__c=p.id;
       Database.UpsertResult testupsert=  ownerdesigner.upsertAffiliationRecords(aff2);
        
    }
    
     @isTest
        public static void testCorrectInsert() {
        
        List<Contact> contacts = ownerdesigner.getContacts('Test');
                Account acc = CreateTestDataUtility.createAccount();
        insert acc;
        Contact c = CreateTestDataUtility.createContact(acc.id);
        Date myDate = Date.newInstance(1960, 2, 17);
        c.BirthDate = myDate;
        c.Served_in_Military__c = 'No';
        Database.insert(c);     

        MUSW__permit2__c p = CreateTestDataUtility.createPermit(acc.id,c.Id); 
        insert p;
        Affiliation__c aff = new affiliation__C();
        aff.Status__c=Label.St_pending;
        aff.Type__c=Label.Str_Designer;
        aff.Permit_Plan_Review__c=p.id;
       Database.UpsertResult testupsert=  ownerdesigner.upsertAffiliationRecords(aff);
        
    }
}