public class CredAnsSubmissionTriggerHandler {
    public Set < MUSW__License2__c > newLicenses {
        get;
        set;
    }

    public Set < Id > LicenseIds {
        get {
            if (LicenseIds == null) LicenseIds = new Set < Id > ();
            return LicenseIds;
        }
        set;
    }

    public Map < Id, MUSW__License2__c > LicenseId_License_Map {
        get {
            if (LicenseId_License_Map == null) LicenseId_License_Map = new Map < Id, MUSW__License2__c > ();
            return LicenseId_License_Map;
        }
        set;
    }
    
   public void updateAnswerSubmissionRecords(Map < Id, Answer__c > newAnswerMap) {
       
       Set<String> credentialList = new Set<String>();
       Set<String> applicationMethodSet = new Set<String>();
       for(Answer__C tempAns: newAnswerMap.values()){
       		List<answer__C> tempcredList = [select id, license__c, license__r.credential__C, license__r.Application_Method__c from answer__C where Id=:tempAns.Id];   
           for(Answer__C a:tempcredList ){
               credentialList.add(a.license__r.credential__c);
               applicationMethodSet.add(a.license__r.Application_Method__c);
           }
           System.debug('credential is '+credentialList);
       }
        
        //System.debug('credential List for new Application--'+credentialList);
        Map < String, List < MUSW__Master_Submission_List__c >> typeToSubmissionMap = new Map < String, List < MUSW__Master_Submission_List__c >> ();
        for (MUSW__Master_Submission_List__c masterSubmission: [SELECT Id, Name,External_id__c, Background_Question_Field_API_Name__c, Question__c, 
                                                   Expected_Answer__c, Description_Long__c, Application_Type__c, Credential_Type__c, Credential__c, 
                                                   Default__c, Show_For__c, Submission_Type__c, Application_Method__c, Document_API_Name__c, BG_File_Location_Type__c
                                                   FROM MUSW__Master_Submission_List__c 
                                                   WHERE Active__c = TRUE 
                                                   AND Object__c = :label.API_License2
                                                   AND Show_for__c = 'Credential'
                                                   AND Credential__c IN :credentialList
                                                                AND Application_Method__C IN: applicationMethodSet
                                                               ]) {
		//System.debug('in ansTrigHandler 2');                                                       
            List < MUSW__Master_Submission_List__c > tempSubmissionList = new List < MUSW__Master_Submission_List__c > ();
            if (typeToSubmissionMap.containsKey(masterSubmission.Credential__c)) {
                ///System.debug('in ansTrigHandler 3 '+masterSubmission.Credential__c);                                                       
                tempSubmissionList = typeToSubmissionMap.get(masterSubmission.Credential__c);
            }
              	//System.debug('in ansTrigHandler 4 '+tempSubmissionList);                                                       
            tempSubmissionList.add(masterSubmission);
			//System.debug('in ansTrigHandler 5 '+tempSubmissionList);
            typeToSubmissionMap.put(masterSubmission.Credential__c, tempSubmissionList);
			//System.debug('in ansTrigHandler 6 '+typeToSubmissionMap);
        }

        List < MUSW__Submission__c > submissionUpsertList = new List < MUSW__Submission__c > ();
        List < MUSW__Submission__c > submissionDeleteList = new List < MUSW__Submission__c > ();

        for (Answer__c Ans: [Select Id, Question__c, License__c, License__r.Credential__c, Answer_Text__c from Answer__c where Id in: newAnswerMap.keySet()]) {
            LicenseIds.add(Ans.License__c);
            //System.debug('in ansTrigHandler 7 '+LicenseIds);
        }

        List < Id > LicenseIdsList = new List < Id > ();
        if (LicenseIds.size() > 0) {
            //System.debug('in ansTrigHandler 8 '+LicenseIds.size());
            LicenseIdsList.addAll(LicenseIds);
            //System.debug('in ansTrigHandler 9 '+LicenseIdsList);
            if (newLicenses == null) {
                //System.debug('in ansTrigHandler 10 ');
                newLicenses = new Set < MUSW__License2__c > ([select id, (Select Id, Name, LicenseQuestionKey__c FROM MUSW__Submissions__r) FROM MUSW__License2__c WHERE Id IN: LicenseIdsList]);
            }

            if (newLicenses.size() > 0) {
                System.debug('in ansTrigHandler 11 ');
                for (MUSW__License2__c license: newLicenses) {
                    System.debug('in ansTrigHandler 12');
                    LicenseId_License_Map.put(license.Id, license);
                }
            }
        }
       
       Map<String,Question__c> questionIdextid = new Map<String,Question__c>();
        Map<Id,Question__c> answerQuestionmap = new Map<Id,Question__c>();
        Set<String> QuestionextIds = new Set<String>();
        
       
        for(Answer__c ans:newAnswerMap.values())
        {            
       System.debug('in ansTrigHandler 13 ');
            if(ans.External_id_of_Question__c!=null)
            {
                System.debug('in ansTrigHandler 14 ');
                QuestionextIds.add(ans.External_id_of_Question__c);
            }                
        }
        List<question__c> questions= [Select id ,external_id__c,Parent_Object_API_Name__c,Compliance_Field_API_Name__c,
                                      Question_is_Compliance_Related__c,Expected_Answer_Parent_Field_Value_Map__c,
                                      Parent_Object_Field_API_Name__c from question__c where external_id__C in: QuestionextIds];
        for(Question__c question:questions ){
            System.debug('in ansTrigHandler 15 ');
            questionIdextid.put(question.external_id__C,question);
        }
        for(Answer__c ans:newAnswerMap.values()) {
            System.debug('in ansTrigHandler 16 ');
            if(ans.External_id_of_Question__c!=null)
            {
                System.debug('in ansTrigHandler 17 ');
                answerQuestionmap.put(ans.id,questionIdextid.get(ans.External_id_of_Question__c));
            }                
        }
       
        for (Answer__c Ans: [Select Id, Question__c, License__c, License__r.Credential__c, Answer_Text__c from Answer__c where Id in: newAnswerMap.keySet()]) {
            System.debug('in ansTrigHandler 18 ');
            if (ans.License__c != null && LicenseId_License_Map.containsKey(ans.License__c)) {
                System.debug('in ansTrigHandler 19 ');
                //Creating a map of existing submission records
                Map < String, MUSW__Submission__c > keyToSumissionMap = new Map < String, MUSW__Submission__c > ();
                for (MUSW__Submission__c submission: (LicenseId_License_Map.get(ans.License__c)).MUSW__Submissions__r) {
                    System.debug('in ansTrigHandler 20 ');
                    if (submission.LicenseQuestionKey__c != null) {
                        System.debug('in ansTrigHandler 21 ');
                        keyToSumissionMap.put(submission.LicenseQuestionKey__c, submission);
                    }
                }
                Answer__c newAnswer = newAnswerMap.get(ans.id);
                if (typeToSubmissionMap.containsKey(ans.License__r.Credential__c)) {
                    System.debug('in ansTrigHandler 22 ');
                    for (MUSW__Master_Submission_List__c masterSubmission: typeToSubmissionMap.get(ans.License__r.Credential__c)) {
                        System.debug('in ansTrigHandler 23 ');
                        String licenseSubmissionComboKey = String.valueOf((LicenseId_License_Map.get(ans.License__c)).Id) + masterSubmission.External_Id__c;
                       Question__c ansQuestion =answerQuestionmap.get(ans.Id);
                        if(ansQuestion!=null){
                            System.debug('in ansTrigHandler 24 ');
                            if ( ansQuestion.Id== masterSubmission.Question__c) {
                                System.debug('in ansTrigHandler 25 ');
                            String questionAnswer;
                            try {
                                questionAnswer = ans.Answer_Text__c;
                                System.debug('in ansTrigHandler 26 ');
                            } catch (Exception ex) {
                                ErrorLogger.logGeneralException(ex, UserInfo.getUserId(), label.Str_User, 'while fetching answer text', 'updateAnswerSubmissionRecords', 'CredAnsSubmissionTriggerHandler', label.str_HIGH);
                            }

                            if (questionAnswer != null && questionAnswer.equalsIgnoreCase(masterSubmission.Expected_Answer__c)) {
                                System.debug('in ansTrigHandler 27 ');
                                if (!keyToSumissionMap.containsKey(licenseSubmissionComboKey)) {
                                    System.debug('in ansTrigHandler 28 ');
                                    MUSW__Submission__c newSubmission = new MUSW__Submission__c(Name = masterSubmission.Name, Description_Long__c = masterSubmission.Description_Long__c,
                                        LicenseQuestionKey__c = licenseSubmissionComboKey, MUSW__License2__c = ans.License__c,
                                        Type__c = (masterSubmission.Submission_Type__c =='Hardcopy: To be Mailed' ? 'Hardcopy: To be Mailed' : 'Softcopy: To be Uploaded'),
                                        Document_API_Name__c = masterSubmission.Document_API_Name__c, Extid_from_Submission_List__c=masterSubmission.External_Id__c,
                                        MUSW__BG_File_Location_Type__c = masterSubmission.BG_File_Location_Type__c);
                                    
                                    if(newSubmission.MUSW__BG_File_Location_Type__c == null || newSubmission.MUSW__BG_File_Location_Type__c == '') newSubmission.MUSW__BG_File_Location_Type__c = 'Salesforce';
                                    submissionUpsertList.add(newSubmission);
                                }
                            } else if ((questionAnswer == null || !questionAnswer.equalsIgnoreCase(masterSubmission.Expected_Answer__c)) && keyToSumissionMap.containsKey(licenseSubmissionComboKey)) {
                                System.debug('in ansTrigHandler 29 ');
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
            System.debug('in ansTrigHandler 30>>> submissionUpsertList '+submissionUpsertList);
            System.debug('in ansTrigHandler 31>>> submissionDeleteList '+submissionDeleteList);
            if(submissionUpsertList != null && submissionUpsertList.size() > 0){
            	upsert submissionUpsertList LicenseQuestionKey__c;	
            }
            if(submissionDeleteList != null && submissionDeleteList.size() > 0 ){
            	delete submissionDeleteList;	
            }
        } catch (Exception ex) {
            ErrorLogger.logGeneralException(ex, UserInfo.getUserId(), label.Str_User, 'while upsert/delete', 'updateAnswerSubmissionRecords', 'CredAnsSubmissionTriggerHandler', label.str_HIGH);            
        }
    }

}