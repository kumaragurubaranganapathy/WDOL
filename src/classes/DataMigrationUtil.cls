/*************************************************************************************************************
**
**************************************************************************************************************
** Class Name    : DataMigrationUtil
** Description   : This class is the utility to delete the old data and insert new data transmitted by
**                  DataObjectService service in the REST response.
** Version       : 1.0
** Built By      : Masood Mahmood
**------------------------------------------------------------------------------------------------------------
** Modification Log:
**------------------
** Developer                         Date                    Version                     Description
**------------------------------------------------------------------------------------------------------------
** Masood Mahmood                   09/27/2016                1.0                        Created
** Srikanth Kottam                  02/22/2018                2.0             Added exception handling and Logging Errors
** Review Log:
**---------------
** Reviewer                         Date                    Version                      Description
**------------------------------------------------------------------------------------------------------------
**
**  **********************************************************************************/
public class DataMigrationUtil {
    public String sObjectName;
    public static boolean hasJobStarted = false;
    public static boolean hasJobFinished = false;
    public String sourceOrg;
    public String targertOrg;
    public String ParentOrChild;
    
    /**
* Method name  : DataMigrationUtil
* Description  : This constructor is passed the object name when it is called by the DataObjectService class.
* Return Type  : None. It is a constructor.
* Parameter    : String
**/
    public DataMigrationUtil(String sObjectName, String ParentOrChild) {
        this.sObjectName = sObjectName;
        this.ParentOrChild = ParentOrChild;
    }
    
    
    /**
* Method name  : insertRecords
* Description  : If the parameter - List<Sobject> has 50k or more records, a DMLException will be thrown.
*                If the records are less than 50k, the method will insert them and returns true if successful.
* Return Type  : boolean
* Parameter    : SOBJECT []
**/
    public boolean insertRecords(SOBJECT [] toBeInserted, Integer recordSizeLimit) {
        System.debug('DataMigrationUtil.insertRecords() WARNING*** inserting in ... ' + sObjectName);
        if (toBeInserted.size() > recordSizeLimit) { 
            hasJobFinished = false;
            throw new DMLException('Error : The Sobject List has '+ recordSizeLimit +' or more records for insertion at line 51');
        }
        
        for ( Sobject item : toBeInserted ) {
            if(!sObjectName.contains('Question__c')&&!sobjectName.contains('MUSW__Master_Submission_List__c'))
            {
                item.put(label.Api_External_Id, item.Id);
            }
            item.put('Id', null);
        }
        if (ParentOrChild != ''&&sObjectName != 'MUSW__Master_Submission_List__c') {
            List<Sobject> parent = Database.query('Select id ,external_id__c from ' + ParentOrChild);
            Data_Object__mdt objectswithparents = Database.query('SELECT Id, MasterLabel, Mapping__c, Field_to_Map__c FROM Data_Object__mdt where MasterLabel = \'' + sObjectName + '\'');
            Map <Id, list <Sobject>> idMap = new Map <Id, list <Sobject>> ();
            
            for (Sobject singleitem : parent ) {
                id parentextidfromtarget = (id)singleitem.get(label.Api_External_Id);
                list <Sobject> newlist = new list <Sobject> ();
                idMap.put(parentextidfromtarget, newlist);
            }
            for ( Sobject item : toBeInserted ) {
                id parentextidfromsource = (id) item.get(objectswithparents.Field_to_Map__c);
                list <Sobject> newlist = idMap.get(parentextidfromsource);
                if (newlist == null) {
                    newlist = new list<Sobject>();
                }
                newlist.add(item);
                idMap.put(parentextidfromsource, newlist);
            }
            for (Sobject singleitem : parent ) {
                Id lstProgId = (id)singleitem.get(label.Api_External_Id);
                list <Sobject> newlist = idMap.get(lstProgId);
                for ( Sobject item : newlist) {
                    item.put(objectswithparents.Field_to_Map__c , singleitem.id);
                }
            }
        }
        
        if (sObjectName.equalsIgnoreCase('Newsfeed__c') || sObjectName.equalsIgnoreCase('Question__c')) {
            System.debug('sObjectName***********'+sObjectName);
            if (sObjectName.equalsIgnoreCase('Newsfeed__c')) {
                hasJobFinished = InsertNewsRecords(toBeInserted); //Revert back to specificOHNList in the param, if needed.
                return hasJobFinished;
            } else if (sObjectName.equalsIgnoreCase('Question__c')) {
                hasJobFinished = insertQuestionRecords(toBeInserted); //Revert back to specificQuestions in the param, if needed.
                return hasJobFinished;
            }
        } else if (sObjectName == 'MUSW__Sequence_Number__c') {
            hasJobFinished = insertSequenceNumbers(toBeInserted); //Revert back to seqNList in the param, if needed.
            return hasJobFinished;
        }
        else if (sObjectName == 'MUSW__Master_Submission_List__c') {
            hasJobFinished = insertSubmissionList(toBeInserted); //Revert back to seqNList in the param, if needed.
            return hasJobFinished;
        }
        
        Set<String> Fieldset  = Schema.GetGlobalDescribe().get(sObjectName).getDescribe().fields.getMap().keyset();
        for (Sobject item : toBeInserted) {
            Map<String, String> fieldToBePassedMap = new Map<String, String>();
            fieldToBePassedMap.put(label.Str_SetupOwnerId, UserInfo.getOrganizationId());
            fieldToBePassedMap.put(label.Str_OwnerId, UserInfo.getUserId());
            String fieldtobepassed = label.Str_SetupOwnerId;
            String fieldtobepassed2 = label.Str_OwnerId;
            for(String fToPass : fieldToBePassedMap.keySet()){
                if(Fieldset.contains(fToPass.toLowerCase())){
                    item.put(fToPass, fieldToBePassedMap.get(fToPass));
                }
            }            
        }
        
        List<Database.SaveResult> lstRes = new List<Database.SaveResult>();
        Database.SaveResult [] srList = Database.insert(toBeInserted, false);
        for (Database.SaveResult sr : srList) {
            if (!sr.isSuccess()) {
                lstRes.add(sr);
                System.debug('The following error has occurred while inserting in ' + sObjectName);
                for (Database.Error err : sr.getErrors()) {
                    system.debug('SaveResultError ' + sr);
                    system.debug(err.getStatusCode() + ' : ' + err.getMessage());
                }
            }
        }
        System.debug('Successfully inserted : ' + (srList.size() - lstRes.size()) + ' records in ' + sObjectName +
                     '\nAnd ' + lstRes.size() + ' failed in ' + sObjectName);
        
        hasJobFinished = true;
        return hasJobFinished;
    }
    
    /**
* Method name  : insertNewsRecords
* Description  : This method is supposed to be running before insertRecords() to load the data transmitted by the DataObjectService.
*                If the purge operation is successful, the return value is true otherwise return value is false.
* Return Type  : boolean
* Parameter    : List<Newsfeed__c>
**/
    public boolean insertNewsRecords(SObject [] toBeInserted) {
        hasJobFinished = false;
        List<Schema.RecordTypeInfo> recordTypeInfo = Schema.getGlobalDescribe().get(sObjectName).getDescribe().getRecordTypeInfos();
        Map<String, Id> mapOfRecordTypeIdByName = new Map<String, Id>();
        for (Schema.RecordTypeInfo info : recordTypeInfo) {
            mapOfRecordTypeIdByName.put(info.getName(), info.getRecordTypeId());
        }
        List<Newsfeed__c> specificOHNList = new List<Newsfeed__c>();
        specificOHNList.addAll((List<Newsfeed__c>) toBeInserted);        
        for (Newsfeed__c revList : specificOHNList) {
            revlist.RecordTypeId = mapOfRecordTypeIdByName.get(revList.Record_Type_Name__c);
            revlist.OwnerId = UserInfo.getUserId();
        }
        
        List<Database.SaveResult> lstRes = new List<Database.SaveResult>();
        Database.SaveResult [] srList = Database.insert(specificOHNList, false);
        ErrorLogger.logDMLDatabaseResultErrors(UserInfo.getUserId(), null, srList, null, 'DataMigrationUtil', 'Insert records', 'insertNewsRecords', 'DataMigrationUtil', label.str_HIGH, null);
        for (Database.SaveResult sr : srList) {
            if (!sr.isSuccess()) {
                lstRes.add(sr);
                
                for (Database.Error err : sr.getErrors()) {
                    
                }
            }
        }        
        
        hasJobFinished = true;
        return hasJobFinished;
    }
    
    
    /** for submissionlist
**/
    public boolean insertSubmissionList(SObject [] toBeInserted) {
        hasJobFinished = false;
        List<Schema.RecordTypeInfo> recordTypeInfo = Schema.getGlobalDescribe().get(sObjectName).getDescribe().getRecordTypeInfos();
        Map<String, Id> mapOfRecordTypeIdByName = new Map<String, Id>();
        for (Schema.RecordTypeInfo info : recordTypeInfo) {
            mapOfRecordTypeIdByName.put(info.getName(), info.getRecordTypeId());
        }
        List<MUSW__Master_Submission_List__c> subList = new List<MUSW__Master_Submission_List__c>();
        subList.addAll((List<MUSW__Master_Submission_List__c>) toBeInserted);        
        for (MUSW__Master_Submission_List__c revList : subList) {
            revlist.RecordTypeId = mapOfRecordTypeIdByName.get(revList.Record_type_Name__c);
            revlist.OwnerId = UserInfo.getUserId();
        }
        
        
        String questionsissue='';
        for (MUSW__Master_Submission_List__c key : subList)
        {
            if(key.External_Id_of_Question__c!=null){
                questionsissue+=key.External_Id_of_Question__c +',';
            }
        }
        String newStr = '' ;
        String[] myList = new List<String>();
        myList = questionsissue.split(',');
        for(String str : myList)
        {
            newStr += '\'' + str.trim() + '\',';
            newStr = newStr.lastIndexOf(',') > 0 ? newStr.substring(0,newStr.lastIndexOf(',')) + ',' : newStr ;
        }
        
        if(newStr.length()>0)
        {
            newStr= newStr.substring(0,newStr.lastIndexOf(','));
        }
        System.debug(' newStr '+newStr);
        String queryStr='SELECT Id, external_id__c FROM Question__c where external_id__c IN ('+newStr+')';
        List<Question__c> relatedQuestion =database.query(queryStr);
        //List<Question__c> relatedQuestion =  [SELECT Id,external_id__c from Question__c where external_id__c =:questionsissue];
        Map<String,Id> questionExt = new  Map<String,Id> ();
        for(Question__c  key :relatedQuestion)
        {
            questionExt.put(key.External_Id__c, key.id);
        }
        for(MUSW__Master_Submission_List__c  test :subList)
        {
            if(test.External_Id_of_Question__c!=null)
            {
                Id home= questionExt.get(test.External_Id_of_Question__c);
                test.question__c=home;
            }
        }
        List<Database.SaveResult> lstRes = new List<Database.SaveResult>();
        Database.SaveResult [] srList = Database.insert(subList, false);
        ErrorLogger.logDMLDatabaseResultErrors(UserInfo.getUserId(), null, srList, null, 'DataMigrationUtil', 'Insert records', 'insertNewsRecords', 'DataMigrationUtil', label.str_HIGH, null);
        for (Database.SaveResult sr : srList) {
            if (!sr.isSuccess()) {
                lstRes.add(sr);
                
                for (Database.Error err : sr.getErrors()) {
                    
                }
            }
        }        
        
        hasJobFinished = true;
        return hasJobFinished;
    }
    
    /**
* Method name  : insertQuestionRecords
* Description  : This method is supposed to be running before insertRecords() to load the data transmitted by the DataObjectService.
*                If the purge operation is successful, the return value is true otherwise return value is false.
* Return Type  : boolean
* Parameter    : List<Question__c>
**/
    public boolean insertQuestionRecords(List<Sobject> toBeInserted) {
        hasJobFinished = false;
        List<Schema.RecordTypeInfo> recordTypeInfo = Schema.getGlobalDescribe().get(sObjectName).getDescribe().getRecordTypeInfos();
        Map<String, Id> mapOfRecordTypeIdByName = new Map<String, Id>();
        for (Schema.RecordTypeInfo info : recordTypeInfo) {
            mapOfRecordTypeIdByName.put(info.getName(), info.getRecordTypeId());
        }
        List<Question__c> specificQuestions = new List<Question__c>();
        //specificQuestions.addAll((List<Question__c>) toBeInserted);
        for(SObject record : toBeInserted) {
            specificQuestions.add((Question__c) record);
        }
        for (Question__c revList : specificQuestions) {
            revList.put(label.Str_RecordTypeId, mapOfRecordTypeIdByName.get(revList.Record_Type_Name__c));
            revlist.OwnerId = UserInfo.getUserId();
        }
        
        List<Database.SaveResult> lstRes = new List<Database.SaveResult>();
        Question__c [] withoutid = toBeInserted.deepClone();
        for (Question__c revList : withoutid) {
            revList.put(label.API_Parent_Question, null);
        }
        Database.SaveResult [] srList = Database.insert(withoutid, false);
        ErrorLogger.logDMLDatabaseResultErrors(UserInfo.getUserId(), null, srList, null, 'DataMigrationUtil', 'Insert records', 'insertQuestionRecords', 'DataMigrationUtil', label.str_HIGH, null);
        for (Database.SaveResult sr : srList) {
            if (!sr.isSuccess()) {
                lstRes.add(sr);
                for (Database.Error err : sr.getErrors()) {
                    
                }
            }
        }
        
        
        List<Question__c> parent = [SELECT Id, external_id__c FROM Question__c where id != NULL];
        Map <String, Question__c> idMap = new Map <String, Question__c> ();
        Map <String, Question__c> idMap2  = new Map <String, Question__c> ();
        Map <String, Id> idMap3  = new Map <String, Id> ();
        Map <Id, String> idMap4  = new Map  <Id, String> ();
        List< Question__c> updatedList = new   List< Question__c> ();
        List< Question__c> updatedList2 = new   List< Question__c> ();
        for (Question__c singleitem : parent ) {
            String parentextidfromtarget = (String)singleitem.get(label.Api_External_Id);
            idMap.put(parentextidfromtarget, singleitem);
        }
        
        for (Question__c singleitem : specificQuestions ) {
            String parentextidfromtarget = (String)singleitem.get(label.Api_External_Id);
            idMap2.put(parentextidfromtarget, singleitem);
        }
        
        for (Question__c singleitem : parent ) {
            String parentextidfromtarget = (String)singleitem.get(label.Api_External_Id);
            idMap3.put(parentextidfromtarget, singleitem.id);
        }
        
        
        Integer i = 0;
        System.debug('Ruuuud');
        for (String mapLoop : idMap.keyset()) {
            Question__c obj =  idMap.get(mapLoop);
            Question__c objfromsource = idMap2.get(mapLoop);
            System.debug('objfromsource  '+objfromsource);
            if(objfromsource!=null){
                System.debug('objfromsource.External_Id_of_Parent__c '+objfromsource.External_Id_of_Parent__c);
                String three = idMap3.get(objfromsource.External_Id_of_Parent__c);
                System.debug('three  '+three );
                if (three != null && i <= 10000) {
                    System.debug('three '+three);
                    obj.Parent_Question__c = three;
                    updatedlist.add(obj);
                }
                if (three != null && i > 10000) {
                    obj.Parent_Question__c =three;
                    updatedlist2.add(obj);
                }
                i++;
            }
        }
        
        lstRes = new List<Database.SaveResult>();
        srList = Database.update(updatedlist, false);
        ErrorLogger.logDMLDatabaseResultErrors(UserInfo.getUserId(), null, srList, null, 'DataMigrationUtil', 'Update records', 'insertQuestionRecords', 'DataMigrationUtil', label.str_HIGH, null);
        for (Database.SaveResult sr : srList) {
            if (!sr.isSuccess()) {
                lstRes.add(sr);
                for (Database.Error err : sr.getErrors()) {
                    
                }
            }
        }
        srList = Database.update(updatedlist2, false);
        ErrorLogger.logDMLDatabaseResultErrors(UserInfo.getUserId(), null, srList, null, 'DataMigrationUtil', 'Insert records', 'insertQuestionRecords', 'DataMigrationUtil', label.str_HIGH, null);
        for (Database.SaveResult sr : srList) {
            if (!sr.isSuccess()) {
                lstRes.add(sr);
                
                for (Database.Error err : sr.getErrors()) {
                    
                }
            }
        }        
        hasJobFinished = true;
        return hasJobFinished;
    }
    
    /**
* Method name  : insertSequenceNumbers
* Description  : This method is supposed to be running before insertRecords() to load the data transmitted by the DataObjectService.
*                If the purge operation is successful, the return value is true otherwise return value is false.
* Return Type  : boolean
* Parameter    : List<MUSW__Sequence_Number__c>
**/
    public boolean insertSequenceNumbers(SObject [] toBeInserted) {
        hasJobFinished = false;
        List<MUSW__Sequence_Number__c> seqNList = toBeInserted;
        for (MUSW__Sequence_Number__c item : seqNList) {
            if (item.Name == Label.Str_Default) {
                item.MUSW__Source_Type_Fields__c = null;
                item.OwnerId = UserInfo.getUserId();
            }
        }
        
        List<Database.SaveResult> lstRes = new List<Database.SaveResult>();
        Database.SaveResult [] srList = Database.insert(seqNList, false);
        ErrorLogger.logDMLDatabaseResultErrors(UserInfo.getUserId(), null, srList, null, 'DataMigrationUtil', 'Insert records', 'execute', 'DataMigrationUtil', label.str_HIGH, null);
        for (Database.SaveResult sr : srList) {
            if (!sr.isSuccess()) {
                lstRes.add(sr);
                
                for (Database.Error err : sr.getErrors()) {
                    
                }
            }
        }
        
        
        hasJobFinished = true;
        return hasJobFinished;
    }
    
    /**
* Method name  : purgeRecords
* Description  : This method will delete all the data specified by the object name in the constructor, which is called by the
*                DataObjectService class.
*                This method is supposed to be running before insertRecords() to load the data transmitted by the DataObjectService.
*                If the purge operation is successful, the return value is true otherwise return value is false.
* Return Type  : boolean
* Parameter    : None
**/
    public boolean purgeRecords() {
        try{
            List<Sobject> sList = Database.query('SELECT Id FROM ' + sObjectName);
            Database.delete(sList);
            Integer recordCount = Database.countQuery('SELECT count() FROM ' + sObjectName );
            if (recordCount == 0) {
                hasJobStarted = true;
            }
        }
        catch(Exception e){
            ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'DataMigrationUtil', 'Delete Records', 'purgeRecords', 'DataMigrationUtil', label.str_HIGH);
        }
        return hasJobStarted;
    }
    
    /*  public Map<String,Sobject> currentRecords() {
Map<String,Sobject> sList = new Map<String,Sobject>();
List<Sobject> currentrecs = new List<Sobject> ();
try{
currentrecs =  (Database.query('SELECT Id,external_id__c FROM ' + sObjectName)); 
if(currentrecs.size()>0){
for(Sobject a : currentrecs){
String externalid= (String)a.get('external_id__c');
Slist.put(externalid,a);
}
}
}
catch(Exception e){
ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'DataMigrationUtil', 'Current Records', 'currentRecords', 'DataMigrationUtil', label.str_HIGH);
}
return sList;
}*/
    
}