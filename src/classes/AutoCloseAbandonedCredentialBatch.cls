/**
 * User Story: 285
 * Name: AutoCloseAbandonedCredentialBatch
 * Type: Class
 * Description: Batch to auto change Status and Sub Status field for abandoned credentials-
 *  -DPCP (Credential) switch to Closed after 365 days of being in a pending status
 * Date:        - Case#/Project:            - Developer/Company                         - Description
 * ------------------------------------------------------------------------------------------------------------------------- *
 * 07/09/2018   Sharad Maheshwari/Deloitte           Initial Creation 
 */

global with sharing class AutoCloseAbandonedCredentialBatch implements Database.Batchable<sObject>{
    global final String query;  
    
    global AutoCloseAbandonedCredentialBatch(String q){        
        query=q;        
    }
    global Database.QueryLocator start(Database.BatchableContext BC){        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, 
                        List<MUSW__License2__c> scope){
                            
                            List<MUSW__License2__c>  credentialListToUpdateStatus = new List<MUSW__License2__c>();       
                            
                            for(MUSW__License2__c credentialList : scope){            
                                credentialList.MUSW__Status__c = Label.ST_Withdrawn;
                                //licList.Sub_Status__c = 'Inactive';
                                
                                credentialListToUpdateStatus.add(credentialList); 
                            }      
                            
                            try{
                                if(!credentialListToUpdateStatus.isEmpty()){
                                update credentialListToUpdateStatus;
                                //check how to delete fee??
                                
                                /*//previous approach
                                 * Once the status is updated, the fee will be deleted overnight through ENT batch 
                                which checks for Marked_for_Deletion__c field on MUSW__Fee__c object*/
                                }
                            }
                            catch(Exception e){
                               ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'AutoCloseAbandonedCredentialBatch', 'Update record', 'execute', 'AutoCloseAbandonedCredentialBatch', label.Str_Low);
                            }                            
                        }
    
    global void finish(Database.BatchableContext BC){
        
    }
    
}