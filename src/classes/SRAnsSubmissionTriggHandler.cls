/*************************************************************************************************************
** User Story: 
**************************************************************************************************************
** Class Name       : SRAnsSubmissionTriggHandler
** Description      : Service Request Answer Submission 
** Version          : 1.0
** Built By         : Srikanth Kottam

**------------------------------------------------------------------------------------------------------------
** Modification Log:
**------------------
** Developer                  Date          Version               Description
**-----------------------------------------------------------------------------------------------------------
** 
** Review Log:
**---------------
** Reviewer                  Date          Version               Description
**------------------------------------------------------------------------------------------------------------
**
*************************************************************************************************************/
public class SRAnsSubmissionTriggHandler {
	public static void updateSubmissionRecords(Map<Id,Answer__c> newAnswerMap){
        Map<String, List<MUSW__Master_Submission_List__c>> typeToSubmissionMap = new Map<String,List<MUSW__Master_Submission_List__c>>();
        Set<Id> SRIds = new Set<Id>();
        Set<String> credentialType = new Set<String>();
        for(Answer__c tempAns: newAnswerMap.values()){
            List<answer__C> tempansList = [select id, Service_Request__c, Service_Request__r.Credential_Type__c from answer__C where Id=:tempAns.Id]; 
            for(Answer__C a: tempansList ){
                SRIds.add(a.Service_Request__c);
            	credentialType.add(a.Service_Request__r.Credential_Type__c);
            }
        }
        for(MUSW__Master_Submission_List__c masterSubmission:[SELECT Id, Name,External_id__c, Background_Question_Field_API_Name__c, Question__c, External_Id_of_Question__c,
                                                   Expected_Answer__c, Description_Long__c, Application_Type__c, Credential_Type__c, Credential__c, Service_Request_Type__c, 
                                                   Default__c, Show_For__c, Submission_Type__c, Application_Method__c, Document_API_Name__c, BG_File_Location_Type__c
                                                   FROM MUSW__Master_Submission_List__c 
                                                   WHERE Active__c = TRUE 
                                                   AND Object__c = :label.API_Application
                                                   AND Show_for__c = 'Service Request' 
                                                   AND Credential_Type__c IN: credentialType            
                                                   ]){ 
                                                  // AND Service_Request__c IN :SRIds
                                                  // AND Application_Method__C IN: applicationMethodSet
                                                  
            List<MUSW__Master_Submission_List__c> tempSubmissionList = new List<MUSW__Master_Submission_List__c> ();
            if(typeToSubmissionMap.containsKey(masterSubmission.Service_Request_Type__c)){
                tempSubmissionList = typeToSubmissionMap.get(masterSubmission.Service_Request_Type__c);
            }
            tempSubmissionList.add(masterSubmission);
            typeToSubmissionMap.put(masterSubmission.Service_Request_Type__c, tempSubmissionList);
        }
        List<MUSW__Submission__c> submissionUpsertList = new List<MUSW__Submission__c>();
        List<MUSW__Submission__c> submissionDeleteList = new List<MUSW__Submission__c>();
        Map<Id,MUSW__Application2__c> SRMap  = new Map<Id,MUSW__Application2__c>([Select id, (Select Id,Name,LicenseQuestionKey__c FROM MUSW__Submissions__r) FROM MUSW__Application2__c WHERE Id IN:SRIds]);
        for(Answer__c Ans:[Select Id, External_id_of_Question__c, Service_Request__c, Service_Request__r.MUSW__Type__c, Answer_Text__c from Answer__c where Id in : newAnswerMap.keySet()]){
            if(Ans.Service_Request__c!=null){
                if(SRMap.containsKey(Ans.Service_Request__c)){
                    Map<String,MUSW__Submission__c> keyToSubmissionMap = new Map<String,MUSW__Submission__c>();
                    for(MUSW__Submission__c submission: (SRMap.get(Ans.Service_Request__c)).MUSW__Submissions__r){
                        if(submission.LicenseQuestionKey__c != null){
                            keyToSubmissionMap.put(submission.LicenseQuestionKey__c,submission);
                        }
                    }
                    Answer__c newAnswer = newAnswerMap.get(ans.id);
                    if(typeToSubmissionMap.containsKey(Ans.Service_Request__r.MUSW__Type__c)){
                        for(MUSW__Master_Submission_List__c masterSubmission:typeToSubmissionMap.get(Ans.Service_Request__r.MUSW__Type__c)){
                            String licenseSubmissionComboKey = String.valueOf(Ans.Service_Request__c)+String.valueOf(masterSubmission.Id);
                            if(Ans.External_id_of_Question__c == masterSubmission.External_Id_of_Question__c){
                                String questionAnswer;
                                try{
                                    questionAnswer= ans.Answer_Text__c;
                                }catch(Exception ex){
                                    ErrorLogger.logGeneralException(ex, UserInfo.getUserId(), label.Str_User, '', 'Update Answer Submission Records', 'SRAnsSubmissionTriggHandler', label.str_HIGH);
                                }
                                if(questionAnswer!= null && questionAnswer.equalsIgnoreCase(masterSubmission.Expected_Answer__c)){
                                    if(!keyToSubmissionMap.containsKey(licenseSubmissionComboKey)){
                                        MUSW__Submission__c newSubmission = new MUSW__Submission__c(Name = masterSubmission.Name, Description_Long__c = masterSubmission.Description_Long__c,
                                        LicenseQuestionKey__c = licenseSubmissionComboKey, MUSW__Application2__c = ans.Service_Request__c, 
                                        Type__c = (masterSubmission.Submission_Type__c =='Hardcopy: To be Mailed' ? 'Hardcopy: To be Mailed' : 'Softcopy: To be Uploaded'),
                                        Document_API_Name__c = masterSubmission.Document_API_Name__c, Extid_from_Submission_List__c=masterSubmission.External_Id__c,
                                        MUSW__BG_File_Location_Type__c = masterSubmission.BG_File_Location_Type__c);
                                                                                                    // Master_Submission__c=masterSubmission.Id);
                                        submissionUpsertList.add(newSubmission);
                                        
                                    }
                                    system.debug('submissionUpsertList>>>'+submissionUpsertList);
                                }
                                
                                else if((questionAnswer == null || !questionAnswer.equalsIgnoreCase(masterSubmission.Expected_Answer__c)) && keyToSubmissionMap.containsKey(licenseSubmissionComboKey)){
                                    //If answer is 'No' and there is an existing submission, it is deleted
                                    MUSW__Submission__c oldSubmission = keyToSubmissionMap.get(licenseSubmissionComboKey);
                                    submissionDeleteList.add(oldSubmission);
                                }
                            }
                        }
                        
                    }
                }
            }
            
        }
        try{
            upsert submissionUpsertList LicenseQuestionKey__c;
            delete submissionDeleteList;
        }catch(Exception ex){
            ErrorLogger.logGeneralException(ex, UserInfo.getUserId(), label.Str_User, '', 'Update Answer Submission Records', 'SRAnsSubmissionTriggHandler', label.str_HIGH);
        }
    }
}