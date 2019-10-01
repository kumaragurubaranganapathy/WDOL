({
    onSuccess : function(component, event, helper) {
       //debugger
        var serverCall = component.get("c.saveLicenseandReceipt");
        serverCall.setParams({"receiptId" : component.get("v.recordId")});
        serverCall.setCallback(this,function(serverResponse){
            var State = serverResponse.getState();
            if(State === 'SUCCESS'){              
                //console.log("serverResponse" + JSON.stringify(serverResponse.getReturnValue()));
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "The record has been Saved successfully."
                });
                toastEvent.fire();
                $A.get("e.force:closeQuickAction").fire(); 
            }else{
                //alert(State);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type":"error",
                    "message": "State : "+State + ". Record saving failed"
                });
                toastEvent.fire();
                $A.get("e.force:closeQuickAction").fire();
            }
        });
        $A.enqueueAction(serverCall);
        
        //component.find("recordViewForm").set("v.mode","readonly");
        
    },
    onSubmit : function(component, event, helper) {
        
        /*    var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "type":"success",
            "message": "The record has been Saved successfully."
        });
        toastEvent.fire();*/
    },
    onLoad : function(component, event, helper) {
        //debugger
        var objectInfo = event.getParams().objectInfos;
        //alert(JSON.stringify(event.getParams("fields").records[component.get("v.recordId")].fields.Name.value));
        var _Name = event.getParams("fields").records[component.get("v.recordId")].fields.Name.value;
        var _DHP__c = event.getParams("fields").records[component.get("v.recordId")].fields.DHP__c.value;
        var _Inactivate_License_Date__c = event.getParams("fields").records[component.get("v.recordId")].fields.Inactivate_License_Date__c.value;
        var _Override_25_Handling_Fee__c = event.getParams("fields").records[component.get("v.recordId")].fields.Override_25_Handling_Fee__c.value;
        var _Reason_for_DHP__c = event.getParams("fields").records[component.get("v.recordId")].fields.Reason_for_DHP__c.value;
        if(_DHP__c === true  &&  _Inactivate_License_Date__c !== null ){
            component.find("recordViewForm").set("v.mode","readonly");
        }else{
            console.log("success");
        }
        /* if(_Name){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Loaded!",
                "type":"success",
                "message": "The record has been Loaded successfully ."  
            });
            toastEvent.fire();
        } */
        
    },
    onError : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "type":"error",
            "message": "Error."
        });
        toastEvent.fire();
    }
    
    
})