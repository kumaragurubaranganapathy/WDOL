public with sharing class LnP_FileUploadController {
 
 
    @AuraEnabled
    public static void deleteFiles(Id documentId){
        List<ContentDocument> contdoc = [select id from contentDocument where id =: documentId];
        delete contdoc;
    }
   
}