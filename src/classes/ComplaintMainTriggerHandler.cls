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
        
    }
    public void AfterUndelete(Map<Id, SObject> oldItems) {
    }
    
    public void AfterUpdate(Map<Id, SObject> newItems, Map<Id,SObject> oldItems) {
    	countComplaintsOnEachLicense((List<MUSW__Complaint2__c>)newItems.values(), (Map<id,MUSW__Complaint2__c>)oldItems);
    }
    public void countComplaintsOnEachLicense(List<MUSW__Complaint2__c> newItems, Map<Id, MUSW__Complaint2__c> oldMap){
        Set<ID> licenseIds = new Set<ID>();
        List<MUSW__License2__c> licenseToUpdateList = new List<MUSW__License2__c>();
        Map<Id,Decimal> noOfComplaintForEachLicenseMap = new map<Id,Decimal>();
        for(MUSW__Complaint2__c complaintObj : newItems){
            if(Trigger.isInsert || Trigger.isDelete|| (Trigger.isUpdate && oldMap!= null && oldMap.containsKey(complaintObj.id) && oldMap.get(complaintObj.id).MUSW__Status__c != complaintObj.MUSW__Status__c)){
                if(complaintObj.License__c != null){
                    licenseIds.add(complaintObj.License__c);
            	}
            }
        }
        if(!licenseIds.isEmpty()){
            List<AggregateResult> aggComplaintObj = [select Count(id) compCount, License__c from MUSW__Complaint2__c where MUSW__Status__c !='Closed'and License__c IN:licenseIds group by License__c ];
        	System.debug('###aggComplaintObj###'+aggComplaintObj);
        	for(AggregateResult aggResObj: aggComplaintObj){
            	noOfComplaintForEachLicenseMap.put((id)aggResObj.get('License__c'),(Decimal)aggResObj.get('compCount'));
            }
        }
        for(ID licId :licenseIds){
            MUSW__License2__c licenseObj = new MUSW__License2__c();
            if(noOfComplaintForEachLicenseMap.containsKey(licId) && noOfComplaintForEachLicenseMap.values()!= null){
                licenseObj.id = licId;
                licenseObj.Open_Complaints__c = noOfComplaintForEachLicenseMap.get(licId);
                licenseToUpdateList.add(licenseObj);
             }
            else{
                licenseObj.id = licId;
                licenseObj.Open_Complaints__c = 0;
                licenseToUpdateList.add(licenseObj);
            }
        }
        try{
            Utilityclass_withoutsharing.updateList(licenseToUpdateList);
        }Catch(Exception ex){
            Polaris_CreateErrorLog_Exception.addError(ex,'Error in Updating License','on Complaint object');
        } 
    }
}