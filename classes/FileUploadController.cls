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
    
    @AuraEnabled
    public static string setContentId(String submissionId,String docId){
         Id submission_Id = submissionId;
         MUSW__Submission__c subObj;
         String submission_Obj_Name  = submission_Id.getSObjectType().getDescribe().getName();
         if(submission_Obj_Name.equalsIgnoreCase('MUSW__Submission__c') && !String.isEmpty(docId)){
             
             subObj = (MUSW__Submission__c)submission_Id.getSObjectType().newSObject(submission_Id);
             subObj.put('ContentDocumentId__c',docId);
             
             UPDATE subObj;
         }
         return JSON.serialize(subObj);
    }
}