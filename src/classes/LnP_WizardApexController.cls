public class LnP_WizardApexController {
    
    @AuraEnabled
    public static Map<String,Question__c> questionForLicenceTyep(String Board, String LicenseType, String ApplicationType, String parentObjectAPIName){
        Map<String,Question__c> LabelMap = new Map<String,Question__c>();
        Map<String,String> questionMap = new Map<String,String>();
        List<String> picklistValues = new List<String>();
        system.debug('applicationType: '+ applicationType);
        list<Question__c> QuestionList = new list<Question__c>();
        String condition = 'Application_Type__c = \''+Board+'\'';
        String condition1 = 'Credential_Type__c = \''+LicenseType+'\'';
        //Changes done for adding eligibility type
        String condition3 = /*ApplicationType != '' ? 'Record_Type_Name__c = \'Application questions\'' : */'Record_Type_Name__c = \'Eligibility Questions\'';
        String condition4 = 'Status__c = \'Active\'';
        String condition5 = 'Application_Method__c = \''+ApplicationType+'\'';
        String condition6 = 'Parent_Object_API_Name__c = \''+parentObjectAPIName+'\'';
        
        String Str ='';
        //if(string.isEmpty(ApplicationType)){
          //   Str = 'Select Id, Eli_Ques_determines_App_Type__c, Name, Board__c, Question_Body__c, Data_Type__c, Possible_Responses__c, License_Type__c, ApplicationType__c, Expected_Answer_To_Show_Question__c, Qualifying_Response_for_App_Type__c, Parent_Question__c, hasEligibilityQuestions__c,Order_Number__c from LnP_Question1__c where '+condition+' AND '+condition1+/*' AND '+condition2+*/' AND '+condition3+' AND '+condition4+' ORDER BY Order_Number__c ASC';
        //  Str = 'Select Id, Eli_Ques_determines_App_Type__c, Name, Board__c, Question_Body__c, Data_Type__c, Possible_Responses__c, License_Type__c, ApplicationType__c, Expected_Answer_To_Show_Question__c, Qualifying_Response_for_App_Type__c, Parent_Question__c, hasEligibilityQuestions__c,Order_Number__c from LnP_Question1__c where '+condition+' AND '+condition1+/*' AND '+condition2+*/' AND '+condition3+' AND '+condition4+' ORDER BY Order_Number__c ASC';
         Str = 'Select Id, Eli_Ques_determines_App_Type__c, Name, Question_Body__c, Data_Type__c, Qualifying_Response__c,Possible_Responses__c, Application_Method__c, Parent_Question__c,Order_Number__c from Question__c where '+condition+' AND '+condition1+' AND '+condition5+' AND '+condition3+' AND '+condition4+' AND '+condition6+' ORDER BY Order_Number__c ASC';
        system.debug('str1'+str);
        /*} else {
            String condition2 = 'ApplicationType__c = \''+ApplicationType+'\'';
            Str = 'Select Id, Name, Board__c, Question_Body__c, Data_Type__c, Possible_Responses__c, License_Type__c, ApplicationType__c,Expected_Answer_To_Show_Question__c,Parent_Question__c, hasEligibilityQuestions__c from LnP_Question1__c where '+condition+' AND '+condition1+' AND '+condition2+' AND '+condition3+' AND '+condition4+' ORDER BY Name ASC'; 
        }*/
        //String Str = 'Select Id, Name, Board__c, Question_Body__c, Data_Type__c, Possible_Responses__c, License_Type__c, ApplicationType__c,Expected_Answer_To_Show_Question__c,Parent_Question__c from LnP_Question1__c where '+condition+' AND '+condition1+/*' AND '+condition2+*/' AND '+condition3+' AND '+condition4+' ORDER BY Name ASC';
    
        QuestionList = Utilityclass_withsharing.queryRecords(Str);
        for(Question__c Ques : QuestionList){
            LabelMap.put(Ques.Id, Ques);
            system.debug('LabelMap---'+Ques);
        }
        return LabelMap;
    }
    //For Renewal
    @AuraEnabled
    public static Map<String,Question__c> questionForLicenceTyep(String Board, String LicenseType, String ApplicationType, String parentObjectAPIName, String renewalReinstate){
        Map<String,Question__c> LabelMap = new Map<String,Question__c>();
        Map<String,String> questionMap = new Map<String,String>();
        List<String> picklistValues = new List<String>();
        system.debug('applicationType: '+ applicationType);
        list<Question__c> QuestionList = new list<Question__c>();
        String condition = 'Application_Type__c = \''+Board+'\'';
        String condition1 = 'Credential_Type__c = \''+LicenseType+'\'';
        //Changes done for adding eligibility type
        String condition3 = /*ApplicationType != '' ? 'Record_Type_Name__c = \'Application questions\'' : */'Record_Type_Name__c = \'Eligibility Questions\'';
        String condition4 = 'Status__c = \'Active\'';
        String condition5 = 'Application_Method__c = \''+ApplicationType+'\'';
        String condition6 = 'Parent_Object_API_Name__c = \''+parentObjectAPIName+'\'';
        String condition7 ='';
        if(renewalReinstate=='Renewal')
        {
            condition7 = 'AND Show_For__c includes (\'Credential Renewal\')';
        }
        else if(renewalReinstate=='Reinstate')
        {
            condition7 = 'AND Show_For__c includes (\'Credential Reinstatement\')';
        }
        
        String Str ='';
        
         Str = 'Select Id, Eli_Ques_determines_App_Type__c, Name, Question_Body__c, Data_Type__c, Qualifying_Response__c,Possible_Responses__c, Application_Method__c, Parent_Question__c,Order_Number__c from Question__c where '+condition+' AND '+condition1+' AND '+condition5+' AND '+condition3+' AND '+condition4+' AND '+condition6+'  '+condition7+'ORDER BY Order_Number__c ASC';
        system.debug('str1'+str);
        
    
        QuestionList = Utilityclass_withsharing.queryRecords(Str);
        for(Question__c Ques : QuestionList){
            LabelMap.put(Ques.Id, Ques);
            system.debug('LabelMap---'+Ques);
        }
        return LabelMap;
    }
    
    
    @AuraEnabled    
    public static AccountWrapper fetchAccountList(String Board, String LicenseType){
        List<Account>  lstAccount = new  List<Account>();
        system.debug('SELECT  IndividualBusinessType__c,Application_Type__c,Credential_Type__c FROM License_Type__mdt where Application_Type__c = :'+Board+'  and  Credential_Type__c =: '+LicenseType+'');
        List<License_Type__mdt> lstLicenseAccount =[SELECT  IndividualBusinessType__c,Application_Type__c,Credential_Type__c FROM License_Type__mdt where Application_Type__c = :Board  and  Credential_Type__c =:LicenseType Limit 1];
        system.debug('printlstLicenseAccount'+lstLicenseAccount);
        //string licenseAccountType ='';
        AccountWrapper acctwrapper = new AccountWrapper();
        if(!lstLicenseAccount.isEmpty()){
              acctwrapper.accountType =  lstLicenseAccount[0].IndividualBusinessType__c;
        }
        system.debug(lstLicenseAccount); 
        //acctwrapper.accountType = licenseAccountType;
        acctwrapper.lstAccount = getAccountList();
        /*if(licenseAccountType == 'Business'){
           lstAccount = getAccountList();
           system.debug('getList'+ lstAccount); 
        }*/
        system.debug('acctwrapper'+acctwrapper);
        return acctwrapper;
    }
   
    private static List<Account> getAccountList(){        
        List<User> userInfoData = new  List<User>();
        String queryCondition = ' Id=\''+UserInfo.getUserId()+'\'';
        String queryStr = 'SELECT Username, ContactId, Contact.Name, Contact.AccountId, Contact.Account.Name FROM User WHERE  '+queryCondition + 'Limit 1';
        Id getContactId;
        userInfoData = Utilityclass_withsharing.queryRecords(queryStr);
        Set<Id> setAcctId = new  Set<Id>();
        if(userInfoData[0].ContactId != null){
            getContactId = userInfoData[0].ContactId;
        }
        for (MUSW__Account_Contact__c ac : [SELECT Id, MUSW__Account__c,MUSW__Contact__c, MUSW__Account__r.Id,MUSW__Account__r.Name, MUSW__Account__r.Business_Alias__c from  MUSW__Account_Contact__c where MUSW__Contact__c =: getContactId])
        {
                   setAcctId.add(ac.MUSW__Account__r.Id);     
        }
        
        return [Select Id,Name From Account where id IN: setAcctId];
    }
    
    @AuraEnabled
    public static String fetchCnBLabels(String customLabelAPI, String board){
        Map<String, String> labelMap = new Map<String, String>();
        labelMap = LnP_AllBoardsLabels.fetchBoardLabel(board);
        String var = labelMap.get(customLabelAPI);
        return var;
    }
    @AuraEnabled
    public static Map<String, List<String>> getPicklistOptions(sObject sObj, String conField, String depField){ 
        Map<String, List<String>> mapConDep = new Map<String, List<String>>();
        mapConDep = LnP_dependentPicklist_UpdateCtrl.getDependentMap(sObj, conField, depField);
        system.debug('mapConDepJSON ' + JSON.serialize(mapConDep));
        return mapConDep;
    }
    @AuraEnabled
    public static Id startAnApplication(String board, String licenseType, String applicationType,String account){
        List<User> userInfoData = new  List<User>();
        String queryCondition = ' Id=\''+UserInfo.getUserId()+'\'';
        System.debug('User Id ' + queryCondition);
        String queryStr = 'SELECT Username, ContactId, Contact.Name, Contact.AccountId, Contact.Account.Name FROM User WHERE  '+queryCondition + 'Limit 1';
        system.debug('queryStr '+queryStr);
        system.debug('applicationType : '+applicationType);
        userInfoData = Utilityclass_withsharing.queryRecords(queryStr);
        Id getContactId = '003r000000EOhBB';
        if(userInfoData[0].ContactId != null){
            getContactId = userInfoData[0].ContactId;
        }
        //MUSW_Application2__c application = new MUSW_Application2__c();
       /* MUSW__Application2__c application = new MUSW__Application2__c();
        application.Board__c = board; 
        application.License_Type__c = licenseType; 
        application.Application_Type__c = applicationType; 
        application.Stage__c = 0;
        application.MUSW_Applicant__c = getContactId;
        
        application.MUSW_Account__c = account;*/
        
        MUSW__Application2__c application = new MUSW__Application2__c();
        application.Application_Type__c = board; 
        application.Credential_Type__c = licenseType; 
        application.Application_Method__c = applicationType; 
        application.Stage__c = 0;
        application.MUSW__Applicant__c = getContactId;
        application.MUSW__Account__c = account;
        
        try{
          
            insert application;
        }
        catch(Exception e){
            HandleException.LogException(e,'LnP_WizardApexController','startAnApplication');
        }

        return application.Id;
    }
    //For renewal
    @AuraEnabled
    public static Id startRenewalApplication(String board, String licenseType, String applicationType,String account, String isRenewal,String licId){
        List<User> userInfoData = new  List<User>();
        String queryCondition = ' Id=\''+UserInfo.getUserId()+'\'';
        String queryStr = 'SELECT Username, ContactId, Contact.Name, Contact.AccountId, Contact.Account.Name FROM User WHERE  '+queryCondition + 'Limit 1';
        system.debug('queryStr '+queryStr);
        system.debug('applicationType : '+applicationType);
        userInfoData = Utilityclass_withsharing.queryRecords(queryStr);
        Id getContactId = '003r000000EOhBB';
        if(userInfoData[0].ContactId != null){
            getContactId = userInfoData[0].ContactId;
        }   
        MUSW__License2__c lic = [Select id,RecordType.name,MUSW__Primary_Licensee__c,Application__c FROM MUSW__License2__c WHERE id =:licId];
        MUSW__Application2__c application = new MUSW__Application2__c();
        application.Application_Type__c = board; 
        application.Credential_Type__c = licenseType; 
        application.Application_Method__c = applicationType; 
        application.Stage__c = 0;
        application.MUSW__Applicant__c = getContactId;
        if(isRenewal != null && isRenewal != ''){
            application.isRenewal__c = Boolean.valueOf(isRenewal);   
        }
        if(lic.recordType.name == 'Business') {
            application.MUSW__Account__c = lic.MUSW__Primary_Licensee__c;
        }
        try{
            insert application;
        }
        catch(Exception e){
            HandleException.LogException(e,'LnP_WizardApexController','startAnApplication');
        }
        if(lic!=null)
        {
            lic.Application__c = application.Id;
            update lic;
        }
        
        List<LnP_Parcel__c>lstParcels = [Select id, Application_BG__c,City__c,Country__c,State_Province__c,Street__c,Zip_Postal_Code__c, Address_Type__c,License__c FROM LnP_Parcel__c where License__c=:licId];
        List<LnP_Parcel__c>lstupdateParcel = new List<LnP_Parcel__c>();
        if(!lstParcels.isEmpty())
        {
            for(LnP_Parcel__c par : lstParcels )
            {
                LnP_Parcel__c parcel = new LnP_Parcel__c();
                parcel.Application_BG__c = application.Id;
                parcel.Address_Type__c  = par.Address_Type__c;
                parcel.City__c = par.City__c;
                parcel.Country__c = par.Country__c;
                parcel.State_Province__c = par.State_Province__c;
                parcel.Street__c = par.Street__c;
                parcel.Zip_Postal_Code__c = par.Zip_Postal_Code__c;
                lstupdateParcel.add(parcel);
            }
        }

        if(!lstupdateParcel.isEmpty())
        {
            insert lstupdateParcel;
        }
        
        List<BGCK__Answer__c> lstAnswer = [SELECT id,Name,BGCK__Valid__c,Answer_Text__c,QuestionDOL__c,Question_Section__c,License__c,Application_BG__c FROM BGCK__Answer__c WHERE License__c=:licId ];
        List<BGCK__Answer__c> lstUpdateAnswer = new List<BGCK__Answer__c>();
        if(!lstAnswer.isEmpty())
        {
            for(BGCK__Answer__c ans : lstAnswer )
            {
                BGCK__Answer__c answer = new BGCK__Answer__c();
                answer.Application_BG__c = application.Id;
                answer.Name  = ans.Name;
                answer.BGCK__Valid__c = ans.BGCK__Valid__c;
                answer.Answer_Text__c = ans.Answer_Text__c;
                answer.QuestionDOL__c = ans.QuestionDOL__c;
                                
                lstUpdateAnswer.add(answer);
            }
        }

        if(!lstUpdateAnswer.isEmpty())
        {
            insert lstUpdateAnswer;
        }
        
        /*//Background Information
        List<LnP_BackgroundSection__c> bgckList = new List<LnP_BackgroundSection__c>();
        for(LnP_BackgroundSection__c bgck  : [select id,RecordTypeId,Application_BG__c ,Name_of_Institution__c,Degree__c,Major__c,Minor__c,Start_Date__c,End_date__c,State__c,Job_Title__c,Country__c,City__c,Employer__c,Zip_code__c,County__c,Total_Hours__c,Street_Address__c,Provider__c,Name_of_Course__c,Trainer_License__c,Credits__c,Hours__c FROM LnP_BackgroundSection__c WHERE Application_BG__c =:licId and RecordTypeID != null]){
            LnP_BackgroundSection__c bgSc = new LnP_BackgroundSection__c();
            bgSc.RecordTypeId = bgck.RecordTypeId;
            bgSc.Application_BG__c = application.Id;
            bgSc.Name_of_Institution__c = bgck.Name_of_Institution__c ;
            bgSc.Degree__c = bgck.Degree__c;
            bgSc.Major__c = bgck.Major__c;
            bgSc.Minor__c = bgck.Minor__c;
            bgSc.Name_of_Course__c = bgck.Name_of_Course__c;
            bgSc.Start_Date__c = bgck.Start_Date__c;
            bgSc.End_date__c = bgck.End_date__c;
            bgSc.Country__c = bgck.Country__c;
            bgSc.State__c = bgck.State__c;
            bgSc.Job_Title__c = bgck.Job_Title__c;
            bgSc.Country__c = bgck.Country__c;
            bgSc.City__c = bgck.City__c;
            bgSc.Employer__c = bgck.Employer__c;
            bgSc.Zip_code__c = bgck.Zip_code__c;
            bgSc.County__c = bgck.County__c;
            bgSc.Total_Hours__c = bgck.Total_Hours__c;
            bgSc.Street_Address__c  = bgck.Street_Address__C;
            bgSc.Provider__c = bgck.Provider__c;
            bgSc.Name_of_Course__c = bgck.Name_of_Course__c;
            bgSc.Trainer_License__c = bgck.Trainer_License__c;
            bgSc.Credits__c = bgck.Credits__c;
            bgSc.Hours__c = bgck.Hours__c;
            bgckList.add(bgSc);
        }
        if(!bgckList.isEmpty()){
            insert bgckList;
        }*/
        
        return application.Id;
    }
    @AuraEnabled
    public static Map<String,String> getAllStaticTexts(){
         Map<String, String> mapJSON = new Map<String, String>();
         try{
           mapJSON = DE_LandingPageCustomLabels.getWizardStaticTexts(); 
         }
         catch(Exception e){
            HandleException.LogException(e,'LnP_WizardApexController','getAllStaticTexts');
         } 
          
         return mapJSON;
    }
    
    public class accountWrapper{
       @AuraEnabled public String accountType {get;set;}
       @AuraEnabled public List<Account> lstAccount {get;set;}
    }

@AuraEnabled
    public  static String fetchInstructions(string Board, String LicenseType, String ApplicationType) {
        //select id,Instructions__c from Newsfeed__c where Application_Method__c =''  and  Application_Type__c =  and Credential_Type__c =''
         String result = '';
        String condition1 = 'Application_Type__c = \''+Board+'\'';
        String condition2 = 'Credential_Type__c = \''+LicenseType+'\'';
        String condition3 = 'Application_Method__c = \''+ApplicationType+'\'';
        list<Newsfeed__c> appInstructionList = new list<Newsfeed__c>();
        String Str = 'select id,Instructions__c from Newsfeed__c  where ' +condition1+' AND '+condition2+' AND '+condition3;       
        appInstructionList = Utilityclass_withsharing.queryRecords(Str);
        if(!appInstructionList.isEmpty()){
            result = appInstructionList[0].Instructions__c;
        }
        system.debug('@@@@result'+result);
              
        return result;
       
    }

}