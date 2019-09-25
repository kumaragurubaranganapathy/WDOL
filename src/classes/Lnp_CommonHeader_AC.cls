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
    @AuraEnabled
    public static string getImageText(String imageId){
        try{
        system.debug('inside getImageTExt method');
        //using post method
        
        String orgUrlLabel=System.Label.LnP_orgUrl;
        String OidLabel = System.Label.Lnp_oId;
        Http http = new Http();
        HttpRequest  request = new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint('https://api.ocr.space/parse/image');
        request.setHeader('apikey', 'bef478ae1688957');
        
       /*     document doc=[select id,name from document where id =:imageId];
        if(doc.Name.contains('.jpg')){
            doc.name.replace('.jpg','.jpeg');
          }
        insert doc;*/
        
        //request.setHeader('User-Agent', 'Mozilla/5.0 desktop Mobile');
       request.setHeader('content-type', 'multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW');
        //request.setHeader('content-type', 'image/jpg');
        //String bodyStr = '------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data;  name=\"url\"\r\n\r\n'+orgUrlLabel+imageId+'&oid='+OidLabel+ '\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data;  name=\"isOverlayRequired\"\r\n\r\nfalse\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data;  name=\"iscreatesearchablepdf\"\r\n\r\nfalse\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW';
      //  bodyStr. =
        //request.setBody('------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name=\"url\"\r\n\r\nhttps://deloittelnp--c.na57.content.force.com/servlet/servlet.ImageServer?id=0150b0000025hsV&oid=00D0b000000CV3R\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-DisposContent-Disposition: form-data;  name=\"isOverlayRequired\"\r\n\r\nfalse\r\------WebKitFormBoundary7MA4YWxkTrZu0gW--');
       String bodyStr ='------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data;  name=\"url\"\r\n\r\n'+orgUrlLabel+imageId+'&oid='+OidLabel+ '\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW--';
        request.setBody(bodyStr);
        system.debug('## '+ request);
        HttpResponse response = http.send(request);
        system.debug('\n Response = ' +response.getBody());
        String imageText=response.getBody();
        system.debug('the value of imageText:' +imageText);
        //ImageInfo result1 = ImageInfo.parse(imageText.ParsedText);
        
        ImageInfo result = ImageInfo.parse(imageText);
        system.debug('the result' +result);
        List<ImageInfo.ParsedResults> parsedResultList = result.ParsedResults;
        system.debug('the parsedResultList' +parsedResultList);
        List<String> output = new List<String>();
        for(ImageInfo.ParsedResults e : parsedResultList){
            output.add(e.ParsedText);
        }
        system.debug('the output' +output);
        system.debug(' result created'+ output.size() );
        List<String> parsedTextList = new List<String>();
        List<String> Output1 = new List<String>();
        list<String> arr = null;
        for(String str : output){
            arr = str.split('\r\n');
            System.debug('## arr ' + arr.size());
            for(String a : arr ){
                system.debug('a'+ a);
                parsedTextList.add(a.trim());
            }
        }
        
        system.debug('the parsedlist' +parsedTextList);
        
        
        for(Integer i =0;i<parsedTextList.size();i++){
            Output1.add(parsedTextList.get(i));
            System.debug(parsedTextList.get(i)+' index = '+i);
        }
        string recordiD  = '';
      
      recordiD= getSearchRec(parsedTextList);
        system.debug('the val of:' +recordiD);
        return recordiD;
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