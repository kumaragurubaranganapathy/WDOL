/**
* Name: ClassTriggerHandler
* Type: Class
* Description: Trigger Handler for ClassTrigger on Classes__c
* Date:        Developer/Company                   Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 08/23/2018   Sharad Maheshwari/Deloitte          Initial Creation
**/
public class ClassTriggerHandler  implements BGCM.ITriggerHandler  {
    public static user u;
    public ClassTriggerHandler() {
        u = [Select Id, UserType, Is_Portal_User__c From User where Id = :UserInfo.getUserId()];
    }
    public void onAfterDelete() {
        System.debug('After Delete');        
    }
    public void onAfterInsert() { 
        System.debug('After Insert');
    }
    public void onAfterUndelete() {}
    public void onAfterUpdate() {
        System.debug('After update');
    }
    public void onBeforeDelete() {}
    public void onBeforeInsert() {
        System.debug('()()()before insert');        
        beforeMethod();
    }
    public void onBeforeUndelete() {}
    public void onBeforeUpdate() {
        System.debug('before update');
    }
    
    
    public void beforeMethod(){
        
        System.debug('testing bulk upload of classes');
        List<Classes__c> triggerNewClasses = Trigger.New;
        System.debug('triggerNewClasses '+triggerNewClasses);
        Set<ID> credentialIDSet = new Set<ID>();
        MUSW__license2__c credentialToUpdate;
        
        for(integer i = 0; i< triggerNewClasses.size(); i++){
            if(triggerNewClasses[i].CE_Status__c == 'New'){   
            if(!credentialIDSet.contains(triggerNewClasses[i].Credential__c)){  
                credentialIDSet.add(triggerNewClasses[i].Credential__c);
                
            }
        }else if(triggerNewClasses[i].CE_Status__c == 'Applied'){
                //users trying to save class record with Applied status should not be allowed to do so
                triggerNewClasses[i].addError(Label.Str_Class_status_cannot_be_Applied);
                
            }
        }
        System.debug('credentialIDSet '+credentialIDSet);
        System.debug('before credentialList query');
        List<MUSW__License2__c> credentialList = [SELECT id, 
                                                  CE_Hours__c, 
                                                  Renewal_Cycle_End_Date__c, 
                                                  Renewal_window__c, 
                                                  MUSW__Expiration_Date__c,
                                                  (SELECT id, CE_Hours__c
                                                   FROM renewal_applications__r 
                                                   WHERE Renewal_Status__c = :Label.ST_Submitted 
                                                   LIMIT 1)           
                                                  FROM MUSW__license2__c
                                                  WHERE ID IN :credentialIDSet
                                                 ];
        System.debug('After credentialList query');
        List<Renewal_Application__c> renewalsToUpdateList = new List<Renewal_Application__c>();
        List<MUSW__License2__c> credentialsToUpdateList = new List<MUSW__License2__c>();
        Map<ID, Renewal_Application__c> renewalsToUpdateMap = new Map<ID, Renewal_Application__c>();
        Map<Id, MUSW__License2__c> credentialsToUpdateMap = new Map<ID, MUSW__License2__c>();
        Renewal_Application__c renewal;
        for(MUSW__License2__c credentialRecord: credentialList){
            for(integer j =0; j<triggerNewClasses.size(); j++){
                if((credentialRecord.Id == triggerNewClasses[j].Credential__c) && (triggerNewClasses[j].CE_Status__c == 'New')){
                    if(credentialRecord.MUSW__Expiration_Date__c != null){
                    Date credentialExpirationDate = credentialRecord.MUSW__Expiration_Date__c;
                    
                    System.debug('credentialExpirationDate '+credentialExpirationDate);
                    integer newYear = credentialExpirationDate.year() - (Integer)credentialRecord.Renewal_window__c;
                    System.debug('newYear '+newYear);
                    Date previousReviewCycleDate = date.newinstance(newYear, 
                                                                    credentialExpirationDate.month(), 
                                                                    credentialExpirationDate.day());
                    System.debug('previousReviewCycleDate '+previousReviewCycleDate);
                    if((triggerNewClasses[j].End_Date_Time__c > previousReviewCycleDate) && 
                       (triggerNewClasses[j].End_Date_Time__c <= credentialRecord.Renewal_Cycle_End_Date__c)){
                           if(credentialRecord.renewal_applications__r.size()>0){
                               System.debug('has renewal records');
                               for(Renewal_Application__c renewalRecord: credentialRecord.renewal_applications__r){
                                   if(renewalsToUpdateMap.containsKey(renewalRecord.Id)){
                                       Renewal_Application__c existingRenewal = renewalsToUpdateMap.get(renewalRecord.Id);
                                       renewal = new Renewal_Application__c(Id = renewalRecord.id,
                                                                            CE_Hours__c = existingRenewal.CE_Hours__c + triggerNewClasses[j].Hours__c);
                                       
                                       renewalsToUpdateMap.put(renewalRecord.id, renewal);
                                       
                                   }else{
                                       Decimal temp = renewalRecord.CE_Hours__C;
                                   if (temp == null){
                                       temp = 0.0;
                                   }
                                       renewal = new Renewal_Application__c(Id = renewalRecord.id,
                                                                            CE_Hours__c = temp + triggerNewClasses[j].Hours__c);
                                       renewalsToUpdateMap.put(renewalRecord.id, renewal);
                                       
                                   }
                                   
                                   
                               }
                               
                           }else{
                               
                               System.debug('DOES NOT have renewal records');
                               if(credentialsToUpdateMap.containsKey(credentialRecord.Id)){
                                   System.debug('id already exists');
                                   MUSW__License2__c existingCredential = credentialsToUpdateMap.get(credentialRecord.Id);
                                   credentialToUpdate = new MUSW__License2__c(Id = credentialRecord.Id,
                                                                              CE_Hours__C = existingCredential.CE_Hours__C + triggerNewClasses[j].Hours__c);
                                   credentialsToUpdateMap.put(credentialRecord.Id, credentialToUpdate);
                               }
                               else{
                                   System.debug('credentialRecord '+credentialRecord);
                                   Decimal temp = credentialRecord.CE_Hours__C;
                                   if (temp == null){
                                       temp = 0.0;
                                   }
                                   System.debug('triggerNewClasses[j] '+ triggerNewClasses[j]);
                                   credentialToUpdate = new MUSW__License2__c(Id = credentialRecord.Id,
                                                                              CE_Hours__C = temp + triggerNewClasses[j].Hours__c);
                                   credentialsToUpdateMap.put(credentialRecord.Id, credentialToUpdate);
                                   
                               }
                           }
                           
                       }
                    System.debug('before setting the status to applied ');
                    triggerNewClasses[j].CE_Status__c = 'Applied';
                    System.debug('after setting the status to applied ');
                    }else{
                        
                        //credential expiration date is null- addError message here
                        triggerNewClasses[j].addError(Label.Str_Expiration_date_cannot_be_blank);
                    }
                }
                
            }
            
        }
        
        if(credentialsToUpdateMap.size() > 0){
            System.debug('lic records in map');
            for (MUSW__License2__c licRecord: credentialsToUpdateMap.values()){
                system.debug('licRecord '+licRecord);
                credentialsToUpdateList.add(licRecord);
            }
            System.debug('credentialsToUpdateList'+credentialsToUpdateList);
            update credentialsToUpdateList;
        }
        if(renewalsToUpdateMap.size() > 0){
            System.debug('renewal records in map');
            for (Renewal_Application__c renRecord: renewalsToUpdateMap.values()){
                system.debug('renRecord '+renRecord);
                renewalsToUpdateList.add(renRecord);
            }
            System.debug('renewalsToUpdateList'+renewalsToUpdateList);
            update renewalsToUpdateList;
        }
    }
}