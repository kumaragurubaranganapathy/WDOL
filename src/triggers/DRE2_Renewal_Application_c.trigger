trigger DRE2_Renewal_Application_c on Renewal_Application__c (after insert, before update,after update, before delete, after undelete) { BGCM.TriggerManager.execute('DRE2_Renewal_Application_c', new DRETriggerHandler());
    if(Trigger.isUpdate && Trigger.isAfter){
        List<Renewal_Application__c> triggerNew = Trigger.New;
        List<Id> licenseList = new List<Id>();
        for(Renewal_Application__c renlic : triggerNew ){
            if(renlic.Total_Balance__c == 0 && renlic.Renewal_Status__c == 'Pending Payment'){
                  licenseList.add(renlic.id);
            }
        
        } 
        if(!licenseList.isEmpty()){
           RenewalReinstatement.createReviewOnRenewal(licenseList);
        } 
         
    }
 }