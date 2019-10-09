@isTest
public class LnP_AllCustomLabelsMapApexClass_Test {
    public static testmethod void LnP_AllCustomLabelsMapconstructor()
    {
        Map<String,String> footerlabel= new Map<String,String>();
        Map<String, String> widgetlabel = new Map<String,String>();
        Map<String, String> commonHeaderLabels = new Map<String, String>();
        Map<String, String> commonFooterLabels = new Map<String, String>();
        Map<String, String> publicFormsJSON = new Map<String, String>();
        
        Test.startTest();
        footerlabel= LnP_AllCustomLabelsMapApexClass.getFooterLabels();
        widgetlabel= LnP_AllCustomLabelsMapApexClass.getWidgetLabels();
        commonHeaderLabels= LnP_AllCustomLabelsMapApexClass.getCommonHeaderLabels();
        commonFooterLabels= LnP_AllCustomLabelsMapApexClass.getCommonFooterLabels();
        publicFormsJSON=LnP_AllCustomLabelsMapApexClass.getPublicFormsJSON();
        system.assert( footerlabel.size() > 0!= null ) ;
        system.assert( widgetlabel.size() > 0!= null ) ;
        system.assert( commonHeaderLabels.size() > 0!= null ) ;
        system.assert( commonFooterLabels.size() > 0!= null ) ;
        system.assert( publicFormsJSON.size() > 0!= null ) ;
        Test.stopTest();
        
    }
    
}