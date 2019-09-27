/**
 * User Story: 
 * Name: Dol_Batch_UpdateLicenseStatus
 * Type: Class
 * Description: Batch to update status field to Abandoned if a draft application is not modified for 30 days
 *              & delete the abandoned applications if not modified for 120 days.
 * Date:        - Case#/Project:            - Developer/Company                         - Description
 * ------------------------------------------------------------------------------------------------------------------------- *
 * 09/26/2019   Mangesh Abhang/Deloitte           Initial Creation 
 */
global with sharing class Dol_Batch_UpdateLicenseStatus implements Database.Batchable<sObject>, Schedulable  {

    global Database.QueryLocator start(Database.BatchableContext BC){
        system.debug('inside batch');
        return Database.getQueryLocator([SELECT ID,Name,MUSW__Expiration_Date__c,Late_Renewal_Eligible_End_Date__c,Renewal_Grace_Period_End_Date__c,Renewal_Eligible_Start_Date__c,MUSW__Status__c from MUSW__License2__c WHERE MUSW__Expiration_Date__c <= Today AND  MUSW__Status__c   in ('Active')]);
        
    }    
    global void execute(Database.BatchableContext BC, List<MUSW__License2__c> lstLicense) {
       
        DOL_AppUtility.runfromDolBatchUpdateLicenseStatus = true;
        system.debug('lstLicensebatch'+lstLicense);
        List<MUSW__License2__c>  lstExpiredLicenses = new List<MUSW__License2__c>();
        List<MUSW__License2__c>  lstCancelledLicenses = new List<MUSW__License2__c>();
        for(MUSW__License2__c appLicense : lstLicense) {
            if(appLicense.MUSW__Status__c == DOL_AppConstants.ACTIVE){
                appLicense.MUSW__Status__c = DOL_AppConstants.EXPIRED;
                lstExpiredLicenses.add(appLicense);
                
            }

        }
        
        try{
            if(!lstExpiredLicenses.isEmpty()){
                Database.SaveResult[] srList = Database.update(lstExpiredLicenses, false);
                for (Database.SaveResult sr : srList) {
                    if (!sr.isSuccess()) {
                        for(Database.Error err : sr.getErrors()) {                            
                             DOL_CreateErrorLog_Exception.logDatabaseError(err, 'Dol_Batch_UpdateLicenseStatus', 'execute');
                        }
                    } else  {
                         DOL_CreateErrorLog_Exception.logDeleteDetails ('Successfully updated License ID: ' + sr.getId(),'Dol_Batch_UpdateLicenseStatus', 'execute');
                    }
                }
                
               
            }
        }
        catch(Exception e){
            System.debug(e);
            DOL_CreateErrorLog_Exception.logApplicationError(e);
        }
        
    }
    global void finish(Database.BatchableContext BC) {
        
        //no action
    }
    global void execute(SchedulableContext ctx) {
        Dol_Batch_UpdateLicenseStatus b = new Dol_Batch_UpdateLicenseStatus ();
        try{
             database.executebatch(b,200);
        } catch (Exception e) {
            DOL_CreateErrorLog_Exception.logApplicationError(e, 'Dol_Batch_UpdateLicenseStatus', 'execute schedulabel');
        }
       
    }
}