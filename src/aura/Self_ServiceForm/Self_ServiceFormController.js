({
	doInit: function(component, event, helper) { 
		helper.doInit(component, event, helper);
        helper.getContact(component, event, helper);
    },
    cancel: function(component, event, helper) { 
		helper.cancel(component, event, helper);
    },
    createcode : function(component, event, helper) { 
		helper.createcode(component, event, helper);
    },
    saveWebsite : function(component, event, helper) { 
		helper.saveWebsitehelper(component, event, helper);
    },
    printUpdate: function(component, event, helper) { 
		helper.printUpdatehelper(component, event, helper);
    },
    maskInput : function(component,event,helper){
        helper.maskInput(component,event);
    },
    validateFields : function(component,event,helper){
        helper.validateFields(component,event);
    }
})