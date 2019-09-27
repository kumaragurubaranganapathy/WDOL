public class Dol_ViewTiffFile {
  public String url {get;set;}
  MUSW__Submission__c submission;
    public ImageBody imagebody {get;set;}
    public String imageToken {get;set;}
    public Dol_ImageTokenResponse tokenResponse;
    
    public Dol_ViewTiffFile(ApexPages.StandardController controller) {
      submission = (MUSW__Submission__c)controller.getRecord();
        if(submission!= null){
            imagebody = new ImageBody();
            
            submission = [select id,SAN_Image_URL__c,SAN_Prof_Code__c,MUSW__License2__c,MUSW__License2__r.Profession_Code__c from MUSW__Submission__c where id=:submission.id AND id != null];
            if(submission.MUSW__License2__c == null && submission.SAN_Prof_Code__c != null){
              imagebody.ProfessionCode = submission.SAN_Prof_Code__c;
            }else if(submission.MUSW__License2__c != null && submission.MUSW__License2__r.Profession_Code__c != null){
              imagebody.ProfessionCode = submission.MUSW__License2__r.Profession_Code__c;
            }
            //imagebody.polarisId = submission.id;
            String userName = UserInfo.getUserName();
            User activeUser = [Select Email From User where Username = : userName AND Username != null limit 1];
            imagebody.userName = activeUser.Email;
            String imageId = DOL_AppConstants.NULL_EMPTY_STRING;
            
            imagebody.ImageName = imageId;
            if(!Test.isRunningTest()) {
              imagebody.sourceIP = Auth.SessionManagement.getCurrentSession().get('SourceIp');
                if(submission.SAN_Image_URL__c!= null){
                 //imagebody.ImageLink = submission.SAN_Image_URL__c;
                 String imageIdWithTif = submission.SAN_Image_URL__c.substringAfterLast('\\');
                 imageId = imageIdWithTif.removeEnd('.tif');
              }
            }
            else {
                imagebody.sourceIP = 'dummy sourceIp';
                imageId = 'testImage';
            }
            imagebody.ImageName = imageId;
            getimageToken(); 
            System.debug('imageToken'+imageToken);
        }
   } 
    public String getimageToken(){
        imageToken = DOL_AppConstants.NULL_EMPTY_STRING;
        tokenResponse = new Dol_ImageTokenResponse();
        HttpResponse apiRespone = Dol_RestAPIservice.getTokenImage(imagebody);
        System.debug('image token apiRespone=='+apiRespone); 
            if(apiRespone.getStatusCode() == 200){
                tokenResponse = (Dol_ImageTokenResponse)JSON.deserialize(apiRespone.getBody(), Dol_ImageTokenResponse.class);
            }
        if(tokenResponse != null && tokenResponse.imageToken != null){
            imageToken = tokenResponse.imageToken.imageTokenID != null ? tokenResponse.imageToken.imageTokenID.trim() : '';
        }
        System.debug('imageToken'+imageToken); 
        return imageToken;
    }
   public class ImageBody {
       public String ImageTokenID;
       public String ImageTokenDate;
       public String ProfessionCode; //27708
       public String ImageName; //20190820155444175
       public String UserName; //lmusic@dol.wa.gov
       public String SourceIP;
       public String ImageLink; //\dolimgdata2dev.dol.wa.govData2BPDAppraiserspd1982090820155444018.tif  
       public String ValidToken;
       public String ErrorCode;
       public String ErrorMessage;
   }    
}