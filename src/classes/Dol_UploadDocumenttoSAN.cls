public class Dol_UploadDocumenttoSAN {
    @AuraEnabled
    public static User getUser() {
        Id userId = UserInfo.getUserId();
        User objUser = [Select Id, Name from User where Id =: userId limit 1];
        system.debug('objUser'+objUser);
        return objUser;
        
    }
    
    @AuraEnabled
    public static String getProfCode(String recordId) {
        System.debug('recordId'+recordId);
        String result = '';
        if(Dol_IntegrationUtil.isNotBlank(recordId)){
            List<MUSW__Submission__c>  submissionList  = [SELECT id, MUSW__License2__c,MUSW__License2__r.Profession_Code__c from MUSW__Submission__c where id=: recordId Limit 1];
            System.debug('submissionList'+submissionList);
            if(Dol_IntegrationUtil.isNotEmpty(submissionList) && 
               (Dol_IntegrationUtil.isNotBlank(submissionList[0].MUSW__License2__c) && Dol_IntegrationUtil.isBlank(submissionList[0].MUSW__License2__r.Profession_Code__c)) ||
               (Dol_IntegrationUtil.isBlank(submissionList[0].MUSW__License2__c))){
                result = 'NoProfessionCode';
            }else result = 'ProfessionCodeExists';
        }  
        System.debug('result'+result);
        return result;
    }
    @AuraEnabled
    public static String backofficeUplaod(String recordId, String docName, String user) {
        String status ='';
        String professionCode;
        if(Dol_IntegrationUtil.isNotBlank(recordId) && Dol_IntegrationUtil.isNotBlank(docName) && Dol_IntegrationUtil.isNotBlank(user)){
            List<MUSW__Submission__c>  submissionList  = [SELECT id, MUSW__License2__r.Profession_Code__c from MUSW__Submission__c where id=: recordId And MUSW__License2__c != null And MUSW__License2__r.Profession_Code__c != null ];
            if(Dol_IntegrationUtil.isNotEmpty(submissionList)){
                professionCode = submissionList[0].MUSW__License2__r.Profession_Code__c;
            }
            else professionCode = 'No code';
            UploadData uploadobj = new UploadData();
            uploadobj.backofficeUserLoginID = user;
            uploadobj.professionCode = professionCode;
            uploadobj.recordID = recordId;
            uploadobj.fileName = docName;
            //uploadobj.areaCode = 'BUS';
            //uploadobj.departmentCode = 'AUC';
            System.debug('uploadobj=='+uploadobj);
            HttpResponse response = Dol_RestAPIservice.BackOfficeUploadToSAN(uploadobj);
            if(response.getStatusCode() == 200){
                status = 'uploadsuccess';
            }
            else status ='uploadfailed';
        }
        system.debug('status'+status);
        return status;
        
    }
    
    /*@AuraEnabled
    public static String portalUplaod(String submissionId, String attachmentId) {
        String status ='';
        String professionCode;
        String attachName;
        Blob body;
        String fileType;
        if(Dol_IntegrationUtil.isNotBlank(submissionId) && Dol_IntegrationUtil.isNotBlank(attachmentId)){
            List<MUSW__Submission__c>  submissionList  = [SELECT id,SAN_Image_Type__c, MUSW__License2__r.Profession_Code__c from MUSW__Submission__c where id=: submissionId And MUSW__License2__c != null And MUSW__License2__r.Profession_Code__c != null ];
            if(Dol_IntegrationUtil.isNotEmpty(submissionList)){
                professionCode = submissionList[0].MUSW__License2__r.Profession_Code__c;
                fileType = submissionList[0].SAN_Image_Type__c != null ? submissionList[0].SAN_Image_Type__c : '';
            }
            //else professionCode = 'No code';
            List<attachment> attachList = [select id,Name,Body,CreatedDate from attachment where id= :attachmentId];
            if(Dol_IntegrationUtil.isNotEmpty(attachList)){
                    attachName = attachList[0].Name;
                	body = attachList[0].Body;
                }
            UploadData uploadobj = new UploadData();
            uploadobj.professionCode = professionCode;
            uploadobj.recordID = submissionId;
            uploadobj.fileName = attachName;
            uploadobj.fileType = fileType;
            uploadobj.fileData = body;
            uploadobj.createDate = string.valueOf(attachList[0].CreatedDate);
            System.debug('uploadobj=='+uploadobj);
            HttpResponse response = Dol_RestAPIservice.portalUploadToSAN(uploadobj);
            if(response.getStatusCode() == 200){
                status = 'uploadsuccess';
            }
            else status ='uploadfailed';
        }
        system.debug('status'+status);
        return status;
        
    }*/
    
    @AuraEnabled
    public static String portalUpload(Map<String,String> submissionToFile) {
        String status ='';
        String professionCode;
        String attachName;
        Blob body;
        String fileType;
        List<ContentVersion> contentVersionList;
        List<MUSW__Submission__c> submissionList;
        Map<String,MUSW__Submission__c> contentToSubMissionMap = new Map<String,MUSW__Submission__c>();
        List<UploadData> uploadobjList = new List<UploadData>();
        
        System.debug('submissionToFile'+submissionToFile);
        if(submissionToFile!= null){
            List<String> contentDocIds = submissionToFile.values();
            if(Dol_IntegrationUtil.isNotEmpty(contentDocIds)){
                contentVersionList = [SELECT id,VersionData,Title,FileExtension,CreatedDate FROM ContentVersion where id =:contentDocIds];
                System.debug('contentVersionList'+contentVersionList);
            }
            Set<String> submissionIds = submissionToFile.keySet();
            System.debug('submissionIds'+submissionIds);
            
            if(submissionIds != null && submissionIds.size()>0){
                submissionList = [SELECT id,SAN_Image_Type__c, MUSW__License2__r.Profession_Code__c from MUSW__Submission__c where id=: submissionIds];
            }
            
            for(MUSW__Submission__c submissionObj : submissionList){
                if(submissionToFile.containsKey(submissionObj.id)){
                   string contentDocId = submissionToFile.get(submissionObj.id);
                   contentToSubMissionMap.put(contentDocId,submissionObj); 
                }
            }  
            for(ContentVersion contversion : contentVersionList){
                 if(contentToSubMissionMap.containsKey(contversion.id)){
                     Blob filecontent = contversion.VersionData;
                        String profCode;
                        if(contentToSubMissionMap.get(contversion.Id).MUSW__License2__c!= null && contentToSubMissionMap.get(contversion.Id).MUSW__License2__r.Profession_Code__c !=null){
                            profCode = contentToSubMissionMap.get(contversion.Id).MUSW__License2__r.Profession_Code__c;
                        }
                        System.debug('profCode'+profCode);
                        String docType;
                        if(contentToSubMissionMap.get(contversion.Id).SAN_Image_Type__c!= null){
                            docType = contentToSubMissionMap.get(contversion.Id).SAN_Image_Type__c;
                        }
                        System.debug('docType'+docType);
                        UploadData uploadobj = new UploadData();
                        uploadobj.professionCode = profCode;
                        uploadobj.recordID = contentToSubMissionMap.get(contversion.Id).id;
                        uploadobj.fileName = contversion.Title + '.' + contversion.FileExtension;
                        uploadobj.fileType = docType;
                        uploadobj.fileData = contversion.VersionData;
                        uploadobj.createDate = string.valueOf(contversion.CreatedDate);
                        uploadobj.attachmentId = contversion.id;
                        uploadobjList.add(uploadobj);
                        System.debug('uploadobj=='+uploadobj);
                 }
            }
                System.debug('uploadobjList=='+uploadobjList);
                HttpResponse response = Dol_RestAPIservice.portalUploadToSAN(uploadobjList);
                if(response.getStatusCode() == 200){
                    status = 'uploadsuccess';
                }
                else status ='uploadfailed';
        }
            system.debug('status'+status);
        return status;
        
    }
            
    public class UploadData{
        public String backofficeUserLoginID;	//jhann
        public String professionCode;	//20205
        public String recordID;	//787356
        public String fileName;	//YYYYMMDDmillisecondIncirmenting#
        public String fileType ;
        public String areaCode;	//BUS
        public String departmentCode;	//AUC
        public Blob fileData ;
        public string createDate ;
        public String attachmentId ;
	
	}

}