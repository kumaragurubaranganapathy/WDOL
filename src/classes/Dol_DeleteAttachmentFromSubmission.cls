public class Dol_DeleteAttachmentFromSubmission {
    
    @AuraEnabled
    public static String getRecordName(Id recordId){
        String recordName ='';
         List<MUSW__Submission__c>  submissionList = new List<MUSW__Submission__c>();
        try{
          if(recordId!=null){
                    submissionList = [select id,Name from MUSW__Submission__c where  id=:recordId ];
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
        String status ='';
        String professionCode;
        String fileURL;
        String docName;
        String attachmentId;
        try{
           if(Dol_IntegrationUtil.isNotBlank(recordId)){
            	List<MUSW__Submission__c>  submissionList  = [SELECT id,Name,SAN_Image_URL__c ,MUSW__License2__r.Profession_Code__c from MUSW__Submission__c where id=: recordId];
                if(Dol_IntegrationUtil.isNotEmpty(submissionList)){
                    professionCode = submissionList[0].MUSW__License2__r.Profession_Code__c != null ? submissionList[0].MUSW__License2__r.Profession_Code__c : 'No code';
                    fileURL = submissionList[0].SAN_Image_URL__c  != null ? submissionList[0].SAN_Image_URL__c : 'No URL';
                    docName = submissionList[0].Name;
                } 
               System.debug('fileURL='+fileURL);
               System.debug('docName='+docName);
               
                if(fileURL == 'No URL'){
                   status = 'No Image url';
                }else if(fileURL != 'No URL'){
               	DeleteData deleteObj = new DeleteData();
                deleteObj.professionCode = professionCode;
                deleteObj.imageName = docName;
                deleteObj.imageURL = fileURL;
                System.debug('deleteObj=='+deleteObj);
                HttpResponse response = Dol_RestAPIservice.BackOfficeDeleteFileURL(deleteObj);
                if(response.getStatusCode() == 200){
                    MUSW__Submission__c submisson = new MUSW__Submission__c(id= recordId, SAN_Image_URL__c ='');
                    update submisson;
                    submisson = [select id,SAN_Image_URL__c from MUSW__Submission__c where id= :recordId];
                    if(submisson!= null && Dol_IntegrationUtil.isBlank(submisson.SAN_Image_URL__c)){
                        status = 'success';
                    }
                    
                }else status ='fail'; 
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
        //public String professionCode;	//jhann
        //public String fileName;	//20205
        //public String fileURL;	//787356
        //public String recordID;	//YYYYMMDDmillisecondIncirmenting#
        //public String areaCode;	//BUS
        //public String departmentCode;	//AUC
        
        public String userName;	//jhann
        public String professionCode;	//20205
        public String polarisId;	//787356
        public String imageName;	//YYYYMMDDmillisecondIncirmenting#
        public String imageType ;
        public String imageURL ;
        public String imageStatus ;
        public String imageComment ;
        public String areaCode;	//BUS
        public String departmentCode;	//AUC
        public Blob imageData ;
        public string createDate ;
        public String attachmentId ;
        
	
	}


}