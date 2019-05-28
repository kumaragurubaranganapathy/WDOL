({
	fetchEndorsement : function(component, event, helper) {        
        var action = component.get("c.fetchEndorsement");
        action.setParams({            
            "licId": component.get("v.recordId")            
        });
        action.setCallback(this, function(actionResult){
            var state = actionResult.getState();
                if (state === "SUCCESS"){
                    var result = actionResult.getReturnValue();
                    component.set("v.endorsementList",result);                    
                }
            });
            $A.enqueueAction(action);
    },
    
    changeStatusHelp : function(component, event, helper) {
        var parcedValue = event.getParam("value").split(',');
        var endorsementID = parcedValue[0];       
        var status = parcedValue[1];
        var action = component.get("c.changeStatus");
        action.setParams({            
            "endoId": endorsementID,
            "Status":status,
            "licId": component.get("v.recordId")
        });
        action.setCallback(this, function(actionResult){
            var state = actionResult.getState();
                if (state === "SUCCESS"){
                    var result = actionResult.getReturnValue();
                    component.set("v.endorsementList",result);                    
                }
            });
            $A.enqueueAction(action);
    },
})