({
    doInit: function(component, event, helper) {
        var action = component.get('c.getLabel');
        var currYear = new Date().getFullYear();
        component.set("v.currentYear",currYear);
        action.setCallback(this,function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.customLblMap',response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        helper.getContactInfo(component,event);
    },
})