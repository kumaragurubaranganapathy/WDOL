public class Polaris_ApplyForLicenseController {
    public static Contact currentContact {get;set;} 
    // public static List<MUSW_Application2__c> lstApps {get;set;}
    public static List<MUSW__Application2__c> lstApps {get;set;}   
    public static String sections {get;set;}
    public static Map<String,String> mapMandatorySubsection {get;set;}
    public static List<Application_Field__c> lstApplicationFields {get;set;}
    public static List<Question__c> lstQuestions {get;set;} 
    public static List<User> lstUserInfoData {get;set;}
    public static List<MUSW__Master_Submission_List__c> lstMasterSubmission {get;set;}
    public static Map<String,String> mapSubsectionIcon {get;set;}
    
    
    @AuraEnabled(cacheable = true)
    public static String fetchData(String board, String licenseType, String applicationType, String flowType, String appId) {
        system.debug('board : '+board+'licenseType : '+licenseType+ 'applicationType: '+applicationType + 'appId :'+appId);
        //Creating the conditions for fetching the data       
        Integer tabIndex = 1;
        Integer currentTab = 0;
        LnP_JSONParser ansWrapper; //to create Wrapper 
        String jsonApplicationFields = '';
        List<LnP_ApplyForLicenseWrapper> lstLicenseWrapper = new List<LnP_ApplyForLicenseWrapper>();
        //Fetching data for subsection icon
        Map<String,String> mapTempSubsectionIcon = Polaris_ApplyForLicenseService.fetchSubsectionIcons(System.Label.Page_Name_For_License);
        mapSubsectionIcon = new Map<String,String>();
        if(mapSubsectionIcon.isEmpty() && !mapTempSubsectionIcon.isEmpty())
        {
            mapSubsectionIcon = mapTempSubsectionIcon;
        }
        
        //Fetching mandatory Subsection
        mapMandatorySubsection = new Map<string,String>();
        Map<string,String> mapTempMandatorySubsection = Polaris_ApplyForLicenseService.fetchMandatorySubsections(board,licenseType);
        if(!mapTempMandatorySubsection.isEmpty())
        {
            mapMandatorySubsection = mapTempMandatorySubsection;
        }
        
        //Fetching Application fields for license
        lstApplicationFields = new List<Application_Field__c>();
        List<Application_Field__c> lstTempApplicationFields = Polaris_ApplyForLicenseService.fetchApplicationFields(board,licenseType,applicationType);
        if(!lstTempApplicationFields.isEmpty())
        {
            lstApplicationFields = lstTempApplicationFields;
        }        
        jsonApplicationFields = JSON.serialize(lstApplicationFields);
        //Fetching the data related to  a user and storing in the list
        lstUserInfoData = new List<User>();
        List<User> lstuserData  = Polaris_ApplyForLicenseService.fetchUserDetails();
        if(!lstuserData.isEmpty())
        {
            lstUserInfoData = lstuserData;
        }
        
        //Fetching the questions in the system per licenseType and applicationType for general application and comity
        lstQuestions = new List<Question__c>();
        List<Question__c> lstTempQuestions = Polaris_ApplyForLicenseService.fetchQuestionsDetails(board,licenseType,applicationType);
        if(!lstTempQuestions.isEmpty())
        {
            lstQuestions = lstTempQuestions;
        }
        
        //Fetching the Master submission list in the system per licenseType and applicationType for general application and comity
        lstMasterSubmission = new List<MUSW__Master_Submission_List__c>();
        List<MUSW__Master_Submission_List__c> lstTempMasterSubmission = Polaris_ApplyForLicenseService.fetchMasterSubmissionDetails(board,licenseType,applicationType);
        if(!lstTempMasterSubmission.isEmpty())
        {
            lstMasterSubmission = lstTempMasterSubmission;
        }    
        
        //Fetching Section
        List<LnP_License_Type_Sections_Setting__mdt> lstSections = new List<LnP_License_Type_Sections_Setting__mdt>();        
        lstSections = Polaris_ApplyForLicenseService.fetchSection(board,licenseType,applicationType);
        if(!lstSections.isEmpty())
        {
            sections = lstSections[0].Sections__c;
        }
        system.debug('sections'+sections);
        List<String> lstOfSections = new List<String>();
        if(sections != null){
            lstOfSections = sections.split(',');
        }
       
        //Fetching Applications by application id
        // lstApps = new List<MUSW_Application2__c>();
        // List<MUSW_Application2__c> lstTempApplication =new List<MUSW_Application2__c>();
        lstApps = new List<MUSW__Application2__c>();
        List<MUSW__Application2__c> lstTempApplication =new List<MUSW__Application2__c>();
        lstTempApplication = Polaris_ApplyForLicenseService.fetchApplications(appId);
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
            labelToFields.regex = Ques.Regex_Validation__c;
            labelToFields.errormsg = Ques.Error_Message__c; 
            if(Ques.isRequired__c==true)
            {
                labelToFields.isMandatoryQues = true;
            }
            else
            {
                labelToFields.isMandatoryQues = false;
            }
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
        
        
        for(String section : lstOfSections)
        {
            LnP_ApplyForLicenseWrapper licenseWrapper = new LnP_ApplyForLicenseWrapper();
            licenseWrapper.sectionName = section;
            licenseWrapper.subheader = section;
            licenseWrapper.currentTab = currentTab;
            licenseWrapper.tabIndex = tabIndex;
            if(!mapMandatorySubsection.isEmpty() && mapMandatorySubsection.containsKey(section))
            {
                licenseWrapper.mandatorySubsection = mapMandatorySubsection.get(section); 
            }
            if(!mapSubsectionIcon.isEmpty() && mapSubsectionIcon.containsKey(section+' icon'))
            {
                licenseWrapper.icon = mapSubsectionIcon.get(section+' icon');              
            }
            //Creating JSON for Personal Information section
            if(section =='Personal Information' )
            {
                licenseWrapper.personalInfoObjectName = 'Contact';
                licenseWrapper.fieldJson = jsonApplicationFields;
                /* if(!lstLicenseApplication.isEmpty() && lstLicenseApplication[0].Contact__c != null )
{
licenseWrapper.contactId = lstLicenseApplication[0].Contact__c;
}*/
                if (!lstApps.isEmpty() && lstApps[0].MUSW__Applicant__c != null) {
                    licenseWrapper.contactId = lstApps[0].MUSW__Applicant__c;   
                }
                else if(!lstUserInfoData.isEmpty() && lstUserInfoData[0].ContactId != null) 
                {
                    licenseWrapper.contactId = lstUserInfoData[0].ContactId;                     
                }   
                
                
            }
            //Created for Course Information Section
            else if(section == 'Course Information' ){
                licenseWrapper.personalInfoObjectName = 'Account';
                licenseWrapper.accountId = lstApps[0].MUSW__Account__c;
                licenseWrapper.fieldJson = jsonApplicationFields;
            } //end
            else if((section =='Business Information') &&  !lstApps.isEmpty())
            {
                licenseWrapper.personalInfoObjectName = 'Account'; 
                licenseWrapper.accountId = lstApps[0].MUSW__Account__c;
                licenseWrapper.fieldJson = jsonApplicationFields;
            }
            else if(section =='Attachments')
            {
                licenseWrapper.sobjectType = 'Submission';
                if(!lstMapLabelFieldsForSubmission.isEmpty())
                {
                    licenseWrapper.labelFieldsMap.addAll(lstMapLabelFieldsForSubmission);
                }
            }
            else
            {
                if(!mapOnQuestions.isEmpty() && mapOnQuestions.containsKey(section))
                {
                    licenseWrapper.labelFieldsMap.addAll(mapOnQuestions.get(section));
                }
            }
            lstLicenseWrapper.add(licenseWrapper);
            tabIndex++;
        }
        system.debug('lstLicenseWrapper : '+JSON.serialize(lstLicenseWrapper));            
        return JSON.serialize(lstLicenseWrapper);             
    }
    
    public static LnP_JSONParser getJSONWrapper(String formJson){
        //system.debug('lstLicenseApplication'+lstLicenseApplication);
        String strJsonForm = '';
        //  for(LnP_Licence_Application__c app : lstLicenseApplication){
        strJsonForm = strJsonForm + formJson;
        // }        
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
            if(objWrapper.sectionName.contains('License Information')||objWrapper.sectionName.contains('Questions')||objWrapper.sectionName.contains('Endorsement')){
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
        String mastSubCond2 = 'Application_Method__c =\''+ApplicationType+'\'';
        String mastSubCond3 = 'Credential_Type__c =\''+LicenseType+'\' AND' + ' Default__c = false';
        String mastSubCond4 = 'Title__c IN: XXX';
        String strSubmission = 'Select Id, Name,Title__c,Question__c,Expected_Answer__c,Submission_Type__c, Required__c,  Active__c, Default__c, Application_Type__c, Credential_Type__c, Application_Method__c from MUSW__Master_Submission_List__c where ' +mastSubCond1+ ' AND '+mastSubCond2+ ' AND '+mastSubCond3+ ' AND ' +mastSubCond4;
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
        Boolean FGquestionsIncomplete = false;
        Boolean CIquestionsIncomplete = false;
        Boolean submissionsIncomplete = true;
        Map<String,List<MUSW__Parcel__c>> mapAddress = new  Map<String,List<MUSW__Parcel__c>>();
        Map<String,List<LnP_BackgroundSection__c>> mapEducation = new  Map<String,List<LnP_BackgroundSection__c>>();
        Set<Id>  setAppId = new Set<Id> ();
        setAppId.add(appId);
        mapAddress = getAddresses(setAppId);
        mapEducation = getBackgroundInformation(setAppId);
        System.debug('dataString---->'+dataString);
        List<LnP_ApplyForLicenseWrapper> wrapperList = (List<LnP_ApplyForLicenseWrapper>)JSON.deserialize(dataString, List<LnP_ApplyForLicenseWrapper>.class);
        Integer questionsAnswered=0;
        Integer FGquestionsAnswered=0;
        Integer CIquestionAnswered=0;
        String accountId='';
        if(!wrapperList.isEmpty()){
            accountId =  wrapperList[0].accountId != null ? wrapperList[0].accountId : '';
            system.debug('accountId---'+accountId);
        }
        wrapperList = fetchSubmission(wrapperList, Board,  LicenseType,  ApplicationType);
        System.debug('Wrapper'+JSON.serialize(wrapperList));
        List<LnP_ApplyForLicenseWrapper.MapLabelToFields> listFields = new List<LnP_ApplyForLicenseWrapper.MapLabelToFields>();
        List<LnP_ApplyForLicenseWrapper.MapLabelToFields> submissionFields = new List<LnP_ApplyForLicenseWrapper.MapLabelToFields>();
        lstUserInfoData = new List<User>();
        List<User> lstuserData  = Polaris_ApplyForLicenseService.fetchUserDetails();
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
            if(objWrapper.sectionName.contains('License Information') || objWrapper.sectionName.contains('Financial Guarantee') || objWrapper.sectionName.contains('Endorsement') || objWrapper.sectionName.contains('Questions')){
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
            Integer FGquestioncount = 0;
            Integer CIquestioncount = 0;
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
                system.debug('requestDetailsList : '+requestDetailsList);
                if(fieldMap.renderedOnUi!=null && fieldMap.renderedOnUi == true && fieldMap.questionSectionClass.contains('Questions') || fieldMap.questionSectionClass.contains('Financial Guarantee') || fieldMap.questionSectionClass.contains('Endorsement') || fieldMap.questionSectionClass.contains('Course')){
                    count++;  
                }
                if(fieldMap.renderedOnUi!=null && fieldMap.renderedOnUi == true && fieldMap.questionSectionClass.contains('Questions') && fieldMap.isMandatoryQues ==true ){
                    questioncount++;
                }
                if(fieldMap.renderedOnUi!=null && fieldMap.renderedOnUi == true &&  fieldMap.questionSectionClass.contains('Financial Guarantee') ){
                    FGquestioncount++;
                }
                if(fieldMap.renderedOnUi!=null && fieldMap.renderedOnUi == true &&  fieldMap.questionSectionClass.contains('Course') ){
                    CIquestioncount++;
                }
                //system.debug('fieldMap.renderedOnUi '+fieldMap.renderedOnUi);
                if(fieldMap.questionSectionClass.contains('Questions')  && fieldMap.isMandatoryQues ==true && fieldMap.renderedOnUi!=null && fieldMap.renderedOnUi==true && fieldMap.value != null && fieldMap.value !='' ){
                    questionsAnswered++;
                }
                if(fieldMap.questionSectionClass.contains('Financial Guarantee') && fieldMap.renderedOnUi!=null && fieldMap.renderedOnUi==true && fieldMap.value != null && fieldMap.value !='' ){
                    FGquestionsAnswered++;
                }
                if(fieldMap.questionSectionClass.contains('Course') && fieldMap.renderedOnUi!=null && fieldMap.renderedOnUi==true && fieldMap.value != null && fieldMap.value !='' ){
                    CIquestionAnswered++;
                }
            }
            //validationForQuestions:
            system.debug('Count '+count);
            system.debug('questioncount '+questioncount);
            system.debug('questionsAnswered '+questionsAnswered);
            if(questionsAnswered != questioncount ){
                questionsIncomplete = true;
            }
            if(FGquestionsAnswered != FGquestioncount ){
                FGquestionsIncomplete = true;
            }
            if(CIquestionAnswered != CIquestioncount){
                CIquestionsIncomplete = true;
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
        List<MUSW__Application2__c> appList =new List<MUSW__Application2__c>();
        String appCondition = 'Id=\''+appId+'\'';
        //String strApp = 'Select Id, Stage__c, Application_Type__c,  Board__c, License_Type__c, (Select Id, Sequence__c, LnP_Form_JSON__c from License_Application__r ORDER BY Sequence__c ASC),(Select Id, Name from Education_History__r ) from MUSW_Application2__c where '+appCondition;
        String strApp = 'Select Id,MUSW__Account__c,Stage__c, Application_Type__c,  Application_Method__c, Credential_Type__c from MUSW__Application2__c where '+appCondition;
        appList = Utilityclass_withsharing.queryRecords(strApp);
        List<Education_History__c> lstEducations = new List<Education_History__c>();
        
        MUSW__Application2__c application = new MUSW__Application2__c();
        if(appList.size()>0){
            application = appList[0];
            application.id = appList[0].id;
            application.Stage__c = Integer.valueOf(tabNumber);            
        }
        else{
            application.MUSW__Applicant__c = getContactId;
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
            if(objWrapper.sectionName.contains('Financial Guarantee') && FGquestionsIncomplete==true){
                objWrapper.sectionError = true;
            } 
            if(objWrapper.sectionName.contains('Questions') && CIquestionsIncomplete==true){
               // objWrapper.sectionError = true;
            } 
            if(objWrapper.sectionName.contains('Attachments') && submissionsIncomplete == true){
                objWrapper.sectionError = true;
            }
            if(objWrapper.mandatorySubsection != null){
                lstMandatorySubsection = objWrapper.mandatorySubsection.split(',') ;
                if(lstMandatorySubsection != null){
                    system.debug('mapAddress'+ mapAddress);
                    for(String mandatorySubSection : lstMandatorySubsection){
                        system.debug('mandatorySubsection098'+ mandatorySubSection);
                        if((mandatorySubSection == 'Physical Address' || mandatorySubSection == 'Mailing Address')){
                            if(mapAddress.isEmpty()){
                                objWrapper.sectionError = true;
                            }else{
                                if(!mapAddress.containsKey('MAILING ADDRESS') || (!mapAddress.containsKey('PHYSICAL ADDRESS') && !mapAddress.get('MAILING ADDRESS')[0].is_Physical_and_Mailing_Address_Same__c)){
                                    //if(mapAddress.get(mandatorySubSection) == null ||  mapAddress.get(mandatorySubSection).size() == 0 ){
                                        system.debug('inside the mandatory'+mapAddress.get('PHYSICAL ADDRESS'));
                                        objWrapper.sectionError = true;
                                    //}
                                }
                            }   
                        }
                        /*commented by shiva
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
                        }*/
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
    public static List<MUSW__License2__c> callCompositeAPI(String applicationId,String childlicenseRecordID){
        system.debug('childlicenseRecordID :'+childlicenseRecordID);
         Map<String,String> mapSubmissionToFile = new Map<String,String>();
        List<MUSW__Application2__c> appList =new List<MUSW__Application2__c>();
        Set<Id>  setapplicationId =  new Set<Id> ();
        List<MUSW__License2__c> licenseID;
        // string applicationId2 = string.valueOf(applicationId).substring(0, 15);
        setapplicationId.add(applicationId);
        String appCondition = 'Id=\''+applicationId+'\'';
        // String strApp = 'Select Id, Stage__c, Application_Type__c,  Credential_Type__c, Application_Method__c, (Select Id, Sequence__c, LnP_Form_JSON__c from License_Application__r ORDER BY Sequence__c ASC) from MUSW__Application2__c where '+appCondition;
        String strApp = 'Select Id, Stage__c, Form_JSON__c, Upgrading_License__c,Application_Type__c,  Credential_Type__c, Application_Method__c from MUSW__Application2__c where '+appCondition;
        system.debug('StrApp Query--->'+strApp);
        appList = Utilityclass_withsharing.queryRecords(strApp);
        system.debug('Applist In AController--->'+appList);
        String stringJSON = '';
        stringJSON = appList[0].Form_JSON__c;
        Boolean checkSuccess = false;
        //Modified code for handling 25 subrequest governor limit
        
        LnP_JSONParser ansWrapper= Polaris_ApplyForLicenseController.getJSONWrapper(stringJSON);
        List<LnP_JSONParser.CompositeRequest> requestDetailsList = new List<LnP_JSONParser.CompositeRequest>();
        for(LnP_JSONParser.CompositeRequest req : ansWrapper.compositeRequest){
            requestDetailsList.add(req);
        }
        List<List<LnP_JSONParser.CompositeRequest>> compositeReq = Polaris_ApplyForLicenseService.partition(requestDetailsList,24);
       // for()
        if(appList[0].Upgrading_License__c!=null)
        {
            childlicenseRecordID = appList[0].Upgrading_License__c;
        }
        // System.debug('appList '+appList);
        System.debug('appList[0].Stage__c '+appList[0].Stage__c);
        if(appList != null && appList.size()>0 && appList[0].Stage__c != -1){
        for(List<LnP_JSONParser.CompositeRequest> record: compositeReq) {    
               Map<String,List<LnP_JSONParser.CompositeRequest>> mapList = new  Map<String,List<LnP_JSONParser.CompositeRequest>>();
               mapList.put('compositeRequest',record);
               string strJsonForm = JSON.serialize(mapList);
               strJsonForm = strJsonForm.replaceAll('\\bAnswer\\b', 'Answer_Text__c');
               strJsonForm = strJsonForm.replaceAll('\\bQuestion\\b', 'QuestionDOL__c');
               strJsonForm = strJsonForm.replaceAll('\\bApplication\\b', 'Application_BG__c');
               strJsonForm = strJsonForm.replaceAll('\\bMUSW_Application2\\b', 'MUSW__Application2__c');
               strJsonForm = strJsonForm.replaceAll('\\bMUSW_Description\\b', 'MUSW__Description__c');
               stringJSON = stringJSON.replaceAll('\\BgckApplication\\b', 'MUSW__Description__c');
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
          
            system.debug('stringJSONfianl'+stringJSON);
            
            if(checkSuccess) {
                appList[0].Stage__c = -1;
                appList[0].MUSW__Status__c = 'Under Review';
                licenseID =insertLisence(setapplicationId);
                //Setup  for the populating the details
                List<MUSW__Application2__c> appListOtherDetils =new List<MUSW__Application2__c>();
                // String strAppOther = 'Select Id, Stage__c, Application_Type__c,  Board__c, License_Type__c,(select id,License__c from MUSW_Submissions__r) ,(select Id,License__c from Answers__r),(Select Id,License__c FROM Employment_History__r),(Select Id,License__c FROM Education_History__r),(Select Id,License__c FROM LnP_Parcels__r) from MUSW_Application2__c where '+appCondition;
                String strAppOther = 'Select Id,MUSW__Account__c,Stage__c, Application_Type__c,  Application_Method__c, Credential_Type__c, (select id,MUSW__License2__c,ContentDocumentId__c from MUSW__Submissions__r) ,(select Id,Answer_Text__c,License__c,Create_Endorsement_Record__c,Endorsement_Type__c,QuestionDOL__r.Data_Type__c,QuestionDOL__r.Question_Body__c,QuestionDOL__r.QuestionFieldAPI__c,QuestionDOL__r.Endorsement_Type__c,QuestionDOL__r.Course_Type_Question__c,QuestionDOL__r.RecordType.DeveloperName,QuestionDOL__r.RecordType.Name,Question_Section__c from Answers1__r),(Select Id,License__c FROM LnP_BackgroundSections__r),(Select Id FROM Parcels__r) from MUSW__Application2__c where '+appCondition;
                system.debug('StrApp Query--->'+strAppOther);
                system.debug('licenseID[0].Id --->'+licenseID[0].Id);
                appListOtherDetils = Utilityclass_withsharing.queryRecords(strAppOther);
                //List<MUSW__Parcel__c> lstParcels = new List<MUSW__Parcel__c>();
                List<MUSW__License_Parcel__c> licenseParcelList = new List <MUSW__License_Parcel__c>();
                if(appListOtherDetils[0].Parcels__r != null && appListOtherDetils[0].Parcels__r.size()>0 && !String.isBlank(licenseID[0].Id)){
                    for(MUSW__Parcel__c parcelInstance : appListOtherDetils[0].Parcels__r){
                        system.debug('parcelInstance==' + parcelInstance);
                        MUSW__License_Parcel__c licenseParcelRecord = new MUSW__License_Parcel__c();
                        licenseParcelRecord.MUSW__Parcel__c = parcelInstance.Id;
                        licenseParcelRecord.MUSW__License2__c    = licenseID[0].Id;
                        licenseParcelList.add(licenseParcelRecord);
                        //parcel.License__c = licenseID[0].Id; 
                        //lstParcels.add(parcel);
                    }
                    upsert licenseParcelList;               
                }
                List<LnP_BackgroundSection__c> lstEduHist = new List<LnP_BackgroundSection__c>();            
                if(appListOtherDetils[0].LnP_BackgroundSections__r != null && appListOtherDetils[0].LnP_BackgroundSections__r.size()>0){
                    for(LnP_BackgroundSection__c EduHist : appListOtherDetils[0].LnP_BackgroundSections__r){
                       EduHist.License_Bg__c = licenseID[0].Id; 
                        lstEduHist.add(EduHist);
                    }
                    update lstEduHist;                
                }   
                List<BGCK__Answer__c> lstAnswers = new List<BGCK__Answer__c>();
                List<Endorsement__c> lstEndorsements = new List<Endorsement__c>();
                String providerName = '';
               //For Courses 
              // MUSW__License2__c LicenseObj = [SELECT Id,Bond_Number__c,Surety_Bond_Company_Name__c,Policy_Amount__c,Effective_Date_of_Bond__c,Expiration_Date_of_Bond__c FROM MUSW__License2__c WHERE Id=: licenseID[0].id ];
                MUSW__License2__c LicenseObj = new MUSW__License2__c(id= licenseID[0].id );
                String courseProvider = '';
                Boolean isAppraiserCourse = false;
                //Course Type Question ANswers
               if(appListOtherDetils[0].Answers1__r != null && appListOtherDetils[0].Answers1__r.size()>0 && appListOtherDetils[0].Credential_Type__c =='Appraiser Course'){
                    system.debug('in course type answers');
                   isAppraiserCourse = true;
                   List<String> preApproval = new List<String>();
                   List<String> courseTypeVal = new List<String>();
                   List<String> deliveryMethod = new List<String>();

                    for(BGCK__Answer__c ans : appListOtherDetils[0].Answers1__r){
                        ans.License__c = LicenseObj.Id; 
                        ans.Question2__c = ans.QuestionDOL__r.Question_Body__c;
                        system.debug('ans.QuestionDOL__r.RecordType.DeveloperName---'+ans.QuestionDOL__r.RecordType.DeveloperName);
                        system.debug('question body===' + ans.QuestionDOL__r.Question_Body__c);
                       
                        if(ans.QuestionDOL__r.RecordType.DeveloperName =='Course_Information'){
                           system.debug(' in course info rec type filter');
                            String QuestionObjFieldAPIName = ans.QuestionDOL__r.QuestionFieldAPI__c;
                            system.debug('QuestionObjFieldAPIName--'+QuestionObjFieldAPIName);
                            if(QuestionObjFieldAPIName == 'Course_Type__c'){
                                system.debug('QuestionObjFieldAPIName course type'+ QuestionObjFieldAPIName);
                                
                               
                                if(ans.Answer_Text__c == 'Yes'){
                                    courseTypeVal.add(ans.QuestionDOL__r.Question_Body__c);
                                    system.debug('courseTypeVal==='+courseTypeVal);
                                }
                            
                                String commaSepratedList='';
                                for(String str : courseTypeVal)
                                {
                                    commaSepratedList += str + ';' ;
                                 }
                                // remove last additional comma from string
                                
                                commaSepratedList = commaSepratedList.subString(0,commaSepratedList.length());
                                
                                system.debug('comma seprated list is----> '+commaSepratedList);
                              
                               LicenseObj.Course_Type__c = commaSepratedList ;
                            }
                            if(QuestionObjFieldAPIName == 'Delivery_Method__c'){
                                system.debug('QuestionObjFieldAPIName '+QuestionObjFieldAPIName);
                                deliveryMethod.add(ans.Answer_Text__c);
                                String delMethodStr = '';
                                    for(String str : deliveryMethod){
                                        delMethodStr += str + ';';
                                    }
                                 delMethodStr = delMethodStr.subString(0,delMethodStr.length());
                                
                                system.debug('delMethodStr----> '+delMethodStr);
                                LicenseObj.Delivery_Method__c = delMethodStr ;
                            } 
                            if(QuestionObjFieldAPIName == 'License_Email__c'){
                                system.debug('QuestionObjFieldAPIName '+QuestionObjFieldAPIName);
                                LicenseObj.License_Email__c = ans.Answer_Text__c;
                            }
                            if(QuestionObjFieldAPIName == 'License_Phone__c'){
                                system.debug('QuestionObjFieldAPIName '+QuestionObjFieldAPIName);
                                LicenseObj.License_Phone__c = ans.Answer_Text__c;
                            }  
                            if(QuestionObjFieldAPIName == 'Website__c'){
                                system.debug('QuestionObjFieldAPIName '+QuestionObjFieldAPIName);
                                LicenseObj.Website__c = ans.Answer_Text__c;
                            } 
                            if(QuestionObjFieldAPIName == 'Provider_Type__c'){
                                system.debug('QuestionObjFieldAPIName '+QuestionObjFieldAPIName);
                                LicenseObj.Provider_Type__c = ans.Answer_Text__c;
                            } 
                            if(QuestionObjFieldAPIName == 'Pre_Approval__c'){
                                
                                system.debug('QuestionObjFieldAPIName '+QuestionObjFieldAPIName);
                                if(ans.QuestionDOL__r.Question_Body__c == 'Is the Provider an accredited college?' && ans.Answer_Text__c == 'Yes')
                                {
                                    preApproval.add('College'); 
                                 }
                                
                                if(ans.QuestionDOL__r.Question_Body__c == 'When does your IDECC approval expire?' &&  ans.Answer_Text__c != '' )
                                {
                                    preApproval.add('IDECC');
                                  
                                }
                                
                                if(ans.QuestionDOL__r.Question_Body__c == 'Do you have an Appraisal Qualification Board approval certificate?' &&  ans.Answer_Text__c == 'Yes')
                                {
                                    preApproval.add('AQB'); 
                                   
                                }  
                                
                                if(ans.QuestionDOL__r.Question_Body__c == 'Is this is a USPAP 15-hour or 7-hour update course?' &&  ans.Answer_Text__c == 'Yes')
                                {
                                    preApproval.add('USPAP Instructor');
                                  
                                }   
                                system.debug('preApproval---'+preApproval);
                                String preApprovalString ='';
                                for(String str : preApproval)
                                {
                                    preApprovalString += str + ';' ;
                                }
                                // remove last additional comma from string
                                
                                preApprovalString = preApprovalString.subString(0,preApprovalString.length());
                                
                                system.debug('preApproval----> '+preApproval);
                                
                                LicenseObj.Pre_Approval__c = preApprovalString;
                            }
                            
                            if(QuestionObjFieldAPIName == 'USPAP_Courses_Expiration_Date__c'){
                                 system.debug('QuestionObjFieldAPIName '+QuestionObjFieldAPIName);
                                LicenseObj.USPAP_Courses_Expiration_Date__c = Date.valueOf(ans.Answer_Text__c);
                                    
                            }
                            if(QuestionObjFieldAPIName == 'IDECC_Approval_Expiration_Date__c'){
                                 system.debug('QuestionObjFieldAPIName '+QuestionObjFieldAPIName);
                                LicenseObj.IDECC_Approval_Expiration_Date__c = Date.valueOf(ans.Answer_Text__c);
                            }
                            if(QuestionObjFieldAPIName == 'AQB_Approval_Expiration_Date__c'){
                                 system.debug('QuestionObjFieldAPIName '+QuestionObjFieldAPIName);
                                LicenseObj.AQB_Approval_Expiration_Date__c = Date.valueOf(ans.Answer_Text__c);
                            }
                                
                                
                            if(QuestionObjFieldAPIName == 'Course_Title__c'){
                                system.debug('QuestionObjFieldAPIName '+QuestionObjFieldAPIName);
                                LicenseObj.Course_Title__c = ans.Answer_Text__c;
                            }
                             if(QuestionObjFieldAPIName == 'Event_City__c'){
                                system.debug('QuestionObjFieldAPIName '+QuestionObjFieldAPIName);
                                LicenseObj.Event_City__c = ans.Answer_Text__c;
                            }
                             if(QuestionObjFieldAPIName == 'Event_Date__c'){
                                system.debug('QuestionObjFieldAPIName '+QuestionObjFieldAPIName);
                                LicenseObj.Event_Date__c = Date.valueOf(ans.Answer_Text__c);
                                    
                            }
                             if(QuestionObjFieldAPIName == 'Event_State__c'){
                                system.debug('QuestionObjFieldAPIName '+QuestionObjFieldAPIName);
                                LicenseObj.Event_State__c = ans.Answer_Text__c;
                            }
                             if(QuestionObjFieldAPIName == 'Clock_Hours_Continuing_Education__c'){
                                 system.debug('QuestionObjFieldAPIName '+QuestionObjFieldAPIName);
                                 system.debug('CE '+Decimal.valueOf(ans.Answer_Text__c));
                                LicenseObj.Clock_Hours_Continuing_Education__c = Decimal.valueOf(ans.Answer_Text__c)  ;
                            }
                             if(QuestionObjFieldAPIName == 'Clock_Hours_Pre_Qualifying__c'){
                                 system.debug('QuestionObjFieldAPIName '+QuestionObjFieldAPIName);
                                 system.debug('CPRE '+Decimal.valueOf(ans.Answer_Text__c));
                                LicenseObj.Clock_Hours_Pre_Qualifying__c = Decimal.valueOf(ans.Answer_Text__c);
                            }
                             if(QuestionObjFieldAPIName == 'Clock_Hours_Qualifying_Elective__c'){
                                 system.debug('QuestionObjFieldAPIName '+QuestionObjFieldAPIName);
                                 system.debug('CQL '+Decimal.valueOf(ans.Answer_Text__c));
                                LicenseObj.Clock_Hours_Qualifying_Elective__c = Decimal.valueOf(ans.Answer_Text__c);
                            }
                             if(QuestionObjFieldAPIName == 'Alternate_Clock_Hours_Continuing_Educa__c'){
                                 system.debug('QuestionObjFieldAPIName '+QuestionObjFieldAPIName);
                                 system.debug('CE ALT'+Decimal.valueOf(ans.Answer_Text__c));
                                LicenseObj.Alternate_Clock_Hours_Continuing_Educa__c = Decimal.valueOf(ans.Answer_Text__c);
                            }
                            if(QuestionObjFieldAPIName == 'Continuing_Education_Licensure_Levels__c') {
                                system.debug('QuestionObjFieldAPIName '+QuestionObjFieldAPIName);
                                LicenseObj.Continuing_Education_Licensure_Levels__c = ans.Answer_Text__c;
                            }
                            if(QuestionObjFieldAPIName == 'Pre_Qualifying_Licensure_Levels__c') {
                                system.debug('QuestionObjFieldAPIName '+QuestionObjFieldAPIName);
                                LicenseObj.Pre_Qualifying_Licensure_Levels__c = ans.Answer_Text__c;
                            }
                            if(QuestionObjFieldAPIName == 'Qualifying_Elective_Licensure_Levels__c') {
                                system.debug('QuestionObjFieldAPIName '+QuestionObjFieldAPIName); 
                                LicenseObj.Qualifying_Elective_Licensure_Levels__c = ans.Answer_Text__c;
                            }    

                            
                                
                              system.debug('licenseID------'+LicenseObj); 
                        }
                    }
                  
                } 
                System.debug('LicenseObj : '+LicenseObj);
                if(isAppraiserCourse){
                   update LicenseObj;
                }
                //For Endorsement
                if(appListOtherDetils[0].Answers1__r != null && appListOtherDetils[0].Answers1__r.size()>0 && appListOtherDetils[0].Credential_Type__c == 'Notary Public'){
                    for(BGCK__Answer__c ans : appListOtherDetils[0].Answers1__r)
                    {                    
                        if((!ans.Create_Endorsement_Record__c) && ans.QuestionDOL__r.Data_Type__c == 'Picklist' && ans.Question_Section__c=='Endorsement' )
                        {
                            providerName = ans.Answer_Text__c;
                        }
                    }
                }
                system.debug('lstAnswers '+lstAnswers);
                if(appListOtherDetils[0].Answers1__r != null && appListOtherDetils[0].Answers1__r.size()>0){
                    for(BGCK__Answer__c ans : appListOtherDetils[0].Answers1__r){
                        ans.License__c = licenseID[0].Id; 
                        ans.Question2__c = ans.QuestionDOL__r.Question_Body__c;
                        System.debug('ans.Question2__c==' + ans.Question2__c);
                        if(ans.Create_Endorsement_Record__c && ans.QuestionDOL__r.Data_Type__c == 'Yes_No' && ans.Answer_Text__c=='Yes')
                        {
                            Endorsement__c endorsment = new Endorsement__c();
                            endorsment.Endorsement_Type__c = ans.Endorsement_Type__c;
                            endorsment.License_Type__c = appListOtherDetils[0].Credential_Type__c;
                            //endorsment.Status__c = 'Pending Add';
                            if(appListOtherDetils[0].Credential_Type__c == 'Notary Public')
                            {
                                endorsment.Status__c = 'Active';
                            }
                            endorsment.Date_Requested_for_Adding_Endorsement__c = system.today();
                            endorsment.License__c = licenseID[0].Id;
                            endorsment.Created_for_New_Application__c = True;
                            lstEndorsements.add(endorsment);
                        }
                        else if(ans.Create_Endorsement_Record__c && ans.QuestionDOL__r.Data_Type__c == 'Picklist' && ans.Answer_Text__c != '' && ans.Answer_Text__c !='--None--' && ans.QuestionDOL__r.Endorsement_Type__c!='Notary' )
                        {
                            Endorsement__c endorsment = new Endorsement__c();
                            endorsment.Endorsement_Type__c = ans.Answer_Text__c;
                            endorsment.License_Type__c = appListOtherDetils[0].Credential_Type__c;
                            //endorsment.Status__c = 'Pending Add';
                            endorsment.Date_Requested_for_Adding_Endorsement__c = system.today();
                            endorsment.License__c = licenseID[0].Id;
                            endorsment.Created_for_New_Application__c = True;
                            lstEndorsements.add(endorsment);
                        }

                        lstAnswers.add(ans);
                    }
                    update lstAnswers;
                    system.debug('lstEndorsements'+lstEndorsements);
                    insert lstEndorsements;
                    if(appListOtherDetils[0].Credential_Type__c == 'Notary Public' && lstEndorsements.size()>0)
                    {
                        List<Electronic_Notary_Provider_Information__c> lstproviders = [SELECT id,Description__c,Effective_Date__c,Endorsement__c FROM Electronic_Notary_Provider_Information__c where Application_BG__c =:appListOtherDetils[0].Id];
                        
                        for(Electronic_Notary_Provider_Information__c provider : lstproviders)
                        {
                            provider.Endorsement__c = lstEndorsements[0].Id;
                        }
                        update lstproviders;
                    }                   
                    
                    //add review record for endorsement
                    /*if(appListOtherDetils[0].Credential_Type__c != 'Notary Public')
                    {
                        List<MUSW__Review__c> lstReview = new List<MUSW__Review__c>();
                        for(Endorsement__c endo :lstEndorsements){
                            MUSW__Review__c review = new MUSW__Review__c();
                            review.Name = 'Endorsement Review - ' + licenseID[0].Applicant_Full_Name__c + '/' + licenseID[0].Name;
                            review.License__c = licenseID[0].Id;
                            review.MUSW__Status__c = 'Pending';
                            review.Endorsement__c = endo.Id;
                            lstReview.add(review);
                        }              
                        
                        insert lstReview;
                    }*/
                }
                List<MUSW__Submission__c> lstSubmissions= new List<MUSW__Submission__c>(); 
                if(appListOtherDetils[0].MUSW__Submissions__r != null && appListOtherDetils[0].MUSW__Submissions__r.size()>0){
                    for(MUSW__Submission__c submissions : appListOtherDetils[0].MUSW__Submissions__r){
                        submissions.MUSW__License2__c = licenseID[0].Id; 
                        submissions.MUSW__License2__c = licenseID[0].Id; 
                        lstSubmissions.add(submissions);
                        
                        //Creating map for integration team to  store the docs in 3rd party
                        mapSubmissionToFile.put(submissions.ID, submissions.ContentDocumentId__c);
                    }
                    update lstSubmissions;                
                }
                update appList[0];
                
            }   
        }
        if(childlicenseRecordID!=null)
        {
            MUSW__License2__c lic = [SELECT id,Upgraded_License__c FROM MUSW__License2__c where id=:childlicenseRecordID];
            lic.Upgraded_License__c = licenseID[0].id;
            update lic;
        }
        //Calling method to  store 3rd party
       /* if(!mapSubmissionToFile.isEmpty()){
            string success = Dol_UploadDocumenttoSAN.portalUpload(mapSubmissionToFile);
        }*/
        return licenseID;
    }
    private static List<MUSW__License2__c> insertLisence(Set<Id> appId){
        List<MUSW__License2__c> lstLisence = new List<MUSW__License2__c>();
        Id businessRT = SObjectType.MUSW__License2__c.getRecordTypeInfosByDeveloperName().get('Business').getRecordTypeId();
        Id individualRT = SObjectType.MUSW__License2__c.getRecordTypeInfosByDeveloperName().get('Universal_Default_License_Record_Type').getRecordTypeId();
        Id courseRT = SObjectType.MUSW__License2__c.getRecordTypeInfosByDeveloperName().get('Course').getRecordTypeId();
        Id mainLicenseRT = SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Main_License_Account').getRecordTypeId();
        Id branchLicenseRT = SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Branch_License_Account').getRecordTypeId();
        //Get COurse Record TYpe Id
        // List<MUSW_Application2__c> applicationList = [SELECT Id,Application_Type__c,Board__c,License_Type__c,MUSW__Account__c,MUSW__Applicant__c FROM MUSW__Application2__c where id IN: appId];
        LnP_ProfessionalCode__mdt[] professionCodeMaps = [SELECT MasterLabel, License_Type__c, Profession_Code__c FROM LnP_ProfessionalCode__mdt];
        System.debug('appIDvalues::'+appId);
        List<MUSW__Application2__c> applicationList =new List<MUSW__Application2__c>();
        List<Account>  lstacc = new List<Account>();
        for(Id applicationID : appId){
            String appliID = '\''+applicationID+'\'';
            applicationList = Database.query('Select Id,MUSW__Account__r.Id,Parent_License__c,MUSW__Account__r.UBI_Number__c,Branch_License__c,MUSW__Account__c,MUSW__Account__r.Extension__c,MUSW__Account__r.Business_Website__c,MUSW__Account__r.Business_Phone__c,MUSW__Account__r.Email__c,MUSW__Account__r.Name,MUSW__Account__r.Doing_Business_As_1__c,MUSW__Account__r.First_Name_Primary_Contact__c,MUSW__Account__r.Last_Name_Primary_Contact__c,MUSW__Account__r.Phone_Primary_Contact__c,MUSW__Account__r.Course_Provider__c,Stage__c, MUSW__Applicant__c, Application_Type__c,MUSW__Account__r.Business_Structure__c,Application_Method__c, Credential_Type__c, (select Id,Answer_Text__c,License__c,Create_Endorsement_Record__c,Endorsement_Type__c,QuestionDOL__r.Data_Type__c,QuestionDOL__r.Question_Body__c,QuestionDOL__r.QuestionFieldAPI__c,QuestionDOL__r.Endorsement_Type__c,QuestionDOL__r.Course_Type_Question__c,QuestionDOL__r.RecordType.DeveloperName,QuestionDOL__r.RecordType.Name,Question_Section__c from Answers1__r) from MUSW__Application2__c where Id = '+appliID);
            for(MUSW__Application2__c application : applicationList){
                system.debug('application::'+application);
                MUSW__License2__c  mstLicense =  new MUSW__License2__c();
                mstLicense.MUSW__Applicant__c = application.MUSW__Applicant__c;
                mstLicense.Application_Type__c = application.Application_Type__c;
                mstLicense.Credential_Type__c = application.Credential_Type__c;
                mstLicense.Application_Method__c = application.Application_Method__c;
                if(application.MUSW__Account__c!=null)
                {
                    system.debug('application.Application_Type__c :'+application.Application_Type__c);
                    if(application.Credential_Type__c == 'Appraiser Course'){
                        mstLicense.RecordTypeId = courseRT;
                        system.debug('mstLicense.RecordTypeId : '+mstLicense.RecordTypeId);
                    }
                    else{
                       //US-1320 to create a new Main License Account. -- start
                        mstLicense.RecordTypeId = businessRT;
                        //mstLicense.License_Printable_Name__c = application.MUSW__Account__r.Name+' '+ doingBusinessAs;
                        system.debug('mstLicense.RecordTypeId : '+mstLicense.RecordTypeId);
                    }
                     Account acc = new Account();
                     
                        acc.Name = application.MUSW__Account__r.Name+'-'+application.Credential_Type__c;
                        acc.ParentId = application.MUSW__Account__r.Id;
                        acc.Business_Structure__c = application.MUSW__Account__r.Business_Structure__c ;
                        acc.First_Name_Primary_Contact__c  = application.MUSW__Account__r.First_Name_Primary_Contact__c;
                        acc.Last_Name_Primary_Contact__c = application.MUSW__Account__r.Last_Name_Primary_Contact__c;
                        acc.Phone_Primary_Contact__c = application.MUSW__Account__r.Phone_Primary_Contact__c;
                        acc.Course_Provider__c =  application.MUSW__Account__r.Course_Provider__c;
                        acc.Email__c  = application.MUSW__Account__r.Email__c;
                        acc.Business_Phone__c  = application.MUSW__Account__r.Business_Phone__c;
                        acc.Extension__c  = application.MUSW__Account__r.Extension__c;
                        acc.Business_Website__c   = application.MUSW__Account__r.Business_Website__c;
                        acc.RecordTypeId = mainLicenseRT ;
                        if(application.Branch_License__c){
                             acc.UBI_Number__c = application.MUSW__Account__r.UBI_Number__c;
                             mstLicense.Parent_License__c = application.Parent_License__c;
                             acc.Parentid = application.MUSW__Account__c;
                             mstLicense.isBranch_License__c = true;
                             acc.RecordTypeId = branchLicenseRT;
                         }
                        //insert acc;
                        lstacc.add(acc);
                        mstLicense.Ultimate_Parent_Account__c = application.MUSW__Account__c; 
                        
                }
                else
                {
                    mstLicense.RecordTypeId = individualRT;
                    //mstLicense.License_Printable_Name__c = firstName+' '+ MiddleName+' '+ LastName;
                    system.debug('mstLicense.RecordTypeId : '+mstLicense.RecordTypeId);
                }
                mstLicense.Application__c = application.id;
                // mstLicense.MUSW__Applicant__c = application.MUSW__Applicant__c;
                
                mstLicense.MUSW__Status__c = 'Generate Fee';
                mstLicense.Name = 'System Number';
                
                if(!professionCodeMaps.isEmpty()){
                    for(LnP_ProfessionalCode__mdt professionCodeMap : professionCodeMaps){
                        if(mstLicense.Credential_Type__c == professionCodeMap.License_Type__c){
                            mstLicense.Profession_Code__c = professionCodeMap.Profession_Code__c;
                        }
                    } 
                }
                    String printableName = '';
                    String firstName = '' ;
                    String MiddleName = '';
                    String LastName = '';
                    String doingBusinessAs = '';
                    boolean differentNameVersion = false;
                    //License_Type__mdt licenseTypemtd = new License_Type__mdt();
                    if(application.Answers1__r != null && application.Answers1__r.size()>0){
                        system.debug('Financial Guarantee if entered');
                        for(BGCK__Answer__c ans : application.Answers1__r){
                           // ans.License__c = licenseID[0].Id;    
                            //system.debug('before If : ans.Question__r.RecordType.DeveloperName::'+ans.Question__r.RecordType.DeveloperName);
                            
                            //US-2017 to add License_Printable_Name__c name on license 
  
                            //Added code by Babita
                        if(ans.QuestionDOL__r.RecordType.DeveloperName =='Review_and_Submit'){
                            system.debug(' in course info rec type filter');
                            String QuestionObjFieldAPIName = ans.QuestionDOL__r.QuestionFieldAPI__c;
                            system.debug('QuestionObjFieldAPIName--'+QuestionObjFieldAPIName);
                            
                            if(QuestionObjFieldAPIName == 'Camping_Resorts__c'){
                                system.debug('QuestionObjFieldAPIName '+QuestionObjFieldAPIName);
                                mstLicense.Camping_Resorts__c = Decimal.ValueOf(ans.Answer_Text__c);
                            }
                            if(QuestionObjFieldAPIName == 'Initial_Contracts__c'){
                                system.debug('QuestionObjFieldAPIName '+QuestionObjFieldAPIName);
                                mstLicense.Initial_Contracts__c = Decimal.ValueOf(ans.Answer_Text__c);
                            }
                        }
                            
                        if(ans.QuestionDOL__r.RecordType.DeveloperName =='Background_Questions'){
                           system.debug(' in course info rec type filter');
                            String QuestionObjFieldAPIName = ans.QuestionDOL__r.QuestionFieldAPI__c;
                            system.debug('QuestionObjFieldAPIName--'+QuestionObjFieldAPIName);
                            if(QuestionObjFieldAPIName == 'Military__c'){
                                system.debug('QuestionObjFieldAPIName '+QuestionObjFieldAPIName);
                                if(ans.Answer_Text__c == 'Yes')
                                {
                                   mstLicense.Military__c = true; 
                                }
                                
                            }
                            if(QuestionObjFieldAPIName == 'Military_Spouse__c'){
                                system.debug('QuestionObjFieldAPIName '+QuestionObjFieldAPIName);
                                if(ans.Answer_Text__c == 'Yes')
                                {
                                   mstLicense.Military_Spouse__c = true; 
                                }
                                
                            }
                            if(QuestionObjFieldAPIName == 'Timeshare_Projects__c'){
                                system.debug('QuestionObjFieldAPIName '+QuestionObjFieldAPIName);
                                mstLicense.Timeshare_Projects__c = Decimal.ValueOf(ans.Answer_Text__c);
                            }
                            if(QuestionObjFieldAPIName == 'Apartment_Units__c'){
                                system.debug('QuestionObjFieldAPIName '+QuestionObjFieldAPIName);
                                mstLicense.Apartment_Units__c = Decimal.ValueOf(ans.Answer_Text__c);
                            }
                            if(QuestionObjFieldAPIName == 'Interval_fees__c'){
                                system.debug('QuestionObjFieldAPIName '+QuestionObjFieldAPIName);
                                mstLicense.Interval_fees__c = Decimal.ValueOf(ans.Answer_Text__c);
                            }
                            if(QuestionObjFieldAPIName == 'Advertising_Fees__c'){
                                system.debug('QuestionObjFieldAPIName '+QuestionObjFieldAPIName);
                                mstLicense.Advertising_Fees__c = Decimal.ValueOf(ans.Answer_Text__c);
                            }
                            if(QuestionObjFieldAPIName == 'Pieces_of_Personal_Property__c'){
                                system.debug('QuestionObjFieldAPIName '+QuestionObjFieldAPIName);
                                mstLicense.Pieces_of_Personal_Property__c = Decimal.ValueOf(ans.Answer_Text__c);
                            }
                            if(QuestionObjFieldAPIName == 'Camping_Resorts__c'){
                                system.debug('QuestionObjFieldAPIName '+QuestionObjFieldAPIName);
                                mstLicense.Camping_Resorts__c = Decimal.ValueOf(ans.Answer_Text__c);
                            }
                            if(QuestionObjFieldAPIName == 'Initial_Contracts__c'){
                                system.debug('QuestionObjFieldAPIName '+QuestionObjFieldAPIName);
                                mstLicense.Initial_Contracts__c = Decimal.ValueOf(ans.Answer_Text__c);
                            }
                       }
                       //-----------Completed by Babita------------------
                            if(ans.QuestionDOL__r.Question_Body__c.contains('How will your name appear') && firstName == '' ){
                               firstName  = ans.Answer_Text__c +' ';
                            }
                            
                            if(ans.QuestionDOL__r.Question_Body__c.contains('Doing Business As') && doingBusinessAs == '' ){
                               doingBusinessAs  = ans.Answer_Text__c +' ';
                            }
                            
                            if(ans.QuestionDOL__r.Question_Body__c=='*Middle Name or initial' && MiddleName == '' ){
                                MiddleName = ans.Answer_Text__c +' ';
                            }
                            
                            if(ans.QuestionDOL__r.Question_Body__c=='*Last Name' && LastName == '' ){
                                LastName = ans.Answer_Text__c;
                            }
                            
                            
                            if(ans.QuestionDOL__r.RecordType.DeveloperName == 'Financial_Guarantee'){
                            //system.debug('after If : ans.Question__r.RecordType.DeveloperName::'+ans.Question__r.RecordType.DeveloperName);
    
                                String quesBody = ans.QuestionDOL__r.Question_Body__c;
                                String answerText = ans.Answer_Text__c;
                                String stringToDate = '';
                                if(quesBody == 'Bond Number'){
                                    mstLicense.Bond_Number__c = String.valueOf(answerText);
                                }
    
                                if(quesBody == 'Surety Bond Company Name'){
                                    mstLicense.Surety_Bond_Company_Name__c = String.valueOf(answerText);
                                }
    
                                if(quesBody == 'Policy Amount'){
                                    mstLicense.Policy_Amount__c = String.valueOf(answerText);
                                }
    
                                if(quesBody == 'Effective Date of Bond'){
                                    stringToDate = String.valueOf(answerText);
                                    Integer year = Integer.valueOf(stringToDate.subString(0, 4));
                                    Integer month = Integer.valueOf(stringToDate.substring(5, 7));
                                    Integer day = Integer.valueOf(stringToDate.subString(8));
                                    Date d = Date.newInstance(year, month, day);
    
                                    mstLicense.Effective_Date_of_Bond__c = d;
                                }
    
                                if(quesBody == 'Expiration Date of Bond'){
                                    stringToDate = String.valueOf(answerText);
                                    Integer year = Integer.valueOf(stringToDate.subString(0, 4));
                                    Integer month = Integer.valueOf(stringToDate.substring(5, 7));
                                    Integer day = Integer.valueOf(stringToDate.subString(8));
                                    Date d = Date.newInstance(year, month, day);
    
                                    mstLicense.Expiration_Date_of_Bond__c = d;
                                }
                            }            
    
                        }  
                     }
                
                                            
                if(application.Credential_Type__c == 'Notary Public'){
                    mstLicense.MUSW__Expiration_Date__c = mstLicense.Expiration_Date_of_Bond__c;
                    
                    if(!(mstLicense.Effective_Date_of_Bond__c < system.today())){
                       mstLicense.MUSW__Issue_Date__c = mstLicense.Effective_Date_of_Bond__c;       
                    }
                }
                System.debug('mstLicense : '+mstLicense);
                 
                if(mstLicense.RecordTypeId == individualRT){
                    mstLicense.License_Printable_Name__c = firstName+' '+ MiddleName+' '+ LastName;
                }
                if(mstLicense.RecordTypeId == businessRT){
                    mstLicense.License_Printable_Name__c = application.MUSW__Account__r.Name+' '+ doingBusinessAs;
                } 
 
                lstLisence.add(mstLicense);
            }
        }
        
        try{
        List<MUSW__License2__c> mstList = new List<MUSW__License2__c>();
             if(!lstAcc.isEmpty()){
                insert lstAcc;
                for(MUSW__License2__c lic : lstLisence ){
                    lic.MUSW__Primary_Licensee__c =  lstAcc[0].id;
                    mstList.add(lic);
                    System.debug('***mstList***'+mstList);
                }
                Polaris_ApplyForLicenseController.addAffiliation(lstAcc);
            }
            if(!mstList.isEmpty()){
                insert mstList;
            }else{
                insert lstLisence;
            }
           
        } catch (Exception ex) {
            Polaris_CreateErrorLog_Exception.addError(ex,'Polaris_ApplyForLicenseController','insertLisence');
        }

        return lstLisence;
        
    }
    
     //to add Account_Contact for Main License Acount 
    @AuraEnabled
    public static void addAffiliation(List<Account> acclist){
        List<MUSW__Account_Contact__c> muswAccConList = new List<MUSW__Account_Contact__c>();
        User currentUser = [SELECT Id,Name,firstname,lastname,ContactId,email from User Where ID = :UserInfo.getUserId() LIMIT 1];
        for(Account acc : accList){
        Id businessRT = SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_Account').getRecordTypeId();
        if(acc.RecordTypeID == businessRT ){
             MUSW__Account_Contact__c ac = new MUSW__Account_Contact__c();
                ac.MUSW__Account__c = acc.Id;
                ac.MUSW__Contact__c = currentUser.ContactId;
                ac.Status__c= 'Active' ;
                ac.isAdminContact__c = True;
                ac.Role__c = 'Administrator';
                ac.Account_Admin__c = true;
                ac.Email__c = currentUser.Email;
                ac.First_Name__c = currentUser.firstname;
                ac.Middle_Name__c = currentUser.firstname;
                ac.Last_Name__c = currentUser.lastName;
                ac.Email__c = currentUser.email;
                ac.Title__c = 'Administrator';
                muswAccConList.add(ac);
        }
        }
        try{
        if(!muswAccConList.isEmpty()){
            insert muswAccConList;
        }
        }catch(Exception ex){
            Polaris_CreateErrorLog_Exception.addError(ex,'Polaris_ApplyForLicenseController','insert muswAccConList');
        }
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
    
    //Fetch all the addresses
    public static Map<String, List<MUSW__Parcel__c>> getAddresses (Set<Id> appId){
        Map<String, List<MUSW__Parcel__c>> mapAddress  =  new Map<String,List<MUSW__Parcel__c>>();
        List<MUSW__Parcel__c> lstAddress  = [SELECT id, MUSW__Street2__c,MUSW__Unit__c,MUSW__City__c,MUSW__State__c,Zip_Postal_Code__c,Country__c,Melissa_Address_Verified__c,
                                                      is_Physical_and_Mailing_Address_Same__c,Address_Type__c, Canadian_provinces__c, County__c from MUSW__Parcel__c 
                                                      where Application_BG__c IN :appId];
        if(!lstAddress.isEmpty()){
            for(MUSW__Parcel__c parcelAddress : lstAddress) {
                if(mapAddress.containsKey(parcelAddress.Address_Type__c)) {
                    mapAddress.get(parcelAddress.Address_Type__c).add(parcelAddress);
                } else {
                    mapAddress.put(parcelAddress.Address_Type__c, new List<MUSW__Parcel__c>{parcelAddress});
                }
            }
        }
        return  mapAddress ;
    }
    //Fetch BackgroundInformation
    public static Map<String,List<LnP_BackgroundSection__c>> getBackgroundInformation (Set<Id> appId) {
        Map<String, List<LnP_BackgroundSection__c>> mapBackgroundInfo =  new Map<String,List<LnP_BackgroundSection__c>>();
        List<LnP_BackgroundSection__c> lstBackground = [SELECT Id, RecordType.name , Application_BG__c FROM LnP_BackgroundSection__c WHERE Application_BG__c IN :appId and RecordTypeID != null];
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
    
    public static String getFormattedValue(String str) {
        return str != null ? str.replace('\r\n', ' ').replace('\n', ' ').escapeHtml4() : str; 
    }
    
    @AuraEnabled
    public static Boolean getTotalBalance(Id licId){
        Boolean noFees;
        List<MUSW__License2__c> licList = [select Id,MUSW__Total_Balance__c from MUSW__License2__c where Id=:licId];
        if(!licList.isEmpty() && licList[0].MUSW__Total_Balance__c == 0){
            noFees = true;
        }else{
            noFees = false;
        }
        
        if(noFees){
            licList[0].No_Fee_Required__c = noFees;
            update licList[0];
        }
        
        return noFees;
    
    }
    
}