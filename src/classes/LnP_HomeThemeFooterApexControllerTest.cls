@isTest
public class LnP_HomeThemeFooterApexControllerTest {

    public static testMethod void testMethod1(){
        
        test.startTest();
        List<de_HomeFooterUrlList__mdt> records =[select Label,URL__c from de_HomeFooterUrlList__mdt];
        LnP_HomeThemeFooterApexController.getUrlMap();
        LnP_HomeThemeFooterApexController.getFooterCustomLabels();
        test.stopTest();
    }
}