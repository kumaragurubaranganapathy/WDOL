({
    doInit : function(component, event, helper) {
        helper.setApplications(component, event, helper);
    },
    goToApplication : function(component, event, helper) {		                
        helper.goToApplicationHelper(component, event, helper);
    }
})