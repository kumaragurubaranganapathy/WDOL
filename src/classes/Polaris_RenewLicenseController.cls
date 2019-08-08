public class Polaris_RenewLicenseController {
    public static Contact currentContact {get;set;}
    public static String liceseIDRenewal {get;set;}
    public static List<MUSW__Application2__c> lstApps {get;set;}
    public static String sections {get;set;}
    public static Map<String,String> mapMandatorySubsection {get;set;}
    public static List<Application_Field__c> lstApplicationFields {get;set;}
    public static List<Question__c> lstQuestions {get;set;}
    public static List<User> lstUserInfoData {get;set;}
    public static List<MUSW__Master_Submission_List__c> lstMasterSubmission {get;set;}
    public static Map<String,String> mapSubsectionIcon {get;set;}
    
    @AuraEnabled(cacheable = true)
    public static string fetchRenewalData( String appId, String renewReinstate, String board, String licenseType, String applicationType, String flowType, String licID)
    {
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
        //mapSObject used to store application Id and List of License application record
        /*Map<Id, List<SObject>> mapSObject = new Map<Id, List<SObject>>();
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
            mapLabel.orderBy = masterSubmissionRecord.Order_No__c;
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
                labelToFields.questionSection ='null';
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
                    if(req.body!=null && req.body.Question == Ques.Id && req.body.Answer != null)
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
            else if(section == 'Course Information' ){
                licenseWrapper.personalInfoObjectName = 'Account';
                licenseWrapper.accountId = lstApps[0].MUSW__Account__c;
                licenseWrapper.fieldJson = jsonApplicationFields;
            } //end
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
    
    /*private static LnP_JSONParser getJSONWrapper(List<LnP_Licence_Application__c> lstLicenseApplication){
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
            system.debug('wrapperlist123444'+wrapperList);
            if(objWrapper.sectionName.contains('License Information')||objWrapper.sectionName.contains('Questions') || objWrapper.sectionName.contains('Endorsement')){
                system.debug('Inside section=Question');             
                for(LnP_ApplyForLicenseWrapper.MapLabelToFields abc: objWrapper.labelFieldsMap) {
                    listFields.add(abc);
                }                
            }
            if(objWrapper.sectionName.contains('Attachments')){
                listFieldSub = objWrapper.labelFieldsMap;
            }
        }
        system.debug('List Fields '+Json.serialize(listFieldSub));
        for(LnP_ApplyForLicenseWrapper.MapLabelToFields fieldMap : listFields){
            if((fieldMap.submissionDetails != '' && fieldMap.submissionDetails != null) ){
                system.debug('insdie submissiondetails'+fieldMap);
                if (fieldMap.value != null && fieldMap.value != '' ) {
                    system.debug('insdie submissiondetailsvalues'+fieldMap.value);
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
        String mastSubCond3 = 'Credential_Type__c =\''+LicenseType+'\'';
        String mastSubCond4 = 'Title__c IN: XXX ORDER BY  Order_No__c ASC';
        String strSubmission = 'Select Id, Order_No__c,Name,Title__c,Question__c,Expected_Answer__c,Submission_Type__c, Required__c,  Active__c, Default__c, Application_Type__c, Credential_Type__c, Application_Method__c from MUSW__Master_Submission_List__c where ' +mastSubCond1+ ' AND '+mastSubCond2+ ' AND '+mastSubCond3+ ' AND ' +mastSubCond4 ;
        system.debug('submissionList'+submissionList);
        masterSubmissionList = Utilityclass_withsharing.queryRecordsInClause(strSubmission,submissionList);
        system.debug('masterSubmissionList12345'+masterSubmissionList);
        
        System.debug('Field Map'+JSON.serialize(listFieldSub));
        Map<Decimal,LnP_ApplyForLicenseWrapper.MapLabelToFields> submissions = new Map<Decimal,LnP_ApplyForLicenseWrapper.MapLabelToFields>();
        Map<Decimal,LnP_ApplyForLicenseWrapper.MapLabelToFields> warapperMapSorted = new Map<Decimal,LnP_ApplyForLicenseWrapper.MapLabelToFields>();
        for(LnP_ApplyForLicenseWrapper.MapLabelToFields fieldMap : listFieldSub){
            if(fieldMap.isGenericSub == true){
                // listFieldTemp.add(fieldMap);
                warapperMapSorted.put(fieldMap.orderBy,fieldMap);  
            }
            else{
                submissions.put(fieldMap.orderBy,fieldMap);  
            }
        }
        system.debug('submissions3454'+submissions);
        //Map<String,LnP_ApplyForLicenseWrapper.MapLabelToFields> warapperMapSorted = new Map<String,LnP_ApplyForLicenseWrapper.MapLabelToFields>();
        if(masterSubmissionList.size()>0){
            for(MUSW__Master_Submission_List__c master : masterSubmissionList){
                if(submissions.containsKey(master.Order_No__c)){
                    // listFieldTemp.add(submissions.get(String.valueof(master.Order_No__c)));
                    
                    warapperMapSorted.put(master.Order_No__c,submissions.get(master.Order_No__c));
                    //  System.debug('submission'+submissions.get(master.Name));
                }
                else{
                    System.debug('Create new submission'+master.id);
                    LnP_ApplyForLicenseWrapper.MapLabelToFields submissionMap = new LnP_ApplyForLicenseWrapper.MapLabelToFields();
                    submissionMap.label = master.Name;
                    submissionMap.conditionalAnswer = master.Title__c;
                    submissionMap.orderBy = master.Order_No__c;
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
                    warapperMapSorted.put(submissionMap.orderBy,submissionMap);
                    // listFieldTemp.add(submissionMap);
                }
            }
            // listFieldTemp.addAll(warapperMapSorted.keyset());
            //  listFieldTemp.sort();
        }
        List<Decimal> lststing = new List<Decimal>();
        Map<Decimal,LnP_ApplyForLicenseWrapper.MapLabelToFields> warapperMapSorted2 = new Map<Decimal,LnP_ApplyForLicenseWrapper.MapLabelToFields>();
        if(!warapperMapSorted.isEmpty()) {
            lststing.addAll(warapperMapSorted.keyset());
            lststing.sort();
            for( Integer i= 0;i < lststing.size(); i++){
                warapperMapSorted2.put(lststing[i],warapperMapSorted.get(lststing[i]));
            }
            // system.debug('after sort'+json.serialize(warapperMapSorted));
            listFieldTemp = warapperMapSorted2.values();
            listFieldSub.clear();
            listFieldSub.addAll(listFieldTemp);
            // System.debug('Field Map'+JSON.serialize(listFieldTemp));
        }
        
        return wrapperList;
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
        mapAddress = getAddresses(setAppId);
        mapEducation = getBackgroundInformation(setAppId);
        System.debug('dataString---->'+dataString);
        List<LnP_ApplyForLicenseWrapper> wrapperList = (List<LnP_ApplyForLicenseWrapper>)JSON.deserialize(dataString, List<LnP_ApplyForLicenseWrapper>.class);
        Integer questionsAnswered=0;
        Integer FGquestionsAnswered=0;
        String accountId='';
        if(!wrapperList.isEmpty()){
            accountId =  wrapperList[0].accountId != null ? wrapperList[0].accountId : '';
        }
        wrapperList = fetchSubmission(wrapperList, Board,  LicenseType,  ApplicationType);
        System.debug('Wrapper'+JSON.serialize(wrapperList));
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
			Integer refcount = 0;
            for(LnP_ApplyForLicenseWrapper.MapLabelToFields fieldMap : listFields){
                refcount++;
                if((fieldMap.value != null && fieldMap.value != '' && fieldMap.value != '--None--' && fieldMap.value != '--Select one--') || (fieldMap.multiValues != null && fieldMap.multiValues.size()>0)){
                    //system.debug('inside a methods');
                    LnP_JSONParser.CompositeRequest requestDetails = new LnP_JSONParser.CompositeRequest();
                    requestDetails.method = 'POST';
                    requestDetails.url = '/services/data/v38.0/sobjects/BGCK__Answer__c';
                    requestDetails.referenceId = 'refId'+refcount;
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
                    // body.questionsBody = fieldMap.label;
                    body.Application = appId;
                    requestDetails.body = body;
                    requestDetailsList.add(requestDetails);
                }
                if(fieldMap.renderedOnUi!=null && fieldMap.renderedOnUi == true && fieldMap.questionSectionClass.contains('Questions') || fieldMap.questionSectionClass.contains('Financial Guarantee') || fieldMap.questionSectionClass.contains('Endorsement') || fieldMap.questionSectionClass.contains('Course') || fieldMap.questionSectionClass.contains('Application Fees')){
                    count++;  
                }
                if(fieldMap.renderedOnUi!=null && fieldMap.renderedOnUi == true && fieldMap.questionSectionClass.contains('Questions') && fieldMap.isMandatoryQues ==true){
                    questioncount++;
                }
                if(fieldMap.renderedOnUi!=null && fieldMap.renderedOnUi == true &&  fieldMap.questionSectionClass.contains('Financial Guarantee') ){
                    FGquestioncount++;
                }
                //system.debug('fieldMap.renderedOnUi '+fieldMap.renderedOnUi);
                if( fieldMap.questionSectionClass.contains('Questions')  && fieldMap.isMandatoryQues ==true && fieldMap.renderedOnUi!=null && fieldMap.renderedOnUi==true && (fieldMap.value != null && fieldMap.value !='' || fieldMap.multiValues != null  ) ){
                    questionsAnswered++;
                }
                if(fieldMap.questionSectionClass.contains('Financial Guarantee') && fieldMap.renderedOnUi!=null && fieldMap.renderedOnUi==true && fieldMap.value != null && fieldMap.value !='' ){
                    FGquestionsAnswered++;
                }
            }
            //validationForQuestions:
            system.debug('Count '+count);
            system.debug('questionsAnswered '+questionsAnswered);
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
                    System.debug('link.LinkedEntityId--->'+link.LinkedEntityId);
                    System.debug('appId--->'+appId);
                    
                    if(link.LinkedEntityId == appId)
                        docLinkMap.put(link.ContentDocumentId,link.Id);
                }    
            }
            Integer count = 0;
            Integer subcount = 0;
            system.debug('submissionFields'+submissionFields);
            for(LnP_ApplyForLicenseWrapper.MapLabelToFields fieldMap : submissionFields){
                subcount++;
                if(fieldMap.isMandatorySub == true){
                    count++;
                }
                if(fieldMap.isMandatorySub == true && !fieldMap.multiValues.isEmpty()){
                    filesSubmitted++;
                }
                system.debug('counttotal'+count);
                system.debug('filesSubmitted'+filesSubmitted);
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
            /* List<LnP_Licence_Application__c> listAppDelete = new List<LnP_Licence_Application__c>();
if(appList[0].License_Application__r != null && appList[0].License_Application__r.size()>0){
listAppDelete.addAll(appList[0].License_Application__r);
}*/
            
            if(appList[0].Education_History__r != null && appList[0].Education_History__r.size() >0){
                // lstEducations = 
                lstEducations.addAll(appList[0].Education_History__r);
            }
            //delete listAppDelete;
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
            /*LnP_Licence_Application__c applicationChild = new LnP_Licence_Application__c();
applicationChild.Contact__c = getContactId;
applicationChild.Sequence__c = count;
if(accountId != ''){
applicationChild.Account__c = accountId;
}

applicationChild.Licence_Application_Bg__c = appId;*/
            if(jsonString.length() <= 131072){
                /*applicationChild.LnP_Form_JSON__c = jsonString;
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
        //insert listApp;
        //string recID = listApp[0].ID;
        //system.debug('listApp'+ recID);
        
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
                lstMandatorySubsection = objWrapper.mandatorySubsection.split(',') ;
                if(lstMandatorySubsection != null){
                    for(String mandatorySubSection : lstMandatorySubsection){
                        system.debug('mandatorySubsection098'+ mandatorySubSection);
                        if((mandatorySubSection == 'Physical Address' || mandatorySubSection == 'Mailing Address')){
                            if(mapAddress.isEmpty()){
                                objWrapper.sectionError = true;
                            }
							else{
                                if(!mapAddress.containsKey('MAILING ADDRESS') || (!mapAddress.containsKey('PHYSICAL ADDRESS') && !mapAddress.get('MAILING ADDRESS')[0].is_Physical_and_Mailing_Address_Same__c)){
                                    //if(mapAddress.get(mandatorySubSection) == null ||  mapAddress.get(mandatorySubSection).size() == 0 ){
                                        system.debug('inside the mandatory'+mapAddress.get('PHYSICAL ADDRESS'));
                                        objWrapper.sectionError = true;
                                    //objWrapper.sectionError = false;
                                    //}
                                }
                            }                           /*else if(mapAddress.get(mandatorySubSection) == null ||  mapAddress.get(mandatorySubSection).size() == 0 ){
                                system.debug('inside the mandatory');
                                objWrapper.sectionError = true;
                            }*/
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
    public static string callCompositeAPI(String applicationId,string renewReinstate){
        List<MUSW__Application2__c> appList =new List<MUSW__Application2__c>();
        Map<String,String> mapSubmissionToFile = new Map<String,String>();
        Set<Id>  setapplicationId =  new Set<Id> ();
        String licenseID;
        Boolean checkSuccess = false;
        // string applicationId2 = string.valueOf(applicationId).substring(0, 15);
        setapplicationId.add(applicationId);
        String appCondition = 'Id=\''+applicationId+'\'';
        //String strApp = 'Select Id, Stage__c, Application_Type__c,  Application_Method__c, Credential_Type__c, (Select Id, Sequence__c, LnP_Form_JSON__c from License_Application__r ORDER BY Sequence__c ASC) from MUSW__Application2__c where '+appCondition;
        String strApp = 'Select Id, Stage__c, Form_JSON__c, Application_Type__c,  Credential_Type__c, Application_Method__c from MUSW__Application2__c where '+appCondition;
        system.debug('StrApp Query--->'+strApp);
        appList = Utilityclass_withsharing.queryRecords(strApp);
        system.debug('Applist In AController--->'+appList);
        String stringJSON = '';
        stringJSON = appList[0].Form_JSON__c;
        //Modified code for handling 25 subrequest governor limit
        LnP_JSONParser ansWrapper= Polaris_ApplyForLicenseController.getJSONWrapper(stringJSON);
        List<LnP_JSONParser.CompositeRequest> requestDetailsList = new List<LnP_JSONParser.CompositeRequest>();
        for(LnP_JSONParser.CompositeRequest req : ansWrapper.compositeRequest){
            requestDetailsList.add(req);
        }
        List<List<LnP_JSONParser.CompositeRequest>> compositeReq = Polaris_ApplyForLicenseService.partition(requestDetailsList,24);
        //  System.debug('appList '+appList);
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
            
            
            if(checkSuccess) {
                appList[0].Stage__c = -1;
                appList[0].MUSW__Status__c = 'Submitted';
                licenseID =insertLisence(setapplicationId,renewReinstate);
                //Setup  for the populating the details
                List<MUSW__Application2__c> appListOtherDetils =new List<MUSW__Application2__c>();
                //  String strAppOther = 'Select Id, Stage__c, Application_Type__c,  Application_Method__c, Credential_Type__c,(select id,MUSW__License2__c from MUSW__Submissions__r) ,(select Id,License__c from Answers1__r),(Select Id,License__c FROM Employment_History__r),(Select Id,License__c FROM Education_History__r),(Select Id FROM Parcels__r) from MUSW__Application2__c where '+appCondition;
                String strAppOther = 'Select Id,MUSW__Account__c,Stage__c, Application_Type__c,  Application_Method__c, Credential_Type__c, (select id,MUSW__License2__c,ContentDocumentId__c from MUSW__Submissions__r) ,(select Id,Answer_Text__c,License__c,Create_Endorsement_Record__c,Endorsement_Type__c,QuestionDOL__r.Course_Type_Question__c,QuestionDOL__r.RecordType.DeveloperName,QuestionDOL__r.RecordType.Name,QuestionDOL__r.Question_Body__c,QuestionDOL__r.Parent_Object_API_Name__c,QuestionDOL__r.Data_Type__c,QuestionDOL__r.Endorsement_Type__c,Question_Section__c,QuestionDOL__r.QuestionFieldAPI__c,QuestionDOL__r.QuestionObjectName__c from Answers1__r),(Select Id,License__c FROM Employment_History__r),(Select Id FROM Parcels__r) from MUSW__Application2__c where '+appCondition;
                system.debug('StrApp Query--->'+strAppOther);
                appListOtherDetils = Utilityclass_withsharing.queryRecords(strAppOther);
                Set<Id> parcelId = new Set<Id>();
                List<MUSW__License_Parcel__c> lstParcelsList = new List<MUSW__License_Parcel__c>(); 
                for(MUSW__Parcel__c parcel : appListOtherDetils[0].Parcels__r){
                    parcelId.add(parcel.Id);
                }
                System.debug('parcelId==='+ parcelId);
                for(MUSW__License_Parcel__c licenseParcel : [Select Id, Renewal_Reinstatement_Application__c, MUSW__Parcel__r.Id From MUSW__License_Parcel__c Where MUSW__Parcel__r.Id IN :parcelId]){
                    licenseParcel.Renewal_Reinstatement_Application__c = licenseID;
                    lstParcelsList.add(licenseParcel);
                }
                System.debug('lstParcelsList==='+ lstParcelsList);
                if(!lstParcelsList.isEmpty()){
                    update lstParcelsList;
                }
                List<LnP_BackgroundSection__c> lstEduHist = new List<LnP_BackgroundSection__c>();            
                if(appListOtherDetils[0].LnP_BackgroundSections__r != null && appListOtherDetils[0].LnP_BackgroundSections__r.size()>0){
                    for(LnP_BackgroundSection__c EduHist : appListOtherDetils[0].LnP_BackgroundSections__r){
                        EduHist.License_Bg__c = licenseID; 
                        lstEduHist.add(EduHist);
                    }
                    update lstEduHist;                
                }   
                //newly added for endo
                List<BGCK__Answer__c> lstAnswers = new List<BGCK__Answer__c>();
                List<Endorsement__c> lstEndorsements = new List<Endorsement__c>();
                String providerName = '';
                if(appListOtherDetils[0].Answers1__r != null && appListOtherDetils[0].Answers1__r.size()>0 && appListOtherDetils[0].Credential_Type__c == 'Notary Public'){
                    for(BGCK__Answer__c ans : appListOtherDetils[0].Answers1__r)
                    {                    
                        if((!ans.Create_Endorsement_Record__c) && ans.QuestionDOL__r.Data_Type__c == 'Picklist' && ans.Question_Section__c=='Endorsement' && ans.QuestionDOL__r.Parent_Object_API_Name__c== 'Renewal_Application__c' )
                        {
                            providerName = ans.Answer_Text__c;
                        }
                    }
                }
                system.debug('lstAnswers '+lstAnswers);
                Renewal_Application__c RenewalObj = [SELECT Id FROM Renewal_Application__c WHERE Id=: licenseID ];
                
                // added for courses
                if(appListOtherDetils[0].Answers1__r != null && appListOtherDetils[0].Answers1__r.size()>0 && appListOtherDetils[0].Credential_Type__c == 'Appraiser Course'  )
                {
                    List<String> preApproval = new List<String>();
                    for(BGCK__Answer__c ans : appListOtherDetils[0].Answers1__r)
                    {   if(ans.QuestionDOL__r.QuestionObjectName__c == 'Renewal_Application__c')  {
                        
                   
                        ans.Renewal_Reinstatement_Application__c = licenseID;   
                        // map course fields here
                        if(ans.QuestionDOL__r.RecordType.DeveloperName =='Course_Information'){
                            String QuestionObjFieldAPIName = ans.QuestionDOL__r.QuestionFieldAPI__c;
                            system.debug(' in course info rec type filter');
                            if(QuestionObjFieldAPIName == 'Email__c'){
                                system.debug('QuestionObjFieldAPIName '+QuestionObjFieldAPIName);
                                RenewalObj.Email__c = ans.Answer_Text__c;
                            }
                            if(QuestionObjFieldAPIName == 'Phone__c'){
                                system.debug('QuestionObjFieldAPIName '+QuestionObjFieldAPIName);
                                RenewalObj.Phone__c = ans.Answer_Text__c;
                            }  
                            if(QuestionObjFieldAPIName == 'Website__c'){
                                system.debug('QuestionObjFieldAPIName '+QuestionObjFieldAPIName);
                                RenewalObj.Website__c = ans.Answer_Text__c;
                            }  
                            if(QuestionObjFieldAPIName == 'IDECC_Approval_Expiration_Date__c'){
                                system.debug('QuestionObjFieldAPIName '+QuestionObjFieldAPIName);
                                RenewalObj.IDECC_Approval_Expiration_Date__c = Date.valueOf(ans.Answer_Text__c);
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
                                String preApprovalString ='';
                                for(String str : preApproval)
                                {
                                    preApprovalString += str + ';' ;
                                }
                                // remove last additional comma from string
                                
                                preApprovalString = preApprovalString.subString(0,preApprovalString.length());
                                
                                system.debug('preApproval----> '+preApproval);
                                
                                RenewalObj.Pre_Approval__c = preApprovalString;
                            }
                            if(QuestionObjFieldAPIName == 'Delivery_Method__c'){
                                if(ans.QuestionDOL__r.Question_Body__c == 'Is this is a Distance / On-line course?' && ans.Answer_Text__c == 'Yes')
                                {
                                    RenewalObj.Course_Renewal_Delivery_Method__c = 'Distance / On-Line';
                                } else
                                {
                                    RenewalObj.Course_Renewal_Delivery_Method__c = 'Classroom (Instructor in room with students)';
                                }
                            }
                        }
                    }
                    }
                    system.debug('RenewalObj1234'+RenewalObj);
                    update RenewalObj;
                }
                if(appListOtherDetils[0].Answers1__r != null && appListOtherDetils[0].Answers1__r.size()>0){
                    for(BGCK__Answer__c ans : appListOtherDetils[0].Answers1__r){
                        ans.Question2__c = ans.QuestionDOL__r.Question_Body__c;
                        ans.Renewal_Reinstatement_Application__c = licenseID;                    
                        if(ans.Create_Endorsement_Record__c && ans.QuestionDOL__r.Data_Type__c == 'Yes_No' && ans.Answer_Text__c=='Yes' && ans.QuestionDOL__r.Parent_Object_API_Name__c== 'Renewal_Application__c')
                        {
                            Endorsement__c endorsment = new Endorsement__c();
                            endorsment.Endorsement_Type__c = ans.Endorsement_Type__c;
                            endorsment.License_Type__c = appListOtherDetils[0].Credential_Type__c;
                            //endorsment.Status__c = 'Pending Add';
                            if(appListOtherDetils[0].Credential_Type__c == 'Notary Public')
                            {
                                //endorsment.Electronic_Software_Provider__c = providerName;
                                endorsment.Status__c = 'Active';
                            }
                            endorsment.Date_Requested_for_Adding_Endorsement__c = system.today();
                            endorsment.Renewal_Reinstatement_Application__c = licenseID;
                            endorsment.Created_for_New_Application__c = True;
                            endorsment.License__c = liceseIDRenewal;
                            lstEndorsements.add(endorsment);
                        }
                        else if(ans.Create_Endorsement_Record__c && ans.QuestionDOL__r.Data_Type__c == 'Picklist' && ans.Answer_Text__c != '' && ans.Answer_Text__c !='--None--' && ans.QuestionDOL__r.Endorsement_Type__c!='Notary' && ans.QuestionDOL__r.Parent_Object_API_Name__c== 'Renewal_Application__c' )
                        {
                            Endorsement__c endorsment = new Endorsement__c();
                            endorsment.Endorsement_Type__c = ans.Answer_Text__c;
                            endorsment.License_Type__c = appListOtherDetils[0].Credential_Type__c;
                            //endorsment.Status__c = 'Pending Add';
                            endorsment.Date_Requested_for_Adding_Endorsement__c = system.today();
                            endorsment.Renewal_Reinstatement_Application__c = licenseID;
                            endorsment.Created_for_New_Application__c = True;
                            endorsment.License__c = liceseIDRenewal;
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
                            review.Name = 'Endorsement Review';
                            review.Renewal_Application__c = licenseID;
                            review.MUSW__Status__c = 'Pending';
                            review.Endorsement__c = endo.Id;
                            lstReview.add(review);
                        }              
                        
                        insert lstReview;
                    }*/
                }
                //end
                List<MUSW__Submission__c> lstSubmissions= new List<MUSW__Submission__c>();            
                if(appListOtherDetils[0].MUSW__Submissions__r != null && appListOtherDetils[0].MUSW__Submissions__r.size()>0){
                    for(MUSW__Submission__c submissions : appListOtherDetils[0].MUSW__Submissions__r){
                        submissions.License_Renewal__c = licenseID; 
                        lstSubmissions.add(submissions);
                        //Creating map for integration team to  store the docs in 3rd party
                        if(submissions!=null && submissions.ContentDocumentId__c != null ) {
                             mapSubmissionToFile.put(submissions.ID, submissions.ContentDocumentId__c.replace(';',''));
                        }
                       
                    }
                    update lstSubmissions;                
                }
                
                
                update appList[0];
                
            }   
        }
                //Calling method to  store 3rd party
        if(!mapSubmissionToFile.isEmpty()){
            Polaris_RenewLicenseController.updateLinkedEntityId(mapSubmissionToFile);
          //  string success = Dol_UploadDocumenttoSAN.portalUpload(mapSubmissionToFile);
        }
        return licenseID;
    }
    
    private static ID insertLisence(Set<Id> appId,String renewReinstate){
        List<Renewal_Application__c> lstLisence = new List<Renewal_Application__c>();
        List<MUSW__License2__c> liceList = new List<MUSW__License2__c>();
        //Id licID;
        Id businessRT = SObjectType.Renewal_Application__c.getRecordTypeInfosByDeveloperName().get('Business').getRecordTypeId();
        Id individualRT = SObjectType.Renewal_Application__c.getRecordTypeInfosByDeveloperName().get('Individual').getRecordTypeId();
        // For Course Renewal Applications
        Id courseRT = SObjectType.Renewal_Application__c.getRecordTypeInfosBYDeveloperName().get('Course').getRecordTypeId();
        
        List<MUSW__Application2__c> applicationList = [SELECT Id,isRenewal__c,Physical_Address_Modified_On_Renewal__c,Application_Type__c,Application_Method__c,Credential_Type__c,MUSW__Account__c,MUSW__Applicant__c, (select Id,Answer_Text__c,License__c,Create_Endorsement_Record__c,Endorsement_Type__c,QuestionDOL__r.Data_Type__c,QuestionDOL__r.Question_Body__c,QuestionDOL__r.QuestionFieldAPI__c,QuestionDOL__r.Endorsement_Type__c,QuestionDOL__r.Course_Type_Question__c,QuestionDOL__r.RecordType.DeveloperName,QuestionDOL__r.RecordType.Name,Question_Section__c,QuestionDOL__r.QuestionObjectName__c,QuestionDOL__r.Parent_Object_API_Name__c from Answers1__r) FROM MUSW__Application2__c where id IN: appId];
        system.debug('applicationList : '+applicationList);
        for(MUSW__Application2__c application : applicationList){
            Renewal_Application__c  mstLicense =  new Renewal_Application__c();
            mstLicense.Applicant__c = application.MUSW__Applicant__c;
            mstLicense.Application_Type__c = application.Application_Type__c;
            mstLicense.Credential_Type__c = application.Credential_Type__c;
            mstLicense.Physical_Address_Modified__c = application.Physical_Address_Modified_On_Renewal__c;
            mstLicense.Credential__c = application.Credential_Type__c;
            //mstLicense.Application_Method__c = application.Application_Method__c;
            if(application.MUSW__Account__c!=null)
            {
                /*if(application.MUSW__Account__r.Course_Provider__c){
mstLicense.RecordTypeId = courseRT;
}else{
mstLicense.RecordTypeId = businessRT; 
}*/
                
            }
            else
            {
                mstLicense.RecordTypeId = individualRT;
            }
            
            
            
            mstLicense.Application__c = application.id;
            //mstLicense.MUSW__Applicant__c = application.MUSW_Applicant__c;
            //mstLicense.MUSW__Primary_Licensee__c = '001r000000Cax8Y';
            liceseIDRenewal = [Select Id,Application__c From MUSW__License2__c where Application__c =:application.id][0].Id;
            mstLicense.Renewal_Status__c = 'Generate Fee';
            mstLicense.License__c = liceseIDRenewal;
            mstLicense.Renewal_Reinstatement_Type__c = renewReinstate;
            MUSW__License2__c lic = [SELECT Id, Bond_Number__c, Surety_Bond_Company_Name__c, Policy_Amount__c, Effective_Date_of_Bond__c, Expiration_Date_of_Bond__c FROM MUSW__License2__c where Id =: liceseIDRenewal];
            //Added for pol
            Map<String, Schema.SObjectField> fields = Schema.getGlobalDescribe().get('Renewal_Application__c').getDescribe().SObjectType.getDescribe().fields.getMap();
            Map<String,String>  mapValueToStr =  new Map<String,String>();
            

            
            //--------Added by Babita---------------
            if(application.Answers1__r != null && application.Answers1__r.size()>0) {
                    for(BGCK__Answer__c ans : application.Answers1__r)
                    {  
                        //updated field name from 'QuestionObjectName__c' to 'Parent_Object_API_Name__c'
                       if(ans.Answer_Text__c != null && ans.QuestionDOL__r.QuestionFieldAPI__c != null 
                          && ans.QuestionDOL__r.Parent_Object_API_Name__c == 'Renewal_Application__c' && ans.QuestionDOL__r.RecordType.DeveloperName == 'Background_Questions')
                        {   
                            mapValueToStr.put(ans.QuestionDOL__r.QuestionFieldAPI__c,ans.Answer_Text__c);
                        }
                    }
                if(!mapValueToStr.isEmpty()) {
                    System.debug('****Inside IF****');
                    for(String fieldName : mapValueToStr.keySet()){     
                        if(mapValueToStr.get(fieldName) != null) {
                            system.debug('***fieldName***'+fieldName);
                           // system.debug('fields.get(fieldName).getDescribe().getType();'+fields.get(fieldName).getDescribe().getType());
                            Schema.DisplayType targetType = fields.get(fieldName).getDescribe().getType();
                            System.debug('***targetType***'+targetType);
                            string strFieldName = String.valueOf(targetType);
                            if(strFieldName == 'TEXTAREA' || strFieldName =='MULTIPICKLIST' || strFieldName == 'TEXT'  ) {
                                mstLicense.put(fieldName,String.valueOf(mapValueToStr.get(fieldName)));
                                system.debug('***RenewalObj in if***'+mstLicense);
                            } else if(strFieldName == 'DOUBLE') {
                                mstLicense.put(fieldName,Double.valueOf(mapValueToStr.get(fieldName))); 
                                system.debug('***RenewalObj in else if***'+mstLicense);
                            }    
                        }

                    }
                    system.debug('***RenewalObj after for ends***'+mstLicense);
                }

                system.debug('Financial Guarantee if entered');
                for(BGCK__Answer__c ans : application.Answers1__r){                    
                    if(ans.QuestionDOL__r.RecordType.DeveloperName == 'Financial_Guarantee'){
                        //system.debug('after If : ans.Question__r.RecordType.DeveloperName::'+ans.Question__r.RecordType.DeveloperName);
                        
                        String quesBody = ans.QuestionDOL__r.Question_Body__c;
                        String answerText = ans.Answer_Text__c;
                        String stringToDate = '';
                        if(quesBody == 'Bond / Policy Number'){
                            lic.Bond_Number__c = String.valueOf(answerText);
                        }
                        
                        if(quesBody == 'Bond / Insurance Company Name'){
                            lic.Surety_Bond_Company_Name__c = String.valueOf(answerText);
                        }
                        
                        if(quesBody == 'Bond / Policy Amount'){
                            lic.Policy_Amount__c = String.valueOf(answerText);
                        }
                        
                        if(quesBody == 'Effective Date'){
                            stringToDate = String.valueOf(answerText);
                            Integer year = Integer.valueOf(stringToDate.subString(0, 4));
                            Integer month = Integer.valueOf(stringToDate.substring(5, 7));
                            Integer day = Integer.valueOf(stringToDate.subString(8));
                            Date d = Date.newInstance(year, month, day);
                            
                            lic.Effective_Date_of_Bond__c = d;
                        }
                        
                        if(quesBody == 'Expiration Date'){
                            stringToDate = String.valueOf(answerText);
                            Integer year = Integer.valueOf(stringToDate.subString(0, 4));
                            Integer month = Integer.valueOf(stringToDate.substring(5, 7));
                            Integer day = Integer.valueOf(stringToDate.subString(8));
                            Date d = Date.newInstance(year, month, day);
                            
                            lic.Expiration_Date_of_Bond__c = d;
                        }
                    }            
                    
                    
                    
                }
            }
            //---------Completed by Babita
            
            liceList.add(lic);
            lstLisence.add(mstLicense);
        }
        
        if(!lstLisence.isEmpty()){
            insert lstLisence;
            update liceList;
        }
        
        List<Endorsement__c> lstEndo = [SELECT id,Date_Requested_for_Adding_Endorsement__c,Endorsement_Type__c,Renewal_Reinstatement_Application__c,License__c,Status__c FROM Endorsement__c where  License__c =:liceseIDRenewal];
        for(Endorsement__c endo : lstEndo)
        {
            if(endo.Status__c == 'Renew'){
                endo.Renewal_Reinstatement_Application__c = lstLisence[0].Id;
                if(endo.Endorsement_Type__c=='Electronic Notary')
                {
                    endo.Status__c = 'Active';
                }
                else
                {
                    endo.Status__c = 'In-Review';
                }
                
            }
            
        }
        update lstEndo;
        if(!applicationList.isEmpty())
        {
            applicationList[0].isRenewal__c = false;
            update applicationList;
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
    public static Map<String, List<MUSW__Parcel__c>> getAddresses (Set<Id> appId){
        Map<String, List<MUSW__Parcel__c>> mapAddress  =  new Map<String,List<MUSW__Parcel__c>>();
        List<MUSW__Parcel__c> lstAddress  = [Select Id, Address_Type__c, is_Physical_and_Mailing_Address_Same__c, MUSW__Street2__c, 
                                                  MUSW__Unit__c, MUSW__City__c,MUSW__State__c, Canadian_provinces__c, 
                                                  County__c, Country__c, Zip_Postal_Code__c,Application_BG__c
                                                  FROM MUSW__Parcel__c WHERE Application_BG__c IN :appId];
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
        List<Renewal_Application__c> licList = [select Id,Total_Balance__c from Renewal_Application__c where Id=:licId];
        if(!licList.isEmpty() && licList[0].Total_Balance__c == 0){
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
    
    @AuraEnabled
    public static boolean updateAddressModified(Id appId){
        Boolean updatedFlag = false;
        MUSW__Application2__c app = new MUSW__Application2__c(Id = appId);
        app.Physical_Address_Modified_On_Renewal__c = true;
        try{
            update app;
            updatedFlag = true;
        }catch(Exception e){
            updatedFlag = false;
        }
        return updatedFlag;
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
