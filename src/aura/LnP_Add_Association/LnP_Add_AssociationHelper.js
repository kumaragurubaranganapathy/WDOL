({
    fetchLicenseDetailsHelper : function(component,event) {
        var action = component.get("c.fetchLicenseDetails");
        action.setParams({"licenseID": component.get("v.parentLicense")});
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result =  response.getReturnValue();
                component.set("v.licenseRecord",result);
            } else if (state === "ERROR") {
                
            }
        });
        $A.enqueueAction(action);
    },
    addTask : function(component,event) {
        var action = component.get("c.createAssociationTask");
        action.setParams({"associationID": component.get("v.asssociationId")});
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var status =  response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                if(status){
                    toastEvent.setParams({
                        "type":"Success",
                        "title": "Success!",
                        "message": "The record has been added successfully."
                    });
                }else{
                    toastEvent.setParams({
                        "type":"Error",
                        "title": "Error!",
                        "message": "Something went wrong"
                    });
                }
                toastEvent.fire();
            } else if (state === "ERROR") {
            }
        });
        $A.enqueueAction(action);
        var compEvent = $A.get("e.c:RefreshComponentEvent"); 
        compEvent.setParams({"refresh" : "true" });
        compEvent.fire();
    }
})