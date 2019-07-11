public class PermitAnsSubmissionTriggerHandler {
    public Set < MUSW__Permit2__c > newPermits {
        get;
        set;
    }

    public Set < Id > permitIds {
        get {
            if (permitIds == null) permitIds = new Set < Id > ();
            return permitIds;
        }
        set;
    }

    public Map < Id, MUSW__Permit2__c > permitId_permit_Map {
        get {
            if (permitId_permit_Map == null) permitId_permit_Map = new Map < Id, MUSW__Permit2__c > ();
            return permitId_permit_Map;
        }
        set;
    }
    
   public void updateAnswerSubmissionRecords(Map < Id, Answer__c > newAnswerMap) {
       
       Set<String> permitTypeList = new Set<String>();
       //Set<String> applicationMethodSet = new Set<String>();
       for(Answer__C tempAns: newAnswerMap.values()){
            List<answer__C> tempPermitTypeList = [select id, permit__c, permit__r.Permit_Type__c, permit__r.Application_Method__c from answer__C where Id=:tempAns.Id];   
           for(Answer__C a:tempPermitTypeList ){
               permitTypeList.add(a.permit__r.Permit_Type__c);
         //      applicationMethodSet.add(a.permit__r.Application_Method__c);
           }
           System.debug('credential is '+permitTypeList);
       }
        
        //System.debug('credential List for new Application--'+permitTypeList);
        Map < String, List < MUSW__Master_Submission_List__c >> typeToSubmissionMap = new Map < String, List < MUSW__Master_Submission_List__c >> ();
        for (MUSW__Master_Submission_List__c masterSubmission: [SELECT Id, Name,External_id__c, Background_Question_Field_API_Name__c, Question__c, 
                                                   Expected_Answer__c, Description_Long__c, Application_Type__c, Program_Area__c, Permit_Type__c, 
                                                   Default__c, Show_For__c, Submission_Type__c, Application_Method__c, Document_API_Name__c, BG_File_Location_Type__c
                                                   FROM MUSW__Master_Submission_List__c 
                                                   WHERE Active__c = TRUE 
                                                   AND Object__c = :label.API_Permit
                                                   AND Show_for__c = 'Permit'
                                                   AND Permit_Type__c IN :permitTypeList
                                                   //             AND Application_Method__C IN: applicationMethodSet
                                                               ]) {
        System.debug('in permit ansTrigHandler 2');                                                       
            List < MUSW__Master_Submission_List__c > tempSubmissionList = new List < MUSW__Master_Submission_List__c > ();
            if (typeToSubmissionMap.containsKey(masterSubmission.Permit_Type__c)) {
                System.debug('in ansTrigHandler 3 '+masterSubmission.Permit_Type__c);                                                       
                tempSubmissionList = typeToSubmissionMap.get(masterSubmission.Permit_Type__c);
            }
                System.debug('in permit ansTrigHandler 4 '+tempSubmissionList);                                                       
            tempSubmissionList.add(masterSubmission);
            System.debug('in permit ansTrigHandler 5 '+tempSubmissionList);
            typeToSubmissionMap.put(masterSubmission.Permit_Type__c, tempSubmissionList);
            System.debug('in permit ansTrigHandler 6 '+typeToSubmissionMap);
        }

        List < MUSW__Submission__c > submissionUpsertList = new List < MUSW__Submission__c > ();
        List < MUSW__Submission__c > submissionDeleteList = new List < MUSW__Submission__c > ();

        for (Answer__c Ans: [Select Id, Question__c,permit__c, permit__r.Permit_Type__c, Answer_Text__c from Answer__c where Id in: newAnswerMap.keySet()]) {
            permitIds.add(Ans.Permit__c);
           System.debug('in permit ansTrigHandler 7 '+permitIds);
        }

        List < Id > permitIdList = new List < Id > ();
        if (permitIds.size() > 0) {
            System.debug('in permit ansTrigHandler 8 '+permitIds.size());
            permitIdList.addAll(permitIds);
            System.debug('in permit ansTrigHandler 9 '+permitIdList);
            if (newPermits == null) {
                System.debug('in permit ansTrigHandler 10 ');
                newPermits = new Set < MUSW__Permit2__c > ([select id, (Select Id, Name, LicenseQuestionKey__c FROM MUSW__Submissions__r) FROM MUSW__Permit2__c WHERE Id IN: permitIdList]);
            }

            if (newPermits.size() > 0) {
                System.debug('in permit ansTrigHandler 11 ');
                for (MUSW__Permit2__c permit: newPermits) {
                    System.debug('in permit ansTrigHandler 12');
                    permitId_permit_Map.put(permit.Id, permit);
                }
            }
        }
       
       Map<String,Question__c> questionIdextid = new Map<String,Question__c>();
        Map<Id,Question__c> answerQuestionmap = new Map<Id,Question__c>();
        Set<String> QuestionextIds = new Set<String>();
        
       
        for(Answer__c ans:newAnswerMap.values())
        {            
       System.debug('in permit ansTrigHandler 13 ');
            if(ans.External_id_of_Question__c!=null)
            {
                System.debug('in permit ansTrigHandler 14 ');
                QuestionextIds.add(ans.External_id_of_Question__c);
            }                
        }
        List<question__c> questions= [Select id ,external_id__c,Parent_Object_API_Name__c,Compliance_Field_API_Name__c,
                                      Question_is_Compliance_Related__c,Expected_Answer_Parent_Field_Value_Map__c,
                                      Parent_Object_Field_API_Name__c from question__c where external_id__C in: QuestionextIds];
        for(Question__c question:questions ){
            System.debug('in permit ansTrigHandler 15 ');
            questionIdextid.put(question.external_id__C,question);
        }
        for(Answer__c ans:newAnswerMap.values()) {
            System.debug('in permit ansTrigHandler 16 ');
            if(ans.External_id_of_Question__c!=null)
            {
                System.debug('in permit ansTrigHandler 17 ');
                answerQuestionmap.put(ans.id,questionIdextid.get(ans.External_id_of_Question__c));
            }                
        }
       
        for (Answer__c Ans: [Select Id, Question__c,permit__c, permit__r.Permit_Type__c, Answer_Text__c from Answer__c where Id in: newAnswerMap.keySet()]) {
            System.debug('in permit ansTrigHandler 18 ');
            if (ans.permit__c != null && permitId_permit_Map.containsKey(ans.permit__c)) {
                System.debug('in permit ansTrigHandler 19 ');
                //Creating a map of existing submission records
                Map < String, MUSW__Submission__c > keyToSumissionMap = new Map < String, MUSW__Submission__c > ();
                for (MUSW__Submission__c submission: (permitId_permit_Map.get(ans.permit__c)).MUSW__Submissions__r) {
                    System.debug('in permit ansTrigHandler 20 ');
                    if (submission.LicenseQuestionKey__c != null) {
                        System.debug('in permit ansTrigHandler 21 ');
                        keyToSumissionMap.put(submission.LicenseQuestionKey__c, submission);
                    }
                }
                Answer__c newAnswer = newAnswerMap.get(ans.id);
                if (typeToSubmissionMap.containsKey(ans.permit__r.Permit_Type__c)) {
                    System.debug('in permit ansTrigHandler 22 ');
                    for (MUSW__Master_Submission_List__c masterSubmission: typeToSubmissionMap.get(ans.permit__r.Permit_Type__c)) {
                        System.debug('in permit ansTrigHandler 23 ');
                        String licenseSubmissionComboKey = String.valueOf((permitId_permit_Map.get(ans.permit__c)).Id) + masterSubmission.External_Id__c;
                       Question__c ansQuestion =answerQuestionmap.get(ans.Id);
                        if(ansQuestion!=null){
                            System.debug('in permit ansTrigHandler 24 ');
                            if ( ansQuestion.Id== masterSubmission.Question__c) {
                                System.debug('in permit ansTrigHandler 25 ');
                            String questionAnswer;
                            try {
                                questionAnswer = ans.Answer_Text__c;
                                System.debug('in permit ansTrigHandler 26 ');
                            } catch (Exception ex) {
                                System.debug('------------------EXCEPTION-----------');
                                ErrorLogger.logGeneralException(ex, UserInfo.getUserId(), 'User', '', 'updateAnswerSubmissionRecords', 'PermitAnsSubmissionTriggerHandler', label.str_HIGH);
                            }

                            if (questionAnswer != null && questionAnswer.equalsIgnoreCase(masterSubmission.Expected_Answer__c)) {
                                System.debug('in permit ansTrigHandler 27 ');
                                if (!keyToSumissionMap.containsKey(licenseSubmissionComboKey)) {
                                    System.debug('in permit ansTrigHandler 28 ');
                                    MUSW__Submission__c newSubmission = new MUSW__Submission__c(Name = masterSubmission.Name, Description_Long__c = masterSubmission.Description_Long__c,
                                        LicenseQuestionKey__c = licenseSubmissionComboKey, MUSW__Permit2__c = ans.permit__c,
                                        Type__c = (masterSubmission.Submission_Type__c =='Hardcopy: To be Mailed' ? 'Hardcopy: To be Mailed' : 'Softcopy: To be Uploaded'),
                                        Document_API_Name__c = masterSubmission.Document_API_Name__c, Extid_from_Submission_List__c=masterSubmission.External_Id__c,
                                        MUSW__BG_File_Location_Type__c = masterSubmission.BG_File_Location_Type__c);
                                    
                                    if(newSubmission.MUSW__BG_File_Location_Type__c == null || newSubmission.MUSW__BG_File_Location_Type__c == '') newSubmission.MUSW__BG_File_Location_Type__c = 'Salesforce';
                                    submissionUpsertList.add(newSubmission);
                                }
                            } else if ((questionAnswer == null || !questionAnswer.equalsIgnoreCase(masterSubmission.Expected_Answer__c)) && keyToSumissionMap.containsKey(licenseSubmissionComboKey)) {
                                System.debug('in permit ansTrigHandler 29 ');
                                //If answer is 'No' and there is an existing submission, it is deleted
                                MUSW__Submission__c oldSubmission = keyToSumissionMap.get(licenseSubmissionComboKey);
                                submissionDeleteList.add(oldSubmission);
                            }
                        }
                    }
                    }
                }
            }
        }
        try {
            System.debug('in permit ansTrigHandler 30>>> submissionUpsertList '+submissionUpsertList);
            System.debug('in permit ansTrigHandler 31>>> submissionDeleteList '+submissionDeleteList);
            if(submissionUpsertList != null && submissionUpsertList.size() > 0){
                upsert submissionUpsertList LicenseQuestionKey__c;  
            }
            if(submissionDeleteList != null && submissionDeleteList.size() > 0 ){
                delete submissionDeleteList;    
            }
        } catch (Exception ex) {
            System.debug('------------------EXCEPTION-----------');
            ErrorLogger.logGeneralException(ex, UserInfo.getUserId(), 'User', '', 'updateAnswerSubmissionRecords', 'PermitAnsSubmissionTriggerHandler', label.str_HIGH);
        }
    }

}