/*** Reference implementation for how vendors call implement and register a BasicGov error handler */

public class DebugErrorLoggger implements BGCM.ErrorLogger {
    
    /** Receive notification of a potentially system recoverable error  - DO NOT Change this method, internal to BasicGov */
    public void logError(Exception e) {
        System.debug('An exception has occurred with message : [' +e.getMessage() + '] of type [' + e.getTypeName() + ']' );
        log_into_object(e, 'Critical','BasicGov',null,null,null,null,null,null);
     } //end method


    /** Receive notification of a non-recoverable error - DO NOT Change this method, internal to BasicGov */
    public void logFatalError(Exception e){
        System.debug('An exception has occurred with message : [' +e.getMessage() + '] of type [' + e.getTypeName() + ']' );
        log_into_object(e, 'Fatal','BasicGov',null,null,null,null,null,null); 
    }//End Method


    /** Receive notification of a system warning - DO NOT Change this method, internal to BasicGov */
    public void logWarning(Exception e) {
        System.debug('An exception has occurred with message : [' +e.getMessage() + '] of type [' + e.getTypeName() + ']' );
        log_into_object(e, 'Warning','BasicGov',null,null,null,null,null,null);
    }//end Method
    

    // Method to log errors for Salesforce custom errors
    public static void LogError(Exception e, String sObjectId, String sObjectName,String className,String functionalityImpacted, String additionalDetails, String additionalDetails2){
        String errorType = DOL_AppConstants.NULL_EMPTY_STRING + 'Critical';
        if (e == null){errorType = DOL_AppConstants.NULL_EMPTY_STRING + 'Debug';}
        log_into_object(e,errorType,'Unmanaged',sObjectId,sObjectName,className,functionalityImpacted,additionalDetails,additionalDetails2);
    } //End Method

 // Method to log errors for Salesforce custom errors
    public static void LogError(Exception e, String sObjectId, String sObjectName,String className,String functionalityImpacted, String additionalDetails){
        LogError(e, sObjectId, sObjectName,className,functionalityImpacted, additionalDetails, null);
    } //End Method

   // Method to log errors for Salesforce custom errors
    public static void LogWarning(Exception e, String sObjectId, String sObjectName,String className,String functionalityImpacted,String additionalDetails, String additionalDetails2){
        String errorType = DOL_AppConstants.NULL_EMPTY_STRING + 'Warning';
        if (e == null){errorType = DOL_AppConstants.NULL_EMPTY_STRING + 'Debug';}
        log_into_object(e,errorType,'Unmanaged',sObjectId,sObjectName,className,functionalityImpacted,additionalDetails,additionalDetails2);
    } //End Method

    // Method to log errors for Salesforce custom errors
    public static void LogWarning(Exception e, String sObjectId, String sObjectName,String className,String functionalityImpacted,String additionalDetails){
        LogWarning(e, sObjectId, sObjectName,className,functionalityImpacted, additionalDetails, null);
    } //End Method
    
      // Method to log errors for Salesforce custom errors
    public static void LogFatal(Exception e, String sObjectId, String sObjectName,String className,String functionalityImpacted, String additionalDetails, String additionalDetails2){
        String errorType = DOL_AppConstants.NULL_EMPTY_STRING + 'Fatal';
        if (e == null){errorType = DOL_AppConstants.NULL_EMPTY_STRING + 'Debug';}
        log_into_object(e,errorType,'Unmanaged',sObjectId,sObjectName,className,functionalityImpacted,additionalDetails,additionalDetails2);
    } //End Method
    
    // Method to log errors for Salesforce custom errors
    public static void LogFatal(Exception e, String sObjectId, String sObjectName,String className,String functionalityImpacted, String additionalDetails){
        LogFatal(e, sObjectId, sObjectName,className,functionalityImpacted, additionalDetails, null);
    } //End Method
    
    public static void dolLogger(Dol_LoggerInput li){
        log_into_object(li.e,li.errorType,li.SourcePackage,li.sObjectId,
                        li.sObjectName,li.className,li.functionalityImpacted,
                        li.additionalDetails,li.additionalDetails2);
    }
    // Internal log error method
     private static void log_into_object(Exception e, String errorType, String SourcePackage,String sObjectId, String sObjectName, String className, String functionalityImpacted, String additionalDetails,String additionalDetails2){
        
        //Check if user is trying to insert exception or custom debug statement. If its custom debug only, check if label.EnableDebugLogs is enabled
        if ((isDebugLogsEnabled() != true) && (e == null) ){
            return; //no need to log since its not exception and Debug log is disabled
        }//end if 

        Error_Logs__c logRecord = new Error_Logs__c();
       
        if (e != null){
            if (e.getCause()!=null){logRecord.Error_Cause__c = e.getCause()+'';}
            if (e.getMessage()!=null){logRecord.Error_Description__c = e.getMessage();}
            if (e.getLineNumber()!=null) {logRecord.Error_Line_Number__c = DOL_AppConstants.NULL_EMPTY_STRING + '' + e.getLineNumber();}
            if (e.getStackTraceString()!=null){logRecord.Error_Stack__c = e.getStackTraceString();}
            if (e.getTypeName()!=null){logRecord.Error_Type__c = e.getTypeName();}
        }//end if - check for exception object

        if (UserInfo.getUserName()!=null) {logRecord.User_Impacted__c = UserInfo.getUserName();}
        if(SourcePackage!=null){ logRecord.Source_Package__c = SourcePackage;}
        
        if (sObjectId!=null){logRecord.sObject_Id__c = sObjectId;}
        if (sObjectName!=null){logRecord.sObject__c = sObjectName;}
        if (className!=null){logRecord.Class_Name__c = className;}
        if (functionalityImpacted!=null) {logRecord.Functionality_Impacted__c = functionalityImpacted;}
        if(errorType!=null) {logRecord.Error_Category__c = errorType;}
        if(additionalDetails!=null){logRecord.Additional_Details__c = additionalDetails;}
        if(additionalDetails2!=null){logRecord.Additional_Details_2__c = additionalDetails2;}
        
        if (e != null){
            if (e.getTypeName()!=null){
                if ('System.DmlException'.equalsIgnoreCase(e.getTypeName())){
                    String DMLfieldNames = DOL_AppConstants.NULL_EMPTY_STRING + '';
                    String DMLMessage = DOL_AppConstants.NULL_EMPTY_STRING + '';
                    String DMLId = DOL_AppConstants.NULL_EMPTY_STRING + '';
                    String DMLType = DOL_AppConstants.NULL_EMPTY_STRING + '';
                    
                    for(Integer i=0;i<e.getNumDml();i++) {
                    if( DMLfieldNames !='') {DMLfieldNames = DMLfieldNames + ', ' + e.getDmlFieldNames(i);}else{DMLfieldNames = e.getDmlFieldNames(i)+'';}
                    if( DMLMessage !='') {DMLMessage = DMLMessage + ', ' + e.getDmlMessage(i);} else{DMLMessage = e.getDmlMessage(i)+'';}
                    if( DMLId !='') {DMLId = DMLId + ', ' +  e.getDmlId(i);}else{DMLId = e.getDmlId(i)+'';} 
                    if( DMLType  !='') {DMLType = DMLType + ', ' +  e.getDmlType(i);}else{DMLType  = e.getDmlType(i)+'';} 
                    }//end loop
                    
                    logRecord.DML_Field_Names__c = DMLfieldNames;
                    logRecord.DML_Error_Message__c = DMLMessage;
                    logRecord.DML_Id_s__c = DMLId;
                    logRecord.DML_Type__c = DMLType;
                    //}else if ('System.'.equalsIgnoreCase(e.getTypeName())){
                }//endif check exception tyoe
            }//end if check for null            
        }//end if - check for e!=null

        //Publish the message to event platform - In the event object after trigger, error message will be stored into custom object
        Debug_Error_Loggger__e objEvent = new Debug_Error_Loggger__e();
        objEvent.Message__c = JSON.serialize(logRecord);
        EventBus.publish(objEvent);
    }//end method    

    public static Boolean isDebugLogsEnabled(){
        try{
            String labelValue = Label.EnableDebugLogs;
            if ('YES'.equalsIgnoreCase(labelValue) || '1'.equalsIgnoreCase(labelValue) || 'TRUE'.equalsIgnoreCase(labelValue) ){
                return true;
            }//end if 
        }catch(Exception e){
            return false;
        }//end catch
        return false; //default
    }   //end method 

      public static String getURIDetailsForLog(){
       String uriData = DOL_AppConstants.NULL_EMPTY_STRING + '';

        try{
            uriData += '\n\n' + 'Page Base URL: ' + String.valueOf(URL.getSalesforceBaseUrl().toExternalForm());
            uriData += '\n\n' + 'Page URI Details:';

            for (String key : System.currentPageReference().getParameters().keySet()) {
                uriData += '\n\n' + 'URI Parameter ' + key + ' = ' + System.currentPageReference().getParameters().get(key) + '  [' + String.escapeSingleQuotes(System.currentPageReference().getParameters().get(key)) + ']';
            }//endfor
            return uriData;
        }catch(Exception e){return '';}

    }//end Method


}//End class