/*@AUTHOR: H ADARSH
@Date: 05-August-2018 

Description: Class to Create the exceptions occured in the org. 

MODIFICATION LOG:
DEVELOPER                          DATE                     DESCRIPTION
================================================================================
H ADARSH                        05-August-2018             Initial Creation
================================================================================= */


public class HandleException extends Exception {
    public static void LogException(Exception e,String cname,String cmethod){
        try{
            String QueryLimit = '1. SOQL Queries used / SOQL Queries allowed: ' + Limits.getQueries() + '/' + Limits.getLimitQueries();
            String DMLimit = '2. Number of records queried so far /  Number allowed: ' + Limits.getDmlRows() + '/' + Limits.getLimitDmlRows();
            String DMLStat = '3. Number of DML statements used so far / Number allowed: ' +  Limits.getDmlStatements() + '/' + Limits.getLimitDmlStatements();   
            String CPUT = '4. Amount of CPU time (in ms) used so far / CPU usage time (in ms) allowed: ' + Limits.getCpuTime() + '/' + Limits.getLimitCpuTime();
            String lan=UserInfo.getLanguage();
            String uid=UserInfo.getUserId();
            String sessid=UserInfo.getSessionId().substring(15);
            LoginHistory lh=[SELECT Browser,LoginTime,SourceIp,UserId,Platform FROM LoginHistory WHERE UserId =:uid ORDER BY LoginTime DESC NULLS LAST LIMIT 1];
            //Create exception record
            LnP_Custom_Exception__c exc = new LnP_Custom_Exception__c();
          // exc.Gov_Limits__c= String.format('{0}\n{1}\n{2}\n{3}',new List<QueryLimit, DMLimit,DMLStat,CPUT>);            
            exc.Error_Message__c = e.getMessage();
            exc.Exception_Type__c = e.getTypeName();
            exc.LineNumber__c= e.getLineNumber();
            exc.Stack_Trace__c = e.getStackTraceString();
            exc.Class_Name__c=cname;
            exc.Class_Method__c=cmethod;
            exc.Language__c=lan;
            exc.Session_Id__c=sessid;   
            exc.Browser__c=lh.Browser;
            exc.Source_IP_Address__c=lh.SourceIp;
            exc.Platform__c=lh.Platform;
            database.insert(exc);
        } catch (Exception exc) {
        }            
    } //end method 
} //end class