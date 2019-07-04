public without sharing class LnP_DashboardApexController_2 {
    
    
    @AuraEnabled
    public static String getRecordTypeId(String sObjectName, String recordTypeDeveloperName){
        try{
                Map<String, Schema.RecordTypeInfo> recordTypeMap =  Schema.getGlobalDescribe().get(sObjectName).getDescribe().getRecordTypeInfosByDeveloperName(); 
        if(recordTypeMap.containsKey(recordTypeDeveloperName)){
           return recordTypeMap.get(recordTypeDeveloperName).getRecordTypeId();
        }else{
            return null;
        }
        }catch(Exception ex){
            return null;
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
    public static Employment_History__c getEducationalHistory(String licenseId){
        try{
    Employment_History__c employmentHistoryObj =   [SELECT id, Start_Date__c, Job_Title__c, Country__c, City__c, Employer__c, End_date__c, Zip_code__c, County__c, Total_Hours__c,
                               Street_Address__c,  State__c FROM Employment_History__c where License__c =: licenseId LIMIT 1];
        if(employmentHistoryObj != null){
            return employmentHistoryObj;
        }                           
        
        return null;
        }catch(Exception ex){
            return null;
        }
    }
    
    @AuraEnabled
    public static Map<String,String> getDBJSON(){
        Map<String, String> mapJSON = new Map<String, String>();
        try{
            System.debug('mapJSON::');
            mapJSON = getDashboardJSON(); 
            System.debug('mapJSON: after::'+ mapJSON );
        }
        catch(Exception e){
            HandleException.LogException(e,'LnP_DashboardApexController','getDBJSON');
        }
        return mapJSON;
    }
    
    @AuraEnabled
    public static String uploadAdditionalDocuments(String licenseId){
       Id  licenseId_id = licenseId;
       Schema.SObjectType sObjType = licenseId_id.getSobjectType();
       String sobjName =  sObjType.getDescribe().getName();
       SObject sObj =     sObjType.newSObject(licenseId);
       
       MUSW__Submission__c subnissionObj = new MUSW__Submission__c();
       subnissionObj.put(sobjName, sObj.id);
       INSERT subnissionObj;
       
       //sObj.put('MUSW__Status__c','In Review');
       //UPDATE sObj;
       
       return subnissionObj.id;
        
    }
    
    @AuraEnabled
    public static void setLicenseToInreview(String licenseId){
       Id  licenseId_id = licenseId;
       Schema.SObjectType sObjType = licenseId_id.getSobjectType();
       String sobjName =  sObjType.getDescribe().getName();
       SObject sObj =     sObjType.newSObject(licenseId);
       
       sObj.put('MUSW__Status__c','In Review');
       UPDATE sObj;
    }
    
    @AuraEnabled
    public static String setCurrentLicenseTable(){
        try{  
            
            List<String> businessLicensesTobeIgnored;
            
            Portal_Dashboard_Settings__mdt dashboardSettings = [SELECT Dashboard_Type__c,DeveloperName,Id,Label,Language,License_Statuses__c,License_Types__c,MasterLabel FROM Portal_Dashboard_Settings__mdt where DeveloperName = 'Business_Dashboard'];
            
            if(dashboardSettings != null){
                
                String allLisenceTypes = dashboardSettings.License_Types__c;
                
                businessLicensesTobeIgnored = allLisenceTypes.split(',');                
            }

            List<String> columnHeaderList = new List<String>{'LICENSE#','PROFESSION','LICENSE TYPE','EXPIRATION DATE','STATUS','SUB-STATUS'};
            List<String> statusFilterList = new List<String>{'Active','Expired','Inactive','Canceled','Revoked','Suspended','Sunset'};
            List<SObject> columnDataList = [Select id,Name,Application_Type__c,Credential_Type__c,MUSW__Expiration_Date__c,MUSW__Status__c,Sub_Status__c,
                                                    RecordType.Name,Is_Renewal_Eligible__c, Is_Late_Renewal_Eligible__c,Is_Reinstatement_Eligible__c,Application__r.isRenewal__c,Application_Method__c,
                                                    CreatedDate
                                                    from MUSW__License2__c
                                                    where Credential_Type__c NOT In :businessLicensesTobeIgnored AND 
                                                          MUSW__Status__c In :statusFilterList AND 
                                                          RecordType.Name = 'Individual' AND 
                                                          MUSW__Applicant__c in(Select ContactId From User Where Id =: UserInfo.getUserId()) ORDER BY CreatedDate asc];
            
            LnP_DashboardApexController_2.lightningDataTableWrapper wrapperObj = new LnP_DashboardApexController_2.lightningDataTableWrapper(columnHeaderList,columnDataList);
            
            return JSON.serialize(wrapperObj,true);
            
        }catch(Exception ex){
            return null;
        }
    }
    
    @AuraEnabled
    public static String ProfessionalRelationshipTable(){
        try{  
            List<String> columnHeaderList = new List<String>{'NAME','ROLE','TITLE','PHONE','EMAIL'};
                List<String> statusFilterList = new List<String>{'Active'};
                    List<SObject> columnDataList = [Select Id,MUSW__Account__r.Name, Role__c, Title__c, MUSW__Account__r.Phone, MUSW__Account__r.Business_Phone__c,MUSW__Account__r.Email__c,Status__c 
                                                    from MUSW__Account_Contact__c
                                                    where Status__c In: statusFilterList AND MUSW__Contact__c in(Select ContactId From User Where Id =: UserInfo.getUserId()) ORDER BY CreatedDate asc];
            
            LnP_DashboardApexController_2.lightningDataTableWrapper wrapperObj = new LnP_DashboardApexController_2.lightningDataTableWrapper(columnHeaderList,columnDataList);
            
            return JSON.serialize(wrapperObj,true);
            
        }catch(Exception ex){
            return null;
        }
    }
    
    @AuraEnabled
    public static String seperateAccountContactRelationship(String AccountContactId){
        return JSON.serialize(Polaris_RelationshipsUtilty.removeAffliationRecord(AccountContactId));
    }
    
    @AuraEnabled
    public static String seperateAssociateRelationship(String associateId){
        return JSON.serialize(Polaris_RelationshipsUtilty.removeAssociationRecord(associateId));
    }
    
    @AuraEnabled
    public static String DraftNewLicenseApplicationsTable(){
        List<String> columnHeaderList = new List<String>{'PROFESSION','LICENSE TYPE','APPLICATION METHOD','LAST UPDATED'};
            List<String> statusFilterList = new List<String>{'Draft', 'Withdrawn','Submission Failed','Pending'};
                List<SObject> columnDataList = [Select id,Name,Application_Type__c,Credential_Type__c,Application_Method__c, FORMAT(LastModifiedDate) editDate,isRenewal__c
                                                from MUSW__Application2__c
                                                where MUSW__Status__c IN :statusFilterList AND  MUSW__Applicant__c in(Select ContactId From User Where Id =: UserInfo.getUserId())  ORDER BY CreatedDate asc];
        
        LnP_DashboardApexController_2.lightningDataTableWrapper wrapperObj = new LnP_DashboardApexController_2.lightningDataTableWrapper(columnHeaderList,columnDataList);
        
        return JSON.serialize(wrapperObj,true);                             
        
    }
    @AuraEnabled
    public static String setDraftRenewApplicationsTable(){
        
        List<String> columnHeaderList = new List<String>{'LICENSE#','PROFESSION','LICENSE TYPE','EXPIRATION DATE','LAST UPDATED'};
            List<String> statusFilterList = new List<String>{'Draft', 'Pending','Submission Failed'};
                List<SObject> columnDataList = [Select id,Name,License__r.name, Application_Type__c,Credential_Type__c,format(Renewal_Expiration_Date__c) renexpirydate,Renewal_Status__c, FORMAT(LastModifiedDate) editDate
                                                from Renewal_Application__c
                                                where Renewal_Status__c In: statusFilterList AND Applicant__c in(Select ContactId From User Where Id =: UserInfo.getUserId()) ORDER BY CreatedDate asc];
        
        LnP_DashboardApexController_2.lightningDataTableWrapper wrapperObj = new LnP_DashboardApexController_2.lightningDataTableWrapper(columnHeaderList,columnDataList);
        
        return JSON.serialize(wrapperObj,true); 
    }
    
    @AuraEnabled
    public static String setDraftMaintananceRequestApplicationsData(){
        List<String> columnHeaderList = new List<String>{'REQUEST TYPE', 'REQUEST AGAINST', 'LAST UPDATED'};
            List<String> statusFilterList = new List<String>{'Draft', 'Withdrawn'};
                List<SObject> columnDataList = [Select  id,License_Type__c, Service_Request_Type__c, FORMAT(LastModifiedDate)
                                                from Request__c
                                                where Status__c IN :statusFilterList AND Contact__c in(Select ContactId From User Where Id =: UserInfo.getUserId())  ORDER BY CreatedDate asc];
        
        LnP_DashboardApexController_2.lightningDataTableWrapper wrapperObj = new LnP_DashboardApexController_2.lightningDataTableWrapper(columnHeaderList,columnDataList);
        
        return JSON.serialize(wrapperObj,true); 
    }
    
    @AuraEnabled
    public static String PendingNewLicenseApplicationsTable(){
        try{  
            
            List<String> columnHeaderList = new List<String>{'APPLICATION#','PROFESSION','LICENSE TYPE','APPLICATION METHOD','STATUS','SUB-STATUS'};
                List<String> statusFilterList = new List<String>{'Submitted','In-Review','In Review','Under Review','Pending Payment','Payment Pending','Pending Additional Qualifications','Pending Action'};
                    
                    List<SObject> columnDataList = [Select id,Name,Application_Number__c,Application_Type__c,Credential_Type__c,Application_Method__c,MUSW__Status__c,Sub_Status__c
                                                    from MUSW__License2__c
                                                    where MUSW__Status__c In: statusFilterList  AND 
                                                          RecordType.Name = 'Individual' AND 
                                                          MUSW__Applicant__c in(Select ContactId From User Where Id =: UserInfo.getUserId()) ORDER BY CreatedDate asc];
            
            LnP_DashboardApexController_2.lightningDataTableWrapper wrapperObj = new LnP_DashboardApexController_2.lightningDataTableWrapper(columnHeaderList,columnDataList);
            
            return JSON.serialize(wrapperObj,true);
            
        }catch(Exception ex){
            return null;
        }
    }
    
    @AuraEnabled
    public static String PendingRenewApplicationsTable(){
        try{  
            
            List<String> columnHeaderList = new List<String>{'LICENSE#','PROFESSION','LICENSE TYPE','EXPIRATION DATE','STATUS','SUB-STATUS','TYPE'};
                List<String> statusFilterList = new List<String>{'Submitted','In-Review','In Review','Pending Payment','Payment Pending','Pending Additional Qualifications','Pending Action'};
                    
                    List<SObject> columnDataList = [Select id,Name,License_Number__c,Credential_Type__c,License__r.Application_Method__c,format(Renewal_Expiration_Date__c),Renewal_Status__c,Application_Type__c
                                                    from Renewal_Application__c
                                                    where Renewal_Status__c In: statusFilterList AND Applicant__c in(Select ContactId From User Where Id =: UserInfo.getUserId()) ORDER BY CreatedDate asc];
            
            LnP_DashboardApexController_2.lightningDataTableWrapper wrapperObj = new LnP_DashboardApexController_2.lightningDataTableWrapper(columnHeaderList,columnDataList);
            
            return JSON.serialize(wrapperObj,true);
            
        }catch(Exception ex){
            return null;
        }
    }
    
    @AuraEnabled
    public static String PendingMaintananceRequestApplicationsTable(){
        try{  
            
            List<String> columnHeaderList = new List<String>{'REQUEST#','REQUEST TYPE', 'REQUEST AGAINST', 'STATUS'};
                List<String> statusFilterList = new List<String>{'Under Review'};
                    List<SObject> columnDataList = [Select  id,name,License_Type__c, Service_Request_Type__c, FORMAT(LastModifiedDate)
                                                    from Request__c
                                                    where Status__c IN :statusFilterList AND Contact__c in(Select ContactId From User Where Id =: UserInfo.getUserId())  ORDER BY CreatedDate asc];
            
            LnP_DashboardApexController_2.lightningDataTableWrapper wrapperObj = new LnP_DashboardApexController_2.lightningDataTableWrapper(columnHeaderList,columnDataList);
            
            return JSON.serialize(wrapperObj,true); 
            
        }catch(Exception ex){
            return null;
        }
    }
    
    @AuraEnabled
    public static String CompletedMaintananceRequestApplicationsTable(){
        try{  
            
            List<String> columnHeaderList = new List<String>{'REQUEST#','REQUEST TYPE', 'REQUEST AGAINST', 'COMPLETION DATE'};
                List<String> statusFilterList = new List<String>{'Approve'};
                    List<SObject> columnDataList = [Select  id,name,License_Type__c, Service_Request_Type__c, FORMAT(End_Time__c)
                                                    from Request__c
                                                    where Status__c IN :statusFilterList AND Contact__c in(Select ContactId From User Where Id =: UserInfo.getUserId())  ORDER BY CreatedDate asc];
            
            LnP_DashboardApexController_2.lightningDataTableWrapper wrapperObj = new LnP_DashboardApexController_2.lightningDataTableWrapper(columnHeaderList,columnDataList);
            
            return JSON.serialize(wrapperObj,true); 
            
        }catch(Exception ex){
            return null;
        }
    }
    
    @AuraEnabled
    public static String fetchLicenseDetailsTable(String licenseId){
        
        if(licenseId != null){
            List<MUSW__License2__c> msusLicenseData = [select id,Name,RecordTypeId, Credential_Type__c, MUSW__Status__c, Sub_Status__c,MUSW__Applicant__r.Name,Original_Issue_Date__c, MUSW__Issue_Date__c, MUSW__Expiration_Date__c, Application_Type__c,Application_Method__c,
                                                       (select id,name, State_Province__c, Country__c, City__c from LnP_Parcels__r ) from MUSW__License2__c where id =: licenseId LIMIT 1];
            return JSON.serialize(msusLicenseData);   
        }else{
            return null;
        }
        
    }
    
    @AuraEnabled
    public static String[] fetchEndorsementDetails(String licenseId){
        List<Endorsement__c> endorsementDataList = new List<Endorsement__c>();
        List<String> EndorsementList= new List<String>();
        if(licenseId != null){ 
            for(Endorsement__c endorseObj: [select id,Endorsement_Type__c from Endorsement__c where License__c =: licenseId]){
                EndorsementList.add(endorseObj.Endorsement_Type__c);
            }
            
        }
        system.debug('fetchEndorsementDetails --> '+JSON.serialize(endorsementDataList)); 
        
        return EndorsementList;  
    }
    
    @auraEnabled
    public static String getBusinessRelationShipData(String license_id){

            List<String> columnHeaderList = new List<String>{'NAME','ROLE','LICENSE TYPE','PHONE','EMAIL'};
            List<String> statusFilterList = new List<String>{'Active'};
                    List<SObject> columnDataList = [Select Id,Parent_License__r.MUSW__Primary_Licensee__r.Name, Association_Type__c,Status__c,
                                                    Parent_License__r.Credential_Type__c,Parent_License__r.MUSW__Primary_Licensee__r.Business_Phone__c,Parent_License__r.MUSW__Primary_Licensee__r.Email__c        
                                                    FROM Associations__c
                                                    WHERE Child_License__c =: license_id AND Status__c IN : statusFilterList] ;
            
            LnP_DashboardApexController_2.lightningDataTableWrapper wrapperObj = new LnP_DashboardApexController_2.lightningDataTableWrapper(columnHeaderList,columnDataList);
            
            return JSON.serialize(wrapperObj,true);
    }
    
    @AuraEnabled
    public static String setPeerRelationShipTable(String licenseType, String licenseId){
        
        List<String> columnHeaderList;   
        
        List<String> statusFilterList = new List<String>{'Active'};
        
        List<SObject> columnDataList;

        LnP_DashboardApexController_2.lightningDataTableWrapper wrapperObj = new LnP_DashboardApexController_2.lightningDataTableWrapper(null,null);
            
        Licensing_RelationShip__mdt license_Custom_Metadata = [SELECT Child_License_Credential__c,Columns_To_Dsiplay_In_Professional_Dashb__c,DeveloperName,Id,Is_Parent__c,Label,Language,MasterLabel,Parent_License_Credential__c FROM Licensing_RelationShip__mdt where label =: licenseType LIMIT 1];
        
         if(license_Custom_Metadata != null && license_Custom_Metadata.Is_Parent__c){
             
           columnHeaderList  = new List<String>{'NAME','PROFESSION','LICENSE TYPE','EMAIL'}; 
          
           columnDataList = [Select Id,Child_License__r.Applicant_Full_Name__c, Child_License__r.Application_Type__c,
                                    Child_License__r.Credential_Type__c, Child_License__r.Email__c,Status__c    
                               FROM Associations__c
                               WHERE Parent_License__c =: licenseId AND Status__c IN : statusFilterList AND Child_License__r.Credential_Type__c LIKE : '%'+license_Custom_Metadata.Child_License_Credential__c+'%'] ;
                               
            wrapperObj = new LnP_DashboardApexController_2.lightningDataTableWrapper(columnHeaderList,columnDataList);
            
            wrapperObj.miscellaneousData = 'true'; //true if the current license is parent          
             
         }else if(license_Custom_Metadata != null && !(license_Custom_Metadata.Is_Parent__c)){
             
             columnHeaderList  = new List<String>{'NAME','PROFESSION','LICENSE TYPE','EMAIL'};
             
             columnDataList = [Select Id,Parent_License__r.Applicant_Full_Name__c, Parent_License__r.Application_Type__c,
                                         Parent_License__r.Credential_Type__c, Parent_License__r.Email__c,Status__c      
                               FROM Associations__c
                               WHERE Child_License__c =: licenseId AND Status__c IN : statusFilterList AND Parent_License__r.Credential_Type__c LIKE : '%'+license_Custom_Metadata.Parent_License_Credential__c+'%'] ;
                               
            wrapperObj = new LnP_DashboardApexController_2.lightningDataTableWrapper(columnHeaderList,columnDataList);
            
            wrapperObj.miscellaneousData = 'false'; //false if the current license is child  
             
         }
         return JSON.serialize(wrapperObj);
          
    }
    
    @AuraEnabled
    public static Contact getContact(){
        Contact conObj;
        List<Contact> ConList =  [SELECT Id 
                                  FROM Contact 
                                  Where Id In (Select ContactId
                                               From User
                                               Where Id = :UserInfo.getUserId()) LIMIT 1];
        if(!ConList.isEmpty()){
            conObj = ConList[0];
        }
        return conObj;
    }
    
    public static Map<String, String> getDashboardJSON() {
        Map <String, String> mapJSON = new Map <String, String>();
        //mapJSON.put('Card Menu List','[{"header":"Notifications", "url":"/dashboard", "icon": "LnP__Notification_E.svg", "class":"slds-small-size_1-of-1 slds-medium-size_1-of-2 slds-large-size_1-of-3"},{"header":"Service Requests:", "url":"/dashboard", "icon": "LnP__ServiceRequest_E.svg", "class":"slds-small-size_1-of-1 slds-medium-size_1-of-2 slds-large-size_1-of-3"},{"header":"My To Do List", "url":"/dashboard", "icon": "LnP__ToDoList_E.svg", "class":"slds-small-size_1-of-1 slds-medium-size_1-of-2 slds-large-size_1-of-3"},{"header":"All Applications", "url":"/dashboard", "icon": "LnP__Applications_E.svg", "class":"slds-small-size_1-of-1 slds-medium-size_1-of-1 slds-large-size_1-of-1"}]');
        mapJSON.put('Card Menu List','[{"header":"All Applications", "url":"/dashboard", "icon": "LnP__Applications_E.svg", "class":"slds-small-size_1-of-1 slds-medium-size_1-of-1 slds-large-size_1-of-1"}]');
        mapJSON.put('Application Header List','["Number","Type", "Status", "Created Date", "Link", "Expiration Date", "Add Association"]');        
        //CR start 
        System.debug('User@@@'+userInfo.getUserId());
        List<User> userInfoData = new  List<User>();
        String queryCondition = ' Id=\''+UserInfo.getUserId()+'\'';//0050b000004XiXjAAK
        // String queryCondition1 = ' Id=\''+UserInfo.getUserId()+'\'';
        String queryStr = 'SELECT ContactId FROM User WHERE  '+queryCondition;
        system.debug('queryStr@@@ '+queryStr);
        userInfoData = Utilityclass_withsharing.queryRecords(queryStr);
        //String queryCondition1 = ' MUSW_Applicant__c =\''+userInfoData[0].ContactId+'\'';
        system.debug('userInfoData[0].ContactId@@@ '+userInfoData[0].ContactId);
        list<MUSW__License2__c> lstLicenses;
        list<MUSW__Application2__c> applicationList;
        if(userInfoData[0].ContactId != null){
            //applicationList = [select Id, isRenewal__c,License_Type__c,Board__c,Application_Type__c, Status__c ,CreatedDate from MUSW__Application2__c WHERE Status__c= 'Pending' AND MUSW_Applicant__c =: userInfoData[0].ContactId ORDER BY CreatedDate desc limit 5];
            applicationList = [select Id,Application_Number__c, isRenewal__c,Credential_Type__c,Application_Type__c,Application_Method__c, MUSW__Status__c ,CreatedDate from MUSW__Application2__c WHERE MUSW__Status__c= 'Pending' AND isRenewal__c=false AND MUSW__Applicant__c =: userInfoData[0].ContactId ORDER BY CreatedDate asc ];
        } 
        if(userInfo.getUserId() != null){
            //applicationList = [select Id, isRenewal__c,License_Type__c,Board__c,Application_Type__c, Status__c ,CreatedDate from MUSW_Application2__c WHERE Status__c= 'Pending' AND CreatedById =: userInfo.getUserId() ORDER BY CreatedDate desc limit 5];
            applicationList = [select Id,Application_Number__c, isRenewal__c,Credential_Type__c,Application_Type__c,Application_Method__c, MUSW__Status__c ,CreatedDate from MUSW__Application2__c WHERE MUSW__Status__c= 'Pending' AND isRenewal__c=false AND MUSW__Applicant__c =: userInfoData[0].ContactId ORDER BY CreatedDate asc ];
        } 
        //For License
        if(userInfoData[0].ContactId != null){
            lstLicenses = [select Id,Name,RecordType.Name,Is_Renewal_Eligible__c, Is_Late_Renewal_Eligible__c,Is_Reinstatement_Eligible__c,Credential_Type__c,Application__c,Application__r.isRenewal__c,Application_Type__c,Application_Method__c, MUSW__Status__c ,CreatedDate,MUSW__Expiration_Date__c from MUSW__License2__c WHERE MUSW__Applicant__c =: userInfoData[0].ContactId ORDER BY CreatedDate asc ];
        } 
        if(userInfo.getUserId() != null){
            lstLicenses = [select Id,Name,RecordType.Name,Is_Renewal_Eligible__c,Is_Late_Renewal_Eligible__c,Is_Reinstatement_Eligible__c,  Credential_Type__c,Application_Type__c,Application_Method__c, MUSW__Status__c ,Application__c,Application__r.isRenewal__c,CreatedDate,MUSW__Expiration_Date__c from MUSW__License2__c WHERE CreatedById =: userInfo.getUserId() ORDER BY CreatedDate asc ];
        }
        
        Map<Id,Map<String,String>> mapLicenses = new Map<Id,Map<String,String>>();
        Map<Id,Map<String,String>> mapBusLicenses = new Map<Id,Map<String,String>>();
        Map<Id,Map<String,String>> applicationMap = new Map<Id,Map<String,String>>();
        for(MUSW__Application2__c app: applicationList){
            Map<String,String> temp = new Map<String,String>();
            if(!applicationMap.containsKey(app.Id)){
                temp.put('Name',app.Application_Number__c);
                temp.put('type',app.Credential_Type__c);
                temp.put('board',app.Application_Type__c);
                temp.put('Id',app.Id);
                temp.put('status', app.MUSW__Status__c);
                temp.put('date', String.valueOf(app.CreatedDate));
                temp.put('applicationType',app.Application_Method__c);
                temp.put('renewal',String.valueOf(app.isRenewal__c));
                applicationMap.put(app.Id,temp); 
            }
        }
        //For mapLicense
        for(MUSW__License2__c lic: lstLicenses){
            Map<String,String> temp = new Map<String,String>();
            if(lic.RecordType.Name == 'Individual'){
                if(!mapLicenses.containsKey(lic.Id)){
                    temp.put('Name',lic.Name);
                    temp.put('type',lic.Credential_Type__c);
                    temp.put('board',lic.Application_Type__c);
                    temp.put('Id',lic.Id);
                    temp.put('status', lic.MUSW__Status__c);
                    temp.put('renewal', String.valueOf(lic.Is_Renewal_Eligible__c));
                    temp.put('lateRenewal', String.valueOf(lic.Is_Late_Renewal_Eligible__c));
                    temp.put('reinstate', String.valueOf(lic.Is_Reinstatement_Eligible__c));
                    temp.put('date', String.valueOf(lic.CreatedDate));
                    temp.put('expiryDate', String.valueOf(lic.MUSW__Expiration_Date__c));
                    temp.put('applicationType',lic.Application_Method__c);
                    temp.put('licenseAppId',lic.Application__c);
                    temp.put('appIsRenewal',String.valueOf(lic.Application__r.isRenewal__c));
                    
                    
                    mapLicenses.put(lic.Id,temp); 
                }}
            if(lic.RecordType.Name == 'Business'){
                if(!mapBusLicenses.containsKey(lic.Id)){
                    temp.put('Name',lic.Name);
                    temp.put('type',lic.Credential_Type__c);
                    temp.put('board',lic.Application_Type__c);
                    temp.put('Id',lic.Id);
                    temp.put('status', lic.MUSW__Status__c);
                    temp.put('renewal', String.valueOf(lic.Is_Renewal_Eligible__c));
                    temp.put('lateRenewal', String.valueOf(lic.Is_Late_Renewal_Eligible__c));
                    temp.put('reinstate', String.valueOf(lic.Is_Reinstatement_Eligible__c));
                    temp.put('date', String.valueOf(lic.CreatedDate));
                    temp.put('expiryDate', String.valueOf(lic.MUSW__Expiration_Date__c));
                    temp.put('applicationType',lic.Application_Method__c);
                    temp.put('licenseAppId',lic.Application__c);
                    temp.put('appIsRenewal',String.valueOf(lic.Application__r.isRenewal__c));
                    mapBusLicenses.put(lic.Id,temp); 
                }
            } 
        }
        
        List<MUSW__Account_Contact__c> AcctConList = [ select id,Account_Admin__c,Associate_Status__c from MUSW__Account_Contact__c where OwnerId =:userInfo.getUserId() and Account_Admin__c = true and Associate_Status__c =:'Active' ];
        system.debug(JSON.serialize(applicationMap));
        mapJSON.put('Application Item List',JSON.serialize(applicationMap));
        mapJSON.put('License Item List',JSON.serialize(mapLicenses));
        String businessFlag = 'false';
        if(!AcctConList.isEmpty()){
            if(AcctConList[0].Account_Admin__c){
                mapJSON.put('BusinessLicense',JSON.serialize(mapBusLicenses));  
                businessFlag = 'true';
            }
        }
        mapJSON.put('businessFlag',businessFlag );
        System.debug('mapJSON :'+mapJSON);
        return mapJSON;
    }
    
    @AuraEnabled
    public static boolean isValidCommunityUser(){
        
        return DE_LandingPageCustomLabels.isValidCommunityUser();
    }
    
    @AuraEnabled
    public static String fetchLicenseRelatedEmploymentNEducationalHistoryRecords(String relatedRecordId){
        
        
         List<String> columnHeaderList = new List<String>{'START DATE','JOB TITLE','EMPLOYER','END DATE','TOTAL HOURS','STREET ADDRESS','COUNTY','STATE','COUNTRY','CITY','ZIP CODE','STATUS'};   
         
         List<LnP_BackgroundSection__c> columnDataList =   [SELECT Start_Date__c,Job_Title__c,Employer__c,End_date__c,Total_Hours__c,
                                                                Street_Address__c,County__c,State__c,Country__c,City__c,Zip_code__c, 
                                                                Status__c,Name_of_Institution__c,Degree__c,Minor__c,Major__c
                                                                FROM LnP_BackgroundSection__c 
                                                             WHERE License_Bg__c =:relatedRecordId
                                                                   AND Status__c = 'Pending'];    
         LnP_DashboardApexController_2.lightningDataTableWrapper wrapperObj = new LnP_DashboardApexController_2.lightningDataTableWrapper(columnHeaderList,columnDataList);
                
        return JSON.serialize(wrapperObj,true);      
    }
    
    
    @AuraEnabled
    public static String fetchRenewalRelatedEmploymentNEducationalHistoryRecords(String relatedRecordId){
        List<String> columnHeaderList = new List<String>{'NAME OF INSTITUTION','DEGREE','MINOR','MAJOR','START DATE','END DATE','COUNTRY','STATE','STATUS'};
        
        List<LnP_BackgroundSection__c> columnDataList =    [SELECT Start_Date__c,Job_Title__c,Employer__c,End_date__c,Total_Hours__c,
                                                                Street_Address__c,County__c,State__c,Country__c,City__c,Zip_code__c, 
                                                                Status__c,Name_of_Institution__c,Degree__c,Minor__c,Major__c
                                                                    FROM LnP_BackgroundSection__c
                                                                    WHERE Renewal_Reinstatement_Application__c =: relatedRecordId 
                                                                       AND Status__c = 'Pending'];
                                                                            
            LnP_DashboardApexController_2.lightningDataTableWrapper wrapperObj = new LnP_DashboardApexController_2.lightningDataTableWrapper(columnHeaderList,columnDataList);
                
            return JSON.serialize(wrapperObj,true);                                                                     
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