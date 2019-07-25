({
	doInit : function(component, event, helper) {
		var recordId = decodeURIComponent(window.location.search.substring(1).split('par1=')[1].split('&par2=')[0]);
        var value = decodeURIComponent(window.location.search.substring(1).split('par1=')[1].split('&par2=')[1]);        
        if(value.toLowerCase() == "contact"){
            component.set("v.objectApiName", 'Contact');
            component.set("v.fieldApiNames", ['Email','Other_Email__c','MobilePhone','Phone']);
            component.set("v.recordIDforSSAMR",recordId);
            component.set("v.recordEditForm", true);
            
            component.set("v.AMRName",'Update Contact Information');
            component.set("v.redirectURL", $A.get("$Label.c.Polaris_Portal_NewDashboard"));
        }
        else if(value.toLowerCase() == "license"){            
            component.set("v.customForm", true);
            component.set("v.recordIDforSSAMR",recordId);   
            component.set("v.AMRName",'Update Website');
            component.set("v.redirectURL", $A.get("$Label.c.Polaris_Portal_Business_Dashboard"));
            helper.fetchWebiste(component, event, helper);
        }
        else if(value.toLowerCase() == "print"){            
            component.set("v.showPrintForm", true);
            component.set("v.recordIDforSSAMR",recordId);            
            component.set("v.redirectURL", $A.get("$Label.c.Polaris_Portal_NewDashboard"));
            component.set("v.AMRName",'Update Website');
            helper.fetchWebiste(component, event, helper);
        }
        else if(value.toLowerCase() == "businesscontact"){
			component.set("v.objectApiName", 'Account');
            component.set("v.fieldApiNames", ['First_Name_Primary_Contact__c','Last_Name_Primary_Contact__c','Email_Primary_Contact__c','Email__c','Phone_Primary_Contact__c','Business_Phone__c']);
            component.set("v.recordIDforSSAMR",recordId);
            component.set("v.recordEditForm",true);
            component.set("v.AMRName",'Update Contact Information');
            component.set("v.redirectURL", $A.get("$Label.c.Polaris_Portal_Business_Dashboard"));
        }
		else if(value.toLowerCase() == "billingcode"){
			component.set("v.objectApiName", 'Account');
            component.set("v.fieldApiNames", ['ThirdPary_Billing_Code__c']);
            component.set("v.recordIDforSSAMR",recordId);
            component.set("v.thirdpartybillingcode", true);
            component.set("v.recordIDforSSAMR",recordId);
            var action = component.get("c.fetchAccountInfo");
            action.setParams({
                "licId": recordId    
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var appId = response.getReturnValue();
                    if(appId != null && appId.ThirdPary_Billing_Code__c != undefined && appId.ThirdPary_Billing_Code__c != null && appId.ThirdPary_Billing_Code__c != ''){
                    	component.set("v.existingBillingCode",appId.ThirdPary_Billing_Code__c);
                    }
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.error("Error message: " + errors[0].message);
                        }
                    } else {
                        console.error("Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);              
            component.set("v.redirectURL",$A.get("$Label.c.Polaris_Portal_Business_Dashboard"));
        }
        
        else if(value.toLowerCase() == "address"){			
            component.set("v.recordIDforSSAMR",recordId);
            component.set("v.AMRName",'Update Address');
            var action = component.get("c.fetchAppId");
            action.setParams({
                "licId": recordId    
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var appId = response.getReturnValue();
                    component.set("v.appId",appId);
                    component.set("v.address", true);
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.error("Error message: " + errors[0].message);
                        }
                    } else {
                        console.error("Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);              
            component.set("v.redirectURL", $A.get("$Label.c.Polaris_Portal_NewDashboard"));             
        }
	},
     getContact : function(component, event, helper){
         var action = component.get("c.fetchContactInfo");
         action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var contactInfo = response.getReturnValue();
                component.set("v.contactName",contactInfo);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.error("Error message: " + errors[0].message);
                    }
                } else {
                    console.error("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
         
     },
    fetchWebiste : function(component, event, helper){
       var licId  = component.get("v.recordIDforSSAMR");        
        var action = component.get("c.fetchWebsiteInfo");
        action.setParams({
            "licId": licId    
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var websiteInfo = response.getReturnValue();
                component.set("v.existWebsite",websiteInfo);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.error("Error message: " + errors[0].message);
                    }
                } else {
                    console.error("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);   
        
    },
    saveWebsitehelper : function(component, event, helper){
        var licId = component.get("v.recordIDforSSAMR");
		var updatedValue = component.get("v.existWebsite");
		var action = component.get("c.updateWebsiteInfo");
        action.setParams({
            "licId": licId,
            "websiteInfo":updatedValue
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //response.getReturnValue();
                window.location.href = component.get("v.redirectURL");
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.error("Error message: " + errors[0].message);
                    }
                } else {
                    console.error("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);       
    },
    printUpdatehelper : function(component, event, helper){
    	var licId = component.get("v.recordIDforSSAMR");
        var action = component.get("c.printUpdateLicense");
        action.setParams({
            "licId": licId,
            "printType":component.find("printLicenseId").get("v.value")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                response.getReturnValue();
                window.location.href = component.get("v.redirectURL");
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.error("Error message: " + errors[0].message);
                    }
                } else {
                    console.error("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
        
	},
    createcode : function(component, event, helper){
        var licId = component.get("v.recordIDforSSAMR");
		var updatedValue = 'createCode';
		var action = component.get("c.updateWebsiteInfo");
        action.setParams({
            "licId": licId,
            "websiteInfo":updatedValue
        });
		/*var action = component.get("c.createCodeValue");
        action.setParams({
            "test": 'hello'
        });*/
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                response.getReturnValue();
                window.location.href = component.get("v.redirectURL");
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.error("Error message: " + errors[0].message);
                    }
                } else {
                    console.error("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);       
    },
    
    cancel : function(component, event, helper){
    	window.location.href = component.get("v.redirectURL");
	}
    
    

})