/**
* User Story: N/A
* Class Name: ErrorLogger
* Test Class Name: ErrorLogger_Test
* Description: Utility Class to log errors in the Error Object
* Date:        Developer/Company                    Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 08/21/2018   Sharad Maheshwari/Deloitte           Initial Creation
**/
global with sharing class ErrorLogger{
    
    /**
* Method name  : logGeneralException
* Description  : This method will log all the general exceptions encountered in the TLS Apex classes
* Return Type  : None
* Parameter    : Exception, Name of the sObject, DML Type, Component of the error, Class or Trigger Name, severity
**/
    public static void logGeneralException(Exception e, Id userId, String sObjectName, String eventType, String componentName, String className, String severityLevel) {
        
        // Variables
        Error_Log__c log                =   new Error_Log__c();
        log.Class__c                    =  className;
        log.Error_Description__c        =  e.getStackTraceString();  // e.getStackTraceString(); 
        log.Error_Detail__c             =  e.getMessage();  // e.getMessage();
        log.Error_Severity__c           =  severityLevel;
        log.Sobject__c                  =  sObjectName;
        log.User__c                     =  userId;
        log.Component__c                =  componentName;
        log.Event__c                    =  eventType;
        // Insert Log
        insert log;
    }
    
    
    /**
* Method name  : logDMLException
* Description  : This method will log all the DML exceptions encountered in the TLS Apex classes
* Return Type  : None
* Parameter    : Exception, User's Id, Delete Result , Save Result, Upsert Result, Name of the sObject, DML Type, Component of the error, Class or Trigger Name, severity
**/
    public static void logDMLDatabaseResultErrors(String userId, Database.deleteResult[] deleteResult, Database.saveResult[] saveresult, Database.upsertResult[] upsertResult, String sObjectName, String eventType, String componentName, String errClassName, String severityLevel, String moduleName) {
        
        // Variables
        List <Error_Log__c> listLog     =   new List <Error_Log__c>();
        Error_Log__c log                =   new Error_Log__c();
        //SObject Sobj= new SObject();
        system.debug('Inside Log DML exception');
        
        // check if the delete result is not NULL
        if(deleteResult != null){
            for(Integer i=0; i < deleteResult.size(); i++){
                if(!deleteResult[i].isSuccess()){
                    List <Database.error> listError = deleteResult[i].getErrors();
                    for(Database.error err : listError){
                        Error_Log__c errorLog       = new Error_Log__c();
                        errorLog.User__c = userId;
                        errorLog.Sobject__c             = sObjectName;    
                        errorLog.Class__c               = errClassName;
                        errorLog.Error_Description__c   = err.getMessage();
                        errorLog.Error_Severity__c      = severityLevel; 
                        errorLog.Error_Detail__c        = String.valueOf(err.getStatusCode());
                        errorLog.Event__c               = eventType;
                        errorLog.Component__c           = moduleName;         
                        errorLog.Error_Record_Id__c     = deleteResult[i].getId();  
                        
                        // add error log to the list
                        ListLog.add(errorLog);
                        
                    }
                }
            }
        }
        
        // Save Result
        if(saveResult !=  null){
            for(Integer i=0; i < saveResult.size(); i++){
                if(!saveResult[i].isSuccess()){
                    system.debug('Inside  saveResult Log DML exception');
                    List <Database.error> listError = saveResult[i].getErrors();
                    for(Database.error err : listError){
                        system.debug('Inside errorList saveResult Log DML exception');
                        Error_Log__c errorLog           = new Error_Log__c();
                        errorLog.User__c                = userId;
                        errorLog.Sobject__c             = sObjectName;    
                        errorLog.Class__c               = errClassName;
                        errorLog.Error_Description__c   = err.getMessage();
                        errorLog.Error_Severity__c      = severityLevel; 
                        errorLog.Error_Detail__c        = String.valueOf(err.getStatusCode());
                        errorLog.Event__c               = eventType;
                        errorLog.Component__c           = moduleName;
                        errorLog.Error_Record_Id__c     = saveResult[i].getId();
                        
                        system.debug('Log class, details etc'+errorLog.Class__c+errorLog.Error_Detail__c);
                        listLog.add(errorLog);
                    }
                }
            }
        }
        
        // Upsert Result
        if(upsertResult !=  null){
            for(Integer i=0; i < upsertResult.size(); i++){
                if(!upsertResult[i].isSuccess()){
                    List <Database.error> listError = upsertResult[i].getErrors();
                    for(Database.error err : listError){                        
                        Error_Log__c errorLog       = new Error_Log__c();
                        errorLog.User__c                = userId;
                        errorLog.Sobject__c             = sObjectName;    
                        errorLog.Class__c               = errClassName;
                        errorLog.Error_Description__c   = err.getMessage();
                        errorLog.Error_Severity__c      = severityLevel; 
                        errorLog.Error_Detail__c        = String.valueOf(err.getStatusCode());
                        errorLog.Event__c               = eventType;
                        errorLog.Component__c           = moduleName;
                        errorLog.Error_Record_Id__c     = upsertResult[i].getId();
                        listLog.add(errorLog);
                    }
                }
            }
        }
        
        // Insert Log
        if(listLog != null && !listLog.isEmpty())
            database.insert(listLog, false);
    }
    
    /**
* Method name  : logDMLException
* Description  : This method will log all the DML exceptions encountered in the TLS Apex classes
* Return Type  : None
* Parameter    : Exception, User's Id, Delete Result , Save Result, Upsert Result, Name of the sObject, DML Type, Component of the error, Class or Trigger Name, severity
**/
    public static boolean logDMLDatabaseResultErrorsWithResponse(String userId, Database.deleteResult[] deleteResult, Database.saveResult[] saveresult, Database.upsertResult[] upsertResult, String sObjectName, String eventType, String componentName, String errClassName, String severityLevel, String moduleName) {
        
        // Variables
        List <Error_Log__c> listLog     =   new List <Error_Log__c>();
        boolean success =true;
        Error_Log__c log                =   new Error_Log__c();
        //SObject Sobj= new SObject();
        system.debug('Inside Log DML exception');
        
        // check if the delete result is not NULL
        if(deleteResult != null){
            for(Integer i=0; i < deleteResult.size(); i++){
                if(!deleteResult[i].isSuccess()){
                    success=false;
                    List <Database.error> listError = deleteResult[i].getErrors();
                    for(Database.error err : listError){
                        Error_Log__c errorLog           = new Error_Log__c();
                        errorLog.User__c                = userId;
                        errorLog.Sobject__c             = sObjectName;    
                        errorLog.Class__c               = errClassName;
                        errorLog.Error_Description__c   = err.getMessage();
                        errorLog.Error_Severity__c      = severityLevel; 
                        errorLog.Error_Detail__c        = String.valueOf(err.getStatusCode());
                        errorLog.Event__c               = eventType;
                        errorLog.Component__c           = moduleName;         
                        errorLog.Error_Record_Id__c = deleteResult[i].getId();  
                        
                        // add error log to the list
                        ListLog.add(errorLog);
                        
                    }
                }
            }
        }
        
        // Save Result
        if(saveResult !=  null){
            for(Integer i=0; i < saveResult.size(); i++){
                if(!saveResult[i].isSuccess()){
                    success=false;
                    system.debug('Inside  saveResult Log DML exception');
                    List <Database.error> listError = saveResult[i].getErrors();
                    for(Database.error err : listError){
                        system.debug('Inside errorList saveResult Log DML exception');
                        Error_Log__c errorLog       = new Error_Log__c();
                        errorLog.User__c = userId;
                        errorLog.Sobject__c             = sObjectName;    
                        errorLog.Class__c               = errClassName;
                        errorLog.Error_Description__c   = err.getMessage();
                        errorLog.Error_Severity__c      = severityLevel; 
                        errorLog.Error_Detail__c        = String.valueOf(err.getStatusCode());
                        errorLog.Event__c               = eventType;
                        errorLog.Component__c           = moduleName;
                        errorLog.Error_Record_Id__c     = saveResult[i].getId();
                        
                        system.debug('Log class, details etc'+errorLog.Class__c+errorLog.Error_Detail__c);
                        listLog.add(errorLog);
                    }
                }
            }
        }
        
        // Upsert Result
        if(upsertResult !=  null){
            for(Integer i=0; i < upsertResult.size(); i++){
                if(!upsertResult[i].isSuccess()){
                    success=false;
                    List <Database.error> listError = upsertResult[i].getErrors();
                    for(Database.error err : listError){                        
                        Error_Log__c errorLog          = new Error_Log__c();
                        errorLog.User__c               = userId;
                        errorLog.Sobject__c            = sObjectName;    
                        errorLog.Class__c              = errClassName;
                        errorLog.Error_Description__c  = err.getMessage();
                        errorLog.Error_Severity__c     = severityLevel; 
                        errorLog.Error_Detail__c      = String.valueOf(err.getStatusCode());
                        errorLog.Event__c              = eventType;
                        errorLog.Component__c          = moduleName;
                        errorLog.Error_Record_Id__c    = upsertResult[i].getId();
                        listLog.add(errorLog);
                    }
                }
            }
        }
        
        // Insert Log
        if(listLog.size()>0){
            try{    
                database.insert(listLog, false);
            }
            catch(exception ex){
                apexpages.addmessages(ex); 
            }
        }
        
        return success;
    }
    
    /**
* Method name  : logNCCPADMLDatabaseResultErrors
* Description  : This method will log all the DML exceptions encountered in the TLS Apex classes
* Return Type  : None
* Parameter    : Exception, User's Id, Delete Result , Save Result, Upsert Result, Name of the sObject, DML Type, Component of the error, Class or Trigger Name, severity,RecordTypeIde
**/
    global static void logNCCPADMLDatabaseResultErrors(String userId, Database.deleteResult deleteResult, Database.saveResult saveresult, Database.upsertResult upsertResult, String sObjectName, String eventType, String componentName, String errClassName, String severityLevel, String moduleName, String RecordTypeIde) {
        /*
        if(saveResult !=  null){
            if(!saveResult.isSuccess()){
                system.debug('Inside  saveResult Log DML exception');
                List <Database.error> listError = saveResult.getErrors();
                for(Database.error err : listError){
                    system.debug('Inside errorList saveResult Log DML exception');
                    Error_Log__c errorLog           = new Error_Log__c();
                    errorLog.User__c                = userId;
                    errorLog.Sobject__c             = sObjectName;    
                    errorLog.Class__c               = errClassName;
                    errorLog.Error_Description__c   = err.getMessage();
                    errorLog.Error_Severity__c      = severityLevel;
                    errorLog.Error_Detail__c        = String.valueOf(err.getStatusCode());
                    errorLog.Event__c               = eventType;
                    errorLog.Component__c           = moduleName;
                    errorLog.Error_Record_Id__c     = saveResult.getId();
                    system.debug('Log class, details etc'+errorLog.Class__c+errorLog.Error_Detail__c);
                    listLog.add(errorLog);
                }
            }
        }
        if(listLog != null && !listLog.isEmpty())
            database.insert(listLog, false);
        system.debug('listLog'+listLog);
        */
    }
    
    
    /**
* Method name  : logExceptions
* Description  : This method will log all the exceptions encountered in the Apex classes
* Return Type  : None
* Parameter    : Exception, User's Id, Name of the sObject, Component of the error, Class or Trigger Name, severity
**/
    public static String logExceptions(String userId,DMLException ex, Sobject Sobj, String sObjectName, String eventType, String componentName, String errClassName, String severityLevel, String moduleName) {
        String errorString = null;
        Error_Log__c errorLog  = new Error_Log__c();
        errorLog.User__c = userId;
        errorLog.Sobject__c = sObjectName;    
        errorLog.Class__c = errClassName;
        errorLog.Error_Description__c  = ex.getMessage();
        errorLog.Error_Severity__c  = severityLevel; 
        errorLog.Error_Detail__c  = ex.getStackTraceString();
        errorLog.Event__c   = eventType;
        errorLog.Component__c  = moduleName;
        errorLog.Error_Record_Id__c = Sobj.id;
        
        // Insert Log
        Database.saveResult saveResultsErr  = database.insert(errorLog);
        errorString = [Select Name from Error_Log__c where ID =:errorLog.id limit 1].Name;
        return errorString;
    }
    
    
/**
* Method name  : logBRExceptions
* Description  : This method will log all the exceptions encountered from Business Rules Engine Classes
* Return Type  : None
* Parameter    : Exception, User's Id, Name of the sObject, Component of the error, Class or Trigger Name, severity
**/
    public static void logBRSaveResultErrors(String userId, Database.upsertResult[] upsertResult, String sObjectName, String componentName, String errClassName, String component) {
      /*  List <Error_Log__c> listLog     =   new List <Error_Log__c>();
        Error_Log__c log                =   new Error_Log__c();
        if(upsertResult !=  null){
            for(Integer i=0; i < upsertResult.size(); i++){
                if(!upsertResult[i].isSuccess()){
                    List <Database.error> listError = upsertResult[i].getErrors();
                    for(Database.error err : listError){                        
                        Error_Log__c errorLog           = new Error_Log__c();
                        errorLog.User__c                = userId;
                        errorLog.Sobject__c             = sObjectName;    
                        errorLog.Class__c               = errClassName;
                        errorLog.Error_Description__c   = err.getMessage();
                        errorLog.Error_Detail__c        = String.valueOf(err.getStatusCode());
                        errorLog.Error_Record_Id__c     = upsertResult[i].getId();
                        errorLog.Component__c           = component;
                        //errorLog.RecordTypeId              = Schema.SObjectType.Error_Log__c.getRecordTypeInfosByName().get('Business Rules Engine').getRecordTypeId();
                        errorLog.Event__c               = componentName;
                        listLog.add(errorLog);
                    }
                }
            }
        }
        
        // Insert Log
        if(listLog != null && !listLog.isEmpty())
            database.insert(listLog, false);*/
    }

}