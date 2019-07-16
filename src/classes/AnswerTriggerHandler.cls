public class AnswerTriggerHandler  implements BGCM.ITriggerHandler{
    public AnswerTriggerHandler()
    {
        System.debug('answertriggerhandler 1');
        //This is to check whether bypass the trigger or not
        Global_Settings__c settings = Global_Settings__c.getInstance(UserInfo.getUserId());
        if (settings.Disable_Triggers__c == true) 
            return;
        System.debug('answertriggerhandler 2');
    }
    
    public void onAfterDelete() {}
    public void onAfterInsert() {
        System.debug('answertriggerhandler 3');
       aftermethod();
    }
    public void onAfterUndelete() {}
    public void onAfterUpdate() {
        System.debug('answertriggerhandler 4');
        aftermethod();
    }
    public void onBeforeDelete() {}
    public void onBeforeInsert() {}
    public void onBeforeUndelete() {}
    public void onBeforeUpdate() {}
    
    public void aftermethod(){
        System.debug('answertriggerhandler 5');
         ParentFieldUpdateTriggerHandler.updateParentFieldAnswer(Trigger.New);
         Map<Id,Answer__c> LrSubmissionMap = new Map<Id,Answer__c>();
        Map<Id,Answer__c> permitRenewalSubmissionMap = new Map<Id,Answer__c>();
        Map<Id,Answer__c> ReinstatementSubmissionMap = new Map<Id,Answer__c>();
        Map<Id,Answer__c> LicenseSubmissionMap = new Map<Id,Answer__c>();
        Map<Id,Answer__c> permitSubmissionMap = new Map<Id,Answer__c>();
        //Map<String,Answer__c> QuestionAnswerMap = new Map<String,Answer__c>();
        Map<Id,Decimal> permitReviewHourMap = new Map<Id,Decimal>();
        Map<Id,Answer__c> SRSubmissionMap = new Map<Id,Answer__c>();
        
        //Calling handler method to check submission list records and create submission records
        //List<Answer__c> answers = new List<Answer__c>();
        Set<Id> RenewalIds = new Set<Id>();
        Set<String> questionExternalId = new Set<String>();
        Map<Id,Renewal_Application__c> RenewalMap = new Map<Id,Renewal_Application__c>();
        if(Trigger.isInsert || Trigger.isUpdate)
        {
            
            for(Answer__c answer :(list<Answer__c>)Trigger.New){
                
                system.debug('answer>>'+answer);
                system.debug('answer>>'+answer.License__r);                
                if(answer.License__c!=null)
                {
                    System.debug('answertriggerhandler 8');
                    system.debug('answer.license__c>>'+answer.License__c);
                    LicenseSubmissionMap.put(Answer.Id,Answer);                    
                }
                
                else if(answer.Renewal_Application__c!=null)
                {
                    System.debug('answertriggerhandler 9');
                    RenewalIds.add(answer.Renewal_Application__c);
                    
                }
                else if(answer.Permit__c!=null){
                    System.debug('encountered Permit in Answer Trigger Handler '+answer.Permit__c);
                    permitSubmissionMap.put(Answer.Id,Answer);
                    //QuestionAnswerMap.put(Answer.External_id_of_Question__c, Answer);
                    questionExternalId.add(Answer.External_id_of_Question__c);
                    if(!permitReviewHourMap.containsKey(Answer.Permit__c)){
                        permitReviewHourMap.put(Answer.Permit__c,0.0);
						                       
                    }                                        
                }
                else if(answer.Service_Request__c!=null){
                    System.debug('Answer Service Request>>>'+answer.Service_Request__c);
                    SRSubmissionMap.put(Answer.Id,Answer);
                }
            }
            System.debug('permitReviewHourMap '+permitReviewHourMap);
            if(!questionExternalId.isEmpty()){
            List<MUSW__Permit2__c> permitsToUpdate = new List<MUSW__Permit2__c>();
                System.debug('questionExternalId '+questionExternalId);
            List<Review_Completion_Time_Computation__c> reviewCompletionTimeList = [SELECT ID, Answer_Comparison_Type__c,Range_Start_Value__c, Range_End_Value__c, Expected_Answer__c, External_id_of_Question__c, Review_Hours__c
                                                                              FROM Review_Completion_Time_Computation__c
                                                                              WHERE External_id_of_Question__c IN :questionExternalId];
                System.debug('reviewCompletionTimeList '+reviewCompletionTimeList);
            Map<ID, MUSW__Permit2__c> permitTypeList = new Map<ID, MUSW__Permit2__c>([SELECT ID, Permit_Type__c
                                                        FROM MUSW__Permit2__c
                                                        WHERE ID IN :permitReviewHourMap.keySet()
                                                        //AND Object_Type__c = 'Plan Review'
                                                                                     ]);
                System.debug('permitTypeList.keySet() '+permitTypeList.keySet());
                System.debug('permitTypeList '+permitTypeList);
                
                Map<ID,String> permitTypeMap = new Map<Id,String>();
                Set<String> permitTypeSet = new Set<String>();
                for(MUSW__Permit2__c permitTypes: permitTypeList.values()){
                    System.debug('permitTypes.Id '+permitTypes.Id);
                    System.debug('permitTypes.Permit_Type__c '+permitTypes.Permit_Type__c);
                    permitTypeMap.put(permitTypes.Id, permitTypes.Permit_Type__c);
                    permitTypeSet.add(permitTypes.Permit_Type__c);
                }
                System.debug('permitTypeSet '+permitTypeSet);
                System.debug('permitTypeMap '+permitTypeMap);
            Map<String, Master_Review_List__C> defaultReviewHours = new Map<String, Master_Review_List__C>([SELECT Permit_Type__c, Estimated_Review_Completion_Time_Hours__c
                                                        FROM Master_Review_List__C
                                                        WHERE Permit_Type__c IN :permitTypeSet
                                                        AND Application_Type__c IN ('Plan Review','Manufactured Homes Communities')
														]);
              System.debug('defaultReviewHours '+defaultReviewHours);
            Map<String, Answer__C> QuestionAnswerMap = new Map<String, Answer__C>([Select External_id_of_Question__c, Permit__c, Answer_Text__c 
                                                    From Answer__c 
                                                    Where Permit__c IN: permitReviewHourMap.keySet()]);
                System.debug('QuestionAnswerMap '+QuestionAnswerMap);
                    for(Id permId: permitReviewHourMap.keySet()){
                        Decimal answerHoursForPermit = 0.0;
                        String permitType = permitTypeMap.get(permId);
                        System.debug('permitType '+permitType);
                        System.debug('permit Id' +permId);
                        System.debug('defaultReviewHours '+defaultReviewHours);  
                        Decimal tempValue = 0.0;
                        for(Master_Review_List__C drh: defaultReviewHours.values()){
                            System.debug('drh.Permit_Type__c '+drh.Permit_Type__c);
                            System.debug('permitType '+permitType);
                            if(drh.Permit_Type__c == permitType){
                                System.debug('in if break ');
                                tempValue = drh.Estimated_Review_Completion_Time_Hours__c;
                                break;
                            }
                            System.debug('after break');
                        }
                        System.debug('temp Value '+tempValue);
                        //MUSW__Permit2__c permitTypeValue = permitReviewHourMap.get(permId);
                        answerHoursForPermit += tempValue;
                              System.debug('answerHoursForPermit '+answerHoursForPermit);                  
                        for(Review_Completion_Time_Computation__c rctl: reviewCompletionTimeList){
                        for(Answer__c answersForPermit: QuestionAnswerMap.values()){
                            if(answersForPermit.Permit__c == permId){
                                if(answersForPermit.external_id_of_Question__c == rctl.External_id_of_Question__c
                                  //&& answersForPermit.Answer_Text__c == rctl.Expected_Answer__c
                                  ){
                                      if(rctl.Answer_Comparison_Type__c == 'Normal' && 
                                         answersForPermit.Answer_Text__c == rctl.Expected_Answer__c){
                                             answerHoursForPermit += rctl.Review_Hours__c;                                    
                                          
                                      }else if(rctl.Answer_Comparison_Type__c == 'Range')
                                      {
                                          try{
                                               	 Decimal answerText;
                                                 if(answersForPermit.Answer_Text__c != null){
                                                   answerText = Decimal.valueOf(answersForPermit.Answer_Text__c);
                                                 }else{
                                                    answerText = 0;
                                                  }
                                              if(answerText >= rctl.Range_Start_Value__c &&
                                             answerText <= rctl.Range_End_Value__c){
                                                 
                                                 answerHoursForPermit += rctl.Review_Hours__c;
                                             }
                                          }
                                          catch(exception e){
                                              ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'AnswerTriggerHandler', 'aftermethod',answersForPermit.Answer_Text__c , 'AnswerTriggerHandler', 'High');
                                          }
                                         
                                         
                                          
                                      }
                                      
                                }
                            }
                        }
                    }
                        MUSW__Permit2__c tempPermit = new MUSW__Permit2__c(ID = permId, 
                                                                           Review_Hours_Based_on_Answers__c=answerHoursForPermit);
                        permitsToUpdate.add(tempPermit);                        
                    }
                    
                
                
                update permitsToUpdate;
                
            }            
            /*
            if(PermitSubmissionMap.size() > 0){
                for (Answer__c answers: PermitSubmissionMap.values()){
                    
                }
            }*/
            
            // Query Renewal Map
            if(!RenewalIds.isEmpty())
            {
                System.debug('answertriggerhandler 10');
                RenewalMap = new Map<Id,Renewal_Application__c>([select Id,Renewal_Reinstatement_Type__c, Renewal_Status__c, Credential__c, Permit_Type__c from Renewal_Application__c where Id IN:RenewalIds]);
            }
            
            for(Answer__c answer:(list<Answer__c>)Trigger.new)
            {
                if(answer.Renewal_Application__c!=null && RenewalMap.containsKey(answer.Renewal_Application__c))
                {
                    Renewal_Application__c renewalRec = RenewalMap.get(answer.Renewal_Application__c);
                    
                    if(renewalRec.Renewal_Reinstatement_Type__c== Label.RNT_Renewal && 
                       renewalRec.Renewal_Status__c == 'Incomplete')
                    {   
                        LrSubmissionMap.put(answer.Id,answer);
                    }
                    else if(renewalRec.Renewal_Reinstatement_Type__c== 'Renewal PTO' && 
                       renewalRec.Renewal_Status__c == 'Incomplete')
                    {   
                        permitRenewalSubmissionMap.put(answer.Id,answer);
                    }
                    else if(renewalRec.Renewal_Reinstatement_Type__c!=null && 
                            renewalRec.Renewal_Reinstatement_Type__c==Label.RNT_Reinstatement && 
                            renewalRec.Renewal_Status__c == Label.ST_Incomplete)
                    {
                        ReinstatementSubmissionMap.put(Answer.Id,Answer);
                    }         
                }
            }
        }
        
        
        
        if(LrSubmissionMap.size()>0)
        {
            
            CredRenewalAnsSubTriggerHandler.updateAnswerSubmissionRecords(LrSubmissionMap,Label.RNT_Renewal);   
        }
        else if(ReinstatementSubmissionMap.size()>0)
        {
            CredRenewalAnsSubTriggerHandler.updateAnswerSubmissionRecords(ReinstatementSubmissionMap,Label.RNT_Reinstatement);
        }
        else if(LicenseSubmissionMap.size()>0)
        {
            CredAnsSubmissionTriggerHandler controller = new CredAnsSubmissionTriggerHandler();
            controller.updateAnswerSubmissionRecords(LicenseSubmissionMap);
        }else if(permitRenewalSubmissionMap.size() > 0){
            PermitRenewalAnsSubmissionTriggerHandler.updateAnswerSubmissionRecords(permitRenewalSubmissionMap,'Renewal PTO');
        }else if(permitSubmissionMap.size() > 0){
            PermitAnsSubmissionTriggerHandler permitController = new PermitAnsSubmissionTriggerHandler();
            permitController.updateAnswerSubmissionRecords(permitSubmissionMap);
        }else if(SRSubmissionMap.size()>0){
            system.debug('Entered SR Submission'+SRSubmissionMap);
            SRAnsSubmissionTriggHandler.updateSubmissionRecords(SRSubmissionMap);
        }
        
       
    }
    
}