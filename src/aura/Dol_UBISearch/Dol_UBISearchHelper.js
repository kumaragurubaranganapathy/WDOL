({
	showToast : function(component, event, title, type, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type":type
        });
        toastEvent.fire();
    },
    setDefaultFields : function(component, event, helper) {
        console.log('setDefaultFields');
        var accountId = component.get("v.recordId");
        var action = component.get("c.getAccountUBI");
        action.setParams({
            'accountId' : accountId
        });
        action.setCallback(this, function(actionResult) { 
            var state = actionResult.getState();
            if(state == 'SUCCESS') {
                var returnValue = actionResult.getReturnValue();
                returnValue = returnValue.replace(/\./g,'-');
                component.set('v.ubiNumber', returnValue);
            }
                       
        });
        $A.enqueueAction(action);
        
		
	},
    closeQuickAction : function(component, event, helper) {
        var dismissActionPanel = $A.get("e.force:closeQuickAction"); 
		dismissActionPanel.fire(); 
    },
        
})