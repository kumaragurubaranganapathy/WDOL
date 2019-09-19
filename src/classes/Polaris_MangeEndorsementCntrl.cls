public class Polaris_MangeEndorsementCntrl {
    
    @AuraEnabled(cacheable = true)
    public static String fetchData(String licId)
    {
        LnP_JSONParser ansWrapper; //to create Wrapper 
        String jsonApplicationFields = DOL_AppConstants.NULL_EMPTY_STRING + '';
        List<LnP_ApplyForLicenseWrapper> lstLicenseWrapper = new List<LnP_ApplyForLicenseWrapper>();
        //Map for Question Section
        Map<String,List<LnP_ApplyForLicenseWrapper.MapLabelToFields>> mapOnQuestions = new Map<String,List<LnP_ApplyForLicenseWrapper.MapLabelToFields>>();
        
        String questionSection = DOL_AppConstants.NULL_EMPTY_STRING + '';
        List<BGCK__Answer__c> lstAnswers = [SELECT id,Answer_Text__c,Question_Section__c,QuestionDOL__c,QuestionDOL__r.Sub_Sub_Header__c,QuestionDOL__r.Possible_Responses__c,QuestionDOL__r.Triggering_Parent_Answer__c,QuestionDOL__r.Sub_Header__c,QuestionDOL__r.Section__c,QuestionDOL__r.Submission_Title__c,QuestionDOL__r.Parent_Question__c,QuestionDOL__r.Has_dependent_questions__c,QuestionDOL__r.Data_Type__c,QuestionDOL__r.Id,QuestionDOL__r.Question_Body__c FROM BGCK__Answer__c Where License__c =:licId and Question_Section__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Endorsement' order by Question_Order__c ];
        for(BGCK__Answer__c answ : lstAnswers )
        {
            LnP_ApplyForLicenseWrapper.MapLabelToFields labelToFields = new LnP_ApplyForLicenseWrapper.MapLabelToFields();
            labelToFields.label = answ.QuestionDOL__r.Question_Body__c;
            labelToFields.labelId = answ.QuestionDOL__r.Id;
            labelToFields.fieldType = answ.QuestionDOL__r.Data_Type__c;
            labelToFields.answerId = answ.Id;
            labelToFields.hasChild = answ.QuestionDOL__r.Has_dependent_questions__c;
            labelToFields.parentQuestionId = answ.QuestionDOL__r.Parent_Question__c;
            //labelToFields.submissionDetails = answ.Question__r.Submission_Title__c;
            labelToFields.questionSectionClass = answ.QuestionDOL__r.Section__c;
            if(questionSection == answ.QuestionDOL__r.Section__c || answ.QuestionDOL__r.Section__c==null)
            {
                labelToFields.questionSection = DOL_AppConstants.NULL_EMPTY_STRING + 'null';
            }
            else
            {
                labelToFields.questionSection = answ.QuestionDOL__r.Section__c;
                questionSection = answ.QuestionDOL__r.Section__c;
                labelToFields.questionSectionDetail = answ.QuestionDOL__r.Sub_Header__c;
            }
            if(answ.QuestionDOL__r.Parent_Question__c != null)
            {
                labelToFields.isChild = true;
                labelToFields.renderedOnUi = false;
            }
            else
            {
                labelToFields.isChild = false;
                labelToFields.renderedOnUi = true;
            }
            //labelToFields.fieldAPIName = answ.Question__r.QuestionFieldAPI__c;
            //labelToFields.fieldObjName = answ.Question__r.QuestionObjectName__c;
            labelToFields.conditionalAnswer = answ.QuestionDOL__r.Triggering_Parent_Answer__c;
            if(answ.QuestionDOL__r.Possible_Responses__c != null && answ.QuestionDOL__r.Data_Type__c == 'Picklist')
            {
                labelToFields.fieldValueOptions = answ.QuestionDOL__r.Possible_Responses__c.split(';');
            }
            else if(answ.QuestionDOL__r.Possible_Responses__c != null && (answ.QuestionDOL__r.Data_Type__c == 'Radio'||answ.QuestionDOL__r.Data_Type__c == 'Checkbox'||answ.QuestionDOL__r.Data_Type__c == 'Yes_No'))
            { 
                for(String radio : answ.QuestionDOL__r.Possible_Responses__c.split(';')){
                    LnP_ApplyForLicenseWrapper.MapRadioButtons radioMap = new LnP_ApplyForLicenseWrapper.MapRadioButtons();
                    radioMap.label = radio;
                    radioMap.value = radio;
                    labelToFields.radioValueOptions.add(radioMap);
                }
            }
            labelToFields.value = answ.Answer_Text__c;
            if(ansWrapper != null && ansWrapper.compositeRequest != null)
            {
                for(LnP_JSONParser.CompositeRequest req : ansWrapper.compositeRequest)
                {
                    if(req.body!=null && req.body.Question == answ.QuestionDOL__r.Id)
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
            
            if(mapOnQuestions.containsKey(answ.QuestionDOL__r.Sub_Sub_Header__c))
            {
                mapOnQuestions.get(answ.QuestionDOL__r.Sub_Sub_Header__c).add(labelToFields);
            }
            else
            {
                mapOnQuestions.put(answ.QuestionDOL__r.Sub_Sub_Header__c,new List<LnP_ApplyForLicenseWrapper.MapLabelToFields>{labelToFields});  
            }
        }
        LnP_ApplyForLicenseWrapper licenseWrapper = new LnP_ApplyForLicenseWrapper();
        if(!mapOnQuestions.isEmpty() && mapOnQuestions.containsKey('Endorsement'))
        {
            licenseWrapper.labelFieldsMap.addAll(mapOnQuestions.get('Endorsement'));
        }
        lstLicenseWrapper.add(licenseWrapper);
        return JSON.serialize(lstLicenseWrapper); 
    }
    
    
        @AuraEnabled
    public static List<String> fetchEndorsementTypeData(String licenseType)
    {
        List<Endorsement_Add_Selection__mdt> lstEndoTypesMetaData = [Select id,Endorsement_Types__c,License_Type__c FROM Endorsement_Add_Selection__mdt WHERE License_Type__c=:licenseType ];
        List<String> lstEndoTypes = new List<String>();
        String endoType;
        if(!lstEndoTypesMetaData.isEmpty())
        {
            for(Endorsement_Add_Selection__mdt endo : lstEndoTypesMetaData )
            {
                endoType = endo.Endorsement_Types__c;
            }
        }        
        if(endoType != null)
        {
            lstEndoTypes = endoType.split(',');
        }
        system.debug('endoType--'+endoType);
        system.debug('lstEndoTypes--'+lstEndoTypes);
        return lstEndoTypes;
    }
    
    @AuraEnabled
    public static Integer fetchAssociations(String licId)
    {
        List<Associations__c> lstassociation = [SELECT id,Parent_License__c FROM Associations__c WHERE Parent_License__c=:licId AND Status__c=: DOL_AppConstants.NULL_EMPTY_STRING + 'Active' AND (Parent_License_Type__c=: DOL_AppConstants.NULL_EMPTY_STRING + 'Certified General Appraiser' OR Parent_License_Type__c=: DOL_AppConstants.NULL_EMPTY_STRING + 'Certified Residential Appraiser')];
        
        return lstassociation.size();
    }
     @AuraEnabled
    public static List<Endorsement__c> insertEndorsement(String licId, String licenseType)
    {
        return [SELECT id,Date_Requested_for_Adding_Endorsement__c,Endorsement_Type__c,License_Type__c,License__c,Status__c FROM Endorsement__c where License__c =:licId AND Status__c!='Canceled' ];
    }
    
    @AuraEnabled
    public static List<Electronic_Notary_Provider_Information__c> fetchProvider(String endoId)
    {
        return [SELECT id,Description__c,Effective_Date__c,Provider_Name__c FROM Electronic_Notary_Provider_Information__c where Endorsement__c =:endoId ];
    }
    
    @AuraEnabled
    public static Void removeProvider(String providerId)
    {
       Electronic_Notary_Provider_Information__c prov = [SELECT id,Description__c,Effective_Date__c,Provider_Name__c FROM Electronic_Notary_Provider_Information__c where Id =:providerId ];
        delete prov;
    }
    
    @AuraEnabled
    public static void removeEndorsement (String endoId)
    {
        Endorsement__c endo = [SELECT id,Status__c,License_Type__c FROM Endorsement__c where id =:endoId  ];
        if(endo.License_Type__c == 'Notary Public')
        {
            endo.Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Remove';
        }
        else
        {
            endo.Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Pending Remove';
        }        
        update endo;
    }
    
    @AuraEnabled
    public static String insertRequest(String licId,String licenseType, String board)
    {
        List<User> userInfoData = new  List<User>();
        String queryCondition = DOL_AppConstants.NULL_EMPTY_STRING + ' Id=\''+UserInfo.getUserId()+'\'';
        System.debug('User Id ' + queryCondition);
        String queryStr = DOL_AppConstants.NULL_EMPTY_STRING + 'SELECT Username, ContactId, Contact.Name, Contact.AccountId, Contact.Account.Name FROM User WHERE  '+queryCondition + 'Limit 1';
        system.debug('queryStr '+queryStr);
        
        userInfoData = Utilityclass_withsharing.queryRecords(queryStr);
        Id getContactId = DOL_AppConstants.NULL_EMPTY_STRING + '003r000000EOhBB';
        if(userInfoData[0].ContactId != null){
            getContactId = userInfoData[0].ContactId;
        }
        system.debug('licenseType'+licenseType+'board');
        Request__c application = new Request__c();
        application.Profession__c = board; 
        application.License_Type__c = licenseType;        
        application.Stage__c = 0;
        application.Service_Request_Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Endorsement';
        application.Contact__c = getContactId;
        application.License__c = licId;    
        try{
          
            insert application;
        }
        catch(Exception e){
            HandleException.LogException(e,'Polaris_MangeEndorsementCntrl','insertRequest');            
        }
        string appId = DOL_AppConstants.NULL_EMPTY_STRING + '';
        return appId = application.Id;
        
    }
    @AuraEnabled
    public static void updateEndorsement(String dataString,String licId, String licenseType)
    {
        List<BGCK__Answer__c> lstUpdateAnswers = new List<BGCK__Answer__c>();
        Set<String> setEndorsementType = new Set<String>();
        List<BGCK__Answer__c> lstAnswers = [SELECT id,Endorsement_Type__c,Answer_Text__c,Question_Section__c,QuestionDOL__c,QuestionDOL__r.Sub_Sub_Header__c,QuestionDOL__r.Possible_Responses__c,QuestionDOL__r.Triggering_Parent_Answer__c,QuestionDOL__r.Sub_Header__c,QuestionDOL__r.Section__c,QuestionDOL__r.Submission_Title__c,QuestionDOL__r.Parent_Question__c,QuestionDOL__r.Has_dependent_questions__c,QuestionDOL__r.Data_Type__c,QuestionDOL__r.Id,QuestionDOL__r.Question_Body__c FROM BGCK__Answer__c Where License__c =:licId and Question_Section__c='Endorsement' order by Question_Order__c ];
        List<LnP_ApplyForLicenseWrapper> wrapperList = (List<LnP_ApplyForLicenseWrapper>)JSON.deserialize(dataString, List<LnP_ApplyForLicenseWrapper>.class);
        List<LnP_ApplyForLicenseWrapper.MapLabelToFields> listFields = new List<LnP_ApplyForLicenseWrapper.MapLabelToFields>();
        for(LnP_ApplyForLicenseWrapper objWrapper : wrapperList){
            listFields.addAll(objWrapper.labelFieldsMap);
            for(LnP_ApplyForLicenseWrapper.MapLabelToFields fieldMap : listFields){
                for(BGCK__Answer__c ans : lstAnswers)
                {
                    if(fieldMap.answerId == ans.id)
                    {
                        if(fieldMap.value != ans.Answer_Text__c)
                        {
                            ans.Answer_Text__c = fieldMap.value;
                            setEndorsementType.add(ans.Endorsement_Type__c);
                        }
                    }
                }
            }
        }
        system.debug('lstAnswers :'+lstAnswers);
        system.debug('setEndorsementType :'+setEndorsementType);
        update lstAnswers;
        List<Endorsement__c> lstEndorsement = [SELECT id,Status__c,License__c,Endorsement_Type__c,Date_Requested_for_Adding_Endorsement__c FROM Endorsement__c where License__c =:licId ];
        map<String, Endorsement__c> mapEndorsement= new  map<String, Endorsement__c>();
        for(Endorsement__c endo : lstEndorsement)
        {
            String key = endo.Endorsement_Type__c+'_'+endo.Status__c;
            system.debug('key'+key);
            mapEndorsement.put(key,endo);
        }
        List<Endorsement__c> lstNewEndorsement = new List<Endorsement__c> ();
        Set<Endorsement__c> setNewEndorsement = new Set<Endorsement__c> ();
        for(String endoType : setEndorsementType)
        {
            String insideKey = endoType+'_Active' ;         
               
                if(!mapEndorsement.isEmpty() && mapEndorsement.containsKey(insideKey))
                {
                    mapEndorsement.get(insideKey).Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Pending Remove';
                }
                else
                {                    
                    Endorsement__c newEndo = new Endorsement__c();
                    newEndo.Endorsement_Type__c = endoType;
                    newEndo.Date_Requested_for_Adding_Endorsement__c = System.today();
                    newEndo.License_Type__c = licenseType;
                    newEndo.License__c = licId;
                    system.debug('newEndo :'+newEndo);
                    setNewEndorsement.add(newEndo);   
                }
            
        }
        
        lstNewEndorsement.addAll(setNewEndorsement);
        lstEndorsement = mapEndorsement.values();
        system.debug('lstEndorsement : '+lstEndorsement);
        system.debug('lstNewEndorsement : '+lstNewEndorsement);
        update lstEndorsement;
        insert lstNewEndorsement;
    }
}
