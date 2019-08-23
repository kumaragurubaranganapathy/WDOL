({
        
	/*showNavigation : function(component, event, helper) {
		var pageTitle = window.location.href;
        if(pageTitle.includes('dashboard')){
           component.set("v.showSideNav", true);
       }	
    }, */
    setBackground : function(component, event, helper){
        var pageTitle=window.location.href;
        if(pageTitle.includes('wizard')){
            component.set("v.pageTitle","wizard");
         
        }
    }
})