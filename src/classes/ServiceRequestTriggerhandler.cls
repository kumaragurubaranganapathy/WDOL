/*************************************************************************************************************
** User Story: N/A
**************************************************************************************************************
** Class Name    : ServiceRequestTriggerhandler
** Description   : Consolidated Trigger Handler for ServiceRequest Object.
** Version       : 1.0
** Built By      : 
**------------------------------------------------------------------------------------------------------------
** Modification Log:
**------------------
** Developer                         Date                    Version                      Description
**------------------------------------------------------------------------------------------------------------
** Review Log:
**---------------
** Reviewer                  Date           Version               Description
**------------------------------------------------------------------------------------------------------------
**
**  **********************************************************************************************************/

public class ServiceRequestTriggerhandler implements BGCM.ITriggerHandler {
    public static user u;

    public ServiceRequestTriggerhandler(){
        u = [Select Id, UserType, Is_Portal_User__c From User where Id = :UserInfo.getUserId()];
    }
    
    public void onBeforeDelete(){}
    public void onBeforeInsert(){
    	processPortalValidations();
    }
    public void onBeforeUndelete(){}
    public void onBeforeUpdate(){
        processPortalValidations();
        beforeMethod();
    }
    public void onAfterDelete(){}
    public void onAfterInsert(){
    	afterMethod();
    }
    public void onAfterUndelete(){}
    public void onAfterUpdate(){
    	afterMethod();
    }
    
    private void processPortalValidations(){
    	if (u.Is_Portal_User__c == true) {
            //This method is for base validation on service request details provided by the Applicant
            BaseValidator v = new BaseValidator();
            for( SObject sObj : Trigger.new ) {
                v.validateServiceRequest(BaseValidator.ApplicationObjectType.ServiceRequest,  sObj);
            }
        }
    }
    
    private void afterMethod(){
    	Map<Id, MUSW__Application2__c> srsInPendingStatusMap = new Map<Id, MUSW__Application2__c>();
        Set<String> srInPendingStatusSet = new Set<String>();
        String permitTypesList = '';
        
        //This Method is called when already an AccountContact Record exists on an Account and serviceRequest records get Created. This Record will be shared with the community Plus User
        ServiceRequestUsersharing controller = new ServiceRequestUsersharing();
        controller.ServiceRequest_RecordInsert(Trigger.New);
        
        //Share the Service Request records when the Delegated Admin is the applicant on the License  
        ServiceRequestCreatedByDelegate delegateController = new ServiceRequestCreatedByDelegate();
        delegateController.shareServiceRequestRecords(Trigger.New);
        
        System.debug('trigger size'+trigger.New.size());
        for(Integer i = 0; i < trigger.New.size(); i++) {
            System.debug('in for loop');
            MUSW__Application2__c srNew = (MUSW__Application2__c) trigger.New[i];
            //get the license id to update submission list             
            System.debug('license status '+ srNew.MUSW__Status__c);
            if(srNew.MUSW__Status__c == '' || srNew.MUSW__Status__c == 'Pending') {
                System.debug('license status is pending or blank');
                
				 //If the license is in pending status- add it to the map
				 
                srsInPendingStatusMap.put(srNew.Id, srNew);
                
                 /* If the license is in pending status- add the license type to the set to avoid 
				  * duplciation/repetition of the same license type */
                 
                //licenseTypesInPendingStatusSet.add(srNew.Credential_Type__c);
                
                if(srNew.Credential__c != null && srNew.Credential__c != ''){
                    srInPendingStatusSet.add(srNew.Credential__c);
                }else if(srNew.Permit_Type__c != null && srNew.Permit_Type__c != ''){
                    permitTypesList = permitTypesList + ',\'' + srNew.Permit_Type__c + '\'';
                }
            }
            
        }
        
        if(srsInPendingStatusMap.size() > 0) {
            System.debug('in if size > 0 ');
            //Creating a map of license type and corresponding submission list.
        
        permitTypesList = permitTypesList.removeStart(',');
        if(permitTypesList == '') permitTypesList = '\'dummy_value\'';
        Map<String, List<MUSW__Master_Submission_List__c>> srTypesSubmissionListMap = new Map<String, List<MUSW__Master_Submission_List__c>>();
        String query = 'SELECT Id, External_id__c, Name, Background_Question_Field_API_Name__c,' +
                                                  ' Description_Long__c, Application_Type__c, Credential_Type__c, Credential__c, Default__c, Show_For__c,' +
                                                  ' Submission_Type__c, Document_API_Name__c, Service_Request_Type__c, BG_File_Location_Type__c, Permit_Type__c' +
                                                  ' FROM MUSW__Master_Submission_List__c ' +
                                                  ' WHERE Active__c = TRUE ' +
                                                  ' AND Object__c = \'' + label.API_Service_Request + '\'' +
                                                  ' AND Show_For__c includes (\'Service Request\') ' +
                                                  ' AND (Credential__c IN :srInPendingStatusSet OR Permit_Type__c includes (' + permitTypesList + '))' +
                                                  ' LIMIT 5000';
            
        for(MUSW__Master_Submission_List__c masterSubmission: Database.query(query)) {
			System.debug('in second for loop ');     			                                                
            
            if(masterSubmission.Credential__c != null && masterSubmission.Credential__c != ''){
                List<MUSW__Master_Submission_List__c> tempSubmissionList = new List<MUSW__Master_Submission_List__c> ();
                /* if license type already exists in the map, then fetch the list of submission list
				* records associated with that license type*/
                if(srTypesSubmissionListMap.containsKey(masterSubmission.Credential__c)) {
                    tempSubmissionList = srTypesSubmissionListMap.get(masterSubmission.Credential__c);
                }
                /*1. adding submission list for the license type in a list                                                      
                * 2. If the above 'if condition' was executed, then the new submission list record would be added to the
                * existing list */
                tempSubmissionList.add(masterSubmission);
                //adding license type and corresponding list in a map
                srTypesSubmissionListMap.put(masterSubmission.Credential__c, tempSubmissionList);
            }else if(masterSubmission.Permit_Type__c != null && masterSubmission.Permit_Type__c != ''){
                List<MUSW__Master_Submission_List__c> tempSubmissionList = new List<MUSW__Master_Submission_List__c> ();
                /* if license type already exists in the map, then fetch the list of submission list
				* records associated with that license type*/
                if(srTypesSubmissionListMap.containsKey(masterSubmission.Permit_Type__c)) {
                    tempSubmissionList = srTypesSubmissionListMap.get(masterSubmission.Permit_Type__c);
                }
                /*1. adding submission list for the license type in a list                                                      
                * 2. If the above 'if condition' was executed, then the new submission list record would be added to the
                * existing list */
                tempSubmissionList.add(masterSubmission);
                //adding license type and corresponding list in a map
                srTypesSubmissionListMap.put(masterSubmission.Permit_Type__c, tempSubmissionList);
            }
        }

        Set<String> srFieldSet = Schema.SObjectType.MUSW__Application2__c.fields.getMap().keyset();

        List<MUSW__Submission__c> submissionUpsertList = new List<MUSW__Submission__c>();
        List<MUSW__Submission__c> submissionDeleteList = new List<MUSW__Submission__c>();
        // Querying existing submissions under license records and iterating over it to create new submissions
         
        for(MUSW__Application2__c serviceRequest:[Select id, MUSW__Type__c, (Select Id, Name, LicenseQuestionKey__c FROM MUSW__Submissions__r) FROM MUSW__Application2__c WHERE Id = :srsInPendingStatusMap.keyset()]){

            // Getting new license instance from Trigger.newMap
            
            MUSW__Application2__c newSR = srsInPendingStatusMap.get(serviceRequest.Id);

            //Creating a map of existing submission records
            
            Map<String,MUSW__Submission__c> keyToSubmissionMap = new Map<String, MUSW__Submission__c>();
            for(MUSW__Submission__c submission: serviceRequest.MUSW__Submissions__r) {
                if(submission.LicenseQuestionKey__c != null){
                    keyToSubmissionMap.put(submission.LicenseQuestionKey__c, submission);
                }
            }
            
            // Creating submissions based on License Type
            List<MUSW__Master_Submission_List__c> masterSubmissionList = null;
            if(newSR.Credential__c != null && newSR.Credential__c != ''){
            	masterSubmissionList = srTypesSubmissionListMap.get(newSR.Credential__c);
            }else if(newSR.Permit_Type__c != null && newSR.Permit_Type__c != ''){
                masterSubmissionList = srTypesSubmissionListMap.get(newSR.Permit_Type__c);
            }
            if(masterSubmissionList != null && masterSubmissionList.size() > 0) {
                for(MUSW__Master_Submission_List__c masterSubmission : masterSubmissionList) {
                	if(serviceRequest.MUSW__Type__c == masterSubmission.Service_Request_Type__c){
	                    String srSubmissionComboKey = String.valueOf(newSR.Id) + String.valueOf(masterSubmission.External_Id__c);
	                    // If question is background question type, submission is created based on answer
	                     
	                    if(masterSubmission.Background_Question_Field_API_Name__c != null && srFieldSet.contains(masterSubmission.Background_Question_Field_API_Name__c.toLowerCase())) {
	                        String questionAnswer;
	                        questionAnswer= (String)newSR.get(masterSubmission.Background_Question_Field_API_Name__c);
	                        
	                       // If answer is 'Yes' new submission is created
	                        
	                        if(questionAnswer!= null && questionAnswer.equalsIgnoreCase('Yes')) { 
	                            if(!keyToSubmissionMap.containsKey(srSubmissionComboKey)) {
	                                MUSW__Submission__c newSubmission = new MUSW__Submission__c(Name = masterSubmission.Name, Description_Long__c = masterSubmission.Description_Long__c,
	                                                                                            LicenseQuestionKey__c = srSubmissionComboKey, MUSW__Application2__c = newSR.Id, Application_Type__c = masterSubmission.Application_Type__c,
	                                                                                            Type__c = (masterSubmission.Submission_Type__c == 'Hardcopy: To be Mailed' ? 'Hardcopy' : 'Softcopy'),
	                                                                                            Extid_from_Submission_List__c = masterSubmission.External_Id__c, Document_API_Name__c = masterSubmission.Document_API_Name__c,
	                                                                                            MUSW__BG_File_Location_Type__c = masterSubmission.BG_File_Location_Type__c);
	                                
	                                if(newSubmission.MUSW__BG_File_Location_Type__c == null || newSubmission.MUSW__BG_File_Location_Type__c == '') newSubmission.MUSW__BG_File_Location_Type__c = 'Salesforce';
	                                submissionUpsertList.add(newSubmission);
	                            }
	                        }else if((questionAnswer == null || questionAnswer.equalsIgnoreCase('No')) && keyToSubmissionMap.containsKey(srSubmissionComboKey)) {
	                           //If answer is 'No' and there is an existing submission, it is deleted
	                             
	                            MUSW__Submission__c oldSubmission = keyToSubmissionMap.get(srSubmissionComboKey);
	                            submissionDeleteList.add(oldSubmission);
	                        }
	                    }
	                    else if(masterSubmission.Default__c) {
	                        // If submisison list is not of question type, corresponding submission is created
	                        
	                        if(!keyToSubmissionMap.containsKey(srSubmissionComboKey)) {
	                            if(masterSubmission.Show_For__c != null && masterSubmission.Show_For__c.containsIgnoreCase('Service Request')) {
	                                MUSW__Submission__c newSubmission = new MUSW__Submission__c(Name = masterSubmission.Name, Description_Long__c = masterSubmission.Description_Long__c,
	                                                                                        LicenseQuestionKey__c = srSubmissionComboKey, MUSW__Application2__c = newSR.Id, Application_Type__c = masterSubmission.Application_Type__c,
	                                                                                        Type__c = (masterSubmission.Submission_Type__c =='Hardcopy: To be Mailed' ? 'Hardcopy: To be Mailed' : 'Softcopy: To be Uploaded'),
	                                                                                        MUSW__Required__c = masterSubmission.Default__c, Extid_from_Submission_List__c = masterSubmission.External_Id__c,
	                                                                                        Document_API_Name__c = masterSubmission.Document_API_Name__c, MUSW__BG_File_Location_Type__c = masterSubmission.BG_File_Location_Type__c);
	                                
	                                if(newSubmission.MUSW__BG_File_Location_Type__c == null || newSubmission.MUSW__BG_File_Location_Type__c == '') newSubmission.MUSW__BG_File_Location_Type__c = 'Salesforce';
	                                submissionUpsertList.add(newSubmission);
	                            }
	                            
	                        }
	                    }
	                }
                }
            }
        }
            
            upsert submissionUpsertList LicenseQuestionKey__c;
            if(Schema.sObjectType.MUSW__Submission__c.isDeletable()) {
                delete submissionDeleteList;
            }
            
        }
    }
    
    public void beforeMethod(){
        
        // If Request for deletion is checked capture the Date which is used for reporting
        list<MUSW__Application2__c> triggerNew = trigger.new;
        for(MUSW__Application2__c SR : triggerNew){
            MUSW__Application2__c srOld = null;
            if(trigger.Old != null){
                srOld = (MUSW__Application2__c)trigger.OldMap.get(SR.Id);
            }
            
            if (srOld != null && srOld.MUSW__Status__c != SR.MUSW__Status__c && SR.MUSW__Status__c == label.ST_Generate_Fee) {
                SR.Attestation_Date__c   = system.today();
            }
        }
        Map<Id, Decimal> MapSRTotalFee = new Map<Id, Decimal>();
        if (trigger.isUpdate) {
            for (AggregateResult ar : [Select MUSW__Application2__c, SUM(MUSW__Amount__c) amt, SUM(MUSW__Amount_Waived__c) wamt From MUSW__Fee__c where MUSW__Application2__c IN :trigger.New group by MUSW__Application2__c]) {
                Decimal feeAmt = (Decimal) ar.get('amt');
                Decimal feeWaivedAmt = (Decimal) ar.get('wamt');
                if (feeAmt == null) feeAmt = 0;
                if (feeWaivedAmt == null) feeWaivedAmt = 0;
                MapSRTotalFee.put((Id) ar.get('MUSW__Application2__c'), feeAmt - feeWaivedAmt);
            }
            for(sObject sObj : trigger.New){
                MUSW__Application2__c sRequest = (MUSW__Application2__c) sObj;
                MUSW__Application2__c sRequestOld = null;
                if(trigger.Old != null){
                    sRequestOld = (MUSW__Application2__c)trigger.OldMap.get(sRequest.Id);
                }
                if(sRequest.MUSW__Total_Fees__c > 0 && sRequest.MUSW__Total_Balance__c == 0 && (sRequestOld == null || sRequestOld.MUSW__Total_Balance__c > 0)){
                    sRequest.MUSW__Status__c = 'Submitted';
                }
                
                Decimal feeAmt = MapSRTotalFee.get(sRequest.Id);
                if (sRequest.Id != null && feeAmt != null && sRequest.MUSW__Total_Fees__c != feeAmt) {
                    sRequest.MUSW__Total_Fees__c = feeAmt;
                    
                }
            } 
        }
    }
}