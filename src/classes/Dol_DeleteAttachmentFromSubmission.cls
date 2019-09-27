public class Dol_DeleteAttachmentFromSubmission {
    
    @AuraEnabled
    public static String getRecordName(Id recordId){
        String recordName = DOL_AppConstants.NULL_EMPTY_STRING;
         List<MUSW__Submission__c>  submissionList = new List<MUSW__Submission__c>();
        try{
          if(recordId!=null){
                    submissionList = [select id,Name from MUSW__Submission__c where  id=:recordId AND id != null];
                }
                if(submissionList!=null && submissionList.size()>0){
                    if(submissionList[0].Name!=null){
                        recordName =submissionList[0].Name;
                    }
                }
            }catch(exception e) {
                throw new AuraHandledException(e.getMessage());
                //DebugErrorLoggger.LogError(e, '', '','Dol_DeleteAttachmentFromSubmission','getRecordName','getRecordName Method failed');
            } 
        return recordName;
    }  
    
    @AuraEnabled
    public static String deleteDocumentLink(Id recordId) {
        String status = DOL_AppConstants.NULL_EMPTY_STRING;
        String professionCode;
        String fileURL;
        String docName;
        String attachmentId;
        try{
           if(Dol_IntegrationUtil.isNotBlank(recordId)){
                List<MUSW__Submission__c>  submissionList  = [SELECT id,Name,SAN_Image_URL__c ,MUSW__License2__c,MUSW__License2__r.Profession_Code__c,SAN_Prof_Code__c from MUSW__Submission__c where id=: recordId AND id != null];
                if(Dol_IntegrationUtil.isNotEmpty(submissionList)){
                    if(Dol_IntegrationUtil.isNotBlank(submissionList[0].MUSW__License2__c)){
                        if(Dol_IntegrationUtil.isNotBlank(submissionList[0].MUSW__License2__r.Profession_Code__c))
                            professionCode = submissionList[0].MUSW__License2__r.Profession_Code__c;
                        }else if(Dol_IntegrationUtil.isNotBlank(submissionList[0].SAN_Prof_Code__c)){
                           professionCode = submissionList[0].SAN_Prof_Code__c;  
                    }
                    //professionCode = submissionList[0].MUSW__License2__r.Profession_Code__c != null ? submissionList[0].MUSW__License2__r.Profession_Code__c : 'No code';
                    fileURL = submissionList[0].SAN_Image_URL__c  != null ? submissionList[0].SAN_Image_URL__c : 'No URL';
                    if(submissionList[0].SAN_Image_URL__c!= null){
                     String imageIdWithTif = submissionList[0].SAN_Image_URL__c.substringAfterLast('\\');
                     docName = imageIdWithTif.removeEnd('.tif');
                    }
                }
               System.debug('fileURL='+fileURL);
               System.debug('docName='+docName);
                
                if(fileURL == 'No URL'){
                   status = DOL_AppConstants.NO_IMAGE_URL;
                }else if(fileURL != 'No URL'){
                DeleteData deleteObj = new DeleteData();
                deleteObj.professionCode = professionCode;
                deleteObj.imageName = docName;
                deleteObj.imageURL = fileURL;
                System.debug('deleteObj=='+deleteObj);
                HttpResponse response = Dol_RestAPIservice.BackOfficeDeleteFileURL(deleteObj);
                if(response.getStatusCode() == 200){
                    MUSW__Submission__c submisson = new MUSW__Submission__c(id= recordId, SAN_Image_URL__c = DOL_AppConstants.NULL_EMPTY_STRING);
                    update submisson;
                    submisson = [select id,SAN_Image_URL__c from MUSW__Submission__c where id= :recordId AND id != null];
                    if(submisson!= null && Dol_IntegrationUtil.isBlank(submisson.SAN_Image_URL__c)){
                        status = DOL_AppConstants.SUCCESS_STRING_LOWERCASE;
                    }
                    
                }else status = DOL_AppConstants.FAIL_STRING; 
            }
        }
        system.debug('status'+status); 
        }catch(exception e) {
            throw new AuraHandledException(e.getMessage());
            //DebugErrorLoggger.LogError(e, '', '','Dol_DeleteAttachmentFromSubmission','deleteDocumentLink','deleteDocumentLink Method failed');
        }
        
        return status;
        
    }
    public class DeleteData{
        public String userName; //jhann
        public String professionCode;   //20205
        public String polarisId;    //787356
        public String imageName;    //YYYYMMDDmillisecondIncirmenting#
        public String imageType ;
        public String imageURL ;
        public String imageStatus ;
        public String imageComment ;
        public String areaCode; //BUS
        public String departmentCode;   //AUC
        public Blob imageData ;
        public string createDate ;
        public String attachmentId ;
        
    
    }


}