public class Dol_UploadDocumenttoSAN {
    
    @AuraEnabled 
    public static List<String> getSelectOptionValues(sObject objObject, string fld) {
      system.debug('objObject:' + objObject);
      system.debug('fld:' + fld);
      List <String> allOpts = new list <String> ();
      Schema.sObjectType objType = objObject.getSObjectType();
      Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
      map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
      list < Schema.PicklistEntry > values =
       fieldMap.get(fld).getDescribe().getPickListValues();
      for (Schema.PicklistEntry a: values) {
       allOpts.add(a.getValue());
      }
      system.debug('allOpts ---->' + allOpts);
      return allOpts;
    }
    
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
            uploadobj.userName  = user;
            uploadobj.professionCode = professionCode;
            uploadobj.polarisId  = recordId;
            uploadobj.imageName = docName;
            
            uploadobj.imageURL = 'docName';
            uploadobj.imageType = 'docName';
            uploadobj.areaCode = 'BUS';
            uploadobj.departmentCode = 'AUC';
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
    
    /*@AuraEnabled -- enhancement code
    public static String backofficeUplaod(String recordId, String docName, String user, String imagetype, String archDate) {
        String status ='';
        String professionCode;
        System.debug('imagetype'+imagetype);
        System.debug('archDate'+archDate);
        if(Dol_IntegrationUtil.isNotBlank(recordId) && Dol_IntegrationUtil.isNotBlank(docName) && Dol_IntegrationUtil.isNotBlank(user)){
            List<MUSW__Submission__c>  submissionList  = [SELECT id, MUSW__License2__r.Profession_Code__c from MUSW__Submission__c where id=: recordId And MUSW__License2__c != null And MUSW__License2__r.Profession_Code__c != null ];
            if(Dol_IntegrationUtil.isNotEmpty(submissionList)){
                professionCode = submissionList[0].MUSW__License2__r.Profession_Code__c;
            }
            else professionCode = 'No code';
            UploadData uploadobj = new UploadData();
            uploadobj.userName  = user;
            uploadobj.professionCode = professionCode;
            uploadobj.polarisId  = recordId;
            uploadobj.imageName = docName;
            
            //uploadobj.imageURL = 'docName';
            uploadobj.imageType = imagetype;
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
        
    }*/
    
    
    
    @Future(callout=true)
        public static void  portalUploadFuture(Map<String,String> submissionToFile) {
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
                contentVersionList = [SELECT id,VersionData,ContentDocumentId,Title,FileExtension,CreatedDate FROM ContentVersion where ContentDocumentId =:contentDocIds];
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
                 if(contentToSubMissionMap.containsKey(contversion.ContentDocumentId)){
                     Blob filecontent = contversion.VersionData;
                        String profCode;
                        if(contentToSubMissionMap.get(contversion.ContentDocumentId).MUSW__License2__c!= null && contentToSubMissionMap.get(contversion.ContentDocumentId).MUSW__License2__r.Profession_Code__c !=null){
                            profCode = contentToSubMissionMap.get(contversion.ContentDocumentId).MUSW__License2__r.Profession_Code__c;
                        }
                        System.debug('profCode'+profCode);
                        String docType;
                        if(contentToSubMissionMap.get(contversion.ContentDocumentId).SAN_Image_Type__c!= null){
                            docType = contentToSubMissionMap.get(contversion.ContentDocumentId).SAN_Image_Type__c;
                        }
                        System.debug('docType'+docType);
                        UploadData uploadobj = new UploadData();
                        uploadobj.professionCode = profCode;
                        uploadobj.polarisId  = contentToSubMissionMap.get(contversion.ContentDocumentId).id;
                        uploadobj.imageName = contversion.Title + '.' + contversion.FileExtension;
                        uploadobj.imageType = docType;
                        uploadobj.imageData = contversion.VersionData;
                        uploadobj.createDate = string.valueOf(contversion.CreatedDate);
                        uploadobj.attachmentId = contversion.ContentDocumentId;
                     	uploadobj.imageURL = 'docName';
           				//uploadobj.imageType = 'docName';
            			uploadobj.areaCode = 'BUS';
           	 			uploadobj.departmentCode = 'AUC';
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
       // return status;
        
    }
            
    public class UploadData{
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