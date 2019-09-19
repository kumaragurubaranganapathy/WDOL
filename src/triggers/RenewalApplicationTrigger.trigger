trigger RenewalApplicationTrigger on Renewal_Application__c (before update,after update) {
 if(Trigger.isUpdate && Trigger.isBefore ){
       System.debug('Trigger inInsert');
       Map<Id,Boolean> autoReneMap = new Map<Id,Boolean>();
       List<Renewal_Application__c> renewList = new List<Renewal_Application__c>();
       for(Renewal_Application__c renewal : trigger.new){
           System.debug('renewal:: '+renewal.Renewal_Status__c );
           if(renewal.Renewal_Status__c == 'In-Review'){
               renewList.add(renewal);
           }
       }
       if(!renewList.isEmpty()){
           autoReneMap = renewalReinstatement.autoRenewReinstatement(renewList);
       }
       for(Renewal_Application__c rene : Trigger.new){
           if(autoReneMap.keyset().contains(rene.id)){
               rene.Auto_Renew__c = autoReneMap.get(rene.id);
               //rene.Renewal_Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Complete';
               
           }
       
       }
       }
       
    if(Trigger.isUpdate && Trigger.isAfter ){
         Set<Id> setId = new Set<Id>();
         List<MUSW__Review__c> reviewList = new List<MUSW__Review__c >();
         for(Renewal_Application__c renewreinstate :trigger.new){
            if(renewreinstate.Renewal_Status__c == 'In-Review' && renewreinstate.Auto_Renew__c == true){
                setId.add(renewreinstate.id);
             }
         }
         for(MUSW__Review__c rev : [select id,MUSW__Status__c from MUSW__Review__c where Renewal_Application__c IN:setId and MUSW__Status__c=: DOL_AppConstants.NULL_EMPTY_STRING + 'Pending' and MUSW__Status__c != null and Renewal_Application__c != null]){
            rev.MUSW__Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Approved';
            reviewList.add(rev);
         }
         if(!reviewList.isEmpty()){
                update reviewList;
         }
    }

}
