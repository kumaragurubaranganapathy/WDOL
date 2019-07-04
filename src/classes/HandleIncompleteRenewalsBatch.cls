global with sharing class HandleIncompleteRenewalsBatch implements Database.Batchable<sObject> {
		
    
       global final String query;  
    
    global HandleIncompleteRenewalsBatch(String q){        
        query=q;        
        System.debug('query from batch '+ query);
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
          return Database.getQueryLocator(query);
      }

      //Method to execute the batch
      global void execute(Database.BatchableContext BC, List<Renewal_application__c> scope ){
          System.debug('in scope '+ scope);
          Set<ID> renewalIds = new Set<ID>();
          for(Renewal_Application__c renewalRecord: scope){
              renewalIds.add(renewalRecord.Id);
          }
          System.debug('renewalIds '+renewalIds);
        List<MUSW__License2__c> licensesToUpdateList = new List<MUSW__License2__c>();
        //List<Renewal_Application__c> renewalsToUpdateList = new List<Renewal_Application__c>();
        List<MUSW__Review__c> reviewsToUpdateList = new List<MUSW__Review__c>();
        MUSW__Review__c reviewToUpdate;
          //fetch list of pending reviews for the renewals
          List<MUSW__Review__c> reviewList = [SELECT renewal_application__r.Id, ID
                                                          FROM MUSW__Review__c 
                                                          WHERE renewal_application__r.Id in :renewalIds
                                             				AND MUSW__Status__c = :Label.ST_Pending];
          System.debug('reviewList '+reviewList);
		  Map<ID, ID> renewalReviewMap = new Map<ID, ID>();
          //create a map for renewal and corresponding review id's
          for(MUSW__Review__c reviewRecord: reviewList){
              System.debug('reviewRecord '+reviewRecord);
              renewalReviewMap.put(reviewRecord.renewal_application__r.Id, reviewRecord.Id);
          }
          System.debug('renewalReviewMap '+renewalReviewMap);
          for(Renewal_Application__c renewalMap: scope){
            System.debug('in renewalMap for loop '+renewalMap);
          	MUSW__License2__c licenseToUpdate;
            Renewal_Application__c renewalToUpdate;
             //if ce hours on renewal record is greater than ce hours per cycle from credential record
             //then mark the review as approved
             //and update the ce hours on credential
              if(renewalMap.CE_Hours__c >= renewalMap.license__r.CE_Hours_Per_Cycle__c && renewalMap.license__r.MUSW__Total_Balance__c == 0){
                  System.debug('in if renewalMap.CE_Hours__c >= renewalMap.license__r.CE_Hours_Per_Cycle__c');
                  System.debug('renewalReviewMap.get(renewalMap.Id) '+renewalReviewMap.get(renewalMap.Id));
                  if(renewalReviewMap.get(renewalMap.Id) != null){
                      //if condition added for bug#2826
                      //this if condition only picks those review records which are in pending status as per the query for reviewList
                      reviewToUpdate = new MUSW__Review__c(Id = renewalReviewMap.get(renewalMap.Id),
                                                      MUSW__Status__c = Label.ST_Approved);
                      reviewsToUpdateList.add(reviewToUpdate);
                      //renewalToUpdate = new Renewal_Application__c(Id = renewalMap.ID, Renewal_Status__c = Label.ST_Complete);
                      //renewalsToUpdateList.add(renewalToUpdate);
                      licenseToUpdate = new MUSW__license2__c(Id = renewalMap.license__r.Id, 
                                                              CE_Hours__c = (renewalMap.CE_Hours__c - renewalMap.license__r.CE_Hours_Per_Cycle__c));
                      licensesToUpdateList.add(licenseToUpdate);
                  }
              }else{
                  System.debug('in else');
                  licenseToUpdate = new MUSW__license2__c(Id = renewalMap.license__r.Id, 
                                                          CE_Hours__c = renewalMap.CE_Hours__c);
                  licensesToUpdateList.add(licenseToUpdate);
              }
              
              
          }
        
          System.debug('licensesToUpdateList '+licensesToUpdateList);
          System.debug('reviewsToUpdateList '+reviewsToUpdateList);
          if(licensesToUpdateList.size() > 0){
              update licensesToUpdateList;
          }
          if(reviewsToUpdateList.size() > 0){
              update reviewsToUpdateList;
          }
          
       
      }

      // Method to be called after the excute
      global void finish(Database.BatchableContext BC) {
          
          //upon successful completion of the previous batch, excute the next batch
          //fetch all the credentials in active/late renewal status and satisfying the below date conditions
          
          /*String renewalExpirationQuery='SELECT id, name, license__r.id, license__r.CE_Eligible__c, '+
                                        'license__r.CE_Hours__c, license__r.MUSW__Status__c, license__r.CE_Hours_Needed__c, '+
                                        'license__r.CE_Hours_per_Cycle__c, license__r.Renewal_Window__c, '+
                                        'license__r.MUSW__Expiration_Date__c, license__r.MUSW__Total_Balance__c, '+
                                        'license__r.Credential_Type__c, license__r.Credential__c '+
                                        'FROM Renewal_Application__c  '+
                                        'WHERE license__r.Renewal_Cycle_End_Date__c =< TODAY';*/
         String licenseExpirationQuery='SELECT id, MUSW__Status__c, CE_Hours__c, Renewal_Cycle_End_Date__c, CE_Hours_Per_Cycle__c, MUSW__Expiration_Date__c, Application_Type__c, Is_Late_Renewal_Eligible__c '+
                                        'FROM MUSW__License2__c  '+
                                        'WHERE (((Renewal_Cycle_End_Date__c >= TODAY) AND (MUSW__Expiration_Date__c < TODAY)) OR (Renewal_Cycle_End_Date__c < TODAY)) '+
             							'AND Credential__c IN  ('+'\'' +Label.CR_Manufactured_Homes_Installer +'\''+', '+'\''+Label.CR_Dwelling_Contractor_Qualifier+'\'' +') ';
          
        System.debug('query from final'+ licenseExpirationQuery);
          //call the next batch
        HandleIncompleteRenewalsExpirationBatch handleRenewalsExpirationBatch = new HandleIncompleteRenewalsExpirationBatch(licenseExpirationQuery); 
        try{
            database.executebatch(handleRenewalsExpirationBatch, Integer.valueOf(Label.Str_Batch_Execution_Limit));
        }
        catch(Exception e){
            //System.debug('test exception');
            ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'HandleIncompleteRenewals', 'final', 'Schedulable', 'HandleIncompleteRenewals', label.Str_Low);            
        }
      }
}