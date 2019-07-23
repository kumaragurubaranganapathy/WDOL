/**
* Name: License2TriggerHandler
* Type: Class
* Description: Trigger Handler for MUSW__License2__c object being called from License2_Trigger
* Date:        Developer/Company                    Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 06/13/2018   Sharad Maheshwari/Deloitte           Initial Creation
**/
public class QuestionAnswerObj {

    // List of all related questions
    public List<Question__c> quesList {get; set;}

    public Set<String> allplanreviewsandpermits;
    public Set<String> allcredentials;
    // List of parent questions
    public List<QuestionObj> questionsList {get; set;}

    // List of all answers
    public List<Answer__c> answersList {get; set;}

    Map<String,List<Answer__c>> mapQuestionIdAnswerList;
    
    public List<Answer__c> answerList_ToBeDeleted {get;set;}
     public QuestionAnswerObj(){}
    
    /**
     * Constructor 
     * @param     applicationType, credentialType, credential, applicationMethod, Object lookup field, licenseOrPermitId
     */   
    public QuestionAnswerObj(String applicationType, String credentialType, String credential, String applicationMethod, String objectLookup, Id licenseOrPermitId) {
              allplanreviewsandpermits =Utilities.getallPlanreviewsandpermits();
        allcredentials =Utilities.getallCredentials();
        String applicationState = Label.Str_Credential;
        
            if(applicationType == Label.RNT_Renewal){
                applicationState = Label.Str_Credential_Renewal;                
            }else if(applicationType == Label.RNT_Reinstatement){
                applicationState = Label.Str_Credential_Reinstatement;                
            }else if(applicationType == Label.Str_ManufacturedHomesRenewal){
                applicationState = Label.Str_Permit_Renewal;                
            }
              else if (allplanreviewsandpermits.contains(applicationType)){
                applicationState = Label.Str_Permit;                
                }
        System.debug('Paralist applicationType' +applicationType );
        System.debug('Paralist credentialType'+ credentialType);
        System.debug('Paralist credential'+credential);
        System.debug('Paralist applicationMethod'+applicationMethod);
        System.debug('Paralist applicationState'+applicationState);
        System.debug('Paralist objectLookup'+objectLookup);
        System.debug('Paralist licenseOrPermitId'+licenseOrPermitId);
        
        // Initialize parent questions list
        questionsList = new List<QuestionObj>();

        // Initialize answers list
        answersList = new List<Answer__c>();
        
        answerList_ToBeDeleted = new List<Answer__c>();

        mapQuestionIdAnswerList = new Map<String,List<Answer__c>>();
        // Get all questions for this license type
        if(applicationType== Label.Str_Trades_Credential || 
           applicationType== Label.Str_Manufactured_Homes_App ||
           applicationType== Label.Str_Credential||
           applicationType== Label.Str_Credential_Renewal||
           applicationType== Label.Str_Credential_Reinstatement ||
           applicationType== Label.RNT_Renewal||
           applicationType== Label.RNT_Reinstatement||
           applicationType=='Delegated Municipality'||
           applicationType=='Notary Public' ||
           applicationType=='Timeshares' ||
           applicationType=='Appraiser Courses' ||
           applicationType=='Camping Resorts' ||
           applicationType=='Architects'||
           applicationType=='Geologist'||
           applicationType=='Appraisers - Real Estate'||
           applicationType=='Engineers'||
           applicationType=='Funerals' ||
           applicationType=='Professional Engineer and Land Surveyor'||
           applicationType=='Appraisal Management Companies' ||
           applicationType=='Cemeteries' ||
           applicationType=='Land Surveyors' ||
           applicationType=='On-site Wastewater'||
           applicationType=='Landscape Architects'
          ){
        quesList = [SELECT Id, Name, Allow_Multiple_Question_Groups__c,Child_Question_Group__c,Question_Group__c, Data_Type__c, Display_Style__c, 
            Application_Type__c, Application_Method__c, Credential_Type__c, Credential__c, Permit_Type__c, Program_Area__c, Parent_Question__c, Possible_Responses__c, Previous_Question_Version__c, 
            Qualifying_Response__c, External_id__c,Question_Body__c, Status__c, Version__c, Show_For__c,
            Triggering_Field_API_Name__c, Triggering_Field_Value__c, Parent_Object_API_Name__c,Effective_Date__c,End_Date__c,Parent_Question__r.Effective_Date__c,Parent_Question__r.End_Date__c,
            Order_Number__c, Triggering_Comment_Box_Value__c, Triggering_Parent_Answer__c,Chevron_Type__c 
            FROM Question__c 
            WHERE Credential_Type__c = :credentialType
            AND Credential__c = :credential
            AND Show_For__c includes (:applicationState)
            AND (Application_Method__c = :applicationMethod OR Application_Method__c = 'All')
            AND Status__c = 'Active'
            AND Record_Type_Name__c = 'Background Questions' 
            //AND Chevron_Type__c = 'Legal Background'      
                    //AND Question_Sub_Section__c = 'a2Mr0000000QUag'
            ORDER BY Order_Number__c];
        }
        
            
  
        else{
               quesList = [SELECT Id, Name, Allow_Multiple_Question_Groups__c,Child_Question_Group__c,Question_Group__c, Data_Type__c, Display_Style__c, 
            Application_Type__c, Application_Method__c, Credential_Type__c, Credential__c, Permit_Type__c, Program_Area__c, Parent_Question__c, Possible_Responses__c, Previous_Question_Version__c, 
            Qualifying_Response__c, External_id__c,Question_Body__c, Status__c, Version__c, Show_For__c,
            Triggering_Field_API_Name__c, Triggering_Field_Value__c, Parent_Object_API_Name__c,Effective_Date__c,End_Date__c,Parent_Question__r.Effective_Date__c,Parent_Question__r.End_Date__c,
            Order_Number__c, Triggering_Comment_Box_Value__c, Triggering_Parent_Answer__c,Chevron_Type__c 
            FROM Question__c 
            WHERE Program_Area__c = :credentialType
            AND Permit_Type__c = :credential
            AND Show_For__c includes (:applicationState)
            AND Status__c = 'Active'
            AND Record_Type_Name__c = 'Background Questions'
                          // AND Question_Sub_Section__c = 'a2Mr0000000QUag'
            ORDER BY Order_Number__c];
            
            //AND Application_Method__c = :applicationMethod
        }
        
            
        // Get all answers for this credential/permit
        // ToDO
        String queryAnswers = 'SELECT Id, App_Generate_Fee_Date__c,Question__r.Effective_Date__c,Question__r.End_Date__c,Answer_Group__c,Question_Group__c,External_id_of_Question__c,Name, Answer_Text__c, Comment__c, License__c, Question__c, Question_Body__c FROM Answer__c WHERE ' + objectLookup + ' = :licenseOrPermitId';       
        answersList = Database.query(queryAnswers);
        System.Debug(licenseOrPermitId);
        setupQuestions(applicationType, licenseOrPermitId);
    }
    
    /**
     * Constructor 
     * @param     applicationType, credentialType, credential, applicationMethod, objectLookup, licenseId, serviceRequestType
     */   
    public QuestionAnswerObj(String applicationType, String credentialType, String credential, String applicationMethod, String objectLookup, String licenseId, String serviceRequestType) {
        
        if(licenseId == '' || licenseId == null){
            return;
        }
        
        allplanreviewsandpermits =Utilities.getallPlanreviewsandpermits();
        allcredentials =Utilities.getallCredentials();
        String applicationState = Label.Str_Service_Request;
        
        // Initialize parent questions list
        questionsList = new List<QuestionObj>();

        // Initialize answers list
        answersList = new List<Answer__c>();
        
        answerList_ToBeDeleted = new List<Answer__c>();

        mapQuestionIdAnswerList = new Map<String,List<Answer__c>>();
        System.debug('Paralist applicationType' +applicationType );
        System.debug('Paralist credentialType'+ credentialType);
        System.debug('Paralist credential'+credential);
        System.debug('Paralist applicationMethod'+applicationMethod);
        System.debug('Paralist applicationState'+applicationState);
        // Get all questions for this license type
        /*quesList = [SELECT Id, Name, Allow_Multiple_Question_Groups__c,Child_Question_Group__c,Question_Group__c, Data_Type__c, Display_Style__c, 
            Application_Type__c, Application_Method__c, Credential_Type__c, Credential__c, Permit_Type__c, Program_Area__c, Parent_Question__c, Possible_Responses__c, Previous_Question_Version__c, 
            Qualifying_Response__c, External_id__c,Question_Body__c, Status__c, Version__c, Show_For__c,
            Triggering_Field_API_Name__c, Triggering_Field_Value__c, Parent_Object_API_Name__c,Effective_Date__c,End_Date__c,Parent_Question__r.Effective_Date__c,Parent_Question__r.End_Date__c,
            Order_Number__c, Triggering_Comment_Box_Value__c, Triggering_Parent_Answer__c 
            FROM Question__c 
            WHERE Credential_Type__c = :credentialType
            AND Credential__c = :credential
            AND Service_Request_Type__c = :serviceRequestType
            AND Show_For__c includes (:applicationState)
            AND Application_Method__c = :applicationMethod
            AND Status__c = 'Active'
            AND Record_Type_Name__c = 'Background Questions'
                  //  AND Question_Sub_Section__c = 'a2Mr0000000QUag'   
            ORDER BY Order_Number__c];*/
           
        // Get all answers for this credential/permit id
        String queryAnswers = 'SELECT Id, App_Generate_Fee_Date__c,Question__r.Effective_Date__c,Question__r.End_Date__c,Answer_Group__c,Question_Group__c,External_id_of_Question__c,Name, Answer_Text__c, Comment__c, License__c, Question__c, Question_Body__c FROM Answer__c WHERE ' + objectLookup + ' = :licenseId';       
        answersList = Database.query(queryAnswers);
        
        setupQuestions(applicationType, licenseId);
    }
    
    private void setupQuestions(String applicationType, Id licenseId){
        if(!answersList.isEmpty())
        {
            for(Answer__c ans:answersList)
            {
                //answerMap.put(ans.Id,ans);
                
                if(ans.Answer_Group__c!=null)
                {
                    //AnswerId_AnswerGroupMap.put(ans.Id,ans.Answer_Group__c);
                    //AnswerGroupId_QuestionIdMap.put(ans.Answer_Group__c,ans.Question__c);
                    
                    //This will get list of all the answers for a single question 
                    if(!mapQuestionIdAnswerList.containsKey(ans.External_id_of_Question__c))
                    {
                        mapQuestionIdAnswerList.put(ans.External_id_of_Question__c,new List<Answer__c>());
                    }
                    mapQuestionIdAnswerList.get(ans.External_id_of_Question__c).add(ans);
                    }
            }
        }
        
        // Build parent questions list
        system.debug('debug at 135'+quesList.size());

        // Build parent questions list
        for(Question__c queObj : quesList) {

            if(queObj.Parent_Question__c == null) {

                    // Call constructor and add fields
                    if(isValidVersion(queObj)){
                        questionsList.add(new QuestionObj(queObj.Id, queObj.Data_Type__c, queObj.Application_type__c, 
                            queObj.Application_Method__c, queObj.Credential_Type__c, queObj.Credential__c, queObj.Permit_Type__c, queObj.Program_Area__c,
                                                          queObj.Question_Body__c, queObj.Parent_Question__c, queObj.Triggering_Field_API_Name__c, queObj.Parent_Object_API_Name__c,
                        queObj.Triggering_Parent_Answer__c,queObj.External_Id__c, queObj.Triggering_Comment_Box_Value__c, queObj.Triggering_Field_Value__c, this.quesList, queObj.Possible_Responses__c,queObj.Question_Group__c,queObj.Allow_Multiple_Question_Groups__c));
                    }
            }
        }
        
        if(!questionsList.isEmpty())
        {
            for(QuestionObj quesObj:questionsList)
            {
                for(Question__c queObj : quesList) {
                    List<Answer__c> AnswerforGroupQuestion = new List<Answer__c>();//List of all the answers for a parent Question
                        if(isValidVersion(queObj)){
                            if(queObj.Parent_Question__c == quesObj.id && quesObj.AllowQuestionGroups && quesObj.QuestionGroup != null)
                            {
                                if(!mapQuestionIdAnswerList.isEmpty() && mapQuestionIdAnswerList.containskey(queObj.External_Id__c))
                                {
                                    system.debug('debug at 194'+mapQuestionIdAnswerList);
                                    AnswerforGroupQuestion = mapQuestionIdAnswerList.get(queObj.External_Id__c);
                                    if(!AnswerforGroupQuestion.isEmpty())
                                    {
                                        for(Answer__c ans:AnswerforGroupQuestion){
                                            
                                            QuestionsGroup quesGroup = new QuestionsGroup(queObj.Id, queObj.Data_Type__c, queObj.Application_type__c, 
                            queObj.Application_Method__c, queObj.Credential_Type__c, queObj.Credential__c, queObj.Permit_Type__c, queObj.Program_Area__c,
                                                                                          queObj.Question_Body__c, queObj.Parent_Question__c, 
                                                queObj.Triggering_Field_API_Name__c, queObj.Parent_Object_API_Name__c, queObj.Triggering_Parent_Answer__c, 
                                                queObj.External_Id__c,queObj.Triggering_Comment_Box_Value__c, queObj.Triggering_Field_Value__c, 
                                                queObj.Possible_Responses__c);
                                            quesGroup.answerId = ans.Id;
                                            quesGroup.answerText = ans.Answer_Text__c;
                                            quesGroup.answerComment = ans.Comment__c;
                                            quesGroup.AnswerGroup= ans.Answer_Group__c;
                                            if(!quesObj.Map_Of_AnswerGroup_childQuestionsGroup.containskey(ans.Answer_Group__c))
                                            {
                                                quesObj.Map_Of_AnswerGroup_childQuestionsGroup.put(ans.Answer_Group__c,new List<QuestionsGroup>());
                                            }
                                           
                                                quesObj.Map_Of_AnswerGroup_childQuestionsGroup.get(ans.Answer_Group__c).add(quesGroup);
                                        }
                                        
                                        system.debug('debug at 213'+quesObj.Map_Of_AnswerGroup_childQuestionsGroup);
                                    }
                                    
                                    
                                }
                                else{
                                        
                                        QuestionsGroup quesGroup = new QuestionsGroup(queObj.Id, queObj.Data_Type__c, queObj.Application_type__c, 
                            queObj.Application_Method__c, queObj.Credential_Type__c, queObj.Credential__c, queObj.Permit_Type__c, queObj.Program_Area__c,
                                                                                      queObj.Question_Body__c, queObj.Parent_Question__c, 
                                                queObj.Triggering_Field_API_Name__c, queObj.Parent_Object_API_Name__c, queObj.Triggering_Parent_Answer__c, 
                                                queObj.External_Id__c,queObj.Triggering_Comment_Box_Value__c, queObj.Triggering_Field_Value__c, 
                                                queObj.Possible_Responses__c);
                                        if(!quesObj.Map_Of_AnswerGroup_childQuestionsGroup.containskey(quesObj.QuestionGroup+'-1'))
                                        {
                                                quesObj.Map_Of_AnswerGroup_childQuestionsGroup.put(quesObj.QuestionGroup+'-1',new List<QuestionsGroup>());
                                        }
                                                
                                         quesObj.Map_Of_AnswerGroup_childQuestionsGroup.get(quesObj.QuestionGroup+'-1').add(quesGroup);
                                }
                            }
                        }
                    
                }
                
                if(!quesObj.Map_Of_AnswerGroup_childQuestionsGroup.isEmpty())
                {
                    system.debug('debug at 534'+quesObj.Map_Of_AnswerGroup_childQuestionsGroup.size());
                    quesObj.Map_Of_AnswerGroup_childQuestionsGroup_JSON = JSON.serialize(quesObj.Map_Of_AnswerGroup_childQuestionsGroup);
                }
            }
            
        }
        // Insert answers into list, if any
        for(Answer__c ansObj : answersList) {
            if(ansObj.App_Generate_Fee_Date__c == null && ansObj.Question__r.End_Date__c < system.today()) {
                if(system.today()>ansObj.Question__r.End_Date__c)
                {
                    answerList_ToBeDeleted.add(ansObj);                   
                }
            }
            else if(ansObj.Question__r.End_Date__c == null || (ansObj.Question__r.Effective_Date__c <= system.today() && ansObj.Question__r.End_Date__c >= system.today()))
            {
                for(QuestionObj queObj : questionsList) {
    
                    // If current question is parent question
                    if(ansObj.External_id_of_Question__c == queObj.externalId) {
                        queObj.answerId = ansObj.Id;
                        queObj.answerText = ansObj.Answer_Text__c;
                        queObj.answerComment = ansObj.Comment__c;
                    }
    
                    for(ChildQuestionObj cQueObj : queObj.childQueList) {
    
                        // If current question is child question
                        if(ansObj.External_id_of_Question__c == cQueObj.externalId) {
                            cQueObj.answerId = ansObj.Id;
                            cQueObj.answerText = ansObj.Answer_Text__c;
                            cQueObj.answerComment = ansObj.Comment__c;
                        }
                    }
                }
            }
        }
        system.debug('at 348 to be deleted answers'+answerList_ToBeDeleted);
        // Update show field based on complex logic
        System.debug('applicationType' +applicationType);
        showHideQuestions(applicationType, licenseId);

        // Clear unused lists
        answersList.clear();
        quesList.clear();
    }    
    
    /**
     * Method - isValidVersion
     * @param Question__c record
     * return Boolean 
    **/
    public boolean isValidVersion(Question__c queObj)
    {
        Boolean validVersion = false;
        if(queObj.Effective_Date__c!=null && queObj.End_Date__c!=null && system.today()>=queObj.Effective_Date__c && system.today()<=queObj.End_Date__c)
        {
            validVersion = true;
        }
        else if(queObj.Effective_Date__c!=null && queObj.End_Date__c==null && system.today()>=queObj.Effective_Date__c)
        {
            validVersion = true;
        }
        else if(queObj.Effective_Date__c==null && queObj.End_Date__c!=null && system.today()<=queObj.End_Date__c)
        {
            validVersion = true;
        }
        else if(queObj.Effective_Date__c==null && queObj.End_Date__c==null){
            validVersion = true;
        }
        else{
            validVersion = false;
        }
        return validVersion;
    }
    /* * Method - Show/hide questions based on complex logic 
     * @param     Application type, License Id
     * @return    void
     */
    public void showHideQuestions(String applicationType, String licenseId) {

        system.debug('applicationType>>>>>' +applicationType);
        // Object name
        String currObjName = '';

        // Set object name
        if(allcredentials.contains(applicationType)) { currObjName = label.API_License2; }
        if(applicationType == Label.RNT_Renewal||applicationType == Label.RNT_Reinstatement||label.Str_ManufacturedHomesRenewal == applicationType) { currObjName = label.API_Renewal_Application; }
        if (allplanreviewsandpermits.contains(applicationType) ) { currObjName = label.API_MUSW_Permit2; }
        else if(applicationType == Label.Str_Service_Request) { currObjName = label.API_Service_Request; }
        /*else if(applicationType == label.Obj_Application) { currObjName = label.API_Application; }*/

        // Object
        SObject currObj;

        // Query string for parent fields
        String fieldsQuery = 'SELECT Id ';
        Set<String> setParentFields = new Set<String>();
        
        for(QuestionObj queObj : questionsList) {

            // Add parent fields in parent questions
            if((queObj.parentFieldObject == currObjName) && (queObj.parentField != null)) {
                /*if(!fieldsQuery.contains(queObj.parentField)) {
                    fieldsQuery = fieldsQuery + ', ' + queObj.parentField;
                }*/
                setParentFields.add(queObj.parentField);
            }

            // Add parent fields in child questions
            for(ChildQuestionObj cQueObj : queObj.childQueList) {
                if((cQueObj.parentFieldObject == currObjName) && (cQueObj.parentField != null)) {
                    setParentFields.add(cQueObj.parentField);
                    /*if(!fieldsQuery.contains(cQueObj.parentField)) {
                        fieldsQuery = fieldsQuery + ', ' + cQueObj.parentField;
                    }*/
                }
            }
            
            //Add Parent Fields in Child Group Questions 
            if(!queObj.Map_Of_AnswerGroup_childQuestionsGroup.isEmpty())
            {
                for(string AnsGroup:queObj.Map_Of_AnswerGroup_childQuestionsGroup.keyset())
                {
                    for(QuestionsGroup quesGrp:queObj.Map_Of_AnswerGroup_childQuestionsGroup.get(AnsGroup))
                    {
                        if((quesGrp.parentFieldObject == currObjName) && (quesGrp.parentField != null)) {
                            setParentFields.add(quesGrp.parentField);
                        }
                    }
                }
            }
        }
        
        List<String> temp = new List<String>();
        temp.addAll(setParentFields);
        String strParentFields = String.join(temp, ', ');
        if(strParentFields != ''){
            fieldsQuery = fieldsQuery + ', ' + strParentFields;
        }
        
        // Complete the parent fields query
        fieldsQuery = fieldsQuery + ' FROM ' + currObjName + ' WHERE Id = \'' + licenseId + '\'';
        system.debug('fieldsQuery: ' + fieldsQuery);
        // Execute query
        currObj = Database.query(fieldsQuery);

        // Add show = true/false
        for(QuestionObj queObj : questionsList) {
            system.debug('line number 315'+currObjName);
            system.debug('line number 316'+queObj.parentFieldObject);
            // If current object is the parent object name
            if(queObj.parentFieldObject == currObjName) {

                // If parent field is also set
                if(queObj.parentField != null) {
                    
                    // If parent parent field response is as expected
                    if(queObj.qualifyingResponseForField == (Boolean)currObj.get(queObj.parentField)) {
                        queObj.show = true;
                    }
                    // If parent field response is not as expected
                    else {
                        queObj.show = false;
                    }
                }
                // If parent fields is not set
                else {
                    queObj.show = true;
                }
            }
            // If some other object is the parent object name
            else if(queObj.parentFieldObject != null) {
                queObj.show = true;
            }
            // No parent field
            else {
                queObj.show = true;
            }
            system.debug('line number 343'+queObj);
            system.debug('line 344'+queObj.show);
            for(ChildQuestionObj cQueObj : queObj.childQueList) {

                // If current object is the parent object name
                if(cQueObj.parentFieldObject == currObjName) {

                    // If parent field is also set
                    if(cQueObj.parentField != null) {

                        // If parent parent field response is as expected
                        if(cQueObj.qualifyingResponseForField == (Boolean)currObj.get(cQueObj.parentField)) {
                            cQueObj.show = true;
                        }
                        // If parent field response is not as expected
                        else {
                            cQueObj.show = false;
                        }
                    }
                    // If parent fields is not set
                    else {
                        cQueObj.show = true;
                    }
                }
                // If some other object is the parent object name
                else if(cQueObj.parentFieldObject != null) {
                    cQueObj.show = false;
                }
                // No parent field
                else {
                    cQueObj.show = true;
                }
            }
            // Added by Shiva to Handle the Show Hide functionality for Group Questions 
            if(!queObj.Map_Of_AnswerGroup_childQuestionsGroup.isEmpty())
            {
                
                for(string AnswerGroup: queObj.Map_Of_AnswerGroup_childQuestionsGroup.keyset())
                {
                    for(Questionsgroup quesGrp:queObj.Map_Of_AnswerGroup_childQuestionsGroup.get(AnswerGroup))
                    {
                        // If current object is the parent object name
                        if(quesGrp.parentFieldObject == currObjName) {
                            system.debug('at 677'+quesGrp.parentField);
                            // If parent field is also set
                            if(quesGrp.parentField != null) {
        
                                system.debug('at 655'+quesGrp.qualifyingResponseForField+' = '+(Boolean)currObj.get(quesGrp.parentField));
                                // If parent parent field response is as expected
                                if(quesGrp.qualifyingResponseForField == (Boolean)currObj.get(quesGrp.parentField)) {
                                    quesGrp.show = true;
                                }
                                // If parent field response is not as expected
                                else {
                                    quesGrp.show = false;
                                }
                            }
                            // If parent fields is not set
                            else {
                                quesGrp.show = true;
                            }
                        }
                        // If some other object is the parent object name
                        else if(quesGrp.parentFieldObject != null) {
                            quesGrp.show = false;
                        }
                        // No parent field
                        else {
                            quesGrp.show = true;
                        }
                    }
                }
            }
            
        }
    }
    /**
     * Class for representing Questions object
     * @version     1.0
     */
    public class QuestionObj {

        // Global variables
        public String id {get; set;}
        public String dataType {get; set;}
        public String applicationType {get; set;}
        public String applicationMethod {get; set;}
        public String credentialType {get; set;}
        public String credential {get; set;}
        public String permitType {get; set;}
        public String programArea {get; set;}
        public String questionBody {get; set;}
        public String parentQuestion {get; set;}
        public String parentField {get; set;}
        public String externalId {get; set;}
        public String parentFieldObject {get; set;}
        public String qualifyingResponse {get; set;}
        public String qualifyingResponseForComment {get; set;}
        public Boolean qualifyingResponseForField {get; set;}
        public Boolean show {get; set;}
        public List<ChildQuestionObj> childQueList {get; set;}
        public List<QuestionsGroup> GroupQuestionsList {get;set;}
        public Map<String,List<QuestionsGroup>> Map_Of_AnswerGroup_childQuestionsGroup {get;set;}
        public String Map_Of_AnswerGroup_childQuestionsGroup_JSON {get;set;}
        public List<String> possibleResponses {get; set;}
        public String answerId {get; set;}
        public String answerText {get; set;}
        public String answerComment {get; set;}
        public String QuestionGroup {get;set;}
        public Boolean AllowQuestionGroups{get;set;}

        /**
         * Constructor
         * @param      id,  dataType,  applicationType,  applicationMethod,  credentialType,  credentail, permitType,  programArea,
                        questionBody,  parentQuestion,  parentField,  parentFieldObject,  qualifyingResponse, 
                        externalId, qualifyingResponseForComment,  qualifyingResponseForField,  quesList,  possibleResponse
                        ,QuestionGroup, AllowQuestionGroups
         */    
        public QuestionObj(String id, String dataType, String applicationType, String applicationMethod, String credentialType, String credentail, 
                         String permitType, String programArea,
            String questionBody, String parentQuestion, String parentField, String parentFieldObject, String qualifyingResponse, 
            String externalId,String qualifyingResponseForComment, String qualifyingResponseForField, List<Question__c> quesList, String possibleResponse
            , String QuestionGroup,Boolean AllowQuestionGroups) { 

                       
            // Set global variables
            this.id = id;
            this.externalId=externalId;
            this.dataType = dataType;
            this.applicationType = applicationType;
            this.applicationMethod = applicationMethod;
            this.credentialType = credentialType;
            this.credential = credential;
            this.permitType = permitType;
            this.programArea = programArea;
            this.questionBody = questionBody;
            this.parentQuestion = parentQuestion;
            this.parentField = parentField;
            this.parentFieldObject = parentFieldObject;
            this.qualifyingResponse = qualifyingResponse;
            this.qualifyingResponseForComment = qualifyingResponseForComment;
            this.QuestionGroup = QuestionGroup;
            this.AllowQuestionGroups = AllowQuestionGroups;
            if(qualifyingResponseForField != null) {
                this.qualifyingResponseForField = Boolean.valueOf(qualifyingResponseForField);
            }
            this.possibleResponses = new List<String>();
            try {
                if(dataType == label.Str_Picklist) {
                    this.possibleResponses = possibleResponse.split(';');
                }
            }
            catch(Exception e) {
                System.debug('--->Error creating possible responses. ' + e);
            }
            
            // Initialize child questions list
            this.childQueList = new List<ChildQuestionObj>();
            
            //Initialize Map of Group Questions 
            this.Map_Of_AnswerGroup_childQuestionsGroup = new map<string,List<QuestionsGroup>>();

            system.debug('this id at 509'+this.id);
            
            //Set child questions
            for(Question__c queObj : quesList) {
                if(queObj.Parent_Question__c == this.id && !queObj.Allow_Multiple_Question_Groups__c && queObj.Question_Group__c == null) {
                    if(queObj.Parent_Question__r.Effective_Date__c!=null && queObj.Parent_Question__r.End_Date__c!=null && system.today()>=queObj.Parent_Question__r.Effective_Date__c && system.today()<=queObj.Parent_Question__r.End_Date__c)
                    {
                        if(queObj.Parent_Question__c == this.id) {
                            this.childQueList.add(new ChildQuestionObj(queObj.Id, queObj.Data_Type__c, queObj.Application_type__c, 
                            queObj.Application_Method__c, queObj.Credential_Type__c, queObj.Credential__c, queObj.Permit_Type__c, queObj.Program_Area__c,
                            queObj.Question_Body__c, queObj.Parent_Question__c, 
                            queObj.Triggering_Field_API_Name__c, queObj.Parent_Object_API_Name__c, queObj.Triggering_Parent_Answer__c, 
                            queObj.external_id__C,queObj.Triggering_Comment_Box_Value__c, queObj.Triggering_Field_Value__c, 
                            queObj.Possible_Responses__c));
                        }
                    }
                    else if(queObj.Parent_Question__r.End_Date__c==null)
                    {
                        if(queObj.Parent_Question__c == this.id) {
                            this.childQueList.add(new ChildQuestionObj(queObj.Id, queObj.Data_Type__c, queObj.Application_type__c, 
                            queObj.Application_Method__c, queObj.Credential_Type__c, queObj.Credential__c, queObj.Permit_Type__c, queObj.Program_Area__c, 
                            queObj.Question_Body__c, queObj.Parent_Question__c, 
                            queObj.Triggering_Field_API_Name__c, queObj.Parent_Object_API_Name__c, queObj.Triggering_Parent_Answer__c, 
                            queObj.external_id__C,queObj.Triggering_Comment_Box_Value__c, queObj.Triggering_Field_Value__c, 
                            queObj.Possible_Responses__c));
                        }
                    }
                }
                
            }
            
            
        }
    }
    
    /**
      * Inner wrapper class representing Question Group
     */
    public class QuestionsGroup { 
      // Global variables
        public String id {get; set;}
        public String dataType {get; set;}
        public String applicationType {get; set;}
        public String applicationMethod {get; set;}
        public String credentialType {get; set;}
        public String credential {get; set;}
        public String permitType {get; set;}
        public String programArea {get; set;}
        public String questionBody {get; set;}
        public String parentQuestion {get; set;}
        public String parentField {get; set;}
        public String parentFieldObject {get; set;}
        public String qualifyingParentResponse {get; set;}
        public String qualifyingResponseForComment {get; set;}
        public Boolean qualifyingResponseForField {get; set;}
        public Boolean show {get; set;}
        public String answerId {get; set;}
        public String externalId {get; set;}
        public String answerText {get; set;}
        public String answerComment {get; set;}
        public List<String> possibleResponses {get; set;}   
        public String AnswerGroup {get; set;}
        
        /**
         * Constructor
         * @param      id,  dataType,  applicationType,  applicationMethod,  credentialType,  credentail, permitType,  programArea,
                         questionBody,  parentQuestion,  parentField,  parentFieldObject,  qualifyingParentResponse, 
                         externalId, qualifyingResponseForComment,  qualifyingResponseForField,  possibleResponse
         */ 
         
         public QuestionsGroup(String id, String dataType, String applicationType, String applicationMethod, String credentialType, String credentail, 
                         String permitType, String programArea,
            String questionBody, String parentQuestion, String parentField, String parentFieldObject, String qualifyingParentResponse, 
            String externalId,String qualifyingResponseForComment, String qualifyingResponseForField, String possibleResponse) {

            // Set global variables
            this.id = id;
            this.dataType = dataType;
            this.externalId=externalId;
            this.applicationType = applicationType;
            this.applicationMethod = applicationMethod;
            this.credentialType = credentialType;
            this.credential = credential;
            this.permitType = permitType;
            this.programArea = programArea;
            this.questionBody = questionBody;
            this.parentQuestion = parentQuestion;
            this.parentField = parentField;
            this.parentFieldObject = parentFieldObject;
            this.qualifyingParentResponse = qualifyingParentResponse;
            this.qualifyingResponseForComment = qualifyingResponseForComment;
            if(qualifyingResponseForField != null) {
                this.qualifyingResponseForField = Boolean.valueOf(qualifyingResponseForField);
            }
            this.possibleResponses = new List<String>();
            try {
                if(dataType == label.Str_Picklist) {
                    this.possibleResponses = possibleResponse.split(';');
                }
            }
            catch(Exception e) {
                System.debug('--->Error creating possible responses. ' + e);
            }
        }
        
    }

    /**
     * Class representing Child Questions object
     * @version     1.0
     */
    public class ChildQuestionObj {

        // Global variables
        public String id {get; set;}
        public String dataType {get; set;}        
        public String externalId{get; set;}
         public String applicationType {get; set;}
        public String applicationMethod {get; set;}
        public String credentialType {get; set;}
        public String credential {get; set;}
        public String permitType {get; set;}
        public String programArea {get; set;}
        public String questionBody {get; set;}
        public String parentQuestion {get; set;}
        public String parentField {get; set;}
        public String parentFieldObject {get; set;}
        public String qualifyingParentResponse {get; set;}
        public String qualifyingResponseForComment {get; set;}
        public Boolean qualifyingResponseForField {get; set;}
        public Boolean show {get; set;}
        public String answerId {get; set;}
        public String answerText {get; set;}
        public String answerComment {get; set;}
        public List<String> possibleResponses {get; set;}

        /**
         * Constructor
         * @param      id,  dataType,  applicationType,  applicationMethod,  credentialType,  credentail,permitType,  programArea,
                     questionBody,  parentQuestion,  parentField,  parentFieldObject,  qualifyingParentResponse, 
                     externalId, qualifyingResponseForComment,  qualifyingResponseForField,  possibleResponse
         */   
        public ChildQuestionObj(String id, String dataType, String applicationType, String applicationMethod, String credentialType, String credentail, 
                         String permitType, String programArea,
            String questionBody, String parentQuestion, String parentField, String parentFieldObject, String qualifyingParentResponse, 
            String externalId,String qualifyingResponseForComment, String qualifyingResponseForField, String possibleResponse) {

            // Set global variables
            this.id = id;
                this.externalId=externalId;
            this.dataType = dataType;
            this.applicationType = applicationType;
            this.applicationMethod = applicationMethod;
            this.credentialType = credentialType;
            this.credential = credential;
            this.permitType = permitType;
            this.programArea = programArea;
            this.questionBody = questionBody;
            this.parentQuestion = parentQuestion;
            this.parentField = parentField;
            this.parentFieldObject = parentFieldObject;
            this.qualifyingParentResponse = qualifyingParentResponse;
            this.qualifyingResponseForComment = qualifyingResponseForComment;
            if(qualifyingResponseForField != null) {
                this.qualifyingResponseForField = Boolean.valueOf(qualifyingResponseForField);
            }
            this.possibleResponses = new List<String>();
            try {
                if(dataType == label.Str_Picklist) {
                    this.possibleResponses = possibleResponse.split(';');
                }
            }
            catch(Exception e) {
                System.debug('--->Error creating possible responses. ' + e);
            }
        }
    }
}