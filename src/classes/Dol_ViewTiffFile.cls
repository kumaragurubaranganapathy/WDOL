public class Dol_ViewTiffFile {
	public String url {get;set;}
	MUSW__Submission__c submission;
    
   	public Dol_ViewTiffFile(ApexPages.StandardController controller) {
    	submission = (MUSW__Submission__c)controller.getRecord();
    	System.debug('submission'+submission);
        if(submission!= null){
            submission = [select SAN_Image_URL__c from MUSW__Submission__c where id=:submission.id];
            if(submission.SAN_Image_URL__c!= null){
                 url = submission.SAN_Image_URL__c;
            }
            else {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'There is no attachmnet to preview'));
            }
            System.debug('url'+url);
        }
   }     
}