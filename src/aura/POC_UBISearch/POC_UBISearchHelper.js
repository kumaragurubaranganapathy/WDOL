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
        component.set("v.ubiNumber" , "");
        
		
	},
        
})