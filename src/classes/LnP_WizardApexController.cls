public class LnP_WizardApexController {
    
    @AuraEnabled
    public static List<MUSW__License2__c> fetchLicenseList(String Board, String LicenseType)
    {
        try{
        List<User> userInfoData = new  List<User>();
        String queryCondition = ' Id=\''+UserInfo.getUserId()+'\'';
        String queryStr = 'SELECT Username, ContactId, Contact.Name, Contact.AccountId, Contact.Account.Name FROM User WHERE  '+queryCondition + 'Limit 1';
        Id getContactId;
        userInfoData = Utilityclass_withsharing.queryRecords(queryStr);
        Set<Id> setAcctId = new  Set<Id>();
        if(userInfoData[0].ContactId != null){
            getContactId = userInfoData[0].ContactId;
        }
        Set<String>lstChildLicenseType = new Set<String>();
        List<Upgrade_License__mdt> lstupgradeLicense = [SELECT id,Child_License_Type__c,Upgrade_License_Type__c FROM Upgrade_License__mdt where Upgrade_License_Type__c=:LicenseType];
        for(Upgrade_License__mdt ul : lstupgradeLicense )
        {
            lstChildLicenseType.add(ul.Child_License_Type__c);
        }
        return [SELECT MUSW__Status__c,Credential_Type__c,Application_Type__c,Name,id FROM MUSW__License2__c where MUSW__Status__c='Active' AND MUSW__Applicant__c=:getContactId AND Credential_Type__c IN:lstChildLicenseType ];
        }
        catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            return null;
        }
    }
    @AuraEnabled
    public static Integer validationForTemporaryLicenses(String Board,String LicenseType,String ApplicationType,String parentObjectAPIName){
        try{
        Id loggedInUserID = UserInfo.getUserId();
        Id contactID;
        Integer noOfTempLicenses = 0;
        String[] tempLicenses = new List<String>();
        String temp = Label.Temporary_Licenses;
        tempLicenses = temp.split(',');
        List<MUSW__License2__c> lstLicenses = New List<MUSW__License2__c>();
        List<MUSW__License2__c> lstTempLicenses = New List<MUSW__License2__c>();
        system.debug('loggedInUserID');
        List<User> lstUser = [Select Id,ContactId from User where Id =:loggedInUserID];            
        if( lstUser != null && lstUser.size() > 0 )            
        {
            System.debug('lstUser[0].ContactId::' + lstUser[0].ContactId);
            contactID = lstUser[0].ContactId;
            system.debug('contactID--'+contactID);
        }
        lstLicenses = [SELECT Id,Name,Application_Type__c,Credential_Type__c,Application_Method__c,MUSW__Status__c,CreatedDate,
                       MUSW__Applicant__c FROM MUSW__License2__c WHERE MUSW__Applicant__c =: contactID AND Application_Type__c =: Board AND Credential_Type__c IN: tempLicenses AND CreatedDate = THIS_YEAR];
        
        system.debug('lstLicenses--'+lstLicenses);
        /*   if(!lstLicenses.isEmpty()){
for(MUSW__License2__c lic : lstLicenses ){
if(lic.Credential_Type__c == ){
lstTempLicenses.add(lic);
} 
} 
}*/
        
        system.debug('lstTempLicenses---'+lstTempLicenses);
        if(!lstLicenses.isEmpty()){
            noOfTempLicenses = lstLicenses.size();
        }
        system.debug('noOfTempLicenses---'+noOfTempLicenses);
        return noOfTempLicenses;
        }
        catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            return null;
        }
    }
    @AuraEnabled
    public static Map<String,Question__c> questionForLicenceTyep(String Board, String LicenseType, String ApplicationType, String parentObjectAPIName){
        try{
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
        catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            return null;
        }
    }
    //For Renewal
    @AuraEnabled
    public static Map<String,Question__c> questionForLicenceTyep(String Board, String LicenseType, String ApplicationType, String parentObjectAPIName, String renewalReinstate){
        try{
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
        else if(renewalReinstate=='Reinstatement')
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
        catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            return null;
        }
    }
    
    
    @AuraEnabled    
    public static AccountWrapper fetchAccountList(String Board, String LicenseType){
        try{
        List<Account>  lstAccount = new  List<Account>();
        List<License_Type__mdt> lstLicenseAccount =[SELECT  IndividualBusinessType__c,Application_Type__c,Credential_Type__c FROM License_Type__mdt where Application_Type__c = :Board  and  Credential_Type__c =:LicenseType Limit 1];
        string licenseAccountType ='';
        AccountWrapper acctwrapper = new AccountWrapper();
        if(!lstLicenseAccount.isEmpty()){
            acctwrapper.accountType =  lstLicenseAccount[0].IndividualBusinessType__c;
        } 
        if(!lstLicenseAccount.isEmpty() && (lstLicenseAccount[0].IndividualBusinessType__c == 'Business' || lstLicenseAccount[0].IndividualBusinessType__c == 'Course')){
            lstAccount = getAccountList();
            acctwrapper.lstAccount = lstAccount;
            system.debug('getList'+ lstAccount); 
        }
        system.debug('acctwrapper'+acctwrapper);
        return acctwrapper;
        }
        catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            return null;
        }
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
        
        return [Select Id,Name,Course_Provider__c, recordType.name From Account where id IN: setAcctId];
        
        
    }
    
    @AuraEnabled
    public static String fetchCnBLabels(String customLabelAPI, String board){
        try{
        Map<String, String> labelMap = new Map<String, String>();
        labelMap = LnP_AllBoardsLabels.fetchBoardLabel(board);
        String var = labelMap.get(customLabelAPI);
        return var;
        }
        catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            return null;
        }
    }
    @AuraEnabled
    public static Map<String, List<String>> getPicklistOptions(string sObj, String conField, String depField){ 
        try{
        Map<String, List<String>> mapConDep = new Map<String, List<String>>();
        MUSW__License2__c mapval = new MUSW__License2__c();
        mapConDep = LnP_dependentPicklist_UpdateCtrl.getDependentMap(mapval, conField, depField);
        system.debug('mapConDepJSON ' + JSON.serialize(mapConDep));
        return mapConDep;
        }
        catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            return null;
        }
    }
    @AuraEnabled
    public static Id startAnApplication(String board, String licenseType, String applicationType,String account,String LicenseUpgradeRecordID){
        try{
        List<User> userInfoData = new  List<User>();
        String queryCondition = ' Id=\''+UserInfo.getUserId()+'\'';
        System.debug('User Id ' + queryCondition);
        String queryStr = 'SELECT Username, ContactId, Contact.Name, Contact.AccountId, Contact.Account.Name FROM User WHERE  '+queryCondition + 'Limit 1';
        system.debug('queryStr '+queryStr);
        system.debug('applicationType : '+applicationType);
        userInfoData = Utilityclass_withsharing.queryRecords(queryStr);
        Id getContactId = null;
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
        
        List<String> branchLicense = new List<String>();
        branchLicense = System.Label.Branch_License_List.split(',');
        
        MUSW__Application2__c application = new MUSW__Application2__c();
        application.Application_Type__c = board; 
        application.Credential_Type__c = licenseType; 
        application.Application_Method__c = applicationType; 
        application.Stage__c = 0;
        application.MUSW__Status__c  = 'Draft';
        application.MUSW__Applicant__c = getContactId;
        if( account != '' && account != null && account !='undefined'){
            application.MUSW__Account__c = account;
        }
        if(branchLicense.contains(licenseType)){
            application.Branch_License__c = true;
            application.Parent_License__c = LicenseUpgradeRecordID;
        }else{
            application.Upgrading_License__c = LicenseUpgradeRecordID;
        }
        try{
            
            insert application;
            system.debug('application---'+application.MUSW__Account__c);
        }
        catch(Exception e){
            HandleException.LogException(e,'LnP_WizardApexController','startAnApplication');
        }
        system.debug('appId : '+application.Id);
        return application.Id;
        }
        catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            return null;
        }
    }
    //For renewal
    @AuraEnabled
    public static Id startRenewalApplication(String board, String licenseType, String applicationType,String account, String isRenewal,String licId){
        try{
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
        MUSW__License2__c lic = [Select id,RecordType.name,MUSW__Primary_Licensee__c,Ultimate_Parent_Account__c,Application__c FROM MUSW__License2__c WHERE id =:licId];
        MUSW__Application2__c application = new MUSW__Application2__c();
        application.Application_Type__c = board; 
        application.Credential_Type__c = licenseType; 
        application.Application_Method__c = applicationType; 
        application.Stage__c = 0;
        application.MUSW__Status__c  = 'Draft';
        application.MUSW__Applicant__c = getContactId;
        if(isRenewal != null && isRenewal != ''){
            application.isRenewal__c = Boolean.valueOf(isRenewal);   
        }
        if(lic.recordType.name == 'Business' || lic.recordType.name == 'Course' ) {
            application.MUSW__Account__c = lic.Ultimate_Parent_Account__c;
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
            lic.Renew_Reinstatement_in_progress__c = true;
            update lic;
        }
        Set<Id> parcelIds = new Set<Id>();
        List<MUSW__Parcel__c>lstParcels = new List<MUSW__Parcel__c>();
        for(MUSW__License_Parcel__c licenseParcelInstance : [Select Id, MUSW__License2__c, MUSW__Parcel__c From MUSW__License_Parcel__c 
                                                             where MUSW__License2__c=:licId]){
            parcelIds.add(licenseParcelInstance.MUSW__Parcel__c);
        }
        if(!parcelIds.isEmpty()){
        lstParcels = [Select id, Application_BG__c,MUSW__Street2__c,MUSW__Unit__c,MUSW__City__c,MUSW__State__c,Zip_Postal_Code__c,Country__c,
                      Melissa_Address_Verified__c, is_Physical_and_Mailing_Address_Same__c,Address_Type__c, Canadian_provinces__c, County__c,
                      MUSW__Primary_Contact__c FROM MUSW__Parcel__c where Id IN :parcelIds];
                                                      }
        List<MUSW__Parcel__c>lstupdateParcel = new List<MUSW__Parcel__c>();
        if(!lstParcels.isEmpty())
        {
            for(MUSW__Parcel__c par : lstParcels )
            {
                MUSW__Parcel__c parcel = new MUSW__Parcel__c();
                parcel.MUSW__Primary_Contact__c = par.MUSW__Primary_Contact__c;
                parcel.Address_Type__c  = par.Address_Type__c;
                parcel.MUSW__City__c = par.MUSW__City__c;
                parcel.Country__c = par.Country__c;
                parcel.MUSW__State__c = par.MUSW__State__c;
                parcel.MUSW__Street2__c = par.MUSW__Street2__c;
                parcel.Zip_Postal_Code__c = par.Zip_Postal_Code__c;
                parcel.County__c = par.County__c ;
                parcel.is_Physical_and_Mailing_Address_Same__c = par.is_Physical_and_Mailing_Address_Same__c;
                lstupdateParcel.add(parcel);
            }
        }
        
        if(!lstupdateParcel.isEmpty())
        {
            insert lstupdateParcel;
        }
        
       /*  commented for not showing license answers in Renewal Application
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
        */
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
        catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            return null;
        }
    }
    @AuraEnabled
    public static Map<String,String> getAllStaticTexts(){
        try{
        Map<String, String> mapJSON = new Map<String, String>();
        try{
            mapJSON = DE_LandingPageCustomLabels.getWizardStaticTexts(); 
        }
        catch(Exception e){
            DOL_CreateErrorLog_Exception.logApplicationError(e);
        } 
        
        return mapJSON;
        }
        catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            return null;
        }
    }
    
    public class accountWrapper{
        @AuraEnabled public String accountType {get;set;}
        @AuraEnabled public List<Account> lstAccount {get;set;}
        @AuraEnabled public string noAccount {get;set;}
    }
    
    @AuraEnabled
    public  static List<String> fetchInstructions(String Board, String LicenseType, String ApplicationType, String Obj, String renewalReinstate, String upgradeLicenseIdValue) {
        try{
        System.debug('IDIDIDIDIDIDDID'+upgradeLicenseIdValue);
        List<String> result = new List<String>();
        String condition1 = 'Application_Type__c = \''+Board+'\'';
        String condition2 = 'Credential_Type__c = \''+LicenseType+'\'';
        String condition3 = 'Application_Method__c = \''+ApplicationType+'\'';
        String condition4 = 'Required__c = True'; 
        String condition5 = 'Active__c = True';
        String condition6 = 'Default__c = True';
        String condition7 = 'Object__c = \''+Obj+'\'';
        //String condition7 = 'Object__c = \'MUSW__License2__c\'';
       system.debug('test123::'+renewalReinstate);
        String condition8 = '';
        String condition9 = 'Order_No__c';
        MUSW__License2__c upgradeLicense = new MUSW__License2__c();
        if(upgradeLicenseIdValue!=null && upgradeLicenseIdValue!=''){
         upgradeLicense = [select id, Application_Type__c,Credential_Type__c from MUSW__License2__c where id=:upgradeLicenseIdValue limit 1];
        }
        String condition10 = 'Show_For_License__c = \''+upgradeLicense.Credential_Type__c+'\'';
        if(renewalReinstate=='Renewal')
        {
            condition8 = ' AND Show_For__c includes (\'Credential Renewal\')';
        }
        else if(renewalReinstate=='Reinstatement')
        {
            condition8 = ' AND Show_For__c includes (\'Credential Reinstatement\')';
        }
        list<Newsfeed__c> appInstructionList = new list<Newsfeed__c>();
        list<MUSW__Master_Submission_List__c> masterSubListOnAppInstrList = new list<MUSW__Master_Submission_List__c>();
        
        String Str1 = 'select id,Instructions__c from Newsfeed__c  where ' +condition1+' AND '+condition2+' AND '+condition3;       
        appInstructionList = Utilityclass_withsharing.queryRecords(Str1);
        system.debug('News Query::'+appInstructionList);
        String Str2 ='';
        if(ApplicationType == 'Upgrade' && upgradeLicenseIdValue != null){
          Str2 = 'SELECT Id, Name FROM MUSW__Master_Submission_List__c WHERE ' + condition1 + ' AND ' + condition2 + ' AND ' + condition3 + ' AND ' + condition4 + ' AND ' + condition5 + ' AND ' + condition10  + ' AND ' + condition7 + condition8 + ' ORDER BY ' + condition9;
         
        }
        else{
        Str2 = 'SELECT Id, Name FROM MUSW__Master_Submission_List__c WHERE ' + condition1 + ' AND ' + condition2 + ' AND ' + condition3 + ' AND ' + condition4 + ' AND ' + condition5 + ' AND ' + condition6  + ' AND ' + condition7 + condition8 + ' ORDER BY ' + condition9;
        }
        masterSubListOnAppInstrList = Utilityclass_withsharing.queryRecords(Str2);
        system.debug('MSL Query::'+masterSubListOnAppInstrList);
        
        if(!appInstructionList.isEmpty()){
            result.add(appInstructionList[0].Instructions__c);             
        }
        else{
            result.add('null');
        }
        if(!masterSubListOnAppInstrList.isEmpty()){
            for(MUSW__Master_Submission_List__c subm : masterSubListOnAppInstrList){
                result.add(subm.Name);
            }
        }
        system.debug('@@@@result'+result);
        
        return result;
        }
        catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            return null;
        }
    }
    @AuraEnabled
    public static Map<String,List<String>> fetchLicenseType(String typeOFLicense) {
        try{
        Map<String,List<String>> lstLicenseType = new  Map<String,List<String>> ();
         List<License_Type__mdt> lstlicenseTypess= new  List<License_Type__mdt>();
        if(typeOFLicense == 'Individual') {
                  lstlicenseTypess= [select Credential_Type__c, Application_Type__c from License_Type__mdt 
                                                    where Object_Name__c ='MUSW__License2__c'  and Record_type_Name__c =:typeOFLicense];  
        }  else {
              lstlicenseTypess= [select Credential_Type__c, Application_Type__c from License_Type__mdt 
                                                    where Object_Name__c ='MUSW__License2__c'  and Record_type_Name__c !='Individual'];  
        }

        for( License_Type__mdt license : lstlicenseTypess) 
        {
            if(lstLicenseType.containsKey(license.Application_Type__c)) {
                lstLicenseType.get(license.Application_Type__c).add(license.Credential_Type__c);
            } else {
                lstLicenseType.put(license.Application_Type__c, new List<String>{license.Credential_Type__c});
            }
        }
        return lstLicenseType;
        }
        catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            return null;
        }
       }
       
        
    
}