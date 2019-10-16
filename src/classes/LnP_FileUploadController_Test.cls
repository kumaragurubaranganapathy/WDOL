@isTest
public class LnP_FileUploadController_Test {
    public static testmethod void LnP_FileUploadConstructor(){
        try{
           
        Document document=new Document();
        document.Body = Blob.valueOf('Some Text');
        document.ContentType = DOL_AppConstants.NULL_EMPTY_STRING + 'application/pdf';
        document.DeveloperName = DOL_AppConstants.NULL_EMPTY_STRING + 'my_doc';
        document.IsPublic = true;
        document.Name = DOL_AppConstants.NULL_EMPTY_STRING + 'My Document';
        document.FolderId = [select id from folder where name =: DOL_AppConstants.NULL_EMPTY_STRING + 'Shared Documents'].id;
        insert document;
       
        Test.startTest();
        LnP_FileUploadController.deleteFiles(document.Id);        
        Test.stopTest();
         
        }catch(Exception ex){
        //    system.debug('Exception !! '+ ex.getMessage());
        }
    }    
}