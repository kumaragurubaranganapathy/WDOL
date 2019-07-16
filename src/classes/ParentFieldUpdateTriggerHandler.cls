/*************************************************************************************************************
** User Story: Controller for "ParentFieldUpdateTriggerHandler" used to update Parent Object Fields
**************************************************************************************************************
** Class Name    : ParentFieldUpdateTriggerHandler
** Description   : Used to Update Parent Object Field upon Answering a Question. This is called from AnswerTriggerHandler
** Version       : 1.0
** Built By      : Aishwaria Rangineni
**------------------------------------------------------------------------------------------------------------
** Modification Log:
**------------------
** Developer                Date               Version                         Description
** Srikanth Kottam		  11/13/2018			2.0			Update Service Request Object upon answering a question
**------------------------------------------------------------------------------------------------------------
** Review Log:
**---------------
** Reviewer                  Date           Version               Description
**------------------------------------------------------------------------------------------------------------
**
**************************************************************************************************************/ 

public with sharing class ParentFieldUpdateTriggerHandler {
    
/***************************************************************************************************
* @Description : Method to Update Parent Object field on Answering a Question. 
*                This looks at the Parent Object API name and the Parent Object Answer Map and 
*                updates the parent Object field value. It works for below Objects: 
*                1. License 2. Renewal 
* @Param       : List of Answers from the Trigger
* @Return      : NA
****************************************************************************************************/
    
    public static void updateParentFieldAnswer(List < Answer__c > newAnswerList) {
        try {
            
            Map < Id, MUSW__License2__c > LicensesToUpdate = new Map < Id, MUSW__License2__c >();
            Map < Id, Renewal_Application__c> RenewalsToUpdate = new Map < Id, Renewal_Application__c > ();
            Map < Id, MUSW__Permit2__c> permitsToUpdate = new Map < Id, MUSW__Permit2__c > (); 
            Map < Id, MUSW__Application2__c> srToUpdate = new Map < Id, MUSW__Application2__c > ();
            Map<Id,Question__c> answerQuestionmap = new Map<Id,Question__c>();
            Map<String,Question__c> questionIdextidMap = new Map<String,Question__c>();
            Set<String> QuestionextIds = new Set<String>();
            
            for(Answer__c ans:newAnswerList)
            {
                if(ans.External_id_of_Question__c!=null)
                {
                    QuestionextIds.add(ans.External_id_of_Question__c);
                }                
            }
            
            List<question__c> questions= [Select id ,External_Id__c,Parent_Object_API_Name__c, Expected_Answer_Parent_Field_Value_Map__c, Parent_Object_Field_API_Name__c from question__c where External_Id__c in: QuestionextIds];
            for(Question__c question:questions ){
                questionIdextidMap.put(question.External_Id__c,question);
            }
            
            for(Answer__c ans:newAnswerList)
            {
                if(ans.External_id_of_Question__c!=null)
                {
                    answerQuestionmap.put(ans.id,questionIdextidMap.get(ans.External_id_of_Question__c));
                }                
            }
            System.debug('answerQuestionmap>>>>>>'+answerQuestionmap);                    
            for (Answer__c Ans: [Select Id, License__c, Renewal_Application__c,Renewal_Application__r.License__c, Permit__c, Service_Request__c, External_id_of_Question__c,  
                                 Answer_Text__c from Answer__c where Id in: newAnswerList]) {
                                     Question__c ansQuestion = answerQuestionmap.get(ans.Id);
                                     if ( ansQuestion.Parent_Object_API_Name__c!= null && ansQuestion.Parent_Object_Field_API_Name__c != null) {
                                         Map < String, String > AnswervalueMap = new Map < String, String > ();
                                         if (ansQuestion.Expected_Answer_Parent_Field_Value_Map__c != null) {
                                             System.debug('Reached Here');
                                             for (String mapPairs: ansQuestion.Expected_Answer_Parent_Field_Value_Map__c.split(';')) {
                                                 System.debug('Reached Here aswell');
                                                 List < String > kv = mapPairs.split('=');
                                                 if (kv.size() == 2) {
                                                     AnswervalueMap.put(kv[0].toLowerCase(), kv[1].toLowerCase());
                                                     System.debug('AnswervalueMap' +AnswervalueMap);
                                                 } else if (kv.size() == 1) {
                                                     AnswervalueMap.put(kv[0].toLowerCase(), '');
                                                 }
                                             }
                                         }
                                         String parentValue = '';
                                         if (Ans.Answer_text__c != null && Ans.Answer_text__c != '') {
                                             if(AnswervalueMap.size() > 0){
                                                 parentValue = AnswervalueMap.get((Ans.Answer_text__c).toLowerCase());
                                             }else if(AnswervalueMap.size() == 0){
                                                 System.debug('reached here');
                                                 parentValue = Ans.Answer_text__c; 
                                             }
                                             
                                             if (parentValue != null) {
                                                 System.debug('parentValue>>>>>>'+parentValue); 
                                                 Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
                                                 Schema.SObjectType leadSchema = schemaMap.get(ansQuestion.Parent_Object_API_Name__c);
                                                 System.debug('leadSchema>>>>>>'+leadSchema); 
                                                 Map < String, Schema.SObjectField > fieldMap = leadSchema.getDescribe().fields.getMap();
                                                 
                                                 /** Code Block Related to License field*/
                                                 if (string.valueOf(leadSchema) == 'MUSW__License2__c') {
                                                     if (Ans.License__c != null || Ans.Renewal_Application__r.License__c != null) {
                                                         Id licenseId = (Ans.License__c != null ) ? Ans.License__c : Ans.Renewal_Application__r.License__c;
                                                         MUSW__License2__c LicenseToUpdate = LicensesToUpdate.get(licenseId);
                                                         if (LicenseToUpdate == null) {
                                                             LicenseToUpdate = new MUSW__License2__c();
                                                         }
                                                         LicenseToUpdate.Id = licenseId;
                                                         Schema.DisplayType fieldType = fieldMap.get(ansQuestion.Parent_Object_Field_API_Name__c).getDescribe().getType();
                                                         if (fieldType == Schema.DisplayType.Boolean) {
                                                             LicenseToUpdate.put(fieldMap.get(ansQuestion.Parent_Object_Field_API_Name__c), Boolean.valueOf(parentValue));
                                                         } else if (fieldType != Schema.DisplayType.Boolean) {
                                                             System.debug('reached here as well');
                                                             LicenseToUpdate.put(fieldMap.get(ansQuestion.Parent_Object_Field_API_Name__c), parentValue);
                                                         }
                                                         
                                                         LicensesToUpdate.put(LicenseToUpdate.Id, LicenseToUpdate);
                                                         System.debug('reached here.....' +LicenseToUpdate);
                                                     }
                                                 } 
                                                 /** Code Block Related to Renewal field*/
                                                 else if (string.valueOf(leadSchema) == 'Renewal_Application__c') {
                                                     if (Ans.Renewal_Application__c != null) {
                                                         Renewal_Application__c LicenseRenewalToUpdate = RenewalsToUpdate.get(Ans.Renewal_Application__c);
                                                         if (LicenseRenewalToUpdate == null) {
                                                             LicenseRenewalToUpdate = new Renewal_Application__c();
                                                         }
                                                         
                                                         LicenseRenewalToUpdate.Id = Ans.Renewal_Application__c;
                                                         
                                                         Schema.DisplayType fieldType = fieldMap.get(ansQuestion.Parent_Object_Field_API_Name__c).getDescribe().getType();
                                                         
                                                         if (fieldType == Schema.DisplayType.Boolean) {
                                                             LicenseRenewalToUpdate.put(fieldMap.get(ansQuestion.Parent_Object_Field_API_Name__c), Boolean.valueOf(parentValue));
                                                         } else if (fieldType != Schema.DisplayType.Boolean) {
                                                             LicenseRenewalToUpdate.put(fieldMap.get(ansQuestion.Parent_Object_Field_API_Name__c), parentValue);
                                                         }
                                                         
                                                         RenewalsToUpdate.put(LicenseRenewalToUpdate.Id, LicenseRenewalToUpdate);
                                                     }
                                                 }  
                                                 else if (string.valueOf(leadSchema) == 'MUSW__Permit2__c') {
                                                     System.debug('Entered permit Map');
                                                     if (Ans.Permit__c != null) {
                                                         MUSW__Permit2__c PermitToUpdate = permitsToUpdate.get(Ans.Permit__c);
                                                         if (PermitToUpdate == null) {
                                                             PermitToUpdate = new MUSW__Permit2__c();
                                                         }
                                                         
                                                         PermitToUpdate.Id = Ans.Permit__c;
                                                         System.debug('Parent_Object_Field_API_Name__c>>>>>>>>>>  '+ansQuestion.Parent_Object_Field_API_Name__c);
                                                         System.debug('parentValue<<<<<<<<  '+parentValue);
                                                         Schema.DisplayType fieldType = fieldMap.get(ansQuestion.Parent_Object_Field_API_Name__c).getDescribe().getType();
                                                         
                                                         if (fieldType == Schema.DisplayType.Boolean) {
                                                             PermitToUpdate.put(fieldMap.get(ansQuestion.Parent_Object_Field_API_Name__c), Boolean.valueOf(parentValue));
                                                         } /*else if (fieldType == Schema.DisplayType.DOUBLE) {
                                                             System.debug('Here to update');
                                                             PermitToUpdate.put(fieldMap.get(ansQuestion.Parent_Object_Field_API_Name__c), DOUBLE.valueOf(parentValue));
                                                         }*/else{
                                                             System.debug('entered else3');
                                                             PermitToUpdate.put(fieldMap.get(ansQuestion.Parent_Object_Field_API_Name__c), parentValue);
                                                         }
                                                         
                                                         if(PermitToUpdate!=null){
                                                             permitsToUpdate.put(PermitToUpdate.Id, PermitToUpdate);
                                                             System.debug('permitsToUpdate>>>>>>>>>>'+permitsToUpdate);
                                                         }
                                                         
                                                     }
                                                 } // Added by Srikanth Kottam for Service Request   
                                                 else if (string.valueOf(leadSchema) == 'MUSW__Application2__c') {
                                                     System.debug('Entered Service Request Map');
                                                     if (Ans.Service_Request__c != null) {
                                                         MUSW__Application2__c servicerequestToUpdate = srToUpdate.get(Ans.Service_Request__c);
                                                         if (servicerequestToUpdate == null) {
                                                             servicerequestToUpdate = new MUSW__Application2__c();
                                                         }
                                                         
                                                         servicerequestToUpdate.Id = Ans.Service_Request__c;
                                                         System.debug('Parent_Object_Field_API_Name__c>>>>>>>>>>  '+ansQuestion.Parent_Object_Field_API_Name__c);
                                                         System.debug('parentValue<<<<<<<<  '+parentValue);
                                                         Schema.DisplayType fieldType = fieldMap.get(ansQuestion.Parent_Object_Field_API_Name__c).getDescribe().getType();
                                                         
                                                         if (fieldType == Schema.DisplayType.Boolean) {
                                                             servicerequestToUpdate.put(fieldMap.get(ansQuestion.Parent_Object_Field_API_Name__c), Boolean.valueOf(parentValue));
                                                         }else{
                                                             System.debug('entered else3');
                                                             servicerequestToUpdate.put(fieldMap.get(ansQuestion.Parent_Object_Field_API_Name__c), parentValue);
                                                         }
                                                         
                                                         if(servicerequestToUpdate!=null){
                                                             srToUpdate.put(servicerequestToUpdate.Id, servicerequestToUpdate);
                                                             System.debug('srToUpdate>>>>>>>>>>'+srToUpdate);
                                                         }
                                                         
                                                     }
                                                 }
                                             }
                                         }
                                     }
                                 }
            if (LicensesToUpdate.size() > 0) {
                Database.SaveResult[] sr = Database.update(LicensesToUpdate.values(), false);
                ErrorLogger.logDMLDatabaseResultErrors(UserInfo.getUserId(), null, sr, null, 'License Update', 'Update Parent Field based on Answer', 'Update Parent Field Answer', 'ParentFieldUpdateTriggerHandler', 'High', 'ParentFieldUpdateTriggerHandler');
            }else if (RenewalsToUpdate.size() > 0) {
                Database.SaveResult[] sr = Database.update(RenewalsToUpdate.values(), false);
                ErrorLogger.logDMLDatabaseResultErrors(UserInfo.getUserId(), null, sr, null, 'License Renewal', 'Update Parent Field based on Answer', 'Update Parent Field Answer', 'ParentFieldUpdateTriggerHandler', 'High', 'ParentFieldUpdateTriggerHandler');
            }else if (permitsToUpdate.size() > 0) {
                System.debug('Here to update');
                Database.SaveResult[] sr = Database.update(permitsToUpdate.values(), false);
                ErrorLogger.logDMLDatabaseResultErrors(UserInfo.getUserId(), null, sr, null, 'Permit Update', 'Update Parent Field based on Answer', 'Update Parent Field Answer', 'ParentFieldUpdateTriggerHandler', 'High', 'ParentFieldUpdateTriggerHandler');
            }else if (srToUpdate.size() > 0) {
                System.debug('Here to update');
                Database.SaveResult[] sr = Database.update(srToUpdate.values(), false);
                ErrorLogger.logDMLDatabaseResultErrors(UserInfo.getUserId(), null, sr, null, 'Service Request', 'Update Parent Field based on Answer', 'Update Parent Field Answer', 'ParentFieldUpdateTriggerHandler', 'High', 'ParentFieldUpdateTriggerHandler');
            }
            
        }catch(Exception e){
            System.debug('Exception>>>>'+e);
        }
        
    }
    
    
    /***************************************************************************************************
* @Description : Method to Update Parent Object complaiance field on Answering a Question. 
*                This looks at the Qualifying response value for each answer on the License. 
*                If atleast one answer satisfies the qualifying response, the parent compliance field is updated to True. 
*                If none of the answer does not satisfy the qualifying response, the parent compliance field is updated to False.
*                It works for below Objects: 
*                1. License 2. Renewal 3.Review
* @Param       : Map of Answers from the Trigger
* @Return      : NA
****************************************************************************************************/
/*    public static void parentComplianceFieldUpdate(Map < Id, Answer__c > newAnswerMap) {
        try {
            System.debug('parentComplianceFieldUpdate ');
            Map < Id, MUSW__License2__c > LicensesToUpdate = new Map < Id, MUSW__License2__c > ();
            Map < Id, Renewal_Application__c > RenewalsToUpdate = new Map < Id, Renewal_Application__c > ();
            Map < id, MUSW__Application2__c> SRsToUpdate = new Map < id, MUSW__Application2__c> ();
            
            Map < Id, List < Answer__c >> LicenseAnswerMap = new Map < Id, List < Answer__c >> ();
            Map < Id, List < Answer__c >> RenewalAnswerMap = new Map < Id, List < Answer__c >> ();
            Map < Id, List < Answer__c >> SRAnswerMap = new Map < Id, List < Answer__c >> ();
            
            
            set < Id > LicenseIds = new set < Id > ();
            set < Id > RenewalIds = new set < Id > ();
            set < Id > SRIds = new set < Id > ();
            
            Map<String,Question__c> questionIdextid = new Map<String,Question__c>();
            Map<Id,Question__c> answerQuestionmap = new Map<Id,Question__c>();
            Set<String> QuestionextIds = new Set<String>();
            
            for(Answer__c ans:newAnswerMap.values())
            {
                if(ans.External_id_of_Question__c!=null)
                {
                    QuestionextIds.add(ans.External_id_of_Question__c);
                }                
            }
            List<question__c> questions= [Select id ,Qualifying_Response__c,External_Id__c,Parent_Object_API_Name__c,Compliance_Field_API_Name__c,Question_is_Compliance_Related__c,Expected_Answer_Parent_Field_Value_Map__c,Parent_Object_Field_API_Name__c from question__c where External_Id__c in: QuestionextIds];
            for(Question__c question:questions ){
                questionIdextid.put(question.External_Id__c,question);
            }
            for(Answer__c ans:newAnswerMap.values()) {
                if(ans.External_id_of_Question__c!=null)
                {
                    answerQuestionmap.put(ans.id,questionIdextid.get(ans.External_id_of_Question__c));
                }                
            }
            
            
            for (Answer__c ans: newAnswerMap.values()) {
                if (Ans.License__c != null) {
                    LicenseIds.add(Ans.License__c);
                } else if (Ans.Renewal_Application__c != null) {
                    RenewalIds.add(Ans.Renewal_Application__c);
                } //else if (Ans.Service_Request__c != null) {
                //SRIds.add(Ans.Service_Request__c);
                //}
            }
            
            /** Code Block Related to License Compliance field
            if (!LicenseIds.isEmpty()) {
                Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
                Schema.SObjectType leadSchema = schemaMap.get('MUSW__License2__c');
                Map < String, Schema.SObjectField > fieldMap = leadSchema.getDescribe().fields.getMap();
                
                List < Answer__c > AnswersList = new List < Answer__c > ();
                
                AnswersList = [Select Id, Name, License__c, Answer_Text__c from Answer__c where License__c IN: LicenseIds];
                
                if (!AnswersList.isEmpty()) {
                    for (Answer__c ans: AnswersList) {
                        List < Answer__c > ansListForMap = LicenseAnswerMap.get(ans.License__c);
                        if (ansListForMap == null) {
                            ansListForMap = new List < Answer__c > ();
                        }
                        ansListForMap.add(ans);
                        LicenseAnswerMap.put(ans.License__c, ansListForMap);
                    }
                }
                
                if (!LicenseAnswerMap.isEmpty()) {
                    for (Id lic: LicenseAnswerMap.keyset()) {
                        Boolean isComplianceMet = false;
                        for (Answer__c ans: LicenseAnswerMap.get(lic)) {
                            Question__c ansQuestion = answerQuestionmap.get(ans.Id);
                            if(ansQuestion!=null){
                                MUSW__License2__c LicenseToUpdate = LicensesToUpdate.get(Ans.License__c);
                                if (LicenseToUpdate == null) {
                                    LicenseToUpdate = new MUSW__License2__c();
                                }
                                LicenseToUpdate.Id = Ans.License__c;
                                
                                if (ans.Answer_Text__c == ansQuestion.Qualifying_Response__c && ansQuestion.Question_is_Compliance_Related__c) {
                                    if (ansQuestion.Compliance_Field_API_Name__c != null) {
                                        LicenseToUpdate.put(fieldMap.get(ansQuestion.Compliance_Field_API_Name__c), true);
                                        isComplianceMet = true;
                                        
                                        LicensesToUpdate.put(lic, LicenseToUpdate);
                                    }
                                    
                                } else if (ans.Answer_Text__c != ansQuestion.Qualifying_Response__c && ansQuestion.Question_is_Compliance_Related__c && !isComplianceMet) {
                                    if (ansQuestion.Compliance_Field_API_Name__c != null) {
                                        LicenseToUpdate.put(fieldMap.get(ansQuestion.Compliance_Field_API_Name__c), false);
                                        //isComplianceMet = false;
                                        
                                        LicensesToUpdate.put(lic, LicenseToUpdate);
                                    }
                                }
                            }
                        }
                    }
                }
            }            
            /** Code Block Related to Renewal Compliance field
            else if (!RenewalIds.isEmpty()) {
                Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
                Schema.SObjectType leadSchema = schemaMap.get('');
                Map < String, Schema.SObjectField > fieldMap = leadSchema.getDescribe().fields.getMap();
                
                List < Answer__c > AnswersList = new List < Answer__c > ();
                
                AnswersList = [Select Id, Name, Renewal_Application__c, Answer_Text__c from Answer__c where Renewal_Application__c IN: RenewalIds];
                
                if (!AnswersList.isEmpty()) {
                    for (Answer__c ans: AnswersList) {
                        List < Answer__c > ansListForMap = RenewalAnswerMap.get(ans.Renewal_Application__c);
                        if (ansListForMap == null) {
                            ansListForMap = new List < Answer__c > ();
                        }
                        ansListForMap.add(ans);
                        RenewalAnswerMap.put(ans.Renewal_Application__c, ansListForMap);
                    }
                }
                
                if (!RenewalAnswerMap.isEmpty()) {
                    for (Id ren: RenewalAnswerMap.keyset()) {
                        Boolean isComplianceMet = false;
                        
                        for (Answer__c ans: RenewalAnswerMap.get(ren)) {
                            Question__c ansQuestion = answerQuestionmap.get(ans.Id);
                            if(ansQuestion!=null){
                                Renewal_Application__c RenewalToUpdate = RenewalsToUpdate.get(Ans.Renewal_Application__c);
                                if (RenewalToUpdate == null) {
                                    RenewalToUpdate = new Renewal_Application__c();
                                }
                                
                                RenewalToUpdate.Id = Ans.Renewal_Application__c;
                                
                                if (ans.Answer_Text__c == ansQuestion.Qualifying_Response__c && ansQuestion.Question_is_Compliance_Related__c) {
                                    if (ansQuestion.Compliance_Field_API_Name__c != null) {
                                        RenewalToUpdate.put(fieldMap.get(ansQuestion.Compliance_Field_API_Name__c), true);
                                        isComplianceMet = true;
                                        
                                        RenewalsToUpdate.put(ren, RenewalToUpdate);
                                    }
                                    
                                } else if (ans.Answer_Text__c != ansQuestion.Qualifying_Response__c && ansQuestion.Question_is_Compliance_Related__c && !isComplianceMet) {
                                    if (ansQuestion.Compliance_Field_API_Name__c != null) {
                                        RenewalToUpdate.put(fieldMap.get(ansQuestion.Compliance_Field_API_Name__c), false);
                                        //isComplianceMet = false;
                                        
                                        RenewalsToUpdate.put(ren, RenewalToUpdate);
                                    }
                                }
                            }
                        }
                    }
                }
            }            
            
            /** Code Block Related to Service Request Compliance field*/ 
            /* else if (!SRIds.isEmpty()) {
Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
Schema.SObjectType leadSchema = schemaMap.get(label.API_Application);
Map < String, Schema.SObjectField > fieldMap = leadSchema.getDescribe().fields.getMap();

List < Answer__c > AnswersList = new List < Answer__c > ();

AnswersList = [Select Id, Name, Service_Request__c, Answer_Text__c from Answer__c where Service_Request__c IN: SRIds];

if (!AnswersList.isEmpty()) {
for (Answer__c ans: AnswersList) {
List < Answer__c > ansListForMap = SRAnswerMap.get(ans.Service_Request__c);
if (ansListForMap == null) {
ansListForMap = new List < Answer__c > ();
}
ansListForMap.add(ans);
SRAnswerMap.put(ans.Service_Request__c, ansListForMap);
}
}
} 
            
            if (!LicensesToUpdate.isEmpty()) {
                Database.SaveResult[] sr = Database.update(LicensesToUpdate.values(), false);
                //ErrorLogger.logDMLDatabaseResultErrors(UserInfo.getUserId(), null, sr, null, label.API_License, label.Str_Update_Parent_compliance_Field_based_on_Answer, label.Str_updateParentComplianceFieldAnswer, label.Str_BIZC_ParentFieldUpdateTriggerHandler, label.Err_Severity, label.Str_BIZC_ParentFieldUpdateTriggerHandler);
            } else if (!RenewalsToUpdate.isEmpty()) {
                Database.SaveResult[] sr = Database.update(RenewalsToUpdate.values(), false);
                //ErrorLogger.logDMLDatabaseResultErrors(UserInfo.getUserId(), null, sr, null, label.API_License_Renewal, label.Str_Update_Parent_compliance_Field_based_on_Answer, label.Str_updateParentComplianceFieldAnswer, label.Str_BIZC_ParentFieldUpdateTriggerHandler, label.Err_Severity, label.Str_BIZC_ParentFieldUpdateTriggerHandler);
            } 
        } catch (Exception e) {
            //ErrorLogger.logGeneralException(e, UserInfo.getUserId(), label.Str_BIZC_ParentFieldUpdateTriggerHandler, label.Err_Error_in_Parent_Compliance_Field_Update_Method, label.Str_parentComplianceFieldUpdate, label.Str_BIZC_ParentFieldUpdateTriggerHandler, label.str_HIGH);
        }
    } */
    
}