/**
* Name: SharingUtilityController
* Type: Class
* Description: Sharing Utility controller for ApexUserSharingModel
* Date:        Developer/Company                 	Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 08/16/2018   Srikanth Kottam/Deloitte           Initial Creation
**/
public without sharing class SharingUtilityController {
     /***************************************************************************************************
     * @Description : Inserts the Records to be shared into the Share Object
     * @Param       : NList of sObject  records to be inserted
     * @Return      : None
     ***************************************************************************************************/
    public void Sharing_Utility_InsertRecords(List < sObject > recordsTobeInserted) {

        Database.SaveResult[] results = Database.insert(recordsTobeInserted, false);
                
        List<Database.saveResult> lstRes = new List<Database.saveResult>() ;

        for (Database.saveResult sr: results) 
        {
            if (sr.isSuccess()) 
            {
               
            } else 
            {
                lstRes.add(sr);
                
                for (Database.Error err: sr.getErrors()) {

                }
            }
        }
        
        if(lstRes.isEmpty() == false )
        {
            ErrorLogger.logDMLDatabaseResultErrors(UserInfo.getUserId(), null, lstRes, null,'sObject','Insert recordstobe inserted', 'Sharing_Utility_InsertRecords', 'SharingUtilityController','Severity', 'SharingUtilityController');
        }
    }
    
    
 
     /***************************************************************************************************
     * @Description : Deletes the Records that are already shared when required
     * @Param       : List of sObject  records to be Deleted
     * @Return      : None
     ***************************************************************************************************/
    public void Sharing_Utility_DeleteRecords(List < sObject > ToBeDeletedRecords) {

            Database.DeleteResult[] dlList = Database.delete(ToBeDeletedRecords, false);
            
            List<Database.DeleteResult> lstRes = new List<Database.DeleteResult>() ;
            for (Database.DeleteResult dr: dlList) {
                if (dr.isSuccess()) {
                } else {
                    ErrorLogger.logDMLDatabaseResultErrors(UserInfo.getUserId(), dlList,null, null,'sObject','Delete records', 'Sharing_Utility_DeleteRecords', 'SharingUtilityController','Severity', 'SharingUtilityController');
                    lstRes.add(dr);
                    
                    //logDMLDatabaseResultErrors(String userId, Database.deleteResult[] deleteResult, Database.saveResult[] saveresult, Database.upsertResult[] upsertResult, String sObjectName, String eventType, String componentName, String errClassName, String severityLevel, String moduleName) ;
                    for (Database.Error err: dr.getErrors()) {

                    }
                }
            }
            if(lstRes.isEmpty() == false )
            {
              ErrorLogger.logDMLDatabaseResultErrors(UserInfo.getUserId(), lstRes,null, null,'sObject','Delete records', 'Sharing Utility DeleteRecords', 'SharingUtilityController','Severity', 'SharingUtilityController');
            }
        }
     
     /***************************************************************************************************
     * @Description : Upserts the sObject Records that are to be shared
     * @Param       : List of sObject  records to be Upserted 
     * @Return      : None
     ***************************************************************************************************/  
    public void Sharing_Utility_UpsertRecords(List < sObject > ToBeUpsertedRecords) {
        //Upsert the Records 

        Database.UpsertResult[] results = Database.upsert(ToBeUpsertedRecords, false);

        List<Database.UpsertResult> lstRes = new List<Database.UpsertResult>() ;
        for (Database.upsertResult sr: results) {
            if (sr.isSuccess()) {
            } else {
                lstRes.add(sr);
                ErrorLogger.logDMLDatabaseResultErrors(UserInfo.getUserId(), null, null, results,'sObject','upsert records', 'Sharing_Utility_UpsertRecords', 'SharingUtilityController','Severity', 'SharingUtilityController');
                //logDMLDatabaseResultErrors(String userId, Database.deleteResult[] deleteResult, Database.saveResult[] saveresult, Database.upsertResult[] upsertResult, String sObjectName, String eventType, String componentName, String errClassName, String severityLevel, String moduleName) ;
                for (Database.Error err: sr.getErrors()) {
                }
            }
        }
        if(lstRes.isEmpty() == false )
            {
            ErrorLogger.logDMLDatabaseResultErrors(UserInfo.getUserId(), null, null, lstRes,'sObject','upsertrecords', 'Sharing Utility UpsertRecords', 'SharingUtilityController','Severity', 'SharingUtilityController');
        }   
        
    }
    
     /***************************************************************************************************
     * @Description : return a List of Delegated Users
     * @Param       : List of Contact ids which need to passed in the where Clause  
     * @Return      : List<user>
     ***************************************************************************************************/ 
    public List < user > Sharing_Utility_queryDelegatedUsers(Set < Id > ContactIds) {
        List < user > users = new List < user > ();

        if (ContactIds.size() > 0) {
            try {
                users = [Select Id, ContactId from User where ContactId in: ContactIds AND UserType = 'PowerCustomerSuccess'];
            } catch (Exception e) {
                ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'SharingUtilityController','Error Occured while querying the delegated users', 'shareRecords', 'LicVerification UsersharingModel', label.str_HIGH);
            }
        }

        return users;
    }
    
     /***************************************************************************************************
     * @Description : return a Map of ContactUser
     * @Param       : List of Users which will be looped to prepare contactUsermap  
     * @Return      : Map<Id,Id>
     ***************************************************************************************************/ 
    public Map < Id, Id > Sharing_Utility_contactUserMap(List < user > users) {
        Map < Id, Id > contactuserMap = new Map < Id, Id > ();

        if (users.size() > 0) {
            for (User u: users) {
                ContactUserMap.put(u.contactId, u.Id);
            }
        }

        return contactuserMap;
    }
    
     /***************************************************************************************************
     * @Description : return a list of custom meta data type records
     * @Param       : TriggeringObject,  TriggeringEvent 
     * @Return      : List < User_Sharing_Model__mdt >
     ***************************************************************************************************/ 
    public List < User_Sharing_Model__mdt > Sharing_Utility_queryCustomMetaDataRecords(String TriggeringObject, String TriggeringEvent) {
        List < User_Sharing_Model__mdt > customMdtShareRecords = new List < User_Sharing_Model__mdt > ();
        if (TriggeringObject != '') {
            customMdtShareRecords = [select Id, DeveloperName, Object_Relationship__c, Shared_Object__c, Object_to_Share__c, Triggering_Event__c, Triggering_Object__c, User_Access_Level__c, Sharing_Reason__c,Created_By_Delegate__c from User_Sharing_Model__mdt where Triggering_Object__c =: TriggeringObject and Triggering_Event__c =: TriggeringEvent and Created_By_Delegate__c=false];
            
        }
        
        return customMdtShareRecords;
    }
    
     /***************************************************************************************************
     * @Description : return a Map of ContactUser
     * @Param       : String ObjectToShare 
     * @Return      : Map < String, Schema.SObjectField >
     ***************************************************************************************************/ 
    public Map < String, Schema.SObjectField > Sharing_Utility_getfieldMap(String ObjectToShare) {
        Map < String, Schema.SObjectType > schemaMap = new Map < String, Schema.SObjectType > ();
        Map < String, Schema.SObjectField > fieldMap = new Map < String, Schema.SObjectField > ();

        if (ObjectToShare != '') {
            schemaMap = Schema.getGlobalDescribe();
            Schema.SObjectType leadSchema = schemaMap.get(ObjectToShare);
            fieldMap = leadSchema.getDescribe().fields.getMap();
        }

        return fieldMap;
    }
     /***************************************************************************************************
     * @Description : Break the object relationship to et AccountIds and prepare a map of AccountsObject
     * @Param       : String objectRelationship, Set < Id > AccountIds, Map < Id, Id > AccountsObjectMap, sObject sObjName
     * @Return      : none
     ***************************************************************************************************/     
        public void Sharing_Utility_BreakObjectRelationship(String objectRelationship, Set < Id > AccountIds, Map < Id, Id > AccountsObjectMap, sObject sObjName) {
        if ((objectRelationship).indexOf('.') != -1) {
            String[] objectRel = (objectRelationship).split('\\.');
            sObject sobj = sObjName;
            for (Integer i = 0; i < objectRel.size(); i++) {
                try {
                    if (i == objectRel.size() - 1) {
                        AccountIds.add((Id) sobj.get(objectRel[i]));
                        AccountsObjectMap.put((Id) sobj.get(objectRel[i]), sObjName.Id);
                    } else {
                        sobj = sobj.getSObject(objectRel[i]);
                    }
                } catch (Exception e) {
                    if(!Test.isRunningTest()) ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'SharingUtilityController', 'Error Occured while prepare a map of sObject', 'shareRecords', 'LicVerification UsersharingModel', label.Str_HIGH);
                	system.debug('Exception in Sharing_Utility_BreakObjectRelationship: '+e);
                }
            }
        } else {
            AccountIds.add((Id) sObjName.get(objectRelationship));
            AccountsObjectMap.put((Id) sObjName.get(objectRelationship), sObjName.Id);
        }
    }
    public List< sObject > Sharing_Utility_QueryShareRecords(List<Id>conIds,string QueryString){
        List< sObject > shareRecords = new List< sObject >();
        try{        
            shareRecords = Database.Query(QueryString); 
        }
        catch(exception e){
            ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'SharingUtilityController', 'Error Occured while prepare a_map of sObject', 'shareRecords', 'LicVerification UsersharingModel', label.Str_HIGH);
        }
        
        return shareRecords;
    }
    
    /***************************************************************************************************
     * @Description : Break the object relationship to et AccountIds and prepare a map of ContactsObject
     * @Param       : String objectRelationship, Set < Id > ContactIds, Map < Id, Id > ContactsObjectMap, sObject sObjName
     * @Return      : none
     ***************************************************************************************************/ 
    public void Sharing_Utility_BreakObjectRelationship_for_UserUpgrade(String objectRelationship, List < Id > ContactIds, Map < Id, Id > ContactsObjectMap, sObject sObjName) {
        if ((objectRelationship).indexOf('.') != -1) {
            String[] objectRel = (objectRelationship).split('\\.');
            sObject sobj = sObjName;
            for (Integer i = 0; i < objectRel.size(); i++) {
                try {
                    if (i == objectRel.size() - 1) {
                        ContactIds.add((Id) sobj.get(objectRel[i]));
                        ContactsObjectMap.put(sObjName.Id,(Id) sobj.get(objectRel[i]));
                    } else {
                        sobj = sobj.getSObject(objectRel[i]);
                    }
                } catch (Exception e) {
                    ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'SharingUtilityController', 'Error Occured while prepare a map of sObject', 'shareRecords', 'LicVerification UsersharingModel', label.Str_HIGH);
                }
            }
        } else {
            ContactIds.add((Id) sObjName.get(objectRelationship));
            ContactsObjectMap.put(sObjName.Id,(Id) sObjName.get(objectRelationship));
        }
    }
    
     /***************************************************************************************************
     * @Description : Inserts Share Object Records
     * @Param       : sObject sObjectName,Id ParentId, Id UserId, String UserAccessLevel 
     * @Return      : sObject
     ***************************************************************************************************/
    public void dynamicShareObjectUpsert(Map<Id,Id> AccountsObjectMap,Map<Id,Id> Account_AccountContact_Map,Map<Id,List<Id>> AccountContact_Contact_Map,Map<Id,Id> ContactUserMap,String ShareObjectName,String SharingReason,String AccessLevel){
        List<sObject> ShareObjectRecords = new List<sObject>();
        
        for(Id AccountId: AccountsObjectMap.keySet()){
            Id parentId = null;
            if (AccountsObjectMap.get(AccountId) != null) {
                parentId = AccountsObjectMap.get(AccountId);
            }
            
            Id AccountContactId = null;
            if (Account_AccountContact_Map.get(AccountId) != null) {
                AccountContactId = Account_AccountContact_Map.get(AccountId);
            }
            
            List<Id> lstContactId = null;
            if (AccountContact_Contact_Map.get(AccountContactId) != null) {
                lstContactId = AccountContact_Contact_Map.get(AccountContactId);
            }
            
            sObject sObj = Schema.getGlobalDescribe().get(ShareObjectName).newSObject();
            if(lstContactId != null){
            for(Id ContactId : lstContactId){
            	Id UserId = null;
                if (ContactUserMap.get(ContactId) != null) {
                    UserId = ContactUserMap.get(ContactId);
                }
                
                try{
                    if(UserId!=null){
                        sObj.put('ParentId', parentId);
                        sObj.put('UserOrGroupId', UserId);
                        sObj.put('AccessLevel', AccessLevel);
                        sObj.put('RowCause', Sharingreason);
                        
                        ShareObjectRecords.add(sObj);  
                    }
                }catch(exception e){
                   ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'SharingUtilityController','Error Occured while creating the sharerecord', 'dynamicShareObjectUpsert', 'SharingUtilityController',label.Str_HIGH); 
                }
            }
        	}
        }
        
        if(ShareObjectRecords.size()>0){
            Sharing_Utility_InsertRecords(ShareObjectRecords);
        }
    }
    
    Public List<MUSW__Account_Contact__c> QueryAccountContacts(Map<Id,Id> AccountsObjectMap,List<MUSW__Account_Contact__c> AccountContacts,String ControllerName)
    {
        try {
            AccountContacts = [select MUSW__Account__c, MUSW__Contact__c from MUSW__Account_Contact__c where MUSW__Account__c In: AccountsObjectMap.keySet() AND Associate_Status__c = 'Active'];
        }
        Catch(Exception e) {
             ErrorLogger.logGeneralException(e, UserInfo.getUserId(), ControllerName, 'Error Occured while querying Account Contact Records', 'shareRecords', ControllerName, label.Str_HIGH);
         }
        return AccountContacts;
    }
    
   
     /***************************************************************************************************
     * @Description : 
     * @Param       : Set<Id> RecordIds, String ObjectName, String TriggeringEvent, String ControllerName, String SharingReason 
     * @Return      : None
     ***************************************************************************************************/
    public void ShareRecordProcessingUtility(Set<Id> RecordIds, String ObjectName, String TriggeringEvent, String ControllerName, String SharingReason){
           List<sObject> sObjectRecordList = new List<sObject>();
           set<Id> AccountIds = new Set<Id>();
           Map<Id,Id> AccountSobject = new Map<Id,Id>();
           List<MUSW__Fee__c> feeList = new List<MUSW__Fee__c>();
           List<User_Sharing_Model__mdt> customMdtShareRecords = Sharing_Utility_queryCustomMetaDataRecords(ObjectName, TriggeringEvent);
           System.debug('customMdtShareRecords in line 338' +customMdtShareRecords);
           Set<User_Sharing_Model__mdt> newcustomMdtShareRecords= new Set<User_Sharing_Model__mdt>();
           String feeQuery;
           if(ObjectName == 'MUSW__Fee__c'){
               feeQuery = 'Select Id, Name, MUSW__License2__c, MUSW__Permit2__c from '+ObjectName+' where ID IN :RecordIds';
           }
           system.debug('feeQuery>>>'+feeQuery);
           if (feeQuery != null && feeQuery != '') {
                feeList = Database.Query(feeQuery);
           }
           system.debug('feeList>>>'+feeList);
           if(feeList.size() > 0){
           	for(MUSW__Fee__c fee : feeList){
               for(User_Sharing_Model__mdt customMdtShareRecord: customMdtShareRecords){
                   if(fee.MUSW__License2__c != null){
                       if(customMdtShareRecord.DeveloperName.contains('Credential')){
                       		newcustomMdtShareRecords.add(customMdtShareRecord);
                       		system.debug('Entered MUSW__License2__c');
                       }    
                    } else if(fee.MUSW__Permit2__c != null){
                        if(customMdtShareRecord.DeveloperName.contains('Permit')){
                            newcustomMdtShareRecords.add(customMdtShareRecord);
                            system.debug('Entered MUSW__Permit2__c');
                        }   
                    } else{
                            newcustomMdtShareRecords.add(customMdtShareRecord);
                            system.debug('Entered Else');
                    }
               }
              }
           }
           system.debug('newcustomMdtShareRecords>>>'+newcustomMdtShareRecords);
           try {
               for (User_Sharing_Model__mdt customMdtShareRecord: newcustomMdtShareRecords) {
                   if (customMdtShareRecord.Shared_Object__c != null) {
                           if ('Id' != customMdtShareRecord.Object_Relationship__c) {
                               String QueryString = 'Select Id, Name, ' + customMdtShareRecord.Object_Relationship__c + ' from '+ObjectName+' where ID IN :RecordIds';
                               
                               if (QueryString != null && QueryString != '') {
                                   sObjectRecordList = Database.Query(QueryString);
                                   
                                   System.debug('Entered' +sObjectRecordList);
                                   if (sObjectRecordList.size() > 0) {
                                       for(sObject sObj:sObjectRecordList) {
                                           Sharing_Utility_BreakObjectRelationship(customMdtShareRecord.Object_Relationship__c, AccountIds, AccountSobject, sObj);
                                       }
                                   }
                                   shareRecords(AccountSobject, AccountIds, customMdtShareRecord.Object_Relationship__c, customMdtShareRecord.User_Access_Level__c,ControllerName,customMdtShareRecord.Object_to_Share__c,SharingReason);
                               }
                           }
                   }
               }
           }catch(exception e){
               ErrorLogger.logGeneralException(e, UserInfo.getUserId(), ControllerName, 'ShareRecords CreatedByDelegate', 'shareRecords', ControllerName, Label.Str_HIGH);
           }
    }
    
     /***************************************************************************************************
     * @Description : 
     * @Param       : Map<Id,Id> AccountsObject,Set < Id > AccIds, string ObjectRelationship, string AccessLevel,String COntrollerName,String ShareObjectName,String SharingReason 
     * @Return      : None
     ***************************************************************************************************/
    public void shareRecords(Map<Id,Id> AccountsObject,Set < Id > AccIds, string ObjectRelationship, string AccessLevel,String COntrollerName,String ShareObjectName,String SharingReason)
    {
        List<MUSW__Account_Contact__c> AccountContacts = new List<MUSW__Account_Contact__c>();
        Set<Id> setContactIds = new Set<Id>();
        Map<Id,Id> Account_AccountContact_Map = new Map<Id,Id>();
        Map<Id, List<Id>> AccountContact_Contact_Map = new Map<Id, List<Id>>();
        List<User> users = new List<User>();
        Map<Id,Id> contactuserMap = new Map<Id,Id>();
        if(AccountsObject.size()>0)
        {
            AccountContacts = QueryAccountContacts(AccountsObject, AccountContacts, COntrollerName);
        }
        if (AccountContacts.size() > 0) {
            for (MUSW__Account_Contact__c AccountContact: AccountContacts) {
                setContactIds.add(AccountContact.MUSW__Contact__c);
                Account_AccountContact_Map.put(AccountContact.MUSW__Account__c, AccountContact.Id);
                
                List<Id> accConList = AccountContact_Contact_Map.get(AccountContact.Id);
                if(accConList == null) accConList = new List<Id>();
                accConList.add(AccountContact.MUSW__Contact__c);
                AccountContact_Contact_Map.put(AccountContact.Id, accConList);
            }
        }
        if (setContactIds.size() > 0) {
            users = Sharing_Utility_queryDelegatedUsers(setContactIds);
        }
        if (users.size() > 0) {
            ContactUserMap = Sharing_Utility_contactUserMap(users);
        } 
        dynamicShareObjectUpsert(AccountsObject,Account_AccountContact_Map,AccountContact_Contact_Map,ContactUserMap,ShareObjectName,SharingReason,AccessLevel);
    }
    
     /***************************************************************************************************
     * @Description : 
     * @Param       : List<Id> ContactIds,List<Id> recIds,String ObjectName,String ControllerName 
     * @Return      : None
     ***************************************************************************************************/
    public void ShareRecords_CreatedByDelegate(List<Id> ContactIds,List<Id> recIds,String ObjectName,String ControllerName)
    {
        List<user> Users = new List<user>();
        Map<Id,Id> ContactUserMap = new Map<Id,Id>();
        List<sObject> sObjectRecordList = new List<sObject>();
        List<sObject> ShareObjectRecords = new List<sObject>();
        List < User_Sharing_Model__mdt > customMdtShareRecords = [select Id, DeveloperName, Object_Relationship__c, Shared_Object__c, Sharing_Reason__c, Object_to_Share__c, Triggering_Event__c, Triggering_Object__c, User_Access_Level__c from User_Sharing_Model__mdt where Triggering_Object__c =:ObjectName
            and Created_By_Delegate__c = true
        ];
        
        Set<Id> setContactIds = new Set<Id>();
        setContactIds.addAll(ContactIds);
        users = Sharing_Utility_queryDelegatedUsers(setContactIds);
        if (users.size() > 0) {
            ContactUserMap = Sharing_Utility_contactUserMap(users);
        }
        try{
            if(customMdtShareRecords.size()>0)
            {
                for (User_Sharing_Model__mdt customMdtShareRecord: customMdtShareRecords) {
                    if (customMdtShareRecord.Shared_Object__c != null) {
                        Map < String, Schema.SObjectField > fieldMap = Sharing_Utility_getfieldMap(customMdtShareRecord.Shared_Object__c); 
                        List < Id > RecordIds = new List < Id > ();
                        RecordIds.addAll(recIds);
                        String QueryString = '';
                        if (customMdtShareRecord.Shared_Object__c != label.Str_Contact) {
                            QueryString = 'select Id,Name,' + customMdtShareRecord.Object_Relationship__c + ' from ';
                            QueryString = QueryString + customMdtShareRecord.Shared_Object__c + ' where ';
                            QueryString = QueryString + customMdtShareRecord.Object_Relationship__c + ' IN :ContactIds'+' and Id IN:RecordIds';
                            
                            sObjectRecordList = Database.Query(QueryString);
                            
                            if (sObjectRecordList.size() > 0) {
                                ShareObjectRecords = new List < sObject > ();
                                
                                for (sObject recordtobeShared: sObjectRecordList) {
                                    Id contactId = null;
                                    // Break the Object relationship to get the contact Id 
                                if ((customMdtShareRecord.Object_Relationship__c).indexOf('.') != -1) {
                                    String[] objectRel = (customMdtShareRecord.Object_Relationship__c).split('\\.');
                                    sObject sobj = recordtobeShared;
                                    for (Integer i = 0; i < objectRel.size(); i++) {
                                        if(sobj != null){
                                            if (i == objectRel.size() - 1) {
                                                contactId = (Id) sobj.get(objectRel[i]);
                                            } else {
                                                sobj = sobj.getSObject(objectRel[i]);
                                            }
                                        }
                                    }
                                 } else {
                                        contactId = (Id) recordtobeShared.get(fieldMap.get(customMdtShareRecord.Object_Relationship__c));
                                    }
                                
                                    //Initialize share Object. For Example: if you want to share License, this sObject will be MUSW__License2__share
                                    if (customMdtShareRecord.Object_to_Share__c != null) {
                                            sObject sObj = Schema.getGlobalDescribe().get(customMdtShareRecord.Object_to_Share__c).newSObject();
                                            if (contactId != null && sObj != null && ContactUserMap.get(contactId) != null) {
    
                                                sObj.put('parentId', recordtobeShared.Id);
                                                sObj.put('UserOrGroupId', ContactUserMap.get(contactId));
                                                sObj.put('AccessLevel', customMdtShareRecord.User_Access_Level__c);
                                                sObj.put('RowCause', customMdtShareRecord.Sharing_Reason__c);
                                                ShareObjectRecords.add(sObj);
                                            }
                                    }
                                }
                                if (ShareObjectRecords.size() > 0) {
                                    Sharing_Utility_InsertRecords(ShareObjectRecords);
                                }
                            }   
                        }
                    }
                }
            }
        }catch(Exception e){
            ErrorLogger.logGeneralException(e, UserInfo.getUserId(), ControllerName, ControllerName, 'ShareRecords CreatedByDelegate', ControllerName, label.str_HIGH);
        }
    }
}