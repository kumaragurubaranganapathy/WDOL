public class InspectionTriggerHandler implements BGCM.ITriggerHandler{
    
    public InspectionTriggerHandler() {
    }
    public void onAfterDelete() {}
    public void onAfterInsert() {
        //  afterMethod();
          afterMethod1();
    }
    public void onAfterUndelete() {}
    public void onAfterUpdate() {   
        //  afterMethod();
    }
    public void onBeforeDelete() {}
    public void onBeforeInsert() {
        beforeMethod();
        beforeMethod2();
    }
    
    public void beforeMethod(){
        List<MUSW__Inspection__c> triggerNew = Trigger.New;
        
        List<Id> permitIds = new List<Id> ();
        for(MUSW__Inspection__c inspection: triggerNew) {
            if(inspection.MUSW__Permit__c!=null)
            {
                System.debug('Inspection' +inspection);
                permitIds.add(inspection.MUSW__Permit__c);
            }
        }
        Map<Id,Musw__Permit2__c> permits = new  Map<Id,Musw__Permit2__c> ([Select id,Permit_Type__c,MHC_Application_Type__c, Community_Owner__c,Community_Address__c,Community_Name__c,Community_ID_Number__c,Number_of_Sites__c,State_Owned_Facility__c from Musw__Permit2__c where id=:permitIds]);
        
        for(MUSW__Inspection__c inspection: triggerNew) {
            System.debug('Reached here');
            //&& inspection.MUSW__Permit__r.Permit_Type__c == 'Manufactured Homes Community Permit'
            if(inspection.MUSW__Permit__c != null&&permits.containskey(inspection.MUSW__Permit__c) ){
                Musw__Permit2__c perm= permits.get(inspection.MUSW__Permit__c);
                System.debug('perm>>>' +perm);
                System.debug('Reached here as well');
                if(perm.Permit_Type__c == 'Manufactured Homes Community Permit'){
                    inspection.Community_ID_No__c = perm.Community_ID_Number__c;
                    inspection.Number_of_Sites__c =perm.Number_of_Sites__c;
                    inspection.Community_Name__c = perm.Community_Name__c;
                    inspection.Community_Address__c =perm.Community_Address__c;
                    inspection.Community_Owner__c = perm.Community_Owner__c; 
                    inspection.MUSW__Type__c = perm.MHC_Application_Type__c;
                } if(perm.Permit_Type__c == 'POWTS State-Owned Privy Registration' || perm.Permit_Type__c == 'POWTS Soil Saturation Determination' || perm.Permit_Type__c == 'POWTS Sanitary Permit' || perm.State_Owned_Facility__c == True){
                    inspection.MUSW__Type__c = 'POWTS INSPECTION REPORT';
                }
            }
        }
    }
    public void onBeforeUndelete() {}
    public void onBeforeUpdate() {
        beforeMethod();
        beforeMethod2();
    }
    
    public void beforeMethod2(){
        List<MUSW__Inspection__c> triggerNew = Trigger.New;
        
        /* Populate follow up date when a Inspection Start date and violation is selected */
        if(Trigger.NewMap != null){
            Map<Id, Decimal> days = followupDate((Map<Id, MUSW__Inspection__c>) Trigger.NewMap);
            BusinessHours bh = [SELECT Id, name FROM BusinessHours WHERE Name = 'Wisconsin Business Hours'];
            for(MUSW__Inspection__c inspection: triggerNew) {
                Decimal nextInspection = days.get(inspection.Id);
                inspection.Days_to_Next_Inspection__c = nextInspection;
                if(inspection.Inspection_Start_Date__c != null && nextInspection != null){
                    system.debug('Math roundoff>>>'+Math.roundToLong(nextInspection * 86400000));
                    system.debug('Inspection_Start_Date__c>>>>'+inspection.Inspection_Start_Date__c);
                    inspection.Inspection_Followup_Date__c = BusinessHours.addGmt(bh.id, inspection.Inspection_Start_Date__c, Math.roundToLong(nextInspection * 28800000));
                    system.debug('Inspection_Followup_Date__c>>>'+inspection.Inspection_Followup_Date__c);
                }
            }
        }
    }
    
    public Map<Id, Decimal> followupDate(Map<Id, MUSW__Inspection__c> NewMapValues){
        Map<Id, Decimal> finalInspectionMap = new Map<Id, Decimal>();
        Map<Id, String> inspectionIds = new Map<Id, String>();
        Set<string> currentViolations = new Set<String>();
        system.debug('NewMapValues Size>>>>'+NewMapValues.size());
        if(NewMapValues.size() > 0){
            for(MUSW__Inspection__c inspection : NewMapValues.values()){
                inspectionIds.put(inspection.Id, inspection.Current_Violations__c);
                system.debug('inspectionIds'+inspectionIds);
                if(inspection.Current_Violations__c != null){
                    if(inspection.Current_Violations__c.contains(',')){
                        system.debug('Entered Loop');
                        string[] cvString = inspection.Current_Violations__c.split(',');
                        for(string str: cvString){
                            str = str.trim();
                            currentViolations.add(str);
                        }
                    } else {
                        currentViolations.add(inspection.Current_Violations__c);
                    }
                }
            }
        }
        if(currentViolations.size() > 0){
            List<MUSW__Violation_Type__c> standardTextList = new List<MUSW__Violation_Type__c>([Select Id, name, MUSW__First_Reinspection__c
                                                                                                from MUSW__Violation_Type__c
                                                                                                where name =: currentViolations
                                                                                                ORDER BY MUSW__First_Reinspection__c
                                                                                                ASC NULLS LAST]);
            
            
            for(Id inspId : inspectionIds.keySet()){
                Decimal reinspection = 0;
                string[] cvString = inspectionIds.get(inspId).split(',');
                for(string str: cvString){
                    str = str.trim();
                    for(MUSW__Violation_Type__c st : standardTextList){
                        if(str == st.name){
                            if(st.MUSW__First_Reinspection__c > reinspection){
                                finalInspectionMap.put(inspId, st.MUSW__First_Reinspection__c);
                                reinspection = st.MUSW__First_Reinspection__c;
                            }
                        }
                    }
                }
            }
        }
        System.debug('finalInspectionMap>>>>>'+finalInspectionMap);
        return finalInspectionMap;
    }
    
    public void aftermethod1(){
        List<MUSW__Inspection__c> inspectionList = trigger.new;
        SET<Id> permitIds = new SET<Id> ();
        for(MUSW__Inspection__c inspection: inspectionList) {
            if(inspection.MUSW__Permit__c != null )
            {
                permitIds.add(inspection.MUSW__Permit__c);
            }
        }
        
        if(permitIds.size()>0){
            Map<Id,Musw__Permit2__c> permits = new  Map<Id,Musw__Permit2__c> ([Select id,Permit_Type__c, Program_Area__c, MHC_Application_Type__c from Musw__Permit2__c where id=:permitIds]);
            Set<String> setChecklistTypes = new Set<String>();
            Set<String> permitTypes = new Set<String>();
            for(MUSW__Inspection__c ins : inspectionList){
                setChecklistTypes.add(ins.Checklist_Type__c);
                MUSW__Permit2__c perm = permits.get(ins.MUSW__Permit__c);
                if(perm != null){
                    permitTypes.add(perm.Program_Area__c); //Changed to Program Area instead of Permit type because For all POWTS, there is one common Inspection checklist
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
            }
        }
    }
}