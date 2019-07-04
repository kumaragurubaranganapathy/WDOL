({
    addTask : function(component,event) {
        var action = component.get("c.createTask");
        //console.log("designation::"+component.get("v.designation"));
        action.setParams({"accountContact": component.get("v.accountContactId"),
                          "Email": component.get("v.accountEmail"),
                          "accountName": component.get("v.accountName"),
                          "accountId": component.get("v.accountId"),
                          "designation": component.get("v.designation"),
                          "DCP": component.get("v.isDCP")});
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var status =  response.getReturnValue()
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
                //console.error(state);
            }
        });
        $A.enqueueAction(action);
        var compEvent = $A.get("e.c:RefreshComponentEvent"); 
        compEvent.setParams({"refresh" : "true" });
        compEvent.fire();
    }
})