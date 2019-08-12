({
    doInit : function(component,event) {        
        var action = component.get('c.getContactUserInfo');  
        var currURL = document.URL;
        if(/Help-Topic/.test(currURL)){
            component.set("v.helpPage",true);
        }
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
        
    },
    
    checkIsCommunityUser : function(component,event) { 
        console.log('checkIsCommunityUser...........');
        var action = component.get('c.isValidCommunityUser');
        action.setCallback(this, function(result) {
            console.log('In Call back checkIsCommunityUser...........');
            var state = result.getState();
            if (state === "SUCCESS") {
                var response = result.getReturnValue();
                component.set("v.isValidCommunityUser",response);
            }
        });
        $A.enqueueAction(action);
        
    }
})