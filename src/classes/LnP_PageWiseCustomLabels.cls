public class LnP_PageWiseCustomLabels {
    public static Map<String, String> fetchPageWiseLabel(String pageName){
        Map<String, String> labelMap = new Map<String, String>();
        
        //<Code Addition>
        //String Cond1 = 'Personal Information icon';
      /*  list<LnP_SubSection_Icon__mdt> mappingIcons = new List<LnP_SubSection_Icon__mdt>();
        mappingIcons = [SELECT LnP_Icon_Name__c, LnP_Icon_SVG_Name__c from LnP_SubSection_Icon__mdt WHERE LnP_Page_Name__c =: pageName];
        for(LnP_SubSection_Icon__mdt A: mappingIcons){
            labelmap.put(A.LnP_Icon_Name__c , A.LnP_Icon_SVG_Name__c);
        } */
        
        for(LnP_SubSection_Icon__mdt mappingIcon : [SELECT LnP_Icon_Name__c, LnP_Icon_SVG_Name__c from LnP_SubSection_Icon__mdt WHERE LnP_Page_Name__c =: pageName]){
            labelmap.put(mappingIcon.LnP_Icon_Name__c , mappingIcon.LnP_Icon_SVG_Name__c);
        }
/*        String X;
        if(pageName=='ApplyForLicesne'){
	        for(Integer i=0; i<mappingIcons.size(); i++){
    	       X = mappingicons.get(i);
               labelMap.put(mappingIcons.get(i),mappingIcon.get(i));
        	}
        }
 */       //</Code Addition>
        //
        //
        //
        //
        //<Initial Code Snippet>
/*       if(pageName=='ApplyForLicense'){
            labelMap.put('Personal Information icon',System.Label.Personal_Information_icon);
            labelMap.put('Background Questions icon',System.Label.Backgroud_Information_icon);
            labelMap.put('Licensure Questions icon',System.Label.Licensure_Questions_icon);
            labelMap.put('Attachments icon',System.Label.Attachments_icon);
            labelMap.put('Review and Submit icon',System.Label.Review_and_Submit_icon);
            //<Code Addition>
            labelMap.put('Business Information icon',System.Label.Business_Information_icon);
            //</Code Addition>
        }
        //</Initial Code Snippet>        
        //
        //
        //
  */      //
        return labelMap;
    }
}