({
    checkForBrowser : function(component,event){
        var browserUsed = window.navigator.userAgent;
        var isIE = browserUsed.indexOf("MSIE ") > -1 || browserUsed.indexOf("Trident/") > -1;
        if(isIE){
            component.set("v.isBrowserIE", true);
        }
        else{
            component.set("v.isBrowserIE",false);
        }
        component.set("v.isScriptLoaded",true);
        
    },
    /*showNavigation : function(component, event, helper) {
        var pageTitle = window.location.href;
        if(pageTitle.includes('dashboard')){
            component.set("v.showSideNav", true);
        }	
    }, */
    setBackground : function(component, event){
        var pageTitle=window.location.href;
        if(pageTitle.includes('wizard')){
            component.set("v.pageTitle","wizard");
            
        }        
    }
})