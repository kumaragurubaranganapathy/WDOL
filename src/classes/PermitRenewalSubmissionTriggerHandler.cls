/**
* Name: PermitRenewalSubmissionTriggerHandler
* Type: Class
* Description: Trigger Handler for Renewals on MUSW__Permit2__c object
* Date:        Developer/Company                 	Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 08/06/2018   Sharad Maheshwari/Deloitte           Initial Creation
**/
/**
* Name: RenewalSubmissionTriggerHandler
* Type: Class
* Description: Trigger Handler for Renewals on MUSW__License2__c
* Date:        Developer/Company                 	Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 08/06/2018   Sharad Maheshwari/Deloitte           Initial Creation
**/
public with sharing class PermitRenewalSubmissionTriggerHandler {
	public static void updateSubmissionRecords(Map<Id,Renewal_Application__c> newLicenseRenewalMap){
		system.debug('LicenseRenewalMap=>'+newLicenseRenewalMap);
        String renewalOrReinstatement = '';
        String showFor = '';
        String permitType = '';
        String programArea = '';
        String applicationMethod ='';
        Set<String> permitList = new Set<String>();
       Set<String> applicationMethodSet = new Set<String>();
       for(Renewal_Application__c renewalApp: newLicenseRenewalMap.values())
        {
            renewalOrReinstatement = renewalApp.Renewal_Reinstatement_Type__c;
            if(renewalOrReinstatement == 'Renewal PTO'){
                showFor = 'Permit Renewal';
            }else if(renewalOrReinstatement == 'Reinstatement PTO'){
                showFor = 'Permit Reinstatement';
            }
            permitType = renewalApp.Permit_Type__c;
            programArea = renewalApp.Program_Area__C;
            List<Renewal_Application__C> tempcredList = [select id, permit__c, permit__r.permit_type__C/*, permit__r.Application_Method__c*/ from renewal_application__C where Id=:renewalApp.Id];   
           for(Renewal_Application__C a:tempcredList ){
               permitList.add(a.permit__r.permit_type__C);
            //   applicationMethodSet.add(a.permit__r.Application_Method__c);
           }
            
        }
        System.debug('renewalOrReinstatement :'+renewalOrReinstatement);
        System.debug('showFor :'+showFor);
        System.debug('Permit_Type__c :'+permitType);
        System.debug('programArea :'+programArea);
        
        
		/***************************************************************************************************
	    * @Description : Method to update default sumission records for Renewals on the Renewal Application Object
	    * @Param       : Map<Id,Renewal_Application__c> newLicenseRenewalMap
	    * @Return      : NA
	    ****************************************************************************************************/
    	//Creating a map of license type and corresponding submission list.
    	Map<String, List<MUSW__Master_Submission_List__c>> typeToSubmissionMap = new Map<String,List<MUSW__Master_Submission_List__c>>();
        system.debug('typeToSubmissionMap>>'+typeToSubmissionMap);
        
        for(MUSW__Master_Submission_List__c masterSubmission:[SELECT Id, External_id__c, Name, Background_Question_Field_API_Name__c, Question__c,Expected_Answer__c,
                                                  					Description_Long__c, Application_Type__c, Permit_Type__c, Program_Area__C, Show_For__c,
                                                              		Default__c, Submission_Type__c, Document_API_Name__c, BG_File_Location_Type__c
                                                              FROM MUSW__Master_Submission_List__c 
                                                              WHERE Active__c = TRUE 
                                                              AND Object__c='Renewal_Application__c' 
                                                              AND Show_For__c includes (:showFor)                                                              
                                                              AND Permit_Type__c IN :permitList
                                                              //AND Program_Area__C = :programArea
                                                              //AND Application_Method__c IN :applicationMethodSet
                                                              ]){
        	system.debug('masterSubmission==>'+masterSubmission);
        	List<MUSW__Master_Submission_List__c> tempSubmissionList = new List<MUSW__Master_Submission_List__c> ();
        	if(typeToSubmissionMap.containsKey(masterSubmission.Permit_Type__c)){
                tempSubmissionList = typeToSubmissionMap.get(masterSubmission.Permit_Type__c);
            }
            
            tempSubmissionList.add(masterSubmission);
            system.debug('tempSubmissionList>>'+tempSubmissionList);
            typeToSubmissionMap.put(masterSubmission.Permit_Type__c, tempSubmissionList);
            system.debug('typeToSubmissionMap>>'+typeToSubmissionMap);
                
        }
        Set<String> renewalFieldSet = Schema.SObjectType.Renewal_Application__c.fields.getMap().keyset();
        List<MUSW__Submission__c> submissionUpsertList = new List<MUSW__Submission__c>();
        List<MUSW__Submission__c> submissionDeleteList = new List<MUSW__Submission__c>();
        
        for(Renewal_Application__c licenseRenewal:[Select id,(Select Id,Name,LicenseQuestionKey__c FROM Submissions__r) FROM Renewal_Application__c WHERE Id=:newLicenseRenewalMap.keyset() and (Renewal_Reinstatement_Type__c = :renewalOrReinstatement)]){
        	system.debug('licenseRenewal==>'+licenseRenewal);
        	
        	//Getting new license instance from Trigger.newMap
            Renewal_Application__c newLincenseRenewal = newLicenseRenewalMap.get(licenseRenewal.Id);
            
            //Creating a map of existing submission records
            Map<String,MUSW__Submission__c> keyToSumissionMap = new Map<String,MUSW__Submission__c>();
            for(MUSW__Submission__c submission: licenseRenewal.Submissions__r){
                if(submission.LicenseQuestionKey__c != null){
                    keyToSumissionMap.put(submission.LicenseQuestionKey__c,submission);
                }
            }
            system.debug(typeToSubmissionMap.containsKey(newLincenseRenewal.Permit_Type__c));
            //Creating submissions based on License Type
            if(typeToSubmissionMap.containsKey(newLincenseRenewal.Permit_Type__c)){
            	system.debug('Entering 66');
				for(MUSW__Master_Submission_List__c masterSubmission:typeToSubmissionMap.get(newLincenseRenewal.Permit_Type__c)){
            		String licenseSubmissionComboKey = String.valueOf(newLincenseRenewal.Id)+String.valueOf(masterSubmission.Id);
            		
            		if(masterSubmission.Default__c){
            			system.debug('entering 71');
            			System.debug('key++'+keyToSumissionMap);
            			system.debug(licenseSubmissionComboKey);
            			if(!keyToSumissionMap.containsKey(licenseSubmissionComboKey)){
            				system.debug(masterSubmission.Show_For__c);
            				system.debug(masterSubmission.Show_For__c.contains(showFor));
            				if(masterSubmission.Show_For__c != null && (masterSubmission.Show_For__c.contains(showFor)))
            				{
            					system.debug('entering here!');
            					MUSW__Submission__c newSubmission = new MUSW__Submission__c(Name=masterSubmission.Name,Description_Long__c=masterSubmission.Description_Long__c,
                                                                                        LicenseQuestionKey__c = licenseSubmissionComboKey,License_Renewal__c = newLincenseRenewal.Id,
                                                                                        Type__c =(masterSubmission.Submission_Type__c =='Hardcopy: To be Mailed'? 'Hardcopy: To be Mailed' : 'Softcopy: To be Uploaded'),
                                                                                        Document_API_Name__c = masterSubmission.Document_API_Name__c, 
                                                                                        Master_Submission_List__c=masterSubmission.Id,MUSW__Required__c=masterSubmission.Default__c,
                                                                                        MUSW__BG_File_Location_Type__c = masterSubmission.BG_File_Location_Type__c);
                                
                                if(newSubmission.MUSW__BG_File_Location_Type__c == null || newSubmission.MUSW__BG_File_Location_Type__c == '') newSubmission.MUSW__BG_File_Location_Type__c = 'Salesforce';
                                submissionUpsertList.add(newSubmission);
            				}
            			}
            		}
                    
                    else if(masterSubmission.Background_Question_Field_API_Name__c != null && renewalFieldSet.contains(masterSubmission.Background_Question_Field_API_Name__c.toLowerCase()))
                    {
                        String questionAnswer;
                        try{
                            questionAnswer= (String)newLincenseRenewal.get(masterSubmission.Background_Question_Field_API_Name__c);
                        }catch(Exception ex){
                            System.debug('ERROR - Please update Question-Submission Mapping cusotm setting with correct field API names'+ex);
                        }
                        
                        //If answer is 'Yes' new submission is created
                        if(questionAnswer!= null && questionAnswer.equalsIgnoreCase('yes')){ 
                            if(!keyToSumissionMap.containsKey(licenseSubmissionComboKey)){
                                MUSW__Submission__c newSubmission = new MUSW__Submission__c(Name=masterSubmission.Name,Description_Long__c=masterSubmission.Description_Long__c,
                                                                                            LicenseQuestionKey__c = licenseSubmissionComboKey,MUSW__Permit2__c = newLincenseRenewal.Id,
                                                                                            Type__c =(masterSubmission.Submission_Type__c =='Hardcopy: To be Mailed'? 'Hardcopy: To be Mailed' : 'Softcopy: To be Uploaded'),
                                                                                            Master_Submission_List__c=masterSubmission.Id,MUSW__Required__c=masterSubmission.Default__c,
                                                                                            Document_API_Name__c = masterSubmission.Document_API_Name__c, License_Renewal__c = newLincenseRenewal.Id,
                                                                                            MUSW__BG_File_Location_Type__c = masterSubmission.BG_File_Location_Type__c);
                                
                                if(newSubmission.MUSW__BG_File_Location_Type__c == null || newSubmission.MUSW__BG_File_Location_Type__c == '') newSubmission.MUSW__BG_File_Location_Type__c = 'Salesforce';
                                submissionUpsertList.add(newSubmission);
                            }
                        }else if((questionAnswer == null || questionAnswer.equalsIgnoreCase('no')) && keyToSumissionMap.containsKey(licenseSubmissionComboKey)){
                            //If answer is 'No' and there is an existing submission, it is deleted
                            MUSW__Submission__c oldSubmission = keyToSumissionMap.get(licenseSubmissionComboKey);
                            submissionDeleteList.add(oldSubmission);
                        }
                    }
            	}
            }
        }
        
       try{
        	system.debug('submissionUpsertList>>'+submissionUpsertList);
            upsert submissionUpsertList LicenseQuestionKey__c;
            system.debug(submissionUpsertList );
            delete submissionDeleteList;
        }catch(Exception ex){
            System.debug(ex);
        }
	}
}