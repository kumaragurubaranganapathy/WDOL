public class FileUploadController {

     @AuraEnabled
    public static void deleteFiles(Id documentId){
        try{
        List<ContentDocument> contdoc = [select id from contentDocument where id =: documentId];
        system.debug('contdoc'+contdoc);
        delete contdoc;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            
        }
    }
    @AuraEnabled
    public static Integer FileSize(Id docId){
        try{
        List<ContentDocument> contdoc = [select id,ContentSize from contentDocument where id =: docId];
        system.debug('contdoc ------------->'+contdoc);
        return contdoc[0].ContentSize;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            return null;
        }
    }
    
    @AuraEnabled
    public static string setContentId(String submissionId,String docId){
         try{
         Id submission_Id = submissionId;
         MUSW__Submission__c subObj;
         String submission_Obj_Name  = submission_Id.getSObjectType().getDescribe().getName();
         if(submission_Obj_Name.equalsIgnoreCase('MUSW__Submission__c') && !String.isEmpty(docId)){
             
             subObj = (MUSW__Submission__c)submission_Id.getSObjectType().newSObject(submission_Id);
              subObj.put('IsSANFileUploadTrue__c',true);
             subObj.put('ContentDocumentId__c',docId);
             
             UPDATE subObj;
         }
         return JSON.serialize(subObj);
         }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            return null;
        }
    }
}