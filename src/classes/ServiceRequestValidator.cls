public class ServiceRequestValidator {
    
    public static ValidationError validate(ValidationError e, sObject newRec){
    	MUSW__Application2__c serviceReq = (MUSW__Application2__c) newRec;
    	
        String query ='';
        query = 'Select Name From Application_Field__c where Required__c = true and Object_Name__c = \'Main Object\' and ' + 
            ' Parent__r.Parent__r.Parent__r.Service_Request_Type__c = \'' + serviceReq.MUSW__Type__c + '\' and Service_Request__c = true';
        
        System.debug('query '+query);
        List<Application_Field__c> lstRequiredFields = Database.query(query);
        Set<String> setRequiredFields = new Set<String>();
        for(Application_Field__c reqField : lstRequiredFields){
            setRequiredFields.add(reqField.Name);
        }
        system.debug(setRequiredFields);
        
        for(String requiredField : setRequiredFields){
            if(serviceReq.get(requiredField) == null || serviceReq.get(requiredField) == ''){
                e.addError(requiredField, 'You must enter a value.');
            }
        }
        
        if(serviceReq.MUSW__Type__c == 'Relinquish Delegated Agent Status'){
        	if(serviceReq.Requested_Effective_Date__c != null && serviceReq.Requested_Effective_Date__c < (Date.today() + 30)){
        		e.addError('Requested_Effective_Date__c', 'The Requested Effective Date should be at least 30 days in the future.');
        	}
        }
        
        return e;
    }
}