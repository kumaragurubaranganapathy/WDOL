public without sharing class Add_BusinessController {
    
    //get BusinessAccount RecordType Id 
    @AuraEnabled 
    public static id getRecordTypeIdAccount(){
        return Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId() ;
    }
    
    @AuraEnabled 
    public static String insertRequest(String acctId,String ServiceRequestType){
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
       // system.debug('licenseType'+licenseType+'board');
        Request__c application = new Request__c();
        application.Profession__c = ServiceRequestType; 
        application.License_Type__c = ServiceRequestType;        
        application.Stage__c = 0;
        application.Service_Request_Type__c = ServiceRequestType;
        application.Contact__c = getContactId;
        if(acctId != null && acctId != ''){
            application.Account__c = acctId;  
        }  
        try
        {          
            insert application;
        }
        catch(Exception e){
            HandleException.LogException(e,'Add_BusinessController','insertRequest');            
        }
        string appId = '';
        return appId = application.Id;
    }
    
    @AuraEnabled
    public static List<Account> getAllAccounts(){
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
    }
    
    @AuraEnabled
    public static Map<String,List<Sobject>> getAccountData(String accountId){
        
        try{
            
            Map<String,List<Sobject>> mapOfSobjects= new Map<String,List<Sobject>>();
            
            for(Account acc: [SELECT  Id,  Name,  Email__c,UBI_Number__c,  Business_Phone__c, Course_Provider__c,
                              (SELECT Address_Type__c,Country__c,County__c,Id,MUSW__City__c,MUSW__District__c,
                               MUSW__Post_Zip_Code__c,MUSW__State__c,MUSW__Street2__c,MUSW__Street_Number__c,
                               MUSW__Street_Suffix__c,MUSW__Street__c,Name 
                               FROM Addresses__r 
                               WHERE Status__c = 'Active' )    
                              FROM Account 
                              Where Id = : accountId LIMIT 1]){
                                  
                                  
                                  mapOfSobjects.put('Account',new List<account>{acc});
                                  for(MUSW__Parcel__c parcel :acc.Addresses__r){
                                      
                                      if(mapOfSobjects.containskey('parcel')){
                                          
                                          mapOfSobjects.get('parcel').add(parcel); 
                                          
                                      }else{
                                          mapOfSobjects.put('parcel',new List<MUSW__Parcel__c>{parcel});
                                      }
                                      
                                  }
                                  
                              }
            
            return mapOfSobjects;
        }    
        catch(Exception ex){
            
            return null;
        }
    }
    
    @AuraEnabled
    public static boolean createAccountContactObject(String aId){
        System.debug('inside createAccount::');
        MUSW__Account_Contact__c retRes ;
        User currentUser = [SELECT Id,Name,firstname,lastname,ContactId,email from User Where ID = :UserInfo.getUserId() LIMIT 1];
        list<MUSW__Account_Contact__c> businessList = new list<MUSW__Account_Contact__c>([SELECT Id, MUSW__Contact__c, MUSW__Account__r.Name, MUSW__Account__r.BillingStreet, MUSW__Account__r.BillingCity, MUSW__Account__r.BillingState, MUSW__Account__r.BillingPostalCode, MUSW__Account__r.BillingCountry FROM MUSW__Account_Contact__c WHERE MUSW__Contact__c =: currentUser.ContactId AND MUSW__Account__c =: aId ]);
        try{
            if(businessList.size()==0){
                MUSW__Account_Contact__c ac = new MUSW__Account_Contact__c();
                ac.MUSW__Account__c = aId;
                ac.MUSW__Contact__c = currentUser.ContactId;
                ac.Status__c= 'Active' ;
                ac.isAdminContact__c = True;
                ac.Role__c = 'Administrator';
                ac.Account_Admin__c = true;
                ac.Email__c = currentUser.Email;
                ac.First_Name__c = currentUser.firstname;
                ac.Middle_Name__c = currentUser.firstname;
                ac.Last_Name__c = currentUser.lastName;
                ac.Email__c = currentUser.email;
                ac.Title__c = 'Administrator';
                insert ac;
                system.debug('ac234567'+ac);
                return true;
            } 
        }catch(Exception e){
            System.debug(e.getMessage());
        }        return false;
    }
    
    @AuraEnabled
    public static void updateAccount(List<Account> acc ){
        update acc;
    }
    
    @AuraEnabled
    public static List<MUSW__Account_Contact__c> getAllContacts(String accountId){
        List<MUSW__Account_Contact__c> lstContact = new List<MUSW__Account_Contact__c>();
        for(MUSW__Account_Contact__c ac :[SELECT Id,MUSW__Account__r.Name,resend_Invitation__c,isAdminContact__c,First_Name__c,Last_Name__c,Title__c,Role__c,Ownership_Percentage__c,Associate_Status__c FROM MUSW__Account_Contact__c WHERE MUSW__Account__c =: accountId]){
            lstContact.add(ac);
        }
        return lstContact;
    }
    @AuraEnabled
    public static List<MUSW__Account_Contact__c> updateContactAccountStatus(String Id, String status, String accountId) {
        List<MUSW__Account_Contact__c> lstContact = new List<MUSW__Account_Contact__c>();
        for(MUSW__Account_Contact__c ac :[SELECT Id,Associate_Status__c 
                                          FROM MUSW__Account_Contact__c WHERE Id =: Id]){
                                              ac.Associate_Status__c = status;
                                              lstContact.add(ac);                                 
                                          }
        system.debug('updatedList'+lstContact);
        if(!lstContact.isEmpty ()){
            update lstContact;
        }
        lstContact = new List<MUSW__Account_Contact__c>();
        for(MUSW__Account_Contact__c ac :[SELECT MUSW__Account__r.Name,isAdminContact__c,First_Name__c,Last_Name__c,Title__c,Role__c,Ownership_Percentage__c,Associate_Status__c FROM MUSW__Account_Contact__c WHERE MUSW__Account__c =: accountId]){
            lstContact.add(ac);
        }
        return lstContact;
    }
    @AuraEnabled
    public static List<MUSW__Account_Contact__c> resendEmailInvitation (String Id, String accountId) {
        Polaris_UtilityClass appUtility = new  Polaris_UtilityClass();
        List<Messaging.SingleEmailMessage> resendEmailList = new List<Messaging.SingleEmailMessage>();        
        List<MUSW__Account_Contact__c> lstContact = [SELECT Id,Associate_Status__c,Email__c
                                                     FROM MUSW__Account_Contact__c WHERE Id =: Id limit 1];
        Set<String> setEmail = new Set<String>();
        if(!lstContact.isEmpty() && lstContact[0].Email__c != null) {
            lstContact[0].Resend_Invitation_Date__c = system.today();
            Id orgWideEmailAddressId = appUtility.getOrgWideEmailAddressId(System.label.Organization_Wide_EmailAddress);
            EmailTemplate emailTemplate = appUtility.getEmailTemplate('Department of Licensing - Pending request to join a firm');
            String htmlBody = emailTemplate.HtmlValue;
            String htmlSubject = emailTemplate.Subject;
            setEmail.add(lstContact[0].Email__c);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.templateid=emailTemplate.Id;
            mail.setToAddresses(new List<String>(setEmail));
            mail.setSubject(htmlSubject);
            mail.setHtmlBody(htmlBody);
            mail.setOrgWideEmailAddressId(orgWideEmailAddressId);
            resendEmailList.add(mail);
            update lstContact;
        }
        if(!resendEmailList.isEmpty()){
            Messaging.sendEmail(resendEmailList);
        }
        
        lstContact = new List<MUSW__Account_Contact__c>();
        for(MUSW__Account_Contact__c ac :[SELECT MUSW__Account__r.Name,isAdminContact__c,First_Name__c,Last_Name__c,Title__c,Role__c,Ownership_Percentage__c,Associate_Status__c FROM MUSW__Account_Contact__c WHERE MUSW__Account__c =: accountId]){
            lstContact.add(ac);
        }
        return lstContact; 
        
    }
    
    @AuraEnabled
    public static List<MUSW__License2__c> getAllCourses(String accountId){
        
        List<Portal_Dashboard_Settings__mdt> dashboardSettings = [SELECT Dashboard_Type__c,Draft_Applications_statuses__c,License_Statuses__c,License_Types__c,Pending_Applications_statuses__c FROM Portal_Dashboard_Settings__mdt WHERE Dashboard_Type__c = 'Business'];
        
        List<String> statusFilterList = new List<String>();
        
        if(!dashboardSettings.isEmpty()){
            
            statusFilterList = dashboardSettings.get(0).License_Statuses__c.split(',');
        }  
        
        system.debug('accountId---'+accountId);
        Id courseRecordTypeId = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Course').getRecordTypeId();
        
        List<MUSW__License2__c> courseList = [SELECT Id,Name,Course_Name__c,Course_Number__c,Credential_Type__c,MUSW__Status__c,
                                              Application_Type__c,What_Licensure_Level__c,What_program_are_you_interested_in__c,MUSW__Primary_Licensee__c,
                                              Course_Status__c, Course_Title__c,Course_Type__c,Course_Topic__c,MUSW__Primary_Licensee__r.Id,Ultimate_Parent_Account__c,
                                              Provider_School_Name__c,Clock_Hours__c,Delivery_Method__c,Clock_Hours_Continuing_Education__c,Is_Renewal_Eligible__c,
                                              Is_Reinstatement_Eligible__c,Is_Late_Renewal_Eligible__c,Application__r.isRenewal__c,Application_Method__c,MUSW__Expiration_Date__c,
                                              Clock_Hours_Pre_Qualifying__c,Clock_Hours_Qualifying_Elective__c,Continuing_Education_Licensure_Levels__c
                                              FROM MUSW__License2__c WHERE RecordTypeId =: courseRecordTypeId AND MUSW__Status__c IN:statusFilterList AND Ultimate_Parent_Account__c =:accountId];
        
        return courseList;
    }
    
    @AuraEnabled
    public static List<MUSW__License2__c> getBusinessLicenses(String accountId,Boolean branch,String LicenseId){
        system.debug('accountId----'+accountId);
        Id businessRecordTypeId = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        List<MUSW__License2__c> businessList = new List<MUSW__License2__c>();
        
        if(branch){
            businessList = [SELECT Id,Name,Credential_Type__c, MUSW__Status__c, MUSW__Primary_Licensee__c,
                            MUSW__Primary_Licensee__r.Doing_Business_As_1__c,
                            MUSW__Primary_Licensee__r.Business_Name__c,MUSW__Primary_Licensee__r.Business_Phone__c,
                            MUSW__Primary_Licensee__r.Business_Website__c,MUSW__Primary_Licensee__r.Email__c,
                            Original_Issue_Date__c,MUSW__Expiration_Date__c,MUSW__Issue_Date__c,Sub_Status__c,
                            Application_Type__c,Application_Method__c,LastModifiedDate FROM MUSW__License2__c
                            WHERE RecordTypeId =: businessRecordTypeId AND Parent_License__c=:LicenseId AND isBranch_License__c=true ];
            
        }else{
            
            businessList = [SELECT Id,Name,Credential_Type__c, MUSW__Status__c, MUSW__Primary_Licensee__c,
                            MUSW__Primary_Licensee__r.Doing_Business_As_1__c,
                            MUSW__Primary_Licensee__r.Business_Name__c,MUSW__Primary_Licensee__r.Business_Phone__c,
                            MUSW__Primary_Licensee__r.Business_Website__c,MUSW__Primary_Licensee__r.Email__c,
                            Original_Issue_Date__c,MUSW__Expiration_Date__c,MUSW__Issue_Date__c,Sub_Status__c,
                            Application_Type__c,Application_Method__c,LastModifiedDate FROM MUSW__License2__c
                            WHERE RecordTypeId =: businessRecordTypeId AND MUSW__Primary_Licensee__c =:accountId];
        }
        
        return businessList;
    }
    
    @AuraEnabled
    public static List<MUSW__Application2__c> getAllApplications(String accountId){
        
        List<Portal_Dashboard_Settings__mdt> dashboardSettings = [SELECT Dashboard_Type__c,Draft_Applications_statuses__c,License_Statuses__c,License_Types__c,Pending_Applications_statuses__c FROM Portal_Dashboard_Settings__mdt WHERE Dashboard_Type__c = 'Business'];
        List<String> statusFilterList = new List<String>();
        if(!dashboardSettings.isEmpty()){
            statusFilterList = dashboardSettings.get(0).Draft_Applications_statuses__c.split(',');    
        }
        
        system.debug('account id ---'+accountId);
        Id businessRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        system.debug('businessRecordTypeId---'+businessRecordTypeId);
        List<MUSW__Application2__c> applicationList = [SELECT Id, MUSW__Applicant__c,Application_Method__c,Application_Number__c,MUSW__Account__c,
                                                       MUSW__Decision_Date__c,MUSW__Description__c,Geolocation__c,
                                                       Attestation__c,Attestation_Date__c,MUSW__Completion_Date__c,License__c,
                                                       License_ID__c,Credential_Type__c,Application_Type__c,Request_Type__c,MUSW__Account__r.RecordTypeId,
                                                       MUSW__Status__c,Stage__c,Submitted_Date__c,MUSW__Type__c,MUSW__Total_Payments__c,
                                                       MUSW__Total_Fees__c,MUSW__Total_Balance__c,Branch_License__c,isRenewal__c,LastModifiedDate,
                                                       MUSW__Issued_Number__c,Parent_License__c,
                                                       Reason_for_Submitting_Service_Request__c 
                                                       FROM MUSW__Application2__c WHERE MUSW__Status__c IN :statusFilterList AND MUSW__Account__c =: accountId];
        system.debug('applicationList--'+applicationList);
        
        return applicationList;
    }
    
    
    
    @AuraEnabled 
    public static List<Renewal_Application__c> getAllRenewalApplications(String accountId){
        system.debug('accountId---'+accountId);
        String businessRecordTypeId = Schema.SObjectType.Renewal_Application__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        system.debug('businessRecordTypeId---'+businessRecordTypeId);
        List<Renewal_Application__c> renewalAppList = [SELECT Additional_Address__c,Applicant__c,Application_Type__c,Application__c,AttestationFullName__c,Attestation_Date__c,Attestation__c,
                                                       Auto_Renew__c,Bad_Check__c,Business_License__c,CE_Hours__c,Community_Address__c,Community_ID_Number__c,Community_Name__c,Community_Owner__c,
                                                       County__c,Credential_Type__c,Credential__c,External_Id__c,External_source_c__c,Generate_Invoice__c,Id,LastModifiedDate,Licensee__c,
                                                       License_Application__c,License_Number__c,License__c,Makes_of_Homes_to_be_Sold__c,MHC_Application_Type__c,Model_Year__c,Name,No_Fee_Required__c,
                                                       No_Fee__c,OwnerId,Permit_Type__c,Permit__c,Program_Area__c,RecordTypeId,Renewal_Expiration_Date__c,Renewal_Reinstatement_Type__c,Renewal_Status__c,
                                                       Renewed_Date__c,Responsible_Party_Type__c,Sales_Tax_Seller_Permit_Number__c,Section_Number__c,Special_Accommodation_Request__c,Total_Balance__c,
                                                       Total_Fees__c,Total_Payments__c,Trade_Name__c,Years_Expired__c FROM Renewal_Application__c WHERE RecordTypeId =: businessRecordTypeId];
        return renewalAppList;
    }
    
    @AuraEnabled
    public static List<MUSW__License2__c> getAllLicenses(String accountId){
        Id businessRecordTypeId = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        List<MUSW__License2__c> licenseList = [SELECT Id,Name,Credential_Type__c, MUSW__Status__c, MUSW__Primary_Licensee__c,
                                               MUSW__Primary_Licensee__r.Doing_Business_As_1__c,
                                               MUSW__Primary_Licensee__r.Business_Name__c,MUSW__Primary_Licensee__r.Business_Phone__c,
                                               MUSW__Primary_Licensee__r.Business_Website__c,MUSW__Primary_Licensee__r.Email__c,
                                               Original_Issue_Date__c,MUSW__Expiration_Date__c,MUSW__Issue_Date__c,Sub_Status__c,
                                               Application_Type__c,Application_Method__c,LastModifiedDate FROM MUSW__License2__c
                                               WHERE RecordTypeId =: businessRecordTypeId  ];
        return licenseList;
    }
    
    @AuraEnabled
    public static String setBusinessLicenseTable(String AccountId,Boolean branch,String LicenseId){
        try{  
            
            List<Portal_Dashboard_Settings__mdt> dashboardSettings = [SELECT Dashboard_Type__c,Draft_Applications_statuses__c,License_Statuses__c,License_Types__c,Pending_Applications_statuses__c FROM Portal_Dashboard_Settings__mdt WHERE Dashboard_Type__c = 'Business'];
            
            List<String> columnHeaderList = new List<String>{'License','License Type','Expiration Date','Status','Sub-status'};
                //List<String> statusFilterList = new List<String>{'Active','Expired','Inactive','Canceled','Revoked','Suspended','Sunset'};
                
                List<String> statusFilterList = new List<String>();
            
            if(!dashboardSettings.isEmpty()){
                
                statusFilterList = dashboardSettings.get(0).License_Statuses__c.split(',');
            }  
            
            Id businessRT = SObjectType.MUSW__License2__c.getRecordTypeInfosByDeveloperName().get('Business').getRecordTypeId();
            List<SObject> columnDataList;
            if(branch){    
                columnDataList = [SELECT id, Name, Application_Type__c,Application__c,Application__r.isRenewal__c,MUSW__Primary_Licensee__c, Credential_Type__c, MUSW__Expiration_Date__c,Is_Renewal_Eligible__c,Is_Late_Renewal_Eligible__c,Is_Reinstatement_Eligible__c, MUSW__Status__c, Sub_Status__c,Application_Method__c FROM MUSW__License2__c WHERE recordTypeId = :businessRT and MUSW__Status__c IN:statusFilterList AND Parent_License__c=:LicenseId AND isBranch_License__c=true ];
                
            }else{
                columnDataList = [SELECT id, Name, Application_Type__c,Application__c,Application__r.isRenewal__c,MUSW__Primary_Licensee__c, Credential_Type__c, MUSW__Expiration_Date__c,Is_Renewal_Eligible__c,Is_Late_Renewal_Eligible__c,Is_Reinstatement_Eligible__c, MUSW__Status__c, Sub_Status__c,Application_Method__c FROM MUSW__License2__c WHERE Ultimate_Parent_Account__c =:AccountId AND recordTypeId = :businessRT and MUSW__Status__c IN:statusFilterList AND isBranch_License__c= false ];
            }                           
            Add_BusinessController.lightningDataTableWrapper wrapperObj = new Add_BusinessController.lightningDataTableWrapper(columnHeaderList,columnDataList);
            
            return JSON.serialize(wrapperObj,true);
            
        }catch(Exception ex){
            return null;
        }
    }
    
    //method to get license details 
    @AuraEnabled 
    public static MUSW__License2__c getLicenseData(String Id){
        
        List<MUSW__License2__c>  lic = [SELECT id, Name,Application_Method__c,MUSW__Issue_Date__c,Original_Issue_Date__c, Application_Type__c,Ultimate_Parent_Account__r.Email__c,Ultimate_Parent_Account__r.Business_Phone__c,Ultimate_Parent_Account__r.Name,Ultimate_Parent_Account__r.Doing_Business_As_1__c, Credential_Type__c, MUSW__Expiration_Date__c, MUSW__Status__c, Sub_Status__c, MUSW__Parcel__r.Address_Type__c,
                                        MUSW__Parcel__r.MUSW__Street__c,MUSW__Parcel__r.MUSW__City__c,MUSW__Parcel__r.MUSW__State__c,MUSW__Parcel__r.MUSW__Post_Zip_Code__c FROM MUSW__License2__c WHERE id=:Id limit 1];
        if(!lic.isEmpty()){
            return lic[0];
        }else{
            return null;
        }
        
    }
    
    //method to get endorsement details 
    @AuraEnabled 
     public static String[] getEndorsementData(String licenseId){
        
        List<Endorsement__c> endorsementDataList = new List<Endorsement__c>();
        List<String> EndorsementList= new List<String>();
        if(licenseId != null){ 
            for(Endorsement__c endorseObj: [select id,Endorsement_Type__c from Endorsement__c where Status__c ='Active' AND License__c =: licenseId]){
                EndorsementList.add(endorseObj.Endorsement_Type__c);
            }
            
        }
        system.debug('fetchEndorsementDetails --> '+JSON.serialize(endorsementDataList)); 
        
        return EndorsementList;  
    }
    
    //method to get Address details 
    @AuraEnabled 
    public static List<MUSW__Parcel__c> getAddressData(String Id){
        
      /*  List<LnP_Parcel__c>  addressData = [SELECT id, Name,Address_Type__c,Street__c,City__c,State__c,Zip_Postal_Code__c,License__c,is_Physical_and_Mailing_Address_Same__c FROM LnP_Parcel__c WHERE License__c=:Id limit 4];
        if(!addressData .isEmpty()){
            return addressData;
        }else{
            return null;
        }*/
        Set<Id> parcelIds = new Set<Id>();
        List<MUSW__Parcel__c>addressData = new List<MUSW__Parcel__c>();
        for(MUSW__License_Parcel__c licenseParcelInstance : [Select Id, MUSW__License2__c, MUSW__Parcel__c From MUSW__License_Parcel__c where MUSW__License2__c=:Id]){
            parcelIds.add(licenseParcelInstance.MUSW__Parcel__c);
        }
        if(!parcelIds.isEmpty()){
            addressData = [Select id, Application_BG__c,MUSW__Street2__c,MUSW__Unit__c,MUSW__City__c,MUSW__State__c,Zip_Postal_Code__c,Country__c,Melissa_Address_Verified__c,
                          is_Physical_and_Mailing_Address_Same__c,Address_Type__c, Canadian_provinces__c, County__c FROM MUSW__Parcel__c where Id IN :parcelIds];
        }
         if(!addressData.isEmpty()){
            return addressData;
        }else{
            return null;
        }
    }
    
    
    // Method to update task status and related record on accept or declined of action.
    @AuraEnabled 
    public static Boolean actionOnTask(string type,string actionClicked ,task tsk){
        try{
            
            sObject objData;
            Associations__c assoc;
            MUSW__Account_Contact__c accCon;
            system.debug('tsk::'+ tsk);
            system.debug('type::'+ type);
            system.debug('actionClicked::'+ actionClicked);
            if(type == 'License Relationship'){
                assoc = [select id,Status__c,invitation_send_date__c from Associations__c  where id=:tsk.Whatid];
                system.debug('assoc::'+ assoc);
                if(actionClicked == 'Accepted'){
                    assoc.Status__c = 'Active';
                    if(tsk != null){
                        tsk.Status = 'Completed';
                    }
                }else if(actionClicked == 'Declined'){
                    assoc.Status__c ='Declined';
                    assoc.invitation_send_date__c = system.today();
                    if(tsk != null){
                        tsk.Status = 'Completed';
                    }
                }
                if(assoc != null){
                    update assoc; 
                }
                if(tsk != null){
                    update tsk;
                }
            }
            if(type =='Contact Relationship'){
                accCon = [select id,Status__c,invitation_send_date__c from MUSW__Account_Contact__c where id=: tsk.Whatid];
                if(actionClicked == 'Accepted'){
                    accCon.Status__c = 'Active';
                    if(tsk != null){
                        tsk.Status = 'Completed';
                    }
                }else if(actionClicked == 'Declined'){
                    accCon.Status__c ='Declined';
                    accCon.invitation_send_date__c = system.today();
                    if(tsk != null){
                        tsk.Status = 'Completed';
                    }
                }
                if(accCon  != null){
                    update accCon ; 
                }
                if(tsk != null){
                    update tsk;
                }
            }
            return true;
        }catch(Exception e){
            system.debug('exception::'+e.getmessage());
            return false;
        } 
        
    }    
    
    @AuraEnabled 
    public static Boolean removeAcconContactRecord(MUSW__Account_Contact__c accConId ,string action){
        try{
            
            
            List<task> tsk = [select id,Whatid,Status from task where Whatid=:accConId.Id limit 1];
            
            System.debug('accConId::'+accConId+' : tsk : '+tsk);
            if(action == 'Remove'){
                accConId.Status__c = 'Deleted';
                if(!tsk.isEmpty()){
                    tsk[0].Status = 'Completed';
                }
                
            }else if(action == 'Resend'){
                accConId.Status__c ='Invited';
                accConId.invitation_send_date__c = system.today();
                if(!tsk.isEmpty()){
                    tsk[0].Status = 'Pending';
                }
            }
            update accConId;
            if(!tsk.isEmpty()){
                update tsk;
            }
            return true;
        }catch(Exception e){
            Polaris_CreateErrorLog_Exception.addError(e,'Add_BusinessController','removeAcconContactRecord');
            return false;
        } 
        
    }
    
    
    
    
    @AuraEnabled 
    public static Boolean removeAssociationRecord(String associationObj ,string action){
        try{
            
            Associations__c accConId = (Associations__c)JSON.deserialize(associationObj, Associations__c.class);  
            
            List<task> tsk = [select id,Whatid,Status from task where Whatid=:accConId.Id limit 1];
            
            System.debug('accConId::'+accConId+' : tsk : '+tsk);
            if(action == 'Remove'){
                accConId.Status__c = 'Deleted';
                if(!tsk.isEmpty()){
                    tsk[0].Status = 'Completed';
                }
                
            }else if(action == 'Resend'){
                accConId.Status__c ='Invited';
                accConId.invitation_send_date__c = system.today();
                if(!tsk.isEmpty()){
                    tsk[0].Status = 'Pending';
                }
            }
            update accConId;
            if(!tsk.isEmpty()){
                update tsk;
            }
            return true;
        }catch(Exception e){
            system.debug('exception::removeAssociationRecord'+e.getmessage());
            return false;
        } 
        
    }
    
    @AuraEnabled
    public static Boolean createTask(Id accountContact,String Email,String accountName,String accountId,String designation,Boolean DCP){
        try{
            task t = new task();
            t.Whatid = accountContact;
            t.Status = 'Pending';
            t.Email__c = Email;
            t.Subject = 'Invitation to be a Business Admin';
            t.Type = 'Contact Relationship';
            t.Designation__c = designation;
            t.Business_Name__c = accountName;
            t.isDCP__c = DCP;
            if(accountName.contains('-')){
                List<String> lst = accountName.split('-');
                if(lst[1] == 'Appraisal Management Company'){
                    t.Main_License_Type__c = 'Appraisal Management Companies'; 
                    
                }
                t.AccountId__c = accountId;
            }
            insert t;
            return true;
        }catch(Exception e){
            System.debug(e.getMessage());
            return false;
        }
    }
    @AuraEnabled
    public static Boolean createAssociationTask(Id associationID){
        Associations__c association = [SELECT id, Child_License__r.MUSW__Applicant__c FROM Associations__c where id=:associationID ];
        Contact con = [Select id,Email FROM Contact where id=:association.Child_License__r.MUSW__Applicant__c];
        try{
            task t = new task();
            t.Whatid = associationID;
            t.Status = 'Pending';
            t.Email__c = con.Email;
            t.Subject = 'Invitation to get asociated to a Business License';
            t.Type = 'License Relationship';
            insert t;
            return true;
        }catch(Exception e){
            System.debug(e.getMessage());
            return false;
        }
    }
    
    
    @AuraEnabled
    public static String getRelationShip(String sObjectName,String queryId){
        
        List<sObject> sObjList; 
        List<String> columnHeaderList;
        List<String> statusFilterList;
        if(sObjectName == 'MUSW__Account_Contact__c'){
            columnHeaderList = new List<String>{'Name','Role','Admin','DCP','Email','Status','Actions'};
                statusFilterList = new List<String>{'Active','Inactive','Canceled','Declined','Invited','No Response','Pending','Deleted'};
                    sObjList =[select id,Name,Role__c,Full_Name__c,DCP__c,Email__c,isAdminContact__c,Status__c,resend_Invitation__c from MUSW__Account_Contact__c where MUSW__Account__c =: queryId and Status__c != 'Deleted']; 
        }
        
        if(sObjectName == 'Associations__c'){
            columnHeaderList = new List<String>{'License Number','Name','License Type','License Status','Association Type','Invitation Status','Actions'}; 
                statusFilterList = new List<String>{'Active','Inactive','Canceled','Declined','Invited','No Response','Pending','Deleted'};
                    sObjList =[select id,Name,Status__c,Child_License__r.Applicant_Full_Name__c,Parent_License__r.Applicant_Full_Name__c,Child_License__r.Application_Type__c,Parent_License__r.Application_Type__c,Child_License__r.Credential_Type__c,Parent_License__r.Credential_Type__c,Child_License__r.Email__c,Parent_License__r.Email__c,Child_License__r.Name,Parent_License__r.Name,Child_License__r.MUSW__Status__c,Parent_License__r.MUSW__Status__c from Associations__c where Parent_License__c =: queryId and Status__c != 'Deleted']; 
        }
        
        Add_BusinessController.lightningDataTableWrapper wrapperObj = new Add_BusinessController.lightningDataTableWrapper(columnHeaderList,sObjList);
        return JSON.serialize(wrapperObj,true);
        
    }
    
    @AuraEnabled
    public static String setPeerRelationShipTable(String licenseId){
        String licenseType ='';
        
        MUSW__License2__c lic = [SELECT id,MUSW__Status__c,Credential_Type__c FROM MUSW__License2__c where id=:licenseId];
        licenseType = lic.Credential_Type__c;
        
        
        List<String> columnHeaderList;   
        List<String> statusFilterList = new List<String>{'Active'};
            List<SObject> columnDataList;
        Add_BusinessController.lightningDataTableWrapper wrapperObj = new Add_BusinessController.lightningDataTableWrapper(null,null);
        Licensing_RelationShip__mdt license_Custom_Metadata = [SELECT Child_License_Credential__c,Columns_To_Dsiplay_In_Professional_Dashb__c,DeveloperName,Id,Is_Parent__c,Label,Language,MasterLabel,Parent_License_Credential__c FROM Licensing_RelationShip__mdt where label =: licenseType LIMIT 1];
        if(license_Custom_Metadata != null && license_Custom_Metadata.Is_Parent__c){
            columnHeaderList  = new List<String>{'Name','Profession','License Type','Email'}; 
                columnDataList = [Select Id,Child_License__r.Applicant_Full_Name__c, Child_License__r.Application_Type__c,
                                  Child_License__r.Credential_Type__c, Child_License__r.Email__c,Status__c    
                                  FROM Associations__c
                                  WHERE Parent_License__c =: licenseId AND Status__c IN : statusFilterList AND Child_License__r.Credential_Type__c LIKE : '%'+license_Custom_Metadata.Child_License_Credential__c+'%'] ;
            wrapperObj = new Add_BusinessController.lightningDataTableWrapper(columnHeaderList,columnDataList);
            wrapperObj.miscellaneousData = 'true'; //true if the current license is parent          
        }else if(license_Custom_Metadata != null && !(license_Custom_Metadata.Is_Parent__c)){
            columnHeaderList  = new List<String>{'Name','Profession','License Type','Email'};
                columnDataList = [Select Id,Parent_License__r.Applicant_Full_Name__c, Parent_License__r.Application_Type__c,
                                  Parent_License__r.Credential_Type__c, Parent_License__r.Email__c,Status__c      
                                  FROM Associations__c
                                  WHERE Child_License__c =: licenseId AND Status__c IN : statusFilterList AND Parent_License__r.Credential_Type__c LIKE : '%'+license_Custom_Metadata.Parent_License_Credential__c+'%'] ;
            wrapperObj = new Add_BusinessController.lightningDataTableWrapper(columnHeaderList,columnDataList);
            wrapperObj.miscellaneousData = 'false'; //false if the current license is child  
        }
        return JSON.serialize(wrapperObj);
        
    }
    
    //method to get mandatory actions pending 
    @AuraEnabled
    public static List<task> getMandatoryActions(){
        User currentUser = [SELECT Name,Id,ContactId,Email from User Where ID = :UserInfo.getUserId() LIMIT 1];
        
        return [select id,Subject,Email__c,Business_Name__c,Status,Whatid,type,Parent_Licensee_Name__c,Parent_License_Name__c,Parent_License_Type__c,Parent_Profession__c,Child_Licensee_Name__c,Child_License_Name__c,Child_License_Type__c,Child_Profession__c,Designation__c from task where Status =:'Pending' and Email__c=:currentUser.Email ];
        
    }
    
    @AuraEnabled
    public static String pendingNewLicenseApplicationsTbl(String accountID){
        try{ 
            
            List<Portal_Dashboard_Settings__mdt> dashboardSettings = [SELECT Dashboard_Type__c,Draft_Applications_statuses__c,License_Statuses__c,License_Types__c,Pending_Applications_statuses__c FROM Portal_Dashboard_Settings__mdt WHERE Dashboard_Type__c = 'Business'];
            
            List<String> statusFilterList = new List<String>();
            
            if(!dashboardSettings.isEmpty()){
                
                statusFilterList = dashboardSettings.get(0).Pending_Applications_statuses__c.split(',');
            } 
            system.debug('accountID::'+accountID);
            List<String> columnHeaderList = new List<String>{'Application','Profession','License Type','Application Method','Status','Sub-status'};
                //List<String> statusFilterList = new List<String>{'In-Review','In Review','Pending Payment','Payment Pending','Pending Additional Qualifications','Pending Action'};
                Id businessRT = SObjectType.MUSW__License2__c.getRecordTypeInfosByDeveloperName().get('Business').getRecordTypeId();        
            List<SObject> columnDataList = [Select id,Name,Application_Number__c,Application_Type__c,Credential_Type__c,Application_Method__c,MUSW__Status__c,Sub_Status__c
                                            from MUSW__License2__c
                                            where MUSW__Status__c In: statusFilterList AND recordTypeId=:businessRT AND Ultimate_Parent_Account__c =: accountID ORDER BY CreatedDate asc];
            
            Add_BusinessController.lightningDataTableWrapper wrapperObj = new Add_BusinessController.lightningDataTableWrapper(columnHeaderList,columnDataList);
            
            return JSON.serialize(wrapperObj,true);
            
        }catch(Exception ex){
            return null;
        }
    }
    
    @AuraEnabled
    public static String fetchPendingCourseData(String accountID){
        try{ 
            
            
            List<Portal_Dashboard_Settings__mdt> dashboardSettings = [SELECT Dashboard_Type__c,Draft_Applications_statuses__c,License_Statuses__c,License_Types__c,Pending_Applications_statuses__c FROM Portal_Dashboard_Settings__mdt WHERE Dashboard_Type__c = 'Business'];
            
            List<String> statusFilterList = new List<String>();
            
            if(!dashboardSettings.isEmpty()){
                
                statusFilterList = dashboardSettings.get(0).Pending_Applications_statuses__c.split(',');
            }  
            
            Id courseRecordTypeId = Schema.SObjectType.MUSW__License2__c.getRecordTypeInfosByName().get('Course').getRecordTypeId();
           List<String> columnHeaderList = new List<String>{'Course','Course Name','Course Type','Delivery Method','Clock Hours', 'Status'};
                //List<String> statusFilterList = new List<String>{'Submitted','Under Review','Pending Payment','Payment Pending','Pending Additional Qualifications','Pending Action'};
                
                List<SObject> columnDataList = [SELECT Id,Name,Course_Name__c,Course_Number__c,Credential_Type__c,
                                                Application_Type__c,What_Licensure_Level__c,What_program_are_you_interested_in__c,
                                                Course_Status__c,Course_Title__c,Course_Type__c,Course_Topic__c,MUSW__Primary_Licensee__r.Id,Ultimate_Parent_Account__c,
                                                Provider_School_Name__c,Clock_Hours__c,Delivery_Method__c,Clock_Hours_Continuing_Education__c,
                                                Clock_Hours_Pre_Qualifying__c,Clock_Hours_Qualifying_Elective__c,Continuing_Education_Licensure_Levels__c,Sub_Status__c,MUSW__Status__c
                                                FROM MUSW__License2__c WHERE MUSW__Status__c In: statusFilterList AND RecordType.Id =: courseRecordTypeId AND Ultimate_Parent_Account__c =: accountID ORDER BY CreatedDate asc];
            system.debug('columnDataList---'+columnDataList);
            Add_BusinessController.lightningDataTableWrapper wrapperObj = new Add_BusinessController.lightningDataTableWrapper(columnHeaderList,columnDataList);
            
            return JSON.serialize(wrapperObj,true);
            
        }catch(Exception ex){
            return null;
        }
    }
    
    @AuraEnabled
    public static String PendingRenewApplicationsTable(String accountID){
        try{  
            
            List<Portal_Dashboard_Settings__mdt> dashboardSettings = [SELECT Dashboard_Type__c,Draft_Applications_statuses__c,License_Statuses__c,License_Types__c,Pending_Applications_statuses__c FROM Portal_Dashboard_Settings__mdt WHERE Dashboard_Type__c = 'Business'];
            
            List<String> statusFilterList = new List<String>();
            
            if(!dashboardSettings.isEmpty()){
                
                statusFilterList = dashboardSettings.get(0).Pending_Applications_statuses__c.split(',');
            } 
            
            List<String> columnHeaderList = new List<String>{'License','Profession','License Type','Expiration Date','Status','Sub-status','Type'};
                //List<String> statusFilterList = new List<String>{'Submitted','In-Review','Pending Payment','Payment Pending','Pending Additional Qualification','Pending Action'};
                
                List<SObject> columnDataList = [Select id,Name,License_Number__c,Credential_Type__c,License__r.Application_Method__c,format(Renewal_Expiration_Date__c),Renewal_Status__c,Application_Type__c
                                                from Renewal_Application__c
                                                where Licensee__c =: accountID AND Renewal_Status__c In: statusFilterList ORDER BY CreatedDate asc];
            
            Add_BusinessController.lightningDataTableWrapper wrapperObj = new Add_BusinessController.lightningDataTableWrapper(columnHeaderList,columnDataList);
            
            return JSON.serialize(wrapperObj,true);
            
        }catch(Exception ex){
            return null;
        }
    }
    
    @AuraEnabled
    public static String PendingMaintananceRequestApplicationsTable(String accountID){
        try{  
            
            List<String> columnHeaderList = new List<String>{'Request','Request Type', 'Request Against', 'Status'};
                List<String> statusFilterList = new List<String>{'Under Review'};
                    List<SObject> columnDataList = [Select  id,name,License_Type__c, Service_Request_Type__c, FORMAT(LastModifiedDate)
                                                    from Request__c
                                                    where Status__c IN :statusFilterList AND Account__c=:accountID  ORDER BY CreatedDate asc];
            
            Add_BusinessController.lightningDataTableWrapper wrapperObj = new Add_BusinessController.lightningDataTableWrapper(columnHeaderList,columnDataList);
            
            return JSON.serialize(wrapperObj,true); 
            
        }catch(Exception ex){
            return null;
        }
    }
    
    @AuraEnabled
    public static Boolean updateTask(Id taskId,String subStatus){
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
        List<Associations__c> lstAssociation = [SELECT id, Status__c,Child_License__c From Associations__c where id=:tskList.Whatid];
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
        for(Associations__c associ : lstAssociation)
        {
            if(subStatus == 'Accepted'){
                associ.Status__c = 'Active';
                
            }else{
                associ.Status__c = 'Declined';
            }
            lstUpdateAssociation.add(associ);
        }
        if(!accList.isEmpty()){
            update tskList;
            update accList;
            return true;
        }
        else if(!lstUpdateAssociation.isEmpty()){
            update tskList;
            update lstUpdateAssociation;
            return true;
        }else{
            return false;
        }
    }
    
    @AuraEnabled
    public static boolean checkDCP(String accountId){
        Account acc = [select id,Name from Account where id=: accountId limit 1];
        String accName = acc.Name;
        Boolean hasDCP = false;
        Set<String> statusSet = new Set<String>{'Confirmed','Active','Accepted'};
            Set<String> roleSet = new Set<String>{'Controlling person','Designated Controlling Person'};
                if(accName.contains('Appraisal Management Company')){
                    List<MUSW__Account_Contact__c> accCon = [select id,Name from MUSW__Account_Contact__c where MUSW__Account__c =: accountId AND Status__c IN:statusSet AND Role__c IN:roleSet  AND DCP__c = true ];
                    hasDCP = (accCon.size() > 0) ? true :false;
                }
        return hasDCP;
    } 
    
    @AuraEnabled
    public static String helptextFetch(){
        Map<String, String> helptextMap = new Map<String, String>();            
        try{
            List<Dashboard_Helptext__mdt> helptextList = [SELECT Id, DeveloperName, Status__c, Sub_Status__c, Object__c, Help_Text__c FROM Dashboard_Helptext__mdt];
            if(!helptextList.isEmpty()){
                for(Dashboard_Helptext__mdt htext : helptextList){
                    String temp = '';
                    temp = String.valueOf(htext.Status__c + '-' + htext.Sub_Status__c + '-' + htext.Object__c);
                    helptextMap.put(temp, String.valueOf(htext.Help_Text__c));
                }
                
            }    
            system.debug('helptextMap::'+helptextMap);            
            return JSON.serialize(helptextMap);
        }
        catch(Exception e){
            DOL_CreateErrorLog_Exception.addError(e,'<class name>','<method name>');
            return JSON.serialize(helptextMap);       
        }
    }
    
    public class lightningDataTableWrapper{
        public List<String> tableHeader;
        public List<Sobject> tableData;
        public String miscellaneousData;
        lightningDataTableWrapper(List<String> tableHeader,List<Sobject> tableData){
            this.tableHeader = tableHeader!=null? tableHeader:new List<String>();
            this.tableData = tableData!=null? tableData : new List<Sobject>();
        }
    }
}