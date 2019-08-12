({
    doinit : function(component, event, helper) {
        //helper.showToast(component, event, title, type, message);
        helper.setDefaultFields(component, event, helper);
    },
    
	format: function (component,event,helper) {
        
        var ubiInput = component.get("v.ubiNumber");
        console.log('ubiInput=='+ubiInput);
        if(ubiInput.includes('-')){
            ubiInput = ubiInput.split('-').join('');    // Remove dash (-) if mistakenly entered.
        }
        if(ubiInput.length > 2){
            var ubiInputwithDash = ubiInput.match(/.{1,3}/g).join('-');
        	//document.getElementById(element.id).value = finalVal;
        	component.set("v.ubiNumber", ubiInputwithDash);
        }  
    }, 
    
	search : function(component, event, helper) {
        var ubi = component.get("v.ubiNumber");
        var accountId = component.get("v.recordId");
        var valid = true;
        //601810719
        console.log('ubi.length**=='+ubi.length);
        console.log('accountId=='+accountId);
        if(ubi == '' || ubi == null){
            valid = false;
            helper.showToast(component, event, "Error!", "error", "UBI# can not be blank.");
        }
        /*else if(ubi != '' || ubi != null && ubi.length != 11){
            valid = false;
            helper.showToast(component, event, "Error!", "error", "UBI# lenght can not be leass than 9 characters");
            
        }*/
        
        var action = component.get("c.transformAndSave");
        action.setParams({
            'accountId' : accountId,
            'ubi': ubi,
        });
        console.log('after setting param');
        if(valid === true){
            action.setCallback(this, function(actionResult){
            if(actionResult.getState() === "SUCCESS"){
                var result = actionResult.getReturnValue();
                if(result == 'success'){
                    console.log('success==');
                    helper.showToast(component, event, "Success!", "success", "Your search result has has been updated successfully.");
                    helper.setDefaultFields(component);
                    $A.get('e.force:refreshView').fire();
                }
                if(result == 'MismatchInactive'){
                    console.log('MismatchInactive==');
                    helper.showToast(component, event, "Warning!", "warning", "Business name is Mismatch and UBI Status is not Active");
                    helper.setDefaultFields(component);
                    $A.get('e.force:refreshView').fire();
                }
                if(result == 'Mismatch'){
                    console.log('Mismatch==');
                    helper.showToast(component, event, "Warning!", "warning", "Business name is Mismatch.");
                    helper.setDefaultFields(component);
                    $A.get('e.force:refreshView').fire();
                }
                if(result == 'Inactive'){
                    console.log('Inactive==');
                    helper.showToast(component, event, "Warning!", "warning", "UBI Status is not Active");
                    helper.setDefaultFields(component);
                    $A.get('e.force:refreshView').fire();
                }
                if(result == 'UBI not found'){
                     console.log('UBI not found==');
                    helper.showToast(component, event, "Warning!", "Warning", "No match found for the UBI#.");
                    helper.setDefaultFields(component);
                    $A.get('e.force:refreshView').fire();
                }
                
                if(result == 'Unknown error occoured'){
                    console.log('error occoured==');
                    helper.showToast(component, event, "Error!", "error", "Error Occoured");
                    helper.setDefaultFields(component);
                    $A.get('e.force:refreshView').fire();
                }
                
                if(result == 'error from SOS'){
                    console.log('error occoured==');
                    helper.showToast(component, event, "Error!", "error", "Error Occoured from SOS");
                    helper.setDefaultFields(component);
                    //$A.get('e.force:refreshView').fire();
                }
            }
        });
        }
        
		 $A.enqueueAction(action);
	},
})