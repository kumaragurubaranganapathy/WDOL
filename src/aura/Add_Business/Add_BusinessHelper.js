({
	getRecordTypeId : function(component,event,helper) {
		var action = component.get("c.getRecordTypeIdAccount");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
              var result = response.getReturnValue();
                component.set("v.recordTypeId",result);
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        
	},
    fetchData: function (cmp,event,helper) {
        var action = cmp.get("c.getAllAccounts");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                console.log('data::'+JSON.stringify(data))
                cmp.set('v.data',data);
                for(var item in data){
                    cmp.set("v.existingAcc",true);
                    break;
                }
                    
                }
                          
        });
        $A.enqueueAction(action);
    }
})