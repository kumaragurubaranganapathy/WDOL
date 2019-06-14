/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class WorkItemVO {
    global String category {
        get;
    }
    global String displayName {
        get;
    }
    global List<MUSW.LightningUIService.UIFieldInfo> fields {
        get;
    }
    global Boolean isAggregate {
        get;
    }
    global Boolean isTemplate {
        get;
    }
    global Id masterWorkItemId {
        get;
        set;
    }
    global List<Id> masterWorkItemIds {
        get;
        set;
    }
    global String subCategory {
        get;
    }
    global List<MUSW__Work_Item__c> workItem {
        get;
    }
    global WorkItemVO(MUSW__Work_Item__c workItem, List<MUSW.LightningUIService.UIFieldInfo> fields, Boolean isTemplate) {

    }
    global WorkItemVO(List<MUSW__Work_Item__c> workItems, List<MUSW.LightningUIService.UIFieldInfo> fields, String category, String subCategory, Boolean isTemplate) {

    }
}
