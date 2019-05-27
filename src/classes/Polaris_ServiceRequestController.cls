public class Polaris_ServiceRequestController {
    public static Map<String,String> mapSubsectionIcon {get;set;}
    public static String sections {get;set;}
    public static List<Question__c> lstQuestions {get;set;} 
    public static List<MUSW__Master_Submission_List__c> lstMasterSubmission {get;set;}
    public static List<Request__c> lstApps {get;set;}   
    
    @AuraEnabled(cacheable = true)
    public static String fetchData(String board,String licenseType,String requestType, String requestId, String flowType)
    {
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
        List<LnP_License_Type_Sections_Setting__mdt> lstSections = new List<LnP_License_Type_Sections_Setting__mdt>();        
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
    
}