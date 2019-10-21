@istest
public class Dol_Batch_UpdateLicenseStatusTest{
    @isTest static void test_method_one(){
        Id businessAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account acc= DOL_TestDataFactory.createAccount(businessAccount);
        acc.Email__c = 'test@mailinator.com';
        update acc;
        
        Id businessLicenseType = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c lic = DOL_TestDataFactory.createLicense(businessLicenseType, acc.Id, 'Architects', 'Architect', 'General Application');
        lic.MUSW__Expiration_Date__c = System.today();
        lic.MUSW__Status__c= 'Active';
        update lic;
        system.debug('lic'+lic);
        MUSW__License2__c lic1 = DOL_TestDataFactory.createLicense(businessLicenseType, acc.Id, 'Architects', 'Architect', 'General Application');
        lic1.MUSW__Expiration_Date__c= System.today();
        lic1.Late_Renewal_Eligible_End_Date__c = System.today();
		lic1.MUSW__Status__c= 'Expired';
        update lic1;
        
        test.startTest();
        list<MUSW__License2__c> lstlic =[SELECT ID,Name,MUSW__Expiration_Date__c,Late_Renewal_Eligible_End_Date__c,Renewal_Grace_Period_End_Date__c,Renewal_Eligible_Start_Date__c,MUSW__Status__c from MUSW__License2__c WHERE MUSW__Expiration_Date__c <= Today AND  MUSW__Status__c   in ('Active','Expired')];
        system.debug('lstlic'+lstlic);
        Dol_Batch_UpdateLicenseStatus sh1 = new Dol_Batch_UpdateLicenseStatus();

        String sch = '0 0 23 * * ?'; 
        system.schedule('Test Territory Check', sch, sh1); 
        test.stopTest();
    }
}