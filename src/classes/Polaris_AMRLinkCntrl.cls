public class Polaris_AMRLinkCntrl {
    
    @AuraEnabled
    Public static List<AMR_Link__mdt> fetchServiceLinksServer(String board, String licenseType, String applicationMethod)
    {       
        try{
        return [SELECT id,MasterLabel,AMR_Type__c,Order_Number__c,Board__c,Service_Request_Type__c,License_Type__c,Application_Method__c FROM AMR_Link__mdt where Board__c =:board AND License_Type__c =:licenseType AND Application_Method__c=:applicationMethod AND Display_In_Related_Tab__c=false ORDER BY Order_Number__c ASC  ];
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
            
    }
    
    @AuraEnabled
    public static String printUpdateLicense(String licId,String printType)
    {   
        try{
        string value= DOL_AppConstants.NULL_EMPTY_STRING + '';
        if(licId!=null){
            if(printType == 'download')
            {
                Set<Id> setConId = new Set<Id>();               
                for(ContentDocumentLink contDocLink:[SELECT ContentDocumentId,Id FROM ContentDocumentLink WHERE LinkedEntityId =:licId and LinkedEntityId!=null]) 
                {                   
                   setConId.add(contDocLink.ContentDocumentId);
                }
                if(!setConId.isEmpty()){
                    system.debug('--setConId'+setConId);
                ContentVersion conVersion = [SELECT CreatedDate,ContentDocumentId,Id,Title FROM ContentVersion WHERE ContentDocumentId IN:setConId and ContentDocumentId!=null AND (Title LIKE '%License_Certificate%' OR Title LIKE '%Self-print_Certificate%' ) AND Title!=null  ORDER BY CreatedDate DESC NULLS FIRST LIMIT 1];
            	return conVersion.ContentDocumentId;
                }  
            }
            else{             
            	MUSW__License2__c lic = [SELECT id,Print_License_Email__c,Print_License_DES__c,Application__c FROM MUSW__License2__c where id=:licId and id!=null];
               if(printType == 'email')
                {
                    lic.Print_License_Email__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Yes';
                }else if(printType=='DES')
                {
                    lic.Print_License_DES__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Yes';
                }
                try{
                    update lic;
                    return 'true';
                }catch(Exception e){
                    DOL_CreateErrorLog_Exception.logApplicationError(e);
                    throw new AuraHandledException('An error occurred: '+e.getMessage());
                }
                
            }
            
        }
        return value;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
        
    }
    
    @AuraEnabled
    public static String fetchAppId(String licId)
    {
        try{
        String appId = DOL_AppConstants.NULL_EMPTY_STRING + '';
        system.debug('licId : '+licId);
        if(licId!=null){
            MUSW__License2__c lic = [SELECT id,Application__c FROM MUSW__License2__c where id=:licId and id!=null];
            appId = lic.Application__c;
        }
        return appId;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
    }
    
    //getMetada values in manage request
    @AuraEnabled
    public static AMR_Link__mdt getMetadata(String board,String ServiceRequestType,String licenseType){
      
      try{
      List<AMR_Link__mdt> listMdt = [ SELECT Sections__c,Generate_Fee__c FROM AMR_Link__mdt WHERE Board__c =:board AND License_Type__c =:licenseType AND Service_Request_Type__c =:ServiceRequestType];
      
      if(!listMdt.isEmpty()){
          return   listMdt[0];
      }else{
          return null;
      }
      }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
      
    }
	@AuraEnabled
    public static String fetchBusinessInfo(String accId)
    {
        return [SELECT id,Name From Account where id=:accId].Name;
    }
    @AuraEnabled
    public static String fetchContactInfo()
    {
        try{
        List<User> userInfoData = new List<User>();
        String queryCondition = DOL_AppConstants.NULL_EMPTY_STRING + ' Id=\''+String.escapeSingleQuotes(UserInfo.getUserId())+'\'';
        String queryStr = DOL_AppConstants.NULL_EMPTY_STRING + 'SELECT Username, ContactId, Contact.Name, Contact.AccountId, Contact.Account.Name FROM User WHERE  '+queryCondition + 'Limit 1';
        userInfoData = Utilityclass_withsharing.queryRecords(queryStr);
        
        return [Select id,Full_Name__c FROM Contact where id=:userInfoData[0].Contact.Id].Full_Name__c;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
    }
    @AuraEnabled
    public static Account fetchAccountInfo(String licId)
    {
        try{
        Account acct = null;
        list<Account> acctlist = [select id,name,ThirdPary_Billing_Code__c from account where id=:licId];
        system.debug('acctlist==='+acctlist);
        if(!acctlist.isEmpty())
        {
            acct = acctlist[0];
        }
        return acct;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
    }
    
    @AuraEnabled
    public static String fetchWebsiteInfo(String licId)
    {
        try{
        String websiteInfo = DOL_AppConstants.NULL_EMPTY_STRING + '';
        system.debug('licId : '+licId);
        if(licId!=null){
            MUSW__License2__c lic = [SELECT id,Website__c FROM MUSW__License2__c where id=:licId and id!=null];
            websiteInfo = lic.Website__c;
        }
        return websiteInfo;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
    }
@AuraEnabled
    public static string updateWebsiteInfo(String licId,String websiteInfo)
    {   
         try{
         string randomcharacter= DOL_AppConstants.NULL_EMPTY_STRING + '';
        system.debug('websiteInfo==='+ websiteInfo+'==licId=='+licId);
        if(String.isNotBlank(websiteInfo) && websiteInfo == 'createCode' && String.isNotBlank(licId)){
        String value = DOL_AppConstants.NULL_EMPTY_STRING + 'success';
        /*List<User> userInfoData = new  List<User>();
        String queryCondition = DOL_AppConstants.NULL_EMPTY_STRING + ' Id=\''+UserInfo.getUserId()+'\'';
        System.debug('User Id ' + queryCondition);
        String queryStr = DOL_AppConstants.NULL_EMPTY_STRING + 'SELECT Username, ContactId, Contact.Name, Contact.AccountId, Contact.Account.Name FROM User WHERE  '+queryCondition + 'Limit 1';
        system.debug('queryStr '+queryStr);
        userInfoData = Utilityclass_withsharing.queryRecords(queryStr);
        //system.debug('userInfoData==='+userInfoData);
        string AccountId= userInfoData[0].Contact.AccountId;
        //string AccountId= userInfoData[0].AccountId;*/
        list<account> acctlist = [select id,name,ThirdPary_Billing_Code__c from account where id=:licId and id!=null];
        system.debug('acctlist==='+acctlist);
       
        if(!acctlist.isEmpty())
        {
             randomcharacter= Polaris_AMRLinkCntrl.generateRandomString(6);  
            system.debug('randomcharacter==='+randomcharacter);
            Account  accts= new Account();
            accts.id=acctlist[0].id;
            //accts.id=AccountId;
            accts.ThirdPary_Billing_Code__c=randomcharacter;
            system.debug('accts==='+accts);
            upsert  accts;
            }
        //return value;===============================
        }else{
            system.debug('dferfer'+ websiteInfo);
            MUSW__License2__c lic = [SELECT id,Website__c FROM MUSW__License2__c where id=:licId and id!=null];
            lic.Website__c =  websiteInfo;
            update lic;
        }
        return randomcharacter;
         }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
    }
    
   
    @AuraEnabled 
    public static String createCodeValue(String test)
    {            
       try{
       system.debug('createcode===');
        String value = DOL_AppConstants.NULL_EMPTY_STRING + 'success';
        List<User> userInfoData = new  List<User>();
        String queryCondition = ' Id=\''+sTRING.escapeSingleQuotes(UserInfo.getUserId())+'\'';
        System.debug('User Id ' + queryCondition);
        String queryStr = DOL_AppConstants.NULL_EMPTY_STRING + 'SELECT Username, ContactId, Contact.Name, Contact.AccountId, Contact.Account.Name FROM User WHERE  '+queryCondition + 'Limit 1';
        system.debug('queryStr '+queryStr);
        
        userInfoData = Utilityclass_withsharing.queryRecords(queryStr);
        system.debug('userInfoData==='+userInfoData);
        string AccountId= userInfoData[0].Contact.AccountId;
        list<account> acctlist = [select id,name,ThirdPary_Billing_Code__c from account where id=:AccountId];
        system.debug('acctlist==='+acctlist);
        if(!acctlist.isEmpty())
        {
            string randomcharacter= Polaris_AMRLinkCntrl.generateRandomString(5);  
            Account  accts= new Account();
            accts.id=acctlist[0].id;
            accts.ThirdPary_Billing_Code__c=randomcharacter;
            system.debug('accts==='+accts);
            upsert  accts;
            }
        return value;
       }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
    }

    
    public static String generateRandomString(Integer len) {
    try{
    final String chars = DOL_AppConstants.NULL_EMPTY_STRING + '0123456789';
    String randStr = DOL_AppConstants.NULL_EMPTY_STRING + '';
    while (randStr.length() < len) {
       Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
       randStr += chars.substring(idx, idx+1);
    }
    return randStr; 
    }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
}
    
    @AuraEnabled
    public static String insertRequest(String licId,String licenseType, String board,String ServiceRequestType,String acctId)
    {
        try{
        List<User> userInfoData = new  List<User>();
        String queryCondition = DOL_AppConstants.NULL_EMPTY_STRING + ' Id=\''+String.escapeSingleQuotes(UserInfo.getUserId())+'\'';
        System.debug('User Id ' + queryCondition);
        String queryStr = DOL_AppConstants.NULL_EMPTY_STRING + 'SELECT Username, ContactId, Contact.Name, Contact.AccountId, Contact.Account.Name FROM User WHERE  '+queryCondition+ 'Limit 1';
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
        application.Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Draft';
        application.Service_Request_Type__c = ServiceRequestType;
        application.Contact__c = getContactId;
		if(acctId != null && acctId != ''){
                application.Account__c = acctId;  
            }  
        if(licId != null && licId != ''){
            application.License__c = licId;  
        }  
        try
        {          
            insert application;
        }
        catch(Exception e){
            DOL_CreateErrorLog_Exception.logApplicationError(e);
            throw new AuraHandledException('An error occurred: '+e.getMessage());
        }
        string appId = DOL_AppConstants.NULL_EMPTY_STRING + '';
        return appId = application.Id;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
        
    }
    
    @AuraEnabled 
    public static List<selectListWrapper> getPickListData(String mainLicense){
    try{
    List<String> str = new List<String>();
    List<selectListWrapper> listWrapper = new List<selectListWrapper>();
    List<Branch_License__mdt> brachList = [select id,MasterLabel,Branch_License__c,Main_License__c from Branch_License__mdt where Main_License__c =:mainLicense];
        if(!brachList.isEmpty()){
            str = brachList[0].Branch_License__c.split(',');
        }
      for(String s : str){
           selectListWrapper slw = new selectListWrapper();
           slw.label = s;
           slw.value = s;
           slw.selected = true;
           listWrapper.add(slw);
      }
      return listWrapper;
    }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
    }
    
    //method to create application.
    @AuraEnabled
    public static Id createApplication(String board, String licenseType, String applicationType,String account,String LicenseUpgradeRecordID){
    try{
    Id applicationId = LnP_WizardApexController.startAnApplication(board,licenseType,applicationType,account,LicenseUpgradeRecordID);
    
    return applicationId;
    }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
    }
    
    public class selectListWrapper{
        @AuraEnabled public string label;
        @AuraEnabled public string value;
        @AuraEnabled public boolean selected;
    }
    
    
    
}