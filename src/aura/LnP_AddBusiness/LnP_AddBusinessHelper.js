({
    addAccountContact: function (component, event) {
        var action = component.get("c.createAccountContactObject");
        action.setParams({ "aId": component.get("v.accountId") });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var status = response.getReturnValue()
                var toastEvent = $A.get("e.force:showToast");
                if (status) {
                    toastEvent.setParams({
                        "type": "Success",
                        "title": "Success!",
                        "message": "The record has been added successfully."
                    });
                    var compEvent = component.getEvent("businessRefresh");
                    compEvent.setParams({ "refreshFlag": "true" });
                    compEvent.fire();
                } else {
                    toastEvent.setParams({
                        "type": "Error",
                        "title": "Error!",
                        "message": "Something went wrong"
                    });
                }
                toastEvent.fire();
            } else if (state === "ERROR") {
            }
        });
        $A.enqueueAction(action);
        component.set("v.isOpen", false);
    }
})