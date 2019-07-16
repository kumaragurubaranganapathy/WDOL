global with sharing class HandleIncompleteRenewalsExpirationBatch implements Database.Batchable<sObject> {
		
    
    global final String query;  
    
    global HandleIncompleteRenewalsExpirationBatch(String q){        
        query=q;        
        System.debug('query from batch '+ query);
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
          return Database.getQueryLocator(query);
      }

      //Method to execute the batch
      global void execute(Database.BatchableContext BC, List<MUSW__License2__c> scope ){
          System.debug('in HandleIncompleteRenewalsExpirationBatch scope '+ scope);          
        	Date todaysDate = System.Date.today();
          Set<ID> licenseIdList = new Set<ID>();
          for(MUSW__License2__c licRecord :scope){
              licenseIdList.add(licRecord.ID);
          }
          System.debug('licenseIdList '+licenseIdList);
          Map<ID, ID> licenseRenewalMap = new Map<ID, ID>();
          //fetch all the renewals in submitted status for the given credentials
          List<Renewal_Application__c> correspondingRenewalList = [SELECT license__r.Id, Id
                                                                  FROM Renewal_Application__c
                                                                  WHERE license__r.id IN :licenseIdList
                                                                  AND Renewal_Status__c = :Label.ST_Submitted];
          System.debug('correspondingRenewalList '+correspondingRenewalList);
          //create a map to store license id and corresponding renewal id
          for(Renewal_Application__c renewalRecord: correspondingRenewalList){
              licenseRenewalMap.put(renewalRecord.license__r.Id, renewalRecord.Id);
              
          }
          System.debug('licenseRenewalMap '+licenseRenewalMap);
          List<MUSW__License2__c> licensesToUpdateList = new List<MUSW__License2__c>();
          List<MUSW__Fee__c> feesToCreate = new List<MUSW__Fee__c>();
          List<Renewal_Application__c> renewalsToUpdate = new List<Renewal_Application__c>();
          MUSW__License2__c licenseToUpdate; 
        for(MUSW__License2__c licenseRecord :scope){
            /*System.debug('licenseRecord '+licenseRecord);
            System.debug('licenseRecord.CE_Hours_per_Cycle__c '+licenseRecord.CE_Hours_per_Cycle__c);
            System.debug('licenseRecord.MUSW__Status__c '+licenseRecord.MUSW__Status__c);
            System.debug('licenseRecord.Renewal_Cycle_End_Date__c '+licenseRecord.Renewal_Cycle_End_Date__c);
            System.debug('todaysDate '+todaysDate);*/
            Decimal licenseCEHours = licenseRecord.CE_Hours__c;
            if(licenseCEHours == null){
                licenseCEHours = 0.0;
            }
            System.debug('licenseCEHours '+licenseCEHours);
            
            if(licenseCEHours < licenseRecord.CE_Hours_per_Cycle__c &&
               licenseRecord.Is_Late_Renewal_Eligible__c &&
              licenseRecord.MUSW__Status__c <> Label.ST_Late_Renewal &&
              todaysDate > licenseRecord.MUSW__Expiration_Date__c &&
              licenseRecord.Renewal_Cycle_End_Date__c > todaysDate){
                  System.debug('batch in if');
                  licenseToUpdate = new MUSW__license2__c(Id = licenseRecord.Id, 
                                                          MUSW__Status__c = Label.ST_Late_Renewal);
                   licensesToUpdateList.add(licenseToUpdate);
                  //if there is a submitted renewal for the given credential, then create a fee record for the same
                  if(licenseRenewalMap.containsKey(licenseRecord.Id)){
                      
                   MUSW__Fee__c lateCEFee = new MUSW__Fee__c(MUSW__Amount__c = 25, Application_Type__c = licenseRecord.Application_Type__c,
                                                            Renewal_Application__c = licenseRenewalMap.get(licenseRecord.Id), MUSW__Type__c = Label.ST_Late_Renewal);
                   //charge late renewal fee
                   feesToCreate.add(lateCEFee);
                   
                   Renewal_Application__c renewalToUpdate = new Renewal_Application__c(Id = licenseRenewalMap.get(licenseRecord.Id), Renewal_Status__c = Label.ST_Additional_Fee_Required);
                   renewalsToUpdate.add(renewalToUpdate);
                      
                  } else{
                   
                   MUSW__Fee__c lateCEFee = new MUSW__Fee__c(MUSW__Amount__c = 25, Application_Type__c = licenseRecord.Application_Type__c,
                                                            MUSW__License2__c = licenseRecord.Id, MUSW__Type__c = Label.ST_Late_Renewal);
                   //charge late renewal fee
                   feesToCreate.add(lateCEFee);
                   
                      
                  }
                  
                  
                
            }else if(licenseCEHours < licenseRecord.CE_Hours_per_Cycle__c &&
              licenseRecord.MUSW__Status__c == Label.ST_Late_Renewal &&
                    todaysDate > licenseRecord.Renewal_Cycle_End_Date__c){
					System.debug('batch in else');
                        licenseToUpdate = new MUSW__license2__c(Id = licenseRecord.Id, 
                                                          MUSW__Status__c = Label.ST_Expired);
                   licensesToUpdateList.add(licenseToUpdate);
                
            }   
                   
        }
          System.debug('licensesToUpdateList '+licensesToUpdateList);
          System.debug('feesToCreate '+feesToCreate);
          System.debug('renewalsToUpdate '+renewalsToUpdate);
          if(licensesToUpdateList.size()>0){
              update licensesToUpdateList;
          }
          if(feesToCreate.size()>0){
              insert feesToCreate;
          }  
          if(renewalsToUpdate.size() > 0){
              update renewalsToUpdate;
          }
       
      }

      // Method to be called after the excute
      global void finish(Database.BatchableContext BC) {
      }
}