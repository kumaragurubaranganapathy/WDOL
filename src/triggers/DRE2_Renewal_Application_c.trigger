trigger DRE2_Renewal_Application_c on Renewal_Application__c (after insert, before update, before delete, after undelete) { BGCM.TriggerManager.execute('DRE2_Renewal_Application_c', new DRETriggerHandler());
     if(Trigger.isUpdate && Trigger.isBefore ){
       System.debug('Trigger inInsert');
       Map<Id,Boolean> autoReneMap = new Map<Id,Boolean>();
       List<Renewal_Application__c> renewList = new List<Renewal_Application__c>();
       for(Renewal_Application__c renewal : trigger.new){
           System.debug('renewal:: '+renewal.Renewal_Status__c );
           if(renewal.Renewal_Status__c == 'In-Review' && renewal.License__r.MUSW__Primary_Licensee__r.Account_Status__c == 'Active'){
               renewList.add(renewal);
           }
       }
       if(!renewList.isEmpty()){
           autoReneMap = renewalReinstatement.autoRenewReinstatement(renewList);
       }
       for(Renewal_Application__c rene : Trigger.new){
           if(autoReneMap.keyset().contains(rene.id)){
               rene.Auto_Renew__c = autoReneMap.get(rene.id);
               rene.Renewal_Status__c = 'Complete';
               
           }
       
       }
       }
       
    if(Trigger.isUpdate && Trigger.isAfter ){
         Set<Id> setId = new Set<Id>();
         List<MUSW__Review__c> reviewList = new List<MUSW__Review__c >();
         for(Renewal_Application__c renewreinstate :trigger.new){
            if(renewreinstate.Renewal_Status__c == 'Complete' && renewreinstate.Auto_Renew__c == true){
                setId.add(renewreinstate.id);
             }
         }
         for(MUSW__Review__c rev : [select id,MUSW__Status__c from MUSW__Review__c where Renewal_Application__c IN:setId and MUSW__Status__c='Pending']){
            rev.MUSW__Status__c = 'Approved';
            reviewList.add(rev);
         }
         if(!reviewList.isEmpty()){
                update reviewList;
         }
   
   
   } 
 }