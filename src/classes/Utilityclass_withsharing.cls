/*@AUTHOR: H ADARSH
@Date: 12-August-2018 

Description: Utlity Class to perform DML Operations on records. 

MODIFICATION LOG:
DEVELOPER                          DATE                     DESCRIPTION
================================================================================
H ADARSH                        12-August-2018             Initial Creation
================================================================================= */


public class Utilityclass_withsharing {   
    public static final String sSize = 'Size';
    public static Boolean bIsTestClass = false;
    public static final list<String> lstEmptyError= new list<String>{'List is empty'}; 
    static final List<String> lstObjExcl = new List<String>{'User'};
    /*********************************************************************
     * Method Name:insertList
     * Description:This method is used to Insert Records 
     * Return Type:List<SObject>
     * Parameter: List of Records.
     * ******************************************************************/
    public static List<SObject> insertList(List<SObject> lstForInsert){
        if(!lstForInsert.isEmpty()){
            
                  Boolean bAccessCheck = checkDMLAccess(lstForInsert, 'insert');
                 if(bAccessCheck)
				    insert lstForInsert;
				 else
                  throw new NoAccessException();
            
        }
        return lstForInsert;
   }
   
     /*********************************************************************
     * Method Name:updateList
     * Description:This method is used to Update Records 
     * Return Type:List<SObject>
     * Parameter: List of Records.
     * ******************************************************************/
    public static List<SObject> updateList(List<SObject> lstForUpdate) {    
        if(!lstForUpdate.isEmpty()){
            
			 Boolean bAccessCheck = checkDMLAccess(lstForUpdate, 'update');
            if(bAccessCheck)
             update lstForUpdate;
			 else
                throw new NoAccessException();
             
           
        }   
        return lstForUpdate;
    }
    /*********************************************************************
     * Method Name:deleteList
     * Description:This method is used to Delete Records 
     * Return Type:List<SObject>
     * Parameter: List of Records.
     * ******************************************************************/    
    public static List<SObject> deleteList(List<SObject> lstForDelete) {
        if(!lstForDelete.isEmpty()) {  
           
		    Boolean bAccessCheck = checkDMLAccess(lstForDelete, 'delete');
            if(bAccessCheck)
                 delete lstForDelete;
			 else
                throw new NoAccessException();
           
            
        }
        return lstForDelete;
    }
    /*********************************************************************
     * Method Name:upsertList
     * Description:This method is used to Upsert Records 
     * Return Type:List<SObject>
     * Parameter: List of Records.
     * ******************************************************************/ 
    public static List<SObject> upsertList(List<SObject> lstForUpsert) {
        if(!lstForUpsert.isEmpty()){
            
			 Boolean bAccessCheck = checkDMLAccess(lstForUpsert, 'upsert');
			 if(bAccessCheck)
			   upsert lstForUpsert;
		    else
                throw new NoAccessException();
           
                 
        }   
        return lstForUpsert;
    }
    /********************************************************************************************
    METHOD NAME    : checkObjectFieldAccess
    DESCRIPTION    : This method is used to check access for object and fields.
    RETURN TYPE    : Boolean
    PARAMETER      : String, list<String>
    ********************************************************************************************/
    public static Boolean checkObjectFieldAccess(String sObjectName, String sSubQuery) {
        Schema.SObjectType convertType = Schema.getGlobalDescribe().get(sObjectName);
        Schema.DescribeSObjectResult objectDescription = convertType.getDescribe();
        System.debug(sObjectName + ' isQueryable:'+objectDescription.isQueryable());
        if(objectDescription.isQueryable()) {
            list<String> lstFieldNames = sSubQuery.split(',');
            Map<String, SObjectField> fields = convertType.getDescribe().fields.getMap();
            for(String sFieldName : lstFieldNames) {
                sFieldName = sFieldName.trim();
                System.debug('sFieldName:'+sFieldName);
                sFieldName = sFieldName.contains('__r') ? sFieldName.substringBefore('.').removeEnd('r') + 'c'  : sFieldName;
                if(sFieldName != null && sFieldName != '') {
                    DescribeFieldResult fieldDescribe = fields.get(sFieldName).getDescribe();
                    System.debug(sFieldName + ' isAccessible: '+fieldDescribe.isAccessible());
                    if(!fieldDescribe.isAccessible()) {
                        return fieldDescribe.isAccessible();
                    }
                }
            }
        }
        return objectDescription.isQueryable();
    }
    
    /********************************************************************************************
    METHOD NAME    : checkSecurityAccessDML
    DESCRIPTION    : This method is used to check access for object and fields before DML operations.
    RETURN TYPE    : Boolean
    PARAMETER      : list<SObject>
    ********************************************************************************************/
    public static Boolean checkSecurityAccessForDelete(List<SObject> lstForDelete) {
         Boolean bAccessCheck  = true ;
         for (SObject oDel : lstForDelete ) {
             if (!oDel.getSObjectType().getDescribe().isDeletable()) {
                 bAccessCheck  = false ; 
                 break;
             } 
         } 
         return bAccessCheck ; 
           
    }
    
    /********************************************************************************************
    METHOD NAME    : checkSecurityAccessDML
    DESCRIPTION    : This method is used to check access for object and fields before DML operations.
    RETURN TYPE    : Boolean
    PARAMETER      : list<SObject>
    ********************************************************************************************/
    public static Boolean checkSecurityAccessDML(List<SObject> lstForDML) {
        if(System.label.ProfileFieldAccessCheck == 'Yes' || bIsTestClass) {
            System.debug('lstForDML:'+lstForDML);
            list<String> lstFieldNames = new list<String>();
            Map<String, Object> fieldsToValue = lstForDML[0].getPopulatedFieldsAsMap();
            if(!fieldsToValue.isEmpty())
                lstFieldNames.addAll(fieldsToValue.keySet());
            //getSObjectType is done for the 0 index element of the array as the
            //list for DML operation might be created in Lightning Component
            //which would be treated as a list of Object and the Type would be null
            Schema.SObjectType convertType = lstForDML.get(0).getSObjectType();
            if(convertType != null) {
                Schema.DescribeSObjectResult objectDescription = convertType.getDescribe();
                if(objectDescription != null && !objectDescription.getName().contains('Share') && !lstObjExcl.contains(objectDescription.getName())){
                    System.debug(convertType + ' isQueryable:'+objectDescription.isQueryable());
                    if(objectDescription.isQueryable()) {
                        Map<String, SObjectField> fields = convertType.getDescribe().fields.getMap();
                        if(fields != null) {
                            System.debug('fields:'+fields);
                            for(String sFieldName : lstFieldNames) {
                                sFieldName = sFieldName.trim();
                                System.debug('sFieldName:'+sFieldName);
                                sFieldName = sFieldName.contains('__r') ? sFieldName.substringBefore('.').removeEnd('r') + 'c'  : sFieldName;
                                if(sFieldName != null && sFieldName != '') {
                                    System.debug('fields.get(sFieldName)'+fields.get(sFieldName));
                                    if(fields.containsKey(sFieldName)){
                                        DescribeFieldResult fieldDescribe = fields.get(sFieldName).getDescribe();
                                        System.debug(sFieldName + ' isAccessible: '+fieldDescribe.isAccessible());
                                        if(!fieldDescribe.isAccessible()) {
                                            return fieldDescribe.isAccessible();
                                        }
                                    }
                                }
                            }
                        }
                    }
                    return objectDescription.isQueryable();
                }
            }
        }
        return true;
    }
    
    /********************************************************************************************
    METHOD NAME    : checkSecurityAccessForDMLOps
    DESCRIPTION    : This method is used to check read/write access of object/fields for the passed
                     object list and DML type.
    RETURN TYPE    : Boolean
    PARAMETER      : List<sObject>, String
    ********************************************************************************************/ 
    public static Boolean checkSecurityAccessForDMLOps(List<SObject> lstForUpdate, String sDMLType) {
        Boolean bDMLAllowed;
        Map<String, Object> fieldsToValue = lstForUpdate[0].getPopulatedFieldsAsMap();
        DescribeFieldResult fieldDescribe;
        Map<String, SObjectField> fields = new Map<String, SObjectField>();
        list<String> lstFieldNames = new list<String>();
        
        if(!fieldsToValue.isEmpty()) 
            lstFieldNames.addAll(fieldsToValue.keySet());
        Schema.SObjectType convertType = lstForUpdate.get(0).getSObjectType();
        Schema.DescribeSObjectResult objectDescription = convertType.getDescribe();
        switch on sDMLType {
            when 'update'
            {
                if(!objectDescription.isUpdateable()){ // If logged in user doesn't have update access on Object
                    throw new NoAccessException();
                }
                else{
                    fields= convertType.getDescribe().fields.getMap();
                    for(String sFieldName : lstFieldNames){
                        if(sFieldName!='Id' && sFieldName!='Name'){
                        fieldDescribe = fields.get(sFieldName).getDescribe();
                        if(fieldDescribe.isUpdateable()){
                            bDMLAllowed=true;
                        }
                        else // If logged in user doesn't have update access on field
                        {
                            bDMLAllowed=false;
                            throw new NoAccessException();
                            //break;
                        }
                    }
                    }
                }
                
            }
            when 'insert'{
                if(!objectDescription.isCreateable()){ // If logged in user doesn't have insert access on object
                    throw new NoAccessException();
                }
                else{
                    fields= convertType.getDescribe().fields.getMap();
                    System.debug('1=='+fields);
                    for(String sFieldName : lstFieldNames){
                        System.debug('2=='+sFieldName);
                        fieldDescribe = fields.get(sFieldName).getDescribe();
                        System.debug('3=='+fieldDescribe);
                        if(fieldDescribe.isUpdateable()){
                            bDMLAllowed=true;
                            System.debug('4=='+bDMLAllowed);
                        }
                        else // If logged in user doesn't have insert access on field
                        {
                            bDMLAllowed=false;
                            System.debug('5=='+bDMLAllowed);
                            throw new NoAccessException();
                            //break;
                        }
                    }
                }
                
            }
        }

        return bDMLAllowed;
    }
	  /********************************************************************************************
		METHOD NAME    : checkDMLAccess
		DESCRIPTION    : This method is used to check update access for object and fields.
		RETURN TYPE    : Boolean
		PARAMETER      : List
		********************************************************************************************/ 
    public static Boolean checkDMLAccess(List<SObject> lstForUpdate, String sAction) {
        Map<String, Object> fieldsToValue = new Map<String, Object>();
        if(!lstForUpdate.isEmpty()){
            fieldsToValue = lstForUpdate[0].getPopulatedFieldsAsMap();
            
            Map<String, SObjectField> fields = new Map<String, SObjectField>();
            List<String> lstFieldNames = new List<String>();
            if(!fieldsToValue.isEmpty())
                lstFieldNames.addAll(fieldsToValue.keySet());
            Schema.SObjectType objType = lstForUpdate.get(0).getSObjectType();            
            Schema.DescribeSObjectResult objectDescription = objType.getDescribe();
            String objName = objectDescription.getName();
            if(!objName.contains('Share') && !lstObjExcl.contains(objName))	{
                if(!objectDescription.isAccessible()){
                    throwException('', objName, '');
                }
                else	{
                    fields = objType.getDescribe().fields.getMap();
                    switch on sAction {
                        when 'update'
                        {
                            if(!(UserInfo.getUserType() == 'Guest' && (objName == 'Contact' || objName == 'Account')))	{
                                if(!objectDescription.isUpdateable()){
                                    throwException('UPDATE', objName, '');
                                }
                                else{
                                    checkFieldAccess(fields, 'update', objName, lstFieldNames);
                                }
                            }
                            
                        }
                        when 'insert' {
                            if(!objectDescription.isCreateable()){
                                throwException('INSERT', objName, '');
                            }
                            else{
                                checkFieldAccess(fields, 'insert', objName, lstFieldNames);
                            }
                        }
                        when 'upsert'	{
                            if(!objectDescription.isCreateable()){
                                 throwException('INSERT', objName, '');
                            }
                            if(!objectDescription.isUpdateable()){
                                throwException('UPDATE', objName, '');
                            }
                            checkFieldAccess(fields, 'upsert', objName, lstFieldNames);
                        }
                        when 'delete'	{
                            if(!objectDescription.isDeletable()){
                                throwException('DELETE', objName, '');
                            }
                        }
                    }
                }
            }
        }
        return true;
    }
    /*************************************************************************************
     * Method Name:queryRecords
     * Description:To fetch the records
     * Parameters: String Query to Run
     * Return Type: List of Queried Results.
     * *********************************************************************************/
     public static List<SObject> queryRecords(String sQueryToRun) {        
       
        list<SObject> lstResult = new list<SObject>();
        
        //try{
        lstResult = Database.query(sQueryToRun);
        //}catch(Exception ex){}
       
        return lstResult;
    }
    /*************************************************************************************
     * Method Name:queryRecordsInClause
     * Description:To fetch the records
     * Parameters: String Query to Run
     * Return Type: List of Queried Results.
     * *********************************************************************************/
     public static List<SObject> queryRecordsInClause(String sQueryToRun, Set<String> inclauseList) {        
       	sQueryToRun = sQueryToRun.replace('XXX', 'inclauseList');
        list<SObject> lstResult = new list<SObject>();
        system.debug('sQueryToRunfiles'+sQueryToRun); 
        lstResult = Database.query(sQueryToRun);
        
        return lstResult;
    }
    
    /*************************************************************************************
     * Method Name:getRecordCount
     * Description:To fetch the number of records returned from the query
     * Parameters: String Query to Run
     * Return Type: Count of the Records returned from the query.
     * *********************************************************************************/    
    public static Integer getRecordCount(String sQuery) {
        Integer iCnt = 0;
        if(String.isNotBlank(sQuery))   {
            iCnt = Database.countQuery(sQuery);
        }
        return iCnt;
    }
    /********************************************************************************************
    METHOD NAME    : getSubQuery
    DESCRIPTION    : This method is used to form the query with all the fields of the input object.
    RETURN TYPE    : String
    PARAMETER      : String
    ********************************************************************************************/
    public static String getSubQuery(String sObjectAPI) {
        SObjectType oObjectType = Schema.getGlobalDescribe().get(sObjectAPI);
        Map<String,Schema.SObjectField> oFieldsTopic = oObjectType.getDescribe().fields.getMap();
        List<String> lstFields = new List<String>(oFieldsTopic.keySet());
        String sQuery = String.join(lstFields, ',');
        return sQuery;
    }
	
	 public static void checkFieldAccess(Map<String, SObjectField> fields, String sAction, String objName, List<String> lstFieldNames)	{
        DescribeFieldResult fieldDescribe;
        for(String sFieldName : lstFieldNames){
            if(fields.containsKey(sFieldName)){
                fieldDescribe = fields.get(sFieldName).getDescribe();
                if(fieldDescribe.isPermissionable() && !fieldDescribe.isCalculated() && !fieldDescribe.isAutoNumber())   {
                    if(!fieldDescribe.isAccessible()){
                        throwException('', objName, sFieldName);
                    }
                    else    {
                        if(sAction == 'insert' || sAction == 'upsert')	{
                            if(!fieldDescribe.isCreateable()){
                                throwException('INSERT', objName, sFieldName);
                            }
                        }
                        if(sAction == 'update' || sAction == 'upsert')	{
                            if(!fieldDescribe.isUpdateable()){    
                                throwException('UPDATE', objName, sFieldName);
                            }
                        }
                    }
                }
            }   
        }
    }
	
	public static void throwException(String sAction, String sObjName, String sFldName)	{
        String sError = 'User does not have ' + (String.isNotBlank(sAction) ? sAction + ' ' :  '');
        sError += 'access to the ';
        if(String.isNotBlank(sFldName))	{
            sError += 'Field: ' + sFldName + ' in the Object: ' + sObjName;
        }
        else	{
            sError += 'Object: ' + sObjName;
        }
        AuraHandledException e = new AuraHandledException(sError);
        e.setMessage(sError);
        throw e;
    }    
   
}