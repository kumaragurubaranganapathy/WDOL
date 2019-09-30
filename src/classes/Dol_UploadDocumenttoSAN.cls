public class Dol_UploadDocumenttoSAN {
    
    @AuraEnabled 
    public static List<String> getSelectOptionValues(sObject objObject, string fld) {
        try{
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
        catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
    }
    
    @AuraEnabled
    public static User getUser() {
        try{
            Id userId = UserInfo.getUserId();
            User objUser = [Select Id, Name,Email from User where Id =: userId limit 1];
            system.debug('objUser'+objUser);
            return objUser;
        }
        catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
        
    }
    
    @AuraEnabled
    public static String getProfCode(String recordId) {
        try{
        System.debug('recordId'+recordId);
        String result = DOL_AppConstants.NULL_EMPTY_STRING + '';
        if(Dol_IntegrationUtil.isNotBlank(recordId)){
            List<MUSW__Submission__c>  submissionList  = [SELECT id, SAN_Prof_Code__c, MUSW__License2__c,Complaint__c,Complaint__r.License__r.Profession_Code__c, MUSW__License2__r.Profession_Code__c from MUSW__Submission__c where id=: recordId AND id != null Limit 1];
            System.debug('submissionList'+submissionList);
            if(Dol_IntegrationUtil.isNotEmpty(submissionList)&& 
               Dol_IntegrationUtil.isNotBlank(submissionList[0].SAN_Prof_Code__c)) {
                result = DOL_AppConstants.NULL_EMPTY_STRING + 'ProfessionCodeExists';
            }
            else if(Dol_IntegrationUtil.isNotEmpty(submissionList) && 
               Dol_IntegrationUtil.isNotBlank(submissionList[0].MUSW__License2__c) && (Dol_IntegrationUtil.isNotBlank(submissionList[0].MUSW__License2__r.Profession_Code__c) ||
               (Dol_IntegrationUtil.isNotBlank(submissionList[0].SAN_Prof_Code__c)))){
                result = DOL_AppConstants.NULL_EMPTY_STRING + 'ProfessionCodeExists';
               }else if(Dol_IntegrationUtil.isNotEmpty(submissionList) && Dol_IntegrationUtil.isNotBlank(submissionList[0].Complaint__c) && (Dol_IntegrationUtil.isNotBlank(submissionList[0].Complaint__r.License__r.Profession_Code__c) ||
               (Dol_IntegrationUtil.isNotBlank(submissionList[0].SAN_Prof_Code__c)))){
                result = DOL_AppConstants.NULL_EMPTY_STRING + 'ProfessionCodeExists';
                   
               }else result = DOL_AppConstants.NULL_EMPTY_STRING + 'NoProfessionCode';
        }  
        System.debug('result'+result);
        return result;
        }
        catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
    }
    @AuraEnabled
    public static String getImageUrl(String recordId) {
        try{
        System.debug('recordId'+recordId);
        String result = DOL_AppConstants.NULL_EMPTY_STRING + '';
        if(Dol_IntegrationUtil.isNotBlank(recordId)){
            List<MUSW__Submission__c>  submissionList  = [SELECT id, SAN_Image_URL__c from MUSW__Submission__c where id=: recordId AND id != null Limit 1];
            System.debug('submissionList'+submissionList);
            if(Dol_IntegrationUtil.isNotEmpty(submissionList) && Dol_IntegrationUtil.isNotBlank(submissionList[0].SAN_Image_URL__c)){
                result = DOL_AppConstants.NULL_EMPTY_STRING + 'SANImageURLExists';
            }
        }  
        System.debug('getImageUrl'+result);
        return result;
        }
        catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
    }
    @AuraEnabled
    public static String getParent(String recordId) {
        try{
        System.debug('recordId'+recordId);
        String result = DOL_AppConstants.NULL_EMPTY_STRING + '';
        if(Dol_IntegrationUtil.isNotBlank(recordId)){
            List<MUSW__Submission__c>  submissionList  = [SELECT id, Complaint__c, MUSW__License2__c   from MUSW__Submission__c where id=: recordId AND id != null Limit 1];
            System.debug('submissionList'+submissionList);
            if(Dol_IntegrationUtil.isNotEmpty(submissionList) && Dol_IntegrationUtil.isNotBlank(submissionList[0].MUSW__License2__c)){
                result = DOL_AppConstants.NULL_EMPTY_STRING + 'License';
            }
            else if(Dol_IntegrationUtil.isNotEmpty(submissionList) && Dol_IntegrationUtil.isNotBlank(submissionList[0].Complaint__c)){
                result = DOL_AppConstants.NULL_EMPTY_STRING + 'Case';
            }
        }  
        System.debug('getImageUrl'+result);
        return result;
        }
        catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
    }
    
    @AuraEnabled
    public static String backofficeUplaod(String recordId, String docName, String user, String imagetype, String archDate) {
        try{
            String imageTypeConversion = DOL_AppConstants.NULL_EMPTY_STRING + 'Other';
            if(imagetype == 'Compliance'){
                imageTypeConversion = DOL_AppConstants.NULL_EMPTY_STRING + 'Compliance';
            }
            Dol_ImageTypeAndTransactionMap__c imagecode = [select Image_Type__c,Transaction_Code__c  from Dol_ImageTypeAndTransactionMap__c where Image_Type__c =:imageTypeConversion Limit 1];
            
        String status = DOL_AppConstants.NULL_EMPTY_STRING + '';
        String professionCode;
        System.debug('imagetype'+imagetype);
        System.debug('archDate'+archDate);
        if(Dol_IntegrationUtil.isNotBlank(recordId) && Dol_IntegrationUtil.isNotBlank(docName) && Dol_IntegrationUtil.isNotBlank(user)){
            List<MUSW__Submission__c>  submissionList  = [SELECT id, SAN_Prof_Code__c, MUSW__License2__c, MUSW__License2__r.Profession_Code__c from MUSW__Submission__c where id=: recordId AND id != null Limit 1];
            if(Dol_IntegrationUtil.isNotEmpty(submissionList) && submissionList[0].MUSW__License2__c == null && submissionList[0].SAN_Prof_Code__c != null){
                professionCode = submissionList[0].SAN_Prof_Code__c;
            }else if(submissionList[0].MUSW__License2__c != null && submissionList[0].MUSW__License2__r.Profession_Code__c != null){
                professionCode = submissionList[0].MUSW__License2__r.Profession_Code__c;
            }
            else professionCode = DOL_AppConstants.NULL_EMPTY_STRING + 'No code';
            UploadData uploadobj = new UploadData();
            uploadobj.userName  = user;
            uploadobj.professionCode = professionCode;
            uploadobj.polarisId  = recordId;
            uploadobj.imageName = docName;
            uploadobj.imageType = imagetype;
            if(archDate!= null){
                uploadobj.archiveDate = archDate;
            }
            if(imagecode != null){
                uploadobj.imageTransaction = imagecode.Transaction_Code__c;
            }
            System.debug('uploadobj=='+uploadobj);
            HttpResponse response = Dol_RestAPIservice.BackOfficeUploadToSAN(uploadobj);
            if(response.getStatusCode() == 200){
                status = DOL_AppConstants.NULL_EMPTY_STRING + 'uploadsuccess';
            }
            else status = DOL_AppConstants.NULL_EMPTY_STRING + 'uploadfailed';
        }
        system.debug('status'+status);
        return status;
        }
        catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
        
    }
    
    
    
    /*@Future(callout=true)
        public static void  portalUploadFuture(Map<String,String> submissionToFile) {
        String status = DOL_AppConstants.NULL_EMPTY_STRING + '';
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
                contentVersionList = [SELECT id,VersionData,ContentDocumentId,Title,FileExtension,CreatedDate FROM ContentVersion where ContentDocumentId =:contentDocIds AND ContentDocumentId!= null];
                System.debug('contentVersionList'+contentVersionList);
            }
            Set<String> submissionIds = submissionToFile.keySet();
            System.debug('submissionIds'+submissionIds);
            
            if(submissionIds != null && submissionIds.size()>0){
                submissionList = [SELECT id,SAN_Image_Type__c, MUSW__License2__r.Profession_Code__c from MUSW__Submission__c where id=: submissionIds AND id != null];
            }
            System.debug('submissionList'+submissionList);
            
            for(MUSW__Submission__c submissionObj : submissionList){
                if(submissionToFile.containsKey(submissionObj.id)){
                   string contentDocId = submissionToFile.get(submissionObj.id);
                   contentToSubMissionMap.put(contentDocId,submissionObj); 
                }
            }  
            System.debug('contentToSubMissionMap'+contentToSubMissionMap);
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
                        uploadobj.imageURL = DOL_AppConstants.NULL_EMPTY_STRING + 'docName';
                        //uploadobj.imageType = DOL_AppConstants.NULL_EMPTY_STRING + 'docName';
                        uploadobj.areaCode = DOL_AppConstants.NULL_EMPTY_STRING + 'BUS';
                        uploadobj.departmentCode = DOL_AppConstants.NULL_EMPTY_STRING + 'AUC';
                        uploadobjList.add(uploadobj);
                        System.debug('uploadobj=='+uploadobj);
                 }
            }
                System.debug('uploadobjList=='+uploadobjList);
                HttpResponse response = Dol_RestAPIservice.portalUploadToSAN(uploadobjList);
                if(response.getStatusCode() == 200){
                    status = DOL_AppConstants.NULL_EMPTY_STRING + 'uploadsuccess';
                }
                else status = DOL_AppConstants.NULL_EMPTY_STRING + 'uploadfailed';
        }
            system.debug('status'+status);
       // return status;
        
    }*/
            
    public class UploadData{
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
        public String imageId ;
        public string createDate ;
        public String attachmentId ;
        public String archiveDate;
        public String imageTransaction;
    
    }
}