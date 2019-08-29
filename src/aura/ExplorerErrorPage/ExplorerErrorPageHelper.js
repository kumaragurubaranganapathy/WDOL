({
	browserTest : function(component, event, helper) {
        var action = component.get("c.fetchErrorLogs"); 
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                component.set("v.errorIDs", result);
            }
        });
        $A.enqueueAction(action);  
		/*var browserUsed = window.navigator.userAgent;
        var isIE = browserUsed.indexOf("MSIE ") > -1 || browserUsed.indexOf("Trident/") > -1; */
        
        var currURL = document.URL;
        var isIE = /IE-error/.test(currURL);
        var id = currURL.split('id=').pop();
        component.set("v.errorID",id);
       
     
        if(isIE){
            component.set("v.dispPage","true")
        }      
            

	}
})