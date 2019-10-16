@isTest
public class LnP_PageWiseCustomLabels_Test {
    
    public static testmethod void LnP_PageWiseCustomLabelsConstructor(){
        Map<String, String> labelMap = new Map<String, String>();
        Test.startTest();
        labelMap= LnP_PageWiseCustomLabels.fetchPageWiseLabel('ApplyForLicense');
        system.assert(labelMap.size() > 0 );
        Test.stopTest();
    }
}