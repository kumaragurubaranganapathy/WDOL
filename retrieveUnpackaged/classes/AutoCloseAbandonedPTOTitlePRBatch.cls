/**
 * User Story: 285
 * Name: AutoCloseAbandonedPTOTitlePRBatch
 * Type: Class
 * Description: Batch to auto change Status and Sub Status field for abandoned Permit to operate ONLY-
 *  -DIS (PTO) switch to Closed after 30 days of being in a request for additional information status
 * Date:        - Case#/Project:            - Developer/Company                         - Description
 * ------------------------------------------------------------------------------------------------------------------------- *
 * 07/09/2018   Sharad Maheshwari/Deloitte           Initial Creation 
 */

global with sharing class AutoCloseAbandonedPTOTitlePRBatch implements Database.Batchable<sObject>{
    global final String query;  
    
    global AutoCloseAbandonedPTOTitlePRBatch(String q){  
        //System.debug('constructor query'+q);
        query=q;        
    }
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        //System.debug('before calling');
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, 
                        List<MUSW__Permit2__c> scope){
                            //System.debug('scope +'+scope);
                            List<MUSW__Permit2__c>  permitListToUpdateStatus = new List<MUSW__Permit2__c>();       
                            
                            for(MUSW__Permit2__c permitList : scope){            
                                permitList.MUSW__Status__c = Label.ST_Withdrawn;
                                //licList.Sub_Status__c = 'Abandoned';//Label.ST_Abandoned;                                  
                                permitListToUpdateStatus.add(permitList); 
                            }      
                            //System.debug('permitListToUpdateStatus >>'+permitListToUpdateStatus);
                            try{
                                if(!permitListToUpdateStatus.isEmpty()){
                                    //System.debug('in is not empty');
                                update permitListToUpdateStatus;
                                //check how to delete fee??
                                
                                /*//previous approach
                                 * Once the status is updated, the fee will be deleted overnight through ENT batch 
                                which checks for Marked_for_Deletion__c field on MUSW__Fee__c object*/
                                }
                            }
                            catch(Exception e){
                                //System.debug('in exception');
                               ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'AutoCloseAbandonedPTOTitlePRBatch', 'Update record', 'execute', 'AutoCloseAbandonedPTOTitlePRBatch', label.Str_Low);
                            }                            
                        }
    
    global void finish(Database.BatchableContext BC){
        
    }
    
}