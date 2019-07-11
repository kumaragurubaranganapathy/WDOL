({
	doInit : function(component, event, helper) {
        	component.set("v.HideSpinner", true);
			var recordId = component.get("v.recordId");
        	var action = component.get("c.CalculateSystemGeneratedAmount");
			action.setParams({
				recordId : recordId
			});
			action.setCallback(this,
				function(response) {
					if(response.getState() === "SUCCESS") {
                        component.set("v.smsg", true);
                        $A.get('e.force:refreshView').fire();
                    } else {
                        component.set("v.emsg", true);
                        $A.get('e.force:refreshView').fire();
                    }
					component.set("v.HideSpinner", false);
				});
				$A.enqueueAction(action);
		}
})