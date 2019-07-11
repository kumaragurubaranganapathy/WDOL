/**
* User Story: N/A
* Class Name: ErrorLogger
* Test Class Name: Polaris_CreateErrorLog_Test
* Description: Utility Class to log errors in the Error Object
* Date:        Developer/Company                    Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 08/21/2018   Mangesh Abhang/Deloitte           Initial Creation
**/
public class Polaris_CreateErrorLog_Exception extends Exception {
    
    //Method to add error in system
    public static void addError(Exception e,String cname,String cmethod) {
        List<Polaris_Custom_Exception__c> LstError = new List<Polaris_Custom_Exception__c>();
        try
        {
            system.debug('inside inside');
            LstError = createErrorLogs(e, cname, cmethod);
            system.debug('error'+LstError);
            if(LstError != NULL && !LstError.isEmpty())
            {
                insert LstError;
            }
        }
        catch(Exception ex)
        {
            System.debug(ex);
        }

    }
    public static List<Polaris_Custom_Exception__c> createErrorLogs(Exception e,String cname,String cmethod) {
        List<Polaris_Custom_Exception__c> lstError = new List<Polaris_Custom_Exception__c>();
            String QueryLimit = '1. SOQL Queries used / SOQL Queries allowed: ' + Limits.getQueries() + '/' + Limits.getLimitQueries();
            String DMLimit = '2. Number of records queried so far /  Number allowed: ' + Limits.getDmlRows() + '/' + Limits.getLimitDmlRows();
            String DMLStat = '3. Number of DML statements used so far / Number allowed: ' +  Limits.getDmlStatements() + '/' + Limits.getLimitDmlStatements();   
            String CPUT = '4. Amount of CPU time (in ms) used so far / CPU usage time (in ms) allowed: ' + Limits.getCpuTime() + '/' + Limits.getLimitCpuTime();
            String lan=UserInfo.getLanguage();
            String uid=UserInfo.getUserId();
            String sessid=UserInfo.getSessionId().substring(15);
            LoginHistory lh=[SELECT Browser,LoginTime,SourceIp,UserId,Platform FROM LoginHistory WHERE UserId =:uid ORDER BY LoginTime DESC NULLS LAST LIMIT 1];
            //Create exception record
            Polaris_Custom_Exception__c exc = new Polaris_Custom_Exception__c();
           //exc.Gov_Limits__c= String.format('{0}\n{1}\n{2}\n{3}',new List<QueryLimit, DMLimit,DMLStat,CPUT>);            
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
            exc.QueryLimit__c = QueryLimit;
            exc.CPUT_Limit__c = CPUT;
            exc.DMLStat__c = DMLStat;
            exc.DMLimit__c = DMLimit;
        lstError.add(exc);
        return lstError;
    }

}