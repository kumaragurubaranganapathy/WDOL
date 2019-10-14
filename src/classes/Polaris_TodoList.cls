/*
Controller for ToDoList
*/
public without Sharing class  Polaris_TodoList{
    
    @AuraEnabled
    public static List<task> getTodoList(){
        
        //Status =:'Pending',
        User currentUser = [SELECT Name,Id,ContactId,Email from User Where ID = :UserInfo.getUserId() LIMIT 1];
        system.debug('currentUser :'+currentUser);
        Contact con = [Select id,Email FROM Contact where id=:currentUser.ContactId];
        return [select id,ActivityDate,Description,License_Application_Type__c,Subject,Email__c,isDCP__c,Child_License_Id__c,AccountId__c,Main_License_Type__c,Business_Name__c,Whatid,type,Parent_Licensee_Name__c,Parent_License_Name__c,Parent_License_Type__c,Parent_Profession__c,Child_Licensee_Name__c,Child_License_Name__c,Child_License_Type__c,Child_Profession__c,Expiration_Date__c,Designation__c from task where Status ='Pending' and Email__c=:con.Email ];
            
    }
    @AuraEnabled
     public static String insertEducationRequestInformation(String licId,String licenseType, String board,String ServiceRequestType,String ExamRecordId)
    {
        try{
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
        application.Exam__c = ExamRecordId;
        
        if(licId != null && licId != ''){
            application.License__c = licId;  
        }  
        try
        {          
            insert application;
        }
        catch(Exception e){
            HandleException.LogException(e,'ExamReschedule','insertRequest');            
        }
        string appId = '';
        return appId = application.Id;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            return null;
        }
    }
    @AuraEnabled
    public static String insertRequestInformation(String licId,String licenseType, String board,String ServiceRequestType){
        try{
        Id getContactId ; 
        List<User> userInfoData = new  List<User>();
        String queryCondition = ' Id=\''+UserInfo.getUserId()+'\'';
        System.debug('User Id ' + queryCondition);
        String queryStr = 'SELECT Username, ContactId, Contact.Name, Contact.AccountId, Contact.Account.Name FROM User WHERE  '+queryCondition + 'Limit 1';
        system.debug('queryStr '+queryStr);
        
        userInfoData = Utilityclass_withsharing.queryRecords(queryStr);
        
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
        application.License__c = licId;
        try
        {          
            insert application;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            
        }
        string appId = '';
        return appId = application.Id;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            return null;
        }
    }
    
    @AuraEnabled
    public static String fetchChildLicense(Id taskId)
    {
        try{
        Task ta =  [select id,Subject,Email__c,Child_License_Id__c,AccountId__c,Main_License_Type__c,Business_Name__c,Whatid,type,Parent_Licensee_Name__c,Parent_License_Name__c,Parent_License_Type__c,Parent_Profession__c,Child_Licensee_Name__c,Child_License_Name__c,Child_License_Type__c,Child_Profession__c,Designation__c from task where id =: taskId ];
        List<Associations__c> lstAssociation = [SELECT id, Status__c,Child_License__c,Child_License__r.MUSW__Expiration_Date__c From Associations__c where id=:ta.Whatid];
        for(Associations__c associ : lstAssociation)
        {
            associ.Status__c = 'Generate Fee';
        }        
        system.debug('lstAssociation from child : '+lstAssociation);
        if(!lstAssociation.isEmpty()){   
            ta.Sub_status__c = 'Accepted';
            update ta;
            update lstAssociation;
        }
        return ta.Child_License_Id__c;
    }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            return null;
        }
    }
    //method to insert Request
    @AuraEnabled
    public static String insertRequest(String accountContactId,String licenseType, String board,String ServiceRequestType){
        
        try{
        Id getContactId ; 
        List<User> userInfoData = new  List<User>();
        String queryCondition = ' Id=\''+UserInfo.getUserId()+'\'';
        System.debug('User Id ' + queryCondition);
        String queryStr = 'SELECT Username, ContactId, Contact.Name, Contact.AccountId, Contact.Account.Name FROM User WHERE  '+queryCondition + 'Limit 1';
        system.debug('queryStr '+queryStr);
        
        userInfoData = Utilityclass_withsharing.queryRecords(queryStr);
        
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
        application.Account_Contact__c = accountContactId;
        try
        {          
            insert application;
        }
        catch(Exception e){
            HandleException.LogException(e,'Polaris_AMRLinkCntrl','insertRequest');            
        }
        string appId = '';
        return appId = application.Id;   
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            return null;
        }
    }
    @AuraEnabled
    public static String updateTaskAMR(Id taskId,String subStatus){
        try{
            String message = '';
            task tskList = [select id,Whatid,Status,Sub_status__c from task where id=:taskId];
            
            tskList.Status = 'Completed';
            if(subStatus == 'Accepted'){
                tskList.Sub_status__c = 'Accepted';
            }else if(subStatus == 'Declined'){
                tskList.Sub_status__c = 'Declined';
            }
            update tskList;
            return 'Success';
    	}
        catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            return null;
        }
    }
    @AuraEnabled
    public static String updateTask(Id taskId,String subStatus){
        try{
        String message = '';
        task tskList = [select id,Whatid,Status,Sub_status__c from task where id=:taskId];
        
        tskList.Status = 'Completed';
        if(subStatus == 'Accepted'){
            tskList.Sub_status__c = 'Accepted';
        }else if(subStatus == 'Declined'){
            tskList.Sub_status__c = 'Declined';
        }
        
        List<MUSW__Account_Contact__c> accList = new List<MUSW__Account_Contact__c>();
        List<Associations__c> lstUpdateAssociation = new List<Associations__c>();
        User currentUser = [SELECT Id,ContactId , IsActive, IsPortalEnabled, MUSW__Successor__c, ProfileId , email from User Where ID = :UserInfo.getUserId() LIMIT 1];
        List<MUSW__Account_Contact__c> accConList = [select id,isAdminContact__c,MUSW__Contact__c,Account_Admin__c,Status__c from MUSW__Account_Contact__c where id=:tskList.Whatid];
        List<Associations__c> lstAssociation = [SELECT id, Status__c,Child_License__c,Child_License__r.MUSW__Expiration_Date__c From Associations__c where id=:tskList.Whatid];
        Set<Id> childLicenseIds = new Set<Id>();
        for(Associations__c asso : lstAssociation){
            childLicenseIds.add(asso.Child_License__c);
        }
        List<Associations__c> lstAssociationsOnChild = [SELECT Id,Child_License__c, Child_License__r.Name FROM Associations__c WHERE Child_License__c IN : childLicenseIds AND Status__c='Active' AND (Child_License_Type__c ='Timeshare Salesperson' OR Child_License_Type__c='Camping Resort Salesperson') ];
        
        for(MUSW__Account_Contact__c acc : accConList ){
            if(subStatus == 'Accepted'){
                acc.Status__c = 'Active';
                if(acc.isAdminContact__c){
                    acc.Account_Admin__c = true;
                    acc.MUSW__Contact__c = currentUser.ContactId;
                }
            }else{
                acc.Status__c = 'Declined';
            }
            accList.add(acc);
        }
        if(!accList.isEmpty()){
            update tskList;
            update accList;
            return 'Success';
        }else if(lstAssociationsOnChild.size() < 1){
            for(Associations__c associ : lstAssociation)
            {
                if(subStatus == 'Accepted'){
                    associ.Status__c = 'Active';
                    
                }else{
                    associ.Status__c = 'Declined';
                }
                lstUpdateAssociation.add(associ);
            }            
            if(!lstUpdateAssociation.isEmpty()){
                update tskList;
                update lstUpdateAssociation;
                return 'Success';
            }else{
                return 'Fail';
            }
        }
        else if(lstAssociationsOnChild.size() >= 1)
        {
            
            for(Associations__c associ : lstAssociation)
            {
                
                if(subStatus == 'Accepted'){
                    //associ.Status__c = 'Generate Fee';
                    Integer days = (associ.Child_License__r.MUSW__Expiration_Date__c != null) ? system.today().daysBetween(associ.Child_License__r.MUSW__Expiration_Date__c):0;
                    system.debug('days : '+days);
                    if(days < 120)
                    {
                        message = 'Pay Fee Near Expiration';
                    }
                    else
                    {
                        message = 'Pay Fee';
                    }
                }else{
                    associ.Status__c = 'Declined';
                }
                lstUpdateAssociation.add(associ);
            }
            system.debug('lstUpdateAssociation : '+lstUpdateAssociation);
            if(!lstUpdateAssociation.isEmpty() && subStatus == 'Accepted' ){
                //update tskList;
                //update lstUpdateAssociation;
                return message;
            }
            else if(!lstUpdateAssociation.isEmpty() && subStatus == 'Declined')
            {
                update tskList;
                update lstUpdateAssociation;
                return 'Success';
            }
        }
        return 'Fail';     
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            return null;
        }
    }
    
    @AuraEnabled
    public static boolean hasBusinessAccounts(){
        
        Boolean hasBusinessAccounts = true;
        
        try{
            
            List<Account> accList = Add_BusinessController.getAllAccounts();
            
            If(accList != null){
                
                if(accList.size()!=0){
                    
                    hasBusinessAccounts = true;
                    
                }else{
                    
                    hasBusinessAccounts = false;
                }
            }
            
            return hasBusinessAccounts;
            
        }catch(Exception Ex){
            
            DOL_CreateErrorLog_Exception.logApplicationError(Ex);
            return hasBusinessAccounts = true;
            
        
        }
   
    }
        @AuraEnabled
    public static boolean hasLicenses(){
        
        Boolean hasLicenses = true;
        
        try{
            
            List<MUSW__License2__c> accList = [select id from  MUSW__License2__c where owner.id =: UserInfo.getUserId() ];
            
            If(accList != null){
                
                if(accList.size()!=0){
                    
                    hasLicenses = true;
                    
                }else{
                    
                    hasLicenses = false;
                }
            }
            
            return hasLicenses;
            
        }catch(Exception Ex){
            
            return hasLicenses = true;
        }
    }
    public class ToDoWrapper{
        @AuraEnabled
        public string businessName;
        @AuraEnabled 
        public string subject;
        @AuraEnabled
        public string type;
        @AuraEnabled
        public string id;
        
    }
    @AuraEnabled
    public static String getContactName(){
        //Status =:'Pending',
        try{
        User currentUserDetails = [SELECT Name from User Where ID = :UserInfo.getUserId() LIMIT 1];
        return currentUserDetails.Name;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            return null;
        }
    }
    
    @AuraEnabled
    public static List<Account> getAllAccounts(){
        try{
        Set<Id> accntIdSet = new Set<Id>();
        List<Account> accList = new List<Account>();
        User currentUser = [SELECT Id, Name,firstName ,lastName, ContactId , IsActive, IsPortalEnabled, MUSW__Successor__c, ProfileId , email from User Where ID = :UserInfo.getUserId() LIMIT 1];
        List<MUSW__Account_Contact__c> accntConList = [SELECT Id,MUSW__Contact__c,Account_Admin__c,MUSW__Account__c,MUSW__Account__r.Name,MUSW__Account__r.Type_of_Ownership__c,
                                                       MUSW__Account__r.Security_Code__c,MUSW__Account__r.First_Name_Primary_Contact__c,MUSW__Account__r.Last_Name_Primary_Contact__c,MUSW__Account__r.Business_Alias__c ,MUSW__Account__r.Doing_Business_As_1__c ,MUSW__Account__r.Website,MUSW__Account__r.Phone_Primary_Contact__c,MUSW__Account__r.Fax,MUSW__Account__r.Email__c,
                                                       MUSW__Account__r.Email_Primary_Contact__c,MUSW__Account__r.FEIN_Number_Encrypted__c,MUSW__Account__r.Social_Security_Number_Encrypted__c,
                                                       MUSW__Account__r.UBI_Number__c,MUSW__Account__r.Extension__c,MUSW__Account__r.Business_Phone__c,Name 
                                                       FROM MUSW__Account_Contact__c WHERE MUSW__Contact__c =: currentUser.ContactId  AND MUSW__Account__c != null and Status__c = 'Active' and Account_Admin__c = true] ; 
        for(MUSW__Account_Contact__c accCon : accntConList ){
            accntIdSet.add(accCon.MUSW__Account__c);
        }
        if(accntIdSet!=null && !accntIdSet.isEmpty()){
            accList= [select Id,(select id,isAdminContact__c,Account_Admin__c from MUSW__Account_Contacts__r where MUSW__Contact__c = :currentUser.ContactId and Account_Admin__c =true),
                      Name,Type_of_Ownership__c,Doing_Business_As_1__c,First_Name_Primary_Contact__c,Last_Name_Primary_Contact__c,Phone_Primary_Contact__c,
                      UBI_Number__c,Email__c,Business_Phone__c,Extension__c,Website, Business_Website__c, Business_Structure__c, Business_Alias__c 
                      from Account where id in:accntIdSet];
        }
        else{
            
            
        }
        return accList;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            return null;
        }
    }
    
}