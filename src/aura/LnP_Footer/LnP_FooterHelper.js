({
    getContactInfo : function(component,event) {
        var action = component.get('c.getContactUserInfo');        
        action.setCallback(this, function(actionResult) {
            var state = actionResult.getState();
            if (state === "SUCCESS") {
                var result = actionResult.getReturnValue();                    
                if(!(result[0] === "Guest"))
                    component.set("v.isLoggedIn",true);
                component.set("v.isPageLoaded",true);
                //component.set("v.userType", result[0]);
                //var nameArr = result[1].split(' ');
                //var nameInitial = nameArr[0].charAt(0) + nameArr[1].charAt(0);
                //component.set("v.userInitial", nameInitial);
            }
        });
        $A.enqueueAction(action);
        
    }
})