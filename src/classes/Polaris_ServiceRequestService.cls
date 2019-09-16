public class Polaris_ServiceRequestService {

public static List<User> fetchUserDetails () {
        List<User> lstUserInfoData = new List<User>();
        String queryCondition = DOL_AppConstants.NULL_EMPTY_STRING + ' Id=\''+UserInfo.getUserId()+'\'';
        String queryStr = DOL_AppConstants.NULL_EMPTY_STRING + 'SELECT Username, ContactId, Contact.Name, Contact.AccountId, Contact.Account.Name FROM User WHERE  '+queryCondition + 'Limit 1';
        lstUserInfoData = Utilityclass_withsharing.queryRecords(queryStr);
        return lstUserInfoData;
    }
    
    public static Map<string,String> fetchMandatorySubsections(String applicationType, String credentialType,String flowtype)
    {
        system.debug('board : '+applicationType+'licenseType : '+credentialType);
        Map<string,String> mapMandatorySubsection = new Map<string,String>();        
        for(LnP_Mandatory_Subsections__mdt mappingSection : [SELECT SubSection__c,Section__c FROM LnP_Mandatory_Subsections__mdt WHERE Board__c =: applicationType AND License_Type__c =: credentialType ] )
        {
            mapMandatorySubsection.put(mappingSection.Section__c, mappingSection.SubSection__c);
        }
        system.debug('mapMandatorySubsection : '+mapMandatorySubsection);
        return mapMandatorySubsection;    
    }
        
    public static Map<string,string> fetchSubsectionIcons(String pageName)
    {
        Map<String, String> labelMap = new Map<String, String>();
        for(LnP_SubSection_Icon__mdt mappingIcon : [SELECT LnP_Icon_Name__c, LnP_Icon_SVG_Name__c from LnP_SubSection_Icon__mdt WHERE LnP_Page_Name__c =: pageName])
        {
            labelmap.put(mappingIcon.LnP_Icon_Name__c , mappingIcon.LnP_Icon_SVG_Name__c);
        }
        system.debug('labelMap '+labelMap);
        return labelMap;
    }
    
    public static List<AMR_Link__mdt> fetchSection(String applicationType, String credentialType, String requestType, String flowType)
    {
        List<AMR_Link__mdt> lstSections = new List<AMR_Link__mdt>();
        //List<LnP_License_Type_Sections_Setting__mdt> lstSections = new List<LnP_License_Type_Sections_Setting__mdt>();
        String str = DOL_AppConstants.NULL_EMPTY_STRING + '';
            //if(flowType=='Endorsement'){
              //  str = DOL_AppConstants.NULL_EMPTY_STRING + 'SELECT Sections__c FROM LnP_License_Type_Sections_Setting__mdt WHERE Board__c = \'' +applicationType+ '\' AND License_Type__c = \'' +credentialType+ '\' AND Application_Method__c = \''+flowType+'\'';
            //}
        //else
        	//str = DOL_AppConstants.NULL_EMPTY_STRING + 'SELECT Sections__c FROM AMR_Link__mdt WHERE Board__c = \''+applicationType+'\' AND License_Type__c = \''+credentialType+'\' AND Service_Request_Type__c = \''+flowType+'\'';
        
        str = DOL_AppConstants.NULL_EMPTY_STRING + 'SELECT Sections__c,MasterLabel FROM AMR_Link__mdt WHERE Board__c = \'' +applicationType+ '\' AND License_Type__c = \'' +credentialType+ '\' AND Service_Request_Type__c = \''+flowType+'\'';
        system.debug('str '+str);
        lstSections = Utilityclass_withsharing.queryRecords(str);
        return lstSections;
    }
    
    public static List<Question__c> fetchQuestionsDetails(String applicationType, String credentialType, String applicationMethod,String flowType) {
        system.debug('board : '+applicationType+'licenseType : '+credentialType+ 'applicationType: '+applicationMethod+'flowType : '+flowType);
        List<Question__c> lstQuestions =  new List<Question__c>(); 
        String str = DOL_AppConstants.NULL_EMPTY_STRING + '';
        if(flowType=='Endorsement'){
            str  = DOL_AppConstants.NULL_EMPTY_STRING + 'Select Id,Name,Warning_Message__c,isRequired__c,Endorsement_Type__c,Triggering_Parent_Answer__c,Qualifying_Response__c,Has_Any_Submission__c,Submission_Title__c,Application_Type__c,Question_Body__c,Data_Type__c,Possible_Responses__c,Credential__c,Application_Method__c,Order_Number__c,Has_dependent_questions__c,  Parent_Question__c, Record_Type_Name__c,Section__c, Sub_Header__c,  Sub_Sub_Header__c,  Section_Order__c,QuestionFieldAPI__c, QuestionObjectName__c,Message__c,MessageTriggerResponse__c FROM Question__c where Application_Type__c =\'' +applicationType+ '\' AND Credential_Type__c = \'' +credentialType+ '\' AND Application_Method__c = \''+applicationMethod +'\' AND status__c=\'Active\' AND record_type_name__c != \'Eligibility Questions\' AND Parent_Object_API_Name__c = \'MUSW__License2__c\' ORDER BY  Sub_Sub_Header__c,Order_Number__c ASC'; 
        }
        else
            str  = DOL_AppConstants.NULL_EMPTY_STRING + 'Select Id,Name,Warning_Message__c,isRequired__c,Endorsement_Type__c,Triggering_Parent_Answer__c,Qualifying_Response__c,Has_Any_Submission__c,Submission_Title__c,Application_Type__c,Question_Body__c,Data_Type__c,Possible_Responses__c,Credential__c,Application_Method__c,Order_Number__c,Has_dependent_questions__c,  Parent_Question__c, Record_Type_Name__c,Section__c, Sub_Header__c,  Sub_Sub_Header__c,  Section_Order__c,QuestionFieldAPI__c, QuestionObjectName__c,Message__c,MessageTriggerResponse__c FROM Question__c where Application_Type__c =\'' +applicationType+ '\' AND Credential_Type__c = \'' +credentialType+ '\' AND Service_Request_Type__c = \''+flowType +'\' AND status__c=\'Active\' AND record_type_name__c != \'Eligibility Questions\' AND Parent_Object_API_Name__c = \'MUSW__License2__c\' ORDER BY  Sub_Sub_Header__c,Order_Number__c ASC'; 
        
        system.debug('str1223'+str);
        lstQuestions = Utilityclass_withsharing.queryRecords(Str);
        system.debug('lstQuestions123'+lstQuestions);
        return lstQuestions;
    }
    
    public static List<MUSW__Master_Submission_List__c>fetchMasterSubmissionDetails(String applicationType, String credentialType, String applicationMethod, String flowType)
    {
        List<MUSW__Master_Submission_List__c> lstMasterSubmission = new List<MUSW__Master_Submission_List__c>();
        String str = DOL_AppConstants.NULL_EMPTY_STRING + '';
        
            str = DOL_AppConstants.NULL_EMPTY_STRING + 'Select Id,Submission_Type__c,Show_For__c, Name,Title__c,Question__c,Expected_Answer__c, Required__c,   Active__c, Default__c, Application_Type__c, Credential_Type__c, Application_Method__c from MUSW__Master_Submission_List__c where  Application_Type__c = \'' +applicationType+ '\' AND Credential_Type__c = \'' +credentialType+ '\' AND Service_Request__c = \'' +flowType +'\' AND Default__c = true And Object__c =\'MUSW__License2__c\' AND Show_For__c INCLUDES (\'License\',\'Credential\')';
        system.debug('str----'+str);
        lstMasterSubmission = Utilityclass_withsharing.queryRecords(str);
        return lstMasterSubmission;
    }
    
    public static List<Request__c> fetchApplications(String appId)
    {
        List<Request__c> lstApplication =new List<Request__c>();
        String appCondition = DOL_AppConstants.NULL_EMPTY_STRING + 'Id=\''+appId+'\'';       
        String strApp = DOL_AppConstants.NULL_EMPTY_STRING + 'Select Id,Application_Type__c,Profession__c, Stage__c, Service_Request_Type__c, License_Type__c, Form_JSON__c from Request__c where '+appCondition;
        lstApplication = Utilityclass_withsharing.queryRecords(strApp); 
        return lstApplication;
    }
    
    public static List<List<LnP_JSONParser.CompositeRequest>> partition(List<LnP_JSONParser.CompositeRequest> lstString, integer chunkSize){
        //system.debug('lstString'+lstString);
        integer counter = 24; 
        List<list<LnP_JSONParser.CompositeRequest>> result =new  List<list<LnP_JSONParser.CompositeRequest>>();
       for (LnP_JSONParser.CompositeRequest lstdata : lstString) {
            if (math.mod(counter,chunksize) == 0) {
                result.add(new list<LnP_JSONParser.CompositeRequest>());
                system.debug('gg'+counter);
               
            }
            counter++;
            result.get(result.size() - 1).add(lstdata); 
        }
        return result;
        
    }
    
    public static List<Endorsement__c> fetchEndorsements(String licID)
    {
        return [SELECT id,Endorsement_Type__c,License__c FROM Endorsement__c WHERE Status__c=: DOL_AppConstants.NULL_EMPTY_STRING + 'Active' AND License__c=:licID];
    }
}