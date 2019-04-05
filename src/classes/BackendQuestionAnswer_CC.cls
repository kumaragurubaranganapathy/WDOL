/**
* User Story: 209 - Questions Framework
* Class Name: BackendQuestionAnswer_CC
* Test Class Name: BackendQuestionAnswer_CC_Test
* Description: This class serves as backend controller for Question Answer Data
* Date:        Developer/Company                    Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 07/16/2018   Sharad Maheshwari/Deloitte           Initial Creation
**/

public with sharing class BackendQuestionAnswer_CC {

    public string RecordId {
        get;
        set;
    }
    public string ObjectName {
        get;
        set;
    }
    public boolean isCredentialRenewal {get;set;}
    public boolean isCredentialReinstatement {get;set;}
    public boolean isPermitRenewal {get;set;}
    public boolean savemode {
        get;
        set;
    }
    public boolean editmode {
        get;
        set;
    }
    public boolean firstRun {
        get;
        set;
    }
    public List < QuestionObj > Questions {
        get;
        set;
    }
    public String showFor='';
    
    List < Question__c > quesList = new List < Question__c > ();
    public Map < String, Answer__c > mapQuesIdAnswer = new Map < String, Answer__c > ();

    public Map < String, List < Answer__c >> mapQuestionIdAnswerList = new Map < String, List < Answer__c >> (); //added for maintaining mulitple answers for a single question 
    public String debugVal {
        get;
        set;
    }
    public List < Answer__c > AnswerList = new List < Answer__c > ();
    public Map < Id, List < Question__c >> ParentQuestion_QuestionGroupMap {
        get;
        set;
    } 
    public Map < String, List < Question__c >> Map_Of_AnswerGroup_QuestionsGroup {
        get;
        set;
    } 
    public integer QuestionsIterator {
        get;
        set;
    } 
    public integer SubQuestionIterator {
        get;
        set;
    } 
    public set < string > ApplicationStatusSet = new set < String > {
        label.ST_Pending,
        label.ST_Incomplete
    }; 
    DateTime AppCreatedDate; 
    Date AttestationDate; 
    String ApplicationStatus;

    public MUSW__License2__c license {
        get {
            if(license == null) license = new MUSW__License2__c();
            return license;
        }
        set;
    }
    public MUSW__Permit2__c permit {
        get {
            if(permit == null) permit = new MUSW__Permit2__c();
            return permit;
        }
        set;
    }
    public Renewal_Application__c Renewal {         
        get {
            if(Renewal == null) Renewal = new Renewal_Application__c();
            return Renewal;
        }
        set;
    }
    public MUSW__Review__c Review {
        get {
            if(Review == null) Review = new MUSW__Review__c();
            return Review;
        }
        set;

    }
    
    public MUSW__Application2__c ServiceRequest {
        get {
            if(ServiceRequest == null) ServiceRequest = new MUSW__Application2__c();
            return ServiceRequest;
        }
        set;
    }
/***************************************************************************************************
* @Description : QuestionsGroup Constructor
* @Param       : 
* @Return      : 
****************************************************************************************************/
    public BackendQuestionAnswer_CC() {
        Questions = new List < QuestionObj > ();
        savemode = true;
        editmode = false;
        firstRun = true;
        ApplicationStatus = ''; 

        ParentQuestion_QuestionGroupMap = new Map < Id, List < Question__c >> (); 
        mapQuestionIdAnswerList = new Map < String, List < Answer__c >> (); 
        Map_Of_AnswerGroup_QuestionsGroup = new Map < String, List < Question__c >> (); 
    }
    
/***************************************************************************************************
    * @Description : Method to enable Edit mode 
    * @Param       : 
    * @Return      : NA
****************************************************************************************************/
    
    public void edit() {
        savemode = false;
        editmode = true;

        for(QuestionObj quesObj: Questions) {
            if(quesObj.Map_Of_AnswerGroup_childQuestionsGroup!=null && quesObj.Map_Of_AnswerGroup_childQuestionsGroup.size() > 1) {
                quesObj.ShowDeleteGroupButton = true;
            }

        }
    }

    Set < String > fieldsToExclude = new Set < String > {
        label.API_LastModifiedDate,
        label.Api_IsDeleted,
        label.API_LastViewedDate,
        label.API_LastReferencedDate,
        label.API_Name,
        label.API_SystemModstamp,
        label.API_CreatedById,
        label.API_LastModifiedById
    };

/***************************************************************************************************
    * @Description : Method to initialize component
    * @Param       : 
    * @Return      : NA
****************************************************************************************************/
        
    public void initializeComponent() {
        firstRun = false;
        debugVal = objectName;

        if(objectname == null || objectname == '') {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, label.Str_Type_not_provided));
            return;
        }
        System.debug('objectName '+objectName);
        System.debug('isPermitRenewal '+isPermitRenewal);
        selectObject();
        buildQuestionsList();
        checkQuestionsVisibility();
        updateResponseLists();
    }
    
/***************************************************************************************************
    * @Description : 
    * @Param       : 
    * @Return      : 
****************************************************************************************************/
    
    public void selectObject() {
        System.debug('in Select Object');
        System.debug('objectname' +objectname);
        try{            
        if(objectname == null || objectname == '') {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, label.Str_Type_not_provided));
            return;
        }else if(objectname == Label.Str_License) {
            showFor = Label.Str_Credential;
        }else if(objectname == Label.RNT_Renewal && isCredentialRenewal) {
            showFor = Label.Str_Credential_Renewal;
        }else if(objectname == Label.RNT_Renewal && isCredentialReinstatement) {
            showFor = Label.Str_Credential_Reinstatement;
        }else if(objectname == Label.Str_Permit || objectName == Label.Str_Plan_Review) {
            showFor = Label.Str_Permit;
        }else if(objectname == Label.RNT_Renewal && isPermitRenewal) {
            showFor = Label.Str_Permit_Renewal;
        }/*else if(objectname == Label.RNT_Renewal && isPermitReinstatement) {
            showFor = Label.Str_Permit_Reinstatement;
        }*/
            System.debug('showFor' +showFor);
                                    
        string Query = 'SELECT Id, External_Id__c, Name, Parent_Object_API_Name__c, Data_Type__c, Display_Style__c, Credential_Type__c, '+
                        'Parent_Question__c, Possible_Responses__c, Previous_Question_Version__c, Qualifying_Response__c, Question_Body__c, '+
                        'Allow_Multiple_Question_Groups__c, Question_Group__c, Child_Question_Group__c,' +
                        ' Status__c, Version__c, Order_Number__c, Application_Type__c, Triggering_Field_API_Name__c, Triggering_Field_Value__c, '+
                        'Triggering_Parent_Answer__c, Effective_Date__c,End_Date__c,Triggering_Comment_Box_Value__c FROM Question__c  WHERE status__c = \'Active\'' +
                        ' and Show_For__c includes (\'' + showFor + '\') and record_type_name__c!=\'Eligibility questions\'';
        System.debug('Query '+ Query); 
                
        String ansQuery = 'SELECT Id, External_id_of_Question__c, Parent_Question_External_Id__c, Answer_Group__c, '+
                          'Question_Group__c,Name, Answer_Text__c, Comment__c, License__c,  Question__c, '+
                          'Question_Body__c, Submitted_By_Portal_User__c FROM Answer__c WHERE ';
        System.debug('Query '+ Query);            
        //Todo
            //App_Generate_Fee_Date__c, License_Renewal__c,Review__c,Service_Request__c,
        //
        if(objectName == label.Str_License) {
            List < String > lstFields = Utilities.getAllFieldsSObject(label.API_License2, fieldsToExclude);
            String strFields = String.join(lstFields, ', ');

            string LicenseQuery = 'select  Id, createddate, Attestation_Date__c, MUSW__Status__c, Application_Type__c, Credential_Type__c, Credential__c, Application_Method__c From MUSW__License2__c where id = \'' + RecordId + '\' limit 1';
            license = Database.query(LicenseQuery);
            System.debug('license-- '+license);
            AppCreatedDate = license.createddate; 
            AttestationDate = license.Attestation_Date__c; 
            ApplicationStatus = license.MUSW__Status__c;
                
            Query += ' and Credential_Type__c = \'' + String.escapeSingleQuotes(license.Credential_Type__c) + 
                    '\' and Credential__c = \'' + + String.escapeSingleQuotes(license.Credential__c) +
                    '\' AND ( Application_Method__c = \'All\' or Application_Method__c = \'' + license.Application_Method__c + '\')';
            ansQuery += 'License__c ';
        }else if(objectName == label.Str_Permit) {
            /*List < String > lstFields = Utilities.getAllFieldsSObject(label.API_License2, fieldsToExclude);
            String strFields = String.join(lstFields, ', ');
            */
            string PermitQuery = 'select  Id, createddate, Attestation_Date__c, MUSW__Status__c, Application_Type__c, Program_Area__c, Permit_Type__c From MUSW__Permit2__c where id = \'' + RecordId + '\' limit 1';
            permit = Database.query(PermitQuery);

            AppCreatedDate = permit.createddate; 
            AttestationDate = permit.Attestation_Date__c; 
            ApplicationStatus = permit.MUSW__Status__c;

            Query += ' and Permit_Type__c = \'' + String.escapeSingleQuotes(permit.Permit_Type__c) + 
                    '\' and Program_Area__c = \'' + String.escapeSingleQuotes(permit.Program_Area__c) + '\'';
            ansQuery += 'Permit__c ';
        }
        /* Todo
         * if(objectName == label.Obj_Review) {
            List < String > lstFields = Utilities.getAllFieldsSObject(label.API_Review, fieldsToExclude);
            String strFields = String.join(lstFields, ', ');

            Review = Database.query('Select Id,MUSW__Application2__c,CE_Exam_Lookup_to_Review__c,Continuing_Education_Lookup_to_Review__c,License2__c,License_Renewal__c From MUSW__Review__c where Id =: RecordId');
            Query += ' and Application_Type__c = \'' + review.Application_Type__c + '\'';
            ansQuery += 'Review__c ';
        }*/
        
            
        
        if(objectName == 'Service Request') {
            List < String > lstFields = Utilities.getAllFieldsSObject(label.API_Application, fieldsToExclude);
            String strFields = String.join(lstFields, ', ');

            ServiceRequest = Database.query('Select Id,License2__c,MUSW__Status__c,MUSW__Type__c From MUSW__Application2__c where Id =: RecordId');
            if(ServiceRequest.Application_Type__c != null && ServiceRequest.Application_Type__c != ''){
                Query += ' and (Application_Type__c = \'' + ServiceRequest.Application_Type__c + '\')';
                Query += 'and (Service_Request_Type__c = \'' + ServiceRequest.Application_Type__c + '\')';
            }
            AppCreatedDate = System.today();  
            AttestationDate = System.today(); 
            ApplicationStatus = ServiceRequest.MUSW__Status__c;  
            
            ansQuery += 'Service_Request__c';
        }
            if(objectName == label.RNT_Renewal && (isCredentialRenewal || isCredentialReinstatement)) {
             System.debug('in if renewal/reinstatement');
            //List < String > lstFields = Utilities.getAllFieldsSObject(label.API_Renewal_Application, fieldsToExclude);
            //String strFields = String.join(lstFields, ', ');
            
            string renewalQuery = 'Select Id,createddate,Credential__c, Credential_Type__c, Attestation_Date__c,License__c ,Renewal_status__c,Renewal_Reinstatement_Type__c From Renewal_Application__c where Id = \'' + RecordId + '\' limit 1';
            System.debug('renewalQuery '+renewalQuery);
            Renewal = Database.query(renewalQuery);
            System.debug('Renewal.Renewal_status__c '+Renewal.Renewal_status__c);            

            AppCreatedDate = Renewal.createddate;
            AttestationDate = Renewal.Attestation_Date__c;

            if(Renewal.Renewal_status__c != null) {
                ApplicationStatus = Renewal.Renewal_status__c;
            }
                system.debug('renewal.Credential_Type__c '+renewal.Credential_Type__c);
                system.debug('renewal.Credential__c '+renewal.Credential__c);
            Query += ' and Credential_Type__c = \'' + String.escapeSingleQuotes(renewal.Credential_Type__c) + 
                    '\' and Credential__c = \'' + String.escapeSingleQuotes(renewal.Credential__c) + '\'';
                System.debug('printing query '+Query);
             ansQuery += 'Renewal_Application__c ';
        }
            if(objectName == label.RNT_Renewal && isPermitRenewal) {
             System.debug('in if permit renewal/reinstatement');
            //List < String > lstFields = Utilities.getAllFieldsSObject(label.API_Renewal_Application, fieldsToExclude);
            //String strFields = String.join(lstFields, ', ');
            
            string renewalQuery = 'Select Id,createddate, Application_Type__c, Program_Area__c, Permit_Type__c, Attestation_Date__c,Permit__c ,Renewal_status__c,Renewal_Reinstatement_Type__c From Renewal_Application__c where Id = \'' + RecordId + '\' limit 1';
            System.debug('renewalQuery '+renewalQuery);
            Renewal = Database.query(renewalQuery);
            System.debug('Renewal.Renewal_status__c '+Renewal.Renewal_status__c);            

            AppCreatedDate = Renewal.createddate;
            AttestationDate = Renewal.Attestation_Date__c;

            if(Renewal.Renewal_status__c != null) {
                ApplicationStatus = Renewal.Renewal_status__c;
            }
            Query += ' and Permit_Type__c = \'' + String.escapeSingleQuotes(renewal.Permit_Type__c) + 
                    '\' and Program_Area__c = \'' + String.escapeSingleQuotes(renewal.Program_Area__c) + '\'';
             ansQuery += 'Renewal_Application__c ';
        }

        ansQuery += ' = :RecordId';
        System.debug('Answer Query - backendquestionanaswer '+ansQuery);            
        System.debug('Question Query - backendquestionanaswer '+Query);            
            
        quesList = Database.query(Query);
        System.debug('quesList '+quesList);
        //added as a part of Enhancement
        if(quesList.size()>0){
        for(Question__c ques: quesList) {
            System.debug('ques.Parent_Question__c '+ques.Parent_Question__c);
            System.debug('ques.Parent_Question__c '+ques.Parent_Question__c);
            System.debug('ques.Allow_Multiple_Question_Groups__c '+ques.Allow_Multiple_Question_Groups__c);
            System.debug('ques.Child_Question_Group__c '+ques.Child_Question_Group__c);
            System.debug('ques.ID '+ques.Id);
            if(ques.Parent_Question__c != null && ques.Allow_Multiple_Question_Groups__c && ques.Child_Question_Group__c != null) {
                if(!ParentQuestion_QuestionGroupMap.containskey(ques.Parent_Question__c)) {
                    ParentQuestion_QuestionGroupMap.put(ques.Parent_Question__c, new List < Question__c > ());
                }
                ParentQuestion_QuestionGroupMap.get(ques.Parent_Question__c).add(ques);
            }
        }
    }
        //end ofcode for Question Group

        // Get all answers for this license id
        AnswerList = Database.query(ansQuery);
        if(AnswerList.size()>0){
        for(Answer__c answer: AnswerList) {
            if(answer.Answer_Group__c != null) {
                //This will get list of all the answers for a single question 
                if(!mapQuestionIdAnswerList.containsKey(answer.External_id_of_Question__c)) {
                    mapQuestionIdAnswerList.put(answer.External_id_of_Question__c, new List < Answer__c > ());
                }
                mapQuestionIdAnswerList.get(answer.External_id_of_Question__c).add(answer);

            }
            mapQuesIdAnswer.put(answer.External_id_of_Question__c, answer);
        }
        }
        }
        catch(exception e){
            ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'BackendQuestionAnswer', null, 'selectObject', 'BackendQuestionAnswer', 'High');
        }
    }

/***************************************************************************************************
    * @Description : Build question. This forms a list of Questions Wrapper object which contains 3 things: 
                     1. Parent Questions 
                     2. Normal Child Questions
                     3. Child Group Question which is a sub warpper Object for Questions Object 
    * @Param       : 
    * @Return      : NA
****************************************************************************************************/    
    public void buildQuestionsList() {
        
        try{
            Questions = new List < QuestionObj > ();
            for(Question__c queObj: quesList) {
            //TODO: add question add logic  
                if(isValidVersion(queObj)) {
                // Loop throug only questions that do not have a value populated in Child_Question_Group__c
                // ParentQuestion_QuestionGroupMap will help us get the GrouQuestions Associated with a single Parent Question
                    if(queObj.Child_Question_Group__c == null) {
                        //This list will be used for each parent question to form the child Question Group. This list will be initailed for each question in the loop
                        List < Question__c > ChildGroupQuestions = new List < Question__c > (); //List of Group Question__c records for a parent Question
                        QuestionObj queRow = new QuestionObj(queObj, queObj.Id, integer.valueof(queobj.Order_Number__c), true); //Form the parent Question First
                        queRow.ChildQuestionsGroup = new List < QuestionsGroup > ();
                        queRow.Map_Of_AnswerGroup_childQuestionsGroup = new Map < String, List < QuestionsGroup >> ();
                        //This will make sure its gets all child group questions are fetched for a parent.  
                        if(ParentQuestion_QuestionGroupMap.containskey(queObj.Id)) {
                        //Populate the ChildGroup Question for its corresponding Parent
                        ChildGroupQuestions.addAll(ParentQuestion_QuestionGroupMap.get(queObj.Id));
                        if(!ChildGroupQuestions.isEmpty()) {
                            queRow.AllowQuestionGroups = true;

                            for(Question__c GroupQuestion: ChildGroupQuestions) {
                                if(isValidVersion(GroupQuestion)) {
                                    List < Answer__c > AnswerGroup = new List < Answer__c > (); //List of all the answers for a parent Question
                                    //Below block forms, Question Obj, Its assoacited Questions Group and answers related to Question Group
                                    if(!mapQuestionIdAnswerList.isEmpty() && mapQuestionIdAnswerList.containskey(GroupQuestion.External_Id__c)) {
                                        AnswerGroup = mapQuestionIdAnswerList.get(GroupQuestion.External_Id__c);
                                        if(!AnswerGroup.isEmpty()) {
                                            for(Answer__c GroupQuestionAnswer: AnswerGroup) {
                                                QuestionsGroup GroupQuestionRow = new QuestionsGroup(GroupQuestion, GroupQuestion.Id, integer.valueof(GroupQuestion.Order_Number__c), false);
                                                GroupQuestionRow.Answer = GroupQuestionAnswer;
                                                GroupQuestionRow.selectedvalue = GroupQuestionAnswer.Answer_Text__c;
                                                GroupQuestionRow.answerComment = GroupQuestionAnswer.Comment__c;
                                                GroupQuestionRow.AnswerGroup = GroupQuestionAnswer.Answer_Group__c;

                                                if(GroupQuestionAnswer.Answer_Group__c != null) {
                                                    //Map_Of_AnswerGroup_childQuestionsGroup is a very important variable.
                                                    // It has AnswerGroup as a map and list of ChildQuestion Group as value. 
                                                    // This variable ensures the differentiation between answerGroups   
                                                    if(!queRow.Map_Of_AnswerGroup_childQuestionsGroup.containsKey(GroupQuestionAnswer.Answer_Group__c)) {
                                                        queRow.Map_Of_AnswerGroup_childQuestionsGroup.put(GroupQuestionAnswer.Answer_Group__c, new List < QuestionsGroup > ());
                                                    }
                                                    queRow.Map_Of_AnswerGroup_childQuestionsGroup.get(GroupQuestionAnswer.Answer_Group__c).add(GroupQuestionRow);
                                                }
                                            }
                                            queRow.renderChildGroupQuestions = true;
                                        }
                                    }
                                    else {
                                        if(!queRow.Map_Of_AnswerGroup_childQuestionsGroup.containsKey(GroupQuestion.Child_Question_Group__c + '-1')) {
                                            queRow.Map_Of_AnswerGroup_childQuestionsGroup.put(GroupQuestion.Child_Question_Group__c + '-1', new List < QuestionsGroup > ());
                                        }
                                        QuestionsGroup GroupQuestionRow = new QuestionsGroup(GroupQuestion, GroupQuestion.Id, integer.valueof(GroupQuestion.Order_Number__c), false);
                                        queRow.Map_Of_AnswerGroup_childQuestionsGroup.get(GroupQuestion.Child_Question_Group__c + '-1').add(GroupQuestionRow);
                                        queRow.ChildQuestionsGroup.add(GroupQuestionRow);
                                        queRow.renderChildGroupQuestions = false;
                                    }

                                }
                            }
                            if(!queRow.ChildQuestionsGroup.isEmpty())
                                queRow.ChildQuestionsGroup.sort();
                        }

                    }
                    // End of logic for Question Grouping 

                    Answer__c ansObj = mapQuesIdAnswer.get(queObj.External_Id__c);
                    if(ansObj != null){
                        queRow.Answer = ansObj;
                        queRow.selectedvalue = ansObj.Answer_Text__c;
                        queRow.answerComment = ansObj.Comment__c;
                    }
                    if (queObj.Triggering_Comment_Box_Value__c != null) {
                        queRow.lstCommentResponses = queObj.Triggering_Comment_Box_Value__c.split(';');
                    }

                    Questions.add(queRow);
                    //}

                }
            }

        }
 
        Map<Id, List<QuestionObj>>  mapping = new Map<Id, List<QuestionObj>> ();
        for(QuestionObj a: Questions)
        {
           System.debug('a.id '+a);
        }
        Questions.sort();
         for(QuestionObj a: Questions)
        {
           System.debug('b.id '+a);
        }
        }catch(exception e){
          ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'BackendQuestionAnswer', null, 'buildQuestionsList', 'BackendQuestionAnswer', 'High');
        }
        
    }
   
/***************************************************************************************************
    * @Description : Method used to check question Versioning. Determines whether a question can be show or not on the back office component
    * @Param       : 
    * @Return      : NA
****************************************************************************************************/
    public boolean isValidVersion(Question__c queObj) {
        
        try{
            Boolean validVersion = false;
            // start of logic for Question Versioning 
            if(queObj.Effective_Date__c != null && queObj.End_Date__c != null) {
                if(ApplicationStatusSet.contains(ApplicationStatus)) {
                    if(system.today() >= queObj.Effective_Date__c && system.today() <= queObj.End_Date__c) {
                    //
                        validVersion = true;
                    }
                }
                else {
                if(AttestationDate != null && AttestationDate >= queObj.Effective_Date__c && AttestationDate <= queObj.End_Date__c) {
                    //Questions.add(addQuestionRow(queObj));
                    validVersion = true;
                }
                else if(AttestationDate == null && AppCreatedDate >= queObj.Effective_Date__c && AppCreatedDate <= queObj.End_Date__c) {
                    //Questions.add(addQuestionRow(queObj));
                    validVersion = true;
                }
            }

        }
            else if(queObj.Effective_Date__c!=null && queObj.End_Date__c==null)
            {
                if(ApplicationStatusSet.contains(ApplicationStatus))
                {
                    if(system.today()>=queObj.Effective_Date__c)
                    {
                    validVersion = true; 
                    }
                }
            else {
                    if(AttestationDate!=null && AttestationDate>=queObj.Effective_Date__c)
                    {
                        validVersion = true;
                    }
                    else if(AttestationDate == null && AppCreatedDate>=queObj.Effective_Date__c)
                    {
                        validVersion = true;
                    }
            }
        }
            else if(queObj.Effective_Date__c==null && queObj.End_Date__c!=null)
            {
                if(ApplicationStatusSet.contains(ApplicationStatus))
                {
                    if(system.today()<=queObj.End_Date__c)
                    {
                        validVersion = true;
                    }
                }
                else {
                    if(AttestationDate!=null && AttestationDate<=queObj.End_Date__c)
                    {
                        validVersion = true;
                    }
                    else if(AttestationDate == null && AppCreatedDate<=queObj.End_Date__c)
                    {
                        validVersion = true;
                    }
                }
                
            }
        else {
            //Questions.add(addQuestionRow(queObj));
            validVersion = true;
        }
        // End of logic for Question Versioning

        return validVersion;
        }catch(exception e){
            ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'BackendQuestionAnswer', null, 'isValidVersion', 'BackendQuestionAnswer', 'High');
            return null;
        }
        
    }
    
/***************************************************************************************************
    * @Description : Adds QuestionGroup for a parent Question Dynamically on click on Add Group Button 
                     1. Uses Question Iterator varaible from the page to get the current parent question in Loop
    * @Param       : 
    * @Return      : 
****************************************************************************************************/
    
    public void addQuestionsGroup() {
        if(QuestionsIterator != null) {

            Integer MapSize = Questions[QuestionsIterator].Map_Of_AnswerGroup_childQuestionsGroup.size();

            String AnsGroup = (new List < String > (Questions[QuestionsIterator].Map_Of_AnswerGroup_childQuestionsGroup.keyset())[MapSize - 1]);

            String NewAnswerGroup = '';
            if(MapSize > 1) {
                NewAnswerGroup = AnsGroup.split('-')[0] + '-' + String.valueOf(Integer.valueOf(AnsGroup.split('-')[1]) + 2);
            }
            else {
                NewAnswerGroup = AnsGroup.split('-')[0] + '-' + String.valueOf(Integer.valueOf(AnsGroup.split('-')[1]) + 1);
            }
            Questions[QuestionsIterator].ShowDeleteGroupButton = true;
            if(!Questions[QuestionsIterator].Map_Of_AnswerGroup_childQuestionsGroup.containsKey(NewAnswerGroup)) {
                Questions[QuestionsIterator].Map_Of_AnswerGroup_childQuestionsGroup.put(NewAnswerGroup, new List < QuestionsGroup > ());
            }
            for(QuestionsGroup GroupQuestion: Questions[QuestionsIterator].Map_Of_AnswerGroup_childQuestionsGroup.get(AnsGroup)) {
                QuestionsGroup newQuesGrp = new QuestionsGroup(GroupQuestion.question, GroupQuestion.question.Id, integer.valueof(GroupQuestion.question.Order_Number__c), false);

                Questions[QuestionsIterator].Map_Of_AnswerGroup_childQuestionsGroup.get(NewAnswerGroup).add(newQuesGrp);

                //Forms the response list for the child group Questions 

                UpdateChildGroupQuestionResponseList(Questions[QuestionsIterator]);
                //End of logic for forming the response list for Child Group Questions
            }

            checkQuestionsVisibility();
        }

    }

/***************************************************************************************************
    * @Description : Delete QuestionGroup for a parent Question Dynamically on click on Delete Group Button 
                     1. Uses Question Iterator varaible from the page to get the current parent question in Loop
    * @Param       : 
    * @Return      : NA
****************************************************************************************************/
    public void deleteQuestionsGroup() {
        List < Answer__c > ToBeDeletedAnswers = new List < Answer__c > ();
        if(QuestionsIterator != null && SubQuestionIterator != null) {
            Integer MapSize = Questions[QuestionsIterator].Map_Of_AnswerGroup_childQuestionsGroup.size();

            String AnsGroup = Questions[QuestionsIterator].question.Question_Group__c + '-' + String.valueOf((MapSize));
            String AnsGroupKey = (new List < String > (Questions[QuestionsIterator].Map_Of_AnswerGroup_childQuestionsGroup.keyset()))[SubQuestionIterator];
            if(Questions[QuestionsIterator].Map_Of_AnswerGroup_childQuestionsGroup.containsKey(AnsGroupKey)) {
                for(QuestionsGroup GroupQuestionRow: Questions[QuestionsIterator].Map_Of_AnswerGroup_childQuestionsGroup.get(AnsGroupKey)) {
                    if(GroupQuestionRow.Answer != null)
                        ToBeDeletedAnswers.add(GroupQuestionRow.Answer);
                }
                Questions[QuestionsIterator].Map_Of_AnswerGroup_childQuestionsGroup.remove(AnsGroupKey);
                MapSize = MapSize - 1;

            }

            if(MapSize == 1) {
                Questions[QuestionsIterator].ShowDeleteGroupButton = false;
            }

        }
        if(!ToBeDeletedAnswers.isEmpty() && Schema.sObjectType.Answer__c.isDeletable()) {
            try {
                delete ToBeDeletedAnswers;
            }
            catch(Exception ex) {
                ApexPages.addMessages(ex);
                ErrorLogger.logGeneralException(ex, UserInfo.getUserId(), 'BackendQuestionAnswer', null, 'deleteQuestionsGroup', 'BackendQuestionAnswer', 'High');
            }
        }
    }


/***************************************************************************************************
    * @Description : Method used to add Questions 
    * @Param       : Question__c queObj
    * @Return      : queRow
****************************************************************************************************/
    /*public QuestionObj addQuestionRow(Question__c queObj) {
        QuestionObj queRow = new QuestionObj(queObj, queObj.Id, integer.valueof(queobj.Order_Number__c), true);
        Answer__c ansObj = mapQuesIdAnswer.get(queObj.External_Id__c);
        if(ansObj != null) {
            queRow.Answer = ansObj;
            queRow.selectedvalue = ansObj.Answer_Text__c;
            queRow.answerComment = ansObj.Comment__c;
        }
        if(queObj.Triggering_Comment_Box_Value__c != null) {
            queRow.lstCommentResponses = queObj.Triggering_Comment_Box_Value__c.split(';');
        }

        return queRow;

    }*/

/***************************************************************************************************
    * @Description : Update the response list for Picklist type of Questions.  
    * @Param       : 
    * @Return      : 
****************************************************************************************************/
    public void updateResponseLists() {
        for(QuestionObj queObj: Questions) {
            if(queObj.lstAnswerOptions == null && queObj.question.Data_Type__c != null && (queObj.question.Data_Type__c).ToLowercase() != 'text' && queObj.question.Possible_Responses__c != null) {
                //Response list for Parent Question 
                queObj.lstAnswerOptions = new List < SelectOption > ();
                String ansRemovenewlines  = String.valueOf(queObj.question.Possible_Responses__c).normalizeSpace(); 
                List < String > ans = ansRemovenewlines.split(';');
                //List < String > ans = String.valueOf(queObj.question.Possible_Responses__c).split(';');
                queObj.lstAnswerOptions.add(new SelectOption('', ''));
                for(String a: ans) {
                    queObj.lstAnswerOptions.add(new SelectOption(a, a));
                }
                //End of response list for parent Question 

                //Forms the response list for the child group Questions 

                UpdateChildGroupQuestionResponseList(queObj);
                //End of logic for forming the response list for Child Group Questions 
            }
        }
    }

/***************************************************************************************************
    * @Description : Update the Child response list for Picklist type of Group Questions.  
    * @Param       : ParentQuestion Obj
    * @Return      : void
****************************************************************************************************/
    public void UpdateChildGroupQuestionResponseList(QuestionObj queObj) {
        if(queObj.Map_Of_AnswerGroup_childQuestionsGroup != null && queObj.Map_Of_AnswerGroup_childQuestionsGroup.size() > 0) {
            for(String AnsGroup: queObj.Map_Of_AnswerGroup_childQuestionsGroup.keyset()) {
                queObj.Map_Of_AnswerGroup_childQuestionsGroup.get(AnsGroup).sort();
                for(QuestionsGroup quesGrp: queObj.Map_Of_AnswerGroup_childQuestionsGroup.get(AnsGroup)) {
                    if(quesGrp.lstAnswerOptions == null && quesGrp.question.Data_Type__c != null && (quesGrp.question.Data_Type__c).ToLowercase() != 'text' && quesGrp.question.Possible_Responses__c != null) {
                        quesGrp.lstAnswerOptions = new List < SelectOption > ();
                        List < String > ansChild = String.valueOf(quesGrp.question.Possible_Responses__c).split(';');
                        quesGrp.lstAnswerOptions.add(new SelectOption('', ''));
                        for(String a: ansChild) {
                            quesGrp.lstAnswerOptions.add(new SelectOption(a, a));
                        }
                    }
                }
            }
        }
    }

/***************************************************************************************************
    * @Description : Check Question Visibility based on answer to parent question 
    * @Param       : None
    * @Return      : void
****************************************************************************************************/    
    public void checkQuestionsVisibility() {
        
        try{
            Map < Id, String > mapQuestionResponse = new Map < Id, String > ();
            Set<String> LicenseFields = new Set<String>();
            Set<String> PermitFields = new Set<String>();
            Set<String> RenewalFields = new Set<String>();
            Set<String> EndorsementFields = new Set<String>();
            Set<String> ReviewFields = new Set<String>();
            Set<String> ServiceRequestFields = new Set<String>();
        
        
            for(QuestionObj queObj: Questions) {
                mapQuestionResponse.put(queObj.Id, queObj.SelectedValue);
                if(queObj.Question.Parent_Object_API_Name__c == label.API_License2 && queObj.Question.Triggering_Field_API_Name__c!=null && queObj.Question.Triggering_Field_Value__c!=null)
                {
                    LicenseFields.add(queObj.Question.Triggering_Field_API_Name__c);
                }
                else if(queObj.Question.Parent_Object_API_Name__c == label.API_Permit && queObj.Question.Triggering_Field_API_Name__c!=null && queObj.Question.Triggering_Field_Value__c!=null)
                {
                    PermitFields.add(queObj.Question.Triggering_Field_API_Name__c);
                }
                else if(queObj.Question.Parent_Object_API_Name__c == label.API_Renewal_Application && queObj.Question.Triggering_Field_API_Name__c!=null && queObj.Question.Triggering_Field_Value__c!=null)
                {
                    RenewalFields.add(queObj.Question.Triggering_Field_API_Name__c);
                }
                /*Todo
                 * else if(queObj.Question.Parent_Object_API_Name__c == label.API_Review && queObj.Question.Triggering_Field_API_Name__c!=null && queObj.Question.Triggering_Field_Value__c!=null)
                {
                    ReviewFields.add(queObj.Question.Triggering_Field_API_Name__c);
                } */
                else if(queObj.Question.Parent_Object_API_Name__c == label.API_Application && queObj.Question.Triggering_Field_API_Name__c!=null && queObj.Question.Triggering_Field_Value__c!=null)
                {
                    ServiceRequestFields.add(queObj.Question.Triggering_Field_API_Name__c);
                }
            }

            String objectAPIName = '';
            SObject recordToCheck = null;

            if(objectName == null || objectName == '') {
                return;
            }
            else if(objectName == label.Str_License) {
                objectAPIName = label.API_License2;
                if(!LicenseFields.isEmpty())
                {
                    String strFields = String.join(new List<string>(LicenseFields),',');
                    string LicenseQuery = 'select Id,' + strFields + ' From MUSW__License2__c where id = \'' + License.Id + '\' limit 1';
                    recordToCheck = Database.query(LicenseQuery);  
                }else{
                    recordToCheck = License;
                }
            }
            else if(objectName == label.Str_Permit) {
                objectAPIName = label.API_Permit;
                if(!PermitFields.isEmpty())
                {
                    String strFields = String.join(new List<string>(PermitFields),',');
                    string LicenseQuery = 'select Id,' + strFields + ' From MUSW__Permit2__c where id = \'' + License.Id + '\' limit 1';
                    recordToCheck = Database.query(LicenseQuery);  
                }else{
                    recordToCheck = License;
                }
            }
            else if(objectName == label.RNT_Renewal && (isCredentialRenewal || isCredentialReinstatement)) {
                objectAPIName = label.API_Renewal_Application;
                if(!RenewalFields.isEmpty())
                {
                    String strFields = String.join(new List<string>(RenewalFields),',');
                    string RenewalQuery = 'select  ' + strFields + ' From Renewal_Application__c where id = \'' + Renewal.Id + '\' limit 1';
                    recordToCheck = Database.query(RenewalQuery);
                }else{
                recordToCheck = Renewal;
                }
            }
            else if(objectName == label.RNT_Renewal && isPermitRenewal) {
                objectAPIName = label.API_Renewal_Application;
                if(!RenewalFields.isEmpty())
                {
                    String strFields = String.join(new List<string>(RenewalFields),',');
                    string RenewalQuery = 'select  ' + strFields + ' From Renewal_Application__c where id = \'' + Renewal.Id + '\' limit 1';
                    recordToCheck = Database.query(RenewalQuery);
                }else{
                recordToCheck = Renewal;
                }
            }
            /*Todo
             * 
            else if(objectName == label.Obj_Review) {
                objectAPIName = label.API_Review;
                if(!EndorsementFields.isEmpty())
                {
                    String strFields = String.join(new List<string>(ReviewFields),',');
                    string ReviewQuery = 'select  ' + strFields + ' From MUSW__Review__c where id = \'' + ServiceRequest.Id + '\' limit 1';
                    recordToCheck = Database.query(ReviewQuery);
                }else{         
                recordToCheck = Review;
                }
            } */
        
             else if(objectName == 'Application') {
                objectAPIName = label.API_Application;
                if(!EndorsementFields.isEmpty())
                {
                    String strFields = String.join(new List<string>(ServiceRequestFields),',');
                    string ServiceRequestQuery = 'select  ' + strFields + ' From MUSW__Application2__c where id = \'' + ServiceRequest.Id + '\' limit 1';
                    recordToCheck = Database.query(ServiceRequestQuery);
                }else{         
                recordToCheck = ServiceRequest;
                }
            }
        
            Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
            Map < String, Schema.SObjectField > fieldMap = schemaMap.get(objectAPIName).getDescribe().fields.getMap();
            for(QuestionObj queObj: Questions) {
                if(queObj.Question.Parent_Question__c == null) {

                    if(queObj.Question.Triggering_Field_API_Name__c == null || queObj.Question.Triggering_Field_API_Name__c == '') {
                        queObj.visible = true;
                    }
                    else if(queObj.Question.Triggering_Field_API_Name__c != null && queObj.Question.Triggering_Field_Value__c != null) {
                        queObj.visible = false;
                        Schema.DisplayType fielddataType = fieldMap.get(queObj.Question.Triggering_Field_API_Name__c).getDescribe().getType();

                        if(fielddataType != Schema.DisplayType.Boolean) {
                            if(recordToCheck.get(queObj.Question.Triggering_Field_API_Name__c) == queObj.Question.Triggering_Field_Value__c) {
                                queObj.visible = true;
                            }
                        }
                        else {
                            if(recordToCheck.get(queObj.Question.Triggering_Field_API_Name__c) == Boolean.ValueOf(queObj.Question.Triggering_Field_Value__c)) {
                                queObj.visible = true;
                            }   
                        }   
                    }
                    else {
                        queObj.visible = false;
                    }
                //Logic to Handle Group Questins Visibility
                    if(queObj.Question.Allow_Multiple_Question_Groups__c == true) {
                    
                    if(queObj.Map_Of_AnswerGroup_childQuestionsGroup!=null && !queObj.Map_Of_AnswerGroup_childQuestionsGroup.isEmpty()) {
                         queObj.renderChildGroupQuestions = false;
                        for(string MapKey: queObj.Map_Of_AnswerGroup_childQuestionsGroup.keyset()) {
                            for(QuestionsGroup quesGroup: queObj.Map_Of_AnswerGroup_childQuestionsGroup.get(MapKey)) {
                                if(QuesGroup.question.Triggering_Parent_Answer__c == mapQuestionResponse.get(QuesGroup.Question.Parent_Question__c)) {
                                    QuesGroup.visible = true;
                                    queObj.renderChildGroupQuestions = true;
                                }
                                else {
                                    QuesGroup.visible = false;                                   
                                }
                            }
                        }
                    }
                }
                //End of logic for Group Questions Visibility

                }
                else {
                if(queObj.Question.Triggering_Parent_Answer__c == mapQuestionResponse.get(queObj.Question.Parent_Question__c) && queObj.Question.Child_Question_Group__c == null) {
                    queObj.visible = true;
                }

                else {
                    queObj.visible = false;
                }
                
                 if(queObj.Question.Triggering_Field_API_Name__c!=null&&recordToCheck.get(queObj.Question.Triggering_Field_API_Name__c)!= Boolean.ValueOf(queObj.Question.Triggering_Field_Value__c)){
                        queObj.visible = false;
                }
            }
        }
        } catch(Exception ex) {
                ApexPages.addMessages(ex);
                ErrorLogger.logGeneralException(ex, UserInfo.getUserId(), 'BackendQuestionAnswer', null, 'deleteQuestionsGroup', 'BackendQuestionAnswer', 'High');
          }
        
    }

/***************************************************************************************************
    * @Description : Method to Save Answers
    * @Param       : None
    * @Return      : Void
****************************************************************************************************/
    public void save() {
        System.debug('SM-in save');
        System.debug('SM-in 0 *****Object Name*******' + objectname);
        Savepoint sp = Database.setSavepoint();

        List < Answer__c > answersUpdate = new List < Answer__c > ();
        List < Answer__c > answersDelete = new List < Answer__c > ();
        try {
            System.debug('SM-in try');
            System.debug('Questions '+Questions);
            for(QuestionObj queObj: Questions) {
                System.debug('SM-in for loop for questionObj');
                if(queObj.visible) { //Save the answer if question was visible
                    System.debug('SM-in quesObj.visible');
                    if(queObj.Answer == null) { //Save answer if there is no existing Answer
                    System.debug('SM-in answer==null');    
                        Answer__c a = new Answer__c();
                        a.External_id_of_Question__c = queObj.question.External_Id__c;
                        a.Question_Body__c=queObj.question.Question_Body__c;
                        a.Answer_Text__c = queObj.selectedvalue;
                        a.Comment__c = queObj.answerComment;
                        //logic to save Child Group Question if there is no existing Answer
                        if(queObj.Map_Of_AnswerGroup_childQuestionsGroup!=null && !queObj.Map_Of_AnswerGroup_childQuestionsGroup.isEmpty()) {
                            System.debug('SM-in queObj.Map_Of_AnswerGroup_childQuestionsGroup!=null');    
                            Integer Index = 0;
                            for(string MapKey: queObj.Map_Of_AnswerGroup_childQuestionsGroup.keyset()) {
                                System.debug('SM-in string MapKey for loop');    
                                Index = Index + 1;
                                for(QuestionsGroup quesGroup: queObj.Map_Of_AnswerGroup_childQuestionsGroup.get(MapKey)) {
                                    if(quesGroup.Answer == null && quesGroup.visible) {
                                        System.debug('SM-in quesGroup.Answer == null && quesGroup.visible');
                                        Answer__c questGroupAnswer = new Answer__c();
                                        questGroupAnswer.External_id_of_Question__c= quesGroup.question.External_Id__c;
                                        questGroupAnswer.Parent_Question_External_Id__c = queObj.question.External_Id__c;
                                        questGroupAnswer.Question_Body__c = quesGroup.question.Question_Body__c;
                                        questGroupAnswer.Answer_Text__c = quesGroup.selectedvalue;
                                        questGroupAnswer.Comment__c = quesGroup.answerComment;
                                        questGroupAnswer.Answer_Group__c = quesGroup.Question.Child_Question_Group__c + '-' + string.valueOf(Index);
                                        System.debug('SM-in 1 *****Object Name*******' + objectname);
                                        if(objectname == label.Str_License) {
                                            questGroupAnswer.License__c = recordId;
                                        }
                                        else if(objectname == label.Str_Permit) {
                                            questGroupAnswer.Permit__c = recordId;
                                        }
                                        else if(objectname == label.RNT_Renewal || objectname == label.RNT_Reinstatement) {
                                            questGroupAnswer.Renewal_Application__c = recordId;
                                        }
                                        else if(objectname == 'PermitRenewal') {
                                            questGroupAnswer.Renewal_Application__c = recordId;
                                        }
                                        /*Todo
                                         * else if(objectname == label.Obj_Review) {
                                            questGroupAnswer.Review__c = recordId;
                                        } */
                                        else if(objectname == 'Service Request') {
                                            questGroupAnswer.Service_Request__c = recordId;
                                        }
                                        answersUpdate.add(questGroupAnswer);
                                    }

                                }
                            }
                        } //End of if at 508
                        System.debug('SM-in 2 *****Object Name*******' + objectname);
                        System.debug('SM-in 3 *****label.Str_License*******' + label.Str_License);
                        if(objectname == label.Str_License) {
                            a.License__c = recordId;
                        }
                        else if(objectname == label.Str_Permit) {
                            a.Permit__c = recordId;
                        }
                        else if(objectName == label.RNT_Renewal && (isCredentialRenewal || isCredentialReinstatement)) {
                            a.Renewal_Application__c = recordId;
                        }
                        else if(objectName == label.RNT_Renewal && isPermitRenewal) {
                            a.Renewal_Application__c = recordId;
                        }
                        /* Todo
                         * else if(objectname == label.Obj_Review) {
                            a.Review__c = recordId;
                        } */
                        else if(objectname == 'Service Request') {
                            a.Service_Request__c = recordId;
                        }
                            
                        answersUpdate.add(a);
                    }
                    else{ //Save answer logic if there is an existing answer
                        System.debug('if answer already exists');
                        System.debug('queObj '+queObj);
                        System.debug('queObj.answer '+queObj.answer);
                        System.debug('queObj.question '+queObj.question);
                        queObj.answer.External_id_of_Question__c = queObj.question.External_Id__c;
                        System.debug('here- queObj.answer.Answer_Text__c '+queObj.answer.Answer_Text__c);
                        System.debug('here again- queObj.selectedvalue '+queObj.selectedvalue);
                        queObj.answer.Answer_Text__c = queObj.selectedvalue;
                        queObj.answer.Comment__c = queObj.answerComment;
                        queObj.answer.Question_Body__c=queObj.question.Question_Body__c;
                        //Logic to handle Child Groups Answers
                        System.debug('before handling group question logic');
                            System.debug('queObj.Map_Of_AnswerGroup_childQuestionsGroup '+queObj.Map_Of_AnswerGroup_childQuestionsGroup);
                        if(queObj.Map_Of_AnswerGroup_childQuestionsGroup!=null && !queObj.Map_Of_AnswerGroup_childQuestionsGroup.isEmpty()) {
                            System.debug('in group questions logic');
                            System.debug('queObj.Map_Of_AnswerGroup_childQuestionsGroup '+queObj.Map_Of_AnswerGroup_childQuestionsGroup);
                            Integer Index = 0;
                            for(string MapKey: queObj.Map_Of_AnswerGroup_childQuestionsGroup.keyset()) {
                                System.debug('looping through mapkey '+MapKey);
                                Index = Index + 1;
                                System.debug('Index '+Index);
                                for(QuestionsGroup quesGroup: queObj.Map_Of_AnswerGroup_childQuestionsGroup.get(MapKey)) {
                                    System.debug('looping through questionGroup');
                                    System.debug('quesGroup '+quesGroup);
                                    System.debug('quesGroup.Answer '+quesGroup.Answer);
                                    System.debug('quesGroup.visible '+quesGroup.visible);
                                    if(quesGroup.Answer == null && quesGroup.visible) { // If there are no Existing Child Answer for an existing Parent Answer
                                        System.debug('If there are no Existing Child Answer for an existing Parent Answer');
                                        Answer__c questGroupAnswer = new Answer__c();
                                        questGroupAnswer.Question_Body__c=quesGroup.question.Question_Body__c;
                                        questGroupAnswer.External_id_of_Question__c= quesGroup.question.External_Id__c;
                                        questGroupAnswer.Parent_Question_External_Id__c = queObj.question.External_Id__c;
                                        questGroupAnswer.Answer_Text__c = quesGroup.selectedvalue;
                                        questGroupAnswer.Comment__c = quesGroup.answerComment;
                                        questGroupAnswer.Answer_Group__c = quesGroup.Question.Child_Question_Group__c + '-' + string.valueOf(Index);
                                        if(objectname == label.Str_License) {
                                            questGroupAnswer.License__c = recordId;
                                        }
                                        else if(objectname == label.Str_Permit) {
                                            questGroupAnswer.Permit__c = recordId;
                                        }
                                        else if(objectName == label.RNT_Renewal && (isCredentialRenewal || isCredentialReinstatement)) {
                                            questGroupAnswer.Renewal_Application__c = recordId;
                                        }
                                        else if(objectName == label.RNT_Renewal && isPermitRenewal) {
                                            questGroupAnswer.Renewal_Application__c = recordId;
                                        }
                                        /*Todo
                                         * else if(objectname == label.Obj_Review) {
                                            questGroupAnswer.Review__c = recordId;
                                        } */
                                        else if(objectname == 'Service Request' ) {
                                            questGroupAnswer.Service_Request__c = recordId;
                                        }
                                        
                                        answersUpdate.add(questGroupAnswer);
                                    }
                                    else if(quesGroup.Answer != null && !quesGroup.visible) { //Delete child answers if there is the parent answer is changed to a va;ue that does not match triiger parent answer value on the child
                                        System.debug('Delete child answers if there is the parent answer is changed to a va;ue that does not match triiger parent answer value on the child');
                                        answersDelete.add(quesGroup.answer);
                                    }
                                    else if(quesGroup.Answer != null && quesGroup.visible) { //If answer is changed from back office- update it
                                        System.debug('If answer is changed from back office- update it');
                                        System.debug('quesGroup.Answer '+quesGroup.Answer);
                                        quesGroup.Answer.Answer_Text__c = quesGroup.selectedvalue;
                                        answersUpdate.add(quesGroup.Answer);
                                        System.debug('answersUpdate '+ answersUpdate);
                                    }
                                }
                            }
                        }
                        if(objectname == label.Str_License) {
                            queObj.answer.License__c = recordId;
                        }
                        else if(objectname == label.Str_Permit) {
                            queObj.answer.Permit__c = recordId;
                        }
                        else if(objectName == label.RNT_Renewal && (isCredentialRenewal || isCredentialReinstatement)) {
                            queObj.answer.Renewal_Application__c = recordId;
                        }
                        else if(objectName == label.RNT_Renewal && isPermitRenewal) {
                            queObj.answer.Renewal_Application__c = recordId;
                        }
                        /*Todo
                         * else if(objectname == label.Obj_Review) {
                            queObj.answer.Review__c = recordId;
                        } */
                        else if(objectname == 'Service Request') {
                            queObj.answer.Service_Request__c = recordId;
                        }

                        answersUpdate.add(queObj.answer);
                    }
                }
                else { //Question is not visible, so delete the answer
                    if(queObj.Answer != null && queObj.Answer.Id != null) {
                        answersDelete.add(queObj.answer);
                    }
                }
            }

            //upsert answersUpdate;   Commented duplicate upsert statement
            if(!answersUpdate.isEmpty() && answersUpdate != null) {
                System.debug('in upsert');
                System.debug('answersUpdate final '+ answersUpdate);
                upsert answersUpdate;
            }
            if(!answersDelete.isEmpty() && answersDelete != null && Schema.sObjectType.Answer__c.isDeletable() ) {
                System.debug('in delete');
                delete answersDelete;
            }

            savemode = true;
            editmode = false;
        }
        catch(Exception ex) {
            ErrorLogger.logGeneralException(ex, UserInfo.getUserId(), 'BackendQuestionAnswer', null, 'save', 'BackendQuestionAnswer', 'High');
            ApexPages.addMessages(ex);
            Database.rollback(sp);
        }
    }

    /**
     * class representing Questions object
     */

    public class QuestionObj implements Comparable {
        // Global variables
        public Question__c question {
            get;
            set;
        }
        public String id {
            get;
            set;
        }
        public Integer orderNumber {
            get;
            set;
        }
        public boolean parent {
            get;
            set;
        }
        public Answer__c answer {
            get;
            set;
        }
        public string answerComment {
            get;
            set;
        }
        public string selectedvalue {
            get;
            set;
        }
        public list < selectOption > lstAnswerOptions {
            get;
            set;
        }
        public boolean visible {
            get;
            set;
        }
        public List < String > lstCommentResponses {
            get;
            set;
        }
        public Boolean AllowQuestionGroups {
            get;
            set;
        } 
        public Boolean renderChildGroupQuestions {
            get;
            set;
        }
        public Boolean ShowDeleteGroupButton {
            get;
            set;
        } 
        public Boolean showComment {
            private set;
            get {
                showComment = false;
                for(String getValue: lstCommentResponses) {
                    if(getValue == selectedvalue) {
                        showComment = true;
                    }
                }
                return showComment;
            }
        }
        public List < QuestionsGroup > ChildQuestionsGroup {
            get;
            set;
        } 
        public Map < String, List < QuestionsGroup >> Map_Of_AnswerGroup_childQuestionsGroup {
            get;
            set;
        } 
        //constructer 
        public QuestionObj(Question__c question, String id, Integer orderNumber, boolean parent) {
            lstCommentResponses = new list < String > ();
            this.question = question;
            this.id = id;
            this.orderNumber = orderNumber;
            this.parent = parent;
            visible = false;
        }

        //sort based on questions
        public Integer compareTo(Object compareToObj) {
            QuestionObj ques2 = (QuestionObj) compareToObj;
            Integer retVal = -1;
            if(orderNumber == ques2.orderNumber) {
                retVal = 0;
            }
            if(orderNumber > ques2.orderNumber) {
                retVal = 1;
            }
            return retVal;
        }

    }

    /**
     * Inner wrapper class representing Question Group
     */
    public class QuestionsGroup implements Comparable {
        public Question__c question {
            get;
            set;
        }
        public String id {
            get;
            set;
        }
        public Integer orderNumber {
            get;
            set;
        }
        public boolean parent {
            get;
            set;
        }
        public Answer__c answer {
            get;
            set;
        }
        public string answerComment {
            get;
            set;
        }
        public string selectedvalue {
            get;
            set;
        }
        public list < selectOption > lstAnswerOptions {
            get;
            set;
        }
        public boolean visible {
            get;
            set;
        }
        public List < String > lstCommentResponses {
            get;
            set;
        }
        public String AnswerGroup {
            get;
            set;
        }
        public String GroupQuestionAnswerValue {
            get;
            set;
        }
        public Boolean showComment {
            private set;
            get {
                showComment = false;
                for(String getValue: lstCommentResponses) {
                    if(getValue == selectedvalue) {
                        showComment = true;
                    }
                }
                return showComment;
            }
        }

         
        /***************************************************************************************************
            * @Description : QuestionsGroup Constructor
            * @Param       : Question__c question, String id, Integer orderNumber, boolean parent
            * @Return      : 
        ****************************************************************************************************/
        public QuestionsGroup(Question__c question, String id, Integer orderNumber, boolean parent) {
            lstCommentResponses = new list < String > ();
            this.question = question;
            this.id = id;
            this.orderNumber = orderNumber;
            this.parent = parent;

            visible = false;
        }

        
        /***************************************************************************************************
            * @Description : Method to sort based on questions
            * @Param       : Object compareToObj
            * @Return      : NA
        ****************************************************************************************************/
        public Integer compareTo(Object compareToObj) {
            QuestionsGroup ques2 = (QuestionsGroup) compareToObj;
            Integer retVal = -1;
            if(orderNumber == ques2.orderNumber) {
                retVal = 0;
            }
            if(orderNumber > ques2.orderNumber) {
                retVal = 1;
            }
            return retVal;
        }
    }
}