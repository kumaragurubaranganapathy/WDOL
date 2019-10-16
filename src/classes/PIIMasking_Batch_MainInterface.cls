/*************************************************************************************************************
** User Story: 31137 TECH: Create a new batch interface using Apex to loop over sObjects defined in Custom Metadata
**************************************************************************************************************
** Class Name    : PIIMasking_Batch_MainInterface
** Description   : Sets the batch job to be kicked off the masking the object fields specified in the VF Page.
**                  Classname: PIIMasking_MainInterface_Constructor.cls is the controller for the VFPage.
**                  Classname: PIIMasking_MainInterface_Constructor.cls calls PIIMasking_Utility's constructor
passing ObjectName and its field(s). to PIIMasking_Utility.
** Version       : 1.0
** Built By      : Masood Mahmood
**------------------------------------------------------------------------------------------------------------
** Modification Log:
**------------------
** Developer                         Date                    Version                     Description
**------------------------------------------------------------------------------------------------------------
** Masood Mahmood                   08/23/2016                  1                        Created
** Rohit Gowrishetty                10/30/2017                  2                        Edited for Custom labels
** Review Log:
**---------------
** Reviewer                         Date                    Version                      Description
** Kaistha, Aayush                  09/15/2016                   1                        Reviewed
**------------------------------------------------------------------------------------------------------------
**
**  **********************************************************************************/

global class PIIMasking_Batch_MainInterface implements Database.Batchable<sObject> {
    
    global String query, sObjectName, fieldname, mdtquery;
    global Set<string> fieldvalues;
    global List<Sandbox_Refresh_PII_Masking__mdt> MaskingMetaDatum;
//    global sObjectType sObj;
    
        /**
* Method name  : PIIMasking_Batch_MainInterface constructor 
* Description  : Kicks of the instantiation of the batch to be run.Gets the metadata type list and sObjectType 
* Return Type  : void
* Parameter    : String query, String sObjectName, Set<String> fname
**/
    global PIIMasking_Batch_MainInterface(String query, String sObjectName, Set<String> fname) {
        this.query = query;
        fieldvalues = fname;
        this.sObjectName = sObjectName;
        mdtquery = DOL_AppConstants.NULL_EMPTY_STRING + 'Select FieldName__c, MaskingString__c, Masking__c, ObjectName__c from Sandbox_Refresh_PII_Masking__mdt where ObjectName__c = \'' ;
        mdtquery   += this.sObjectName;
        Integer size = fieldvalues.size();
        
        if (fieldvalues.size() > 0 ) {
            for (String element : fieldvalues) {
                if (size == (fieldvalues.size())) {
                    mdtquery += '\'  and  ( FieldName__c= \'' + String.escapeSingleQuotes(element) + '\'';
                } else {
                    mdtquery += ' or FieldName__c= \'' + String.escapeSingleQuotes(element) + '\'';
                }
                size = size - 1;
            }
        }
        mdtquery += ')';
        MaskingMetaDatum = Database.query(mdtquery);
       // this.sObj = Schema.getGlobalDescribe().get(sObjectName);
    }
    
        /**
* Method name  : start
* Description  : Returns the query of the batch to be run.
* Return Type  : Database.QueryLocator
* Parameter    : Database.BatchableContext BC
**/
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }
    
    /**
* Method name  : execute
* Description  : Schedules the batch job to be kicked off to mask the object fields specified in the VF Page.
* Return Type  : void
* Parameter    : Database.BatchableContext BC, List<sObject> scope
**/
    global void execute(Database.BatchableContext BC, List<sObject> scope ) {
        if (PIIMasking_Utility.isSandbox && scope != null) { //Run only in the sandbox org.
            List<sObject> updateList = scope;
            for ( Sobject acc : updateList ) {
                for (Sandbox_Refresh_PII_Masking__mdt MaskingMetaData : MaskingMetaDatum) {
                    if (MaskingMetaData.Masking__c.equalsIgnoreCase('1. NULL')) {
                        acc.put(MaskingMetaData.FieldName__c, MaskingMetaData.MaskingString__c);
                    } else if (MaskingMetaData.Masking__c.equalsIgnoreCase(label.Str_X2_APPEND_BEGINNING)) {
                        acc.put(MaskingMetaData.FieldName__c, MaskingMetaData.MaskingString__c + acc.get(MaskingMetaData.FieldName__c));
                    } else if (MaskingMetaData.Masking__c.equalsIgnoreCase('3. APPEND END')) {
                        acc.put(MaskingMetaData.FieldName__c, acc.get(MaskingMetaData.FieldName__c) + MaskingMetaData.MaskingString__c);
                    } else if (MaskingMetaData.Masking__c.equalsIgnoreCase('4. APPEND BOTH')) {
                        acc.put(MaskingMetaData.FieldName__c, MaskingMetaData.MaskingString__c + acc.get(MaskingMetaData.FieldName__c) + MaskingMetaData.MaskingString__c);
                    } else if (MaskingMetaData.Masking__c.equalsIgnoreCase(label.Str_X5_REPLACE_DOMAIN)) {                      
                        String username,domain;
                        String email = String.valueOf(acc.get(MaskingMetaData.FieldName__c));
                        if(email!=null){
                            email.deleteWhitespace();
                            username = email.split('@').get(0);
                            domain = email.split('@').get(1);
                            Integer sizelimit= 80-MaskingMetaData.MaskingString__c.length();
                            if (username.length() >sizelimit)
                            {
                                username = username.substring(0, sizelimit);
                            }
                        }                       
                       else{                            
                            email= DOL_AppConstants.NULL_EMPTY_STRING + 'test@test.com';
                            username = email.split('@').get(0);
                            domain = email.split('@').get(1);
                        }                        
                        acc.put(MaskingMetaData.FieldName__c, username + MaskingMetaData.MaskingString__c);
                    }
                }
            }
            List<Database.saveResult> lstRes = new List<Database.saveResult>() ;
            Database.SaveResult[] srList = Database.update(updateList, false);
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                   // System.debug('Successfully inserted account. Account ID: ' + sr.getId());
                } else {
                    lstRes.add(sr);
                    for (Database.Error err : sr.getErrors()) {
                     //   System.debug('The following error has occurred.');
                    //    system.debug('saveresultError' + sr);
                    //    system.debug(err.getStatusCode() + ': ' + err.getMessage());
                    }
                }
            }
         //   if (lstRes.isEmpty() == false ) {
              //  ErrorLogger.logDMLDatabaseResultErrors(UserInfo.getUserId(), null, lstRes, null, label.Str_User, label.Err_Occured_while_updating + ' '+ sObjectName + ' '+fieldvalues, label.Str_Update+' '+sObjectName, label.Str_PIIMasking_Batch_MainInterface, label.Err_Severity, label.Str_PIIMasking_Batch_MainInterface);
         //   }
        }
    }
   
    global void finish(Database.BatchableContext BC) {
    }
}