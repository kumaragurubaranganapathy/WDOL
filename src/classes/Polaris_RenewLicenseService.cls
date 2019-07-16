public class Polaris_RenewLicenseService {
        
    public static List<User> fetchUserDetails () {
        List<User> lstUserInfoData = new List<User>();
        String queryCondition = ' Id=\''+UserInfo.getUserId()+'\'';
        String queryStr = 'SELECT Username, ContactId, Contact.Name, Contact.AccountId, Contact.Account.Name FROM User WHERE  '+queryCondition + 'Limit 1';
        lstUserInfoData = Utilityclass_withsharing.queryRecords(queryStr);
        return lstUserInfoData;
    }
    
    public static List<Question__c> fetchQuestionsDetails(String applicationType, String credentialType, String applicationMethod, String renewReinstate) {
        system.debug('board : '+applicationType+'licenseType : '+credentialType+ 'applicationType: '+applicationMethod);
        List<Question__c> lstQuestions =  new List<Question__c>();
        String condition1 = '';
        if(renewReinstate == 'Renewal')
        {
            condition1 = 'AND Show_For__c INCLUDES (\'Credential Renewal\')';
        }
        else if(renewReinstate=='Reinstatement')
        {
            condition1 = 'AND Show_For__c INCLUDES (\'Credential Reinstatement\')';
        }
        String str  = 'Select Id,Name,Endorsement_Type__c,Triggering_Parent_Answer__c,Qualifying_Response__c,Has_Any_Submission__c,Submission_Title__c,Application_Type__c,Question_Body__c,Data_Type__c,Possible_Responses__c,Credential__c,Application_Method__c,Order_Number__c,Has_dependent_questions__c,  Parent_Question__c, Record_Type_Name__c,Section__c, Sub_Header__c,  Sub_Sub_Header__c,  Section_Order__c,QuestionFieldAPI__c, QuestionObjectName__c,Message__c,MessageTriggerResponse__c FROM Question__c where Application_Type__c =\'' +applicationType+ '\' AND Credential_Type__c = \'' +credentialType+ '\' AND Application_Method__c = \''+applicationMethod +'\' '+condition1+' AND status__c=\'Active\' AND record_type_name__c != \'Eligibility Questions\' AND Parent_Object_API_Name__c = \'Renewal_Application__c\' ORDER BY  Sub_Sub_Header__c,Order_Number__c ASC';
        system.debug('str1223'+str);
        lstQuestions = Utilityclass_withsharing.queryRecords(Str);
        system.debug('lstQuestions123'+lstQuestions);
        return lstQuestions;
    }
    public static List<Endorsement__c> fetchEndorsements(String licID)
    {
        return [SELECT id,Endorsement_Type__c,License__c FROM Endorsement__c WHERE License__c=:licID];
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
    
    public static Map<string,String> fetchMandatorySubsections(String applicationType, String credentialType,String renewReinstate)
    {
        system.debug('board : '+applicationType+'licenseType : '+credentialType);
        Map<string,String> mapMandatorySubsection = new Map<string,String>();        
        for(LnP_Mandatory_Subsections__mdt mappingSection : [SELECT SubSection__c,Section__c FROM LnP_Mandatory_Subsections__mdt WHERE Board__c =: applicationType AND License_Type__c =: credentialType AND RenewOrReinstate__c=: renewReinstate] )
        {
            mapMandatorySubsection.put(mappingSection.Section__c, mappingSection.SubSection__c);
        }
        system.debug('mapMandatorySubsection : '+mapMandatorySubsection);
        return mapMandatorySubsection;
    
    }
    
    public static List<Application_Field__c>fetchApplicationFields(String applicationType, String credentialType, String applicationMethod)
    {
        system.debug('board : '+applicationType+'licenseType : '+credentialType+ 'applicationType: '+applicationMethod);
        List<Application_Field__c> lstApplicationFields = new List<Application_Field__c>();
        String Str = 'SELECT Application_Method__c,Application_Type__c,Id,Label__c,Credential_Type__c,Name,Object_Name__c,Order_Number__c,Read_Only__c,Required__c,Type__c,Validator__c FROM Application_Field__c where Application_Type__c = \'' +applicationType+ '\' AND Credential_Type__c = \'' +credentialType+ '\' ORDER BY Order_Number__c ASC';
        system.debug('Str '+Str);
        lstApplicationFields = Utilityclass_withsharing.queryRecords(Str);
        return lstApplicationFields;
    }
    
    public static List<MUSW__Master_Submission_List__c>fetchMasterSubmissionDetails(String applicationType, String credentialType, String applicationMethod,String renewReinstate)
    {
        List<MUSW__Master_Submission_List__c> lstMasterSubmission = new List<MUSW__Master_Submission_List__c>();
        
        String condition1 = '';
        if(renewReinstate == 'Renewal')
        {
            condition1 = 'AND Show_For__c INCLUDES (\'Credential Renewal\') ORDER BY  CreatedDate ASC';
        }
        else if(renewReinstate=='Reinstatement')
        {
            condition1 = 'AND Show_For__c INCLUDES (\'Credential Reinstatement\') ORDER BY  CreatedDate ASC';
        }
        String Str = 'Select Id,Submission_Type__c,Show_For__c, Name,Title__c,Question__c,Expected_Answer__c, Required__c,   Active__c, Default__c, Application_Type__c, Credential_Type__c, Application_Method__c from MUSW__Master_Submission_List__c where  Application_Type__c = \'' +applicationType+ '\' AND Credential_Type__c = \'' +credentialType+ '\' AND Application_Method__c = \'' +applicationMethod +'\' AND Default__c = true And Object__c =\'Renewal_Application__c\'  '+condition1;
        lstMasterSubmission = Utilityclass_withsharing.queryRecords(Str);
        return lstMasterSubmission;
    }
    
    public static List<MUSW__Application2__c> fetchApplications(String appId)
    {
        List<MUSW__Application2__c> lstApplication =new List<MUSW__Application2__c>();
        String appCondition = 'Id=\''+appId+'\'';
        //String strApp = 'Select Id,MUSW__Account__c,Stage__c, Application_Type__c,  Application_Method__c, Credential_Type__c, (Select Id, Contact__c, Account__c, Sequence__c, LnP_Form_JSON__c from License_Application__r ORDER BY Sequence__c ASC) from MUSW__Application2__c where '+appCondition;
         String strApp = 'Select MUSW__Applicant__c,Id,MUSW__Account__c,Stage__c, Application_Type__c,  Application_Method__c, Credential_Type__c, Form_JSON__c from MUSW__Application2__c where '+appCondition;
        lstApplication = Utilityclass_withsharing.queryRecords(strApp);
        return lstApplication;
    }
    
    public static List<LnP_License_Type_Sections_Setting__mdt> fetchSection(String applicationType, String credentialType, String applicationMethod)
    {
        List<LnP_License_Type_Sections_Setting__mdt> lstSections = new List<LnP_License_Type_Sections_Setting__mdt>();
        String Str = 'SELECT Sections__c FROM LnP_License_Type_Sections_Setting__mdt WHERE Board__c = \'' +applicationType+ '\' AND License_Type__c = \'' +credentialType+ '\' AND Application_Method__c = \''+applicationMethod+'\'';
        lstSections = Utilityclass_withsharing.queryRecords(Str);
        return lstSections;
    }
    
    public static List<MUSW__License2__c> fetLicenseDetails (Id licenseId) {
        List<MUSW__License2__c>  lstLicense = new List<MUSW__License2__c> ();
        for (MUSW__License2__c license  :  [SELECT Id,Name,Application_Type__c,Credential__c, Application_Method__c FROM  MUSW__License2__c WHERE Id = :licenseId] ){
            lstLicense.add(license);   
        }
        return lstLicense;
    }

}