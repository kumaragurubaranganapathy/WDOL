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
        if(PatternAndFlagCheck){
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
            if(numbers.length==9){
                var trimmedNo = ('' + numbers).replace(/\D/g, '');
                var phone = trimmedNo.slice(0, 3)+'-'+trimmedNo.slice(3,6) + '-' + trimmedNo.slice(6);
                event.getSource().set('v.value',phone); 
            }
        }        
    }
})