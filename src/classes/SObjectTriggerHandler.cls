/**
* Name: SObjectTriggerHandler
* Type: Class
* Description: Trigger Handler for  objects.
* Date:        Developer/Company                 	Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 06/1/2018   Akosa Okwudiafor/Deloitte           Initial Creation
**/
public class SObjectTriggerHandler {
    
    //list of valid actions that this trigger can handle
    public enum Action {BeforeInsert, BeforeUpdate}    
    private SObject[] newRecs;
    private Map<Id, SObject> oldRecordMap;
    private Action a;
    
    /**
* constructor
* @arg newRecs - the Trigger.new
* @arg a - the type of action that fired the trigger
*/
    public SObjectTriggerHandler(SObject[] newRecs,Action a) {
        this.newRecs = newRecs;
        this.a = a;
    }
    
    /**
* constructor
* @arg newRecs - the Trigger.new
* @arg oldRecs - the Trigger.old
* @arg a - the type of action that fired the trigger
*/    
    public SObjectTriggerHandler(SObject[] newRecs, Map<Id, SObject> oldRecordMap,Action a) {
        this(newRecs, a);
        this.oldRecordMap = oldRecordMap;        
    }  
    
    private BaseValidator.ApplicationObjectType getObjectType(SObject sObj) {
        if ( Schema.MUSW__License2__c.getSObjectType() == sObj.getSObjectType() ) { return BaseValidator.ApplicationObjectType.LICENSE; }
        if ( Schema.Renewal_Application__c.getSObjectType() == sObj.getSObjectType() ) { return BaseValidator.ApplicationObjectType.RENEWAL; }
        if ( Schema.MUSW__Permit2__c.getSObjectType() == sObj.getSObjectType() ) { return BaseValidator.ApplicationObjectType.PERMIT; }
        return null;
    }
    
    private String getRecordStatus(SObject sObj){
        String status = '';        
        BaseValidator.ApplicationObjectType objectType = getObjectType(sObj);
        if(objectType == BaseValidator.ApplicationObjectType.LICENSE){
            status = (String)sObj.get(label.Api_Musw_Status);
        }else if(objectType == BaseValidator.ApplicationObjectType.RENEWAL){
            status = (String)sObj.get(label.API_Renewal_Status);
        }else if(objectType == BaseValidator.ApplicationObjectType.PERMIT){
            status = (String)sObj.get(Label.Api_Musw_Status);
        }        
        System.debug(status);
        return status;
    }
    
    /**
* logic for the trigger handler
*/
    public void process() {
        // 1. run validation
        if ( Action.BeforeInsert == a || Action.BeforeUpdate == a) {   
            BaseValidator v;
            try {
                for( SObject sObj : newRecs ) {
                    Decimal secNum = (Decimal)sObj.get(label.API_SectionNumber);
                    if ( secNum == 99 ) {
                        String status = getRecordStatus(sObj); 
                        if(status == label.ST_Pending || status == label.ST_Incomplete || status == label.ST_Generate_Fee){
                            v = BaseValidator.createValidator(this.getObjectType(sObj),getRecordTypeNameForId(sObj, String.valueOf(sObj.get(label.Str_RecordTypeId))));                            
                            // note: during an insert, the oldmap is null
                            SObject oldObj;
                            if ( oldRecordMap != null ) {
                                oldObj = oldRecordMap.get( (Id)sObj.get('id') );
                            }
                            else {
                                oldObj = sObj.getSObjectType().newSObject();
                            }
                            if (sObj.get(label.API_Business_License) == false){
                                v.validateContact(this.getObjectType(sObj), sObj); 
                            }
                            else {
                                v.validateAccount(this.getObjectType(sObj), sObj);
                            }
                            System.debug('validateAddress');
                            v.validateAddress(this.getObjectType(sObj), sObj);
                            System.debug('validateAddress');
                            v.validate(sObj, oldObj);
                        }
                    }
                }
            }
            catch(Exception e) {                             
                System.debug('---> Exception in SObjectTriggerHandler.process()' + e.getMessage() + ' - line:' + e.getLineNumber());
            }
        }   
    }   
    
    /**
* return the recordTypeName for a given recordTypeId
* @param String sObjectName - the sObject to look for the record type
* @param Id recordTypeId - the specific record type id
* TODO: move to a Utility class
*/
    public String getRecordTypeNameForId(SObject sObj, Id recordTypeId) {
        Map<Id, Schema.RecordTypeInfo> rtMap;
        if ( Schema.MUSW__License2__c.getSObjectType() == sObj.getSObjectType() ) {
            rtMap = Schema.getGlobalDescribe().get(label.API_License2).getDescribe().getRecordTypeInfosById();
            System.debug('---> map:' + rtMap);
        }
        if ( Schema.Renewal_Application__c.getSObjectType() == sObj.getSObjectType() ) {
            rtMap = Schema.getGlobalDescribe().get(label.API_Renewal_Application).getDescribe().getRecordTypeInfosById();
            System.debug('---> map:' + rtMap);
        }        
        if ( Schema.MUSW__Permit2__c.getSObjectType() == sObj.getSObjectType() ) {
            rtMap = Schema.getGlobalDescribe().get(label.API_Permit).getDescribe().getRecordTypeInfosById();
            System.debug('---> map:' + rtMap);
        }                
        return rtMap.get(recordTypeId).getName();
    }    
    
}