@isTest
public class LnP_LicenseQuestionsApex_Test {
    public static testmethod void LnP_LicenseQuestionsApexConstructor(){
Test.startTest();
        LnP_LicenseQuestionsApexController.getAllStaticTexts();
        LnP_LicenseQuestionsApexController.getPicklistOptions('test');
        LnP_LicenseQuestionsApexController.startAnApplication('Architects','Architect','General Application');
       // system.assert(mapJSON.size() > 0 );
Test.stopTest();

    }
}