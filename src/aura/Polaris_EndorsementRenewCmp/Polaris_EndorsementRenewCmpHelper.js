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
    viewProviderHelper: function(component, event, helper) {
         var parcedValue = event.getParam("value").split(',');
        var endorsementID = parcedValue[0];  
        component.set("v.showProvider",false);
        var action = component.get("c.fetchProvider");
        action.setParams({            
            "endoId": endorsementID,
        });
        action.setCallback(this, function(actionResult){
            var state = actionResult.getState();
            if (state === "SUCCESS"){
                var result = actionResult.getReturnValue();
                if(result.length>0)
                {
                    component.set("v.showProvider",true);
                    component.set("v.providerList",result);
                }
                    
               // helper.fetchEndorsement(component, event, helper);
            }
        });
        $A.enqueueAction(action);    
    },
    addProviderHelper: function(component, event, helper) {
        var parcedValue = event.getParam("value").split(',');
        var endorsementID = parcedValue[0]; 
        component.set("v.endorsementID",endorsementID);
        
        component.set("v.isModalOpen",true);
    },
    deleteProviderHelper : function(component, event, helper) {
         var action = component.get("c.removeProvider");
        
        action.setParams({            
            "providerId": event.getSource().get("v.value"),
        });
        action.setCallback(this, function(actionResult){
            var state = actionResult.getState();
            if (state === "SUCCESS"){
                //helper.viewProviderHelper(component, event, helper);
                component.set("v.showProvider",false);
            }
        });
        $A.enqueueAction(action);
    },
})