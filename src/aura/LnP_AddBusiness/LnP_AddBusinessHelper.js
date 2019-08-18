({
    addAccountContact: function (component, event) {
        var action = component.get("c.createAccountContactObject");
        action.setParams({ "aId": component.get("v.accountId") });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var status = response.getReturnValue()
                var toastEvent = $A.get("e.force:showToast");
                component.set("v.loadingSpinner",false);
                if (status) {
                    toastEvent.setParams({
                        "type": "Success",
                        "title": "Success!",
                        "message": "The record has been added successfully."
                    });
                    var compEvent = component.getEvent("businessRefresh");
                    compEvent.setParams({ "refreshFlag": "true" });
                    compEvent.fire();
					sessionStorage.setItem("fromAddbusiness", true);
					sessionStorage.setItem("businessAccountId", component.get("v.accountId"));
                    var str ='/business';
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": str
                    });
                    urlEvent.fire(); 
                } else {
                    toastEvent.setParams({
                        "type": "Error",
                        "title": "Error!",
                        "message": "Something went wrong"
                    });
                    component.set("v.buttonDisable",false);
                }
                toastEvent.fire();
            } else if (state === "ERROR") {
                component.set("v.loadingSpinner",false);
                component.set("v.buttonDisable",false);
            }
        });
        $A.enqueueAction(action);
        component.set("v.isOpen", false);
    },
    handleSuccess : function(component,event,helper){
        var accntId = event.getParams().response.id;
        component.set("v.accountId",accntId);
        helper.addAccountContact(component,event,helper);
    },
	handleError : function(component,event,helper){
        component.set("v.loadingSpinner",false);
        var errors = event.getParam('detail');
        var errorMessage = "";
        if (errors) {
            if(errors.includes('DUPLICATES_DETECTED')){
                errorMessage = "Please use a unique UBI Number as Account with this number already exists.";
            }else{
                errorMessage = "Something went wrong. Please contact system admin.";
            }
        } else {
            errorMessage = "Something went wrong. Please contact system admin.";
        }
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": "Error",
            "title": "Error!",
            "message": errorMessage
        });
        toastEvent.fire();
        component.set("v.buttonDisable",false);
    },
    handleClick : function(component,event){
        var str ='/new-business';
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": str
        });
        urlEvent.fire();        
        component.set("v.isOpen",true);
    },
    returnBusiness : function(component,event){
        var str ='/business';
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": str
        });
        urlEvent.fire(); 
    }
    
})