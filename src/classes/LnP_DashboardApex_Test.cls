@isTest
public class LnP_DashboardApex_Test {
    //Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business Account').getRecordTypeId()
    public static testmethod void LnP_DashboardApexonstructor(){
        LnP_BackgroundSection__c testBgRec = DOL_TestDataFactory.createBackgroundSection();
        MUSW__License2__c liceId = DOL_TestDataFactory.createLicense('012r000000074ci', 
                                                                    DOL_TestDataFactory.createAccount('012r000000074cO').Id, 
                                                                    'Appraisal Management Companies', 
                                                                    'Appraisal Management Company', 
                                                                    'General Application');
        testBgRec.License_Bg__c = liceId.Id;
        Map<String, String> mapJSON = new Map<String, String>();
        Test.startTest();
         LnP_DashboardApexController_2.checkActiveCart();
        LnP_DashboardApexController_2.helptextFetch();
        LnP_DashboardApexController_2.getDashboardJSON();
        LnP_DashboardApexController_2.fetchRenewalRelatedEmploymentNEducationalHistoryRecords('test');
        LnP_DashboardApexController_2.fetchLicenseRelatedEmploymentNEducationalHistoryRecords(liceId.Id);
             Test.stopTest();
        
    }
}