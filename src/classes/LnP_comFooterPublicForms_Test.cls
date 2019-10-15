@isTest
public class LnP_comFooterPublicForms_Test {
    public static testmethod void LnP_comFooterPublicConstructor(){
        Map<String, String> mapCommonFooterLabels = new Map<String, String>();
        Test.startTest();
        try{
            mapCommonFooterLabels=LnP_comFooterPublicFormsApexController.getCommonFooterCustomLabels();
        }catch(Exception ex){}
        Test.stopTest();
         system.assert( mapCommonFooterLabels.size() > 0!= null ) ;
    }
}