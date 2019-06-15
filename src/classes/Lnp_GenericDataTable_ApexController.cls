public class Lnp_GenericDataTable_ApexController {        
    @AuraEnabled
    public static List<Sobject> getSobjectData(List<String> soqlFields,String sObjectName,String BusinessFunction){
        List<sObject> sObjList;
        if(BusinessFunction == 'Current Licenses'){
        sObjList   = [Select Name,Application_Type__c,Credential_Type__c,MUSW__Expiration_Date__c,MUSW__Status__c,Sub_Status__c 
                                     from MUSW__License2__c
                                     where MUSW__Applicant__c in(Select ContactId From User Where Id =: UserInfo.getUserId())];
         //sObjList = [select id from contact where id  = '003r000100EoRNc'];
        
        }else if(BusinessFunction == 'Draft License'){
          sObjList   = [Select Name,Application_Type__c,Credential_Type__c,Application_Method__c,LastModifiedDate 
                                     from MUSW__License2__c
                                     where MUSW__Status__c <> 'Active' AND MUSW__Applicant__c in(Select ContactId From User Where Id =: UserInfo.getUserId())];
             	 
        }else if(BusinessFunction == 'Draft Renew License'){
         	sObjList   = [Select License_Number__c,Application_Type__c,Credential_Type__c,Renewal_Expiration_Date__c,LastModifiedDate 
                                     from Renewal_Application__c
                                     where Renewal_Status__c = 'Draft' AND Applicant__c in(Select ContactId From User Where Id =: UserInfo.getUserId())];
            
           
         }else if(BusinessFunction == 'Draft Maintance Request'){
         sObjList   = [Select  License_Type__c, Service_Request_Type__c
                                     from Request__c
                                     where Status__c = 'Under Review' AND Contact__c in(Select ContactId From User Where Id =: UserInfo.getUserId())];
            
         }
         if(!sObjList.isEmpty()){
             return sObjList;
         }else{
             return null;
         }
         

    }

}