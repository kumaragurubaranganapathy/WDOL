public class CreateInspectiononCompletingReview {
    
    public CreateInspectiononCompletingReview(){
        
    }
    
    @Future
    Public static void insertInspections(SET<Id> permitIds, SET<ID> reviewIDs){
        try{
            List<MUSW__Inspection__c> InspectionList = new List<MUSW__Inspection__c>();
            Map<Id,Musw__Permit2__c> permits = new  Map<Id,Musw__Permit2__c> ([Select id,Permit_Type__c, MHC_Application_Type__c from Musw__Permit2__c where id=:permitIds]);
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
                    if(perm.Permit_Type__c == Label.PT_POWTS_State_Owned_Privy_Registration || perm.Permit_Type__c == 'POWTS Soil Saturation Determination'){
                        insp.Checklist_Type__c ='POWTS INSPECTION REPORT';
                        InspectionList.add(insp);
                    }
                    
                }
                
            }
            if(InspectionList.size()>0)
                insert InspectionList;
            
            Set<String> setChecklistTypes = new Set<String>();
            Set<String> permitTypes = new Set<String>();
            for(MUSW__Inspection__c ins : InspectionList){
                setChecklistTypes.add(ins.Checklist_Type__c);
                MUSW__Permit2__c permit = permits.get(ins.MUSW__Permit__c);
                if(permit != null){
                    permitTypes.add(permit.Permit_Type__c);
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
                    List<BGCK__Page_Question__c> lstPageQuestions = mapPermitTypePageQuestion.get(permit.Permit_Type__c);
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
            }
        }catch(Exception e){
            System.debug('Exception occured>>>>' +e);
        }
        
    }
    
}