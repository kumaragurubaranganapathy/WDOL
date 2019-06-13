({
    setApplications : function(component, event, helper) {
        var action = component.get("c.getApplications");
        action.setCallback(this, function(actionResult){
            var state = actionResult.getState();
            if (state === "SUCCESS"){
                console.log('result-->success');
                var result = actionResult.getReturnValue();
                component.set("v.applications",result);
            }else{
				console.log('error-->');
			}
        });
        $A.enqueueAction(action);
    },
    goToApplicationHelper : function(component, event, helper) {
        var applicationId = event.target.id;
        console.log('applicationId'+applicationId);
        sessionStorage.setItem("applicationId", applicationId);
        sessionStorage.setItem("licenseType", 'Licensed Architect');
        sessionStorage.setItem("applicationType", 'Examination');
        sessionStorage.setItem("board", 'Architects Board');
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "./apply-for-license"
        });
        urlEvent.fire();
    }
})