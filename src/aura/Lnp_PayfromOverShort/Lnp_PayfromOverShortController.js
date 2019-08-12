({
	doInit : function(component, event, helper) {
			component.set("v.OkMsg", true);
        	
	},
	cancelBtn : function(component, event, helper) { 
		// Close the action panel 
		var dismissActionPanel = $A.get("e.force:closeQuickAction"); 
		dismissActionPanel.fire(); 
	},
    submitBtn:function(component, event, helper) {
        	
        	component.set("v.OkMsg", true);
        	component.set("v.HideSpinner", true);
       		var feeId = component.get("v.recordId");
        	
			var action = component.get("c.payFromOverShort");
			action.setParams({
				feeId : feeId
			});
			
			action.setCallback(this,
			function(response) {
				var state = response.getReturnValue();
                 var Errormsg ='Validation Error';
                
                if(Errormsg == response.getReturnValue()){
                    component.set("v.ErrorMsg", true);
                    $A.get('e.force:refreshView').fire();
                } 
                else{
                    if(response.getState() === "SUCCESS") {
                        component.set("v.smsg", true);
                        $A.get('e.force:refreshView').fire();
                    } else {
                       component.set("v.emsg", true);
                       $A.get('e.force:refreshView').fire();
                    }
                }
                component.set("v.HideSpinner", false);
			});
        	
			$A.enqueueAction(action);
    }
})