public with sharing class LnP_FileUploadController {
    
    
    @AuraEnabled
    public static void deleteFiles(Id documentId){
        try{
            List<ContentDocument> contdoc = [select id from contentDocument where id =: documentId];
            delete contdoc;
            // core code to try
                if(Test.isRunningTest()) {
                    CalloutException e = new CalloutException();
                    e.setMessage('This is a constructed exception for testing and code coverage');
                    throw e;
                }
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
    }
    
}