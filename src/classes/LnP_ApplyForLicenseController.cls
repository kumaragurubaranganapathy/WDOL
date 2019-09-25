public class LnP_ApplyForLicenseController {
    @AuraEnabled
    public static String fetchData(String Board, String LicenseType, String ApplicationType, String flowType, String appId){
        if(appId != ''){
            system.debug('LicenseType '+LicenseType);
            Integer currentTab = 0;
            LnP_JSONParser ansWrapper;
            //Query Answers and Application records
            List<MUSW_Application2__c> appList =new List<MUSW_Application2__c>();
            List<LnP_Licence_Application__c> appList2 =new List<LnP_Licence_Application__c>();
            String appCondition = 'Id=\''+appId+'\'';
            String strApp = 'Select Id,MUSW_Account__c,Stage__c, Application_Type__c,  Board__c, License_Type__c, (Select Id, Contact__c, Account__c, Sequence__c, LnP_Form_JSON__c from License_Application__r ORDER BY Sequence__c ASC) from MUSW_Application2__c where '+appCondition;
            appList = Utilityclass_withsharing.queryRecords(strApp);
            Map<Id, List<SObject>> m = new Map<Id, List<SObject>>();
            for (MUSW_Application2__c p : [
                Select Id, Stage__c, Application_Type__c,  Board__c, License_Type__c, 
                (Select Id, Sequence__c,Contact__c, Account__c, LnP_Form_JSON__c from License_Application__r ORDER BY Sequence__c ASC) from MUSW_Application2__c where Id =:appId ]) {
                    m.put(p.Id, p.License_Application__r);
                }
            for (List <sObject> quoteList : m.values())
            {               
                appList2 =quoteList ;            
            }
            system.debug('appList'+appList2);
            if(appList.size() >0 && !appList2.isEmpty()){
                system.debug('inside #####');
                if(appList[0].Stage__c != null)
                    currentTab = Integer.valueOf(appList[0].Stage__c);
                ansWrapper = getJSONWrapper(appList2);
            }
            system.debug('ansWrapper'+ansWrapper);
            List<String> picklistValues = new List<String>();
            List<LnP_ApplyForLicenseWrapper> listLicense = new List<LnP_ApplyForLicenseWrapper>();
            list<Contact> ConList = new list<Contact>();
            Map<String,LnP_ApplyForLicenseWrapper> sectionMap = new Map<String,LnP_ApplyForLicenseWrapper>();
            String sections = [SELECT Sections__c FROM LnP_License_Type_Sections_Setting__mdt WHERE Board__c=: Board AND License_Type__c=: LicenseType AND Application_Method__c=: ApplicationType  ][0].Sections__c;
            Integer tabIndex = 1;
            List<String> wizardSections = sections.split(',');
            system.debug('wizardSections'+wizardSections);
            List<LnP_ApplyForLicenseWrapper> listLicense1 = new List<LnP_ApplyForLicenseWrapper>();
            List<LnP_Mandatory_Subsections__mdt> lstMandatorySubsection = new List<LnP_Mandatory_Subsections__mdt>();
            lstMandatorySubsection = [SELECT SubSection__c,Section__c FROM LnP_Mandatory_Subsections__mdt WHERE Board__c=: Board AND License_Type__c=:LicenseType];
            string manSubsections ='';
            List<Application_Field__c> applicationFieldList = new List<Application_Field__c>();
            list<Question__c> QuestionList = new list<Question__c>();
            String Condition1 = 'Application_Type__c = \''+Board+'\'';
            String Condition2 = 'Application_Method__c =\''+ApplicationType+'\'';
            String Condition3 = 'Credential_Type__c =\''+LicenseType+'\'';
           // String Condition4 = 'Show_For__c includes (\''+flowType+'\')';
            String str = '';
             //Modified it to  the questions object
            // str  = 'Select Id, Name, Qualifying_answer_for_Submission__c, Has_Any_Submission__c, Submission_Title__c, Board__c, Question_Body__c, Expected_Answer_To_Show_Question__c, Data_Type__c, Possible_Responses__c, License_Type__c, ApplicationType__c, Order_Number__c,Has_dependent_questions__c, Qualifying_answer_for_dependent_question__c, Parent_Question__c, Record_Type_Name__c,Section__c,Sub_Header__c,Sub_Sub_Header__c,Section_Order__c,QuestionFieldAPI__c,QuestionObjectName__c from LnP_Question1__c where ' +Condition1+ ' AND '+Condition2+ ' AND '+Condition3 + 'AND '+Condition4+' ORDER BY Section_Order__c, Order_Number__c ASC';
            str  = 'Select Id,Name,Triggering_Parent_Answer__c,Qualifying_Response__c,Has_Any_Submission__c,Submission_Title__c,Application_Type__c,Question_Body__c,   Data_Type__c,Possible_Responses__c,Credential__c,Application_Method__c,Order_Number__c,Has_dependent_questions__c,  Parent_Question__c, Record_Type_Name__c,Section__c, Sub_Header__c,  Sub_Sub_Header__c,  Section_Order__c,QuestionFieldAPI__c,   QuestionObjectName__c FROM Question__c where ' +Condition1+ ' AND '+Condition2+ ' AND '+Condition3 + ' AND status__c=\'Active\' ORDER BY  Order_Number__c ASC';
            system.debug('printQuestions'+ str);
            QuestionList = Utilityclass_withsharing.queryRecords(Str);
            String queryApplicationField = '';
            String jsonApplicationField = '';
            queryApplicationField = 'SELECT Application_Method__c,Application_Type__c,Id,Label__c,Credential_Type__c,Name,Object_Name__c,Order_Number__c,Read_Only__c,Required__c,Type__c,Validator__c FROM Application_Field__c where ' +Condition1+ ' AND '+Condition2+ ' AND '+Condition3 +' ORDER BY Order_Number__c ASC';
            system.debug('printPersonal'+queryApplicationField);
            applicationFieldList = Utilityclass_withsharing.queryRecords(queryApplicationField);
            jsonApplicationField = JSON.serialize(applicationFieldList);
            system.debug('jsonApplicationField'+jsonApplicationField);
            List<User> userInfoData = new  List<User>();
            String queryCondition = ' Id=\''+UserInfo.getUserId()+'\'';
            String queryStr = 'SELECT Username, ContactId, Contact.Name, Contact.AccountId, Contact.Account.Name FROM User WHERE  '+queryCondition + 'Limit 1';
            userInfoData = Utilityclass_withsharing.queryRecords(queryStr);
            for(String section: wizardSections){
                LnP_ApplyForLicenseWrapper licenseWrapper = new LnP_ApplyForLicenseWrapper();
                licenseWrapper.sectionName = section;
                licenseWrapper.subheader = section;
                licenseWrapper.currentTab = currentTab;
                licenseWrapper.tabIndex = tabIndex;
                if(!lstMandatorySubsection.isEmpty() ){
                    for(LnP_Mandatory_Subsections__mdt mandatorySubSection : lstMandatorySubsection){
                        if(section == mandatorySubSection.Section__c) {
                            manSubsections = mandatorySubSection.SubSection__c;
                            licenseWrapper.mandatorySubsection = manSubsections; 
                        }  
                    }

                }
                licenseWrapper.icon = LnP_PageWiseCustomLabels.fetchPageWiseLabel('ApplyForLicense').get(section+' icon');
                system.debug('icon= '+licenseWrapper.icon);
                if(section =='Personal Information'  ){
                    licenseWrapper.personalInfoObjectName = 'Contact';
                    licenseWrapper.fieldJson = jsonApplicationField;
                    if(!appList2.isEmpty() && appList2[0].Contact__c != null ){
                        licenseWrapper.contactId = appList2[0].Contact__c;
                    } else {
                        Id getContactId = '003r000000EOhBB';
                        if(userInfoData[0].ContactId != null){
                            getContactId = userInfoData[0].ContactId;
                        }
                        licenseWrapper.contactId = getContactId;
                    }
                    
                } 
                else if(section =='Business Information' &&  !appList.isEmpty()){
                    licenseWrapper.personalInfoObjectName = 'Account'; 
                    licenseWrapper.accountId = appList[0].MUSW_Account__c;
                    licenseWrapper.fieldJson = jsonApplicationField;
                }
                else if(section =='Attachments'){
                    system.debug('inside attachments');
                    licenseWrapper.sobjectType = 'Submission';
                    list<MUSW__Master_Submission_List__c> masterSubmissionList = new list<MUSW__Master_Submission_List__c>();
                    String subCon1 = 'Application_Type__c = \''+Board+'\'';
                    String subCon2 = 'Application_Method__c =\''+ApplicationType+'\'';
                    String subCon3 = 'Credential_Type__c =\''+LicenseType+'\'';
                    String subCon4 = 'Default__c = true';
                    String subCon5 = 'Show_For__c includes (\''+flowType+'\')';
                    //String strSubmission = 'Select Id, Name, Upload_By__c, Title__c, Submission_Title__c, Submission_For__c, Show_For__c, Mandatory_Submission__c, Submission_Details__c, Qualifying_Response__c, License_For__c, Is_Active__c, Generic_Submission__c, Board__c, License_Type__c, Application_Type__c from MUSW_Master_Submission_List__c where ' +subCon1+ ' AND '+subCon2+ ' AND '+subCon3+ ' AND '+subCon4+ ' AND '+subCon5;
                    String strSubmission = 'Select Id,Submission_Type__c,Show_For__c, Name,Title__c,Question__c,Expected_Answer__c, Required__c,   Active__c, Default__c, Application_Type__c, Credential_Type__c, Application_Method__c from MUSW__Master_Submission_List__c where ' +subCon1+ ' AND '+subCon2+ ' AND '+subCon3+ ' AND '+subCon4+ ' AND Show_For__c INCLUDES (\'License\',\'Credential\')';
                    system.debug('strSubmission'+strSubmission);
                    masterSubmissionList = Utilityclass_withsharing.queryRecords(strSubmission);
                    System.debug('Att list-----'+masterSubmissionList); 
                    for(MUSW__Master_Submission_List__c master: masterSubmissionList){
                        LnP_ApplyForLicenseWrapper.MapLabelToFields submissionMap = new LnP_ApplyForLicenseWrapper.MapLabelToFields();
                        submissionMap.label = master.Name;
                        submissionMap.conditionalAnswer = master.Title__c;
                        submissionMap.fieldType = 'Attachment';
                        submissionMap.isGenericSub = true;
                        
                        if(master.Submission_Type__c != null && master.Submission_Type__c.contains('Softcopy: To be Uploaded')){
                            submissionMap.uploadFile = true;
                        }
                        if(master.Submission_Type__c != null && master.Submission_Type__c.contains('Hardcopy: To be Mailed')){
                            submissionMap.acknowledge = true;
                        }
                        submissionMap.isMandatorySub = false; 
                        if(master.Required__c){
                            submissionMap.isMandatorySub = true;   
                        }
                        if(ansWrapper != null && ansWrapper.compositeRequest != null){
                            for(LnP_JSONParser.CompositeRequest req : ansWrapper.compositeRequest){
                                if(master.Name !=null && req.body!=null && req.body.MUSW_Description!= null && req.body.MUSW_Description == master.Name){                                   
                                    submissionMap.acknowledgeResponse = req.body.Hardcopy;
                                    if(req.body.ContentDocumentId != null && req.body.ContentDocumentId.contains(';')){
                                        submissionMap.multiValues = req.body.ContentDocumentId.split(';');
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        licenseWrapper.labelFieldsMap.add(submissionMap);
                    }
                    
                }
                else if(section =='Background Information'){
                    String questionSection = '';
                    for(Question__c Ques : QuestionList){
                        //system.debug('Ques.Data_Type__c = '+Ques.Data_Type__c+ 'section=='+section);
                        LnP_ApplyForLicenseWrapper.MapLabelToFields labelToFields = new LnP_ApplyForLicenseWrapper.MapLabelToFields();
                        if(Ques.Sub_Sub_Header__c == section){
                            labelToFields.label = Ques.Question_Body__c;
                            labelToFields.labelId = Ques.Id;
                            labelToFields.fieldType = Ques.Data_Type__c;
                            labelToFields.hasChild = Ques.Has_dependent_questions__c;
                            labelToFields.parentQuestionId = Ques.Parent_Question__c;
                            labelToFields.submissionDetails = Ques.Submission_Title__c;
                            labelToFields.questionSectionClass = Ques.Section__c;
                            if(questionSection == Ques.Section__c || Ques.Section__c==null){
                                labelToFields.questionSection ='null';
                            }else{
                                labelToFields.questionSection = Ques.Section__c;
                                questionSection = Ques.Section__c;
                                labelToFields.questionSectionDetail = Ques.Sub_Header__c;
                            }
                            if(Ques.Parent_Question__c != null){
                                labelToFields.isChild = true;
                            }
                            else{
                                labelToFields.isChild = false;
                            }
                            labelToFields.fieldAPIName = Ques.QuestionFieldAPI__c;
                            labelToFields.fieldObjName = Ques.QuestionObjectName__c;
                            labelToFields.conditionalAnswer = Ques.Triggering_Parent_Answer__c;
                            
                            //system.debug('answerwrapperansss'+ansWrapper);
                            if(ansWrapper != null && ansWrapper.compositeRequest != null){
                                for(LnP_JSONParser.CompositeRequest req : ansWrapper.compositeRequest){
                                    // system.debug('ansWrapper.compositeRequest'+ansWrapper.compositeRequest);
                                    if(req.body!=null && req.body.Question == Ques.Id){
                                        if(req.body.Answer.contains(';')){
                                            labelToFields.multiValues = req.body.Answer.split(';');
                                            labelToFields.acknowledgeResponse = req.body.Hardcopy;
                                        }
                                        else{
                                            labelToFields.value = req.body.Answer;
                                            
                                        }
                                    }
                                    
                                }
                            }
                            system.debug('Ques.Possible_Responses__c =='+Ques.Id);
                            licenseWrapper.labelFieldsMap.add(labelToFields);
                        }
                    }
                    
                }           
                else if(section=='Background Questions' || section=='Financial Guarantee'){
                    String questionSection = '';
                    system.debug('questionsList'+QuestionList);
                    for(Question__c Ques : QuestionList){
                        //system.debug('Ques.Data_Type__c = '+Ques.Data_Type__c+ 'section=='+section);
                        LnP_ApplyForLicenseWrapper.MapLabelToFields labelToFields = new LnP_ApplyForLicenseWrapper.MapLabelToFields();
                        if(Ques.Sub_Sub_Header__c == section){
                           // labelToFields.label = fetchBoardLabels(Ques.Question_Body__c, board);
                           // 
                            labelToFields.label = Ques.Question_Body__c;
                            labelToFields.labelId = Ques.Id;
                            labelToFields.fieldType = Ques.Data_Type__c;
                            labelToFields.hasChild = Ques.Has_dependent_questions__c;
                            labelToFields.parentQuestionId = Ques.Parent_Question__c;
                            labelToFields.submissionDetails = Ques.Submission_Title__c;
                            labelToFields.questionSectionClass = Ques.Section__c;
                            if(questionSection == Ques.Section__c || Ques.Section__c==null){
                                labelToFields.questionSection ='null';
                                //  labelToFields.questionSectionClass = 'null';
                            }else{
                                labelToFields.questionSection = Ques.Section__c;
                                questionSection = Ques.Section__c;  
                                labelToFields.questionSectionDetail = Ques.Sub_Header__c;
                            }
                            if(Ques.Parent_Question__c != null){
                                labelToFields.isChild = true;
                                labelToFields.renderedOnUi = false;
                            } 
                            else{
                                labelToFields.isChild = false;
                                labelToFields.renderedOnUi = true;
                            }
                            labelToFields.fieldAPIName = Ques.QuestionFieldAPI__c;
                            labelToFields.fieldObjName = Ques.QuestionObjectName__c;
                            labelToFields.conditionalAnswer = Ques.Triggering_Parent_Answer__c;
                            if(Ques.Possible_Responses__c != null && Ques.Data_Type__c == 'Picklist'){
                                labelToFields.fieldValueOptions = Ques.Possible_Responses__c.split(';');
                            }
                            else if(Ques.Possible_Responses__c != null && (Ques.Data_Type__c == 'Radio'||Ques.Data_Type__c == 'Checkbox'||Ques.Data_Type__c == 'Yes_No')){ 
                                for(String radio : Ques.Possible_Responses__c.split(';')){
                                    LnP_ApplyForLicenseWrapper.MapRadioButtons radioMap = new LnP_ApplyForLicenseWrapper.MapRadioButtons();
                                    radioMap.label = radio;
                                    radioMap.value = radio;
                                    labelToFields.radioValueOptions.add(radioMap);
                                }
                            }
                            if(ansWrapper != null && ansWrapper.compositeRequest != null){
                                for(LnP_JSONParser.CompositeRequest req : ansWrapper.compositeRequest){
                                    if(req.body!=null && req.body.Question == Ques.Id){
                                        if(req.body.Answer.contains(';')){
                                            labelToFields.multiValues = req.body.Answer.split(';');
                                            labelToFields.acknowledgeResponse = req.body.Hardcopy;
                                        }
                                        else{
                                            labelToFields.value = req.body.Answer;
                                            
                                        }
                                    }
                                    
                                }
                            }
                            system.debug('Ques.Possible_Responses__c =='+Ques.Id);
                            licenseWrapper.labelFieldsMap.add(labelToFields);
                        }
                    }
                    
                }
                listLicense1.add(licenseWrapper);
                tabIndex++;
            }
            system.debug('listLicense1'+JSON.serialize(listLicense1));            
            return JSON.serialize(listLicense1);
        }
        else{
            return 'Failed';
        }
    }
    public static List<LnP_ApplyForLicenseWrapper> fetchSubmission(List<LnP_ApplyForLicenseWrapper> wrapperList,String Board, String LicenseType, String ApplicationType){
        Set<String> submissionList  = new Set<String>(); 
        List<LnP_ApplyForLicenseWrapper.MapLabelToFields> listFields = new List<LnP_ApplyForLicenseWrapper.MapLabelToFields>();
        List<MUSW__Master_Submission_List__c> masterSubmissionList = new List<MUSW__Master_Submission_List__c>();
        List<LnP_ApplyForLicenseWrapper.MapLabelToFields> listFieldSub = new List<LnP_ApplyForLicenseWrapper.MapLabelToFields>();
        List<LnP_ApplyForLicenseWrapper.MapLabelToFields> listFieldTemp = new List<LnP_ApplyForLicenseWrapper.MapLabelToFields>();
        //List<string> lstMandatorySubSections= new  List<string>();
        for(LnP_ApplyForLicenseWrapper objWrapper : wrapperList){
            if(objWrapper.sectionName.contains('Questions')){
                system.debug('Inside section=Question');
                listFields = objWrapper.labelFieldsMap;
                system.debug('List Fields '+listFields);
            }
        }
        for(LnP_ApplyForLicenseWrapper.MapLabelToFields fieldMap : listFields){
            if((fieldMap.submissionDetails != '' && fieldMap.submissionDetails != null) ){
                if (fieldMap.value != null && fieldMap.value != '' ) {
                    Map<String, String> mapAttachment = (Map<String, String>)JSON.deserialize(fieldMap.submissionDetails,Map<String, String>.class);
                    system.debug('mapAttachment12344'+mapAttachment);
                    if(mapAttachment.containsKey(fieldMap.value)){
                        submissionList.addAll(mapAttachment.get(fieldMap.value).split(','));
                    }
                }
                else if(fieldMap.multiValues != null && fieldMap.multiValues.size()>0){
                    for(String str : fieldMap.multiValues){
                        Map<String, String> mapAttachment = (Map<String, String>)JSON.deserialize(fieldMap.submissionDetails,Map<String, String>.class);
                        if(mapAttachment.containsKey(str)){
                            submissionList.addAll(mapAttachment.get(str).split(','));
                        }
                    }
                }
            }
        }
        for(String str : submissionList){
            str = str.trim();
        }
        String mastSubCond1 = 'Application_Type__c = \''+Board+'\'';
        String mastSubCond2 = 'Application_Method__c =\''+ApplicationType+'\'';
        String mastSubCond3 = 'Credential_Type__c =\''+LicenseType+'\' AND' + ' Default__c = false';
        String mastSubCond4 = 'Title__c IN: XXX';
        String strSubmission = 'Select Id, Name,Title__c,Question__c,Expected_Answer__c,Submission_Type__c, Required__c,  Active__c, Default__c, Application_Type__c, Credential_Type__c, Application_Method__c from MUSW__Master_Submission_List__c where ' +mastSubCond1+ ' AND '+mastSubCond2+ ' AND '+mastSubCond3+ ' AND ' +mastSubCond4;
        system.debug('submissionList'+submissionList);
        masterSubmissionList = Utilityclass_withsharing.queryRecordsInClause(strSubmission,submissionList);
        system.debug('masterSubmissionList12345'+masterSubmissionList);
        for(LnP_ApplyForLicenseWrapper objWrapper : wrapperList){
            if(objWrapper.sectionName.contains('Attachments')){
                listFieldSub = objWrapper.labelFieldsMap;
            }
        }
        System.debug('Field Map'+JSON.serialize(listFieldSub));
        Map<String,LnP_ApplyForLicenseWrapper.MapLabelToFields> submissions = new Map<String,LnP_ApplyForLicenseWrapper.MapLabelToFields>();
        for(LnP_ApplyForLicenseWrapper.MapLabelToFields fieldMap : listFieldSub){
            if(fieldMap.isGenericSub == true){
                listFieldTemp.add(fieldMap);
            }
            else{
                submissions.put(fieldMap.label,fieldMap);   
            }
        }
        if(masterSubmissionList.size()>0){
            for(MUSW__Master_Submission_List__c master : masterSubmissionList){
                if(submissions.containsKey(master.Name)){
                    listFieldTemp.add(submissions.get(master.Name));
                    System.debug('submission'+submissions.get(master.Name));
                }
                else{
                    System.debug('Create new submission'+master.id);
                    LnP_ApplyForLicenseWrapper.MapLabelToFields submissionMap = new LnP_ApplyForLicenseWrapper.MapLabelToFields();
                    submissionMap.label = master.Name;
                    submissionMap.conditionalAnswer = master.Title__c;
                    submissionMap.fieldType = 'Attachment';
                    if(master.Submission_Type__c != null && master.Submission_Type__c.contains('Softcopy: To be Uploaded')){
                            submissionMap.uploadFile = true;
                    }
                    if(master.Submission_Type__c != null && master.Submission_Type__c.contains('Hardcopy: To be Mailed')){
                            submissionMap.acknowledge = true;
                    }
                    if(master.Required__c){
                        submissionMap.isMandatorySub = true;   
                    }
                    listFieldTemp.add(submissionMap);
                }
            }
        }
        listFieldSub.clear();
        listFieldSub.addAll(listFieldTemp);
        System.debug('Field Map'+JSON.serialize(listFieldTemp));
        return wrapperList;
    }
    @AuraEnabled 
    public static String insertApplication(String dataString, Integer tabNumber, Id appId, String Board, String LicenseType, String ApplicationType){
        Boolean questionsIncomplete = false;
        Boolean submissionsIncomplete = false;
        Map<String,List<LnP_Parcel__c>> mapAddress = new  Map<String,List<LnP_Parcel__c>>();
        Set<Id>  setAppId = new Set<Id> ();
        setAppId.add(appId);
        mapAddress = getAddresses(setAppId);
        System.debug('dataString---->'+dataString);
        List<LnP_ApplyForLicenseWrapper> wrapperList = (List<LnP_ApplyForLicenseWrapper>)JSON.deserialize(dataString, List<LnP_ApplyForLicenseWrapper>.class);
        Integer questionsAnswered=0;
        String accountId='';
        if(!wrapperList.isEmpty()){
            accountId =  wrapperList[0].accountId != null ? wrapperList[0].accountId : '';
        }
        wrapperList = fetchSubmission(wrapperList, Board,  LicenseType,  ApplicationType);
        System.debug('Wrapper'+JSON.serialize(wrapperList));
        List<LnP_ApplyForLicenseWrapper.MapLabelToFields> listFields = new List<LnP_ApplyForLicenseWrapper.MapLabelToFields>();
        List<LnP_ApplyForLicenseWrapper.MapLabelToFields> submissionFields = new List<LnP_ApplyForLicenseWrapper.MapLabelToFields>();
        List<User> userInfoData = new  List<User>();
        String queryCondition = ' Id=\''+UserInfo.getUserId()+'\'';
        String queryStr = 'SELECT Username, ContactId, Contact.Name, Contact.AccountId, Contact.Account.Name FROM User WHERE  '+queryCondition + 'Limit 1';
        system.debug('queryStr '+queryStr);
        userInfoData = Utilityclass_withsharing.queryRecords(queryStr);
        Id getContactId = '003r000000EOhBB';
        if(userInfoData[0].ContactId != null){
            getContactId = userInfoData[0].ContactId;
        }
        LnP_JSONParser finalRequest = new LnP_JSONParser();
        List<LnP_JSONParser.CompositeRequest> requestDetailsList = new List<LnP_JSONParser.CompositeRequest>();
        for(LnP_ApplyForLicenseWrapper objWrapper : wrapperList){
            system.debug('objWrapper.labelFieldsMap'+objWrapper.labelFieldsMap);
            if(objWrapper.sectionName.contains('Questions') || objWrapper.sectionName.contains('Financial Guarantee')){
                listFields.addAll(objWrapper.labelFieldsMap);
            }
            if(objWrapper.sectionName.contains('Attachments')){
                submissionFields = objWrapper.labelFieldsMap;
            }
        }
        System.debug('listFields'+JSON.serialize(listFields));
        if(listFields.size()>0){
            Integer count = 0;
            for(LnP_ApplyForLicenseWrapper.MapLabelToFields fieldMap : listFields){
                
                if((fieldMap.value != null && fieldMap.value != '' && fieldMap.value != '--None--') || (fieldMap.multiValues != null && fieldMap.multiValues.size()>0)){
                    //system.debug('inside a methods');
                    LnP_JSONParser.CompositeRequest requestDetails = new LnP_JSONParser.CompositeRequest();
                    requestDetails.method = 'POST';
                    requestDetails.url = '/services/data/v38.0/sobjects/BGCK_Answer__c';
                    requestDetails.referenceId = 'refId'+count;
                    LnP_JSONParser.Body body = new LnP_JSONParser.Body();
                    // system.debug('fieldMap '+fieldMap.value);
                    if(fieldMap.value != null && fieldMap.value != ''){
                        body.Answer = fieldMap.value; 
                    }
                    else{
                        body.Answer = '';
                        for(String str : fieldMap.multiValues){
                            if(body.Answer == ''){
                                body.Answer = str;
                            }
                            else{
                                body.Answer = body.Answer+';'+str;
                            }
                        }
                    }
                    //body.replace('Answer','Answer__c');
                    body.Question = fieldMap.labelId;
                    body.Application = appId;
                    requestDetails.body = body;
                    requestDetailsList.add(requestDetails);
                    count++;
                }
                //system.debug('fieldMap.renderedOnUi '+fieldMap.renderedOnUi);
                if( fieldMap.renderedOnUi!=null && fieldMap.renderedOnUi==true && fieldMap.value != null && fieldMap.value != 'null'){
                    questionsAnswered++;
                }
            }
            //validationForQuestions:
            system.debug('Count '+count);
            system.debug('questionsAnswered '+questionsAnswered);
            if(questionsAnswered != count){
                questionsIncomplete = true;
            }
        }
        if(submissionFields.size()>0){
            
            Set<String> docId = new Set<String>();
            Map<Id,Id> docLinkMap = new Map<Id,Id>();
            Integer count = 0;
            Integer filesSubmitted = 0;
            for(LnP_ApplyForLicenseWrapper.MapLabelToFields fieldMap : submissionFields){
                if(fieldMap.multiValues != null && fieldMap.multiValues.size()>0){
                    docId.addAll(fieldMap.multiValues);
                }
                if(fieldMap.isMandatorySub == true){
                   count++;
                }
                if(fieldMap.isMandatorySub == true && !fieldMap.multiValues.isEmpty()){
                  filesSubmitted++;
                }
            }
            if(docId.size()>0){
                List<ContentDocumentLink> contentLink = new List<ContentDocumentLink>();
                String queryFiles = 'SELECT Id, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE ContentDocumentId IN : XXX';
                contentLink = Utilityclass_withsharing.queryRecordsInClause(queryFiles,docId);
                for(ContentDocumentLink link : contentLink){
                    System.debug('link.LinkedEntityId--->'+link.LinkedEntityId);
                    System.debug('appId--->'+appId);
                    
                    if(link.LinkedEntityId == appId)
                        docLinkMap.put(link.ContentDocumentId,link.Id);
                }    
            }
            system.debug('submissionFields'+submissionFields);
            for(LnP_ApplyForLicenseWrapper.MapLabelToFields fieldMap : submissionFields){
                
                if((fieldMap.multiValues != null && fieldMap.multiValues.size()>0 && fieldMap.uploadFile) ){
                    for(String contentdocId : fieldMap.multiValues){
                        Integer innerCount = 0;
                        LnP_JSONParser.CompositeRequest requestDetails = new LnP_JSONParser.CompositeRequest();
                        requestDetails.method = 'DELETE';
                        requestDetails.url = '/services/data/v38.0/sobjects/ContentDocumentLink/'+docLinkMap.get(contentdocId);
                        requestDetails.referenceId = 'refDocId'+count+innerCount;
                        requestDetailsList.add(requestDetails);
                    }
                }
                LnP_JSONParser.CompositeRequest requestDetailSub = new LnP_JSONParser.CompositeRequest();
                requestDetailSub.method = 'POST';
                requestDetailSub.url = '/services/data/v38.0/sobjects/MUSW_Submission__c';
                requestDetailSub.referenceId = 'refSubId'+count;
                LnP_JSONParser.Body bodySub = new LnP_JSONParser.Body();
                bodySub.Name = fieldMap.conditionalAnswer;
                bodySub.MUSW_Description = fieldMap.label;
                bodySub.MUSW_Application2= appId;
                bodySub.Hardcopy = fieldMap.acknowledgeResponse;
                bodySub.ContentDocumentId ='';
                if((fieldMap.multiValues != null && fieldMap.multiValues.size()>0 && fieldMap.uploadFile) ){
                    for(String contentdocId : fieldMap.multiValues){
                        Integer innerCount = 0;
                        LnP_JSONParser.CompositeRequest requestDetailsContent = new LnP_JSONParser.CompositeRequest();
                        requestDetailsContent.method = 'POST';
                        requestDetailsContent.url = '/services/data/v38.0/sobjects/ContentDocumentLink';
                        requestDetailsContent.referenceId = 'refContId'+count;
                        LnP_JSONParser.Body bodyLink = new LnP_JSONParser.Body();
                        bodyLink.LinkedEntityId = '@{refSubId'+count+'.id}';
                        bodyLink.ContentDocumentId = contentdocId;
                        bodyLink.ShareType = 'I';
                        requestDetailsContent.body = bodyLink;
                        requestDetailsList.add(requestDetailsContent); 
                        
                        bodySub.ContentDocumentId = contentdocId +';'+ bodySub.ContentDocumentId ;
                    }
                }
                requestDetailSub.body = bodySub;
                requestDetailsList.add(requestDetailSub);
            }
            //validationForSubmissions:
            if(filesSubmitted != count){//change logic to not equals to count, where count is the number of complete submissions
                submissionsIncomplete = true;
            }
        }
        finalRequest.compositeRequest = requestDetailsList;
        String JSONstr = JSON.serialize(finalRequest);
        System.debug('JSONstr-->'+JSONstr);
        Map<String,Object> field = (Map<String,Object>)JSON.deserializeUntyped(JSONstr);
        List<Object> keyValueList = new List<Object>();
        keyValueList = (List<Object>)field.get('compositeRequest');
        for(Object obj : keyValueList){
            Map<String,Object> mapObj1 = (Map<String,Object>)obj;
            Map<String,Object> fieldmap = (Map<String,Object>)mapObj1.get('body');
            if(fieldmap != null){
                for(String key : fieldmap.keySet()){
                    if(fieldmap.get(key) == '' || fieldmap.get(key) == null){
                        fieldmap.remove(key);
                    }
                    else if(key.contains('_x_')){
                        String temp = key.replace('_x_','__');
                        fieldmap.put(temp,fieldmap.get(key));
                        fieldmap.remove(key);
                    }
                }
            }
            else{
                mapObj1.remove('body');
            }
        }
        System.debug('Map of JSON--->'+JSON.serialize(field));
        System.debug('tabNumber-->'+tabNumber);
        String jsonString = JSON.serialize(field);
        List<MUSW_Application2__c> appList =new List<MUSW_Application2__c>();
        String appCondition = 'Id=\''+appId+'\'';
        String strApp = 'Select Id, Stage__c, Application_Type__c,  Board__c, License_Type__c, (Select Id, Sequence__c, LnP_Form_JSON__c from License_Application__r ORDER BY Sequence__c ASC),(Select Id, Name from Education_History__r ) from MUSW_Application2__c where '+appCondition;
        appList = Utilityclass_withsharing.queryRecords(strApp);
        List<Education_History__c> lstEducations = new List<Education_History__c>();
        
        MUSW_Application2__c application = new MUSW_Application2__c();
        if(appList.size()>0){
            List<LnP_Licence_Application__c> listAppDelete = new List<LnP_Licence_Application__c>();
            if(appList[0].License_Application__r != null && appList[0].License_Application__r.size()>0){
                listAppDelete.addAll(appList[0].License_Application__r);
            }
            
            if(appList[0].Education_History__r != null && appList[0].Education_History__r.size() >0){
               // lstEducations = 
                lstEducations.addAll(appList[0].Education_History__r);
            }
            delete listAppDelete;
            application = appList[0];
            application.id = appList[0].id;
            application.Stage__c = Integer.valueOf(tabNumber);
           // application.MUSW_Applicant__c = getContactId;
            
        }
        else{
            application.MUSW_Applicant__c = getContactId;
            application.Stage__c = Integer.valueOf(tabNumber);
        }
        upsert application;
        appId = application.Id; 
        Integer count = 1;
        List<LnP_Licence_Application__c> listApp = new List<LnP_Licence_Application__c>();
        while(count != 20){
            LnP_Licence_Application__c applicationChild = new LnP_Licence_Application__c();
            applicationChild.Contact__c = getContactId;
            applicationChild.Sequence__c = count;
            if(accountId != ''){
                applicationChild.Account__c = accountId;
            }
            
            applicationChild.Application__c = appId;
            if(jsonString.length() <= 32768){
                applicationChild.LnP_Form_JSON__c = jsonString;
                listApp.add(applicationChild);
                break;
            }
            else{
                applicationChild.LnP_Form_JSON__c = jsonString.subString(0,32768);
                jsonString = jsonString.subString(32768,jsonString.length());
            }
            listApp.add(applicationChild);
            count++;
        }  
        insert listApp;
        string recID = listApp[0].ID;
        system.debug('listApp'+ recID);
        
        //Subsection  error
        List<String> lstMandatorySubsection;
        for(LnP_ApplyForLicenseWrapper objWrapper : wrapperList){
           objWrapper.sectionError = false;
           lstMandatorySubsection= new List<String> ();
            if(objWrapper.sectionName.contains('Questions') && questionsIncomplete==true){
                objWrapper.sectionError = true;
            }
            if(objWrapper.mandatorySubsection != null){
                lstMandatorySubsection = objWrapper.mandatorySubsection.split(',') ;
                if(lstMandatorySubsection != null){
                    for(String mandatorySubSection : lstMandatorySubsection){
                        system.debug('mandatorySubsection098'+ mandatorySubSection);
                        if(mandatorySubSection == 'Qualifying Education' && lstEducations.isEmpty()) {
                            objWrapper.sectionError = true;
                        }
                        if((mandatorySubSection == 'Physical Address' || mandatorySubSection == 'Mailing Address')){
                            if(mapAddress.isEmpty()){
                                objWrapper.sectionError = true;
                            } else if(mapAddress.get(mandatorySubSection) == null ||  mapAddress.get(mandatorySubSection).size() == 0 ){
                                system.debug('inside the mandatory');
                                objWrapper.sectionError = true;
                            }
                        }
                    }
                } 
            }

            
        }
        system.debug('wrapperList123'+wrapperList);
        return JSON.serialize(wrapperList);
    }
    @AuraEnabled
    public static string callCompositeAPI(String applicationId){
        List<MUSW_Application2__c> appList =new List<MUSW_Application2__c>();
        Set<Id>  setapplicationId =  new Set<Id> ();
        String licenseID;
        // string applicationId2 = string.valueOf(applicationId).substring(0, 15);
        setapplicationId.add(applicationId);
        String appCondition = 'Id=\''+applicationId+'\'';
        String strApp = 'Select Id, Stage__c, Application_Type__c,  Board__c, License_Type__c, (Select Id, Sequence__c, LnP_Form_JSON__c from License_Application__r ORDER BY Sequence__c ASC) from MUSW_Application2__c where '+appCondition;
        appList = Utilityclass_withsharing.queryRecords(strApp);
        system.debug('Applist In AController--->'+appList);
        String stringJSON = '';
        System.debug('appList '+appList);
        System.debug('appList[0].Stage__c '+appList[0].Stage__c);
        if(appList != null && appList.size()>0 && appList[0].Stage__c != -1){
            if(appList[0].License_Application__r != null && appList[0].License_Application__r.size()>0){
                for(LnP_Licence_Application__c app : appList[0].License_Application__r){
                    stringJSON = stringJSON + app.LnP_Form_JSON__c;
                }
            }
            system.debug('stringJSONfianl'+stringJSON);
            stringJSON = stringJSON.replaceAll('\\bAnswer\\b', 'Answer__c');
            stringJSON = stringJSON.replaceAll('\\bQuestion\\b', 'Question__c');
             stringJSON = stringJSON.replaceAll('\\bApplication\\b', 'Application__c');
            stringJSON = stringJSON.replaceAll('\\bMUSW_Application2\\b', 'MUSW_Application2__c');
            stringJSON = stringJSON.replaceAll('\\bMUSW_Description\\b', 'MUSW_Description__c');
            stringJSON = stringJSON.replaceAll('\\bContentDocumentId\\b', 'ContentDocumentId__c');
            system.debug('stringJSON '+stringJSON);
            //stringJSON.replaceAll('Answer', 'Answer__c');
            system.debug('String sessionId=UserInfo.getSessionId();'+UserInfo.getSessionId());
            HttpRequest req = new HttpRequest();
            
            req.setEndpoint('https://wadolbuspro--dev.my.salesforce.com/services/data/v39.0/composite/');
            req.setMethod('POST');
            String sessionId=UserInfo.getSessionId();
            req.setHeader('Authorization', 'Bearer '+ sessionId);
            req.setHeader('Content-Type','application/json');
            req.setBody(stringJSON);
            Http http = new Http();
            HTTPResponse res = http.send(req);
            System.debug('ResponseBody'+res.getBody());
            System.debug('Response ' + res.getStatusCode());
            appList[0].Stage__c = -1;
            appList[0].Status__c = 'Under Review';
            licenseID =insertLisence(setapplicationId);
            update appList[0];
            
        }
        return licenseID;
    }
    private static ID insertLisence(Set<Id> appId){
        List<MUSW__License2__c> lstLisence = new List<MUSW__License2__c>();
        Id businessRT = SObjectType.MUSW__License2__c.getRecordTypeInfosByDeveloperName().get('Business').getRecordTypeId();
        Id individualRT = SObjectType.MUSW__License2__c.getRecordTypeInfosByDeveloperName().get('Universal_Default_License_Record_Type').getRecordTypeId();
        List<MUSW_Application2__c> applicationList = [SELECT Id,Application_Type__c,Board__c,License_Type__c,MUSW_Account__c,MUSW_Applicant__c FROM MUSW_Application2__c where id IN: appId];
        for(MUSW_Application2__c application : applicationList){
            MUSW__License2__c  mstLicense =  new MUSW__License2__c();
            mstLicense.MUSW__Applicant__c = application.MUSW_Applicant__c;
            mstLicense.Application_Type__c = application.Board__c;
            mstLicense.Credential_Type__c = application.License_Type__c;
            mstLicense.Credential__c = application.License_Type__c;
            mstLicense.Application_Method__c = application.Application_Type__c;
            if(application.MUSW_Account__c!=null)
            {
                mstLicense.RecordTypeId = businessRT;
            }
            else
            {
                mstLicense.RecordTypeId = individualRT;
            }
            mstLicense.License_Application__c = application.id;
            mstLicense.MUSW__Applicant__c = application.MUSW_Applicant__c;
            mstLicense.MUSW__Primary_Licensee__c = '001r000000Cax8Y';
            mstLicense.MUSW__Status__c = 'Generate Fee';
            mstLicense.Name = 'System Number';
            lstLisence.add(mstLicense);
        }
        if(!lstLisence.isEmpty()){
            insert lstLisence;
        }
        return lstLisence[0].Id;
        
    }
    @AuraEnabled
    public static String fetchBoardLabels(String customLabelAPI, String board){
        Map<String, String> labelMap = new Map<String, String>();
        labelMap = LnP_AllBoardsLabels.fetchBoardLabel(board);        
        String var = labelMap.get(customLabelAPI);
        return var;
    }
    
    @AuraEnabled
    public static Map<Id, Contact> UserInfo(){
        
        Map<Id, Contact> conMap = new Map<Id, Contact>();
        id userId = UserInfo.getUserId();
        User u = [select id, contactId from User where id = : userId];
        system.debug('u----' + u);
        Id getContactId = '003r000000BnY6T';
        system.debug('getContactId----' + getContactId);
        list<Contact> conlist = new list<Contact>();
        for(Contact con : [Select Id, LastName, Birthdate, Email from contact where Id=:getContactId]){
            conMap.put(con.Id, con);
            system.debug('conMap----' + conMap);
        }
        return conMap;
    }
    public static LnP_JSONParser getJSONWrapper(List<LnP_Licence_Application__c> appList){
        system.debug('appList'+appList);
        String str = '';
        for(LnP_Licence_Application__c app : appList){
            str = str + app.LnP_Form_JSON__c;
        }
        system.debug('strinhggggff '+str);
        Map<String,Object> field = (Map<String,Object>)JSON.deserializeUntyped(str);
        //  system.debug('fieldmap'+field);
        str = JSON.serialize(field);
        system.debug('fieldmap string'+str);
        LnP_JSONParser parser = LnP_JSONParser.parse(str);
        System.debug('Map of JSON--->'+parser);
        return parser;
    }
    //Fetch all the addresses
    public static Map<String, List<LnP_Parcel__c>> getAddresses (Set<Id> appId){
        Map<String, List<LnP_Parcel__c>> mapAddress  =  new Map<String,List<LnP_Parcel__c>>();
        List<LnP_Parcel__c> lstAddress  = [SELECT Id, Address_Type__c, Application__c, City__c, Country__c, State_Province__c, Street__c, Zip_Postal_Code__c 
                                           FROM LnP_Parcel__c WHERE Application__c IN :appId];
        if(!lstAddress.isEmpty()){
            for(LnP_Parcel__c parcelAddress : lstAddress) {
                if(mapAddress.containsKey(parcelAddress.Address_Type__c)) {
                    mapAddress.get(parcelAddress.Address_Type__c).add(parcelAddress);
                } else {
                    mapAddress.put(parcelAddress.Address_Type__c, new List<LnP_Parcel__c>{parcelAddress});
                }
            }
        }
        return  mapAddress ;
    }
    public static String getFormattedValue(String str) {
        return str != null ? str.replace('\r\n', ' ').replace('\n', ' ').escapeHtml4() : str;
    }
    
}