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
        List<String> lstOfSections = sections.split(',');
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
        //mapSObject used to store application Id and List of License application record
      /*  Map<Id, List<SObject>> mapSObject = new Map<Id, List<SObject>>();
        for (MUSW__Application2__c app : lstApps) 
        {
            mapSObject.put(app.Id, app.License_Application__r);
        }
        
        List<LnP_Licence_Application__c> lstLicenseApplication =new List<LnP_Licence_Application__c>();
        for (List <sObject> lstApplicationLicense : mapSObject.values())
        {               
            lstLicenseApplication =lstApplicationLicense ;            
        }*/
        
        
        /*if(lstApps.size() >0 && !lstLicenseApplication.isEmpty() && lstApps[0].Stage__c != null  )
        {
            currentTab = Integer.valueOf(lstApps[0].Stage__c);
            ansWrapper = getJSONWrapper(lstLicenseApplication);
        }*/
        
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
            if(section =='Personal Information'  )
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
            else if(section =='Business Information' &&  !lstApps.isEmpty())
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
    
   /* private static LnP_JSONParser getJSONWrapper(List<LnP_Licence_Application__c> lstLicenseApplication){
        system.debug('lstLicenseApplication'+lstLicenseApplication);
        String strJsonForm = '';
        for(LnP_Licence_Application__c app : lstLicenseApplication){
            strJsonForm = strJsonForm + app.LnP_Form_JSON__c;
        }        
        Map<String,Object> mapfield = (Map<String,Object>)JSON.deserializeUntyped(strJsonForm);        
        strJsonForm = JSON.serialize(mapfield);        
        LnP_JSONParser parser = LnP_JSONParser.parse(strJsonForm);
        System.debug('Map of JSON--->'+parser);
        return parser;
    }*/
    
    private static LnP_JSONParser getJSONWrapper(String formJson){
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
            if(objWrapper.sectionName.contains('Questions')){
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
        Boolean submissionsIncomplete = true;
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
        lstUserInfoData = new List<User>();
        List<User> lstuserData  = Polaris_ApplyForLicenseService.fetchUserDetails();
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
                    body.Application = appId;
                    requestDetails.body = body;
                    requestDetailsList.add(requestDetails);
                    
                }
                if(fieldMap.renderedOnUi!=null && fieldMap.renderedOnUi == true && fieldMap.questionSectionClass.contains('Questions')){
                  count++;  
                }
                
                //system.debug('fieldMap.renderedOnUi '+fieldMap.renderedOnUi);
                if( fieldMap.questionSectionClass.contains('Questions') && fieldMap.renderedOnUi!=null && fieldMap.renderedOnUi==true && fieldMap.value != null && fieldMap.value !='' ){
                    questionsAnswered++;
                }
            }
            //validationForQuestions:
            system.debug('Count '+count);
            system.debug('questionsAnswered '+questionsAnswered);
            if(questionsAnswered != count ){
                questionsIncomplete = true;
            }
        }
        if(submissionFields.size()>0){
            
            Set<String> docId = new Set<String>();
            Map<Id,Id> docLinkMap = new Map<Id,Id>();
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
            Integer filesSubmitted = 0;
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
                   // filesSubmitted++;
                }
                requestDetailSub.body = bodySub;
                requestDetailsList.add(requestDetailSub);
               /* if(fieldMap.isMandatorySub == true){
                 count++;
                }*/
            }
            submissionsIncomplete = false;
            system.debug('filesSubmitted123'+filesSubmitted);
            system.debug('filesSubmittedcount'+count);
            //validationForSubmissions:
           /* if(filesSubmitted == count){//change logic to not equals to count, where count is the number of complete submissions
                submissionsIncomplete = false;
            }*/
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
        String strApp = 'Select Id,MUSW__Account__c,Stage__c, Application_Type__c,  Application_Method__c, Credential_Type__c,(Select Id, Name from Education_History__r ) from MUSW__Application2__c where '+appCondition;
        appList = Utilityclass_withsharing.queryRecords(strApp);
        List<Education_History__c> lstEducations = new List<Education_History__c>();
        
        MUSW__Application2__c application = new MUSW__Application2__c();
        if(appList.size()>0){
            /*List<LnP_Licence_Application__c> listAppDelete = new List<LnP_Licence_Application__c>();
            if(appList[0].License_Application__r != null && appList[0].License_Application__r.size()>0){
                listAppDelete.addAll(appList[0].License_Application__r);
            }*/
            
            if(appList[0].Education_History__r != null && appList[0].Education_History__r.size() >0){
               // lstEducations = 
                lstEducations.addAll(appList[0].Education_History__r);
            }
           // delete listAppDelete;
            application = appList[0];
            application.id = appList[0].id;
            application.Stage__c = Integer.valueOf(tabNumber);
           // application.MUSW_Applicant__c = getContactId;
            
        }
        else{
            application.MUSW__Applicant__c = getContactId;
            application.Stage__c = Integer.valueOf(tabNumber);
        }
       
        appId = application.Id; 
        Integer count = 1;
      
        while(count != 20){
           /* LnP_Licence_Application__c applicationChild = new LnP_Licence_Application__c();
            applicationChild.Contact__c = getContactId;
            applicationChild.Sequence__c = count;
            if(accountId != ''){
                applicationChild.Account__c = accountId;
            }
            
            applicationChild.Licence_Application_Bg__c = appId;*/
            if(jsonString.length() <= 131072){
              /*  applicationChild.LnP_Form_JSON__c = jsonString;
                listApp.add(applicationChild);*/
                application.Form_JSON__c = jsonString;
                break;
            }
            else{
                application.Form_JSON__c = jsonString.subString(0,32768);
                jsonString = jsonString.subString(32768,jsonString.length());
            }
           // listApp.add(applicationChild);
            count++;
        }  
       // insert listApp;
      //  string recID = listApp[0].ID;
     //   system.debug('listApp'+ recID);
        
        //Subsection  error
        List<String> lstMandatorySubsection;
        for(LnP_ApplyForLicenseWrapper objWrapper : wrapperList){
           objWrapper.sectionError = false;
           lstMandatorySubsection= new List<String> ();
            if(objWrapper.sectionName.contains('Questions') && questionsIncomplete==true){
                objWrapper.sectionError = true;
            }
            if(objWrapper.sectionName.contains('Attachments') && submissionsIncomplete==true){
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
         upsert application;
        system.debug('wrapperList123'+wrapperList);
        return JSON.serialize(wrapperList);
    }
    @AuraEnabled
    public static string callCompositeAPI(String applicationId){
        List<MUSW__Application2__c> appList =new List<MUSW__Application2__c>();
        Set<Id>  setapplicationId =  new Set<Id> ();
        String licenseID;
        // string applicationId2 = string.valueOf(applicationId).substring(0, 15);
        setapplicationId.add(applicationId);
        String appCondition = 'Id=\''+applicationId+'\'';
       // String strApp = 'Select Id, Stage__c, Application_Type__c,  Credential_Type__c, Application_Method__c, (Select Id, Sequence__c, LnP_Form_JSON__c from License_Application__r ORDER BY Sequence__c ASC) from MUSW__Application2__c where '+appCondition;
         String strApp = 'Select Id, Stage__c, Form_JSON__c, Application_Type__c,  Credential_Type__c, Application_Method__c from MUSW__Application2__c where '+appCondition;
        system.debug('StrApp Query--->'+strApp);
        appList = Utilityclass_withsharing.queryRecords(strApp);
        system.debug('Applist In AController--->'+appList);
        String stringJSON = '';
        stringJSON = appList[0].Form_JSON__c;
       // System.debug('appList '+appList);
        System.debug('appList[0].Stage__c '+appList[0].Stage__c);
        if(appList != null && appList.size()>0 && appList[0].Stage__c != -1){
            /*if(appList[0].License_Application__r != null && appList[0].License_Application__r.size()>0){
                for(LnP_Licence_Application__c app : appList[0].License_Application__r){
                    stringJSON = stringJSON + app.LnP_Form_JSON__c;
                }
            }*/
            system.debug('stringJSONfianl'+stringJSON);
            stringJSON = stringJSON.replaceAll('\\bAnswer\\b', 'Answer_Text__c');
            stringJSON = stringJSON.replaceAll('\\bQuestion\\b', 'Question__c');
            stringJSON = stringJSON.replaceAll('\\bApplication\\b', 'Application_BG__c');
            stringJSON = stringJSON.replaceAll('\\bMUSW_Application2\\b', 'MUSW__Application2__c');
            stringJSON = stringJSON.replaceAll('\\bMUSW_Description\\b', 'MUSW__Description__c');
           // stringJSON = stringJSON.replaceAll('\\BgckApplication\\b', 'MUSW__Description__c');
            stringJSON = stringJSON.replaceAll('\\bContentDocumentId\\b', 'ContentDocumentId__c');
           // stringJSON = stringJSON.replaceAll('\\questionsBody\\b', 'Question_Body__c');
            
            system.debug('stringJSON '+stringJSON);
            //stringJSON.replaceAll('Answer', 'Answer__c');
            system.debug('String sessionId=UserInfo.getSessionId();'+UserInfo.getSessionId());
            HttpRequest req = new HttpRequest();
            String url = System.Label.CompositeAPIURL;
            req.setEndpoint(url);
            req.setMethod('POST');
            String sessionId=UserInfo.getSessionId();
            req.setHeader('Authorization', 'Bearer '+ sessionId);
            req.setHeader('Content-Type','application/json');
            req.setBody(stringJSON);
            Http http = new Http();
            HTTPResponse res = http.send(req);
            System.debug('ResponseBody'+res.getBody());
            System.debug('Response ' + res.getStatusCode());
            
         if(res.getStatusCode() == 200 ) {
             appList[0].Stage__c = -1;
            appList[0].MUSW__Status__c = 'Under Review';
            licenseID =insertLisence(setapplicationId);
            //Setup  for the populating the details
            List<MUSW__Application2__c> appListOtherDetils =new List<MUSW__Application2__c>();
           // String strAppOther = 'Select Id, Stage__c, Application_Type__c,  Board__c, License_Type__c,(select id,License__c from MUSW_Submissions__r) ,(select Id,License__c from Answers__r),(Select Id,License__c FROM Employment_History__r),(Select Id,License__c FROM Education_History__r),(Select Id,License__c FROM LnP_Parcels__r) from MUSW_Application2__c where '+appCondition;
            String strAppOther = 'Select Id,MUSW__Account__c,Stage__c, Application_Type__c,  Application_Method__c, Credential_Type__c, (select id,MUSW__License2__c from MUSW__Submissions__r) ,(select Id,License__c from Answers1__r),(Select Id,License__c FROM Employment_History__r),(Select Id,License__c FROM LnP_Parcels__r) from MUSW__Application2__c where '+appCondition;
            system.debug('StrApp Query--->'+strAppOther);
            appListOtherDetils = Utilityclass_withsharing.queryRecords(strAppOther);
            
            List<LnP_Parcel__c> lstParcels = new List<LnP_Parcel__c>();            
            if(appListOtherDetils[0].LnP_Parcels__r != null && appListOtherDetils[0].LnP_Parcels__r.size()>0){
                for(LnP_Parcel__c parcel : appListOtherDetils[0].LnP_Parcels__r){
                    parcel.License__c = licenseID; 
                    lstParcels.add(parcel);
                }
                update lstParcels;                
            }
            List<Education_History__c> lstEduHist = new List<Education_History__c>();            
            if(appListOtherDetils[0].Education_History__r != null && appListOtherDetils[0].Education_History__r.size()>0){
                for(Education_History__c EduHist : appListOtherDetils[0].Education_History__r){
                    EduHist.License__c = licenseID; 
                    lstEduHist.add(EduHist);
                }
                update lstEduHist;                
            }   
            List<Employment_History__c> lstEmpHist = new List<Employment_History__c>();            
            if(appListOtherDetils[0].Employment_History__r != null && appListOtherDetils[0].Employment_History__r.size()>0){
                for(Employment_History__c EmpHist : appListOtherDetils[0].Employment_History__r){
                    EmpHist.License__c = licenseID; 
                    lstEmpHist.add(EmpHist);
                }
                update lstEmpHist;                
            }
           List<BGCK__Answer__c> lstAnswers = new List<BGCK__Answer__c>();  
            system.debug('lstAnswers '+lstAnswers);
            if(appListOtherDetils[0].Answers1__r != null && appListOtherDetils[0].Answers1__r.size()>0){
                for(BGCK__Answer__c ans : appListOtherDetils[0].Answers1__r){
                    ans.License__c = licenseID; 
                    lstAnswers.add(ans);
                }
                update lstAnswers;                
            }
            List<MUSW__Submission__c> lstSubmissions= new List<MUSW__Submission__c>();            
            if(appListOtherDetils[0].MUSW__Submissions__r != null && appListOtherDetils[0].MUSW__Submissions__r.size()>0){
                for(MUSW__Submission__c submissions : appListOtherDetils[0].MUSW__Submissions__r){
                    submissions.MUSW__License2__c = licenseID; 
                    lstSubmissions.add(submissions);
                }
                update lstSubmissions;                
            }
            
            
            update appList[0];
            
        }   
      }
            
        return licenseID;
    }
    private static ID insertLisence(Set<Id> appId){
        List<MUSW__License2__c> lstLisence = new List<MUSW__License2__c>();
        Id businessRT = SObjectType.MUSW__License2__c.getRecordTypeInfosByDeveloperName().get('Business').getRecordTypeId();
        Id individualRT = SObjectType.MUSW__License2__c.getRecordTypeInfosByDeveloperName().get('Universal_Default_License_Record_Type').getRecordTypeId();
       // List<MUSW_Application2__c> applicationList = [SELECT Id,Application_Type__c,Board__c,License_Type__c,MUSW__Account__c,MUSW__Applicant__c FROM MUSW__Application2__c where id IN: appId];
       
        List<MUSW__Application2__c> applicationList = [Select Id,MUSW__Account__c,Stage__c, Application_Type__c, MUSW__Applicant__c, Application_Method__c, Credential_Type__c from MUSW__Application2__c where id IN: appId];
        for(MUSW__Application2__c application : applicationList){
            MUSW__License2__c  mstLicense =  new MUSW__License2__c();
            mstLicense.MUSW__Applicant__c = application.MUSW__Applicant__c;
            mstLicense.Application_Type__c = application.Application_Type__c;
            mstLicense.Credential_Type__c = application.Credential_Type__c;
            mstLicense.Credential__c = application.Credential_Type__c;
            mstLicense.Application_Method__c = application.Application_Method__c;
			if(application.MUSW__Account__c!=null)
            {
                mstLicense.RecordTypeId = businessRT;
            }
            else
            {
                mstLicense.RecordTypeId = individualRT;
            }
            mstLicense.Application__c = application.id;
           // mstLicense.MUSW__Applicant__c = application.MUSW__Applicant__c;
          //  mstLicense.MUSW__Primary_Licensee__c = application.MUSW__Applicant__c.ContactId;
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
    
    //Fetch all the addresses
    public static Map<String, List<LnP_Parcel__c>> getAddresses (Set<Id> appId){
        Map<String, List<LnP_Parcel__c>> mapAddress  =  new Map<String,List<LnP_Parcel__c>>();
        List<LnP_Parcel__c> lstAddress  = [SELECT Id, Address_Type__c, Application_BG__c,Application__c, City__c, Country__c, State_Province__c, Street__c, Zip_Postal_Code__c 
                                           FROM LnP_Parcel__c WHERE Application_BG__c IN :appId];
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