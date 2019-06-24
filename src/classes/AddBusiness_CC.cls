/**************************************************************************************************************
**************************************************************************************************************
** Name             : AddBusiness_CC
** Description      : Controller for business information and adding business licenses
** Version          : 1.0
** Built By         : Srikanth Kottam
**------------------------------------------------------------------------------------------------------------------------
** Modification Log:
**--------------------------
** Developer                    Date                       Version             Description
**------------------------------------------------------------------------------------------------------------------------
															
** Review Log:
**---------------
** Reviewer                     Date                    Version             Description
**------------------------------------------------------------------------------------------------------------------------
**
**************************************************************************************************************/

public without sharing class AddBusiness_CC 
{
    public static final String COMMUNITY_PLUS_PROFILE = 'eSLA Customer Community Plus Login User';
    public List<SelectOption> registeredAsOptions {get;set;}
    
    public String secCode {get;set;}  
    public String primaryParcelId {get;set;}
    public String mailingParcelId {get;set;}
    public User currentUser;
    public Id commPlusProfileId;
    public Boolean isCommunityPlusUser{get;set;}
    
/*    public List<License_Relationship__c> mybusinesAffliationsrecords;
    public List<License_Relationship__c> mybusinesAffliations;
    public Map<Id,License_Relationship__c> mybusinesAffliations1;
*/    
    public String newAccountName {get;set;}
    public Account newAccount {get;set;}
    public String AccountId {get;set;}
    public String BusIdChosen {get;set;}
    public String EmpIdChosen {get;set;}
    public boolean isCasinoContact{get;set;}
    public boolean firstThreeMonths{get;set;}
    public boolean isSoleProprietorship{get; set;}
   
    public List<ManageBusinessWrapper> mybusinessList {
        get{
            if(mybusinessList == null){
                List<MUSW__Account_Contact__c> busList =  [SELECT 
                           Id, 
                           MUSW__Contact__c, 
                           MUSW__Account__c,
                           MUSW__Account__r.Name,
                           MUSW__Account__r.Type_of_Ownership__c,
                           MUSW__Account__r.Security_Code__c , 
                           MUSW__Account__r.First_Name_Primary_Contact__c,
                           MUSW__Account__r.Last_Name_Primary_Contact__c,
                           MUSW__Account__r.Business_Alias__c ,
                           MUSW__Account__r.Doing_Business_As_1__c ,                               
                           MUSW__Account__r.Website,
                           MUSW__Account__r.Phone_Primary_Contact__c,
                           MUSW__Account__r.Fax,
                           MUSW__Account__r.Email__c,
                           MUSW__Account__r.Email_Primary_Contact__c,
                           MUSW__Account__r.FEIN_Number_Encrypted__c,
                           MUSW__Account__r.Social_Security_Number_Encrypted__c,
                           MUSW__Account__r.UBI_Number__c, 	//Dharan Shah -- adding UBI number for Business Account -- 03/26
                           MUSW__Account__r.Extension__c,	//Dharan Shah -- adding Extension for Business Account -- 03/27
                           MUSW__Account__r.Business_Phone__c,	//Dharan Shah -- adding Business Phone number for Business Account -- 03/27
                           Name FROM MUSW__Account_Contact__c WHERE MUSW__Contact__c =: currentUser.ContactId  AND MUSW__Account__c != null and Associate_Status__c = 'Active' ];
                           
                  Set<Id> setAccountIds = new Set<Id>();
                  for(MUSW__Account_Contact__c bus : busList){
                    setAccountIds.add(bus.MUSW__Account__c);
                  }
                  
              /*    Map<Id, List<License_Relationship__c>> mapLicRelationships = new Map<Id, List<License_Relationship__c>>();
                  //Start of changes for Bug: 49328 -- Display only Employee relationship record type under my employees list in portal
                  Id AffrecTypId = Schema.SObjectType.License_Relationship__c.getRecordTypeInfosByName().get(label.RT_Employee_Relationship_Record_Type).getRecordTypeId();
                  //for(License_Relationship__c licRel : [Select id, Name, Supervisee__c, Supervisee_License__r.Name,Supervisee__r.Name,Unlicensed_Supervisee__c, Supervisor_Business__c from License_Relationship__c where Supervisor_Business__c IN :setAccountIds]){
                  for(License_Relationship__c licRel : [Select id, Name, Supervisee__c, Supervisee_License__r.Name,Supervisee__r.Name,Unlicensed_Supervisee__c, Supervisor_Business__c from License_Relationship__c where Supervisor_Business__c IN :setAccountIds and RecordTypeId =: AffrecTypId]){
                  //End of changes    
                        List<License_Relationship__c> lstLicRelationships = mapLicRelationships.get(licRel.Supervisor_Business__c);
                        if(lstLicRelationships == null){
                            lstLicRelationships = new List<License_Relationship__c>();
                        }
                        lstLicRelationships.add(licRel);
                        
                        mapLicRelationships.put(licRel.Supervisor_Business__c, lstLicRelationships);
                  }
                  */
                  mybusinessList = new List<ManageBusinessWrapper>();
                  for(MUSW__Account_Contact__c bus : busList){
                        ManageBusinessWrapper wrapper = new ManageBusinessWrapper();
                        wrapper.mybusiness = bus;
                    //    wrapper.myAffiliations = mapLicRelationships.get(bus.MUSW__Account__c);
                        
                        mybusinessList.add(wrapper);
                      system.debug('Wrapper>>>>>>>>>>>'+wrapper);
                  }
                  
            }
            system.debug('mybusinessList>>>>>>>>>>'+mybusinessList);
            return mybusinessList;
            
        }
        set;
    }
    
    public String getUserInfoJSON(){
        return JSON.serialize(currentUser) ;
    }
      public AddBusiness_CC() {
        registeredAsOptions = new List<SelectOption>{
            new SelectOption('novalue','-- Select --')
                
        } ;
      //  mybusinesAffliations = new List<License_Relationship__c>();
        
        for(Schema.PicklistEntry f : Account.Type_of_Ownership__c.getDescribe().getPicklistValues()){
            registeredAsOptions.add(new SelectOption(f.getLabel(), f.getValue()));
        } 
          system.debug('regis @116 here'+registeredAsOptions);
        
        isCommunityPlusUser = false;
        currentUser = [SELECT Id, Name,firstName ,lastName, ContactId , IsActive, IsPortalEnabled, MUSW__Successor__c, ProfileId , email 
                        from User Where ID = :UserInfo.getUserId() LIMIT 1];
        system.debug('currentUser @128 here'+currentUser);
        commPlusProfileId = [SELECT Id FROM Profile WHERE Name = : COMMUNITY_PLUS_PROFILE  Limit 1].Id;
        system.debug('commPlusProfileId @135 here'+commPlusProfileId);
        if(currentUser.ProfileId == commPlusProfileId){
            isCommunityPlusUser = true;
            system.debug('inserting acc here');
            newAccount = new Account();
        }
        
    }
    public string getOperationResult(){
        return JSON.serialize(result) ;
    }
    public AddBusinessDBResult result ;
    public class AddBusinessDBResult {
        public boolean isSuccess {get;set;}
        public String message {get;set;}
        public String operation {get;set;}
        public String nextAction {get;set;}
    }
    //Employee
    public class EmployeeRecord{
        public String AffliationId {get;set;}
        public String EmployeeId {get;set;}
        public String LicenseId {get;set;}
        public String UnSupervisor {get;set;}
        public String Unsupervisee {get;set;}
    }
    public class BusinessRecord{
        public String accountId {get;set;}
        public String contactPerson {get;set;}
        
        public String contactPersonFirstName {get;set;}
        public String contactPersonLastName {get;set;}
        
        public String phoneNumber {get;set;}
        public String email {get;set;}
        public String primaryContactEmail {get;set;}
        public String businessAlias {get;set;}
        
        public String DoingbusinessAs{get;set;}
        public String fax {get;set;}
        public String UBINumber {get;set;}   	//Dharan Shah -- adding UBI number for Business Account -- 03/26
        public String extension {get;set;}		//Dharan Shah -- adding Extension for Business Account -- 03/27
        public String businessPhone {get;set;}	//Dharan Shah -- adding Business Phone for Business Account -- 03/27
        public String website {get;set;}
        public String registeredAs {get;set;}
        public String accountName {get;set;}
        public String contactId {get;set;}
        public String firmCertificate{get;set;}
        public String primaryParcelId {get;set;}
        public String mailingParcelId {get;set;}
        
        public String currentUserId {get;set;}
        public String currentUserProfileId {get;set;}
        public String firstName {get;set;}
        public String lastName {get;set;}
        public String userEmail {get;set;}
        public String FEINNumbersole {get;set;}    
        public String SSNNumber {get;set;}   
    }
    
    // This will call only for Community plus user
    
    public void addNewBusiness(){
        system.debug('inside me');
        System.debug('###1');
        Savepoint sp = Database.setSavepoint(); 
        result = new AddBusinessDBResult() ;
        system.debug('inside result'+ result);
        result.operation = 'AddNewBusiness' ;
        try{
         //   newAccount.Created_By_Contact__c = currentUser.ContactId ;
         // newAccount = new Account();
           system.debug('newAccountName'+newAccountName);
            newAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId() ; 
            system.debug('newAccountName'+newAccountName);
            newAccount.name= newAccountName;
            system.debug('Insert Account>>>>'+newAccount);
            INSERT newAccount ;
           
            // Create two junctions for primary and mailing 
            
            List<Parcel_Account__c> paJunctions = new List<Parcel_Account__c>() ;
            if(primaryParcelId != null && primaryParcelId instanceof ID ){
                Parcel_Account__c pa = new Parcel_Account__c();
                pa.Account__c = newAccount.Id;
                pa.Parcel__c =primaryParcelId;
                pa.Primary__c = true ;
                paJunctions.add(pa) ;
            }
            
            if(mailingParcelId != null && mailingParcelId instanceof ID ){
                Parcel_Account__c pam = new Parcel_Account__c();
                pam.Account__c = newAccount.Id;
                pam.Parcel__c =mailingParcelId;
                pam.Mailing__c = true ;
                paJunctions.add(pam) ;
            }
            
            if(paJunctions.isEmpty() == false ){
                INSERT paJunctions ;
                 system.debug('new account created paJunctions');
            }
                        
            MUSW__Account_Contact__c junction = new MUSW__Account_Contact__c() ;
            junction.MUSW__Contact__c = currentUser.ContactId ;
            junction.MUSW__Account__c = newAccount.Id ;
            junction.Associate_Status__c = label.ST_Active ;
            
            INSERT junction ;
             system.debug('new account created junction');
            
            result.isSuccess = true ;
            result.nextAction = 'KEEP-ALIVE' ;
            result.message =  'Operation completed successfully !' ;
        }catch(exception ex)
        {
            result.isSuccess = false ;
            result.nextAction = 'KEEP-ALIVE' ;
            result.message =  'Error occured ------' + ex.getMessage() ;
            Database.rollback(sp);
          //  ErrorLogger.logGeneralException(ex, UserInfo.getUserId(), 'AddBusiness_CC', null, 'addNewBusiness', 'AddBusiness_CC', label.str_HIGH);
        }
       } 
    
   
    public MUSW__Account_Contact__c createAccountContactObject(String cId, String aId ){
        system.debug('enetered junction @284');
        MUSW__Account_Contact__c retRes ;
        list<MUSW__Account_Contact__c> businessList = new list<MUSW__Account_Contact__c>([SELECT Id, MUSW__Contact__c, MUSW__Account__r.Name, MUSW__Account__r.BillingStreet, MUSW__Account__r.BillingCity, MUSW__Account__r.BillingState, MUSW__Account__r.BillingPostalCode, MUSW__Account__r.BillingCountry FROM MUSW__Account_Contact__c WHERE MUSW__Contact__c =: cId AND MUSW__Account__c =: aId ]);
        if(businessList.size()==0)
        {
            MUSW__Account_Contact__c ac = new MUSW__Account_Contact__c();
         //   ac.Delegated_Administrator__c = true;
            ac.MUSW__Account__c = aId;
            ac.MUSW__Contact__c = cId;
            ac.Associate_Status__c = 'Active' ;
            insert ac;
             system.debug('new account created ac');
            retRes = ac;
        }else if(businessList.size()==1){
            retRes = businessList[0];
        }
        return retRes ;
        
    }
     @RemoteAction 
    public static AddBusinessDBResult addNewBusinessForCommUser(BusinessRecord busRecord){
        AddBusinessDBResult retRes = new AddBusinessDBResult();
        retRes.operation = 'AddNewBusiness' ;
        try
        {
            //Create business and userProm objects
            //Starting additional thread to Create Account and User promotion processing   
            
            BusinessUtility.NewBusiness nBusiness = new BusinessUtility.NewBusiness();
            nBusiness.registeredAs = busRecord.registeredAs ;
            nBusiness.accountName = busRecord.accountName ;
            nBusiness.contactId = busRecord.contactId ;
            nBusiness.firmCertificate = busRecord.firmCertificate ;
            nBusiness.contactPerson = busRecord.contactPerson ;
            nBusiness.contactPersonLastName = busRecord.contactPersonLastName ;
            nBusiness.contactPersonFirstName = busRecord.contactPersonFirstName ;
            nBusiness.DoingbusinessAs = busRecord.DoingbusinessAs;
            nBusiness.website = busRecord.website ;
            nBusiness.phoneNumber = busRecord.phoneNumber ;
            nBusiness.email = busRecord.email ;
            nBusiness.primaryContactEmail = busRecord.primaryContactEmail;
            nBusiness.businessAlias = busRecord.businessAlias;
            nBusiness.fax = busRecord.fax;
            nBusiness.UBINumber = busRecord.UBINumber;			//Dharan Shah -- adding UBI number for Business Account -- 03/26
            nBusiness.extension = busRecord.extension;		//Dharan Shah -- adding extension for Business Account -- 03/27
            nBusiness.businessPhone = busRecord.businessPhone;		//Dharan Shah -- adding Business Phone for Business Account -- 03/27
            nBusiness.primaryParcelId = busRecord.primaryParcelId ;
            nBusiness.mailingParcelId = busRecord.mailingParcelId ;
            nBusiness.FEINNumbersole = busRecord.FEINNumbersole ;
            nBusiness.SSNNumber = busRecord.SSNNumber ;
            BusinessUtility.UserPromotion uPromo = new BusinessUtility.UserPromotion();
            uPromo.currentUserId = busRecord.currentUserId ;
            uPromo.currentUserProfileId = busRecord.currentUserProfileId ;
            uPromo.firstName = busRecord.firstName ;
            uPromo.lastName = busRecord.lastName ;
            uPromo.contactId = busRecord.contactId ;
            uPromo.email = busRecord.userEmail ;
            
            
            Messaging.SendEmailResult threadResult = BusinessUtility.sendMessageForEmailService('COMMUNITY_USER_DEMOTION', new BusinessUtility.NewBusinessUserPromoCombo(nBusiness ,uPromo , 'BrandNewBusiness'));
            system.debug('threadResult>>>>>>>>'+threadResult);
            if(threadResult.isSuccess()){
                retRes.isSuccess = true ;
                retRes.nextAction = 'LOGOUT';
                retRes.message ='Business Add request queued successfully ' ;   
                sendEmailAfterUpgradingUser(uPromo);
            }else
            {
                retRes.isSuccess = false ;
                retRes.nextAction = 'KEEP-ALIVE';
                retRes.message ='Error occured while processing request  ' ;
            }
            
        }catch(exception ex)
        {
            retRes.isSuccess = false ;
            retRes.message = ex.getMessage() ;
           // ErrorLogger.logGeneralException(ex, UserInfo.getUserId(), 'AddBusiness_CC', null, 'addNewBusinessForCommUser', 'AddBusiness_CC', label.str_HIGH);
        }
        return retRes ;
        
    }
    @RemoteAction
    public static AddBusinessDBResult saveBusinessRecord(BusinessRecord busRec){
        SavePoint sp = Database.setSavePoint() ;
        AddBusinessDBResult retRes = new AddBusinessDBResult();
        try
        {
            Account business = new Account(ID = busRec.accountId  ) ;
            business.First_Name_Primary_Contact__c = busRec.contactPersonFirstName ;
            business.Doing_Business_As_1__c = busRec.DoingbusinessAs;
            business.Last_Name_Primary_Contact__c = busRec.contactPersonLastName ;
            business.Phone_Primary_Contact__c = busRec.phoneNumber ;
            business.Email__c = busRec.email ;
            business.Email_Primary_Contact__c = busRec.primaryContactEmail ;
            business.Business_Alias__c = busRec.businessAlias ;
            business.fax = busRec.fax ;
            business.UBI_Number__c = busRec.UBINumber;			//Dharan Shah -- adding UBI number for Business Account -- 03/26
            business.Extension__c = busRec.extension;			//Dharan Shah -- adding extension for Business Account -- 03/27
            business.Business_Phone__c = busRec.businessPhone;		//Dharan Shah -- adding Business Phone for Business Account -- 03/27
            business.website = busRec.website;
            business.FEIN_Number_Encrypted__c = busRec.FEINNumbersole;
            business.Social_Security_Number_Encrypted__c = busRec.SSNNumber;
            Update business ;
            retRes.isSuccess = true ;
            retRes.message ='Business updated successfully ' ;
        }catch(exception ex)
        {
            retRes.isSuccess = false ;
            retRes.message = ex.getMessage() ;
            Database.rollback(sp) ;
           // ErrorLogger.logGeneralException(ex, UserInfo.getUserId(), 'AddBusiness_CC', null, 'saveBusinessRecord', 'AddBusiness_CC', label.str_HIGH);
        }
        return retRes ;
    }
    @RemoteAction
    public static AddBusinessDBResult saveEmployeeRecord(EmployeeRecord busRec)
    {
      /*  SavePoint sp = Database.setSavePoint() ;
        //AddEmployeeDBResult retRes = new AddEmployeeDBResult();
        try
        {
            License_Relationship__c Employee = new License_Relationship__c(ID =busRec.AffliationId ) ;
            Employee.Unlicensed_Supervisee__c = busRec.UnSupervisee ;
            //Employee.Board__c = 'Speech-Language Pathology & Audiology Bd';
            //Employee.Unlicensed_Supervisor__c = busRec.UnSupervisor ;
            Update Employee ;
            //retRes.isSuccess = true ;
            //retRes.message ='Business updated successfully ' ;
        }catch(exception ex)
        {
            //retRes.isSuccess = false ;
            //retRes.message = ex.getMessage() ;
            Database.rollback(sp) ;
            ErrorLogger.logGeneralException(ex, UserInfo.getUserId(), 'AddBusiness_CC', null, 'saveEmployeeRecord', 'AddBusiness_CC', label.str_HIGH);
        } */
        return null ;
    }
    @RemoteAction
    public static AddBusinessDBResult deleteEmployeeRecord(Id EmpId)
    {
      /*  SavePoint sp = Database.setSavePoint() ;
        //AddEmployeeDBResult retRes = new AddEmployeeDBResult();
        try
        {
            License_Relationship__c Employee = new License_Relationship__c(ID = EmpId) ;
            //Employee.Unlicensed_Supervisee__c = busRec.UnSupervisee ;
            //Employee.Unlicensed_Supervisor__c = busRec.UnSupervisor ;
            if (Schema.sObjectType.License_Relationship__c.isDeletable()) {
                Delete Employee ;
            }
            //retRes.isSuccess = true ;
            //retRes.message ='Business updated successfully ' ;
            //mybusinessList = null;
        }catch(exception ex)
        {
            //retRes.isSuccess = false ;
            //retRes.message = ex.getMessage() ;
            Database.rollback(sp) ;
            ErrorLogger.logGeneralException(ex, UserInfo.getUserId(), 'AddBusiness_CC', null, 'deleteEmployeeRecord', 'AddBusiness_CC', label.str_HIGH);
        } */
        return null ;
    }
    
    @RemoteAction
    public static String doUploadAttachment(String acctId, String attachmentBody, String attachmentName) {
      /*  if(acctId != null) {
            Attachment att = new Attachment();
            String newBody = attachmentBody;
            att.Body = EncodingUtil.base64Decode(newBody);
            att.Name = attachmentName;
            att.parentId = acctId;
            insert att;
            return att.Id;
        } else {
            return 'Attachment Body was null';
        }
        */
        return 'Attachment Body was null';
    }
    //End of changes
    
    public void deleteEmployee(){
      /*  License_Relationship__c Employee = new License_Relationship__c(ID = EmpIdChosen) ;
        if (Schema.sObjectType.License_Relationship__c.isDeletable()) {
   			Delete Employee ;
		}
        
        mybusinessList = null;
        */
    }
    
    public void addExistingBusiness()
    {
        SavePoint sp = Database.setSavePoint() ;
        result = new AddBusinessDBResult() ;
        result.operation = 'AddBusinessBySecCode' ;
        result.message =  ''  ;
        try
        {
            if(secCode != null)
            {
                list<Account> aList = new list<Account>([Select Id, Name, Security_Code__c From Account WHERE Security_Code__c =: secCode LIMIT 1]);
                if(aList.isEmpty() == false )
                {
                    transient string accountId = aList[0].Id ;
                    //create junction record
                    if(isCommunityPlusUser)
                    {
                         system.debug('entered createjunctionrecord @483');
                        MUSW__Account_Contact__c junction = createAccountContactObject(currentUser.ContactId, accountId)  ;
                        //List<MUSW__Account_Contact__c> tempBusinessList =   getMyBusiness() ;     
                         result.isSuccess = true ;
                        result.message = result.message + 'New Business added for community plus , You will be promoted' ;
                        result.nextAction = 'KEEP-ALIVE' ;
                    }else if(!isCommunityPlusUser)  // Means this is the first business for Community user , need to promote user
                    {
                        //&& junction != null &&  ( tempBusinessList!= null && tempBusinessList.size() == 1 )
                        // As Community user is not having necessary accesso on User handling 
                        // So we are calling email service to take care of user management 
                        // This thread will deactivate community user and create C+ user
                        BusinessUtility.UserPromotion uPromo= new BusinessUtility.UserPromotion() ;
                        uPromo.contactId = currentUser.contactId  ;
                        uPromo.currentUserId = currentUser.Id ;
                        uPromo.currentUserProfileId = currentUser.profileId ;
                        uPromo.firstName = currentUser.firstName ;
                        uPromo.lastName = currentUser.lastName ;
                        uPromo.email = currentUser.email ;
                        uPromo.newAccountId = accountId ;
                        
                        Messaging.SendEmailResult threadResult = BusinessUtility.sendMessageForEmailService('COMMUNITY_USER_DEMOTION', new BusinessUtility.NewBusinessUserPromoCombo(null ,uPromo , 'SecurityCode') ) ;
                        if(threadResult.isSuccess() == true){
                            sendEmailAfterUpgradingUser(uPromo);
                        }
                        
                        result.isSuccess = true ;
                        result.nextAction = 'LOGOUT' ;
                        result.message = result.message + 'New Business added, You will be promoted'  ;
                    }
                }else
                {
                    result.isSuccess = false ;
                    result.message = result.message + 'No match found. Please check your Security Code' ;
                }
            }else
            {
                result.isSuccess = false ;
                result.message = 'Please provide correct security code ' ;
            }
        }catch(exception ex)
        {
            system.debug('entered exception @521'+ex);
            result.isSuccess = false ;
            result.message = ex.getMessage() ;
            Database.rollback(sp) ;
           // ErrorLogger.logGeneralException(ex, UserInfo.getUserId(), 'AddBusiness_CC', null, 'addExistingBusiness', 'AddBusiness_CC', label.str_HIGH);
        }
    }
    
    public PageReference refreshAddNewBusinessSection()
    {
        newAccount = new Account() ;
        return null ;
    }
    
    public class ManageBusinessWrapper{
        public MUSW__Account_Contact__c myBusiness {get; set;}
       // public List<License_Relationship__c> myAffiliations {get; set;}
    }
    
    // Send Email after is user is prompted
    public static void sendEmailAfterUpgradingUser(BusinessUtility.UserPromotion uPromo){
        List<Email_Notification__c> enList = new List<Email_Notification__c>();
        Email_Notification__c en = new Email_Notification__c();
        en.Email__c = uPromo.email;
        en.Recipient_Contact__c = uPromo.contactId;
        en.Type__c = 'User Upgrade';
        en.Param1__c = uPromo.firstName + ' ' + uPromo.lastName;
        enList.add(en);
        
        if(enList.size()>0){
            try{
                insert enList;
            } catch(Exception e){
                system.debug('Insert Failed for Email Notification in AddBusiness Class');
            }
        }
    }
    
}