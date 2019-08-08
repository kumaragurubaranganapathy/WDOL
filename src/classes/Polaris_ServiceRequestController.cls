public class Polaris_ServiceRequestController {
    public static Map<String,String> mapSubsectionIcon {get;set;}
    public static String sections {get;set;}
    public static List<Question__c> lstQuestions {get;set;} 
    public static List<MUSW__Master_Submission_List__c> lstMasterSubmission {get;set;}
    public static List<Request__c> lstApps {get;set;}   
     public static List<User> lstUserInfoData {get;set;}
    
    @AuraEnabled(cacheable = true)
    public static String fetchData(String board,String licenseType,String requestType, String requestId, String flowType)
    {
        system.debug('board : '+board+'  licenseType : '+licenseType+' requestType : '+requestType+' requestId: '+requestId+' flowType:'+flowType);
        //Creating the conditions for fetching the data       
        Integer tabIndex = 1;
        Integer currentTab = 0;
        LnP_JSONParser ansWrapper; //to create Wrapper 
        String jsonApplicationFields = '';
        List<LnP_ApplyForLicenseWrapper> lstLicenseWrapper = new List<LnP_ApplyForLicenseWrapper>();
        //Fetching data for subsection icon
      //  Map<String,String> mapTempSubsectionIcon = Polaris_ServiceRequestService.fetchSubsectionIcons(System.Label.Application_Management_Request);
        Map<String,String> mapTempSubsectionIcon = Polaris_ServiceRequestService.fetchSubsectionIcons(System.Label.Page_Name_For_License);
        mapSubsectionIcon = new Map<String,String>();
        if(mapSubsectionIcon.isEmpty() && !mapTempSubsectionIcon.isEmpty())
        {
            mapSubsectionIcon = mapTempSubsectionIcon;
        }
        //Fetching Section
        List<AMR_Link__mdt> lstSections = new List<AMR_Link__mdt>();
       // List<LnP_License_Type_Sections_Setting__mdt> lstSections = new List<LnP_License_Type_Sections_Setting__mdt>();
        lstSections = Polaris_ServiceRequestService.fetchSection(board,licenseType,requestType,flowType);
        if(!lstSections.isEmpty())
        {
            sections = lstSections[0].Sections__c;
        }
        system.debug('sections'+sections);
        List<String> lstOfSections = sections.split(',');
        //Fetching the questions in the system per licenseType and applicationType for general application and comity
        lstQuestions = new List<Question__c>();
        List<Question__c> lstTempQuestions = Polaris_ServiceRequestService.fetchQuestionsDetails(board,licenseType,requestType,flowType);
        if(!lstTempQuestions.isEmpty())
        {
            lstQuestions = lstTempQuestions;
        }
        //Fetching the Master submission list in the system per licenseType and applicationType for general application and comity
        lstMasterSubmission = new List<MUSW__Master_Submission_List__c>();
        List<MUSW__Master_Submission_List__c> lstTempMasterSubmission = Polaris_ServiceRequestService.fetchMasterSubmissionDetails(board,licenseType,requestType,flowType);
        if(!lstTempMasterSubmission.isEmpty())
        {
            lstMasterSubmission = lstTempMasterSubmission;
        }    
        
        lstApps = new List<Request__c>();
        List<Request__c> lstTempApplication =new List<Request__c>();
        lstTempApplication = Polaris_ServiceRequestService.fetchApplications(requestId);
        if(!lstTempApplication.isEmpty())
        { 
            lstApps = lstTempApplication;
        }
         if(lstApps.size() >0 && lstApps[0].Stage__c != null && lstApps[0].Form_JSON__c != '' )
        {
            currentTab = Integer.valueOf(lstApps[0].Stage__c); 
            ansWrapper = getJSONWrapper(lstApps[0].Form_JSON__c);
        }
        
                //List for Attachment section section
        List<LnP_ApplyForLicenseWrapper.MapLabelToFields> lstMapLabelFieldsForSubmission = new List<LnP_ApplyForLicenseWrapper.MapLabelToFields>();   
        for(MUSW__Master_Submission_List__c masterSubmissionRecord : lstMasterSubmission)
        {
            LnP_ApplyForLicenseWrapper.MapLabelToFields mapLabel = new LnP_ApplyForLicenseWrapper.MapLabelToFields();
            mapLabel.label = masterSubmissionRecord.Name;
            mapLabel.conditionalAnswer = masterSubmissionRecord.Title__c;
            mapLabel.fieldType = 'Attachment';
            mapLabel.isGenericSub = true;
            
            if(masterSubmissionRecord.Submission_Type__c != null && masterSubmissionRecord.Submission_Type__c.contains('Softcopy: To be Uploaded')){
                mapLabel.uploadFile = true;
            }
            if(masterSubmissionRecord.Submission_Type__c != null && masterSubmissionRecord.Submission_Type__c.contains('Hardcopy: To be Mailed')){
                mapLabel.acknowledge = true;
            }
            mapLabel.isMandatorySub = false; 
            if(masterSubmissionRecord.Required__c){
                mapLabel.isMandatorySub = true;   
            }
            if(ansWrapper != null && ansWrapper.compositeRequest != null){
                for(LnP_JSONParser.CompositeRequest req : ansWrapper.compositeRequest){
                    if(masterSubmissionRecord.Name !=null && req.body!=null && req.body.MUSW_Description!= null && req.body.MUSW_Description == masterSubmissionRecord.Name){                                   
                        mapLabel.acknowledgeResponse = req.body.Hardcopy;
                        if(req.body.ContentDocumentId != null && req.body.ContentDocumentId.contains(';')){
                            mapLabel.multiValues = req.body.ContentDocumentId.split(';');
                        }
                        
                    }
                    
                }
                
            }
            
            lstMapLabelFieldsForSubmission.add(mapLabel);
        }
        //Map for Question Section
        Map<String,List<LnP_ApplyForLicenseWrapper.MapLabelToFields>> mapOnQuestions = new Map<String,List<LnP_ApplyForLicenseWrapper.MapLabelToFields>>();
        
        String questionSection = '';
        system.debug('lstQuestions :'+lstQuestions);
        for(Question__c Ques : lstQuestions )
        {
            LnP_ApplyForLicenseWrapper.MapLabelToFields labelToFields = new LnP_ApplyForLicenseWrapper.MapLabelToFields();
            labelToFields.label = Ques.Question_Body__c;
            labelToFields.labelId = Ques.Id;
            labelToFields.fieldType = Ques.Data_Type__c;
            labelToFields.hasChild = Ques.Has_dependent_questions__c;
            labelToFields.parentQuestionId = Ques.Parent_Question__c;
            labelToFields.submissionDetails = Ques.Submission_Title__c;
            labelToFields.questionSectionClass = Ques.Section__c;
            labelToFields.message = Ques.Message__c;
            labelToFields.messageTriggerResponse = Ques.MessageTriggerResponse__c;
            if(questionSection == Ques.Section__c || Ques.Section__c==null)
            {
                labelToFields.questionSection ='null';
            }
            else
            {
                labelToFields.questionSection = Ques.Section__c;
                questionSection = Ques.Section__c;
                labelToFields.questionSectionDetail = Ques.Sub_Header__c;
            }
            if(Ques.Parent_Question__c != null)
            {
                labelToFields.isChild = true;
                labelToFields.renderedOnUi = false;
            }
            else
            {
                labelToFields.isChild = false;
                labelToFields.renderedOnUi = true;
            }
            labelToFields.fieldAPIName = Ques.QuestionFieldAPI__c;
            labelToFields.fieldObjName = Ques.QuestionObjectName__c;
            labelToFields.conditionalAnswer = Ques.Triggering_Parent_Answer__c;
            if(Ques.Possible_Responses__c != null && Ques.Data_Type__c == 'Picklist')
            {
                labelToFields.fieldValueOptions = Ques.Possible_Responses__c.split(';');
            }
            else if(Ques.Possible_Responses__c != null && (Ques.Data_Type__c == 'Radio'||Ques.Data_Type__c == 'Checkbox'||Ques.Data_Type__c == 'Yes_No'))
            { 
                for(String radio : Ques.Possible_Responses__c.split(';')){
                    LnP_ApplyForLicenseWrapper.MapRadioButtons radioMap = new LnP_ApplyForLicenseWrapper.MapRadioButtons();
                    radioMap.label = radio;
                    radioMap.value = radio;
                    labelToFields.radioValueOptions.add(radioMap);
                }
            }
            if(ansWrapper != null && ansWrapper.compositeRequest != null)
            {
                for(LnP_JSONParser.CompositeRequest req : ansWrapper.compositeRequest)
                {
                    if(req.body!=null && req.body.Question == Ques.Id)
                    {
                        if(req.body.Answer.contains(';'))
                        {
                            labelToFields.multiValues = req.body.Answer.split(';');
                            labelToFields.acknowledgeResponse = req.body.Hardcopy;
                        }
                        else
                        {
                            labelToFields.value = req.body.Answer;                            
                        }
                    }
                    
                }
            }
            
            if(mapOnQuestions.containsKey(Ques.Sub_Sub_Header__c))
            {
                mapOnQuestions.get(Ques.Sub_Sub_Header__c).add(labelToFields);
            }
            else
            {
                mapOnQuestions.put(Ques.Sub_Sub_Header__c,new List<LnP_ApplyForLicenseWrapper.MapLabelToFields>{labelToFields});  
            }
        }
        system.debug('lstOfSections : '+lstOfSections);
        
        for(String section : lstOfSections)
        {
            LnP_ApplyForLicenseWrapper licenseWrapper = new LnP_ApplyForLicenseWrapper();
            licenseWrapper.sectionName = section;
            licenseWrapper.subheader = section;
            licenseWrapper.currentTab = currentTab;
            licenseWrapper.tabIndex = tabIndex;
            if(!mapSubsectionIcon.isEmpty() && mapSubsectionIcon.containsKey(section+' icon'))
            {
                licenseWrapper.icon = mapSubsectionIcon.get(section+' icon');              
            }
            if(section =='Attachments')
            {
                licenseWrapper.sobjectType = 'Submission';
                if(!lstMapLabelFieldsForSubmission.isEmpty())
                {
                    licenseWrapper.labelFieldsMap.addAll(lstMapLabelFieldsForSubmission);
                }
            }
            else
            {
                system.debug('mapOnQuestions : '+mapOnQuestions);
                if(!mapOnQuestions.isEmpty() && mapOnQuestions.containsKey(section))
                {
                    licenseWrapper.labelFieldsMap.addAll(mapOnQuestions.get(section));
                }
            }
            system.debug('licenseWrapper : '+licenseWrapper);
            lstLicenseWrapper.add(licenseWrapper);
            tabIndex++;
        }
        system.debug('lstLicenseWrapper : '+JSON.serialize(lstLicenseWrapper));            
       return JSON.serialize(lstLicenseWrapper); 
    }
    
    private static LnP_JSONParser getJSONWrapper(String formJson){
        
        String strJsonForm = '';     
        strJsonForm = strJsonForm + formJson;             
        Map<String,Object> mapfield = (Map<String,Object>)JSON.deserializeUntyped(strJsonForm);        
        strJsonForm = JSON.serialize(mapfield);        
        LnP_JSONParser parser = LnP_JSONParser.parse(strJsonForm);
        System.debug('Map of JSON--->'+parser);
        return parser;
    }
    
     public static List<LnP_ApplyForLicenseWrapper> fetchSubmission(List<LnP_ApplyForLicenseWrapper> wrapperList,String Board, String LicenseType, String ApplicationType){
        Set<String> submissionList  = new Set<String>(); 
        List<LnP_ApplyForLicenseWrapper.MapLabelToFields> listFields = new List<LnP_ApplyForLicenseWrapper.MapLabelToFields>();
        List<MUSW__Master_Submission_List__c> masterSubmissionList = new List<MUSW__Master_Submission_List__c>();
        List<LnP_ApplyForLicenseWrapper.MapLabelToFields> listFieldSub = new List<LnP_ApplyForLicenseWrapper.MapLabelToFields>();
        List<LnP_ApplyForLicenseWrapper.MapLabelToFields> listFieldTemp = new List<LnP_ApplyForLicenseWrapper.MapLabelToFields>();
        //List<string> lstMandatorySubSections= new  List<string>();
        for(LnP_ApplyForLicenseWrapper objWrapper : wrapperList){
            if(objWrapper.sectionName.contains('License Information') || objWrapper.sectionName.contains('Endorsement') || objWrapper.sectionName.contains('Request Information') ){
                system.debug('Inside section=Question');
                listFields = objWrapper.labelFieldsMap;
                system.debug('List Fields '+listFields);
            }
            if(objWrapper.sectionName.contains('Attachments')){
                listFieldSub = objWrapper.labelFieldsMap;
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
        //String mastSubCond2 = 'Application_Method__c =\''+ApplicationType+'\'';
        String mastSubCond3 = 'Credential_Type__c =\''+LicenseType+'\' AND' + ' Default__c = false';
        String mastSubCond4 = 'Title__c IN: XXX';
        String strSubmission = 'Select Id, Name,Title__c,Question__c,Expected_Answer__c,Submission_Type__c, Required__c,  Active__c, Default__c, Application_Type__c, Credential_Type__c, Application_Method__c from MUSW__Master_Submission_List__c where ' +mastSubCond1+ ' AND '+mastSubCond3+ ' AND ' +mastSubCond4;
        system.debug('submissionList'+submissionList);
        masterSubmissionList = Utilityclass_withsharing.queryRecordsInClause(strSubmission,submissionList);
        system.debug('masterSubmissionList12345'+masterSubmissionList);
        
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
        Boolean submissionsIncomplete = true;
        Map<String,List<LnP_Parcel__c>> mapAddress = new  Map<String,List<LnP_Parcel__c>>();
        Map<String,List<LnP_BackgroundSection__c>> mapEducation = new  Map<String,List<LnP_BackgroundSection__c>>();
        Set<Id>  setAppId = new Set<Id> ();
        setAppId.add(appId);
       mapAddress = getAddresses(setAppId);
       mapEducation = getBackgroundInformation(setAppId);
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
        lstUserInfoData = new List<User>();
        List<User> lstuserData  = Polaris_ServiceRequestService.fetchUserDetails();
        String getContactId ='';
        if(!lstuserData.isEmpty())
        {
            lstUserInfoData = lstuserData;
        }
        
        if(lstUserInfoData[0].ContactId != null)
        {
            getContactId = lstUserInfoData[0].ContactId;
        }
        LnP_JSONParser finalRequest = new LnP_JSONParser();
        List<LnP_JSONParser.CompositeRequest> requestDetailsList = new List<LnP_JSONParser.CompositeRequest>();
        for(LnP_ApplyForLicenseWrapper objWrapper : wrapperList){
            system.debug('objWrapper.labelFieldsMap'+objWrapper.labelFieldsMap);
            if(objWrapper.sectionName.contains('License Information') || objWrapper.sectionName.contains('Financial Guarantee') || objWrapper.sectionName.contains('Endorsement') || objWrapper.sectionName.contains('Request Information')){
                listFields.addAll(objWrapper.labelFieldsMap);
            }
            if(objWrapper.sectionName.contains('Attachments')){
                submissionFields = objWrapper.labelFieldsMap;
            }
        }
        System.debug('listFields'+JSON.serialize(listFields));
        if(listFields.size()>0){
            Integer count = 0;
            Integer questioncount = 0;
            for(LnP_ApplyForLicenseWrapper.MapLabelToFields fieldMap : listFields){
                
                if((fieldMap.value != null  && fieldMap.value != '' && fieldMap.value != '--None--') || (fieldMap.multiValues != null && fieldMap.multiValues.size()>0)){
                    //system.debug('inside a methods');
                    LnP_JSONParser.CompositeRequest requestDetails = new LnP_JSONParser.CompositeRequest();
                    requestDetails.method = 'POST';
                    requestDetails.url = '/services/data/v38.0/sobjects/BGCK__Answer__c';
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
                    //body.MUSW_Description = fieldMap.questionSectionClass;
                    body.Application = appId;
                    requestDetails.body = body;
                    requestDetailsList.add(requestDetails);
                    
                }
                if(fieldMap.renderedOnUi!=null && fieldMap.renderedOnUi == true && fieldMap.questionSectionClass.contains('Questions') || fieldMap.questionSectionClass.contains('Financial Guarantee') || fieldMap.questionSectionClass.contains('Endorsement')){
                    count++;  
                }
                if(fieldMap.renderedOnUi!=null && fieldMap.renderedOnUi == true && fieldMap.questionSectionClass.contains('Questions') ){
                    questioncount++;
                }
                //system.debug('fieldMap.renderedOnUi '+fieldMap.renderedOnUi);
                if( fieldMap.questionSectionClass.contains('Questions')  && fieldMap.renderedOnUi!=null && fieldMap.renderedOnUi==true && fieldMap.value != null && fieldMap.value !='' ){
                    questionsAnswered++;
                }
            }
            //validationForQuestions:
            system.debug('Count '+count);
            system.debug('questioncount '+questioncount);
            system.debug('questionsAnswered '+questionsAnswered);
            if(questionsAnswered != questioncount ){
                questionsIncomplete = true;
            }
        }
        if(submissionFields.size()>0){
            Set<String> docId = new Set<String>();
            Map<Id,Id> docLinkMap = new Map<Id,Id>();
            Integer filesSubmitted = 0;
            for(LnP_ApplyForLicenseWrapper.MapLabelToFields fieldMap : submissionFields){
                if(fieldMap.multiValues != null && fieldMap.multiValues.size()>0){
                    docId.addAll(fieldMap.multiValues);
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
            Integer count = 0;
            system.debug('submissionFields'+submissionFields);
            for(LnP_ApplyForLicenseWrapper.MapLabelToFields fieldMap : submissionFields){
                if(fieldMap.isMandatorySub == true){
                    count++;
                }
                if(fieldMap.isMandatorySub == true && !fieldMap.multiValues.isEmpty()){
                    filesSubmitted++;
                }
                system.debug('counttotal'+count);
                system.debug('filesSubmitted'+filesSubmitted);
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
                requestDetailSub.url = '/services/data/v38.0/sobjects/MUSW__Submission__c';
                requestDetailSub.referenceId = 'refSubId'+count;
                LnP_JSONParser.Body bodySub = new LnP_JSONParser.Body();
                bodySub.Name = fieldMap.conditionalAnswer;
                bodySub.MUSW_Description = fieldMap.label;
                bodySub.MUSW_Application2 = appId;
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
            submissionsIncomplete = false;
            if(filesSubmitted != count) {//change logic to not equals to count, where count is the number of complete submissions
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
        List<Request__c> appList =new List<Request__c>();
        String appCondition = 'Id=\''+appId+'\'';
        //String strApp = 'Select Id, Stage__c, Application_Type__c,  Board__c, License_Type__c, (Select Id, Sequence__c, LnP_Form_JSON__c from License_Application__r ORDER BY Sequence__c ASC),(Select Id, Name from Education_History__r ) from MUSW_Application2__c where '+appCondition;
        String strApp = 'Select Id,Status__c,Stage__c, Profession__c,   License_Type__c from Request__c where '+appCondition;
        appList = Utilityclass_withsharing.queryRecords(strApp);
        List<Education_History__c> lstEducations = new List<Education_History__c>();
        
        Request__c application = new Request__c();
        if(appList.size()>0){
            application = appList[0];
            application.id = appList[0].id;
            application.Stage__c = Integer.valueOf(tabNumber);            
        }
        else{
            application.Contact__c = getContactId;
            application.Stage__c = Integer.valueOf(tabNumber);
        }
        
        appId = application.Id; 
        Integer count = 1;
        
        while(count != 20){
            if(jsonString.length() <= 131072){
                application.Form_JSON__c = jsonString;
                break;
            }
            else{
                application.Form_JSON__c = jsonString.subString(0,32768);
                jsonString = jsonString.subString(32768,jsonString.length());
            }
            count++;
        }  
        
        //Subsection  error
        List<String> lstMandatorySubsection;
        for(LnP_ApplyForLicenseWrapper objWrapper : wrapperList){
            objWrapper.sectionError = false;
            lstMandatorySubsection= new List<String> ();
            if(objWrapper.sectionName.contains('License Information') && questionsIncomplete==true){
                objWrapper.sectionError = true;
            } 
            if(objWrapper.sectionName.contains('Request Information') && questionsIncomplete==true){
                objWrapper.sectionError = true;
            } 
            if(objWrapper.sectionName.contains('Attachments') && submissionsIncomplete == true){
                objWrapper.sectionError = true;
            }
            if(objWrapper.mandatorySubsection != null){
                lstMandatorySubsection = objWrapper.mandatorySubsection.split(',') ;
                if(lstMandatorySubsection != null){
                    for(String mandatorySubSection : lstMandatorySubsection){
                        system.debug('mandatorySubsection098'+ mandatorySubSection);
                        if((mandatorySubSection == 'Physical Address' || mandatorySubSection == 'Mailing Address')){
                            if(mapAddress.isEmpty()){
                                objWrapper.sectionError = true;
                            } else if(mapAddress.get(mandatorySubSection) == null ||  mapAddress.get(mandatorySubSection).size() == 0 ){
                                system.debug('inside the mandatory');
                                objWrapper.sectionError = true;
                            }
                        }
                        else if((mandatorySubSection == 'Qualifying Education' || mandatorySubSection == 'Qualifying Training' || mandatorySubSection == 'Qualifying Experience')  ){
                            if(mapEducation.isEmpty()){
                                objWrapper.sectionError = true;
                            } else if(mapEducation.get(mandatorySubSection) == null ||  mapEducation.get(mandatorySubSection).size() == 0 ){
                                system.debug('inside the mandatory');
                                objWrapper.sectionError = true;
                            }
                        }
                    }
                } 
            }
            
            
        }
        upsert application;
        system.debug('wrapperList123'+wrapperList);
        return JSON.serialize(wrapperList);
    }
    
    @AuraEnabled
    public static List<Request__c> callCompositeAPI(String applicationId,String description){
        List<Request__c> appList =new List<Request__c>();
        Map<String,String> mapSubmissionToFile = new Map<String,String>();
        Set<Id>  setapplicationId =  new Set<Id> ();
        List<Request__c> licenseID;
        // string applicationId2 = string.valueOf(applicationId).substring(0, 15);
        setapplicationId.add(applicationId);
        String appCondition = 'Id=\''+applicationId+'\'';
        // String strApp = 'Select Id, Stage__c, Application_Type__c,  Credential_Type__c, Application_Method__c, (Select Id, Sequence__c, LnP_Form_JSON__c from License_Application__r ORDER BY Sequence__c ASC) from MUSW__Application2__c where '+appCondition;
        String strApp = 'Select Id,Service_Request_Type__c, Stage__c, License__c,Form_JSON__c, Profession__c,  License_Type__c from Request__c where '+appCondition;
        system.debug('StrApp Query--->'+strApp);
        appList = Utilityclass_withsharing.queryRecords(strApp);
        system.debug('Applist In AController--->'+appList);
        String stringJSON = '';
        stringJSON = appList[0].Form_JSON__c;
        // System.debug('appList '+appList);
        Boolean checkSuccess = false;
        //Modified code for handling 25 subrequest governor limit
        
        LnP_JSONParser ansWrapper= Polaris_ServiceRequestController.getJSONWrapper(stringJSON);
        List<LnP_JSONParser.CompositeRequest> requestDetailsList = new List<LnP_JSONParser.CompositeRequest>();
        for(LnP_JSONParser.CompositeRequest req : ansWrapper.compositeRequest){
            requestDetailsList.add(req);
        }
        List<List<LnP_JSONParser.CompositeRequest>> compositeReq = Polaris_ServiceRequestService.partition(requestDetailsList,24);
        System.debug('appList[0].Stage__c '+appList[0].Stage__c);
        if(appList != null && appList.size()>0 && appList[0].Stage__c != -1){
               for(List<LnP_JSONParser.CompositeRequest> record: compositeReq) {    
               Map<String,List<LnP_JSONParser.CompositeRequest>> mapList = new  Map<String,List<LnP_JSONParser.CompositeRequest>>();
               mapList.put('compositeRequest',record);
               string strJsonForm = JSON.serialize(mapList);
               strJsonForm = strJsonForm.replaceAll('\\bAnswer\\b', 'Answer_Text__c');
               strJsonForm = strJsonForm.replaceAll('\\bQuestion\\b', 'QuestionDOL__c');
               strJsonForm = strJsonForm.replaceAll('\\bApplication\\b', 'Request__c');
               strJsonForm = strJsonForm.replaceAll('\\bMUSW_Application2\\b', 'Request__c');
               strJsonForm = strJsonForm.replaceAll('\\bMUSW_Description\\b', 'MUSW__Description__c');
               //stringJSON = stringJSON.replaceAll('\\BgckApplication\\b', 'MUSW__Description__c');
               strJsonForm = strJsonForm.replaceAll('\\bContentDocumentId\\b', 'ContentDocumentId__c');
            
            strJsonForm = strJsonForm.replaceAll('\"[^\"]*\":null',''); //basic removeal of null values
            strJsonForm = strJsonForm.replaceAll(',{2,}', ','); //remove duplicate/multiple commas
            strJsonForm = strJsonForm.replace('{,', '{'); //prevent opening brace from having a comma after it
            strJsonForm = strJsonForm.replace(',}', '}'); //prevent closing brace from having a comma before it
            strJsonForm = strJsonForm.replace('[,', '['); //prevent opening bracket from having a comma after it
            strJsonForm = strJsonForm.replace(',]', ']');            
            // stringJSON = stringJSON.replaceAll('\\questionsBody\\b', 'Question_Body__c');
            
            system.debug('stringJSON '+strJsonForm);
            //stringJSON.replaceAll('Answer', 'Answer__c');
            system.debug('String sessionId=UserInfo.getSessionId();'+UserInfo.getSessionId());
            HttpRequest req = new HttpRequest();
            String url = System.Label.CompositeAPIURL;
            req.setEndpoint(url);
            req.setMethod('POST');
            String sessionId=UserInfo.getSessionId();
            req.setHeader('Authorization', 'Bearer '+ sessionId);
            req.setHeader('Content-Type','application/json');
            req.setBody(strJsonForm);
            req.setTimeout(60000);
            Http http = new Http();
            HTTPResponse res = http.send(req);
            System.debug('ResponseBody'+res.getBody());
            System.debug('Response ' + res.getStatusCode());
            if(res.getStatusCode() == 200) {
                checkSuccess = true;
            }
            
        }
            if(checkSuccess ) {
                appList[0].Stage__c = -1;
                if(appList[0].License_Type__c == 'Notary Public' && appList[0].Service_Request_Type__c == 'Endorsement')
                {
                    appList[0].Status__c = 'Approved';
                }
                else
                {
                    appList[0].Status__c = 'Under Review';
                }                
                 appList[0].Description__c = description ;
                //licenseID =insertLisence(setapplicationId);
                //Setup  for the populating the details
                List<Request__c> appListOtherDetils =new List<Request__c>();
                // String strAppOther = 'Select Id, Stage__c, Application_Type__c,  Board__c, License_Type__c,(select id,License__c from MUSW_Submissions__r) ,(select Id,License__c from Answers__r),(Select Id,License__c FROM Employment_History__r),(Select Id,License__c FROM Education_History__r),(Select Id,License__c FROM LnP_Parcels__r) from MUSW_Application2__c where '+appCondition;
                String strAppOther = 'Select Id,Stage__c, Profession__c,  License_Type__c, (select id,Request__c,ContentDocumentId__c from Submissions__r) ,(select Id,Answer_Text__c,License__c,Request__c,Create_Endorsement_Record__c,Endorsement_Type__c,QuestionDOL__r.Data_Type__c,QuestionDOL__r.Endorsement_Type__c,Question_Section__c from Answers__r),(Select Id,License__c,Request__c FROM LnP_BackgroundSections__r),(Select Id,License__c,Request__c FROM LnP_Parcels__r) from Request__c where '+appCondition;
                system.debug('StrApp Query--->'+strAppOther);
                appListOtherDetils = Utilityclass_withsharing.queryRecords(strAppOther);
                List<LnP_Parcel__c> lstParcels = new List<LnP_Parcel__c>();            
                if(appListOtherDetils[0].LnP_Parcels__r != null && appListOtherDetils[0].LnP_Parcels__r.size()>0){
                    for(LnP_Parcel__c parcel : appListOtherDetils[0].LnP_Parcels__r){
                        parcel.Request__c = appList[0].Id; 
                        lstParcels.add(parcel);
                    }
                    update lstParcels;                
                }
                List<LnP_BackgroundSection__c> lstEduHist = new List<LnP_BackgroundSection__c>();            
                if(appListOtherDetils[0].LnP_BackgroundSections__r != null && appListOtherDetils[0].LnP_BackgroundSections__r.size()>0){
                    for(LnP_BackgroundSection__c EduHist : appListOtherDetils[0].LnP_BackgroundSections__r){
                        EduHist.Request__c = appList[0].Id; 
                        lstEduHist.add(EduHist);
                    }
                    update lstEduHist;                
                } 
                List<BGCK__Answer__c> lstNewAnswers = new List<BGCK__Answer__c>();
                List<BGCK__Answer__c> lstAnswers = [SELECT Id,Answer_Text__c,License__c,Create_Endorsement_Record__c,Endorsement_Type__c,QuestionDOL__r.Data_Type__c,QuestionDOL__r.Endorsement_Type__c,Question_Section__c,Request__c FROM BGCK__Answer__c where Request__c=:applicationId];
                List<Endorsement__c> lstEndorsements = new List<Endorsement__c>();
                String providerName = '';
                if(lstAnswers != null && lstAnswers.size()>0 && appList[0].License_Type__c == 'Notary Public'){
                    for(BGCK__Answer__c ans : lstAnswers)
                    {                    
                        if((!ans.Create_Endorsement_Record__c) && ans.QuestionDOL__r.Data_Type__c == 'Picklist' && ans.Question_Section__c=='Endorsement' )
                        {
                            providerName = ans.Answer_Text__c;
                        }
                    }
                }
                system.debug('lstAnswers '+lstAnswers);
                if(lstAnswers != null && lstAnswers.size()>0){
                    for(BGCK__Answer__c ans : lstAnswers){
                        //ans.Request__c = appList[0].Id;                    
                        if(ans.Create_Endorsement_Record__c && ans.QuestionDOL__r.Data_Type__c == 'Yes_No' && ans.Answer_Text__c=='Yes')
                        {
                            Endorsement__c endorsment = new Endorsement__c();
                            endorsment.Endorsement_Type__c = ans.Endorsement_Type__c;
                            endorsment.License_Type__c = appList[0].License_Type__c;
                            //endorsment.Status__c = 'Pending Add';
                            if(appList[0].License_Type__c == 'Notary Public')
                            {
                                //endorsment.Electronic_Software_Provider__c = providerName;
                                endorsment.Status__c = 'Active';
                            }
                            endorsment.Date_Requested_for_Adding_Endorsement__c = system.today();
                            endorsment.Request__c = appList[0].Id;
                            endorsment.Created_for_New_Application__c = True;
                            endorsment.Added_Through_AMR__c = True;
                             endorsment.License__c = appList[0].License__c;
                            lstEndorsements.add(endorsment);
                        }
                        else if(ans.Create_Endorsement_Record__c && ans.QuestionDOL__r.Data_Type__c == 'Picklist' && ans.Answer_Text__c != '' && ans.Answer_Text__c !='--None--' && ans.QuestionDOL__r.Endorsement_Type__c!='Notary' )
                        {
                            Endorsement__c endorsment = new Endorsement__c();
                            endorsment.Endorsement_Type__c = ans.Answer_Text__c;
                            endorsment.License_Type__c = appList[0].License_Type__c;
                            //endorsment.Status__c = 'Pending Add';
                            endorsment.Date_Requested_for_Adding_Endorsement__c = system.today();
                            endorsment.Request__c = appList[0].Id;
                            endorsment.Created_for_New_Application__c = True;
                            endorsment.Added_Through_AMR__c = True;
                             endorsment.License__c = appList[0].License__c;
                            lstEndorsements.add(endorsment);
                        }
                        lstNewAnswers.add(ans);
                    }
                    //update lstAnswers;
                    system.debug('lstEndorsements'+lstEndorsements);
                    insert lstEndorsements;
                    if(appListOtherDetils[0].License_Type__c == 'Notary Public' && lstEndorsements.size()>0)
                    {
                        List<Electronic_Notary_Provider_Information__c> lstproviders = [SELECT id,Description__c,Effective_Date__c,Endorsement__c FROM Electronic_Notary_Provider_Information__c where Request__c =:appListOtherDetils[0].Id];
                        
                        for(Electronic_Notary_Provider_Information__c provider : lstproviders)
                        {
                            provider.Endorsement__c = lstEndorsements[0].Id;
                        }
                        update lstproviders;
                    }          
                    //add review record for endorsement
                    /*if(appList[0].License_Type__c != 'Notary Public')
                    {
                        List<MUSW__Review__c> lstReview = new List<MUSW__Review__c>();
                        for(Endorsement__c endo :lstEndorsements){
                            MUSW__Review__c review = new MUSW__Review__c();
                            review.Name = 'Endorsement Review';
                            review.Request__c = appList[0].Id;
                            review.MUSW__Status__c = 'Pending';
                            review.License__c = appList[0].License__c;
                            review.Endorsement__c = endo.Id;
                            lstReview.add(review);
                        }              
                        
                        insert lstReview;
                    }*/
                }
                List<MUSW__Submission__c> lstSubmissions= new List<MUSW__Submission__c>();            
                if(appListOtherDetils[0].Submissions__r != null && appListOtherDetils[0].Submissions__r.size()>0){
                    for(MUSW__Submission__c submissions : appListOtherDetils[0].Submissions__r){
                        submissions.Request__c = appList[0].Id; 
                        lstSubmissions.add(submissions);
                        if(submissions!=null && submissions.ContentDocumentId__c != null ) {
                            mapSubmissionToFile.put(submissions.ID, submissions.ContentDocumentId__c.replace(';',''));
                        }
                    }
                    
                    update lstSubmissions;                
                }
            }   
             System.debug('Service_Request_Type__c::'+ appList[0].Service_Request_Type__c);
                if(appList[0].Service_Request_Type__c == 'Add Affiliations' || appList[0].Service_Request_Type__c == 'Remove Affiliations'){
                    appList[0].Status__c = 'Under Review';
                }
                update appList[0];
        }
        //Calling method to  store 3rd party
        if(!mapSubmissionToFile.isEmpty()){
            Polaris_ServiceRequestController.updateLinkedEntityId(mapSubmissionToFile);
          //  string success = Dol_UploadDocumenttoSAN.portalUpload(mapSubmissionToFile);
        }
        return appList;
    }
    
    
    //Fetch all the addresses
    public static Map<String, List<LnP_Parcel__c>> getAddresses (Set<Id> appId){
        Map<String, List<LnP_Parcel__c>> mapAddress  =  new Map<String,List<LnP_Parcel__c>>();
        List<LnP_Parcel__c> lstAddress  = [SELECT Id, Address_Type__c,Request__c, Application_BG__c,Application__c, City__c, County__c, Country__c, State_Province__c, Street__c, Zip_Postal_Code__c 
                                           FROM LnP_Parcel__c WHERE Request__c IN :appId];
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
    //Fetch BackgroundInformation
    public static Map<String,List<LnP_BackgroundSection__c>> getBackgroundInformation (Set<Id> appId) {
        Map<String, List<LnP_BackgroundSection__c>> mapBackgroundInfo =  new Map<String,List<LnP_BackgroundSection__c>>();
        List<LnP_BackgroundSection__c> lstBackground = [SELECT Id, RecordType.name , Request__c,Application_BG__c FROM LnP_BackgroundSection__c WHERE Request__c IN :appId and RecordTypeID != null];
        if(!lstBackground.isEmpty()){
            for(LnP_BackgroundSection__c backgroundInfo : lstBackground) {
                if(mapBackgroundInfo.containsKey(backgroundInfo.RecordType.name )) {
                    mapBackgroundInfo.get(backgroundInfo.RecordType.name ).add(backgroundInfo);
                } else {
                    mapBackgroundInfo.put(backgroundInfo.RecordType.name, new List<LnP_BackgroundSection__c>{backgroundInfo});
                }
            }
        }
        return  mapBackgroundInfo ;  
    }
    
    //method to get metadata
    @AuraEnabled
    public static AMR_Link__mdt getMetadata(String board,String ServiceRequestType,String licenseType){
      
      List<AMR_Link__mdt> listMdt = [ SELECT Sections__c,Generate_Fee__c FROM AMR_Link__mdt WHERE Board__c =:board AND License_Type__c =:licenseType AND Service_Request_Type__c =:ServiceRequestType];
      
      if(!listMdt.isEmpty()){
          return   listMdt[0];
      }else{
          return null;
      }
      
    }
    
    
    @AuraEnabled
    public static boolean updateAffiliation(string requestId){
        try{
        List<Request__c> reqList = [select id,Account_Contact__c from Request__c where id=:requestId ];
        
            if(!reqList.isEmpty()){
                MUSW__Account_Contact__c accCon = [select id,Status__c from MUSW__Account_Contact__c where id=:reqList[0].Account_Contact__c];
                accCon.Status__c = 'Active';
                
                task tsk = [select id,Status,Sub_status__c from task where Whatid=:accCon.id AND status=:'Pending' limit 1];
                tsk.Status = 'Completed';
                tsk.Sub_status__c = 'Accepted';
                update tsk;
            }
            return true;
        }catch(Exception e){
            Polaris_CreateErrorLog_Exception.addError(e,'Polaris_ServiceRequestController','updateAffiliation');
            return false;
        }
    
    }
    private static void updateLinkedEntityId (Map<String,String> mapSubmissionToFile) {
        List<String> abc  = new List<String>();
         List<ContentDocumentLink> lstFiles  = new List<ContentDocumentLink>();
        if(!mapSubmissionToFile.isEmpty()) {
            abc.addAll(mapSubmissionToFile.values());
        }
        List<ContentDocumentLink> lstContent = new List<ContentDocumentLink>();
        system.debug('inside the submissions');
        for(ContentDocumentLink cont : [select  ContentDocumentId,Id,LinkedEntityId FROM ContentDocumentLink where  LinkedEntityId =:UserInfo.getUserId()]){
            system.debug('inside the submissions'+cont);
            lstContent.add(cont);
        }
        if(!lstContent.isEmpty()){
            for(String submissionId :mapSubmissionToFile.keySet()) {
                for(ContentDocumentLink contentID : lstContent){
                    if (mapSubmissionToFile.get(submissionId) == contentID.ContentDocumentId) {
                        ContentDocumentLink newclnk = contentID.clone();
                        newclnk.linkedentityid = submissionId;
                        newclnk.ShareType = 'I';
                        lstFiles.add(newclnk);
                    }
                }
            } 
        }

        if(!lstContent.isEmpty()) {
            upsert lstFiles;
        } 
    }
    
}