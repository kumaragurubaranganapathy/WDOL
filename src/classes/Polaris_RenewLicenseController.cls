public class Polaris_RenewLicenseController {
    public static Contact currentContact {get;set;}
    public static MUSW__License2__c liceseIDRenewal {get;set;}
    public static List<MUSW__Application2__c> lstApps {get;set;}
    public static String sections {get;set;}
    public static Map<String,String> mapMandatorySubsection {get;set;}
    public static List<Application_Field__c> lstApplicationFields {get;set;}
    public static List<Question__c> lstQuestions {get;set;}
    public static List<User> lstUserInfoData {get;set;}
    public static List<MUSW__Master_Submission_List__c> lstMasterSubmission {get;set;}
    public static Map<String,String> mapSubsectionIcon {get;set;}
    
    @AuraEnabled
    public static string fetchRenewalData( String appId, String renewReinstate, String board, String licenseType, String applicationType, String flowType, String licID)
    {
        try{
            //Creating the conditions for fetching the data       
            Integer tabIndex = 1;
            Integer currentTab = 0;
            LnP_JSONParser ansWrapper; //to create Wrapper 
            String jsonApplicationFields = '';
            List<LnP_ApplyForLicenseWrapper> lstLicenseWrapper = new List<LnP_ApplyForLicenseWrapper>();
            //Fetching data for subsection icon
            Map<String,String> mapTempSubsectionIcon = Polaris_RenewLicenseService.fetchSubsectionIcons(System.Label.Page_Name_For_License);
            mapSubsectionIcon = new Map<String,String>();
            if(mapSubsectionIcon.isEmpty() && !mapTempSubsectionIcon.isEmpty())
            {
                mapSubsectionIcon = mapTempSubsectionIcon;
            }
            
            //Fetching mandatory Subsection
            mapMandatorySubsection = new Map<string,String>();
            Map<string,String> mapTempMandatorySubsection = Polaris_RenewLicenseService.fetchMandatorySubsections(board,licenseType,renewReinstate);
            if(!mapTempMandatorySubsection.isEmpty())
            {
                mapMandatorySubsection = mapTempMandatorySubsection;
            }
            
            //Fetching Application fields for license
            lstApplicationFields = new List<Application_Field__c>();
            List<Application_Field__c> lstTempApplicationFields = Polaris_RenewLicenseService.fetchApplicationFields(board,licenseType,applicationType);
            if(!lstTempApplicationFields.isEmpty())
            {
                lstApplicationFields = lstTempApplicationFields;
            }        
            jsonApplicationFields = JSON.serialize(lstApplicationFields);
            //Fetching the data related to  a user and storing in the list
            lstUserInfoData = new List<User>();
            List<User> lstuserData  = Polaris_RenewLicenseService.fetchUserDetails();
            if(!lstuserData.isEmpty())
            {
                lstUserInfoData = lstuserData;
            }
            
            //Fetching the questions in the system per licenseType and applicationType for general application and comity
            lstQuestions = new List<Question__c>();
            List<Question__c> lstTempQuestions = Polaris_RenewLicenseService.fetchQuestionsDetails(board,licenseType,applicationType,renewReinstate);
            if(!lstTempQuestions.isEmpty())
            {
                lstQuestions = lstTempQuestions;
            }
            
            //Fetching the Master submission list in the system per licenseType and applicationType for general application and comity
            lstMasterSubmission = new List<MUSW__Master_Submission_List__c>();
            List<MUSW__Master_Submission_List__c> lstTempMasterSubmission = Polaris_RenewLicenseService.fetchMasterSubmissionDetails(board,licenseType,applicationType,renewReinstate);
            if(!lstTempMasterSubmission.isEmpty())
            {
                lstMasterSubmission = lstTempMasterSubmission;
            }    
            
            //Fetching Section
            List<LnP_License_Type_Sections_Setting__mdt> lstSections = new List<LnP_License_Type_Sections_Setting__mdt>();        
            lstSections = Polaris_RenewLicenseService.fetchSection(board,licenseType,renewReinstate);
            system.debug('lstSections---'+lstSections);
            if(!lstSections.isEmpty())
            {
                sections = lstSections[0].Sections__c;
            }
            List<String> lstOfSections = sections.split(',');
            //Fetching endorsement from License
            List <Endorsement__c> lstendo = Polaris_RenewLicenseService.fetchEndorsements(licID);
            //Fetching Applications by application id
            lstApps = new List<MUSW__Application2__c>();
            List<MUSW__Application2__c> lstTempApplication =new List<MUSW__Application2__c>();
            lstTempApplication = Polaris_RenewLicenseService.fetchApplications(appId);
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
                mapLabel.fieldType = DOL_AppConstants.ATTACHMENT;
                mapLabel.isGenericSub = true;
                mapLabel.orderBy = masterSubmissionRecord.Order_No__c;
                if(masterSubmissionRecord.Submission_Type__c != null && masterSubmissionRecord.Submission_Type__c.contains(DOL_AppConstants.SOFTCOPY_TO_BE_UPLOADED)){
                    mapLabel.uploadFile = true;
                }
                if(masterSubmissionRecord.Submission_Type__c != null && masterSubmissionRecord.Submission_Type__c.contains(DOL_AppConstants.HARDCOPY_TO_BE_UPLOADED)){
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
                            if(req.body.ContentDocumentId != null && req.body.ContentDocumentId.contains(DOL_AppConstants.SEMI_COLON)){
                                mapLabel.multiValues = req.body.ContentDocumentId.split(DOL_AppConstants.SEMI_COLON);
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
                labelToFields.label =  Ques.Question_Body__c.replaceAll('<span[^>]*>','');
                labelToFields.labelId = Ques.Id;
                labelToFields.fieldType = Ques.Data_Type__c;
                labelToFields.hasChild = Ques.Has_dependent_questions__c;
                labelToFields.parentQuestionId = Ques.Parent_Question__c;
                labelToFields.submissionDetails = Ques.Submission_Title__c;
                labelToFields.questionSectionClass = Ques.Section__c;
                labelToFields.regex = Ques.Regex_Validation__c;
                labelToFields.minValue = Ques.min_value__c;
                labelToFields.maxValue = Ques.max_value__c; 
                labelToFields.validationCriteria = Ques.Validation_Criteria__c;
                labelToFields.message = Ques.Message__c;
                labelToFields.warningMessages  = Ques.Warning_Message__c;
                labelToFields.endorsementType=Ques.Endorsement_Type__c;
                labelToFields.messageTriggerResponse = Ques.MessageTriggerResponse__c;
                labelToFields.errormsg = Ques.Error_Message__c; 
                labelToFields.questionSectionDetail = Ques.Sub_Header__c;
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
                    labelToFields.questionSection = DOL_AppConstants.NULL_STRING;
                }
                else
                {
                    labelToFields.questionSection = Ques.Section__c;
                    questionSection = Ques.Section__c;
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
                //added code to remove endorsement questions
                Integer countEndoQuesVisible = 0;
                for(Endorsement__c endo : lstendo)
                {
                    
                    if(endo.Endorsement_Type__c == Ques.Endorsement_Type__c )
                    {
                        countEndoQuesVisible++;   
                    }
                }
                if(countEndoQuesVisible!=0)
                {
                    labelToFields.renderedOnUi = false;
                }
                
                labelToFields.fieldAPIName = Ques.QuestionFieldAPI__c;
                labelToFields.fieldObjName = Ques.QuestionObjectName__c;
                labelToFields.conditionalAnswer = Ques.Triggering_Parent_Answer__c;
                if(Ques.Possible_Responses__c != null && Ques.Data_Type__c == DOL_AppConstants.PICKLIST)
                {
                    labelToFields.fieldValueOptions = Ques.Possible_Responses__c.split(DOL_AppConstants.SEMI_COLON);
                }
                else if(Ques.Possible_Responses__c != null && (Ques.Data_Type__c == DOL_AppConstants.RADIO ||Ques.Data_Type__c == DOL_AppConstants.CHECKBOX ||Ques.Data_Type__c == DOL_AppConstants.YES_NO))
                { 
                    for(String radio : Ques.Possible_Responses__c.split(DOL_AppConstants.SEMI_COLON)){
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
                        if(req.body!=null && req.body.Question == Ques.Id && req.body.Answer != null)
                        {
                            if(req.body.Answer!= null && req.body.Answer.contains(DOL_AppConstants.SEMI_COLON))
                            {
                                labelToFields.multiValues = req.body.Answer.split(DOL_AppConstants.SEMI_COLON);
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
                if(!mapSubsectionIcon.isEmpty() && mapSubsectionIcon.containsKey(section+ DOL_AppConstants.ICON))
                {
                    licenseWrapper.icon = mapSubsectionIcon.get(section+ DOL_AppConstants.ICON);              
                }
                //Creating JSON for Personal Information section
                if(section == DOL_AppConstants.PERSONAL_INFORMATION )
                {
                    licenseWrapper.personalInfoObjectName = DOL_AppConstants.CONTACT;
                    licenseWrapper.fieldJson = jsonApplicationFields;
                    /*if(!lstLicenseApplication.isEmpty() && lstLicenseApplication[0].Contact__c != null )
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
                else if(section == DOL_AppConstants.COURSE_INFORMATION && !lstApps.isEmpty()){
                    licenseWrapper.personalInfoObjectName = DOL_AppConstants.ACCOUNT;
                    licenseWrapper.accountId = lstApps[0].MUSW__Account__c;
                    licenseWrapper.fieldJson = jsonApplicationFields;
                } //end
                else if(section == DOL_AppConstants.BUSINESS_INFORMATION &&  !lstApps.isEmpty())
                {
                    licenseWrapper.personalInfoObjectName = DOL_AppConstants.ACCOUNT; 
                    licenseWrapper.accountId = lstApps[0].MUSW__Account__c;
                    licenseWrapper.fieldJson = jsonApplicationFields;
                }
                else if(section == DOL_AppConstants.ATTACHMENTS)
                {
                    licenseWrapper.sobjectType = DOL_AppConstants.SUBMISSION;
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
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            return null;
        }
    }
    
    private static LnP_JSONParser getJSONWrapper(String formJson){
        //system.debug('lstLicenseApplication'+lstLicenseApplication);
        try{
            String strJsonForm = '';
            //  for(LnP_Licence_Application__c app : lstLicenseApplication){
            strJsonForm = strJsonForm + formJson;
            // }   
            Map<String,Object> mapfield = (Map<String,Object>)JSON.deserializeUntyped(strJsonForm);        
            strJsonForm = JSON.serialize(mapfield);        
            LnP_JSONParser parser = LnP_JSONParser.parse(strJsonForm);
            return parser;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            return null;
        }
    }
    
    public static List<LnP_ApplyForLicenseWrapper> fetchSubmission(List<LnP_ApplyForLicenseWrapper> wrapperList,String Board, String LicenseType, String ApplicationType){
        try{
            Set<String> submissionList  = new Set<String>(); 
            List<LnP_ApplyForLicenseWrapper.MapLabelToFields> listFields = new List<LnP_ApplyForLicenseWrapper.MapLabelToFields>();
            List<MUSW__Master_Submission_List__c> masterSubmissionList = new List<MUSW__Master_Submission_List__c>();
            List<LnP_ApplyForLicenseWrapper.MapLabelToFields> listFieldSub = new List<LnP_ApplyForLicenseWrapper.MapLabelToFields>();
            List<LnP_ApplyForLicenseWrapper.MapLabelToFields> listFieldTemp = new List<LnP_ApplyForLicenseWrapper.MapLabelToFields>();
            for(LnP_ApplyForLicenseWrapper objWrapper : wrapperList){
                if(objWrapper.sectionName.contains(DOL_AppConstants.LICENSE_INFORMATION)||objWrapper.sectionName.contains(DOL_AppConstants.QUESTIONS) || objWrapper.sectionName.contains(DOL_AppConstants.ENDORSEMENT)){
                    
                    for(LnP_ApplyForLicenseWrapper.MapLabelToFields abc: objWrapper.labelFieldsMap) {
                        listFields.add(abc);
                    }                
                }
                if(objWrapper.sectionName.contains(DOL_AppConstants.ATTACHMENTS)){
                    listFieldSub = objWrapper.labelFieldsMap;
                }
            }
            system.debug('List Fields '+Json.serialize(listFieldSub));
            for(LnP_ApplyForLicenseWrapper.MapLabelToFields fieldMap : listFields){
                if((fieldMap.submissionDetails != '' && fieldMap.submissionDetails != null) ){
                    if (fieldMap.value != null && fieldMap.value != '' ) {
                        Map<String, String> mapAttachment = (Map<String, String>)JSON.deserialize(fieldMap.submissionDetails,Map<String, String>.class);
                        system.debug('mapAttachment12344'+mapAttachment);
                        if(mapAttachment.containsKey(fieldMap.value)){
                            submissionList.addAll(mapAttachment.get(fieldMap.value).split(DOL_AppConstants.COMMA));
                        }
                    }
                    else if(fieldMap.multiValues != null && fieldMap.multiValues.size()>0){
                        for(String str : fieldMap.multiValues){
                            Map<String, String> mapAttachment = (Map<String, String>)JSON.deserialize(fieldMap.submissionDetails,Map<String, String>.class);
                            if(mapAttachment.containsKey(str)){
                                submissionList.addAll(mapAttachment.get(str).split(DOL_AppConstants.COMMA));
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
            String mastSubCond3 = 'Credential_Type__c =\''+LicenseType+'\'';
            String mastSubCond4 = 'Title__c IN: XXX ORDER BY  Order_No__c ASC';
            String strSubmission = 'Select Id, Order_No__c,Name,Title__c,Question__c,Expected_Answer__c,Submission_Type__c, Required__c,  Active__c, Default__c, Application_Type__c, Credential_Type__c, Application_Method__c from MUSW__Master_Submission_List__c where ' +mastSubCond1+ ' AND '+mastSubCond2+ ' AND '+mastSubCond3+ ' AND ' +mastSubCond4 ;
            system.debug('submissionList'+submissionList);
            masterSubmissionList = Utilityclass_withsharing.queryRecordsInClause(strSubmission,submissionList);
            Map<Decimal,LnP_ApplyForLicenseWrapper.MapLabelToFields> submissions = new Map<Decimal,LnP_ApplyForLicenseWrapper.MapLabelToFields>();
            Map<Decimal,LnP_ApplyForLicenseWrapper.MapLabelToFields> warapperMapSorted = new Map<Decimal,LnP_ApplyForLicenseWrapper.MapLabelToFields>();
            for(LnP_ApplyForLicenseWrapper.MapLabelToFields fieldMap : listFieldSub){
                if(fieldMap.isGenericSub == true){
                    warapperMapSorted.put(fieldMap.orderBy,fieldMap);  
                }
                else{
                    submissions.put(fieldMap.orderBy,fieldMap);  
                }
            }
            
            if(masterSubmissionList.size()>0){
                for(MUSW__Master_Submission_List__c master : masterSubmissionList){
                    if(submissions.containsKey(master.Order_No__c)){
                        warapperMapSorted.put(master.Order_No__c,submissions.get(master.Order_No__c));
                    }
                    else{
                        LnP_ApplyForLicenseWrapper.MapLabelToFields submissionMap = new LnP_ApplyForLicenseWrapper.MapLabelToFields();
                        submissionMap.label = master.Name;
                        submissionMap.conditionalAnswer = master.Title__c;
                        submissionMap.orderBy = master.Order_No__c;
                        submissionMap.fieldType = DOL_AppConstants.ATTACHMENT;
                        if(master.Submission_Type__c != null && master.Submission_Type__c.contains('Softcopy: To be Uploaded')){
                            submissionMap.uploadFile = true;
                        }
                        if(master.Submission_Type__c != null && master.Submission_Type__c.contains('Hardcopy: To be Mailed')){
                            submissionMap.acknowledge = true;
                        }
                        if(master.Required__c){
                            submissionMap.isMandatorySub = true;   
                        }
                        warapperMapSorted.put(submissionMap.orderBy,submissionMap);
                    }
                }
            }
            List<Decimal> lststing = new List<Decimal>();
            lststing.addAll(warapperMapSorted.keyset());
            lststing.sort();
            Map<Decimal,LnP_ApplyForLicenseWrapper.MapLabelToFields> warapperMapSorted2 = new Map<Decimal,LnP_ApplyForLicenseWrapper.MapLabelToFields>();
            for( Integer i= 0;i < lststing.size(); i++){
                warapperMapSorted2.put(lststing[i],warapperMapSorted.get(lststing[i]));
            }
            listFieldTemp = warapperMapSorted2.values();
            listFieldSub.clear();
            listFieldSub.addAll(listFieldTemp);
            return wrapperList;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            return null;
        }
    }
    @AuraEnabled 
    public static String insertApplication(String dataString, Integer tabNumber, Id appId, String Board, String LicenseType, String ApplicationType){
        
        Boolean questionsIncomplete = false;
        Boolean FGquestionsIncomplete = false;
        Boolean submissionsIncomplete = true;
        Map<String,List<MUSW__Parcel__c>> mapAddress = new  Map<String,List<MUSW__Parcel__c>>();
        Map<String,List<LnP_BackgroundSection__c>> mapEducation = new  Map<String,List<LnP_BackgroundSection__c>>();
        Set<Id>  setAppId = new Set<Id> ();
        setAppId.add(appId);
        Id accountIdFromApplication; 
        for(MUSW__Application2__c getAccountIdFromApplication: [Select Id, MUSW__Account__c From MUSW__Application2__c where Id = :appId]){
            accountIdFromApplication = getAccountIdFromApplication.MUSW__Account__c;
        }
        mapEducation = getBackgroundInformation(setAppId);
        List<LnP_ApplyForLicenseWrapper> wrapperList = (List<LnP_ApplyForLicenseWrapper>)JSON.deserialize(dataString, List<LnP_ApplyForLicenseWrapper>.class);
        Integer questionsAnswered=0;
        Integer FGquestionsAnswered=0;
        String accountId='';
        if(!wrapperList.isEmpty()){
            accountId =  wrapperList[0].accountId != null ? wrapperList[0].accountId : '';
            system.debug('accountId---'+accountId);
        }
        wrapperList = fetchSubmission(wrapperList, Board,  LicenseType,  ApplicationType);
        Id contactAccountId;
        Id contactRecordId = getCommunityUserContactId();
        System.debug('contactRecordId for insert application===' + contactRecordId + 'accountIdFromApplication---' + accountIdFromApplication);
        if(String.isNotBlank(accountIdFromApplication)){
            contactAccountId = accountIdFromApplication;
        }else{
            contactAccountId = contactRecordId;
        }
        System.debug('Entered mapAddress method---' + appId);
        mapAddress = getAddresses(contactAccountId, appId);
        List<LnP_ApplyForLicenseWrapper.MapLabelToFields> listFields = new List<LnP_ApplyForLicenseWrapper.MapLabelToFields>();
        List<LnP_ApplyForLicenseWrapper.MapLabelToFields> submissionFields = new List<LnP_ApplyForLicenseWrapper.MapLabelToFields>();
        lstUserInfoData = new List<User>();
        List<User> lstuserData  = Polaris_RenewLicenseService.fetchUserDetails();
        String getContactId ='';
        if(!lstuserData.isEmpty())
        {
            lstUserInfoData = lstuserData;
        }
        if(lstUserInfoData[0].ContactId != null){
            getContactId = lstUserInfoData[0].ContactId;
        }
        LnP_JSONParser finalRequest = new LnP_JSONParser();
        List<LnP_JSONParser.CompositeRequest> requestDetailsList = new List<LnP_JSONParser.CompositeRequest>();
        for(LnP_ApplyForLicenseWrapper objWrapper : wrapperList){
            if(objWrapper.sectionName.contains(DOL_AppConstants.LICENSE_INFORMATION) || objWrapper.sectionName.contains(DOL_AppConstants.FINANCIAL_GUARANTEE) || objWrapper.sectionName.contains(DOL_AppConstants.ENDORSEMENT) 
               || objWrapper.sectionName.contains(DOL_AppConstants.QUESTIONS) || objWrapper.sectionName.contains(DOL_AppConstants.REVIEW_AND_SUBMIT)){
                   listFields.addAll(objWrapper.labelFieldsMap);
               }
            if(objWrapper.sectionName.contains(DOL_AppConstants.ATTACHMENTS)){
                submissionFields = objWrapper.labelFieldsMap;
            }
        }
        System.debug('listFields'+JSON.serialize(listFields));
        if(listFields.size()>0){
            Integer count = 0;
            Integer questioncount = 0;
            Integer FGquestioncount = 0;
            Integer refcount = 0;
            for(LnP_ApplyForLicenseWrapper.MapLabelToFields fieldMap : listFields){
                refcount++;
                if(fieldMap.questionSectionClass == DOL_AppConstants.CERTIFICATIONS  || (fieldMap.value != null && fieldMap.value != '' && fieldMap.value != DOL_AppConstants.NONE && fieldMap.value != DOL_AppConstants.SELECT_ONE) || (fieldMap.multiValues != null && fieldMap.multiValues.size()>0)){
                    
                    LnP_JSONParser.CompositeRequest requestDetails = new LnP_JSONParser.CompositeRequest();
                    requestDetails.method = 'POST';
                    requestDetails.url = '/services/data/v38.0/sobjects/BGCK__Answer__c';
                    requestDetails.referenceId = 'refId'+refcount;
                    LnP_JSONParser.Body body = new LnP_JSONParser.Body();
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
                    body.Question = fieldMap.labelId;
                    body.Application = appId;
                    requestDetails.body = body;
                    requestDetailsList.add(requestDetails);
                }
                if(fieldMap.renderedOnUi!=null && fieldMap.renderedOnUi == true && fieldMap.questionSectionClass.contains(DOL_AppConstants.QUESTIONS) || fieldMap.questionSectionClass.contains(DOL_AppConstants.FINANCIAL_GUARANTEE) || fieldMap.questionSectionClass.contains(DOL_AppConstants.ENDORSEMENT) || fieldMap.questionSectionClass.contains(DOL_AppConstants.COURSE) || fieldMap.questionSectionClass.contains(DOL_AppConstants.APPLICATION_FEES)){
                    count++;  
                }
                if(fieldMap.renderedOnUi!=null && fieldMap.renderedOnUi == true && fieldMap.questionSectionClass.contains(DOL_AppConstants.QUESTIONS) && fieldMap.isMandatoryQues ==true){
                    questioncount++;
                }
                if(fieldMap.renderedOnUi!=null && fieldMap.renderedOnUi == true &&  fieldMap.questionSectionClass.contains(DOL_AppConstants.FINANCIAL_GUARANTEE) ){
                    FGquestioncount++;
                }
                if( fieldMap.questionSectionClass.contains(DOL_AppConstants.QUESTIONS)  && fieldMap.isMandatoryQues ==true && fieldMap.renderedOnUi!=null && fieldMap.renderedOnUi==true && (fieldMap.value != null && fieldMap.value !='' || fieldMap.multiValues != null  ) ){
                    questionsAnswered++;
                }
                if(fieldMap.questionSectionClass.contains(DOL_AppConstants.FINANCIAL_GUARANTEE) && fieldMap.renderedOnUi!=null && fieldMap.renderedOnUi==true && fieldMap.value != null && fieldMap.value !='' ){
                    FGquestionsAnswered++;
                }
            }
            //validationForQuestions:
            if(questionsAnswered != questioncount ){
                questionsIncomplete = true;
            }
            if(FGquestionsAnswered != FGquestioncount ){
                FGquestionsIncomplete = true;
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
                    
                    if(link.LinkedEntityId == appId)
                        docLinkMap.put(link.ContentDocumentId,link.Id);
                }    
            }
            Integer count = 0;
            Integer subcount = 0;
            for(LnP_ApplyForLicenseWrapper.MapLabelToFields fieldMap : submissionFields){
                subcount++;
                if(fieldMap.isMandatorySub == true){
                    count++;
                }
                if(fieldMap.isMandatorySub == true && !fieldMap.multiValues.isEmpty()){
                    filesSubmitted++;
                }
                if((fieldMap.multiValues != null && fieldMap.multiValues.size()>0 && fieldMap.uploadFile) ){
                    Integer innerCount = 0;
                    for(String contentdocId : fieldMap.multiValues){
                        innerCount++;
                        LnP_JSONParser.CompositeRequest requestDetails = new LnP_JSONParser.CompositeRequest();
                        requestDetails.method = 'DELETE';
                        requestDetails.url = '/services/data/v38.0/sobjects/ContentDocumentLink/'+docLinkMap.get(contentdocId);
                        requestDetails.referenceId = 'refDocId'+subcount+innerCount;
                        requestDetailsList.add(requestDetails);
                    }
                }
                LnP_JSONParser.CompositeRequest requestDetailSub = new LnP_JSONParser.CompositeRequest();
                requestDetailSub.method = 'POST';
                requestDetailSub.url = '/services/data/v38.0/sobjects/MUSW__Submission__c';
                requestDetailSub.referenceId = 'refSubId'+subcount;
                LnP_JSONParser.Body bodySub = new LnP_JSONParser.Body();
                bodySub.Name = fieldMap.conditionalAnswer;
                bodySub.MUSW_Description = fieldMap.label;
                bodySub.MUSW_Application2= appId;
                bodySub.Hardcopy = fieldMap.acknowledgeResponse;
                bodySub.ContentDocumentId ='';
                Integer innerCount = 0;
                if((fieldMap.multiValues != null && fieldMap.multiValues.size()>0 && fieldMap.uploadFile) ){
                    for(String contentdocId : fieldMap.multiValues){
                        innerCount++;
                        LnP_JSONParser.CompositeRequest requestDetailsContent = new LnP_JSONParser.CompositeRequest();
                        requestDetailsContent.method = 'POST';
                        requestDetailsContent.url = '/services/data/v38.0/sobjects/ContentDocumentLink';
                        requestDetailsContent.referenceId = 'refContId'+innerCount;
                        LnP_JSONParser.Body bodyLink = new LnP_JSONParser.Body();
                        bodyLink.LinkedEntityId = '@{refSubId'+innerCount+'.id}';
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
        String jsonString = JSON.serialize(field);
        List<MUSW__Application2__c> appList =new List<MUSW__Application2__c>();
        String appCondition = 'Id=\''+appId+'\'';
        String strApp = 'Select Id,MUSW__Account__c,Stage__c, Application_Type__c,  Application_Method__c, Credential_Type__c from MUSW__Application2__c where '+appCondition;
        appList = Utilityclass_withsharing.queryRecords(strApp);
        List<Education_History__c> lstEducations = new List<Education_History__c>();
        
        MUSW__Application2__c application = new MUSW__Application2__c();
        if(appList.size()>0){
            if(appList[0].Education_History__r != null && appList[0].Education_History__r.size() >0){
                
                lstEducations.addAll(appList[0].Education_History__r);
            }
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
            if(objWrapper.sectionName.contains('Attachments') && submissionsIncomplete == true){
                objWrapper.sectionError = true;
            } 
            if(objWrapper.mandatorySubsection != null){
                lstMandatorySubsection = objWrapper.mandatorySubsection.split(DOL_AppConstants.COMMA) ;
                if(lstMandatorySubsection != null){
                    for(String mandatorySubSection : lstMandatorySubsection){
                        if((mandatorySubSection == DOL_AppConstants.PHYSICAL_ADDRESS || mandatorySubSection == DOL_AppConstants.MAILING_ADDRESS)){
                            if(mapAddress.isEmpty()){
                                objWrapper.sectionError = true;
                            }
                            else{
                                if(!mapAddress.containsKey(DOL_AppConstants.CAP_MAILING_ADDRESS) || (!mapAddress.containsKey(DOL_AppConstants.CAP_PHYSICAL_ADDRESS) && !mapAddress.get('MAILING ADDRESS')[0].is_Physical_and_Mailing_Address_Same__c)){
                                    objWrapper.sectionError = true;
                                    
                                }
                            }                         
                        }
                        else if((mandatorySubSection == DOL_AppConstants.QUALIFYING_EDUCATION || mandatorySubSection == DOL_AppConstants.QUALYFYING_TRAINING || mandatorySubSection == DOL_AppConstants.QUALYFYING_EXPERIENCE)  ){
                            if(mapEducation.isEmpty()){
                                objWrapper.sectionError = true;
                            } else if(mapEducation.get(mandatorySubSection) == null ||  mapEducation.get(mandatorySubSection).size() == 0 ){
                                
                                objWrapper.sectionError = true;
                            }
                        }
                    }
                } 
            }
            
            
        }
        try{
            upsert application;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
        }
        
        return JSON.serialize(wrapperList);
    }
    
    @AuraEnabled
    public static string callCompositeAPI(String applicationId,string renewReinstate){
        try{
            List<MUSW__Application2__c> appList =new List<MUSW__Application2__c>();
            Map<String,String> mapSubmissionToFile = new Map<String,String>();
            Set<Id>  setapplicationId =  new Set<Id> ();
            String licenseID;
            Boolean checkSuccess = false;
            setapplicationId.add(applicationId);
            String appCondition = 'Id=\''+applicationId+'\'';
            String strApp = 'Select Id, Stage__c, Form_JSON__c, Application_Type__c,  Credential_Type__c, Application_Method__c from MUSW__Application2__c where '+appCondition;
            system.debug('strApp---'+strApp);
            appList = Utilityclass_withsharing.queryRecords(strApp);
            String stringJSON = '';
            stringJSON = appList[0].Form_JSON__c;
            //Modified code for handling 25 subrequest governor limit
            LnP_JSONParser ansWrapper= Polaris_ApplyForLicenseController.getJSONWrapper(stringJSON);
            List<LnP_JSONParser.CompositeRequest> requestDetailsList = new List<LnP_JSONParser.CompositeRequest>();
            for(LnP_JSONParser.CompositeRequest req : ansWrapper.compositeRequest){
                requestDetailsList.add(req);
            }
            List<List<LnP_JSONParser.CompositeRequest>> compositeReq = Polaris_ApplyForLicenseService.partition(requestDetailsList,24);
            
            if(appList != null && appList.size()>0 && appList[0].Stage__c != -1){
                for(List<LnP_JSONParser.CompositeRequest> record: compositeReq) {    
                    Map<String,List<LnP_JSONParser.CompositeRequest>> mapList = new  Map<String,List<LnP_JSONParser.CompositeRequest>>();
                    mapList.put('compositeRequest',record);
                    string strJsonForm = JSON.serialize(mapList);
                    strJsonForm = strJsonForm.replaceAll('\\bAnswer\\b', DOL_AppConstants.ANSWER_TEXT);
                    strJsonForm = strJsonForm.replaceAll('\\bQuestion\\b', DOL_AppConstants.QUESTIONDOL);
                    strJsonForm = strJsonForm.replaceAll('\\bApplication\\b', DOL_AppConstants.APPLICATION_BG);
                    strJsonForm = strJsonForm.replaceAll('\\bMUSW_Application2\\b', DOL_AppConstants.APPLICATION2);
                    strJsonForm = strJsonForm.replaceAll('\\bMUSW_Description\\b', DOL_AppConstants.DESCRIPTION);
                    stringJSON = stringJSON.replaceAll('\\BgckApplication\\b', DOL_AppConstants.DESCRIPTION);
                    strJsonForm = strJsonForm.replaceAll('\\bContentDocumentId\\b', DOL_AppConstants.CONTENTDOCUMENTID);
                    
                    strJsonForm = strJsonForm.replaceAll('\"[^\"]*\":null',''); //basic removeal of null values
                    strJsonForm = strJsonForm.replaceAll(',{2,}', ','); //remove duplicate/multiple commas
                    strJsonForm = strJsonForm.replace('{,', '{'); //prevent opening brace from having a comma after it
                    strJsonForm = strJsonForm.replace(',}', '}'); //prevent closing brace from having a comma before it
                    strJsonForm = strJsonForm.replace('[,', '['); //prevent opening bracket from having a comma after it
                    strJsonForm = strJsonForm.replace(',]', ']');            
                    
                    HttpRequest req = new HttpRequest();
                    String url = System.Label.CompositeAPIURL;
                    req.setEndpoint(url);
                    req.setMethod(DOL_AppConstants.POST);
                    String sessionId=UserInfo.getSessionId();
                    req.setHeader(DOL_AppConstants.AUTHORIZATION, DOL_AppConstants.BEARER + sessionId);
                    req.setHeader(DOL_AppConstants.CONTENTTYPE,'application/json');
                    req.setBody(strJsonForm);
                    req.setTimeout(60000);     
                    Http http = new Http();
                    HTTPResponse res = http.send(req);
                    if(res.getStatusCode() == 200) {
                        checkSuccess = true;
                    }
                    
                }
                
                
                if(checkSuccess) {
                    appList[0].Stage__c = -1;
                    appList[0].MUSW__Status__c = DOL_AppConstants.SUBMITTED;
                    licenseID =insertLisence(setapplicationId,renewReinstate);
                    //Fetch Parcel Record data based on Logged in User
                    Id contactRecordIdData = getCommunityUserContactId();
                    Id contactAccountId;
                    System.debug('contactRecordIdData===' + contactRecordIdData + 'account Id==='+ appList[0].MUSW__Account__c + 'License Id-- ' + licenseID);
                    if(String.isNotBlank(appList[0].MUSW__Account__c)){
                        contactAccountId = appList[0].MUSW__Account__c;
                    }else{
                        contactAccountId = contactRecordIdData;
                    }
                    List<MUSW__Parcel__c> allAddressList = new List<MUSW__Parcel__c>();
                    getAllAddressesForComposite(contactAccountId, appList[0].Id, licenseID);
                    List<MUSW__Application2__c> appListOtherDetils =new List<MUSW__Application2__c>();
                    String strAppOther = 'Select Id,MUSW__Account__c,Stage__c, Application_Type__c,  Application_Method__c, Credential_Type__c, (select id,MUSW__License2__c,ContentDocumentId__c from MUSW__Submissions__r) ,(select Id,Answer_Text__c,License__c,Create_Endorsement_Record__c,Endorsement_Type__c,QuestionDOL__r.Course_Type_Question__c,QuestionDOL__r.RecordType.DeveloperName,QuestionDOL__r.RecordType.Name,QuestionDOL__r.Question_Body__c,QuestionDOL__r.Parent_Object_API_Name__c,QuestionDOL__r.Data_Type__c,QuestionDOL__r.Endorsement_Type__c,Question_Section__c,QuestionDOL__r.QuestionFieldAPI__c,QuestionDOL__r.QuestionObjectName__c from Answers1__r),(Select Id,License__c FROM Employment_History__r),(Select Id FROM Parcels__r) from MUSW__Application2__c where '+appCondition;
                    appListOtherDetils = Utilityclass_withsharing.queryRecords(strAppOther);
                    List<LnP_BackgroundSection__c> lstEduHist = new List<LnP_BackgroundSection__c>();            
                    if(appListOtherDetils[0].LnP_BackgroundSections__r != null && appListOtherDetils[0].LnP_BackgroundSections__r.size()>0){
                        for(LnP_BackgroundSection__c EduHist : appListOtherDetils[0].LnP_BackgroundSections__r){
                            EduHist.License_Bg__c = licenseID; 
                            lstEduHist.add(EduHist);
                        }
                        try{
                            if(!lstEduHist.isEmpty()){
                                update lstEduHist; 
                            }   
                        }catch(Exception ex)
                        {
                            DOL_CreateErrorLog_Exception.logApplicationError(ex);
                        }
                    }   
                    //newly added for endo
                    List<BGCK__Answer__c> lstAnswers = new List<BGCK__Answer__c>();
                    List<Endorsement__c> lstEndorsements = new List<Endorsement__c>();
                    String providerName = '';
                    List<Renewal_Application__c> RenewalObjList = [SELECT Id FROM Renewal_Application__c WHERE Id=: licenseID limit 1];
                    Renewal_Application__c RenewalObj =  new Renewal_Application__c();
                    if(!RenewalObjList.isEmpty()){
                        RenewalObj = RenewalObjList[0];
                    }
                    List<String> preApproval = new List<String>();
                    for(BGCK__Answer__c ans : appListOtherDetils[0].Answers1__r)
                    { 
                        ans.Question2__c = ans.QuestionDOL__r.Question_Body__c;
                        ans.Renewal_Reinstatement_Application__c = licenseID;  
                        if(appListOtherDetils[0].Answers1__r != null && appListOtherDetils[0].Answers1__r.size()>0 && appListOtherDetils[0].Credential_Type__c == DOL_AppConstants.NOTARY_PUBLIC){
                            if((!ans.Create_Endorsement_Record__c) && ans.QuestionDOL__r.Data_Type__c == DOL_AppConstants.PICKLIST && ans.Question_Section__c== DOL_AppConstants.ENDORSEMENT && ans.QuestionDOL__r.Parent_Object_API_Name__c== DOL_AppConstants.RENEWAL_APPLICATION )
                            {
                                providerName = ans.Answer_Text__c;
                            }
                        }
                        
                        if(appListOtherDetils[0].Answers1__r != null && appListOtherDetils[0].Answers1__r.size()>0 && appListOtherDetils[0].Credential_Type__c == DOL_AppConstants.APPRAISERCOURSE  ){
                            if(ans.QuestionDOL__r.QuestionObjectName__c == DOL_AppConstants.RENEWAL_APPLICATION)  {
                                ans.Renewal_Reinstatement_Application__c = licenseID;   
                                // map course fields here
                                if(ans.QuestionDOL__r.RecordType.DeveloperName == DOL_AppConstants.COURSE_INFORMATION){
                                    String QuestionObjFieldAPIName = ans.QuestionDOL__r.QuestionFieldAPI__c;
                                    system.debug(' in course info rec type filter');
                                    if(QuestionObjFieldAPIName == DOL_AppConstants.EMAIL){
                                        RenewalObj.Email__c = ans.Answer_Text__c;
                                    }
                                    if(QuestionObjFieldAPIName == DOL_AppConstants.PHONE){
                                        RenewalObj.Phone__c = ans.Answer_Text__c;
                                    }  
                                    if(QuestionObjFieldAPIName == DOL_AppConstants.WEBSITE){
                                        RenewalObj.Website__c = ans.Answer_Text__c;
                                    }  
                                    if(QuestionObjFieldAPIName == DOL_AppConstants.IDECC_APPROVAL_EXPIRATION){
                                        RenewalObj.IDECC_Approval_Expiration_Date__c = Date.valueOf(ans.Answer_Text__c);
                                    }
                                    if(QuestionObjFieldAPIName == DOL_AppConstants.PREAPPROVAL){
                                        
                                        if(ans.QuestionDOL__r.Question_Body__c == DOL_AppConstants.IS_PROVIDER_AN_ACCREDITED_COLLEGE && ans.Answer_Text__c == DOL_AppConstants.YES)
                                        {
                                            preApproval.add(DOL_AppConstants.COLLEGE); 
                                        }
                                        if(ans.QuestionDOL__r.Question_Body__c == DOL_AppConstants.WHEN_DOES_YOUR_IDECC_APPROVAL_EXPIRE &&  ans.Answer_Text__c != '' )
                                        {
                                            preApproval.add( DOL_AppConstants.IDECC);
                                            
                                        }
                                        String preApprovalString ='';
                                        for(String str : preApproval)
                                        {
                                            preApprovalString += str + ';' ;
                                        }
                                        // remove last additional comma from string
                                        
                                        preApprovalString = preApprovalString.subString(0,preApprovalString.length());
                                        
                                        RenewalObj.Pre_Approval__c = preApprovalString;
                                    }
                                    if(QuestionObjFieldAPIName == DOL_AppConstants.DELIVERY_METHOD){
                                        if(ans.QuestionDOL__r.Question_Body__c == DOL_AppConstants.IS_THIS_DISTANCE_ONLINE_COURSE && ans.Answer_Text__c == DOL_AppConstants.YES)
                                        {
                                            RenewalObj.Course_Renewal_Delivery_Method__c = DOL_AppConstants.DISTANCE_ONLINE;
                                        } else
                                        {
                                            RenewalObj.Course_Renewal_Delivery_Method__c = DOL_AppConstants.CLASSROOM_INSTRUCTOR;
                                        }
                                    }
                                }
                            }   
                        }
                        if(ans.Question_Section__c == DOL_AppConstants.CERTIFICATIONS) {
                            ans.Answer_Text__c = DOL_AppConstants.YES; 
                        }
                        if(ans.Create_Endorsement_Record__c && ans.QuestionDOL__r.Data_Type__c == DOL_AppConstants.YES_NO && ans.Answer_Text__c== DOL_AppConstants.YES && ans.QuestionDOL__r.Parent_Object_API_Name__c== DOL_AppConstants.RENEWAL_APPLICATION)
                        {
                            Endorsement__c endorsment = new Endorsement__c();
                            endorsment.Endorsement_Type__c = ans.Endorsement_Type__c;
                            endorsment.License_Type__c = appListOtherDetils[0].Credential_Type__c;
                            if(appListOtherDetils[0].Credential_Type__c == DOL_AppConstants.NOTARY_PUBLIC)
                            {
                                //endorsment.Electronic_Software_Provider__c = providerName;
                                endorsment.Status__c = DOL_AppConstants.ACTIVE;
                            }
                            endorsment.Date_Requested_for_Adding_Endorsement__c = system.today();
                            endorsment.Renewal_Reinstatement_Application__c = licenseID;
                            endorsment.Created_for_New_Application__c = True;
                            endorsment.License__c = liceseIDRenewal.Id;
                            lstEndorsements.add(endorsment);
                        }
                        else if(ans.Create_Endorsement_Record__c && ans.QuestionDOL__r.Data_Type__c == DOL_AppConstants.PICKLIST && ans.Answer_Text__c != '' && ans.Answer_Text__c != DOL_AppConstants.NONE && ans.QuestionDOL__r.Endorsement_Type__c!= DOL_AppConstants.NOTARY && ans.QuestionDOL__r.Parent_Object_API_Name__c== DOL_AppConstants.RENEWAL_APPLICATION )
                        {
                            Endorsement__c endorsment = new Endorsement__c();
                            endorsment.Endorsement_Type__c = ans.Answer_Text__c;
                            endorsment.License_Type__c = appListOtherDetils[0].Credential_Type__c;
                            endorsment.Date_Requested_for_Adding_Endorsement__c = system.today();
                            endorsment.Renewal_Reinstatement_Application__c = licenseID;
                            endorsment.Created_for_New_Application__c = True;
                            endorsment.License__c = liceseIDRenewal.Id;
                            lstEndorsements.add(endorsment);
                        }
                        lstAnswers.add(ans);
                    }
                    
                    try{
                        if(!lstEndorsements.isEmpty()){
                            insert lstEndorsements;
                        }
                    }catch(Exception ex)
                    {
                        DOL_CreateErrorLog_Exception.logApplicationError(ex);
                    }
                    
                    try{
                        if(!lstAnswers.isEmpty()){
                            update lstAnswers;
                        }
                    }catch(Exception ex)
                    {
                        DOL_CreateErrorLog_Exception.logApplicationError(ex);
                    }
                    if(appListOtherDetils[0].Credential_Type__c == DOL_AppConstants.NOTARY_PUBLIC && lstEndorsements.size()>0)
                    {
                        List<Electronic_Notary_Provider_Information__c> providerList = new List<Electronic_Notary_Provider_Information__c>();
                        List<Electronic_Notary_Provider_Information__c> lstproviders = [SELECT id,Description__c,Effective_Date__c,Endorsement__c FROM Electronic_Notary_Provider_Information__c where Application_BG__c =:appListOtherDetils[0].Id];
                        
                        for(Electronic_Notary_Provider_Information__c provider : lstproviders)
                        {
                            provider.Endorsement__c = lstEndorsements[0].Id;
                            providerList.add(provider);
                        }
                        try{
                            if(!providerList.isEmpty()){
                                update providerList;
                            }
                        }catch(Exception ex)
                        {
                            DOL_CreateErrorLog_Exception.logApplicationError(ex);
                        }
                    }    
                    try{
                        update RenewalObj;
                    }catch(Exception ex)
                    {
                        DOL_CreateErrorLog_Exception.logApplicationError(ex);
                    }
                    //end
                    List<MUSW__Submission__c> lstSubmissions= new List<MUSW__Submission__c>();            
                    if(appListOtherDetils[0].MUSW__Submissions__r != null && appListOtherDetils[0].MUSW__Submissions__r.size()>0){
                        for(MUSW__Submission__c submissions : appListOtherDetils[0].MUSW__Submissions__r){
                            submissions.License_Renewal__c = licenseID; 
                            
                            if(submissions!=null && submissions.ContentDocumentId__c != null ) {
                                submissions.IsSANFileUploadTrue__c = true;
                                submissions.SAN_Image_Type__c ='Renewal';
                                mapSubmissionToFile.put(submissions.ID, submissions.ContentDocumentId__c.replace(';',''));
                            }
                            lstSubmissions.add(submissions);
                            
                        }
                        try{
                            update lstSubmissions; 
                        }catch(Exception ex){
                            DOL_CreateErrorLog_Exception.logApplicationError(ex);
                        }
                    }
                    
                    try{
                        update appList[0];
                    }catch(Exception ex){
                        DOL_CreateErrorLog_Exception.logApplicationError(ex);
                    }
                    
                }   
            }
            //  Calling method to  store 3rd party
            if(!mapSubmissionToFile.isEmpty()){
                Polaris_RenewLicenseController.updateLinkedEntityId(mapSubmissionToFile);
            }
            return licenseID;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            return null;
        }
    }
    
    private static ID insertLisence(Set<Id> appId,String renewReinstate){
        try{
            List<Renewal_Application__c> lstLisence = new List<Renewal_Application__c>();
            List<MUSW__License2__c> liceList = new List<MUSW__License2__c>();
            Id businessRT = SObjectType.Renewal_Application__c.getRecordTypeInfosByDeveloperName().get(DOL_AppConstants.BUSINESS).getRecordTypeId();
            Id individualRT = SObjectType.Renewal_Application__c.getRecordTypeInfosByDeveloperName().get(DOL_AppConstants.INDIVIDUAL).getRecordTypeId();
            // For Course Renewal Applications
            Id courseRT = SObjectType.Renewal_Application__c.getRecordTypeInfosBYDeveloperName().get(DOL_AppConstants.COURSE).getRecordTypeId();
            List<MUSW__Application2__c> applicationList = [SELECT Id,isRenewal__c,Physical_Address_Modified_On_Renewal__c,Application_Type__c,Application_Method__c,Credential_Type__c,MUSW__Account__c,MUSW__Applicant__c,MUSW__Applicant__r.FirstName,MUSW__Applicant__r.MiddleName,MUSW__Applicant__r.LastName, (select Id,Answer_Text__c,License__c,Create_Endorsement_Record__c,Endorsement_Type__c,QuestionDOL__r.Data_Type__c,QuestionDOL__r.Question_Body__c,QuestionDOL__r.QuestionFieldAPI__c,QuestionDOL__r.Endorsement_Type__c,QuestionDOL__r.Course_Type_Question__c,QuestionDOL__r.RecordType.DeveloperName,QuestionDOL__r.RecordType.Name,Question_Section__c,QuestionDOL__r.QuestionObjectName__c,QuestionDOL__r.Parent_Object_API_Name__c from Answers1__r) FROM MUSW__Application2__c where id IN: appId];
            liceseIDRenewal = [Select Id,Application__c,Bond_Number__c,recordTypeId, Surety_Bond_Company_Name__c, Policy_Amount__c, Effective_Date_of_Bond__c, Expiration_Date_of_Bond__c From MUSW__License2__c where Application__c IN:appId];
            for(MUSW__Application2__c application : applicationList){
                Renewal_Application__c  mstLicense =  new Renewal_Application__c();
                mstLicense.Applicant__c = application.MUSW__Applicant__c;
                mstLicense.Application_Type__c = application.Application_Type__c;
                mstLicense.Credential_Type__c = application.Credential_Type__c;
                mstLicense.Physical_Address_Modified__c = application.Physical_Address_Modified_On_Renewal__c;
                mstLicense.Credential__c = application.Credential_Type__c;
                if(application.MUSW__Account__c!=null)
                {
                    if(application.MUSW__Account__r.Course_Provider__c){
                        mstLicense.RecordTypeId = courseRT;
                    }else{
                        mstLicense.RecordTypeId = businessRT; 
                    }
                    
                }
                else
                {
                    mstLicense.RecordTypeId = individualRT;
                }
                
                
                
                mstLicense.Application__c = application.id;
                mstLicense.Renewal_Status__c = DOL_AppConstants.GENERATE_FEE;
                mstLicense.License__c = liceseIDRenewal.Id;
                mstLicense.Renewal_Reinstatement_Type__c = renewReinstate;
                //Added for pol
                Map<String, Schema.SObjectField> fields = Schema.getGlobalDescribe().get('Renewal_Application__c').getDescribe().SObjectType.getDescribe().fields.getMap();
                Map<String,String>  mapValueToStr =  new Map<String,String>();
                
                String printableName = '';
                String firstName = '' ;
                String MiddleName = '';
                String LastName = '';
                String doingBusinessAs = '';
                
                //--------Added by Babita---------------
                if(application.Answers1__r != null && application.Answers1__r.size()>0) {
                    for(BGCK__Answer__c ans : application.Answers1__r)
                    {  
                        //updated field name from 'QuestionObjectName__c' to 'Parent_Object_API_Name__c'
                        system.debug('anshey'+ans);
                        if( ans.QuestionDOL__r != null) {
                            if(ans.Answer_Text__c != null && ans.QuestionDOL__r.QuestionFieldAPI__c != null 
                               && ans.QuestionDOL__r.Parent_Object_API_Name__c == 'Renewal_Application__c' && ans.QuestionDOL__r.RecordType.DeveloperName == 'Background_Questions')
                            {   
                                mapValueToStr.put(ans.QuestionDOL__r.QuestionFieldAPI__c,ans.Answer_Text__c);
                            }
                            
                            if(ans.QuestionDOL__r.Question_Body__c == DOL_AppConstants.HOW_WILL_YOUR_NAME_APPEAR && firstName == '' ){
                                firstName  = ans.Answer_Text__c +' ';
                            }
                            if(ans.QuestionDOL__r.Question_Body__c == DOL_AppConstants.FIRST_NAME_INITIAL && firstName == '' &&  ans.Answer_Text__c  != null &&  ans.Answer_Text__c  !='' ){
                                firstName  = ans.Answer_Text__c +' ';
                            }
                            
                            if(ans.QuestionDOL__r.Question_Body__c == DOL_AppConstants.DOING_BUSINESS_AS && doingBusinessAs == '' ){
                                doingBusinessAs  = ans.Answer_Text__c +' ';
                            }
                            
                            if(ans.QuestionDOL__r.Question_Body__c== DOL_AppConstants.MIDDLE_NAME_INITIAL && MiddleName == '' ){
                                MiddleName = ans.Answer_Text__c +' ';
                            }
                            
                            if(ans.QuestionDOL__r.Question_Body__c== DOL_AppConstants.LASTNAME && LastName == '' ){
                                LastName = ans.Answer_Text__c;
                            }
                            
                            if(ans.QuestionDOL__r.Question_Body__c == DOL_AppConstants.HOW_DO_YOU_WANT_YOUR_NAME_DISPLAYED_ON_YOUR_LICENSE && ans.Answer_Text__c == DOL_AppConstants.USE_MY_FULL_LEGAL_NAME && firstName == '' ){
                                firstName  = application.MUSW__Applicant__r.FirstName;
                            }
                            if(ans.QuestionDOL__r.Question_Body__c == DOL_AppConstants.HOW_DO_YOU_WANT_YOUR_NAME_DISPLAYED_ON_YOUR_LICENSE  && ans.Answer_Text__c == DOL_AppConstants.USE_MY_FULL_LEGAL_NAME && MiddleName == '' ){
                                MiddleName  = application.MUSW__Applicant__r.MiddleName;
                            }
                            if(ans.QuestionDOL__r.Question_Body__c == DOL_AppConstants.HOW_DO_YOU_WANT_YOUR_NAME_DISPLAYED_ON_YOUR_LICENSE  && ans.Answer_Text__c == DOL_AppConstants.USE_MY_FULL_LEGAL_NAME && LastName == '' ){
                                LastName  = application.MUSW__Applicant__r.LastName;
                            }
                        }
                        
                    }
                    if(!mapValueToStr.isEmpty()) {
                        for(String fieldName : mapValueToStr.keySet()){     
                            if(mapValueToStr.get(fieldName) != null) {
                                Schema.DisplayType targetType = fields.get(fieldName).getDescribe().getType();
                                string strFieldName = String.valueOf(targetType);
                                if(strFieldName == DOL_AppConstants.TEXTAREA || strFieldName == DOL_AppConstants.MULTIPICKLIST || strFieldName == DOL_AppConstants.TEXT  ) {
                                    mstLicense.put(fieldName,String.valueOf(mapValueToStr.get(fieldName)));
                                } else if(strFieldName == DOL_AppConstants.DOUBLE_DATA) {
                                    mstLicense.put(fieldName,Double.valueOf(mapValueToStr.get(fieldName)));
                                }    
                            }
                            
                        }
                    }
                    for(BGCK__Answer__c ans : application.Answers1__r){                    
                        if(ans.QuestionDOL__r.RecordType.DeveloperName == DOL_AppConstants.FINANCIAL_GUARANTEE){
                            
                            String quesBody = ans.QuestionDOL__r.Question_Body__c;
                            String answerText = ans.Answer_Text__c;
                            String stringToDate = '';
                            if(quesBody == DOL_AppConstants.BOND_POLICY_NUMBER){
                                liceseIDRenewal.Bond_Number__c = String.valueOf(answerText);
                            }
                            
                            if(quesBody == DOL_AppConstants.BOND_INSURANCE_COMPANY){
                                liceseIDRenewal.Surety_Bond_Company_Name__c = String.valueOf(answerText);
                            }
                            
                            if(quesBody == DOL_AppConstants.BOND_POLICY_AMOUNT){
                                liceseIDRenewal.Policy_Amount__c = String.valueOf(answerText);
                            }
                            
                            if(quesBody == DOL_AppConstants.EFFECTIVE_DATE){
                                stringToDate = String.valueOf(answerText);
                                Integer year = Integer.valueOf(stringToDate.subString(0, 4));
                                Integer month = Integer.valueOf(stringToDate.substring(5, 7));
                                Integer day = Integer.valueOf(stringToDate.subString(8));
                                Date d = Date.newInstance(year, month, day);
                                
                                liceseIDRenewal.Effective_Date_of_Bond__c = d;
                            }
                            
                            if(quesBody == DOL_AppConstants.EXPIRATION_DATE){
                                stringToDate = String.valueOf(answerText);
                                Integer year = Integer.valueOf(stringToDate.subString(0, 4));
                                Integer month = Integer.valueOf(stringToDate.substring(5, 7));
                                Integer day = Integer.valueOf(stringToDate.subString(8));
                                Date d = Date.newInstance(year, month, day);
                                
                                liceseIDRenewal.Expiration_Date_of_Bond__c = d;
                            }
                        }            
                        
                        
                        
                    }
                }
                //---------Completed by Babita
                Id individualLicRT = SObjectType.MUSW__License2__c.getRecordTypeInfosByDeveloperName().get(DOL_AppConstants.DEFAULT_LICENSE_RECORDTYPE).getRecordTypeId();
                Id BusinessLicRT =  SObjectType.MUSW__License2__c.getRecordTypeInfosByDeveloperName().get(DOL_AppConstants.BUSINESS).getRecordTypeId();
                
                if(liceseIDRenewal.RecordTypeId == individualLicRT){
                    liceseIDRenewal.License_Printable_Name__c = firstName+' '+ MiddleName+' '+ LastName;
                    liceseIDRenewal.Print_First_Name__c = firstName;
                    liceseIDRenewal.Print_Middle_Name__c = MiddleName;
                    liceseIDRenewal.Print_Last_Name__c = LastName;
                }
                if(liceseIDRenewal.RecordTypeId == BusinessLicRT){
                    liceseIDRenewal.License_Printable_Name__c = application.MUSW__Account__r.Name+' '+ doingBusinessAs;
                } 
                
                liceList.add(liceseIDRenewal);
                lstLisence.add(mstLicense);
            }
            
            
            if(!lstLisence.isEmpty()){
                try{
                    insert lstLisence;
                }catch(Exception ex){
                    DOL_CreateErrorLog_Exception.logApplicationError(ex);
                }
                
                try{
                    update liceList;
                }catch(Exception ex){
                    DOL_CreateErrorLog_Exception.logApplicationError(ex);
                }
            }
            
            List<Endorsement__c> lstEndo = [SELECT id,Date_Requested_for_Adding_Endorsement__c,Endorsement_Type__c,Renewal_Reinstatement_Application__c,License__c,Status__c FROM Endorsement__c where  License__c =:liceseIDRenewal.Id];
            for(Endorsement__c endo : lstEndo)
            {
                if(endo.Status__c == DOL_AppConstants.RENEW){
                    endo.Renewal_Reinstatement_Application__c = lstLisence[0].Id;
                    if(endo.Endorsement_Type__c== DOL_AppConstants.ELECTRONIC_NOTARY)
                    {
                        endo.Status__c = DOL_AppConstants.ACTIVE;
                    }
                    else
                    {
                        endo.Status__c = DOL_AppConstants.IN_REVIEW;
                    }
                    
                }
                
            }
            try{
                update lstEndo;
            }catch(Exception ex)
            {
                DOL_CreateErrorLog_Exception.logApplicationError(ex);
            }
            if(!applicationList.isEmpty())
            {
                applicationList[0].isRenewal__c = false;
                try{
                    update applicationList;
                }catch(Exception ex)
                {
                    DOL_CreateErrorLog_Exception.logApplicationError(ex);
                }
            }
            return lstLisence[0].Id;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            return null;
        }
        
    }
    @AuraEnabled
    public static String fetchBoardLabels(String customLabelAPI, String board){
        try{
            Map<String, String> labelMap = new Map<String, String>();
            labelMap = LnP_AllBoardsLabels.fetchBoardLabel(board);        
            String var = labelMap.get(customLabelAPI);
            return var;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            return null;
        }
    }
    
    @AuraEnabled
    public static Map<Id, Contact> UserInfo(){
        try{
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
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            return null;
        }
    }
    
    //Fetch all the addresses
    public static Map<String, List<MUSW__Parcel__c>> getAddresses (Id contactAccountId, Id appId){
        try{
            Map<String, List<MUSW__Parcel__c>> mapAddress  =  new Map<String,List<MUSW__Parcel__c>>();
            if(String.isNotBlank(contactAccountId)){
                List<MUSW__Parcel__c> lstAddress  = [Select Id, Address_Type__c, is_Physical_and_Mailing_Address_Same__c, MUSW__Street2__c, 
                                                     MUSW__Unit__c, MUSW__City__c,MUSW__State__c, Canadian_provinces__c, RecordType.Name,
                                                     County__c, Country__c,MUSW__Post_Zip_Code__c,Application_BG__c, MUSW__Primary_Contact__c,
                                                     Primary_Account__c,LastModifiedDate from MUSW__Parcel__c 
                                                     where (MUSW__Primary_Contact__c!=null AND MUSW__Primary_Contact__c = :contactAccountId)
                                                     OR (Primary_Account__c!=null AND Primary_Account__c = :contactAccountId AND Application_BG__c =:appId)
                                                     order by LastModifiedDate desc];
                System.debug('lstAddress===' + lstAddress);
                if(!lstAddress.isEmpty()){
                    for(MUSW__Parcel__c parcelAddress : lstAddress) {
                        if(mapAddress.containsKey(parcelAddress.Address_Type__c)) {
                            mapAddress.get(parcelAddress.Address_Type__c).add(parcelAddress);
                        } else {
                            mapAddress.put(parcelAddress.Address_Type__c, new List<MUSW__Parcel__c>{parcelAddress});
                        }
                    }
                }
                System.debug('mapAddress from method===' + mapAddress);
            }
            return  mapAddress ;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            return null;
        }
    }
    
    @Future
    public static void getAllAddressesForComposite (Id contactAccountId, Id appId, Id licenseId){
        List<MUSW__Parcel__c> allAddressList = new List<MUSW__Parcel__c>();
        Set<Id> parcelIdSet = new Set<Id>();
        if(String.isNotBlank(contactAccountId)){
            for(MUSW__Parcel__c allAddressRecords : [Select Id, Address_Type__c, is_Physical_and_Mailing_Address_Same__c, MUSW__Street2__c, 
                                                     MUSW__Unit__c, MUSW__City__c,MUSW__State__c, Canadian_provinces__c, RecordType.Name,
                                                     County__c, Country__c, MUSW__Post_Zip_Code__c,Application_BG__c, MUSW__Primary_Contact__c,
                                                     Primary_Account__c,LastModifiedDate from MUSW__Parcel__c 
                                                     where (MUSW__Primary_Contact__c!=null AND MUSW__Primary_Contact__c = :contactAccountId)
                                                     OR (Primary_Account__c!=null AND Primary_Account__c = :contactAccountId AND Application_BG__c =:appId)
                                                     order by LastModifiedDate desc]){
                                                         allAddressList.add(allAddressRecords);
                                                         parcelIdSet.add(allAddressRecords.Id);
                                                     }
        }
        List<MUSW__Parcel__c> lstParcels = new List<MUSW__Parcel__c>();
        List<MUSW__License_Parcel__c> licenseParcelList = new List <MUSW__License_Parcel__c>();
        if(!allAddressList.isEmpty()){
            for(MUSW__License_Parcel__c licenseParcel : [Select Id, Renewal_Reinstatement_Application__c, MUSW__Parcel__r.Id From MUSW__License_Parcel__c 
                                                         Where MUSW__Parcel__r.Id IN :parcelIdSet]){
                                                             licenseParcel.Renewal_Reinstatement_Application__c = licenseId;
                                                             licenseParcelList.add(licenseParcel);
                                                         }
            System.debug('licenseParcelList==='+ licenseParcelList);
            if(!licenseParcelList.isEmpty()){
                try{
                    update licenseParcelList; 
                }
                catch(DmlException e){
                    System.debug('Error while updating---' + e.getMessage());
                }
                System.debug('licenseParcelList===' + licenseParcelList);   
            }
        }          
        System.debug('allAddressList===' + allAddressList);
        //  return  allAddressList ;
    }
    //Fetch BackgroundInformation
    public static Map<String,List<LnP_BackgroundSection__c>> getBackgroundInformation (Set<Id> appId) {
        try{
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
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            return null;
        }
    }
    public static String getFormattedValue(String str) {
        try{
            return str != null ? str.replace('\r\n', ' ').replace('\n', ' ').escapeHtml4() : str;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            return null;
        }
    }
    
    @AuraEnabled
    public static Boolean getTotalBalance(Id licId){
        try{
            Boolean noFees;
            List<Renewal_Application__c> licList = [select Id,Total_Balance__c from Renewal_Application__c where Id=:licId];
            if(!licList.isEmpty() && licList[0].Total_Balance__c == 0){
                noFees = true;
            }else{
                noFees = false;
            }
            
            if(noFees){
                licList[0].No_Fee_Required__c = noFees;
                try{
                    update licList[0];
                }catch(Exception ex)
                {
                    DOL_CreateErrorLog_Exception.logApplicationError(ex);
                }
            }
            
            return noFees;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            return null;
        }
    }
    
    @AuraEnabled
    public static boolean updateAddressModified(Id appId){
        try{
            Boolean updatedFlag = false;
            MUSW__Application2__c app = new MUSW__Application2__c(Id = appId);
            app.Physical_Address_Modified_On_Renewal__c = true;
            try{
                update app;
                updatedFlag = true;
            }catch(Exception e){
                updatedFlag = false;
                DOL_CreateErrorLog_Exception.logApplicationError(e,'Polaris_RenewLicenseController','updateAddressModified');
            }
            return updatedFlag;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            return null;
        }
    }
    
    @Future
    private static void updateLinkedEntityId (Map<String,String> mapSubmissionToFile) {
        try{
            List<String> abc  = new List<String>();
            List<ContentDocumentLink> lstFiles  = new List<ContentDocumentLink>();
            if(!mapSubmissionToFile.isEmpty()) {
                abc.addAll(mapSubmissionToFile.values());
            }
            List<ContentDocumentLink> lstContent = new List<ContentDocumentLink>();
            for(ContentDocumentLink cont : [select  ContentDocumentId,Id,LinkedEntityId FROM ContentDocumentLink where  LinkedEntityId =:UserInfo.getUserId()]){
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
                try
                {
                    upsert lstFiles;
                }catch(Exception ex)
                {
                    DOL_CreateErrorLog_Exception.logApplicationError(ex);
                }
            } 
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            
        }
    }
    
    private static Id getCommunityUserContactId(){
        try{
            Id contactId;
            for(User userRecord: [Select Id, username, contactId from User where Id = :UserInfo.getUserId() LIMIT 1]){
                contactId = userRecord.contactId;
            }
            System.debug('contactId===' + contactId);
            return contactId;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            return null;
        }
        
    }
    
    
}