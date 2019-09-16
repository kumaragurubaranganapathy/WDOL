({
    errorlog:function(component,event){
        var url=$A.get("$Label.c.Polaris_Portal_Home")+'explorer-error-page';
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": url
        });
        urlEvent.fire();
    },
    doInit : function(component, event, objectApi, fieldsName, auraAttr) {
        component.set("v.loadingSpinner", true);
        var action = component.get("c.getPicklistFieldValues");
        action.setParams({
            'objectName':objectApi,
            'pickListFieldName':fieldsName
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                if(auraAttr == "v.professionOptions"){
                    var filteredResult = result.filter(function(item){
                       return item != 'Delegated Municipality' && item != 'Manufactured Homes' && item != 'Misc Payments' && item != 'Regulatory Compliance' && item != 'Update/Close Company' && item != 'Update Legal Name' && item != 'Remove Owner' && item != 'Collection Agency' && item != 'Update Business Name' && item != 'Update Company Information' && item != 'Program Unknown';
                    });
                    component.set(auraAttr, filteredResult);
                }else{
                    component.set(auraAttr, result);
                }
                component.set("v.loadingSpinner", false);
            }else{
                component.set("v.loadingSpinner", false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "There is some error in loading the page. Please reload the page.",
                    "type": "error"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);  
    },
	goToNext : function(component, event, helper) {
		var tabIndex = component.get("v.currentTab");
        if(tabIndex == 1){
            var professionValue = component.find("Profession").get("v.value");
            component.set("v.professionDisable",true);
            if(professionValue != ""){
                component.set("v.loadingSpinner", true);
                var label;
                var value;
               	var allprofessionalFormFields = component.find('professionalForm').reduce(function (validSoFar, inputCmp) {
                    inputCmp.showHelpMessageIfInvalid();
                    return validSoFar && inputCmp.get('v.validity').valid;
                }, true);
                if (allprofessionalFormFields) {
                    var professionalFormValues = {};
                    var professionalForm = component.find("professionalForm");          
                    for(var i=0; i<professionalForm.length; i++){ 
                        label = component.find("professionalForm")[i].get("v.name");
                        value = component.find("professionalForm")[i].get("v.value");
                        professionalFormValues[label] = value;
                    }
                    component.set("v.professionalForm", professionalFormValues);
                } else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Please correct the error fields",
                        "type": "error"
                    });
                    toastEvent.fire();
                }
                if(component.get("v.businessScreen")){                    
                    var allBusinessFormFields = component.find('businessForm').reduce(function (validSoFar, inputCmp) {
                        inputCmp.showHelpMessageIfInvalid();
                        return validSoFar && inputCmp.get('v.validity').valid;
                    }, true);
                    if (allBusinessFormFields) {
                        var businessFormValues = {};
                        var businessForm = component.find("businessForm");
                        for(var i=0; i<businessForm.length; i++){ 
                            label = component.find("businessForm")[i].get("v.name");
                            value = component.find("businessForm")[i].get("v.value");
                            businessFormValues[label] = value;
                        }
                        component.set("v.businessForm", businessFormValues);
                    } else {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": "Please correct the error fields",
                            "type": "error"
                        });
                        toastEvent.fire();
                    }
                }
                if(component.get("v.businessScreen")){
                    if(!allprofessionalFormFields || !allBusinessFormFields){
                        component.set("v.firstTabFlag", false);
                    }else{
                        component.set("v.firstTabFlag", true);
                    }
                }else {
                    if(!allprofessionalFormFields){
                        component.set("v.firstTabFlag", false);
                    }else{
                        component.set("v.firstTabFlag", true);
                    }
                }
                if(component.get("v.firstTabFlag")){
                    var applicationId = component.get("v.applicationId");
                    if(applicationId != '' && applicationId != null){
                        // proceed without calling
                        component.set("v.loadingSpinner", false);
                        component.set("v.currentTab", 2);
                        component.set("v.screenOne", false);
                        component.set("v.screenTwo", true);
                        component.set("v.screenThree", false);
                        window.scrollTo({ top: 0, behavior: 'smooth' });
                    } else {
                        // call server and set app id
                        var action = component.get("c.addComplaint");
                        action.setCallback(this, function(actionResult) {
            			var state = actionResult.getState();
                            if (state === "SUCCESS"){
                                var result = actionResult.getReturnValue();
                                if(result!=null){
                                component.set("v.applicationId",result);
                                component.set("v.loadingSpinner", false);
                                component.set("v.currentTab", 2);
                                component.set("v.screenOne", false);
                                component.set("v.screenTwo", true);
                                component.set("v.screenThree", false);
                                window.scrollTo({ top: 0, behavior: 'smooth' });
                                }
                                else{
                                    console.log("Error");
                                    this.errorlog(component,event);
                                }
                            } else {
                                component.set("v.loadingSpinner", false);
                                var toastEvent = $A.get("e.force:showToast");
                                var errors = actionResult.getError();
                                if (errors) {
                                    var message = "";
                                    if (errors[0] && errors[0].message) {
                                       message = "Error message: " + errors[0].message;
                                    }
                                }
                                else {
                                    message = "Unknown error";
                                }
                                toastEvent.setParams({
                                    "title": "Error!",
                                    "message": message,
                                    "type": "error"
                                });
                                toastEvent.fire(); 
                            }
                        });
                        $A.enqueueAction(action); 
                    }
                }else{
                    console.log("Error");
                }
            } else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Please fill the mandatory fields",
                    "type": "error"
                });
                toastEvent.fire();
            }
        }
        if(tabIndex == 2){
            var labels;
            var values;
            var allInformationFormFields = component.find('informationForm').reduce(function (validSoFar, inputCmp) {
                inputCmp.showHelpMessageIfInvalid();
                return validSoFar && inputCmp.get('v.validity').valid;
            }, true);
            if (allInformationFormFields) {
                var informationFormValues = {};
                var informationForm = component.find("informationForm");          
                for(var i=0; i<informationForm.length; i++){ 
                    labels = component.find("informationForm")[i].get("v.name");
                    values = component.find("informationForm")[i].get("v.value");
                    informationFormValues[labels] = values;
                }
                component.set("v.informationForm", informationFormValues);
                component.set("v.currentTab", 3);
                component.set("v.screenOne", false);
                component.set("v.screenTwo", false);
                component.set("v.screenThree", true);
                component.set("v.agreeCheck", true);
                window.scrollTo({ top: 0, behavior: 'smooth' });
            } else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Please fill the mandatory fields",
                    "type": "error"
                });
                toastEvent.fire();
            }            
        }
	},
    backToPrevious : function(component, event, helper) {
		var tabIndex = component.get("v.currentTab");
        if(tabIndex == 3){
            component.set("v.currentTab", 2);
            component.set("v.screenOne", false);
            component.set("v.screenTwo", true);
            component.set("v.screenThree", false);
            component.set("v.agreeCheck", false);
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }
        if(tabIndex == 2){
            component.set("v.currentTab", 1);
            component.set("v.screenOne", true);
            component.set("v.screenTwo", false);
            component.set("v.screenThree", false);
            component.set("v.agreeCheck", false);
            component.set("v.anonymousComplaintCheckbox", false);
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }
	},
    showOtherFields : function(component, event, helper) {
        var professionValue = component.find("Profession").get("v.value");
        if(professionValue != ""){
            if(professionValue == "Engineers" || professionValue == "Land Surveyors"){
                component.set("v.displayMessage", true);
                component.set("v.anonymousComplaint", false);
            }else{
                component.set("v.displayMessage", false);
                component.set("v.anonymousComplaint", true);
            }
            component.set("v.professionalScreen", true);
            component.set("v.selectedProfession", professionValue);
        } else {
            component.set("v.professionalScreen", false);
            component.set("v.businessScreen", false);
            component.set("v.selectedProfession", "");
            component.set("v.displayMessage", false);
            component.set("v.anonymousComplaint", true);
        }
    },
    submitComplaint : function(component, event, helper) {
        component.set("v.loadingSpinner", true);
        var applicationId = component.get("v.applicationId");
        var selectedProfession = component.get("v.selectedProfession");
        var professional = JSON.stringify(component.get("v.professionalForm"));
        var business = JSON.stringify(component.get("v.businessForm"));
        var information = JSON.stringify(component.get("v.informationForm"));
        var complaintSummary = component.find('complaintSummary').get('v.value');
        var agreeCheck = component.get('v.agreeCheck');
        var anonymous = component.get("v.anonymousComplaintCheckbox");
        var complaintWrapper = {
            'selectedProfession': selectedProfession,
            'professionalData': JSON.parse(professional),
            'businessData': JSON.parse(business),
            'information' : JSON.parse(information),
            'complaintSummary' : complaintSummary,
            'agreeCheck' : agreeCheck,
            'anonymous' : anonymous
        }
        console.log('complaintWrapper : ',JSON.stringify(complaintWrapper));
        var action = component.get("c.saveComplaint");
        action.setParams({
            "dataString" : JSON.stringify(complaintWrapper),
            "applicationId" : applicationId,
        });
        action.setCallback(this, function(actionResult){
            var state = actionResult.getState();
            if (state === "SUCCESS"){
                var result = actionResult.getReturnValue();
                if(result!=null){
                var form = component.find("complaintApplication");
                $A.util.addClass(form, 'slds-hide');
                component.set("v.loadingSpinner", false);
                component.set("v.isOpen", true);
                component.set("v.complaintId", result);
                window.scrollTo({ top: 0, behavior: 'smooth' });
                }
                else{
                    this.errorlog(component,event);
                }
            } else {
                component.set("v.loadingSpinner", false);
                window.scrollTo({ top: 0, behavior: 'smooth' });
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Server Error please try again",
                    "type": "error"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    cancelComplaint : function(component, event, helper) {
		var tabIndex = component.get("v.currentTab");
        if(tabIndex == 1){
            if(professionValue != ""){
                var professionValue = component.find("Profession").set("v.value","");
                var professionalForm = component.find("professionalForm");          
                for(var i=0; i<professionalForm.length; i++){ 
                    component.find("professionalForm")[i].set("v.value", "");
                }
                component.set("v.professionalScreen", false);
                if(component.get("v.businessScreen")){                    
                    var businessForm = component.find("businessForm");
                    for(var i=0; i<businessForm.length; i++){ 
                        component.find("businessForm")[i].set("v.value", "");
                    }
                    component.set("v.businessScreen", false);
                }                
            } 
        }
        if(tabIndex == 2){
            if(professionValue != ""){
                var professionValue = component.find("Profession").set("v.value","");
                var professionalForm = component.find("professionalForm");          
                for(var i=0; i<professionalForm.length; i++){ 
                    component.find("professionalForm")[i].set("v.value", "");
                }
                component.set("v.professionalScreen", false);
                if(component.get("v.businessScreen")){                    
                    var businessForm = component.find("businessForm");
                    for(var i=0; i<businessForm.length; i++){ 
                        component.find("businessForm")[i].set("v.value", "");
                    }
                    component.set("v.businessScreen", false);
                }                
            } 
            var informationForm = component.find("informationForm");          
            for(var i=0; i<informationForm.length; i++){ 
                component.find("informationForm")[i].set("v.value", "");
            }
            //component.set("v.applicationId",'');
            component.set("v.currentTab", 1);
            component.set("v.screenOne", true);
            component.set("v.screenTwo", false);
            component.set("v.screenThree", false);
            component.set("v.anonymousComplaintCheckbox", false);
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }
        if(tabIndex == 3){
            if(professionValue != ""){
                var professionValue = component.find("Profession").set("v.value","");
                var professionalForm = component.find("professionalForm");          
                for(var i=0; i<professionalForm.length; i++){ 
                    component.find("professionalForm")[i].set("v.value", "");
                }
                component.set("v.professionalScreen", false);
                if(component.get("v.businessScreen")){                    
                    var businessForm = component.find("businessForm");
                    for(var i=0; i<businessForm.length; i++){ 
                        component.find("businessForm")[i].set("v.value", "");
                    }
                    component.set("v.businessScreen", false);
                }                
            } 
            var informationForm = component.find("informationForm");          
            for(var i=0; i<informationForm.length; i++){ 
                component.find("informationForm")[i].set("v.value", "");
            }
            //component.set("v.applicationId",'');
            component.find('complaintSummary').set('v.value','');
            component.set("v.currentTab", 1);
            component.set("v.screenOne", true);
            component.set("v.screenTwo", false);
            component.set("v.screenThree", false);
            component.set("v.agreeCheck", false);
            component.set("v.anonymousComplaintCheckbox", false);
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }
	},
    changepattern: function(component, event){
        var fieldval=event.getSource().get("v.value");
          if(fieldval.length==10){
              var trimmedNo = ('' + fieldval).replace(/\D/g, '');
              var phone = trimmedNo.slice(0, 3)+'.'+trimmedNo.slice(3,6) + '.' + trimmedNo.slice(6);
              event.getSource().set('v.value',phone);    
          }
    },
	redirectToHome: function(component, event){
        var url=$A.get("$Label.c.Polaris_Portal_Home");
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": url
        });
        urlEvent.fire();
    },
    printAcknowledgement: function(component, event){
        document.getElementById("pageHeader").style.display = "none";
        document.getElementById("pageFooter").style.display = "none";
        document.getElementById("PrintButton").style.visibility = "hidden";
        window.print();
        document.getElementById("pageHeader").style.display = "block";
        document.getElementById("pageFooter").style.display = "block";
        document.getElementById("PrintButton").style.visibility = "visible";
    },
})