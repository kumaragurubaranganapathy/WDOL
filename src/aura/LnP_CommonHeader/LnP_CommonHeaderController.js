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
    toggleMenu:function(component,event,helper){
        helper.toggleMenu(component,event);
    },
    serviceMenuOpen:function(component,event,helper){
        helper.serviceMenuOpen(component,event);
    },
    closeServiceMenu: function(component,event,helper){
        helper.closeServiceMenu(component,event);
    },
    loginUser : function(component,event,helper){
        helper.loginUser(component,event);
    }
    
    
})