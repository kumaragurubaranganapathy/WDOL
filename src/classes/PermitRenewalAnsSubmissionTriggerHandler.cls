public class PermitRenewalAnsSubmissionTriggerHandler {    
    
     public static void updateAnswerSubmissionRecords(Map < Id, Answer__c > newAnswerMap, String renewalOrReinstatement) {       
        Set<String> permitTypeList = new Set<String>();
       /*Set<String> applicationMethodSet = new Set<String>();
       for(Answer__C tempAns: newAnswerMap.values()){
           //, permit__r.Application_Method__c
       		List<answer__C> tempPermitTypeList = [select id,  renewal_application__r.permit_type__c from answer__C where Id=:tempAns.Id];   
			//, renewal_application__r.permit__r.Application_Method__c
           for(Answer__C a:tempPermitTypeList ){
               permitTypeList.add(a.renewal_application__r.permit_type__c);
               applicationMethodSet.add(a.renewal_application__r.permit__r.Application_Method__c);
               
           }
           System.debug('permit Type is '+permitTypeList);
       } */        
          System.debug('permitTypeList>>>1'+permitTypeList);
        String showFor = '';
       		if(renewalOrReinstatement == 'Renewal PTO'){
                showFor = Label.Str_Permit_Renewal;
            }else if(renewalOrReinstatement == 'Reinstatement PTO'){
                showFor = Label.Str_Permit_Reinstatement;
            } 
         System.debug('showFor>>>'+showFor);
         System.debug('renewalOrReinstatement>>>'+renewalOrReinstatement);
        Map < String, List < MUSW__Master_Submission_List__c >> typeToSubmissionMap = new Map < String, List < MUSW__Master_Submission_List__c >> ();
        Set<String> BackgroundAPIFields = new Set<String>();
        for (MUSW__Master_Submission_List__c masterSubmission: [SELECT Id,External_Id__c, Name, Background_Question_Field_API_Name__c,  
                                                                Question__c, Expected_Answer__c, Description_Long__c, Application_Type__c, 
                                                                program_area__c, permit_type__c, Default__c, Show_For__c, 
                                                                Submission_Type__c, Application_Method__c, Document_API_Name__c, BG_File_Location_Type__c
                                                                FROM MUSW__Master_Submission_List__c 
                                                                WHERE Active__c = TRUE 
                                                                AND Object__c = :Label.API_Renewal_Application
                                                                AND Show_For__c includes (:showFor)
                                                   				AND permit_type__c IN :permitTypeList
                                                                //AND Application_Method__C IN: applicationMethodSet
                                                               ]) {
            System.debug('showFor>>>2 '+masterSubmission);
            List < MUSW__Master_Submission_List__c > tempSubmissionList = new List < MUSW__Master_Submission_List__c > ();
            if (typeToSubmissionMap.containsKey(masterSubmission.permit_type__c)) {
                System.debug('showFor>>>3');
                tempSubmissionList = typeToSubmissionMap.get(masterSubmission.permit_type__c);
            }
            tempSubmissionList.add(masterSubmission);
            typeToSubmissionMap.put(masterSubmission.permit_type__c, tempSubmissionList);
            if(masterSubmission.Question__c != null && masterSubmission.Background_Question_Field_API_Name__c != null){ // Submissions with Questions and Background API fields
                System.debug('showFor>>>4');
                BackgroundAPIFields.add(masterSubmission.Background_Question_Field_API_Name__c);  // Fields to be added to the dynamic query
            }
                                                                    System.debug('masterSubmission>>>'+masterSubmission);
        }
         System.debug('typeToSubmissionMap>>>'+typeToSubmissionMap);
        Set < Id > RenewalIds = new Set < Id > ();
        
        List < MUSW__Submission__c > submissionUpsertList = new List < MUSW__Submission__c > ();
        List < MUSW__Submission__c > submissionDeleteList = new List < MUSW__Submission__c > ();
        for (Answer__c ans: newAnswerMap.values()) {
            System.debug('showFor>>>5');
            if (ans.Renewal_Application__c != null) {
                System.debug('showFor>>>6');
                RenewalIds.add(ans.Renewal_Application__c);
            }
        }
        
        
        //Map < Id, Renewal_Application__c > Renewal = new Map < Id, Renewal_Application__c > ([Select id, (Select Id, Name, LicenseQuestionKey__c FROM Submissions__r) FROM Renewal_Application__c WHERE Id IN: RenewalIds and Type_Reinstatement_Renewal__c = :label.RNT_Renewal]);
        String query = 'Select id,  (Select Id, Name, LicenseQuestionKey__c FROM Submissions__r) '; // Moved the above query to Dynamic SOQL to include background API fields
        if(BackgroundAPIFields.size() > 0){
            System.debug('showFor>>>7');
            query+= ',';
            query+= String.join(new List<String>(BackgroundAPIFields), ',');
        }
        query+= ' FROM Renewal_Application__c WHERE Id IN: RenewalIds and  Renewal_Reinstatement_Type__c = \'' + renewalOrReinstatement +'\'';
        System.debug('QUERY => 8 '+ query);
        
        Map < Id, Renewal_Application__c > Renewal = new Map < Id, Renewal_Application__c > ((List<Renewal_Application__c>) Database.query(query));
        Map<String,Question__c> questionIdextid = new Map<String,Question__c>();
        Map<Id,Question__c> answerQuestionmap = new Map<Id,Question__c>();
        Set<String> QuestionextIds = new Set<String> ();
        System.debug('showFor>>>9');
        for(Answer__c ans:newAnswerMap.values())
        {System.debug('showFor>>>10');
            if(ans.External_id_of_Question__c!=null)
            {System.debug('showFor>>>11');
                QuestionextIds.add(ans.External_id_of_Question__c);
            }                
        }
        List<question__c> questions= [Select id ,External_Id__c,Parent_Object_API_Name__c,Compliance_Field_API_Name__c,Application_Type__c, 
                                                                program_area__c, permit_type__c,
                                      Question_is_Compliance_Related__c,Expected_Answer_Parent_Field_Value_Map__c,
                                      Parent_Object_Field_API_Name__c 
                                      from question__c 
                                      where External_Id__c in: QuestionextIds];
        for(Question__c question:questions ){
            System.debug('showFor>>>12');
            questionIdextid.put(question.External_Id__c,question);
        }
        for(Answer__c ans:newAnswerMap.values()) {
            System.debug('showFor>>>13');
            if(ans.External_id_of_Question__c!=null)
            {System.debug('showFor>>>14');
                answerQuestionmap.put(ans.id,questionIdextid.get(ans.External_id_of_Question__c));
            }                
        }
        
        for (Answer__c Ans: [Select Id,External_id_of_Question__c, Renewal_Application__c, 
                             Renewal_Application__r.Renewal_Reinstatement_Type__c,Renewal_Application__r.permit_type__c, Answer_Text__c 
                             from Answer__c 
                             where Id in: newAnswerMap.keySet()]) {
                                System.debug('showFor>>>15');
            if (Ans.Renewal_Application__c != null) {
                System.debug('showFor>>>16');
                if (Renewal.containsKey(Ans.Renewal_Application__c)) {
                    System.debug('showFor>>>17');
                    System.debug('Renewal---'+Renewal);
                    System.debug('Ans---'+Ans);
                    System.debug('typeToSubmissionMap---'+typeToSubmissionMap);
                    System.debug('Ans.Renewal_Application__r.Renewal_Reinstatement_Type__c---'+Ans.Renewal_Application__r.Renewal_Reinstatement_Type__c);
                    Map < String, MUSW__Submission__c > keyToSumissionMap = new Map < String, MUSW__Submission__c > ();
                    
                    for (MUSW__Submission__c submission: (Renewal.get(Ans.Renewal_Application__c)).Submissions__r) {
                        System.debug('showFor>>>18');
                        if (submission.LicenseQuestionKey__c != null) {
                            System.debug('showFor>>>19');
                            keyToSumissionMap.put(submission.LicenseQuestionKey__c, submission);
                        }
                    }
                    System.debug('typeToSubmissionMap>>>>>>>'+typeToSubmissionMap);
                    if (typeToSubmissionMap.containsKey(Ans.Renewal_Application__r.permit_type__c)) {
                        System.debug('showFor>>>20');
                        for (MUSW__Master_Submission_List__c masterSubmission: typeToSubmissionMap.get(Ans.Renewal_Application__r.permit_type__c)) {
                            System.debug('showFor>>>21');
                            String licenseSubmissionComboKey = String.valueOf(Ans.Renewal_Application__c) +masterSubmission.External_Id__c;
                            Question__c ansQuestion =answerQuestionmap.get(ans.Id);
                            if(ansQuestion!=null){
                                System.debug('showFor>>>22');
                                if ( ansQuestion.Id== masterSubmission.Question__c) {
                                    System.debug('showFor>>>23');
                                    String questionAnswer;
                                    try {
                                        System.debug('showFor>>>24');
                                        questionAnswer = ans.Answer_Text__c;
                                        System.debug('showFor>>>25');
                                    } catch (exception ex) {
                                        System.debug('showFor>>>EXCEPTION---------------');
                                        ErrorLogger.logGeneralException(ex, UserInfo.getUserId(), 'User', '', 'updateAnswerSubmissionRecords', 'PermitRenewalAnsSubmissionTriggerHandler', label.str_HIGH);
                                    }
                                    System.debug('questionAnswer>>>>>>>'+questionAnswer);
                                    System.debug('masterSubmission.Expected_Answer__c>>>>>>>'+masterSubmission.Expected_Answer__c);
                                    System.debug('keyToSumissionMap>>>>>>>'+keyToSumissionMap);
                                    System.debug('keyToSumissionMap.containsKey(licenseSubmissionComboKey)>>>>>>>'+keyToSumissionMap.containsKey(licenseSubmissionComboKey));
                                    System.debug('licenseSubmissionComboKey>>>>>>>'+licenseSubmissionComboKey);
                                    if (questionAnswer != null && questionAnswer.equalsIgnoreCase(masterSubmission.Expected_Answer__c)) {
                                        System.debug('showFor>>>26');
                                        Boolean BackgroundAPIcheck = true;
                                        if(masterSubmission.Background_Question_Field_API_Name__c != null && BackgroundAPIFields.size()>0 && BackgroundAPIFields.contains(masterSubmission.Background_Question_Field_API_Name__c)){
                                            System.debug('showFor>>>27');
                                            // Submission needs to be triggered based on Answer and value of Background API field on submission list
                                            String BackgroundAPIAnswer = (String)Renewal.get(Ans.Renewal_Application__c).get(masterSubmission.Background_Question_Field_API_Name__c);
                                            if(BackgroundAPIAnswer != 'yes')
                                                BackgroundAPIcheck = false;
                                        }
                                        if (!keyToSumissionMap.containsKey(licenseSubmissionComboKey) && BackgroundAPIcheck) {
                                            System.debug('showFor>>>28');
                                            MUSW__Submission__c newSubmission = new MUSW__Submission__c(Name = masterSubmission.Name, Description_Long__c = masterSubmission.Description_Long__c,
                                                                                                        LicenseQuestionKey__c = licenseSubmissionComboKey, License_Renewal__c = ans.Renewal_Application__c,
                                                                                                        Type__c = (masterSubmission.Submission_Type__c =='Hardcopy: To be Mailed' ? 'Hardcopy: To be Mailed' : 'Softcopy: To be Uploaded'),
                                                                                                        Document_API_Name__c = masterSubmission.Document_API_Name__c, Extid_from_Submission_List__c=masterSubmission.External_Id__c,
                                                                                                        MUSW__BG_File_Location_Type__c = masterSubmission.BG_File_Location_Type__c);
                                            
                                            if(newSubmission.MUSW__BG_File_Location_Type__c == null || newSubmission.MUSW__BG_File_Location_Type__c == '') newSubmission.MUSW__BG_File_Location_Type__c = 'Salesforce';
                                            submissionUpsertList.add(newSubmission);
                                        }
                                    } else if ((questionAnswer == null || !questionAnswer.equalsIgnoreCase(masterSubmission.Expected_Answer__c)) && keyToSumissionMap.containsKey(licenseSubmissionComboKey)) {
                                        //If answer is 'No' and there is an existing submission, it is deleted
                                        System.debug('showFor>>>29');
                                        MUSW__Submission__c oldSubmission = keyToSumissionMap.get(licenseSubmissionComboKey);
                                        submissionDeleteList.add(oldSubmission);
                                    }
                                }
                            }
                        }
                    }
                }
                
            }
            
        }
        
        try {System.debug('submissionUpsertList>>>'+submissionUpsertList);
             System.debug('submissionDeleteList>>>'+submissionDeleteList);
            if(!submissionUpsertList.isEmpty() && submissionUpsertList != null) {
                upsert submissionUpsertList LicenseQuestionKey__c;
            }
            if(!submissionDeleteList.isEmpty() && submissionDeleteList != null ) {
                delete submissionDeleteList;
            }
        } catch (Exception ex) {
            ErrorLogger.logGeneralException(ex, UserInfo.getUserId(), 'User', '', 'updateAnswerSubmissionRecords', 'PermitRenewalAnsSubmissionTriggerHandler', label.str_HIGH);
        }
    }

}