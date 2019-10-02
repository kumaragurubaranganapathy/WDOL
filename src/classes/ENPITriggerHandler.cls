/**
* @author Sandeep Mahankali
* @date 09-25-2019
*
* 
*
* @description Trigger Handler on Endorsement object to check whether Electronic Notary Provider Information records exists or not.
*/



public class ENPITriggerHandler {
    
    public static void handlerIsRecordExists(List<Electronic_Notary_Provider_Information__c> triggerNew, List<Electronic_Notary_Provider_Information__c> triggerOld){
        set<id> endorsementIds = new set<id>();
        List<Electronic_Notary_Provider_Information__c> recs = new List<Electronic_Notary_Provider_Information__c>();
        if(trigger.isDelete){
            recs = triggerOld;            
        }else{
            recs = triggerNew;
        }
        for(Electronic_Notary_Provider_Information__c enpi: recs){
            if(enpi.Endorsement__c != null){
                endorsementIds.add(enpi.Endorsement__c );
            }
        }
        if(endorsementIds.size() > 0){
            map<id, Endorsement__c> EndorsementToUpdate = new map<id,Endorsement__c>();
            for(Id i :endorsementIds ){
                EndorsementToUpdate.put(i,new Endorsement__c(Id=i,Is_Record_Exists__c = false));
            }
            for(AggregateResult ar : [select count(id) c,Endorsement__c from Electronic_Notary_Provider_Information__c where Endorsement__c=:endorsementIds group by Endorsement__c ]){
                string recId = (string) ar.get('Endorsement__c');
                if(ar.get('c') != null){
                    Integer cnt = Integer.valueOF(ar.get('c'));
                    if(cnt > 0){
                        EndorsementToUpdate.put(recId,new Endorsement__c(Id=recId,Is_Record_Exists__c = true));
                    }
                }
            }
            update EndorsementToUpdate.values();
        }
    }
    
}