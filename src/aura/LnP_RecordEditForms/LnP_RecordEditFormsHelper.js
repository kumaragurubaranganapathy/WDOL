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
            console.log('flowType:' + component.get("v.flowType"));
            console.log('Record Id==' + recordTypeID + 'applicationId==' + appId + 'ObjectName== ' + obj);
            action.setParams({ applicationId : appId, ObjectName: obj, recordTypeID:recordTypeID,flowType:component.get("v.flowType")});
            action.setCallback(this,function(response){
                
                var state = response.getState();
                if (state === "SUCCESS") {
                    dataList = response.getReturnValue();
                    var sectionList = component.get('v.sectionList');
                    sectionList = sectionList.labelFieldsMap;
                    
                    for(var i=0;i<sectionList.length;i++){
                        if(sectionList[i].questionSectionClass== sectionName && sectionList[i].fieldObjName == 'LnP_BackgroundSection__c' && obj=='LnP_BackgroundSection__c'){
                            recordList.push({"fieldName": sectionList[i].fieldAPIName, "label": sectionList[i].label, "required":sectionList[i].isMandatoryQues, "regex":sectionList[i].regex, "error":sectionList[i].errormsg});
                        }
                        else if(sectionList[i].questionSectionClass== sectionName && sectionList[i].fieldObjName == 'Endorsement__c' && obj=='Endorsement__c'){
                            recordList.push({"fieldName": sectionList[i].fieldAPIName, "label": sectionList[i].label});
                        }
                            else if(sectionList[i].questionSectionClass== sectionName && sectionList[i].fieldObjName == 'Electronic_Notary_Provider_Information__c' && obj=='Electronic_Notary_Provider_Information__c'){
                                recordList.push({"fieldName": sectionList[i].fieldAPIName, "label": sectionList[i].label});
                            }
                                else if(sectionList[i].questionSectionClass== sectionName && sectionList[i].fieldObjName == 'Education_History__c' && obj=='Education_History__c'){
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
    },
    
    getLicenseData:function(component, event, helper){
        var action = component.get("c.updateEducationHistoryRecord");
        action.setParams({'educationHistoryRecordId': component.get("v.educationHistoryId"),
                          'requestId': component.get("v.applicationId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var educationHistoryRecordDetails = response.getReturnValue();
                console.log('educationHistoryRecordDetails=' + educationHistoryRecordDetails);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                console.error(JSON.stringify(errors));
            }
        });
        $A.enqueueAction(action);
        
    },
    inputClick : function(component,event){        
        var currentValue;
        /*var outFields = component.find("outputEditfield");
        var endDateField;
        outFields.forEach(function(elem){
            if(elem.get("v.fieldName"==="End_date__c"))
                endDateField = elem;
        }); */
        
        var currElem = event.getSource();
        if(currElem.get("v.fieldName")==="Current__c"){
            currentValue = currElem.get("v.value");
            component.set("v.currentValue",currentValue);            
        }      
        
    },
    inputEditClick : function(component,event){        
        var currElem = event.getSource();
        
        //var inputFields = component.find("inputEditField");
        var currentValue;
        var cardIndex; 
        var cardClass;
        if(currElem.get("v.fieldName")==="Current__c"){
            currentValue = currElem.get("v.value"); 
            cardClass = currElem.get("v.class");
            cardIndex = parseInt(cardClass.split("itemRow=")[1]);
            component.set("v.currentEditValue",currentValue);
            component.set("v.cardIndex",cardIndex);            
        }
        /*inputFields.forEach(function(elem){
            var fieldName = elem.get("v.fieldName");
            if(fieldName==="Current__c"){
                currentValue = elem.get("v.value");               
            }                         
            if(fieldName==="End_date__c"&&currentValue)
                $A.util.addClass(elem,'slds-hide');            
            else if(fieldName==="End_date__c"&&!currentValue)
                $A.util.removeClass(elem,'slds-hide');            
        }); */
        
    }
})