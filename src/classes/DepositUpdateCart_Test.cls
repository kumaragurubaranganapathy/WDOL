@isTest
public class DepositUpdateCart_Test {
    @isTest
    public static void testMethod1(){
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Id conRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        Contact con = DOL_TestDataFactory.createContact(conRecTypeId, a.Id);
        BGBK__Cart__c testCart = new BGBK__Cart__c(BGBK__Account__c= con.AccountId, 
                                                   BGBK__Contact__c= con.Id, 
                                                   BGBK__Expiration_DateTime__c=system.now().addDays(1));
        insert testCart;
        
        MUSW__Deposit__c dep = new MUSW__Deposit__c(Name='System Number',wadol_Program_Type__c= 'Architects',MUSW__Amount__c = 100);
        dep.BGBK__Cart__c = testCart.Id;
        insert dep;
        
        Id LicenseRecType = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        MUSW__License2__c lic = DOL_TestDataFactory.createLicense(LicenseRecType, a.Id, 'Architects', 'Architect', 'General Application');
        
        MUSW__Fee__c objFee = DOL_TestDataFactory.createFeeWithLicense('General',100.00,lic.id);
        objFee.BGBK__Cart__c = testCart.Id;
        update objFee;
        
        
        
    }

}