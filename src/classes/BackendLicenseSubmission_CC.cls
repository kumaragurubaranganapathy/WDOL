/**
* User Story: 124- Submission List Triggers
* Name: BackendLicenseSubmission_CC
* Type: Custom Controller
* Description: Custom Controller for BackendLicenseSubmission component
* Date:        Developer/Company                    Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 06/28/2018   Sharad Maheshwari/Deloitte           Initial Creation
**/
global class BackendLicenseSubmission_CC {

    public String pid{get;set;}
    public String permitpid{get;set;}
    public Boolean enableDoneButton{get;set;}
    private String retURL;
    public List<MUSW__Submission__c> submissionList;
    public Attachment file{ get;set;}
    public String subId{get;set;}
    public String hiddenSubId{get;set;}
    public MUSW__Submission__c newSubmission{get;set;}

    
    //Flags to decide which submissions need to be shown
    public Boolean isRenewal{get;set;}
    public Boolean isRenewalPTO{get;set;}
    public Boolean isSR{get;set;}
    public Boolean isReinstatement{get;set;}
    public Boolean isLicense{get;set; }  
    public Boolean isPermit{get;set; }  
    public Boolean isVerification{get;set;}
    public Boolean isReview{get;set;}
    public Boolean isComplaint{get;set;}
    public Boolean isExamCredit{get;set;}
    public Boolean isLicenseReinstatement{get;set;}
    
    /***************************************************************************************************
    * @Description : Method to redirect user back to the license record
    * @Param       : NA
    * @Return      : PageReference
    ****************************************************************************************************/
    public BackendLicenseSubmission_CC() {
        System.debug('in BackendLicenseSubmission_CC');
        newSubmission = new MUSW__Submission__c();
        file = new Attachment();
        submissionList = new List<MUSW__Submission__c >();
        enableDoneButton = getStatus(submissionList);
    }

    /***************************************************************************************************
    * @Description : Method to get submissions under a license
    * @Param       : NA
    * @Return      : NA
    ****************************************************************************************************/
    public List<MUSW__Submission__c> getsubmissionList() {
        System.debug('in getSubmissionList');
        submissionList = new List<MUSW__Submission__c>();
        System.debug('pid '+pid);
        System.debug('permitpid '+permitpid);
        System.debug('isRenewalPTO '+isRenewalPTO);
        System.debug('isRenewal '+isRenewal);
        System.debug('isReinstatement '+isReinstatement);
        System.debug('isLicense '+isLicense);
        System.debug('isPermit '+isPermit);
        if((pid != null && pid != '') || (permitpid != null && permitpid != '')){
            System.debug('isRenewal in back'+ isRenewal);
             if(isRenewal != null && isRenewal){
                 System.debug('isRenewal in if');
                submissionList = [Select Id,Name,Hardcopy__c,Description_Long__c,Type__c,is_Backend_Submission__c,Available_To_Public__c,MUSW__Link__c,MUSW__Submission_DateTime__c,Status__c,Master_Submission_List__r.Hide_Upload_button_in_backend__c,(Select Id,Name FROM Attachments ORDER BY Name) FROM MUSW__Submission__c WHERE License_Renewal__c=:pid AND Show_For_Credential_Renewal__c=TRUE ORDER BY Name];
                 System.debug('isRenewal in if size of submissionList '+submissionList.size());
            }else if(isRenewalPTO != null && isRenewalPTO){
                 System.debug('isRenewalPTO in if');
                 submissionList = [Select Id,Name,Hardcopy__c,Description_Long__c,Type__c,is_Backend_Submission__c,Available_To_Public__c,MUSW__Link__c,MUSW__Submission_DateTime__c,Status__c,Master_Submission_List__r.Hide_Upload_button_in_backend__c,(Select Id,Name FROM Attachments ORDER BY Name) FROM MUSW__Submission__c WHERE License_Renewal__c=:permitpid AND Show_For_Permit_Renewal__c=TRUE ORDER BY Name];
                 System.debug('isRenewalPTO in if size of submissionList '+submissionList.size());
            }else if(isReinstatement != null && isReinstatement){
                submissionList = [Select Id,Name,Hardcopy__c,Description_Long__c,Type__c,is_Backend_Submission__c,Available_To_Public__c,MUSW__Link__c,MUSW__Submission_DateTime__c,Status__c,Master_Submission_List__r.Hide_Upload_button_in_backend__c,(Select Id,Name FROM Attachments ORDER BY Name) FROM MUSW__Submission__c WHERE License_Renewal__c=:pid AND Show_for_Credential_Reinstatement__c=TRUE ORDER BY Name];
            }/*//Todo
             *else if(isSR != null && isSR){
                submissionList = [Select Id,Name,Hardcopy__c,Description_Long__c,Type__c,is_Backend_Submission__c,Available_To_Public__c,MUSW__Link__c,MUSW__Submission_DateTime__c,Status__c,Master_Submission_List__r.Hide_Upload_button_in_backend__c,(Select Id,Name FROM Attachments ORDER BY Name) FROM MUSW__Submission__c WHERE MUSW__Application2__c=:pid AND Show_For_Name_Change_SR__c=TRUE ORDER BY Name];
            }*/else if(isLicense != null && isLicense){
                System.debug('in license');
                
                submissionList = [Select Id,Name,Hardcopy__c,Description_Long__c,Type__c,is_Backend_Submission__c,Available_To_Public__c,MUSW__Link__c,MUSW__Submission_DateTime__c,Status__c,Master_Submission_List__r.Hide_Upload_button_in_backend__c,(Select Id,Name FROM Attachments ORDER BY Name) FROM MUSW__Submission__c WHERE MUSW__License2__c=:pid AND Show_For_Credential__c=TRUE ORDER BY Name];
                System.debug('submissionList.size '+submissionList.size());
                System.debug('submissionList '+submissionList);
                
            }else if(isPermit != null && isPermit){
                submissionList = [Select Id,Name,Hardcopy__c,Description_Long__c,Type__c,is_Backend_Submission__c,Available_To_Public__c,MUSW__Link__c,MUSW__Submission_DateTime__c,Status__c,Master_Submission_List__r.Hide_Upload_button_in_backend__c,(Select Id,Name FROM Attachments ORDER BY Name) FROM MUSW__Submission__c WHERE MUSW__Permit2__c=:permitpid AND Show_For_Permit__c=TRUE ORDER BY Name];
            }/*else if(isLicenseReinstatement != null && isLicenseReinstatement){
                submissionList = [Select Id,Name,Hardcopy__c,Description_Long__c,Type__c,is_Backend_Submission__c,Available_To_Public__c,MUSW__Link__c,MUSW__Submission_DateTime__c,Status__c,Master_Submission_List__r.Hide_Upload_button_in_backend__c,(Select Id,Name FROM Attachments ORDER BY Name) FROM MUSW__Submission__c WHERE MUSW__License2__c=:pid AND Show_for_License__c=TRUE ORDER BY Name];
            }
            else if(isReview != null && isReview){
                submissionList = [Select Id,Name,Hardcopy__c,Description_Long__c,Type__c,is_Backend_Submission__c,Available_To_Public__c,MUSW__Link__c,MUSW__Submission_DateTime__c,Status__c,Master_Submission_List__r.Hide_Upload_button_in_backend__c,(Select Id,Name FROM Attachments ORDER BY Name) FROM MUSW__Submission__c WHERE MUSW__Review__c=:pid ORDER BY Name];
            }else if(isComplaint != null && isComplaint){
                submissionList = [Select Id,Name,Hardcopy__c,Description_Long__c,Type__c,is_Backend_Submission__c,Available_To_Public__c,MUSW__Link__c,MUSW__Submission_DateTime__c,Status__c,Master_Submission_List__r.Hide_Upload_button_in_backend__c,(Select Id,Name FROM Attachments ORDER BY Name) FROM MUSW__Submission__c WHERE Complaint__c=:pid ORDER BY Name];
            }
            else if(isExamCredit != null && isExamCredit){
                submissionList = [Select Id,Name,Hardcopy__c,Description_Long__c,Type__c,is_Backend_Submission__c,Available_To_Public__c,MUSW__Link__c,MUSW__Submission_DateTime__c,Status__c,Master_Submission_List__r.Hide_Upload_button_in_backend__c,(Select Id,Name FROM Attachments ORDER BY Name) FROM MUSW__Submission__c WHERE CE_Exam_Credit__c=:pid ORDER BY Name];         
            }*/
        }
        enableDoneButton = getStatus(submissionList);
        return submissionList;
    }
    
    /***************************************************************************************************
    * @Description : Method to create attachment under submission
    * @Param       : NA
    * @Return      : PageReference
    ****************************************************************************************************/
    public PageReference uploadFile(){
        PageReference currentPage = Apexpages.CurrentPage();
        if(file.body != null){
            try{
                file.parentId = subId;
                if(file != null){
                    insert file;    
                }  
                MUSW__Submission__c submissionUpdate = new MUSW__Submission__c(Id=subId,MUSW__Submission_DateTime__c=System.now());
                if(submissionUpdate != null){
                    update submissionUpdate;    
                }
                //submissionList = [Select Id,Name,Hardcopy__c,Description_Long__c,Type__c,(Select Id,Name FROM Attachments) FROM MUSW__Submission__c WHERE MUSW__License2__c=:pid];                     
            }catch(Exception ex){
                ApexPages.Addmessage(new ApexPages.Message(Apexpages.SEVERITY.ERROR,ex.getmessage()));
                return null;
            }finally{
                //Clearing file body to avoid serizling file body into view state
                file = new Attachment();
            }
        }
        return null;
    }

    /***************************************************************************************************
    * @Description : Method to create new submission
    * @Param       : NA
    * @Return      : PageReference
    ****************************************************************************************************/
    public PageReference createSubmission(){
        try{
            if(hiddenSubId != null && hiddenSubId !=''){
                newSubmission.Id = hiddenSubId;
            }
            if(isLicense!=null && isLicense)
            {
                newSubmission.MUSW__License2__c = pid;
            }else if(isPermit!=null && isPermit)
            {
                newSubmission.MUSW__Permit2__c = permitpid;
            }else if(isLicenseReinstatement!=null && isLicenseReinstatement)
            {
                newSubmission.MUSW__License2__c = pid;
            }            
            else if((isRenewal!=null && isRenewal))
            {
                newSubmission.License_Renewal__c = pid;
            }
            else if((isRenewalPTO!=null && isRenewalPTO))
            {
                System.debug('in createSubmission renewalPTO');
                newSubmission.License_Renewal__c = permitpid;
            }
            else if(isReinstatement!=null && isReinstatement)
            {
                newSubmission.License_Renewal__c = pid;
            }/*
            else if(isVerification!=null && isVerification)
            {
                newSubmission.License_Verification__c = pid;
            }
            else if(isReview!=null && isReview)
            {
                newSubmission.MUSW__Review__c = pid;
            }
            else if(isComplaint!=null && isComplaint)
            {
                newSubmission.Complaint__c = pid;
            }
            else if(isSR!=null && isSR)
            {
                newSubmission.MUSW__Application2__c = pid;
            }
            else if(isExamCredit!=null && isExamCredit)
            {
                newSubmission.CE_Exam_Credit__c = pid;
            }*/
            newSubmission.MUSW__Submission_DateTime__c=System.now();
            newSubmission.is_Backend_Submission__c = TRUE;
            if(newSubmission !=  null){
                upsert newSubmission;   
            }
            newSubmission = new MUSW__Submission__c();
            if(hiddenSubId != null && hiddenSubId !=''){
                ApexPages.Addmessage(new ApexPages.Message(Apexpages.SEVERITY.INFO,label.Str_Submission_is_updated_successfully));
            }else{
                ApexPages.Addmessage(new ApexPages.Message(Apexpages.SEVERITY.INFO,label.Str_New_submission_is_created_successfully));
            }
        }catch(Exception ex){
            ApexPages.Addmessage(new ApexPages.Message(Apexpages.SEVERITY.ERROR,ex.getmessage()));
            return null;
        }
        return null;
    }
    
    /***************************************************************************************************
    * @Description : Method to delete submission and refresh submissionList
    * @Param       : NA
    * @Return      : PageReference
    ****************************************************************************************************/
    public PageReference refreshSubmissions(){
        if(hiddenSubId != null){
            try{
                MUSW__Submission__c backendSubmission = new MUSW__Submission__c(Id=hiddenSubId);
                if(backendSubmission != null){
                    delete backendSubmission;   
                }
                
                ApexPages.Addmessage(new ApexPages.Message(Apexpages.SEVERITY.INFO,label.Str_Submission_is_deleted_successfully));
            }catch(Exception ex){
                ApexPages.Addmessage(new ApexPages.Message(Apexpages.SEVERITY.ERROR,label.Str_Error_in_deleting_submission));
            }
        }
        return null;
    }    
    
    /***************************************************************************************************
    * @Description : Method to get status of completion of necessary uploads
    * @Param       : List<MUSW__Submission__c>
    * @Return      : Boolean
    ****************************************************************************************************/
    public static Boolean getStatus(List<MUSW__Submission__c> subList){
        Boolean completionStatus = TRUE;
        for(MUSW__Submission__c submission: subList){
            if((submission.Attachments == NULL || submission.Attachments.isEmpty()) && submission.Hardcopy__c == FALSE){
                completionStatus = FALSE;
            }   
        }
        return completionStatus;
    }
    
    /***************************************************************************************************
    * @Description : JSRemoted method to get submission details for editing
    * @Param       : ID
    * @Return      : MUSW__Submission__c
    ****************************************************************************************************/
    @RemoteAction
    global static MUSW__Submission__c getSubmissionDetails(Id submissionId){
        try{
            MUSW__Submission__c submission = [select id,Description_Long__c,Name,MUSW__Link__c,Available_To_Public__c FROM MUSW__Submission__c WHERE ID=:submissionId];
            return submission;
        }catch(Exception ex){
            system.debug(ex.getMessage());
        }
        return null;
    }
    
    /***************************************************************************************************
    * @Description : JSRemoted method to update submission hard copy field as true
    * @Param       : ID
    * @Return      : String
    ****************************************************************************************************/
    @RemoteAction
    global static String updateHardCopy(Id submissionId){
        try{
            MUSW__Submission__c submission = [select id,Hardcopy__c FROM MUSW__Submission__c WHERE ID=:submissionId];
            submission.Hardcopy__c = TRUE;
            if(submission != null){
                update submission;  
            }
            
            return label.Str_success;
        }catch(Exception ex){
            return ex.getMessage();
        }
    }

    /***************************************************************************************************
    * @Description : JSRemoted method to update submission status
    * @Param       : ID
    * @Param       : String
    * @Return      : String
    ****************************************************************************************************/
    @RemoteAction
    global static String updateStatus(Id submissionId,String status){
        try{
            MUSW__Submission__c submissionUpdate = new MUSW__Submission__c(Id=submissionId,Status__c=status);
            if(submissionUpdate != null){
                update submissionUpdate;    
            }
            
            return label.Str_success;
        }catch(Exception ex){
            return ex.getMessage();
        }
    }
    
    /***************************************************************************************************
    * @Description : JSRemoted method to delete attachment
    * @Param       : ID
    * @Return      : String
    ****************************************************************************************************/
    @RemoteAction
    global static String deleteAttachment(Id attachmentId){
        try{
            Attachment attachment = New Attachment(Id=attachmentId);
            if(attachment != null){
                delete attachment;
            }
            
            return label.Str_success;
        }catch(Exception ex){
            return ex.getMessage();
        }
    }

    /***************************************************************************************************
    * @Description : JSRemoted method to get list of attachments under a submission
    * @Param       : ID
    * @Return      : List<Attachment>
    ****************************************************************************************************/
    @RemoteAction
    global static List<Attachment> getAttachmentList(Id submissionId){
        try{
            List<Attachment> attList = [Select Id,Name FROM Attachment where parentId=:submissionId];
            return attList;
        }catch(Exception ex){
            System.debug('Unexpected Error'+ex.getMessage());
        }
        return null;
    }
    
    /***************************************************************************************************
    * @Description : JSRemoted method to check if all submissions documents are uplaoded
    * @Param       : ID
    * @Return      : Boolean
    ****************************************************************************************************/
    @RemoteAction
    global static Boolean getCompletionStatus(Id submissionId,String isRenewal, String isRenewalPTO, String isExamCredit, String isSR,String isReinstatement,String isLicense, String isPermit, String isLicenseReinstatement,String isReview, String isEndorsement, String isComplaint){
        List<MUSW__Submission__c> subList;
         if(isRenewal!= null && isRenewal ==label.Str_true){
            subList = [Select Id,Hardcopy__c,(Select Id FROM Attachments) FROM MUSW__Submission__c WHERE License_Renewal__c=:submissionId AND Show_for_Credential_Renewal__c=TRUE AND is_Backend_Submission__c = FALSE];
        }/* Todo
         *else if(isSR!= null && isSR ==label.Str_true){
            subList = [Select Id,Hardcopy__c,(Select Id FROM Attachments) FROM MUSW__Submission__c WHERE MUSW__Application2__c=:submissionId AND Show_For_Name_Change_SR__c=TRUE AND is_Backend_Submission__c = FALSE];
        }*/else if(isReinstatement !=null && isReinstatement ==label.Str_true){
            subList = [Select Id,Hardcopy__c,(Select Id FROM Attachments) FROM MUSW__Submission__c WHERE License_Renewal__c=:submissionId AND Show_for_Credential_Reinstatement__c=TRUE AND is_Backend_Submission__c = FALSE];
        } else if(isLicense !=null && isLicense == label.Str_true){
            subList = [Select Id,Hardcopy__c,(Select Id FROM Attachments) FROM MUSW__Submission__c WHERE MUSW__License2__c=:submissionId AND Show_For_Credential__c=TRUE AND is_Backend_Submission__c = FALSE];
            
        }else if(isPermit !=null && isPermit == label.Str_true){
            System.debug('in getCompletionStatus renewalPTO');
                subList = [Select Id,Hardcopy__c,(Select Id FROM Attachments) FROM MUSW__Submission__c WHERE MUSW__Permit2__c=:submissionId AND Show_For_Permit__c=TRUE AND is_Backend_Submission__c = FALSE];
            System.debug('in getCompletionStatus subList '+subList);
        }else if(isRenewalPTO != null && isRenewalPTO == label.Str_true){
            subList = [Select Id,Hardcopy__c,(Select Id FROM Attachments) FROM MUSW__Submission__c WHERE License_Renewal__c=:submissionId AND Show_for_Permit_Renewal__c=TRUE AND is_Backend_Submission__c = FALSE];
        }/*else if(isLicenseReinstatement !=null && isLicenseReinstatement == label.Str_true){
            subList = [Select Id,Hardcopy__c,(Select Id FROM Attachments) FROM MUSW__Submission__c WHERE MUSW__License2__c=:submissionId AND Show_for_License__c=TRUE AND is_Backend_Submission__c = FALSE];
        }else if(isReview !=null && isReview == label.Str_true){
            subList = [Select Id,Hardcopy__c,(Select Id FROM Attachments) FROM MUSW__Submission__c WHERE MUSW__Review__c=:submissionId AND is_Backend_Submission__c = FALSE];
        }else if(isComplaint !=null && isComplaint == label.Str_true){
            subList = [Select Id,Hardcopy__c,(Select Id FROM Attachments) FROM MUSW__Submission__c WHERE Complaint__c=:submissionId AND is_Backend_Submission__c = FALSE];
        }
        else if(isExamCredit !=null && isExamCredit == label.Str_true){
            subList = [Select Id,Hardcopy__c,(Select Id FROM Attachments) FROM MUSW__Submission__c WHERE CE_Exam_Credit__c=:submissionId AND is_Backend_Submission__c = FALSE];
        }*/
        Boolean isComplete = getStatus(subList);
        return isComplete;
    }
}