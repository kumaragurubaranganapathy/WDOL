/**
* User Story: N/A
* Class Name: DOL_CreateErrorLog_Exception
* Test Class Name: ****
* Description: Utility Class to log errors in the Error Object
* Date:        Developer/Company                    Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 07/08/2019   Laltu Banerjee/Deloitte           Initial Creation
**/
public class DOL_CreateErrorLog_Exception extends Exception {
    
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
            String QueryLimit = DOL_AppConstants.NULL_EMPTY_STRING + '1. SOQL Queries used / SOQL Queries allowed: ' + Limits.getQueries() + '/' + Limits.getLimitQueries();
            String DMLimit = DOL_AppConstants.NULL_EMPTY_STRING + '2. Number of records queried so far /  Number allowed: ' + Limits.getDmlRows() + '/' + Limits.getLimitDmlRows();
            String DMLStat = DOL_AppConstants.NULL_EMPTY_STRING + '3. Number of DML statements used so far / Number allowed: ' +  Limits.getDmlStatements() + '/' + Limits.getLimitDmlStatements();   
            String CPUT = DOL_AppConstants.NULL_EMPTY_STRING + '4. Amount of CPU time (in ms) used so far / CPU usage time (in ms) allowed: ' + Limits.getCpuTime() + '/' + Limits.getLimitCpuTime();
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

    public static Id logApplicationError(Exception error,String className,String methodName){
        try{
            if(error != null ){
            Polaris_Custom_Exception__c log = new Polaris_Custom_Exception__c();
            log.Error_Message__c = error.getMessage();
            log.Exception_Type__c = error.getTypeName();
            log.LineNumber__c = error.getLineNumber();
            log.Stack_Trace__c = error.getStackTraceString();
            log.Class_Name__c = className;
            log.Class_Method__c = methodName;
            log.Log_Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'ERROR';
            log.Source__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Salesforce';
            logToDB(log);
            return log.Id;
            }
        }catch(Exception e){
            System.debug(e);
        }
        return null;        
    }
    
        public static Id logDatabaseError(Database.Error error,String className,String methodName){
        try{
            if(error != null ){
            Polaris_Custom_Exception__c log = new Polaris_Custom_Exception__c();
            log.Error_Message__c = error.getMessage();
            log.Class_Name__c = className;
            log.Class_Method__c = methodName;
            log.Log_Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'ERROR';
            log.Source__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Salesforce';
            logToDB(log);
            return log.Id;
            }
        }catch(Exception e){
            System.debug(e);
        }
        return null;        
    }

    /**
    ** Name             : logApplicationError
    ** Input            : error Exception
    ** Functionality    : Save input to Polaris_Custom_Exception__c
    ** Return           : Id, created Record ID 
    ** Author           : Laltu Banerjee
    ** Date             : 07/24/2019
    */
    public static Id logApplicationError(Exception error){
        Polaris_Custom_Exception__c log = new Polaris_Custom_Exception__c();
        try{
            if(error != null ){
                log.Error_Message__c = error.getMessage();
                log.Exception_Type__c = error.getTypeName();
                log.LineNumber__c = error.getLineNumber();
                log.Stack_Trace__c = error.getStackTraceString();
                log.Class_Name__c = getClassName(error.getStackTraceString());
                log.Class_Method__c = getMethodName(error.getStackTraceString());
                log.Log_Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'ERROR';
                log.Source__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Salesforce';
                logToDB(log);
                return log.Id;
            }
        }catch(Exception e){
            Polaris_Custom_Exception__c log2 = new Polaris_Custom_Exception__c();
            log2.Error_Message__c += ' error occured while saving error '+ e.getMessage();
            log2.Stack_Trace__c += ' error occured while saving error '+ e.getStackTraceString();
            insert log2;
        }
        return null; 
    }

    private static String getClassName(String stackTraceString){
        try{    
            stackTraceString = stackTraceString.substringBefore('\n');
            if (stackTraceString.startsWith('Class.'))
                stackTraceString = stackTraceString.substringAfter('Class.');
            return stackTraceString.substringBefore(':').substringBeforeLast('.');
        }catch(Exception e){
            return '';
        }
    }

    private static String getMethodName(String stackTraceString){
        try{
            stackTraceString = stackTraceString.substringBefore('\n');
            return stackTraceString.substringBefore(':').substringAfterLast('.');
        }catch(Exception e){
            return '';
        }
    }

    private static void logToDB(Polaris_Custom_Exception__c log){
        String uid=UserInfo.getUserId();
        //LoginHistory lh=[SELECT Browser,LoginTime,SourceIp,UserId,Platform FROM LoginHistory WHERE UserId =:uid ORDER BY LoginTime DESC NULLS LAST LIMIT 1];
        /*if( lh != null){
            log.Browser__c=lh.Browser;
            log.Source_IP_Address__c=lh.SourceIp;
            log.Platform__c=lh.Platform;
        }*/
        
        log.QueryLimit__c = DOL_AppConstants.NULL_EMPTY_STRING + 'SOQL Queries used / SOQL Queries allowed: ' + Limits.getQueries() + '/' + Limits.getLimitQueries();
        log.DMLimit__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Number of records queried so far /  Number allowed: ' + Limits.getDmlRows() + '/' + Limits.getLimitDmlRows();
        log.DMLStat__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Number of DML statements used so far / Number allowed: ' +  Limits.getDmlStatements() + '/' + Limits.getLimitDmlStatements();   
        log.CPUT_Limit__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Amount of CPU time (in ms) used so far / CPU usage time (in ms) allowed: ' + Limits.getCpuTime() + '/' + Limits.getLimitCpuTime();
        
        log.Session_Id__c=UserInfo.getSessionId().substring(15);
        log.Language__c=UserInfo.getLanguage();
        
        insert log;
    }
    
    //Add delete record details
    public static void logDeleteDetails(String message, String cname,String cmethod ){
           Polaris_Custom_Exception__c exc = new Polaris_Custom_Exception__c();
           //exc.Gov_Limits__c= String.format('{0}\n{1}\n{2}\n{3}',new List<QueryLimit, DMLimit,DMLStat,CPUT>);            
            exc.Error_Message__c = message;
            exc.Class_Name__c=cname;
            exc.Class_Method__c=cmethod;
            insert exc;
    }
    
    // Add details related to DatabseSave
    public static void logDataBaseSaveDetails(Database.SaveResult[] srList , String cname, String cmethod ){ 
       List<Polaris_Custom_Exception__c> logtoDb = new List<Polaris_Custom_Exception__c>();
        for (Database.SaveResult sr : srList) {
            if (!sr.isSuccess()) {
                for(Database.Error err : sr.getErrors()) {                            
                    Polaris_Custom_Exception__c log = new Polaris_Custom_Exception__c();
                    log.Error_Message__c = err.getMessage();
                    log.Class_Name__c = cname;
                    log.Class_Method__c = cmethod;
                    log.Log_Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'ERROR';
                    log.Source__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Salesforce';
                    logtoDb.add(log);
                }
            } else  {  
                Polaris_Custom_Exception__c exc = new Polaris_Custom_Exception__c();        
                exc.Error_Message__c ='Successfully updated License ID: ' + sr.getId();
                exc.Class_Name__c=cname;
                exc.Class_Method__c=cmethod;
                logtoDb.add(exc);
            }
        }
        try {
            if(!logtoDb.isEmpty()) {
                insert logtoDb;
            }
        } catch(Exception ex) {
            system.debug('Error'+ex);
        }

        
    }
}