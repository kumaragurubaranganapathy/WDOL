/*@AUTHOR: H ADARSH
@Date: 12-August-2018 

Description: Utlity Class to perform DML Operations on records. 

MODIFICATION LOG:
DEVELOPER                          DATE                     DESCRIPTION
================================================================================
H ADARSH                        12-August-2018             Initial Creation
================================================================================= */
public without sharing class Utilityclass_withoutsharing {
    /*********************************************************************
     * Method Name:insertList
     * Description:This method is used to Insert Records 
     * Return Type:List<SObject>
     * Parameter: List of Records.
     * ******************************************************************/
    public static List<SObject> insertList(List<SObject> lstForInsert){
		List<SObject> insertlsit1=new List<SObject>();
            insertlsit1=Utilityclass_withsharing.insertList(lstForInsert);
        
        return insertlsit1;
    }    
     /*********************************************************************
     * Method Name:updateList
     * Description:This method is used to Update Records 
     * Return Type:List<SObject>
     * Parameter: List of Records.
     * ******************************************************************/
    public static List<SObject> updateList(List<SObject> lstForUpdate) {    
		List<SObject> lstForUpdate1=new List<SObject>();
            lstForUpdate1=Utilityclass_withsharing.updateList(lstForUpdate);
        return lstForUpdate1;
    }
    /*********************************************************************
     * Method Name:deleteList
     * Description:This method is used to Delete Records 
     * Return Type:List<SObject>
     * Parameter: List of Records.
     * ******************************************************************/    
    public static List<SObject> deleteList(List<SObject> lstForDelete) {
        List<SObject> lstForDelete1=new List<SObject>();
            lstForDelete1=Utilityclass_withsharing.deleteList(lstForDelete);
        return lstForDelete1;
    }
    /*********************************************************************
     * Method Name:upsertList
     * Description:This method is used to Upsert Records 
     * Return Type:List<SObject>
     * Parameter: List of Records.
     * ******************************************************************/ 
    public static List<SObject> upsertList(List<SObject> lstForUpsert) {
       List<SObject> upsertList1=new List<SObject>();
            upsertList1=Utilityclass_withsharing.deleteList(lstForUpsert);
        return upsertList1;
    }
    
    /*************************************************************************************
     * Method Name:queryRecords
     * Description:To fetch the records
     * Parameters: String Query to Run
     * Return Type: List of Queried Results.
     * *********************************************************************************/
     public static List<SObject> queryRecords(String sQueryToRun) {      
        list<SObject> lstResult = new list<SObject>();
        lstResult = Database.query(sQueryToRun);
        //System.debug('lstResult:'+lstResult);
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
}