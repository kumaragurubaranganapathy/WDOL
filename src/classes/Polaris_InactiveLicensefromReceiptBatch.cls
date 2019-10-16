/*@AUTHOR: Rishap Varma
@Date:  26-Sept-2019      

Description: 

MODIFICATION LOG:
DEVELOPER                          DATE                     DESCRIPTION
================================================================================
Rishap Varma               26-Sept-2019             Initial Creation
================================================================================= */
global class Polaris_InactiveLicensefromReceiptBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        return Database.getQueryLocator('SELECT Id,Inactivate_License_Date__c FROM MUSW__Receipt__c WHERE DHP__c = True AND Inactivate_License_Date__c != null' );
    }
    global void execute(Database.BatchableContext bc, List<MUSW__Receipt__c> DHPReceiptList){
       // system.debug('Scope : '+DHPReceiptList);
        
        SET<Id> receiptIds = new SET<Id>();
        if(!DHPReceiptList.isEmpty()){
            for(MUSW__Receipt__c rec : DHPReceiptList){
                receiptIds.add(rec.Id);
            }
        //    system.debug('receiptIds : '+receiptIds); 
        }
         
        //querying the Fee Payment junction obj
        List<MUSW__Fee_Payment__c> feepaymentList = [SELECT 
                                                     Id,
                                                     Related_To_License__c,
                                                     MUSW__Receipt__c,
                                                     MUSW__Fee__c 
                                                     FROM MUSW__Fee_Payment__c 
                                                     WHERE MUSW__Receipt__c IN : receiptIds AND MUSW__Receipt__c != NULL 
                                                    ];
       // system.debug('feepaymentList : '+feepaymentList);
        
        
        Map<Id,Id> receiptFeePaymentMap = new Map<Id,Id>();  //map of receipt and fee Id
        Map<Id,Id> feetoLicenseMap = new Map<Id,Id>(); // map of fee and license Id
        Set<Id> feeIds = new Set<Id> ();  //set of Fee ids
        Set<Id> relatedFeeLicense = new Set<Id>(); // set of License Ids related to Fee
        if(!feepaymentList.isEmpty()){
            for(MUSW__Fee_Payment__c feePay : feepaymentList){
                feeIds.add(feePay.MUSW__Fee__c);
                relatedFeeLicense.add(feePay.Related_To_License__c); 
                
                receiptFeePaymentMap.put(feePay.MUSW__Receipt__c,feePay.MUSW__Fee__c );
                feetoLicenseMap.put(feePay.MUSW__Fee__c,feePay.Related_To_License__c );
            }
            
        //    system.debug('feeIds : '+feeIds);
         //   system.debug('relatedFeeLicense : '+relatedFeeLicense);
        //    system.debug('receiptFeePaymentMap : '+receiptFeePaymentMap);
          //  system.debug('feetoLicenseMap : '+feetoLicenseMap);
        }
        
        
        Map<Id,MUSW__License2__c> licenseToUpdate = new Map<Id,MUSW__License2__c>([Select 
                                                                                   Id, 
                                                                                   MUSW__Status__c,
                                                                                   Polaris_DHP__c
                                                                                   from MUSW__License2__c 
                                                                                   where Id IN : relatedFeeLicense and Id != NULL 
                                                                                  ]);
        Map<Id,MUSW__Fee__c> feesToCompare = new Map<Id,MUSW__Fee__c>([Select 
                                                                       Id,
                                                                       MUSW__Outstanding_Fee__c 
                                                                       from MUSW__Fee__c where Id IN :feeIds and ID != NULL
                                                                      ]) ;
        
     //   system.debug('licenseToUpdate : '+licenseToUpdate);
     //   system.debug('feesToCompare : '+feesToCompare);
        
        list<MUSW__License2__c> finalLicenseList =  new list<MUSW__License2__c>();
        
        //already checked for Null/Empty above
        //
        for(MUSW__Receipt__c rec : DHPReceiptList){
         //   system.debug('rec.Inactivate_License_Date__c : ' + rec.Inactivate_License_Date__c);
         //   System.debug('System.today() : '+System.today());
            if(rec.Inactivate_License_Date__c == System.today()){
                
                //getting the Fee to check if its Outstanding Amount is greater than 0
                if(receiptFeePaymentMap != null && receiptFeePaymentMap.ContainsKey(rec.Id) && receiptFeePaymentMap.get(rec.Id) !=  null ){
                    Id feeId = receiptFeePaymentMap.get(rec.Id);
                    if(feesToCompare != null && feesToCompare.ContainsKey(feeId) && feesToCompare.get(feeId) !=  null ){
                        MUSW__Fee__c fee = feesToCompare.get(feeId);
                        if(fee.MUSW__Outstanding_Fee__c > 0){
                            
                            if(feetoLicenseMap != null && feetoLicenseMap.ContainsKey(fee.Id) && feetoLicenseMap.get(fee.Id) !=  null ){
                                Id licId = feetoLicenseMap.get(fee.Id);
                                if(licenseToUpdate != null && licenseToUpdate.ContainsKey(licId) && licenseToUpdate.get(licId) !=  null ){
                                    MUSW__License2__c lic = licenseToUpdate.get(licId);
                                    if(lic.MUSW__Status__c != 'Inactive'&& lic.Polaris_DHP__c == True){
                                        lic.MUSW__Status__c = 'Inactive';
                                        finalLicenseList.add(lic);
                                    }// end : check for inactive Status      
                                }//end : null check for licenseToUpdate
                                
                            }//end : null check for feetoLicenseMap                            
                            
                        }// end : check fot outstanding amount 
                    }//end : null check for feesToCompare
                    
                }//end : null check for receiptFeePaymentMap
                
            }//end : check for todays date
        }//end of For
      //  system.debug('finalLicenseList : '+finalLicenseList);
        If(!finalLicenseList.isEmpty()){
            update finalLicenseList;
          //  system.debug('AFTER finalLicenseList : '+finalLicenseList);
        }
        
        //Call the method for review
    }
    global void finish(Database.BatchableContext bc){
     //   system.debug('Batch Completed');
        // execute any post-processing operations
    }   
}