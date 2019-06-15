public class FileUploadController {

     @AuraEnabled
    public static void deleteFiles(Id documentId){
        List<ContentDocument> contdoc = [select id from contentDocument where id =: documentId];
        system.debug('contdoc'+contdoc);
        delete contdoc;
    }
    @AuraEnabled
    public static Integer FileSize(Id docId){
        List<ContentDocument> contdoc = [select id,ContentSize from contentDocument where id =: docId];
        system.debug('contdoc ------------->'+contdoc);
        return contdoc[0].ContentSize;  
    }
}