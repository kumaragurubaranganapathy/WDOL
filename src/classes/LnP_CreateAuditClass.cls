/*@AUTHOR: Kojashree Kakariya
@Date:  25-June-2019      

Description: Class to select ten percent of renewal and license records for audit process.

MODIFICATION LOG:
DEVELOPER                          DATE                     DESCRIPTION
================================================================================
Kojashree Kakariya               25-June-2019             Initial Creation
================================================================================= */

public class LnP_CreateAuditClass {
    
    //Generic class to calculate ten percent of records of each License Type
    
    public static List<SObject> calculateTenPercentRecords(List<SObject> appList){
        system.debug('appList 123'+appList);
        Integer listSize = appList.size();
        system.debug('listSize---'+listSize);
        Integer tenPerRecList = (listSize < 10 ) ? 1 : (listSize*0.1).intValue();
        system.debug('tenPerRecList---'+tenPerRecList);
        List<SObject> selectedRenApp = new List<SObject>();  
        System.debug('tenPerRecList::'+tenPerRecList);
        
        for(Integer i= 0; i< tenPerRecList;i++){
            if(appList.size() !=0){
                selectedRenApp.add(appList[i]);
                system.debug('selectedRenApp---'+selectedRenApp); 
            }
            
        }
        system.debug('tenPerRecList---'+tenPerRecList);
        return selectedRenApp;
    } 
    
    // Create an updated map with ten percent records selected of each RE License type 
    public static Map<String,List<Renewal_Application__c>> getUpdatedRenewalAppMap(Map<String,List<Renewal_Application__c>> renApplicationMap){
        system.debug('renApplicationMap---'+renApplicationMap);
        Map<String,List<Renewal_Application__c>> updatedRenAppMap = new Map<String,List<Renewal_Application__c>>();
       
        for(String key : renApplicationMap.keySet()){
            system.debug('keySet--'+key);
            system.debug('value--'+renApplicationMap.get(key));
            
            List<Renewal_Application__c> updatedList = new List<Renewal_Application__c>();
            updatedList = calculateTenPercentRecords(renApplicationMap.get(key));
            system.debug('updatedList---'+updatedList);
            updatedRenAppMap.put(key,updatedList);
         }
        return updatedRenAppMap;
    }
    
    // Create an updated map with ten percent records selected of each RBS License type 
    public static Map<String,List<MUSW__License2__c>> getUpdatedLicenseMap(Map<String,List<MUSW__License2__c>> rbsAppMap ){
        system.debug('rbsAppMap---'+rbsAppMap);
        Map<String,List<MUSW__License2__c>> updatedLicenseMap = new Map<String,List<MUSW__License2__c>>();
        
        for(String key : rbsAppMap.keySet()){
            List<MUSW__License2__c> updatedRBSList = new List<MUSW__License2__c>();
            system.debug('keySet--'+key);
            system.debug('value--'+rbsAppMap.get(key));
            
           updatedRBSList = calculateTenPercentRecords(rbsAppMap.get(key));
           system.debug('updatedList---'+updatedRBSList);
           updatedLicenseMap.put(key,updatedRBSList);
            
        }
        return updatedLicenseMap;
    }
    
    
 public static void createAuditForRE(List<Renewal_Application__c> appList){
        List<MUSW__Review__c> auditList = new List<MUSW__Review__c>();
        List<Renewal_Application__c> updateFlagforAuditList = new List<Renewal_Application__c>();
        system.debug('appList---'+appList);
        Id recordTypeId = Schema.SObjectType.MUSW__Review__c.getRecordTypeInfosByName().get('CE Audit Review').getRecordTypeId();
        system.debug(' ce audit review record type '+recordTypeId);
        for(Renewal_Application__c renApp : appList){
            MUSW__Review__c newAuditReviewRec = new MUSW__Review__c(
                Renewal_Application__c = renApp.Id,
                recordTypeId = recordTypeId,
                Application_Type__c = renApp.Application_Type__c,
                License__c = renApp.License__c,
                MUSW__Status__c =  'Pending',
                Review_Type__c = 'CE Audit',
                License_Type__c = renApp.Credential_Type__c
            );
            renApp.Selected_for_Audit__c = true;
            updateFlagforAuditList.add(renApp);
            auditList.add(newAuditReviewRec);
            system.debug('auditList 1-------'+auditList);
        }
     if(!auditList.isEmpty()){
         insert auditList;
     } 
     if(!updateFlagforAuditList.isEmpty()){
         update updateFlagforAuditList;
     }
 }
    
    public static void createAuditForRBS(List<MUSW__License2__c> licenseList){
        List<MUSW__Review__c> auditList = new List<MUSW__Review__c>();
        List<Request__c> requestList = new List<Request__c>();
        List<MUSW__License2__c> updateFlagOnLicenseList = new List<MUSW__License2__c>();
        
        system.debug('licenseList---'+licenseList);
        Id recordTypeId = Schema.SObjectType.MUSW__Review__c.getRecordTypeInfosByName().get('CE Audit Review').getRecordTypeId();
        system.debug(' ce audit review record type '+recordTypeId);
        for(MUSW__License2__c licenseApp : licenseList){
            MUSW__Review__c newAuditReviewRec = new MUSW__Review__c(
                recordTypeId = recordTypeId,
                Application_Type__c = licenseApp.Application_Type__c,
                License__c = licenseApp.Id,
                MUSW__Status__c = 'Pending',
                Review_Type__c = 'CE Audit',
                License_Type__c = licenseApp.Credential_Type__c
            );
          
            auditList.add(newAuditReviewRec);
            system.debug('auditList-------'+auditList);
            
            Request__c newCEAuditRequest = new Request__c(
                Profession__c = licenseApp.Application_Type__c,
                License_Type__c = licenseApp.Credential_Type__c,
                Service_Request_Type__c = 'CE Audit',
                License__c = licenseApp.id,
                Status__c = 'Draft'
           );
           requestList.add(newCEAuditRequest); 
            
            licenseApp.Selected_for_Audit__c = true;
            updateFlagOnLicenseList.add(licenseApp);
           system.debug('newCEAuditRequest----'+newCEAuditRequest);
           
        }
        if(!auditList.isEmpty()){
            insert auditList;
        } 
        if(!requestList.isEmpty()){
            insert requestList;
        }
        if(!updateFlagOnLicenseList.isEmpty()){
            update updateFlagOnLicenseList;
        }
    }
    
}