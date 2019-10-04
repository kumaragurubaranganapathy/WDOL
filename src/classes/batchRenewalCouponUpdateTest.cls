@isTest
public class batchRenewalCouponUpdateTest {
    @isTest
    static void batchTest(){
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('User_Account').getRecordTypeId();
        Account acc = DOL_TestDataFactory.createAccount(accRecordTypeId);
        
        Id licRecordTypeId = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByDeveloperName().get('Business').getRecordTypeId();
        MUSW__License2__c lic = DOL_TestDataFactory.createLicense(licRecordTypeId, acc.Id, 'Cemeteries', 'Cemetery', 'General Application');
        
        lic.Print_Renewal_Coupon__c = 'No';
        lic.MUSW__Expiration_Date__c = Date.newInstance(2019, 12, 25);
        lic.Renewal_Eligible_Start_Date__c = Date.newInstance(2019, 05, 12);
        lic.Renewal_Grace_Period_End_Date__c = Date.newInstance(2019, 10, 01);
        lic.MUSW__Status__c = 'Active';
        update lic;
        
        batchRenewalCouponUpdate bR = new batchRenewalCouponUpdate();
        Database.executeBatch(bR);
    }
}