public with sharing class Lnp_CommonHeader_AC {
    
 //   public static id recId;
    
    @AuraEnabled
    public static Map<String,String> getLabel() {
        try{
        Map<String, String> customLabelMap = new Map<String, String>();
        customLabelMap.put('LnP_CommonHeader_Home', System.Label.LnP_CommonHeader_Home);
        customLabelMap.put('LnP_CommonHeader_AboutUs', System.Label.LnP_CommonHeader_AboutUs);
        customLabelMap.put('LnP_CommonHeader_Service', System.Label.LnP_CommonHeader_Service);
        customLabelMap.put('LnP_CommonHeader_News', System.Label.LnP_CommonHeader_News);
        customLabelMap.put('LnP_CommonHeader_Support', System.Label.LnP_CommonHeader_Support);
        customLabelMap.put('LnP_CommonHeader_Register', System.Label.LnP_CommonHeader_Register);
        customLabelMap.put('LnP_CommonHeader_Login', System.Label.LnP_CommonHeader_Login);
        customLabelMap.put('LnP_ApplyLicense', System.Label.LnP_ApplyLicense);
        customLabelMap.put('LnP_Header_Description', System.Label.LnP_Header_Description);
        customLabelMap.put('LnP_Let_Us_Help_You', System.Label.LnP_Let_Us_Help_You);
        customLabelMap.put('LnP_News_Header', System.Label.LnP_News_Header);
        customLabelMap.put('LnP_View_All', System.Label.LnP_View_All);
        customLabelMap.put('LnP_News_Title', System.Label.LnP_News_Title);
        customLabelMap.put('LnP_News', System.Label.LnP_News);
        customLabelMap.put('LnP_Read_More', System.Label.LnP_Read_More);
        customLabelMap.put('LnP_News_Title1', System.Label.LnP_News_Title1);
        customLabelMap.put('LnP_Logo', System.Label.LnP_Logo);
        customLabelMap.put('LnP_License_FindTitle', System.Label.LnP_License_FindTitle);
        customLabelMap.put('LnP_License_FindSubtitle', System.Label.LnP_License_FindSubtitle);
        customLabelMap.put('LnP_SearchLocation', System.Label.LnP_SearchLocation);
        customLabelMap.put('LnP_Feedback_Main_Title', System.Label.LnP_Feedback_Main_Title);
        customLabelMap.put('LnP_Footer_Terms', System.Label.LnP_Footer_Terms);
        customLabelMap.put('LnP_Footer_Privacy', System.Label.LnP_Footer_Privacy);
        customLabelMap.put('LnP_Footer_Guide', System.Label.LnP_Footer_Guide);
        customLabelMap.put('LnP_Footer_Support', System.Label.LnP_Footer_Support);
        customLabelMap.put('LnP_complaint_Text', System.Label.LnP_complaint_Text);
        customLabelMap.put('LnP_Feedback_Subtitle', System.Label.LnP_Feedback_Subtitle);
        customLabelMap.put('LnP_Submit_Text', System.Label.LnP_Submit_Text); 
        customLabelMap.put('LnP_Thoughts_Title', System.Label.LnP_Thoughts_Title);
        customLabelMap.put('LnP_Complaint_Text_Lastcolumn', System.Label.LnP_Complaint_Text_Lastcolumn);
        customLabelMap.put('LnP_Provide_Feedback', System.Label.LnP_Provide_Feedback);
        customLabelMap.put('LnP_News_Title2', System.Label.LnP_News_Title2);
        customLabelMap.put('LnP_News1', System.Label.LnP_News1);
        customLabelMap.put('LnP_News2', System.Label.LnP_News2);
        customLabelMap.put('LnP_Footer', System.Label.LnP_Footer);
        customLabelMap.put('LnP_recordUrl', System.Label.LnP_recordUrl);
        customLabelMap.put('LnP_Licenses', System.Label.LnP_Licenses);
        customLabelMap.put('LnP_Praise', System.Label.LnP_Praise);
        customLabelMap.put('LnP_FileComplaint', System.Label.LnP_FileComplaint);
        customLabelMap.put('LnP_LicenseList', System.Label.LnP_LicenseList);
        customLabelMap.put('LnP_FooterTerms_URL', System.Label.LnP_FooterTerms_URL);
        customLabelMap.put('LnP_FooterPrivacy_URL', System.Label.LnP_FooterPrivacy_URL);
        customLabelMap.put('LnP_FooterGuide_URL', System.Label.LnP_FooterGuide_URL);
        customLabelMap.put('LnP_FooterSupport_URL', System.Label.LnP_FooterSupport_URL);
        
        
        return customLabelMap;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
    }
    
    @AuraEnabled
    public static Id saveChunk(String fileName, String base64Data, String contentType, String fileId) {
        try{
        if (fileId == '') {
            system.debug('inside the method of save chunk');
            fileId = saveTheFile( fileName, base64Data, contentType); 
        } else {
            system.debug('inside else');
            appendToFile(fileId, base64Data);
        }
        return Id.valueOf(fileId);
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
    }
    
    @AuraEnabled
    public static List<String> getContactUserInfo(){
         try{
         List<String> usrInfo = new List<String>();
       
         //List<User> userDetail = [select id,UserType,Name from User where ContactId=:conId];
         //String userType= userDetail[0].UserType;
         //String userName = userDetail[0].Name;
         
         usrInfo.add(userInfo.getUserType());
         //usrInfo.add(userDetail[0].Name);
         //usrInfo.add(userDetail[0].Id);
            //usrInfo.add(conId);
        
         return usrInfo;
         }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
      }
    
    @AuraEnabled  
    public static boolean isValidCommunityUser(){
        try
        {
        String validProfileName = 'eSLA Customer Community Plus Login User';
        Boolean isValid = true;
        User u  = [select id,Profile.name from user where id  =: UserInfo.getUserId() LIMIT 1];
        if(u != null){
            if(u.Profile.name != validProfileName){
                isValid = false;
            }
        }        
        return isValid;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
    }
    
    public static Id saveTheFile(String fileName, String base64Data,String contentType) {
        try
        {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        Document oAttachment=new Document();
        oAttachment.Name = fileName;
        oAttachment.Body = EncodingUtil.base64Decode(base64Data);
        oAttachment.ContentType = contentType;
        oAttachment.FolderId =System.Label.LnP_Shared_Document_Id;
        oAttachment.IsPublic=true;
        
        insert oAttachment;
        System.debug('oAttachment ::'+oAttachment);
      //  getImageText(oAttachment.id);
        //System.debug('recId----> ::'+oAttachment.id);
        return oAttachment.id;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
        
    }   
    
    private static string getSearchRec(List<String> parsedTextList1){
        // List<String> acc=parsedTextList1;
       String recId ='';
         return recId;
    }
    
    private static void appendToFile(Id fileId, String base64Data) {
        try{
        system.debug('inside append to file');
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        Document a = [
            SELECT Id, body
            FROM Document
            WHERE Id =: fileId
        ];
        
        String existingBody = EncodingUtil.base64Encode(a.body);
        system.debug('the body is:' +existingBody);
        a.body = EncodingUtil.base64Decode(existingBody + base64Data);
        
        update a;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            
        }
    }
    
    
}