public class ReviewTriggerHandler implements BGCM.ITriggerHandler{
    public ReviewTriggerHandler() {
    }
    
    public void onAfterDelete() {}
    public void onAfterInsert() {
   
    	BluebeamReviewHelper();
    }
    public void onAfterUndelete() {}
    public void onAfterUpdate() { 
        aftermethod();
        BluebeamReviewHelper();
    }
    public void onBeforeDelete() {}
    public void onBeforeInsert() {
        createMilestoneRecords();
             checkForScheduler();
    }
    public void onBeforeUndelete() {}
    public void onBeforeUpdate() {
        beforemethod();
    }
    
    private void createMilestoneRecords(){
        List<MUSW__Milestone__c> lstNewMilestones = new List<MUSW__Milestone__c>();
        Map<Id,Id> mapPermitMilestone = new Map<Id,Id>();
        
        List<MUSW__Review__c> triggerNew = Trigger.New;
        for(MUSW__Review__c review: triggerNew) {
            if(review.MUSW__Permit2__c != null){
                MUSW__Milestone__c milestone = new MUSW__Milestone__c();
                milestone.MUSW__Permit2__c = review.MUSW__Permit2__c;
                milestone.MUSW__Original_Start_Date__c = Date.today();
                milestone.MUSW__Original_Due_Date__c = review.MUSW__Due_Date__c;
                
                lstNewMilestones.add(milestone);
            }
        }
        
        if(lstNewMilestones.size() > 0){
            insert lstNewMilestones;
            for(MUSW__Milestone__c milestone : lstNewMilestones){
                mapPermitMilestone.put(milestone.MUSW__Permit2__c, milestone.Id);
            }
            
            for(MUSW__Review__c review: triggerNew) {
                review.MUSW__Milestone__c = mapPermitMilestone.get(review.MUSW__Permit2__c);
            }
        }
    }
    
    public void aftermethod(){
        List<MUSW__Review__c> triggerNew = Trigger.New;
        System.debug('Entered after method');
        
        
        
        SET<Id> permitIds = new SET<Id> ();
        SET<Id> reviewIds = new SET<Id> ();
        for(MUSW__Review__c review: triggerNew) {
            if(review.MUSW__Permit2__c != null && review.MUSW__Status__c == 'Approved')
            {
                permitIds.add(review.MUSW__Permit2__c);
                reviewIds.add(review.Id);
            }
            /*if(review.MUSW__Permit2__c != null){
                ReviewCompletionTimeComputation rctc = new ReviewCompletionTimeComputation();
                Decimal reviewHours = rctc.ReviewCompletionTimeComputation(review.Id);
                if(reviewHours != -1){
                    System.debug('reviewhours '+reviewhours);
                    //review.Delete_Time_Taken__c = String.valueOf(reviewhours);
                    
                }
            }*/
        }
        if(permitIds.size()>0){
             System.debug('Entered if');
            //CreateInspectiononCompletingReview.insertInspections(permitIds, reviewIds);
            List<MUSW__Inspection__c> InspectionList = new List<MUSW__Inspection__c>();
            Map<Id,Musw__Permit2__c> permits = new  Map<Id,Musw__Permit2__c> ([Select id,Permit_Type__c, Program_Area__c, MHC_Application_Type__c,State_Owned_Facility__c from Musw__Permit2__c where id=:permitIds]);
            List<MUSW__Review__c> reviewList = [select id, Musw__Permit2__c, Name from MUSW__Review__c where id in :reviewIDs];
            for(MUSW__Review__c review: reviewList) {
                if(review.MUSW__Permit2__c != null && permits.containskey(review.MUSW__Permit2__c) ){
                    Musw__Permit2__c perm= permits.get(review.MUSW__Permit2__c);
                    MUSW__Inspection__c insp = new MUSW__Inspection__c();
                    insp.MUSW__Permit__c = review.MUSW__Permit2__c;
                    if(perm.Permit_Type__c == label.PT_Manufactured_Homes_Community_Permit){
                        insp.Checklist_Type__c = 'MHC Inspection checklist';
                        InspectionList.add(insp);
                    }
                    if(perm.Permit_Type__c == Label.PT_POWTS_State_Owned_Privy_Registration || perm.Permit_Type__c == 'POWTS Soil Saturation Determination' || perm.Permit_Type__c == 'POWTS Sanitary Permit' || perm.State_Owned_Facility__c == True){
                        insp.Checklist_Type__c ='POWTS INSPECTION REPORT';
                        InspectionList.add(insp);
                    }
                    
                }
                
            }
            if(InspectionList.size()>0)
                insert InspectionList;
            
          /*  Set<String> setChecklistTypes = new Set<String>();
            Set<String> permitTypes = new Set<String>();
            for(MUSW__Inspection__c ins : InspectionList){
                setChecklistTypes.add(ins.Checklist_Type__c);
                MUSW__Permit2__c permit = permits.get(ins.MUSW__Permit__c);
                if(permit != null){
                    permitTypes.add(permit.Program_Area__c); //Changed to Program Area instead of Permit type because For all POWTS, there is one common Inspection checklist
                }
            }
            
            if(setChecklistTypes.size() > 0 && permitTypes.size() > 0){
                Map<String, List<BGCK__Page_Question__c>> mapPermitTypePageQuestion = new Map<String, List<BGCK__Page_Question__c>>();
                for(BGCK__Page_Question__c pageQuestion : [Select Id, BGCK__BG_Checklist_Name__c, BGCK__Checklist_Version_Status__c, Permit_Type_or_Credential_Type__c, Checklist_type__c
                                                                    From BGCK__Page_Question__c where BGCK__Checklist_Version_Status__c = 'Active' and BGCK__BG_Checklist_Name__c != '' and
                                                                    Permit_Type_or_Credential_Type__c IN :permitTypes and Checklist_type__c IN :setChecklistTypes]){
                                                                    
                    List<BGCK__Page_Question__c> lstPageQuestions = mapPermitTypePageQuestion.get(pageQuestion.Permit_Type_or_Credential_Type__c);
                    if(lstPageQuestions == null){
                        lstPageQuestions = new List<BGCK__Page_Question__c>();
                    }
                    lstPageQuestions.add(pageQuestion);
                    mapPermitTypePageQuestion.put(pageQuestion.Permit_Type_or_Credential_Type__c, lstPageQuestions);
                }
                
                List<BGCK__Answer__c> answersToInsert = new List<BGCK__Answer__c>();
                for(MUSW__Inspection__c ins : InspectionList){
                    Musw__Permit2__c permit = permits.get(ins.MUSW__Permit__c);
                    List<BGCK__Page_Question__c> lstPageQuestions = mapPermitTypePageQuestion.get(permit.Program_Area__c);
                    if(lstPageQuestions != null){
                        for(BGCK__Page_Question__c pageQuestion : lstPageQuestions){
                            BGCK__Answer__c answer = new BGCK__Answer__c();
                            answer.Inspection__c = ins.Id;
                            answer.BGCK__Page_Question__c = pageQuestion.Id;
                            answer.Name = 'Not Answered Yet';
                            
                            answersToInsert.add(answer);
                        }
                    }
                }
                
                if(answersToInsert.size() > 0){
                    insert answersToInsert;
                }
            }*/
        }
    }
    
    public void beforemethod(){
        
        List<MUSW__Review__c> triggerNew = Trigger.New;
        
        for(MUSW__Review__c review: triggerNew) {
            if(review.MUSW__Permit2__c != null){
                 
                if((review.Application_Type__c == 'Plan Review' || review.Application_Type__c == 'Manufactured Homes Communities') && 
                   review.Start_Date__c != null && review.MUSW__Completed_DateTime__c != null){
                    ReviewCompletionTimeComputation rctc = new ReviewCompletionTimeComputation();
                Decimal reviewHours = rctc.ReviewCompletionTimeComputation(review);
                if(reviewHours != -1){
                    System.debug('reviewhours '+reviewhours);
                    review.Actual_Completion_Time_Hours__c = String.valueOf(reviewhours);
                    
                }
                }
                
            }
        }
        
        /*List<MUSW__Review__c> triggerNew = Trigger.New;
        System.debug('Entered after method');
        Set<ID> reviewIdsSet = new Set<ID>();
        for(MUSW__Review__c reviews: triggerNew) {
            if(reviews.MUSW__Permit2__c != null)
            {
                reviewIdsSet.add(reviews.Id);
            }
        }
        Map<Id, MUSW__Review__c> reviewMap = new Map<Id, MUSW__Review__c>([SELECT Id, Start_Date__c, MUSW__Completed_DateTime__c, MUSW__permit2__r.application_Type__c 
                                                                                  FROM MUSW__Review__c 
                                                                                  WHERE ID in :reviewIdsSet]);
        
        
        //SET<Id> permitIds = new SET<Id> ();
        //SET<Id> reviewIds = new SET<Id> ();
        for(MUSW__Review__c review: triggerNew) {
            if(review.MUSW__Permit2__c != null){
                MUSW__Review__c reviewRecord = reviewMap.get(review.Id);
                String applicationType = reviewRecord.MUSW__Permit2__r.Application_Type__c;
                
                if((applicationType == 'Plan Review' || applicationType == 'Manufactured Homes Communities') && 
                   reviewRecord.Start_Date__c != null && reviewRecord.MUSW__Completed_DateTime__c != null){
                    ReviewCompletionTimeComputation rctc = new ReviewCompletionTimeComputation();
                Decimal reviewHours = rctc.ReviewCompletionTimeComputation(triggerNew);
                if(reviewHours != -1){
                    System.debug('reviewhours '+reviewhours);
                    review.Actual_Completion_Time_Hours__c = String.valueOf(reviewhours);
                    
                }
                }
                
            }
        }*/
        
    }
    
    public  void checkForScheduler()
    {
        Map<Id,MUSW__Review__c> PermIdtoRev = new   Map<Id,MUSW__Review__c>();
         Map<Id,Request__c> permIdtoReq = new   Map<Id,Request__c>();
        System.debug('checkForScheduler');
               List<MUSW__Review__c> triggerNew = Trigger.New;
        for(MUSW__Review__c revSch : triggerNew)
        {
            if(revSch.MUSW__Status__c==Label.ST_Pending&&revSch.MUSW__Permit2__c!=null){
                PermIdtoRev.put( revSch.MUSW__Permit2__c,revSch);
            }
        }

        for(Request__c req :[Select Id,Assigned_Resource_User_Id__c,Permit_Plan_Review__c  from Request__c where status__c=:Label.St_Scheduled and Permit_Plan_Review__c =:PermIdtoRev.Keyset()])
        {
            permIdtoReq.put(req.Permit_Plan_Review__c,req);
         }
        
        for(Id permId : permIdtoReq.keyset())
        {
            Request__c req= permIdtoReq.get(permId);
            MUSW__Review__c review =PermIdtoRev.get(permId);
            review.OwnerId=req.Assigned_Resource_User_Id__c;
        }
    }
    /**
	* launches a method to add the milestone owner to the parent
	* Bluebeam projectId
	*/
	private void BluebeamReviewHelper() {
		if(!Test.isRunningTest()) {
			if(Trigger.isInsert || Trigger.isUpdate && Trigger.isAfter) {
				// examine each object and fetch data...
				Set<Id> ownerIds = new Set<Id>();
				Set<Id> reviewIds = new Set<id>();
				// milestone Id : user Id
				Map<Id, Id> ms_review_ownerMap = new Map<Id, Id>();
				// get the parent Ids, use metadata...
				String objectLabel = BGCM.UtilitySObject.getObjectNameFromId(Trigger.New[0].Id);
				String parentAPILookupField;
				String parentAPIObject;
				MUSW__Bluebeam_Relationship_Setting__mdt[] parentMapMdts = getRelationshipMetadata(objectLabel, 'Review');
				// find the relationship field use first found value...
				for(MUSW__Bluebeam_Relationship_Setting__mdt parentMapMdt : parentMapMdts) {
					if(Trigger.New[0].get(parentMapMdt.MUSW__Parent_Lookup_API_Name__c) != null) {
						parentAPILookupField = (String)parentMapMdt.MUSW__Parent_Lookup_API_Name__c;
						parentAPIObject = (String)parentMapMdt.MUSW__Parent_Object_API_Name__c;
					}
				}
				// get the project id and current owner email address then call
				for (SObject record: Trigger.New){
                    if(record.get('MUSW__Permit2__c') != null && parentAPILookupField != null && record.get(parentAPILookupField) != null && record.get('OwnerId') != null){
                        reviewIds.add(record.Id);
                        ownerIds.add((Id)record.get('OwnerId'));
                        ms_review_ownerMap.put((Id)record.get(parentAPILookupField), (Id)record.get('OwnerId'));
                    }
				}
				// get the Bluebeam User Emails...
				Map<Id, String> emailMap = new Map<Id, String>();
				if (ownerIds.size() > 0){
					Map<Id, User> usersMap = new Map<Id, User>([SELECT MUSW__BG_BlueBeam_Email_Address__c FROM User WHERE Id=:ownerIds]);
					for (Id userId : usersMap.keySet()){
						User u = usersMap.get(userId);
					    if (String.isNotBlank((String)u.MUSW__BG_BlueBeam_Email_Address__c)){
							emailMap.put(userId, u.MUSW__BG_BlueBeam_Email_Address__c);
						}
					}
				}
				Map<String, List<String>> projectEmailMap = new Map<String, List<String>>();
				for (Id parentId : ms_review_ownerMap.keyset()){
					String projectId = getProjectIdfromSessionRecord(parentId);
					if (String.isNotBlank(projectId)){
						String userEmail = (String)emailMap.get(ms_review_ownerMap.get(parentId));
						if (String.isNotBlank(userEmail)){
							MUSW.BluebeamProjectService.addBluebeamuser(projectId, userEmail);
						}
					}
				}
			}
		}
	}
	/**
	******************************************************************
	* Helpers to get metadata relationships...
	******************************************************************
	*/
	/**
	* Get bluebeam parent-child metadata
	* @param String child object label
	* @param String bluebeam api type
	* @return MUSW__Bluebeam_Relationship_Setting__mdt bluebeam parent-child metadata
	*/
	private MUSW__Bluebeam_Relationship_Setting__mdt[] getRelationshipMetadata(String childObjectLabel, String apiType) {
		if(String.isBlank(childObjectLabel) || String.isBlank(apiType)) {
			return null;
		}
		MUSW__Bluebeam_Relationship_Setting__mdt[] parentMapMdts = new List<MUSW__Bluebeam_Relationship_Setting__mdt>();
		String queryFields = BGCM.UtilitySObject.getFieldsFor_Str('MUSW__Bluebeam_Relationship_Setting__mdt', false);
		String queryString = 'SELECT ' + queryFields + ' FROM MUSW__Bluebeam_Relationship_Setting__mdt WHERE MUSW__Child_Object_API_Name__c=\''+childObjectLabel+'\' AND MUSW__Type__c=\''+apiType+'\'';
		parentMapMdts = Database.query( queryString );
		if(parentMapMdts.size() > 0) {
			return parentMapMdts;
		} else {
			return null;
		}
	}
	/**
	* Get bluebeam project metadata
	* @param String object label
	* @return MUSW__BlueBleam_Project_Setting__mdt bluebeam project metadata
	*/
	private MUSW__BlueBleam_Project_Setting__mdt getProjectMetadata(String objectLabel) {
		if(String.isBlank(objectLabel)) {
			return null;
		}
		MUSW__BlueBleam_Project_Setting__mdt[] projectMdts = new List<MUSW__BlueBleam_Project_Setting__mdt>();
		String queryFields = BGCM.UtilitySObject.getFieldsFor_Str('MUSW__BlueBleam_Project_Setting__mdt', false);
		String queryString = 'SELECT ' + queryFields + ' FROM MUSW__BlueBleam_Project_Setting__mdt WHERE MUSW__Object_API_Name__c =\''+objectLabel+'\' LIMIT 1';
		projectMdts = Database.query( queryString );
		if(projectMdts.size() > 0) {
			return projectMdts[0];
		} else {
			return null;
		}
	}
	/**
	* Retrieve project Id from session record's parent
	*
	* @param String record Id
	* @return String bluebeam project Id from parent record
	*/
	private String getProjectIdfromSessionRecord(String recordId) {
		if(String.isBlank(recordId)) {
			return null;
		}
		String objectLabel = BGCM.UtilitySObject.getObjectNameFromId(recordId);
		//get parent-child metadata for session record
		MUSW__Bluebeam_Relationship_Setting__mdt[] parentMapMdts = getRelationshipMetadata(objectLabel, 'Session');
		if(parentMapMdts == null) {
		    throw new BGCM.BGException('There is no Bluebeam Parent Map Settingss for object type: '+objectLabel+'.');
		}
		List<String> parentLookupAPIFields = new List<String>();
		if(parentMapMdts.size() > 0) {
			for(MUSW__Bluebeam_Relationship_Setting__mdt parentMapMdt : parentMapMdts) {
				parentLookupAPIFields.add(parentMapMdt.MUSW__Parent_Lookup_API_Name__c);
			}
		}
		String sessionRecordQuery = 'SELECT '+String.join(parentLookupAPIFields, ',')+' FROM '+objectLabel+' WHERE Id=\''+recordId+'\'';
		SObject[] sessionRecords = Database.query( sessionRecordQuery );
		if(sessionRecords.size() > 0) {
			String parentAPILookupField;
			String parentAPIObject;
			for(MUSW__Bluebeam_Relationship_Setting__mdt parentMapMdt : parentMapMdts) {
				if(sessionRecords[0].get(parentMapMdt.MUSW__Parent_Lookup_API_Name__c) != null) {
					parentAPILookupField = (String)parentMapMdt.MUSW__Parent_Lookup_API_Name__c;
					parentAPIObject = (String)parentMapMdt.MUSW__Parent_Object_API_Name__c;
				}
			}
			//get project metadata
			MUSW__BlueBleam_Project_Setting__mdt projectMdt = getProjectMetadata(parentAPIObject);
			if(projectMdt == null) {
				throw new BGCM.BGException('There is no Bluebeam Projects Settingss for object type: '+parentAPIObject+'.');
			}
			String projectRecordQuery = 'SELECT '+projectMdt.MUSW__BlueBeam_Project_Id_API_Name__c+' FROM '+parentAPIObject+' WHERE Id=\''+sessionRecords[0].get(parentAPILookupField)+'\' LIMIT 1';
			SObject[] projectRecords = Database.query( projectRecordQuery );
			if(projectRecords.size() > 0) {
				return (String)projectRecords[0].get(projectMdt.MUSW__BlueBeam_Project_Id_API_Name__c);
			} else {
				return null;
			}
	    }
		else {
			return null;
		}
	}
}