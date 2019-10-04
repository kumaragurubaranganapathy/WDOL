@isTest
public class DE_LandingPageCustomLabels_Test {
    @isTest
    public static void testGetFooterLabels(){
        DE_LandingPageCustomLabels.getFooterLabels();
    }
    
    @isTest
    public static void testGetPublicFormsJSON(){
        DE_LandingPageCustomLabels.getPublicFormsJSON();
    }
    
    @isTest
    public static void testGetCommonHeaderLabels(){
        Test.startTest();
        DE_LandingPageCustomLabels.getCommonHeaderLabels();
        Test.stopTest();
    }
    
    @isTest
    public static void testGetWidgetLabels(){
        DE_LandingPageCustomLabels.getWidgetLabels();
    }
    
    @isTest
    public static void testGetCommonFooterLabels(){
        DE_LandingPageCustomLabels.getCommonFooterLabels();
    }
    
    @isTest
    public static void testGetDashboardJSON1(){
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Id LicRecTypeId1 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        MUSW__License2__c lic1 = DOL_TestDataFactory.createLicense(LicRecTypeId1, a.Id, 'Architects', 'Architect', 'General Application');
        DE_LandingPageCustomLabels.getDashboardJSON();
    }
    @isTest
    public static void testGetDashboardJSON2(){
        Id AccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = DOL_TestDataFactory.createAccount(AccRecTypeId);
        Id LicRecTypeId2 = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        MUSW__License2__c lic2 = DOL_TestDataFactory.createLicense(LicRecTypeId2, a.Id, 'Architects', 'Architect', 'General Application');
        DE_LandingPageCustomLabels.getDashboardJSON();
    }
    
    @isTest
    public static void testGetWizardStaticTexts(){
        DE_LandingPageCustomLabels.getWizardStaticTexts();
    }
    
    @isTest
    public static void testIsValidCommunityUser(){
        DE_LandingPageCustomLabels.isValidCommunityUser();
    }
}