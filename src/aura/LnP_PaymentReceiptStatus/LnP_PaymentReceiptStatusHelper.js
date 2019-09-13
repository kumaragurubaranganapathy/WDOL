({
    showToast : function(component, event, title, type, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type":type
        });
        toastEvent.fire();
    },
    doInit : function(component, event, helper) {
        component.set("v.Spinner", true);
        var action = component.get("c.getPmtInitialTotals");
        action.setCallback(this, function(response) {
            component.set("v.Spinner", false);
            var state = response.getState();
            if (state === 'SUCCESS'){
                var responseValues = response.getReturnValue();
                console.log('responseValues:'+responseValues);
                var mapList = [];
                if(responseValues != ''){
                    for ( var key in responseValues ) {
                        mapList.push({value:responseValues[key], key:key});
                    }
                    component.set('v.totalAmountMap',mapList);
                    //component.set("v.displayTotalAmount",true); 
                } else {
                    //component.set("v.displayTotalAmount",false); 
                    var errorMessage = 'There is an error while loading total amounts.';
                    helper.showToast(component, event, "Error", "error", errorMessage);
                }
            } else {
                // show error message and close button
                if (state === 'ERROR') {
                    var error = response.getError();
                    
                    // try finding a useful error message
                    if (error && error[0] && error[0].message) {
                        message = error[0].message;
                        console.error('error.message=='+message);
                    }
                }
                helper.showToast(component, event, "Error", "error", message);
            }
        });
        $A.enqueueAction(action);
    },
    hideUnHideCreditCards : function(component, event, helper) {
        var ccCheck =   component.find("ccCheckId").get("v.checked");
        var achCheck = component.find("achCheckId").get("v.checked");
        if(ccCheck != null && ccCheck != undefined && ccCheck == true){
            component.set("v.displayCreditCard",true);
            component.find("amexCheckId").set("v.checked",true);
            component.find("masterCheckId").set("v.checked",true);
            component.find("visaCheckId").set("v.checked",true);
            component.find("discoverCheckId").set("v.checked",true); 
        }else if(achCheck != null && achCheck != undefined && achCheck == true){
            component.set("v.displayCreditCard",false);
            component.find("amexCheckId").set("v.checked",false);
            component.find("masterCheckId").set("v.checked",false);
            component.find("visaCheckId").set("v.checked",false);
            component.find("discoverCheckId").set("v.checked",false);
            //component.set("v.displayTotalAmount",true);
        }else{
            component.set("v.displayCreditCard",false);
            component.find("amexCheckId").set("v.checked",false);
            component.find("masterCheckId").set("v.checked",false);
            component.find("visaCheckId").set("v.checked",false);
            component.find("discoverCheckId").set("v.checked",false);
            //component.set("v.displayTotalAmount",false);  
        }
	},
    displayTotalAmounts : function(component, event, helper) {
        var selectedDate = component.get("v.processDate");
        var pmtParameter = helper.getPaymentCheckParameter(component, event, helper);
        var isPaymentTypeChecked = helper.isPaymentTypeChecked(component, event, helper);
       if(isPaymentTypeChecked &&  selectedDate == null || selectedDate == undefined || selectedDate == ''){
            var errorMessage = 'Select process date to calculate total amounts.';
            helper.showToast(component, event, "Error", "error", errorMessage);
            return;
        }
        if(isPaymentTypeChecked){
            component.set("v.Spinner", true);
            var action = component.get("c.getPaymentTotals");
            action.setParams({
                "paymentParameter": pmtParameter,
                "selectedDate" : selectedDate
            });
            action.setCallback(this, function(response) {
            	component.set("v.Spinner", false);
                var state = response.getState();
                if (state === 'SUCCESS'){
                    var responseValues = response.getReturnValue();
                    console.log('responseValues:'+responseValues);
                    var mapList = [];
                    if(responseValues != ''){
                        for ( var key in responseValues ) {
                            mapList.push({value:responseValues[key], key:key});
                        }
                        component.set('v.totalAmountMap',mapList);
                        component.set("v.displayTotalAmount",true); 
                    } else {
                        component.set("v.displayTotalAmount",false); 
                        var errorMessage = 'There is an error while calculating total amounts.';
                        helper.showToast(component, event, "Error", "error", errorMessage);
                    }
                } else {
                    // show error message and close button
                    if (state === 'ERROR') {
                        var error = response.getError();
                        
                        // try finding a useful error message
                        if (error && error[0] && error[0].message) {
                            message = error[0].message;
                            console.error('error.message=='+message);
                        }
                    }
                    helper.showToast(component, event, "Error", "error", message);
                }
            });
            $A.enqueueAction(action);
            //component.set("v.Spinner", false);
        }else{
            var errorMessage = 'Select Credit Card type or ACH to calculate the total amount.';
            helper.showToast(component, event, "Error", "error", errorMessage);
            //component.set("v.displayTotalAmount",false); 
        }
    },
    paymentReceiptRecordsUpdate : function(component, event, helper) {
        var selectedDate = component.get("v.processDate");
        var pmtParameter = helper.getPaymentCheckParameter(component, event, helper);
        var isPaymentTypeChecked = helper.isPaymentTypeChecked(component, event, helper);
        
        if(selectedDate == null || selectedDate == undefined || selectedDate == ''){
            var errorMessage = 'Select process date to update the settlement.';
            helper.showToast(component, event, "Error", "error", errorMessage);
            return;
        }
        if(isPaymentTypeChecked){
            component.set("v.Spinner", true);
            var action = component.get("c.paymentReceiptRecordsUpdate");
            action.setParams({
                "paymentParameter": pmtParameter,
                "selectedDate" : selectedDate
            });
            action.setCallback(this, function(response) {
            	component.set("v.Spinner", false);
                var state = response.getState();
                if (state === 'SUCCESS'){
                    var responseValues = response.getReturnValue();
                    console.log('responseValues:'+responseValues);
                    var mapList = [];
                    if(responseValues != null && responseValues != '' && responseValues != undefined){
                        if(responseValues == 'success'){
                            component.set("v.displayUpdateButton",false);
                            var successMessage = 'The payment settlement status has been updated successfully.';
                            helper.showToast(component, event, "Success!!!", "success", successMessage);
                            helper.displayTotalAmounts(component, event, helper);
                        }else if(responseValues == 'NoRecord'){
                            var errorMessage = 'No Receipt record to update the settlement.';
                            helper.showToast(component, event, "Error", "error", errorMessage);
                        }
                    } else {
                        //component.set("v.displayUpdateButton",true); 
                        var errorMessage = 'There is an error while update the settlement.';
                        helper.showToast(component, event, "Error", "error", errorMessage);
                    }
                } else {
                    // show error message and close button
                    if (state === 'ERROR') {
                        var error = response.getError();
                        // try finding a useful error message
                        if (error && error[0] && error[0].message) {
                            message = error[0].message;
                            console.error('error.message=='+message);
                        }
                    }
                    helper.showToast(component, event, "Error", "error", message);
                }
            });
            $A.enqueueAction(action);
        }else{
            var errorMessage = 'Select Credit Card type or ACH to update the settlement.';
            helper.showToast(component, event, "Error", "error", errorMessage);
        }
    },
    isPaymentTypeChecked : function(component, event, helper) {
        var isPaymentTypeChecked = false;
        var amexCheck = false;
        var visaCheck = false;
        var masterCheck = false;
        var discoverCheck = false;
        var achCheck = false;
        if(component.find("ccCheckId").get("v.checked")){
            amexCheck =   component.find("amexCheckId").get("v.checked");
            visaCheck =   component.find("visaCheckId").get("v.checked");
            masterCheck =   component.find("masterCheckId").get("v.checked");
            discoverCheck =   component.find("discoverCheckId").get("v.checked");
        }
        achCheck = component.find("achCheckId").get("v.checked");
        if((amexCheck != null && amexCheck != undefined && amexCheck == true)
          	||(visaCheck != null && visaCheck != undefined && visaCheck == true)
          	||(masterCheck != null && masterCheck != undefined && masterCheck == true)
            ||(discoverCheck != null && discoverCheck != undefined && discoverCheck == true)
            ||(achCheck != null && achCheck != undefined && achCheck == true)){
                isPaymentTypeChecked = true;
        }
        return isPaymentTypeChecked;
    },
    getPaymentCheckParameter : function(component, event, helper) {
        var paymentParameter = '';
        var amexCheck = false;
        var visaCheck = false;
        var masterCheck = false;
        var discoverCheck = false;
        var achCheck = false;
        if(component.find("ccCheckId").get("v.checked")){
            amexCheck =   component.find("amexCheckId").get("v.checked");
            visaCheck =   component.find("visaCheckId").get("v.checked");
            masterCheck =   component.find("masterCheckId").get("v.checked");
            discoverCheck =   component.find("discoverCheckId").get("v.checked");
        }
        achCheck = component.find("achCheckId").get("v.checked");
        paymentParameter = amexCheck+'-'+visaCheck+'-'+masterCheck+'-'+discoverCheck+'-'+achCheck;
        return paymentParameter;
    }
})