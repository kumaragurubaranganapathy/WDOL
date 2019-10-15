@isTest
public class ParcelTriggerHandler_Test {
    
    @isTest
    public static void testonBeforeDelete(){
        ParcelTriggerHandler parcelTriggerHandler = new ParcelTriggerHandler();
        parcelTriggerHandler.onBeforeDelete();
    }
    
    @isTest
    public static void testonBeforeUndelete(){
        ParcelTriggerHandler parcelTriggerHandler = new ParcelTriggerHandler();
        parcelTriggerHandler.onBeforeUndelete();
    }
    
    @isTest
    public static void testonAfterDelete(){
        ParcelTriggerHandler parcelTriggerHandler = new ParcelTriggerHandler();
        parcelTriggerHandler.onAfterDelete();
    }
    
    @isTest
    public static void testonAfterUndelete(){
        ParcelTriggerHandler parcelTriggerHandler = new ParcelTriggerHandler();
        parcelTriggerHandler.onAfterUndelete();
    }
    
    @isTest
    public static void testBypassTrigger(){
        Id recTypeId = Schema.SObjectType.MUSW__Parcel__c.getRecordTypeInfosByName().get('Address').getRecordTypeId();
        Global_Settings__c globalSetting = DOL_TestDataFactory.createGlobalSetting(UserInfo.getUsername(),true);
        ParcelTriggerHandler parcelTriggerHandler = new ParcelTriggerHandler();
        MUSW__Parcel__c par = DOL_TestDataFactory.createParcel(recTypeId);
    }
    
    @isTest
    public static void insertParcel(){
        Id recTypeId = Schema.SObjectType.MUSW__Parcel__c.getRecordTypeInfosByName().get('Address').getRecordTypeId();
        MUSW__Parcel__c par = DOL_TestDataFactory.createParcel(recTypeId);
    }
    
    @isTest
    public static void updateParcel(){
        Id recTypeId = Schema.SObjectType.MUSW__Parcel__c.getRecordTypeInfosByName().get('Address').getRecordTypeId();
        MUSW__Parcel__c par = DOL_TestDataFactory.createParcel(recTypeId);
        par.International_Address__c = DOL_AppConstants.NULL_EMPTY_STRING + '456 Street';
        update par;
    }
}