({
    hideAddRecord : function(component, event, helper) {
        var className = component.get('v.objectRecordType');
        className = className+'addRecord';
        var addRecord = document.getElementsByClassName(className);
        for (var i = 0; i < addRecord.length; ++i) {
            var item = addRecord[i];  
            item.classList.add('slds-hide');
        }
    },
    editRecordHelper : function(component, event, helper, editNo) {
        var rows = [];
        var outFields = [];
        outFields = document.getElementsByClassName(editNo+'showHide');
        for(var i = 0; i < outFields.length; ++i){
            var item = outFields[i];  
            item.classList.toggle('slds-hide');
        }
        
    },
    deleteRecordHelper : function(component, event, helper, editClassNo) {
        var action = component.get('c.deleteTableRecord');
        action.setParams({ recordId : editClassNo });
        action.setCallback(this,function(response){			
            var state = response.getState();
            if (state === "SUCCESS") {
                helper.setData(component, event, helper);
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Deleted",
                    "message": "The record was deleted.",
                    "type": "success"
                });
                resultsToast.fire();
            }
        });
        //helper.hideAddRecord(component, event, helper);
        
        $A.enqueueAction(action);
    },
    setData : function(component, event, helper) {
        
        if(component.get('v.sObj') != null) {
        var sectionName = component.get('v.sectionName');
        var obj = component.get('v.sObj');
        var recordTypeID = component.get('v.objectRecordType');
        var dataList;
       // var recordList =[];
        var sectionList = [];
        var appId = component.get("v.applicationId");
        var action = component.get('c.returnIds');
        var dataRows=[];
        var recordList =[];
        action.setParams({ applicationId : appId, ObjectName: obj, recordTypeID:recordTypeID});
        action.setCallback(this,function(response){
            
            var state = response.getState();
            if (state === "SUCCESS") {
                dataList = response.getReturnValue();
                var sectionList = component.get('v.sectionList');
                sectionList = sectionList.labelFieldsMap;
                
                for(var i=0;i<sectionList.length;i++){
                    if(sectionList[i].questionSectionClass== sectionName && sectionList[i].fieldObjName == 'LnP_BackgroundSection__c' && obj=='LnP_BackgroundSection__c'){
                        recordList.push({"fieldName": sectionList[i].fieldAPIName, "label": sectionList[i].label});
                    }
                    else if(sectionList[i].questionSectionClass== sectionName && sectionList[i].fieldObjName == 'Endorsement__c' && obj=='Endorsement__c'){
                        recordList.push({"fieldName": sectionList[i].fieldAPIName, "label": sectionList[i].label});
                    }
                }
                component.set('v.recordList', recordList);
                for(var i=0;i<dataList.length;i++){
                    dataRows.push({"id": dataList[i].Id, "fields": recordList});
                }
                component.set('v.dataRows', dataRows);
            }
        });
        $A.enqueueAction(action);
    }
    }
})