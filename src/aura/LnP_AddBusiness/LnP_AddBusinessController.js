({    
    handleClick : function(component, event,helper) {
        helper.handleClick(component,event);        
    },    
    returnBusiness : function(component,event,helper){
        helper.returnBusiness(component,event);        
    },    
    handleSuccess : function(component,event,helper){        
        helper.handleSuccess(component,event,helper)   
    },
	handleError : function(component,event,helper){        
        helper.handleError(component,event,helper)   
    },  
    // Validate input fields and submit add business.
    validateFields : function(component,event,helper){
        component.set("v.buttonDisable",true);
		var ubiValidation = component.get("v.ubiValidated");
        document.body.scrollTop = document.documentElement.scrollTop = 0;
        component.set("v.loadingSpinner",true);
        var fieldsWrapper = component.get("v.validateFields");
        var validateFields = fieldsWrapper.filter(function(item){
            return  item.Required__c == true || item.Regex_Validation__c != "";
        });                
        var fieldValuesWrapper = component.find("validateField");                 
        var errorMessage = "Please fill valid data";
        var PatternAndFlagCheck = validateFields.every(function validateFields(item, index) {
            if(item.Required__c){
                if(item.Regex_Validation__c != undefined && item.Regex_Validation__c != ""){
                    if(item.Regex_Validation__c == "Date-Validation"){
                        
                    } else {
                        item.Regex_Validation__c = item.Regex_Validation__c.replace("%5C", "\\");
                        var regexExp = new RegExp(item.Regex_Validation__c);
                        var valueVal = fieldValuesWrapper[index].get("v.value");
                        if(fieldValuesWrapper[index].get("v.value") != '' && fieldValuesWrapper[index].get("v.value") != null && regexExp.test(valueVal)){
                            return true;
                        }else{
                            errorMessage = item.Error_Message__c != undefined? item.Error_Message__c: item.Name+" error";
                            return false;
                        }  
                    }
                } else {
                    if(fieldValuesWrapper[index].get("v.value") != '' && fieldValuesWrapper[index].get("v.value") != null){
                        return true;
                    } else {
                        errorMessage = item.Error_Message__c != undefined? item.Error_Message__c: item.Name+" error";
                        return false;
                    }  
                }
            } else {
                if(item.Regex_Validation__c != undefined && item.Regex_Validation__c != ""){
                    if(fieldValuesWrapper[index].get("v.value") != '' && fieldValuesWrapper[index].get("v.value") != null){
                        if(item.Regex_Validation__c == "Date-Validation"){
                            
                        } else {
                            item.Regex_Validation__c = item.Regex_Validation__c.replace("%5C", "\\");
                            var regexExp = new RegExp(item.Regex_Validation__c);
                            var valueVal = fieldValuesWrapper[index].get("v.value");
                            if(regexExp.test(valueVal)){
                                return true;
                            }else{
                                errorMessage = item.Error_Message__c != undefined? item.Error_Message__c: item.Name+" error";
                                return false;
                            }  
                        }
                    } else {
                        return true;
                    }
                } else {
                    return true;
                }
            }
        });
        if(ubiValidation){
            
        }else{
            errorMessage = "Validate UBI before proceeding!";
        }
        if(PatternAndFlagCheck && ubiValidation){
            component.find("editForm").submit();                  
        }
        else{
            component.set("v.loadingSpinner",false);
            component.set("v.buttonDisable",false);
            component.set("v.nextFlag", false);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "ERROR!",
                "message": errorMessage,
                "type": "error"
            });
            toastEvent.fire();
        } 
    }, 
    // Masking input fields.    
    fieldchange:function(component,event,helper){       
        var numbers=event.getSource().get('v.value');
        var fieldname=event.getSource().get('v.fieldName');
        if(fieldname=="Phone_Primary_Contact__c" || fieldname=="Business_Phone__c"){
            if(numbers.length==10){
                var trimmedNo = ('' + numbers).replace(/\D/g, '');
                var phone = trimmedNo.slice(0, 3)+'.'+trimmedNo.slice(3,6) + '.' + trimmedNo.slice(6);
                event.getSource().set('v.value',phone); 
            }
        }
        if(fieldname=="UBI_Number__c"){
			component.set("v.ubiValidated", false);
            if(numbers.length==9){
                var trimmedNo = ('' + numbers).replace(/\D/g, '');
                var phone = trimmedNo.slice(0, 3)+'-'+trimmedNo.slice(3,6) + '-' + trimmedNo.slice(6);
                event.getSource().set('v.value',phone); 
            }
        }        
    },
	validateUBINumber : function(component, event, helper) {
        var ubi = component.get("v.ubiValueEntered");
        var accountId = component.get("v.accountId");
        var valid = true;
        console.log('ubi.length**=='+ubi.length);
        var ubiLength = ubi.length;
        console.log('accountId=='+accountId);
        if(ubi == '' || ubi == null){
            valid = false;
            helper.showToast(component, event, "Error!", "error", "UBI nummber cannot be blank.");
        }
        else if(ubi != '' && ubi != null && ubi.length < 11){
            valid = false;
            helper.showToast(component, event, "Error!", "error", "UBI number length cannot be less than 9 characters");            
        }        
        var action = component.get("c.validateUBI");
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
                        component.set("v.ubiValidated", true);
                        component.set("v.ubiValidationResponse", "Active");
                        helper.showToast(component, event, "Success!", "success", "Your Search result has been updated successfully.");
                        //helper.setDefaultFields(component);
                        //$A.get('e.force:refreshView').fire();
                        //helper.closeQuickAction(component, event, helper);
                    }
                    if(result == ""){
                        component.set("v.ubiValidated", true);
                        component.set("v.ubiValidationResponse", "Active");
                        helper.showToast(component, event, "Success!", "success", "Your Search result has been updated successfully.");
                    }
                    //follwoing two conditions have been removed as per User Story 1436
                    /*if(result == 'MismatchInactive'){
                    console.log('MismatchInactive==');
                    helper.showToast(component, event, "Warning!", "warning", "Business name is Mismatch and UBI Status is not Active");
                    helper.setDefaultFields(component);
                    $A.get('e.force:refreshView').fire();
                }
                result.contains(Mismatch)
                if(result == 'Mismatch'){
                    console.log('Mismatch==');
                    helper.showToast(component, event, "Warning!", "warning", "Business name is Mismatch.");
                    helper.setDefaultFields(component);
                    $A.get('e.force:refreshView').fire();
                }*/                
                if(result.includes('Mismatch')){
                    console.log('Mismatch==');
                    component.set("v.ubiValidated", true);
                    component.set("v.ubiValidationResponse", "Inactive");
                    var businessName =  result.split('***')[1];
                    var acctName =  result.split('***')[2];
                    var errormsg = 'Business name '+businessName+' retrieved from SOS is not matching with Account Name '+acctName+'.';
                    helper.showToast(component, event, "Warning!", "warning", errormsg);
                    //$A.get('e.force:refreshView').fire();
                    //helper.setDefaultFields(component);
                    //helper.closeQuickAction(component, event, helper);
                }
                if(result == 'Inactive'){
                    console.log('Inactive==');
                    component.set("v.ubiValidated", true);
                    component.set("v.ubiValidationResponse", "Inactive");
                    helper.showToast(component, event, "Warning!", "warning", "UBI Status is not Active");
                    //$A.get('e.force:refreshView').fire();
                    //helper.setDefaultFields(component);
                    //helper.closeQuickAction(component, event, helper);                    
                }
                if(result == 'UBI not found'){
                    console.log('UBI not found==');
                    component.set("v.ubiValidated", true);
                    component.set("v.ubiValidationResponse", "Inactive");
                    helper.showToast(component, event, "Warning!", "Warning", "No match found for the UBI.");
                    //helper.setDefaultFields(component);
                    //$A.get('e.force:refreshView').fire();
                    //helper.closeQuickAction(component, event, helper);
                }                
                if(result == 'Unknown error occoured'){
                    console.log('error occoured==');
                    component.set("v.ubiValidated", true);
                    component.set("v.ubiValidationResponse", "Inactive");
                    helper.showToast(component, event, "Error!", "error", "Error Occoured");
                    //helper.setDefaultFields(component);
                    //$A.get('e.force:refreshView').fire();
                    //helper.closeQuickAction(component, event, helper);
                }                
                if(result == 'error from SOS'){
                    console.log('error occoured==');
                    component.set("v.ubiValidated", true);
                    component.set("v.ubiValidationResponse", "Inactive");
                    helper.showToast(component, event, "Error!", "error", "Error Occoured from SOS");
                    //helper.setDefaultFields(component);
                    //$A.get('e.force:refreshView').fire();
                    //helper.closeQuickAction(component, event, helper);
                }
            }
            });
        }        
        $A.enqueueAction(action);
    },
})