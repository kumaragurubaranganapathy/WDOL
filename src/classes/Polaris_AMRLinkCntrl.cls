public class Polaris_AMRLinkCntrl {
    
    @AuraEnabled
    Public static List<AMR_Link__mdt> fetchServiceLinksServer(String board, String licenseType, String applicationMethod)
    {       
        return [SELECT id,MasterLabel,AMR_Type__c,Order_Number__c,Board__c,Service_Request_Type__c,License_Type__c,Application_Method__c FROM AMR_Link__mdt where Board__c =:board AND License_Type__c =:licenseType AND Application_Method__c=:applicationMethod ORDER BY Order_Number__c ASC  ];
    }
    @AuraEnabled
    public static String fetchAppId(String licId)
    {
        String appId = '';
        system.debug('licId : '+licId);
        if(licId!=null){
            MUSW__License2__c lic = [SELECT id,Application__c FROM MUSW__License2__c where id=:licId ];
            appId = lic.Application__c;
        }
        return appId;
    }
    
    //getMetada values in manage request
    @AuraEnabled
    public static AMR_Link__mdt getMetadata(String board,String ServiceRequestType,String licenseType){
      
      List<AMR_Link__mdt> listMdt = [ SELECT Sections__c,Generate_Fee__c FROM AMR_Link__mdt WHERE Board__c =:board AND License_Type__c =:licenseType AND Service_Request_Type__c =:ServiceRequestType];
      
      if(!listMdt.isEmpty()){
          return   listMdt[0];
      }else{
          return null;
      }
      
    }
    
    
    @AuraEnabled
    public static String fetchWebsiteInfo(String licId)
    {
        String websiteInfo = '';
        system.debug('licId : '+licId);
        if(licId!=null){
            MUSW__License2__c lic = [SELECT id,Website__c FROM MUSW__License2__c where id=:licId ];
            websiteInfo = lic.Website__c;
        }
        return websiteInfo;
    }
	
	@AuraEnabled
    public static Account fetchAccountInfo(String licId)
    {
        Account acct = null;
        list<Account> acctlist = [select id,name,ThirdPary_Billing_Code__c from account where id=:licId];
        system.debug('acctlist==='+acctlist);
        if(!acctlist.isEmpty())
        {
            acct = acctlist[0];
        }
        return acct;
    }
	
    @AuraEnabled
    public static void updateWebsiteInfo(String licId,String websiteInfo)
    {   
        system.debug('websiteInfo==='+ websiteInfo+'==licId=='+licId);
        if(String.isNotBlank(websiteInfo) && websiteInfo == 'createCode' && String.isNotBlank(licId)){
        String value = 'success';
        /*List<User> userInfoData = new  List<User>();
        String queryCondition = ' Id=\''+UserInfo.getUserId()+'\'';
        System.debug('User Id ' + queryCondition);
        String queryStr = 'SELECT Username, ContactId, Contact.Name, Contact.AccountId, Contact.Account.Name FROM User WHERE  '+queryCondition + 'Limit 1';
        system.debug('queryStr '+queryStr);
        userInfoData = Utilityclass_withsharing.queryRecords(queryStr);
        //system.debug('userInfoData==='+userInfoData);
        string AccountId= userInfoData[0].Contact.AccountId;
        //string AccountId= userInfoData[0].AccountId;*/
        list<account> acctlist = [select id,name,ThirdPary_Billing_Code__c from account where id=:licId];
        system.debug('acctlist==='+acctlist);
        if(!acctlist.isEmpty())
        {
            string randomcharacter= Polaris_AMRLinkCntrl.generateRandomString(6);  
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
            MUSW__License2__c lic = [SELECT id,Website__c FROM MUSW__License2__c where id=:licId ];
            lic.Website__c =  websiteInfo;
            update lic;
        }
    }
    @AuraEnabled
    public static String insertRequest(String licId,String licenseType, String board,String ServiceRequestType)
    {
        List<User> userInfoData = new  List<User>();
        String queryCondition = ' Id=\''+UserInfo.getUserId()+'\'';
        System.debug('User Id ' + queryCondition);
        String queryStr = 'SELECT Username, ContactId, Contact.Name, Contact.AccountId, Contact.Account.Name FROM User WHERE  '+queryCondition + 'Limit 1';
        system.debug('queryStr '+queryStr);
        
        userInfoData = Utilityclass_withsharing.queryRecords(queryStr);
        Id getContactId = '003r000000EOhBB';
        if(userInfoData[0].ContactId != null){
            getContactId = userInfoData[0].ContactId;
        }
        system.debug('licenseType'+licenseType+'board');
        Request__c application = new Request__c();
        application.Profession__c = board; 
        application.License_Type__c = licenseType;        
        application.Stage__c = 0;
        application.Service_Request_Type__c = ServiceRequestType;
        application.Contact__c = getContactId;
        if(licId != null && licId != ''){
            application.License__c = licId;  
        }  
        try
        {          
            insert application;
        }
        catch(Exception e){
            HandleException.LogException(e,'Polaris_AMRLinkCntrl','insertRequest');            
        }
        string appId = '';
        return appId = application.Id;
        
    }
    
    @AuraEnabled 
    public static List<selectListWrapper> getPickListData(String mainLicense){
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
    }
	@AuraEnabled 
    public static String createCodeValue(String test)
    {            
       system.debug('createcode===');
        String value = 'success';
        List<User> userInfoData = new  List<User>();
        String queryCondition = ' Id=\''+UserInfo.getUserId()+'\'';
        System.debug('User Id ' + queryCondition);
        String queryStr = 'SELECT Username, ContactId, Contact.Name, Contact.AccountId, Contact.Account.Name FROM User WHERE  '+queryCondition + 'Limit 1';
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
    }

    
    public static String generateRandomString(Integer len) {
    final String chars = '0123456789';
    String randStr = '';
    while (randStr.length() < len) {
       Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
       randStr += chars.substring(idx, idx+1);
    }
    return randStr; 
}

    
    //method to create application.
    @AuraEnabled
    public static Id createApplication(String board, String licenseType, String applicationType,String account,String LicenseUpgradeRecordID){
    
    Id applicationId = LnP_WizardApexController.startAnApplication(board,licenseType,applicationType,account,LicenseUpgradeRecordID);
    
    return applicationId;
    }
    
    public class selectListWrapper{
        @AuraEnabled public string label;
        @AuraEnabled public string value;
        @AuraEnabled public boolean selected;
    }
    
    
    
}