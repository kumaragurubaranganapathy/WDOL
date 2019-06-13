({
    doInit: function(component, event, helper) {
        var action = component.get('c.getLabel');
        action.setCallback(this,function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.customLblMap',response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
})