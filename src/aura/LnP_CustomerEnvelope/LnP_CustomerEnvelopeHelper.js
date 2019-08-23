({
	createDynamicCompInsideContainer : function(container, componentName , atrributeMap) 
    {
        //debugger;
        $A.createComponent
        (
            componentName,
            atrributeMap ,
            function(dynamicComponentName, status, errorMessage)
            {
                //Add the new button to the body array
                if (status === "SUCCESS") 
                {
                    var body = container.get("v.body");
                    body.push(dynamicComponentName);
                    container.set("v.body", body);
                }
                else if (status === "INCOMPLETE") 
                {
                    console.error("No response from server or client is offline.")
                    // Show offline error
                }
                    else if (status === "ERROR") 
                    {
                        console.error("Error: " + errorMessage);
                        // Show error message
                    }
            }
        );           
    },
   
    getParameterByName: function(component, event, name) {
        name = name.replace(/[\[\]]/g, "\\$&");
        var url = window.location.href;
        var regex = new RegExp("[?&]" + name + "(=1\.([^&#]*)|&|#|$)");
        var results = regex.exec(url);
        if (!results) return null;
        if (!results[2]) return '';
        return decodeURIComponent(results[2].replace(/\+/g, " "));
    }

})