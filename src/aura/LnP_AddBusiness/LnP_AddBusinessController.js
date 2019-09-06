({    
    doInit : function(component, event) {
        component.set("v.ubiHelpText", "Ubi help <b>text</b>");        
        var fields = component.get("v.validateFields");
        fields.forEach(function(elem){
            if(elem.lName === "UBI_Number__c"){
                elem.Required__c = true;
            }
        });
    },    
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
		if(component.get("v.ubiRequired"))            
            var ubiValidation = component.get("v.ubiValidated");
        else
            var ubiValidation = true;
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
        var validateFields = component.get("v.validateFields");
        if(fieldname=="Phone_Primary_Contact__c" || fieldname=="Business_Phone__c"){
            if(numbers.length==10){
                var trimmedNo = ('' + numbers).replace(/\D/g, '');
                var phone = trimmedNo.slice(0, 3)+'.'+trimmedNo.slice(3,6) + '.' + trimmedNo.slice(6);
                event.getSource().set('v.value',phone); 
            }
        }
        if(fieldname=="UBI_Number__c"){
            component.set("v.ubiValidated", false);
            /*var fieldValues = component.find("validateField");
            for(var i=0; i<fieldValues.length; i++){
                if(fieldValues[i].get("v.fieldName") == 'Name'){
                    var auraID = component.find("validateField")[i];
                    $A.util.removeClass(auraID, 'disable');
                }
            }*/
            numbers = numbers.replace(/\s/gi, "");
            if(numbers.length==9){
                var trimmedNo = ('' + numbers).replace(/\D/g, '');
                var phone = trimmedNo.slice(0, 3)+'-'+trimmedNo.slice(3,6) + '-' + trimmedNo.slice(6);
                event.getSource().set('v.value',phone); 
            }
        }        
        if(fieldname==="Course_Provider__c"){
            if(numbers){
                validateFields.forEach(function(elem){
                    if(elem.lName === 'UBI_Number__c'){
                        elem.Required__c = !numbers;  
                        component.set("v.ubiRequired", elem.Required__c);
                    }
                });
            }
            else{
                validateFields.forEach(function(elem){
                    if(elem.lName === 'UBI_Number__c')
                        elem.Required__c = true; 
                    component.set("v.ubiRequired", elem.Required__c);
                });
            }
            component.set("v.validateFields",validateFields);
        }
    },
    cancelUBIDetails : function(component, event, helper){
        component.set("v.ubiValidated", false);
        component.set("v.isOpen", false);
    },
    confirmUBIDetails : function(component, event, helper){
        var values = component.get("v.ubiDetails");
        var fieldValues = component.find("validateField");
        for(var i=0; i<fieldValues.length; i++){
            if(fieldValues[i].get("v.fieldName") == 'Name'){
                fieldValues[i].set("v.value", values.Name);
                //var auraID = component.find("validateField")[i];
                //$A.util.addClass(auraID, 'disable');
            }
        }
        component.set("v.ubiValidationResponse", "Active");
        component.set("v.ubiValidated", true);
        component.set("v.isOpen", false);
    },
    validateUBINumber : function(component, event, helper) {
        var ubiRequired = component.get("v.ubiRequired");
        if(ubiRequired){
        var ubi = component.get("v.ubiValueEntered");
        var valid = true;
        if(ubi==undefined){
            ubi=""
        }
        
        if(ubi!=undefined && ubi!=""){
            ubi = ubi.replace(/\s/gi, "");
        }
        
        if(ubi == '' || ubi == null){
            valid = false;
            helper.showToast(component, event, "Error!", "error", "UBI cannot be blank.");
        }
        else if(ubi != '' && ubi != null && ubi.length < 11){
            valid = false;
            helper.showToast(component, event, "Error!", "error", "UBI length cannot be less than 9 characters");            
        }
        else {
            ubi = ubi.replace(/-/gi, "");   
        }
        
        if(valid === true){
            var action = component.get("c.validateUBI");
            action.setParams({
                'ubi': ubi,
            });
            action.setCallback(this, function(actionResult){
                if(actionResult.getState() === "SUCCESS"){
                    var result = actionResult.getReturnValue();
                    if(result!=null || result!=""){
                        if(result.AccountNumber == "200"){
                            if(result.UBI_Status__c == "Active"){
                                component.set("v.ubiDetails",result);
                                component.set("v.isOpen", true);
                            }
                            if(result.UBI_Status__c == "Inactive"){
                                component.set("v.ubiValidationResponse", "Inactive");
                                component.set("v.ubiValidated", true);
                        		helper.showToast(component, event, "Warning!", "warning", "UBI Status of "+result.Name+" is Inactive");
                            }
                        }
                        if(result.AccountNumber == "404"){
                            component.set("v.ubiValidationResponse", "NA");
                            component.set("v.ubiValidated", true);
                        	helper.showToast(component, event, "Warning!", "Warning", "No match found for the UBI.");
                        }
                        if(result.AccountNumber == undefined || result.AccountNumber == null || result.AccountNumber == ""){
                            component.set("v.ubiValidationResponse", "NA");
                            component.set("v.ubiValidated", true);
                        	helper.showToast(component, event, "Error!", "error", "Error Occoured from SOS");
                        }
                    } else {
                        component.set("v.ubiValidationResponse", "NA");
                        component.set("v.ubiValidated", true);
                        helper.showToast(component, event, "Error!", "error", "Error Occoured from SOS");
                    }                    
                } else {
                    component.set("v.ubiValidationResponse", "NA");
                    component.set("v.ubiValidated", true);
                    helper.showToast(component, event, "Error!", "error", "Error Occoured from SOS");
                }
            });
            $A.enqueueAction(action);
        }    
    }    
    },
})