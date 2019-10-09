({
	init : function(component, event) {
		//this.update(component, event);
	},
    close:function(component, event) {
        component.set("v.alertClose",true);
     }, 
    handleAlertClose : function(component,event){
        var alertType = component.get("v.alertType");
        var alertClose = component.get("v.alertClose");
        var str=component.get("v.redirectUrl");
        var compRefresh=component.get("v.refresh");
        console.log('alertType::'+alertType);
        console.log('alertClose::'+alertClose);
        if(alertType === "success" && alertClose === true){
          /*  var compEvent = component.getEvent(compRefresh);
            compEvent.setParams({ "refreshFlag": "true" });
            compEvent.fire();                    
           /* var str ='/business';*/
            
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": str
            });
            urlEvent.fire(); 
        }
        else if(alertType === "error" && alertClose === true){          
            
             component.set("v.buttonDisable",false);
        }
    }
})