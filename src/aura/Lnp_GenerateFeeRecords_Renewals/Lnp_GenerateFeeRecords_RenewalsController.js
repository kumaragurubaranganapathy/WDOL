({
	doInit : function(component, event, helper) {
			
			component.set("v.OkMsg", true);
       		component.set("v.HideSpinner", true);
			var renewalId = component.get("v.recordId");
			var action = component.get("c.generateFeeRecords_Renewals");
			action.setParams({
				renewalId : renewalId
			});
			
			action.setCallback(this,
			function(response) {
				var state = response.getReturnValue();
                var Errormsg ='False';
                var statusErrorLabel = $A.get("$Label.c.Fee_Generation_Status_Error");
                if(statusErrorLabel == response.getReturnValue()){
                   component.set("v.ErrorMsg", true);
				   $A.get('e.force:refreshView').fire();
            	}else if(response.getState() === "SUCCESS") {
					component.set("v.smsg", true);
					$A.get('e.force:refreshView').fire();
				} else {
				   component.set("v.emsg", true);
				   $A.get('e.force:refreshView').fire();
				}
                component.set("v.HideSpinner", false);
			}
			);
			$A.enqueueAction(action);
			
	},
	cancelBtn : function(component, event, helper) { 
		// Close the action panel 
		var dismissActionPanel = $A.get("e.force:closeQuickAction"); 
		dismissActionPanel.fire(); 
	} 
})