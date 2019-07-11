public class ComplaintMainTriggerHandler implements ITriggerHandler {
    public static Boolean TriggerDisabled = false;
    public Boolean IsDisabled(){
        return TriggerDisabled;
    }
    public void BeforeInsert(List<SObject> lstItems) {
    }
    public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
    }
    public void BeforeDelete(Map<Id, SObject> oldItems) {
    }
    
    public void AfterInsert(List<SObject> newItems) {
        countComplaintsOnEachLicense(newItems,null);
    }
    public void AfterInsert(Map<Id, SObject> newItems){
        
    }
                            
    public void AfterDelete(Map<Id, SObject> oldItems) {
        countComplaintsOnEachLicense(null, (Map<id,MUSW__Complaint2__c>)oldItems);
    }
    public void AfterUndelete(Map<Id, SObject> oldItems) {
    }
    
    public void AfterUpdate(Map<Id, SObject> newItems, Map<Id,SObject> oldItems) {
    	countComplaintsOnEachLicense((List<MUSW__Complaint2__c>)newItems.values(), (Map<id,MUSW__Complaint2__c>)oldItems);
    }
    public void countComplaintsOnEachLicense(List<MUSW__Complaint2__c> newItems, Map<Id, MUSW__Complaint2__c> oldMap){
        Set<ID> licenseIds = new Set<ID>();
        for(MUSW__Complaint2__c complaintObj : newItems){
            if(Trigger.isInsert || Trigger.isDelete|| (Trigger.isUpdate && oldMap!= null && oldMap.containsKey(complaintObj.id) && oldMap.get(complaintObj.id).MUSW__Status__c != complaintObj.MUSW__Status__c)){
                if(complaintObj.License__c != null){
                	licenseIds.add(complaintObj.License__c);
            	}
            }
        }
        List<AggregateResult> aggComplaintObj = [select Count(id) compCount, License__c from MUSW__Complaint2__c where MUSW__Status__c !='Closed'and License__c IN:licenseIds group by License__c ];
        List<MUSW__License2__c> licenseToUpdateList = new List<MUSW__License2__c>();
        for(AggregateResult aggResObj: aggComplaintObj){
            MUSW__License2__c licenseObj = new MUSW__License2__c();
            licenseObj.id = (id)aggResObj.get('License__c');
            licenseObj.Open_Complaints__c = (decimal)aggResObj.get('compCount');
            licenseToUpdateList.add(licenseObj);
        }
        try{
        	Utilityclass_withoutsharing.updateList(licenseToUpdateList);
        }Catch(Exception ex){
            Polaris_CreateErrorLog_Exception.addError(ex,'Error in Updating License','on Complaint object');
        }
    }
}