({
	 fetchData: function (cmp,event,helper) {
        var action = cmp.get("c.getAllAccounts");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                cmp.set('v.data',data);
            }
            // error handling when state is "INCOMPLETE" or "ERROR"
        });
        $A.enqueueAction(action);
    },
    
    saveAccountContact : function(component,accId){
        alert('inside saveAccount::');
        var action = cmp.get("c.createAccountContactObject");
        action.setParams({ aId : accId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
               alert('success');
            }
            // error handling when state is "INCOMPLETE" or "ERROR"
        });
        $A.enqueueAction(action);
    },
    
    handleCancel : function(component, event){
        component.find("accordion").set('v.activeSectionName', ''); 
    }
})